/* Independent synthetic A/B tests. Only API calls, documented packet layout and
 * production ksn_procedural rendering; no original model assets or image data. */
#define _POSIX_C_SOURCE 200809L
#include "ayatsuri/ayatsuri_model.h"
#include "ui/kasane/ksn_mesh_depth.h"
#include <assert.h>
#include <float.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#ifndef CANDIDATE
#define CANDIDATE 0
#endif
static int owner, wrong_owner;
static FILE *binary,*logfile;
static unsigned check_count,record_count,render_count;
static int tracking;
static unsigned long allocations;
void *__real_malloc(size_t);void *__real_calloc(size_t,size_t);void *__real_realloc(void *,size_t);void __real_free(void *);
void *__wrap_malloc(size_t n){if(tracking)allocations++;return __real_malloc(n);}
void *__wrap_calloc(size_t n,size_t s){if(tracking)allocations++;return __real_calloc(n,s);}
void *__wrap_realloc(void *p,size_t n){if(tracking)allocations++;return __real_realloc(p,n);}
void __wrap_free(void *p){__real_free(p);}
#define CHECK(x) do{check_count++;if(!(x)){fprintf(stderr,"FAIL %s:%d %s\n",__FILE__,__LINE__,#x);exit(2);}}while(0)
#define STATUS(x,s) CHECK((x)==(s))
static void wr(const void *p,size_t n){if(binary)CHECK(fwrite(p,1,n,binary)==n);}
static void u32(uint32_t n){wr(&n,4);}
static uint64_t hash(const void *p,size_t n){const uint8_t *b=p;uint64_t h=1469598103934665603ULL;while(n--){h^=*b++;h*=1099511628211ULL;}return h;}
static ayatsuri_model_status evaluate(ayatsuri_model_instance *i,const float c[9],const float l[6]){tracking=1;ayatsuri_model_status s=ayatsuri_model_instance_evaluate(i,&owner,1,c,l);tracking=0;return s;}
static void append(ksn_proc_frame *f,unsigned type,int l,int t,int r,int b,unsigned cost,const void *p,size_t bytes){
    if(l>r||t>b)return;
    unsigned words=(unsigned)((bytes+sizeof(ksn_proc_segment)-1)/sizeof(ksn_proc_segment));
    CHECK(f->count+words+1<=KSN_PROC_SEGMENTS);CHECK(f->raster_steps+cost<=UINT16_MAX);
    f->segments[f->count++]=(ksn_proc_segment){(int16_t)(l+(int)type),(int16_t)t,(int16_t)r,(int16_t)b,0};
    memset(f->segments+f->count,0,words*sizeof(ksn_proc_segment));memcpy(f->segments+f->count,p,bytes);
    f->count+=(uint16_t)words;f->raster_steps+=(uint16_t)cost;f->ext=1;
}
static void append_mesh(ksn_proc_frame *f,const ksn_proc_gouraud_patch *p){
    int l,t,r,b;unsigned cost;CHECK(ksn_proc_gouraud_bounds(p,&l,&t,&r,&b,&cost));
    uint8_t packed[sizeof *p];memset(packed,0,sizeof packed);uint8_t *at=packed;
    memcpy(at,&p->header,8);at+=8;size_t n=p->header.vertices*sizeof p->vertices[0];memcpy(at,p->vertices,n);at+=n;
    n=p->header.triangles*3*sizeof p->indices[0];memcpy(at,p->indices,n);at+=n;
    n=p->header.holes*sizeof p->clips[0];memcpy(at,p->clips,n);at+=n;
    append(f,KSN_PROC_EXT_GOURAUD_PATCH,l,t,r,b,cost,packed,(size_t)(at-packed));
}
static void make_frame(ayatsuri_model_instance *i,ksn_proc_frame *f){
    memset(f,0,sizeof *f);uint32_t cursor=0;ayatsuri_model_packet packet;
    ayatsuri_model_status s;
    while((s=ayatsuri_model_instance_next(i,&owner,1,&cursor,&packet))==AYATSURI_MODEL_OK){
        if(packet.kind==1){
            ksn_proc_ellipsoid p={0};memcpy(p.screen,packet.storage+96,32);memcpy(p.normal,packet.storage+128,36);
            memcpy(p.material,packet.storage+164,32);memcpy(p.texture,packet.storage+196,36);
            memcpy(p.surface,packet.storage+232,10);memcpy(p.light,packet.lighting,36);
            int l,t,r,b;CHECK(ksn_proc_ellipsoid_bounds(&p,&l,&t,&r,&b));
            append(f,KSN_PROC_EXT_ELLIPSOID,l,t,r,b,(unsigned)(r-l+1)*(unsigned)(b-t+1),&p,sizeof p);
        }else if(packet.kind==2||packet.kind==3){
            ksn_proc_blend_ellipsoids p={0};ksn_proc_blend_region_mask mask;int l,t,r,b;
            p.header.count=packet.lobe_count;memcpy(p.header.light,packet.lighting,36);memcpy(p.header.surface,packet.storage+252,6);
            memcpy(p.header.material,packet.storage+264,44);memcpy(p.header.controls,packet.storage+308,8);
            memcpy(p.lobes,packet.storage+316+24*packet.lobe_count,84*packet.lobe_count);
            uint8_t packed[sizeof p+sizeof mask];size_t n=KSN_PROC_BLEND_BYTES(p.header.count);memcpy(packed,&p,n);
            if(packet.kind==3){memcpy(&mask,packet.storage+316+108*packet.lobe_count,sizeof mask);
                CHECK(ksn_proc_blend_region_bounds(&p,&mask,&l,&t,&r,&b));memcpy(packed+n,&mask,sizeof mask);n+=sizeof mask;
            }else CHECK(ksn_proc_blend_bounds(&p,&l,&t,&r,&b));
            append(f,packet.kind==3?KSN_PROC_EXT_BLEND_REGION:KSN_PROC_EXT_BLEND_ELLIPSOIDS,l,t,r,b,
                   (unsigned)(r-l+1)*(unsigned)(b-t+1)*p.header.count,packed,n);
        }else if(packet.kind==4){append_mesh(f,(const ksn_proc_gouraud_patch *)(packet.storage+84));}
        else if(packet.kind==5){
            ayatsuri_model_sided_mesh_view v;STATUS(ayatsuri_model_instance_sided_mesh_view(i,&owner,1,packet.node_id,&v),AYATSURI_MODEL_OK);
            const ksn_proc_gouraud_patch *source=v.patch;ksn_proc_gouraud_patch part;unsigned at=0;
            while(at<source->header.triangles){CHECK(ksn_mesh_sided_run(source,v.back_colors,v.back_faces,&at,&part));append_mesh(f,&part);}
        }else CHECK(0);
    }
    CHECK(s==AYATSURI_MODEL_DONE);f->ready=true;
}
static void pixels(const ksn_proc_frame *f,uint16_t *p){
    for(unsigned k=0;k<KSN_PROC_W*KSN_PROC_H;k++)p[k]=(uint16_t)(0x0841+(k%7));
    CHECK(ksn_proc_render_band(f,p,0,KSN_PROC_H));
}
static void record(const char *name,ayatsuri_model_instance *i,ayatsuri_model_status s){
    record_count++;u32((uint32_t)strlen(name));wr(name,strlen(name));u32(s);u32(i->mutation_epoch);u32(i->evaluated);
    wr(i->camera,sizeof i->camera);wr(i->light,sizeof i->light);wr(i->lighting,sizeof i->lighting);
    u32((uint32_t)i->arena_bytes);wr(i->arena,i->arena_bytes);
    if(s==AYATSURI_MODEL_OK&&i->evaluated){
        uint32_t cursor=0;ayatsuri_model_packet packet;ayatsuri_model_status next;
        while((next=ayatsuri_model_instance_next(i,&owner,1,&cursor,&packet))==AYATSURI_MODEL_OK){
            u32(packet.node_id);u32(packet.kind);u32(packet.lobe_count);u32(packet.bytes);wr(packet.storage,packet.bytes);wr(packet.lighting,36);
        }CHECK(next==AYATSURI_MODEL_DONE);u32(UINT32_MAX);
        ksn_proc_frame f;make_frame(i,&f);u32(f.count);wr(&f,sizeof f);
        uint16_t p[KSN_PROC_W*KSN_PROC_H];pixels(&f,p);wr(p,sizeof p);render_count++;
    }
    fprintf(logfile,"%s\t%d\t%u\t%u\t%u\t%u\t%u\n",name,s,i->stats.eval_calls,i->stats.geometry_updates,i->stats.projection_updates,i->stats.shade_updates,i->mutation_epoch);
}
static void run_eval(const char *name,ayatsuri_model_instance *i,float c[9],float l[6],int expect,int mode){
    ayatsuri_model_stats before=i->stats;ayatsuri_model_status s=evaluate(i,c,l);STATUS(s,expect);
    if(s==AYATSURI_MODEL_OK){
        unsigned nodes=i->model->node_count,draw=i->model->packet_count;
        unsigned geom=mode==0?0:mode==2&&CANDIDATE?0:nodes;
        unsigned proj=mode==0?0:mode==2&&CANDIDATE?0:draw;
        unsigned shade=mode==0?0:draw;
        CHECK(i->stats.geometry_updates-before.geometry_updates==geom);
        CHECK(i->stats.projection_updates-before.projection_updates==proj);
        CHECK(i->stats.shade_updates-before.shade_updates==shade);
    }
    record(name,i,s);
}
static void target(ayatsuri_model_instance *i,unsigned node,unsigned flags,float pose[8][9],uint32_t col[8],double op[8],int expect){
    uint8_t dirty[8]={0};dirty[node]=(uint8_t)flags;ayatsuri_model_targets t={dirty,&pose[0][0],col,op,8};
    tracking=1;ayatsuri_model_status s=ayatsuri_model_instance_targets(i,&owner,1,&t);tracking=0;STATUS(s,expect);
}
static double seconds(void){struct timespec t;CHECK(clock_gettime(CLOCK_MONOTONIC,&t)==0);return t.tv_sec+t.tv_nsec*1e-9;}
int main(int argc,char **argv){
    CHECK(argc>=4);FILE *input=fopen(argv[1],"rb");CHECK(input);CHECK(fseek(input,0,SEEK_END)==0);long n=ftell(input);CHECK(n>0);rewind(input);
    uint8_t *cold=malloc((size_t)n);CHECK(cold);CHECK(fread(cold,1,(size_t)n,input)==(size_t)n);fclose(input);
    ayatsuri_model model;tracking=1;ayatsuri_model_status opened=ayatsuri_model_open(cold,(size_t)n,&model);tracking=0;STATUS(opened,AYATSURI_MODEL_OK);
    size_t arena_bytes=ayatsuri_model_instance_bytes(&model);void *arena=calloc(1,arena_bytes);CHECK(arena);
    ayatsuri_model_instance i;tracking=1;
    ayatsuri_model_status init=ayatsuri_model_instance_init(&model,arena,arena_bytes,&owner,1,&i);
    tracking=0;STATUS(init,AYATSURI_MODEL_OK);
    float c[9]={0,0,10,0,0,0,10,120,67},l[6]={0,0,1,1,.8f,.6f};
    if(argc>=5&&!strcmp(argv[4],"bench")){
        STATUS(evaluate(&i,c,l),AYATSURI_MODEL_OK);const unsigned loops=50000;double t=seconds();
        for(unsigned k=0;k<loops;k++){l[3]=(k&1)?.7f:.9f;STATUS(evaluate(&i,c,l),AYATSURI_MODEL_OK);}double light=(seconds()-t)/loops;
        t=seconds();for(unsigned k=0;k<loops;k++){c[7]=(k&1)?120:120.25f;STATUS(evaluate(&i,c,l),AYATSURI_MODEL_OK);}double full=(seconds()-t)/loops;
        printf("{\"loops\":%u,\"light_us\":%.9g,\"full_us\":%.9g,\"arena_bytes\":%zu,\"instance_size\":%zu,\"model_size\":%zu,\"eval_allocations\":%lu}\n",loops,light*1e6,full*1e6,arena_bytes,sizeof i,sizeof model,allocations);return 0;
    }
    binary=fopen(argv[2],"wb");logfile=fopen(argv[3],"w");CHECK(binary&&logfile);
    fprintf(logfile,"stage\tstatus\tevals\tgeometry\tprojection\tshade\tepoch\n");
    float pose[8][9];uint32_t col[8];double op[8];for(unsigned j=0;j<8;j++){STATUS(ayatsuri_model_instance_read_pose(&i,&owner,1,j,pose[j]),AYATSURI_MODEL_OK);col[j]=0xd0a060;op[j]=1;}
    run_eval("initial",&i,c,l,AYATSURI_MODEL_OK,1);
    ksn_proc_frame owned;make_frame(&i,&owned);uint16_t saved_pixels[KSN_PROC_W*KSN_PROC_H];pixels(&owned,saved_pixels);uint64_t owned_hash=hash(&owned,sizeof owned),pixels_hash=hash(saved_pixels,sizeof saved_pixels);
    run_eval("unchanged",&i,c,l,AYATSURI_MODEL_OK,0);
    target(&i,0,AYATSURI_TARGET_POSITION|AYATSURI_TARGET_ROTATION|AYATSURI_TARGET_SCALE,pose,col,op,AYATSURI_MODEL_OK);
    run_eval("same_pose_targets",&i,c,l,AYATSURI_MODEL_OK,0);
    l[0]=.6f;l[2]=.8f;run_eval("light_direction",&i,c,l,AYATSURI_MODEL_OK,2);
    l[3]=.6f;l[4]=.4f;l[5]=.9f;run_eval("light_rgb",&i,c,l,AYATSURI_MODEL_OK,2);
    pose[0][0]=.25f;target(&i,0,AYATSURI_TARGET_POSITION,pose,col,op,AYATSURI_MODEL_OK);run_eval("parent_pose",&i,c,l,AYATSURI_MODEL_OK,1);
    pose[7][5]=.3f;target(&i,7,AYATSURI_TARGET_ROTATION,pose,col,op,AYATSURI_MODEL_OK);run_eval("leaf_pose",&i,c,l,AYATSURI_MODEL_OK,1);
    l[4]=.6f;run_eval("light_after_pose",&i,c,l,AYATSURI_MODEL_OK,2);
    c[0]=2;c[1]=1;run_eval("camera",&i,c,l,AYATSURI_MODEL_OK,1);
    l[5]=.6f;run_eval("light_after_camera",&i,c,l,AYATSURI_MODEL_OK,2);
    c[3]=-0.0f;l[3]=.8f;run_eval("camera_signed_zero_light",&i,c,l,AYATSURI_MODEL_OK,1);
    c[3]=0.0f;run_eval("camera_signed_zero_only",&i,c,l,AYATSURI_MODEL_OK,0);
    l[5]=.8f;run_eval("camera_signed_zero_deferred_light",&i,c,l,AYATSURI_MODEL_OK,1);
    uint8_t kind;STATUS(ayatsuri_model_instance_node_kind(&i,&owner,1,1,&kind),AYATSURI_MODEL_OK);bool mesh_only=kind==3;
    if(!mesh_only){
        target(&i,1,AYATSURI_TARGET_COLOR|AYATSURI_TARGET_OPACITY,pose,col,op,AYATSURI_MODEL_OK);run_eval("same_material_targets",&i,c,l,AYATSURI_MODEL_OK,0);
        col[1]=0x3060d0;op[1]=.75;target(&i,1,AYATSURI_TARGET_COLOR|AYATSURI_TARGET_OPACITY,pose,col,op,AYATSURI_MODEL_OK);run_eval("ellipse_color_opacity",&i,c,l,AYATSURI_MODEL_OK,1);
        col[3]=0x50d040;op[3]=.85;target(&i,3,AYATSURI_TARGET_COLOR|AYATSURI_TARGET_OPACITY,pose,col,op,AYATSURI_MODEL_OK);run_eval("blend_color_opacity",&i,c,l,AYATSURI_MODEL_OK,1);
    }
    target(&i,4,AYATSURI_TARGET_COLOR,pose,col,op,AYATSURI_MODEL_INVALID);record("reject_mesh_color_preserves",&i,AYATSURI_MODEL_OK);
    target(&i,2,AYATSURI_TARGET_HIDDEN,pose,col,op,AYATSURI_MODEL_OK);run_eval("hide_parent",&i,c,l,AYATSURI_MODEL_OK,1);
    l[4]=.3f;run_eval("light_hidden_parent",&i,c,l,AYATSURI_MODEL_OK,2);
    target(&i,2,AYATSURI_TARGET_VISIBLE,pose,col,op,AYATSURI_MODEL_OK);run_eval("show_parent",&i,c,l,AYATSURI_MODEL_OK,1);
    target(&i,6,AYATSURI_TARGET_VISIBLE,pose,col,op,AYATSURI_MODEL_OK);run_eval("show_hidden_leaf",&i,c,l,AYATSURI_MODEL_OK,1);
    target(&i,6,AYATSURI_TARGET_VISIBLE,pose,col,op,AYATSURI_MODEL_OK);run_eval("same_visibility",&i,c,l,AYATSURI_MODEL_OK,0);
    pose[2][6]=-pose[2][6];target(&i,2,AYATSURI_TARGET_SCALE,pose,col,op,AYATSURI_MODEL_OK);run_eval("reflect_parent",&i,c,l,AYATSURI_MODEL_OK,1);
    pose[5][6]=-pose[5][6];target(&i,5,AYATSURI_TARGET_SCALE,pose,col,op,AYATSURI_MODEL_OK);run_eval("reflect_sided",&i,c,l,AYATSURI_MODEL_OK,1);
    l[3]=.7f;run_eval("light_reflected",&i,c,l,AYATSURI_MODEL_OK,2);
    pose[2][6]=-pose[2][6];target(&i,2,AYATSURI_TARGET_SCALE,pose,col,op,AYATSURI_MODEL_OK);pose[5][6]=-pose[5][6];target(&i,5,AYATSURI_TARGET_SCALE,pose,col,op,AYATSURI_MODEL_OK);run_eval("restore_reflection",&i,c,l,AYATSURI_MODEL_OK,1);
    float screen_center=c[7];c[7]+=400;run_eval("offscreen_camera",&i,c,l,AYATSURI_MODEL_OK,1);l[4]=.7f;run_eval("light_offscreen",&i,c,l,AYATSURI_MODEL_OK,2);c[7]=screen_center;run_eval("restore_onscreen",&i,c,l,AYATSURI_MODEL_OK,1);
    float viewpoint[3]={c[0],c[1],c[2]};c[0]=0;c[1]=10;c[2]=0;run_eval("vertical_camera",&i,c,l,AYATSURI_MODEL_OK,1);l[3]=.65f;run_eval("light_vertical_camera",&i,c,l,AYATSURI_MODEL_OK,2);memcpy(c,viewpoint,12);run_eval("restore_viewpoint",&i,c,l,AYATSURI_MODEL_OK,1);
    float original_c[9];memcpy(original_c,c,36);c[6]=0;run_eval("invalid_camera_zoom",&i,c,l,AYATSURI_MODEL_INVALID,-1);memcpy(c,original_c,36);run_eval("recover_camera_zoom",&i,c,l,AYATSURI_MODEL_OK,1);
    c[0]=c[3];c[1]=c[4];c[2]=c[5];run_eval("invalid_camera_coincident",&i,c,l,AYATSURI_MODEL_INVALID,-1);memcpy(c,original_c,36);run_eval("recover_camera_coincident",&i,c,l,AYATSURI_MODEL_OK,1);
    STATUS(evaluate(&i,NULL,l),AYATSURI_MODEL_INVALID);record("null_camera",&i,AYATSURI_MODEL_INVALID);run_eval("recover_null_camera",&i,c,l,AYATSURI_MODEL_OK,1);
    STATUS(evaluate(&i,c,NULL),AYATSURI_MODEL_INVALID);record("null_light",&i,AYATSURI_MODEL_INVALID);run_eval("recover_null_light",&i,c,l,AYATSURI_MODEL_OK,1);
    float saved=l[3];l[3]=NAN;run_eval("invalid_light_nan",&i,c,l,AYATSURI_MODEL_INVALID,-1);l[3]=saved;run_eval("recover_nan",&i,c,l,AYATSURI_MODEL_OK,1);
    l[3]=1.1f;run_eval("invalid_light_rgb",&i,c,l,AYATSURI_MODEL_INVALID,-1);l[3]=saved;run_eval("recover_rgb",&i,c,l,AYATSURI_MODEL_OK,1);
    float keep[3]={l[0],l[1],l[2]};l[0]=l[1]=l[2]=0;run_eval("zero_light_direction",&i,c,l,AYATSURI_MODEL_RANGE,-1);memcpy(l,keep,12);run_eval("recover_zero_light",&i,c,l,AYATSURI_MODEL_OK,1);
    float zoom=c[6];c[6]=FLT_MAX;run_eval("projection_overflow",&i,c,l,AYATSURI_MODEL_RANGE,-1);c[6]=zoom;run_eval("recover_projection",&i,c,l,AYATSURI_MODEL_OK,1);
    float pos=pose[0][0];pose[0][0]=FLT_MAX;target(&i,0,AYATSURI_TARGET_POSITION,pose,col,op,AYATSURI_MODEL_OK);run_eval("target_overflow",&i,c,l,AYATSURI_MODEL_RANGE,-1);
    pose[0][0]=pos;target(&i,0,AYATSURI_TARGET_POSITION,pose,col,op,AYATSURI_MODEL_OK);run_eval("recover_target",&i,c,l,AYATSURI_MODEL_OK,1);
    float px=pose[7][0];pose[7][0]=NAN;target(&i,7,AYATSURI_TARGET_POSITION,pose,col,op,AYATSURI_MODEL_INVALID);pose[7][0]=px;record("rejected_target_preserves",&i,AYATSURI_MODEL_OK);
    STATUS(ayatsuri_model_instance_evaluate(&i,&wrong_owner,1,c,l),AYATSURI_MODEL_STATE);STATUS(ayatsuri_model_instance_evaluate(&i,&owner,2,c,l),AYATSURI_MODEL_STATE);
    i.busy=true;STATUS(ayatsuri_model_instance_evaluate(&i,&owner,1,c,l),AYATSURI_MODEL_BUSY);i.busy=false;record("owner_generation_busy_preserves",&i,AYATSURI_MODEL_OK);
    /* Force a fresh full path with a real no-op pose round-trip and compare the
     * resulting complete state to a preceding light-only result across builds. */
    l[3]=.55f;run_eval("light_before_forced_full",&i,c,l,AYATSURI_MODEL_OK,2);
    uint8_t *copy=malloc(arena_bytes);CHECK(copy);memcpy(copy,arena,arena_bytes);float lighting[9];memcpy(lighting,i.lighting,36);
    pose[0][0]+=.125f;target(&i,0,AYATSURI_TARGET_POSITION,pose,col,op,AYATSURI_MODEL_OK);pose[0][0]-=.125f;target(&i,0,AYATSURI_TARGET_POSITION,pose,col,op,AYATSURI_MODEL_OK);
    run_eval("forced_full",&i,c,l,AYATSURI_MODEL_OK,1);CHECK(!memcmp(copy,arena,arena_bytes));CHECK(!memcmp(lighting,i.lighting,36));free(copy);
    /* Make the nine-float lighting array exactly equal to cached camera.
     * Its input span is disjoint from the camera/light memcpy destinations;
     * using i.camera itself would inherit a self-overlapping memcpy. */
    float alias_c[9]={1,1,1,.577350269f,.577350269f,.577350269f,1,0,0},
          alias_l[6]={1,1,1,1,0,0};
    run_eval("camera_alias_guard_setup",&i,alias_c,alias_l,AYATSURI_MODEL_OK,1);
    CHECK(!memcmp(i.camera,i.lighting,36));
    float alias_changed_l[6]={.6f,0,.8f,.4f,.5f,.6f};
    run_eval("camera_alias_guard_equal_cache",&i,i.lighting,alias_changed_l,AYATSURI_MODEL_OK,1);
    run_eval("camera_alias_guard_recover",&i,c,l,AYATSURI_MODEL_OK,1);
    /* Legal overlapping public input arrays: retain the baseline full-path semantics. */
    l[4]=.25f;run_eval("aliased_camera_input",&i,i.lighting,l,AYATSURI_MODEL_OK,1);run_eval("recover_alias_camera",&i,c,l,AYATSURI_MODEL_OK,1);
    run_eval("aliased_light_input",&i,c,i.lighting,AYATSURI_MODEL_OK,1);run_eval("recover_alias_light",&i,c,l,AYATSURI_MODEL_OK,2);
    for(unsigned k=0;k<24;k++){double a=(double)k*.3;l[0]=(float)sin(a);l[1]=.0f;l[2]=(float)cos(a);l[3]=.25f+(float)(k%5)*.1f;char label[40];snprintf(label,sizeof label,"light_sweep_%02u",k);run_eval(label,&i,c,l,AYATSURI_MODEL_OK,2);}
    i.stats.eval_calls=i.stats.geometry_updates=i.stats.projection_updates=i.stats.shade_updates=UINT32_MAX;
    l[3]=.99f;STATUS(evaluate(&i,c,l),AYATSURI_MODEL_OK);CHECK(i.stats.eval_calls==UINT32_MAX&&i.stats.geometry_updates==UINT32_MAX&&i.stats.projection_updates==UINT32_MAX&&i.stats.shade_updates==UINT32_MAX);record("counter_saturation",&i,AYATSURI_MODEL_OK);
    CHECK(hash(&owned,sizeof owned)==owned_hash);uint16_t after[KSN_PROC_W*KSN_PROC_H];pixels(&owned,after);CHECK(hash(after,sizeof after)==pixels_hash);CHECK(!memcmp(saved_pixels,after,sizeof after));
    STATUS(ayatsuri_model_instance_dispose(&i,&wrong_owner,1),AYATSURI_MODEL_STATE);STATUS(ayatsuri_model_instance_dispose(&i,&owner,1),AYATSURI_MODEL_OK);
    STATUS(evaluate(&i,c,l),AYATSURI_MODEL_STATE);STATUS(ayatsuri_model_instance_dispose(&i,&owner,1),AYATSURI_MODEL_OK);
    CHECK(hash(&owned,sizeof owned)==owned_hash);pixels(&owned,after);CHECK(!memcmp(saved_pixels,after,sizeof after));
    CHECK(allocations==0);fclose(binary);fclose(logfile);
    printf("{\"checks\":%u,\"records\":%u,\"raster_frames\":%u,\"arena_bytes\":%zu,\"instance_size\":%zu,\"model_size\":%zu,\"api_allocations\":%lu}\n",check_count,record_count,render_count,arena_bytes,sizeof i,sizeof model,allocations);
    free(arena);free(cold);return 0;
}
