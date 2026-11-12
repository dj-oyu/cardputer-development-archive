#include "ui/kasane/ksn_mesh_depth.h"
#include <assert.h>
#include <float.h>
#include <limits.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

bool old_co_append(co_buffer *,const co_input *);
bool old_co_append_sided(co_buffer *,const co_sided_input *);
bool old_co_append_pixel(co_buffer *,const co_pixel_input *);
bool old_co_read(const uint8_t *,size_t,co_view *);
#define BYTES 8192
static unsigned checks;
static uint32_t rng=0x75834689;
static uint32_t random32(void){rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
static void w16(uint8_t *d,unsigned x){d[0]=(uint8_t)x;d[1]=(uint8_t)(x>>8);}
static void w32(uint8_t *d,uint32_t x){for(unsigned k=0;k<4;k++)d[k]=(uint8_t)(x>>(8*k));}
static void w64(uint8_t *d,uint64_t x){for(unsigned k=0;k<8;k++)d[k]=(uint8_t)(x>>(8*k));}
static size_t align4(size_t n){return (n+3)&~(size_t)3;}
static void vertices(co_pixel_vertex *v,unsigned n){
    memset(v,0,n*sizeof *v);
    for(unsigned j=0;j<n;j++){
        v[j].front=(co_vertex){(float)(j*3),(float)(j*2),j%2?1.25f:-.75f,j==0?-0.0f:(float)j/7,(uint16_t)(random32()),(uint16_t)(random32())};
        v[j].world[0]=j==0?-0.0:0x1.23456789abcdep-500*(j+1);
        v[j].world[1]=-0x1.abcdef0123456p+400/(j+1);v[j].world[2]=DBL_MIN*(j+1);
        v[j].normal_front[0]=(int16_t)(j%2?-32767:32767);
        v[j].normal_front[1]=(int16_t)((int)j-16);v[j].normal_front[2]=0;
        for(unsigned k=0;k<3;k++)v[j].normal_back[k]=(int16_t)(-(int32_t)v[j].normal_front[k]);
    }
}
static void same_fields(const co_pixel_vertex *a,const co_pixel_vertex *b){
    assert(!memcmp(&a->front.x,&b->front.x,4));assert(!memcmp(&a->front.y,&b->front.y,4));
    assert(!memcmp(&a->front.mask,&b->front.mask,4));assert(!memcmp(&a->front.depth,&b->front.depth,4));
    assert(a->front.color_a==b->front.color_a&&a->front.color_b==b->front.color_b);
    assert(!memcmp(a->world,b->world,24));assert(!memcmp(a->normal_front,b->normal_front,6));assert(!memcmp(a->normal_back,b->normal_back,6));
}
static void expand(const uint8_t *wire,size_t length,uint8_t *out,size_t *out_len){
    co_view view;assert(co_read(wire,length,&view));co_pixel_vertex v[32];uint16_t ix[192];uint8_t bits[8]={0};
    for(unsigned j=0;j<view.vertex_count;j++)assert(co_pixel_vertex_at(&view,j,v+j));
    for(unsigned t=0;t<view.triangle_count;t++){uint8_t a[3];bool back;assert(co_triangle_at(&view,t,a));assert(co_triangle_side(&view,t,&back));for(unsigned j=0;j<3;j++)ix[3*t+j]=a[j];if(back)bits[t/8]|=(uint8_t)(1u<<(t%8));}
    co_pixel_input in={v,ix,bits,view.node,view.vertex_count,view.triangle_count};co_buffer b={out,BYTES,0,0};assert(co_append_pixel(&b,&in));*out_len=b.size;
}
static unsigned check_record(co_pixel_input *in){
    uint8_t a[BYTES],b[BYTES],c[BYTES],full[BYTES];memset(a,0xa7,sizeof a);memset(b,0xa7,sizeof b);memset(c,0xa7,sizeof c);
    co_buffer old={a,sizeof a,0,0},off={b,sizeof b,0,0},on={c,sizeof c,0,0};
    assert(old_co_append_pixel(&old,in));assert(co_append_pixel(&off,in));assert(old.size==off.size&&old.packets==off.packets&&!memcmp(a,b,sizeof a));
    assert(co_append_pixel_normal_pair(&on,in));co_view ov,nv;assert(co_read(a,old.size,&ov));assert(co_read(c,on.size,&nv));assert(ov.mode==4);assert(nv.mode==4||nv.mode==5);
    assert(ov.vertex_count==nv.vertex_count&&ov.triangle_count==nv.triangle_count&&ov.node==nv.node);
    for(unsigned j=0;j<ov.vertex_count;j++){co_pixel_vertex x,y;assert(co_pixel_vertex_at(&ov,j,&x));assert(co_pixel_vertex_at(&nv,j,&y));same_fields(&x,&y);for(unsigned back=0;back<2;back++){co_vertex u,v;assert(co_vertex_at_side(&ov,j,back,&u));assert(co_vertex_at_side(&nv,j,back,&v));assert(!memcmp(&u.x,&v.x,16)&&u.color_a==v.color_a&&u.color_b==v.color_b);}}
    for(unsigned j=0;j<ov.triangle_count;j++){uint8_t x[3],y[3];bool u,v;assert(co_triangle_at(&ov,j,x)&&co_triangle_at(&nv,j,y)&&!memcmp(x,y,3));assert(co_triangle_side(&ov,j,&u)&&co_triangle_side(&nv,j,&v)&&u==v);}
    size_t restored=0;expand(c,on.size,full,&restored);assert(restored==old.size&&!memcmp(full,a,old.size));
    if(nv.mode==4)assert(old.size==on.size&&!memcmp(a,c,old.size));
    else assert(on.size==align4(12+50u*nv.vertex_count+3u*nv.triangle_count+(nv.triangle_count+7u)/8u));
    checks++;return nv.mode;
}
static void record_matrix(void){
    co_pixel_vertex v[32];uint16_t ix[192];uint8_t bits[8];
    for(unsigned n=3;n<=32;n++)for(unsigned t=1;t<=64;t++){
        vertices(v,n);memset(bits,0,8);
        for(unsigned j=0;j<t;j++){unsigned a=(j*7)%n;ix[3*j]=(uint16_t)a;ix[3*j+1]=(uint16_t)((a+1)%n);ix[3*j+2]=(uint16_t)((a+2)%n);if(j%3)bits[j/8]|=(uint8_t)(1u<<(j%8));}
        co_pixel_input in={v,ix,bits,(uint16_t)(n*67+t),(uint8_t)n,(uint8_t)t};assert(check_record(&in)==5);
        unsigned used=ix[t*3-1],k=t%3;v[used].normal_back[k]=(int16_t)(v[used].normal_back[k]==32767?32766:v[used].normal_back[k]+1);assert(check_record(&in)==4);
    }
    vertices(v,8);uint16_t sparse[]={6,2,0,2,6,4};uint8_t side[]={2};co_pixel_input in={v,sparse,side,0x1234,8,2};
    v[1].normal_back[2]=123;v[3].world[0]=NAN;v[5].normal_front[0]=INT16_MIN;assert(check_record(&in)==5); /* only used vertices count */
    for(unsigned k=0;k<3;k++){vertices(v,8);v[4].normal_back[k]=(int16_t)(v[4].normal_back[k]+1);assert(check_record(&in)==4);}
    /* All modes0/1/2 remain exact original bytes, including mode2 reduction. */
    co_vertex plain[32];uint16_t backs[64];uint16_t tri[]={4,0,2,2,0,4};uint8_t sides[1];
    for(unsigned n=5;n<=32;n++)for(unsigned variant=0;variant<5;variant++){
        vertices(v,n);for(unsigned j=0;j<n;j++){plain[j]=v[j].front;if(variant==1)plain[j].color_a=plain[j].color_b=0x3456;backs[2*j]=(uint16_t)(plain[j].color_a^(variant==4?0:0xabcd));backs[2*j+1]=(uint16_t)(plain[j].color_b^(variant==4?0:0x1234));}
        sides[0]=(uint8_t)(variant==2?0:variant==3?3:2);co_sided_input in2={{plain,tri,31,(uint8_t)n,2},backs,sides};
        uint8_t a[BYTES],b[BYTES];memset(a,0xa5,sizeof a);memset(b,0xa5,sizeof b);co_buffer x={a,sizeof a,0,0},y={b,sizeof b,0,0};
        assert(old_co_append(&x,&in2.front)&&co_append(&y,&in2.front)&&x.size==y.size&&!memcmp(a,b,sizeof a));co_view view;assert(co_read(a,x.size,&view));assert(view.mode==(variant==1?1:0));
        memset(a,0xa5,sizeof a);memset(b,0xa5,sizeof b);x.size=y.size=x.packets=y.packets=0;assert(old_co_append_sided(&x,&in2)&&co_append_sided(&y,&in2)&&x.size==y.size&&!memcmp(a,b,sizeof a));assert(co_read(a,x.size,&view));if(variant==0||variant==1)assert(view.mode==2);checks++;
    }
}
static void rejects(co_buffer *b,co_pixel_input *in){
    uint8_t prior[BYTES];assert(b->capacity<=sizeof prior);memcpy(prior,b->data,b->capacity);co_buffer old=*b;
    assert(!co_append_pixel_normal_pair(b,in));assert(!memcmp(b,&old,sizeof old));assert(!memcmp(b->data,prior,b->capacity));
    assert(!co_append_pixel(b,in));assert(!memcmp(b,&old,sizeof old));assert(!memcmp(b->data,prior,b->capacity));checks++;
}
static void input_failures(void){
    uint8_t data[BYTES];memset(data,0xa3,sizeof data);co_pixel_vertex v[32];vertices(v,32);uint16_t ix[192]={0,1,2};uint8_t bits[8]={0};co_pixel_input in={v,ix,bits,42,3,1};co_buffer b={data,sizeof data,0,0};
    for(unsigned field=0;field<7;field++){vertices(v,32);if(field<4){float *f[]={&v[0].front.x,&v[0].front.y,&v[0].front.mask,&v[0].front.depth};*f[field]=field%2?INFINITY:NAN;}else v[0].world[field-4]=field%2?INFINITY:NAN;rejects(&b,&in);}
    for(unsigned side=0;side<2;side++)for(unsigned k=0;k<3;k++){vertices(v,32);(side?v[0].normal_back:v[0].normal_front)[k]=INT16_MIN;assert(!old_co_append_pixel(&b,&in));rejects(&b,&in);}
    for(unsigned side=0;side<2;side++){vertices(v,32);memset(side?v[0].normal_back:v[0].normal_front,0,6);rejects(&b,&in);}
    vertices(v,32);v[0].front.x=4097;rejects(&b,&in);vertices(v,32);v[0].front.y=-4097;rejects(&b,&in);vertices(v,32);
    ix[2]=3;rejects(&b,&in);ix[2]=1;rejects(&b,&in);ix[2]=2;bits[0]=2;rejects(&b,&in);bits[0]=0;
    unsigned counts[]={0,1,2,33,255};for(unsigned j=0;j<5;j++){in.vertex_count=(uint8_t)counts[j];rejects(&b,&in);}in.vertex_count=3;unsigned tris[]={0,65,255};for(unsigned j=0;j<3;j++){in.triangle_count=(uint8_t)tris[j];rejects(&b,&in);}in.triangle_count=1;
    b.capacity=164;rejects(&b,&in);
    b.capacity=168;assert(co_append_pixel_normal_pair(&b,&in)&&b.size==168&&data[2]==5);
    b.size=0;b.packets=0;v[0].normal_back[2]=1;rejects(&b,&in);v[0].normal_back[2]=0;
    assert(!co_append_pixel(&b,&in)&&b.size==0&&b.packets==0);b.capacity=sizeof data;b.size=b.capacity+1;rejects(&b,&in);b.size=0;b.packets=CO_MAX_PACKETS;rejects(&b,&in);b.packets=0;
    /* A valid preceding record and all uncommitted bytes are kept on failure. */
    assert(co_append_pixel_normal_pair(&b,&in));in.node=13;v[1].world[2]=NAN;rejects(&b,&in);vertices(v,32);
    /* Destination overlap, even in its unused capacity, and source-source aliases. */
    const co_pixel_vertex *vv=in.vertices;in.vertices=(co_pixel_vertex *)(void *)(data+2048);rejects(&b,&in);in.vertices=vv;
    const uint16_t *ii=in.indices;in.indices=(uint16_t *)(void *)(data+2048);rejects(&b,&in);in.indices=ii;
    const uint8_t *bb=in.back_faces;in.back_faces=data+2048;rejects(&b,&in);in.back_faces=bb;
    in.indices=(const uint16_t *)(const void *)v;rejects(&b,&in);in.indices=ii;in.back_faces=(uint8_t *)v;rejects(&b,&in);in.back_faces=bb;in.back_faces=(uint8_t *)ix;rejects(&b,&in);in.back_faces=bb;
    /* Count-bounded multiplication; forged range sizes must reject before writes. */
    co_buffer overflow=b,save;overflow.capacity=SIZE_MAX;save=overflow;assert(!co_append_pixel_normal_pair(&overflow,&in)&&!memcmp(&overflow,&save,sizeof save));
    overflow=b;overflow.data=(uint8_t *)(uintptr_t)(UINTPTR_MAX-15);overflow.capacity=64;overflow.size=0;save=overflow;assert(!co_append_pixel_normal_pair(&overflow,&in)&&!memcmp(&overflow,&save,sizeof save));
    co_pixel_input broken=in;broken.vertices=(co_pixel_vertex *)(uintptr_t)(UINTPTR_MAX-15);rejects(&b,&broken);broken=in;broken.indices=(uint16_t *)(uintptr_t)(UINTPTR_MAX-1);rejects(&b,&broken);
    /* Input/control overlap with writable storage or each other rejects atomically. */
    union {max_align_t align;uint8_t bytes[BYTES];} box;memset(&box,0xa3,sizeof box);co_buffer *inside=(co_buffer *)(void *)box.bytes;*inside=(co_buffer){box.bytes,sizeof box.bytes,0,0};co_buffer saved=*inside;assert(!co_append_pixel_normal_pair(inside,&in)&&!memcmp(inside,&saved,sizeof saved));
    co_buffer target={box.bytes,sizeof box.bytes,0,0};co_pixel_input *inside_in=(co_pixel_input *)(void *)(box.bytes+256);*inside_in=in;uint8_t before[BYTES];memcpy(before,box.bytes,BYTES);assert(!co_append_pixel_normal_pair(&target,inside_in)&&!target.size&&!memcmp(before,box.bytes,BYTES));
    assert(!co_append_pixel_normal_pair(NULL,&in));assert(!co_append_pixel_normal_pair(&b,NULL));
}
static void read_reject(const uint8_t *data,size_t length){co_view out,prior;memset(&out,0xa4,sizeof out);memcpy(&prior,&out,sizeof out);assert(!co_read(data,length,&out));assert(!memcmp(&out,&prior,sizeof out));checks++;}
static void parser_failures(void){
    uint8_t wire[BYTES],bad[BYTES];co_pixel_vertex v[5];vertices(v,5);uint16_t ix[]={0,1,2,2,3,4,4,0,2};uint8_t bits[]={1};co_pixel_input in={v,ix,bits,99,5,2};co_buffer b={wire,sizeof wire,0,0};assert(co_append_pixel_normal_pair(&b,&in));assert(wire[2]==5);size_t raw=12+50*5+6+1;assert(b.size>raw);
    for(size_t n=0;n<b.size;n++)read_reject(wire,n);
    for(unsigned mode=0;mode<256;mode++)if(mode!=5){memcpy(bad,wire,b.size);bad[2]=(uint8_t)mode;read_reject(bad,b.size);}
    unsigned header[]={3,6,7,8,9};for(unsigned j=0;j<5;j++){memcpy(bad,wire,b.size);bad[header[j]]=1;read_reject(bad,b.size);}
    for(unsigned len=0;len<4;len++){memcpy(bad,wire,b.size);w16(bad+10,len==0?0:len==1?(unsigned)b.size-1:len==2?(unsigned)b.size+4:65535);read_reject(bad,b.size);}
    unsigned vc[]={0,2,33,255},tc[]={0,65,255};for(unsigned j=0;j<4;j++){memcpy(bad,wire,b.size);bad[0]=(uint8_t)vc[j];read_reject(bad,b.size);}for(unsigned j=0;j<3;j++){memcpy(bad,wire,b.size);bad[1]=(uint8_t)tc[j];read_reject(bad,b.size);}
    for(unsigned k=0;k<4;k++){memcpy(bad,wire,b.size);w32(bad+12+4*k,k%2?0xff800000:0x7fc00000);read_reject(bad,b.size);}
    for(unsigned k=0;k<3;k++){memcpy(bad,wire,b.size);w64(bad+12+20+8*k,UINT64_C(0x7ff8000000000000));read_reject(bad,b.size);memcpy(bad,wire,b.size);w16(bad+12+44+2*k,32768);read_reject(bad,b.size);}
    memcpy(bad,wire,b.size);memset(bad+12+44,0,6);read_reject(bad,b.size);
    memcpy(bad,wire,b.size);bad[12+50*5]=5;read_reject(bad,b.size);memcpy(bad,wire,b.size);bad[12+50*5]=1;read_reject(bad,b.size);
    memcpy(bad,wire,b.size);bad[raw-1]|=8;read_reject(bad,b.size);for(size_t j=raw;j<b.size;j++){memcpy(bad,wire,b.size);bad[j]=1;read_reject(bad,b.size);}
    read_reject(wire,SIZE_MAX);read_reject((uint8_t *)(uintptr_t)(UINTPTR_MAX-8),20);
    co_view parsed;assert(co_read(wire,b.size,&parsed));co_pixel_vertex output,save;memset(&output,0xa4,sizeof output);memcpy(&save,&output,sizeof save);
    assert(!co_pixel_vertex_at(&parsed,5,&output)&&!memcmp(&output,&save,sizeof save));co_view shortview=parsed;shortview.size=12+50*4+49;assert(!co_pixel_vertex_at(&shortview,4,&output)&&!memcmp(&output,&save,sizeof save));
    memcpy(bad,wire,b.size);co_view invalid=parsed;invalid.data=bad;w16(bad+12+44,32768);assert(!co_pixel_vertex_at(&invalid,0,&output)&&!memcmp(&output,&save,sizeof save));
    memcpy(bad,wire,b.size);assert(!co_pixel_vertex_at(&parsed,0,(co_pixel_vertex *)(void *)wire));assert(!co_read(wire,b.size,(co_view *)(void *)wire));assert(!memcmp(wire,bad,b.size));
    co_view legacy_view;assert(!old_co_read(wire,b.size,&legacy_view));
    /* Arbitrarily unaligned record start plus odd 50B stride, every field exact. */
    for(unsigned offset=0;offset<8;offset++){uint8_t *unaligned=malloc(b.size+offset);assert(unaligned);memcpy(unaligned+offset,wire,b.size);co_view view;assert(co_read(unaligned+offset,b.size,&view));for(unsigned j=0;j<5;j++){co_pixel_vertex got;assert(co_pixel_vertex_at(&view,j,&got));same_fields(&v[j],&got);}free(unaligned);}
    /* Additional bytes are next records, not length ambiguity. */
    memcpy(bad,wire,b.size);memcpy(bad+b.size,wire,b.size);assert(co_read(bad,2*b.size,&parsed)&&parsed.size==b.size);assert(co_read(bad+parsed.size,b.size,&parsed));
}
static FoxDiskScene scene(double power){FoxDiskLightInput a[3]={0};for(unsigned j=0;j<3;j++){a[j].shape=FOX_DISK_SHAPE_DISK;a[j].center[2]=4;a[j].diameter=1;a[j].power=power;for(unsigned k=0;k<3;k++)a[j].color[k]=1;}double world[]={.02,.03,.04};FoxDiskScene s;assert(fox_disk_scene_init(&s,a,world,0)==FOX_DISK_OK);return s;}
static void patch(ksn_proc_gouraud_patch *p,co_pixel_vertex *v,float depth,uint16_t color){memset(p,0,sizeof *p);vertices(v,3);p->header.vertices=3;p->header.triangles=1;p->indices[0]=0;p->indices[1]=1;p->indices[2]=2;float xy[][2]={{10,10},{16,10},{10,16}};for(unsigned j=0;j<3;j++){v[j].front=(co_vertex){xy[j][0],xy[j][1],j==1?1:-1,depth,color,(uint16_t)(color^0xffff)};v[j].world[0]=v[j].world[2]=0;v[j].world[1]=-38;v[j].normal_front[0]=v[j].normal_front[2]=0;v[j].normal_front[1]=-32767;for(unsigned k=0;k<3;k++)v[j].normal_back[k]=(int16_t)(-(int32_t)v[j].normal_front[k]);p->vertices[j]=(ksn_proc_gouraud_vertex){xy[j][0],xy[j][1],v[j].front.mask,0,0};}}
static void snapshot_tests(void){
    uint8_t storage[2][65536],saved[65536];ksn_mesh_pixel_snapshot s[2];FoxDiskScene lights=scene(1);ksn_proc_gouraud_patch p;co_pixel_vertex v[3];uint8_t bits[8]={0};
    uint16_t px[2][240*16];float depth[2][240*8];ksn_mesh_pixel_stats stats[2];
    for(unsigned reverse=0;reverse<2;reverse++){
        for(unsigned j=0;j<2;j++){memset(storage[j],0xab,65536);assert(ksn_mesh_pixel_begin(s+j,storage[j],65536,&lights,8000000));}
        for(unsigned record=0;record<3;record++){unsigned id=reverse?2-record:record;patch(&p,v,1,(uint16_t)(0xf800>>id));bits[0]=(uint8_t)(id==1);if(id==1)v[1].normal_back[0]=1; /* whole-record fallback */
            assert(ksn_mesh_pixel_append(s,&p,v,bits,(uint16_t)id));assert(ksn_mesh_pixel_append_normal_pair(s+1,&p,v,bits,(uint16_t)id));}
        assert(s[0].mesh.work==s[1].mesh.work&&s[0].mesh.packets.packets==3&&s[1].mesh.packets.packets==3);assert(!memcmp(storage[0],storage[1],416));
        /* Dispose/poison all borrowed patch, fields, bits and source scene. */
        memset(&p,0xa5,sizeof p);memset(v,0xa5,sizeof v);memset(bits,0xa5,sizeof bits);FoxDiskScene original=lights;memset(&lights,0xa5,sizeof lights);
        for(unsigned j=0;j<2;j++){memcpy(saved,storage[j],65536);memset(px[j],0,sizeof px[j]);stats[j]=(ksn_mesh_pixel_stats){0};assert(ksn_mesh_pixel_render(s+j,px[j],0,16,depth[j],8,stats+j));assert(stats[j].shade_updates&&!memcmp(saved,storage[j],65536));assert(!ksn_mesh_render(&s[j].mesh,px[j],0,16,depth[j],8));}
        assert(!memcmp(px[0],px[1],sizeof px[0])&&!memcmp(depth[0],depth[1],sizeof depth[0])&&!memcmp(stats,stats+1,sizeof stats[0]));lights=original;memset(bits,0,8);
        /* Exact record order, side choices and full mode4 serialization restore. */
        size_t off=0,on=0;while(off<s[0].mesh.packets.size){co_view a,b;assert(co_read(storage[0]+416+off,s[0].mesh.packets.size-off,&a));assert(co_read(storage[1]+416+on,s[1].mesh.packets.size-on,&b));uint8_t restored[BYTES];size_t count;expand(b.data,b.size,restored,&count);assert(count==a.size&&!memcmp(restored,a.data,count));off+=a.size;on+=b.size;}assert(on==s[1].mesh.packets.size);
    }
    /* Independent snapshots: rewriting snapshot1 cannot alter snapshot0. */
    memcpy(saved,storage[0],65536);FoxDiskScene dark=scene(.1);assert(ksn_mesh_pixel_begin(s+1,storage[1],65536,&dark,8000000));patch(&p,v,2,0xffff);assert(ksn_mesh_pixel_append_normal_pair(s+1,&p,v,bits,7));memset(px[1],0,sizeof px[1]);stats[1]=(ksn_mesh_pixel_stats){0};assert(ksn_mesh_pixel_render(s+1,px[1],0,16,depth[1],8,stats+1));assert(memcmp(px[0],px[1],sizeof px[0])&&!memcmp(saved,storage[0],65536));
    /* Bad append is fully atomic, including work, packet count, capacity and bytes. */
    ksn_mesh_pixel_snapshot before=s[1];memcpy(saved,storage[1],65536);v[1].world[0]=NAN;assert(!ksn_mesh_pixel_append_normal_pair(s+1,&p,v,bits,8)&&!memcmp(&before,s+1,sizeof before)&&!memcmp(saved,storage[1],65536));patch(&p,v,2,0xffff);s[1].mesh.work_limit=s[1].mesh.work;before=s[1];assert(!ksn_mesh_pixel_append_normal_pair(s+1,&p,v,bits,8)&&!memcmp(&before,s+1,sizeof before)&&!memcmp(saved,storage[1],65536));s[1].mesh.work_limit=8000000;
    before=s[1];assert(!ksn_mesh_pixel_append_normal_pair(s+1,&p,(co_pixel_vertex *)(void *)storage[1],bits,8)&&!memcmp(&before,s+1,sizeof before)&&!memcmp(saved,storage[1],65536));
    assert(!ksn_mesh_pixel_append_normal_pair(s+1,&p,v,(uint8_t *)v,8));
    /* Pixel and nonpixel mode boundaries remain explicit; failed stats rollback. */
    ksn_mesh_pixel_stats st={1,48},prior=st;co_view view;assert(co_read(storage[1]+416,s[1].mesh.packets.size,&view));storage[1][418]=3;assert(!ksn_mesh_pixel_render(s+1,px[1],0,16,depth[1],8,&st)&&!memcmp(&st,&prior,sizeof st));storage[1][418]=5;
    s[1].mesh.packets.packets++;assert(!ksn_mesh_pixel_render(s+1,px[1],0,16,depth[1],8,&st)&&!memcmp(&st,&prior,sizeof st));s[1].mesh.packets.packets--;
    assert(!ksn_mesh_pixel_render(s+1,(uint16_t *)(void *)storage[1],0,16,depth[1],8,&st));assert(!ksn_mesh_pixel_render(s+1,px[1],0,16,(float *)(void *)storage[1],8,&st));assert(!ksn_mesh_pixel_render(s+1,px[1],0,16,depth[1],8,(ksn_mesh_pixel_stats *)(void *)storage[1]));
    checks++;
}
int main(void){record_matrix();input_failures();parser_failures();snapshot_tests();printf("NORMAL_PAIR_PASS checks=%u mode5 exact roundtrip, mode4 fallback, OFF0/1/2/4 bytes, parser/input rejection, alignment, ownership, order, mixed rendering, atomicity\n",checks);return 0;}
