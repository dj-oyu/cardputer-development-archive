#include "fox_idle.h"
#include "ui/kasane/ksn_mesh_depth.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static struct {size_t bytes; uint32_t work; unsigned records;} peak;
static void render(ayatsuri_model_instance *i,const void *owner,const float camera[9],
                   uint16_t frame[32400]){
    const float light[6]={-.3f,-.45f,1.f,1.f,1.f,1.f};
    assert(ayatsuri_model_instance_evaluate(i,owner,1,camera,light)==AYATSURI_MODEL_OK);
    static uint8_t storage[65536];
    ksn_mesh_snapshot s={.packets={storage,sizeof storage,0,0},.work_limit=8000000,.enabled=true};
    ayatsuri_model_packet p;uint32_t cur=0;ayatsuri_model_status value;
    while((value=ayatsuri_model_instance_next(i,owner,1,&cur,&p))==AYATSURI_MODEL_OK){
        if(p.kind==5){
            ayatsuri_model_sided_mesh_view v;
            assert(ayatsuri_model_instance_sided_mesh_view(i,owner,1,p.node_id,&v)==AYATSURI_MODEL_OK);
            assert(ksn_mesh_append_sided(&s,v.patch,v.depth,v.back_colors,v.back_faces,v.node_id));
        }else{
            ayatsuri_model_mesh_view v;
            assert(p.kind==4&&ayatsuri_model_instance_mesh_view(i,owner,1,p.node_id,&v)==AYATSURI_MODEL_OK);
            assert(ksn_mesh_append(&s,v.patch,v.depth,v.node_id));
        }
    }
    assert(value==AYATSURI_MODEL_DONE&&s.packets.packets);
    if(s.packets.size>peak.bytes)peak.bytes=s.packets.size;
    if(s.work>peak.work)peak.work=s.work;
    if(s.packets.packets>peak.records)peak.records=s.packets.packets;
    memset(frame,0,32400*sizeof *frame);
    float scratch[240*8];
    assert(ksn_mesh_render(&s,frame,0,135,scratch,8));
    static uint16_t one[32400];
    memset(one,0,sizeof one);
    assert(ksn_mesh_render(&s,one,0,135,scratch,1));
    assert(!memcmp(one,frame,sizeof one));
}
int main(int argc,char **argv){
    setvbuf(stdout,NULL,_IONBF,0);
    assert(argc==4); int anchor=atoi(argv[2]);assert(anchor==35||anchor==-35);
    FILE *f=fopen(argv[1],"rb");assert(f&&!fseek(f,0,SEEK_END));
    long size=ftell(f);assert(size==122024);rewind(f);
    void *bytes=malloc((size_t)size);assert(bytes&&fread(bytes,1,(size_t)size,f)==(size_t)size);fclose(f);
    ayatsuri_model model;assert(ayatsuri_model_open(bytes,(size_t)size,&model)==AYATSURI_MODEL_OK);
    size_t arena_size=ayatsuri_model_instance_bytes(&model);void *arena=malloc(arena_size);unsigned owner=1;
    ayatsuri_model_instance i; assert(arena&&ayatsuri_model_instance_init(&model,arena,arena_size,&owner,1,&i)==AYATSURI_MODEL_OK);
    const float yaw=anchor*0.01745329252f,elev=13.57f*0.01745329252f;
    float camera[9]={400*sinf(yaw)*cosf(elev),-1.0f-400*sinf(elev),400*cosf(yaw)*cosf(elev),0,-1,0,32,120,77};
    static fox_idle idle;
    assert(fox_idle_bind(&idle,&i,&owner,1)==AYATSURI_MODEL_OK);
    assert(fox_idle_mark(&idle,&i,&owner,1,-1)==AYATSURI_MODEL_OK);
    assert(fox_idle_apply(&idle,&i,&owner,2,0,anchor)!=AYATSURI_MODEL_OK);
    assert(fox_idle_apply(&idle,&i,&idle,1,0,anchor)!=AYATSURI_MODEL_OK);
    assert(fox_idle_apply(&idle,&i,&owner,1,0,42)!=AYATSURI_MODEL_OK);
    static uint16_t unmodified[32400], frames[12][32400], repeated[32400];
    render(&i,&owner,camera,unmodified);
    const uint32_t stamps[]={0,1500,4000,7200,7500,7850,8050,8500,9000,9350,11999,12000};
    for(unsigned j=0;j<12;++j){
        const uint32_t ms=stamps[j];
        assert(fox_idle_apply(&idle,&i,&owner,1,ms,anchor)==AYATSURI_MODEL_OK);
        render(&i,&owner,camera,frames[j]);
        unsigned delta=0,coverage=0;
        for(unsigned p=0;p<32400;++p){delta+=unmodified[p]!=frames[j][p];coverage+=frames[j][p]!=0;}
        assert(coverage>100);
        for(unsigned x=0;x<240;++x)assert(!frames[j][x]&&!frames[j][134u*240+x]);
        for(unsigned y=0;y<135;++y)assert(!frames[j][y*240]&&!frames[j][y*240+239]);
        fox_idle_values v=fox_idle_sample(ms,anchor);
        printf("%u %u %u %.7f %.7f\n",ms,coverage,delta,v.breath,v.yaw_rad);
        char path[1024];assert(snprintf(path,sizeof path,"%s/%u.rgb565",argv[3],ms)>0);
        f=fopen(path,"wb");assert(f&&fwrite(frames[j],2,32400,f)==32400&&!fclose(f));
    }
    assert(!memcmp(unmodified,frames[0],sizeof unmodified));
    assert(!memcmp(unmodified,frames[2],sizeof unmodified));
    assert(!memcmp(unmodified,frames[11],sizeof unmodified));
    assert(memcmp(unmodified,frames[1],sizeof unmodified));
    assert(memcmp(frames[4],frames[5],sizeof unmodified));
    assert(memcmp(frames[5],frames[9],sizeof unmodified));
    for(unsigned j=12;j-->0;){
        assert(fox_idle_apply(&idle,&i,&owner,1,stamps[j],anchor)==AYATSURI_MODEL_OK);
        render(&i,&owner,camera,repeated);assert(!memcmp(frames[j],repeated,sizeof repeated));
    }
    unsigned all_mark_pixels=0;
    for(unsigned m=0;m<FOX_MARKS;++m){
        const uint16_t id=idle.ids[FOX_HEAD_GROUPS+m];
        assert(fox_idle_mark(&idle,&i,&owner,1,(int)m)==AYATSURI_MODEL_OK);
        float rest[9], turned[9];
        for(unsigned j=0;j<=5;j+=5){
            assert(fox_idle_apply(&idle,&i,&owner,1,stamps[j],anchor)==AYATSURI_MODEL_OK);
            render(&i,&owner,camera,repeated);
            unsigned delta=0;
            for(unsigned p=0;p<32400;++p)delta+=frames[j][p]!=repeated[p];
            all_mark_pixels+=delta;
            assert(delta>0);
            assert(ayatsuri_model_instance_read_pose(&i,&owner,1,id,j?turned:rest)==AYATSURI_MODEL_OK);
            printf("mark %u at %u: %u pixels\n",m,stamps[j],delta);
        }
        assert(memcmp(rest,turned,sizeof rest));
        assert(fox_idle_apply(&idle,&i,&owner,1,12000,anchor)==AYATSURI_MODEL_OK);
        assert(ayatsuri_model_instance_read_pose(&i,&owner,1,id,turned)==AYATSURI_MODEL_OK);
        assert(!memcmp(rest,turned,sizeof rest));
        assert(fox_idle_mark(&idle,&i,&owner,1,-1)==AYATSURI_MODEL_OK);
    }
    printf("combined visible mark delta=%u\n",all_mark_pixels);
    printf("peak records=%u snapshot_bytes=%zu work=%u\n",peak.records,peak.bytes,peak.work);
    assert(ayatsuri_model_instance_dispose(&i,&owner,1)==AYATSURI_MODEL_OK);
    fprintf(stderr,"PASS %d native depth, 12 forward/reverse, closure exact; arena bytes %zu; adapter bytes %zu\n",anchor,arena_size,sizeof idle);
    free(arena);free(bytes);
}
