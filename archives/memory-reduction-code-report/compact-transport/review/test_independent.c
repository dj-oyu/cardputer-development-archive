#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "../private-build/transport/bounce.h"
static int fail_alloc, fail_retain;
static void *checked_calloc(size_t n,size_t b){return fail_alloc?NULL:calloc(n,b);}
static vis_status checked_binding(vis_binding *b,vis_scene *s,vis_generation g){return fail_retain?VIS_INVALID:vis_binding_set(b,s,g);}
#define calloc checked_calloc
#define vis_binding_set checked_binding
#include "../private-build/transport/bounce.c"
#undef calloc
#undef vis_binding_set
#include "reference_hit.inc"
static FoxDiskScene lighting(void){FoxDiskScene s;FoxDiskLightInput l[3]={0};for(int i=0;i<3;i++){l[i].shape=FOX_DISK_SHAPE_DISK;l[i].center[0]=i*2;l[i].center[2]=5;l[i].power=1;l[i].diameter=.2;}double world[3]={.25,.5,1};assert(fox_disk_scene_init(&s,l,world,1)==FOX_DISK_OK);return s;}
static vis_scene *geometry(size_t n,vis_generation g){double p[]={-100,-100,1,100,-100,1,0,100,1};uint32_t *idx=malloc(n*3*sizeof(*idx));for(size_t i=0;i<n*3;i++)idx[i]=i%3;vis_scene *s=NULL;assert(vis_scene_build(&s,p,3,idx,n,g,(vis_limits){2048,4095,524288})==VIS_OK);free(idx);return s;}
static bounce_triangle attr(unsigned i){bounce_triangle a={0};a.double_sided=i%2;for(int j=0;j<3;j++){a.v[j].front[0]=(int16_t)(i%137);a.v[j].front[2]=32767;a.v[j].back[1]=(int16_t)(i%153);a.v[j].back[2]=-32767;a.v[j].mask=(float)((int)(i%11)-5);a.v[j].a565=(uint16_t)(i*113);a.v[j].b565=(uint16_t)(i*271);}return a;}
static void check(size_t n,int unique){
 bounce_generation g={{1,1,1},1,0};FoxDiskScene l=lighting();vis_scene *v=geometry(n,g.visibility);bounce_triangle *a=calloc(n,sizeof(*a));
 for(size_t i=0;i<n;i++){a[i]=attr((unsigned)(unique?i:i%9));for(int j=0;j<3;j++)if(unique)a[i].v[j].mask=(float)(3*i+j);}
 if(!unique&&n>3){a[0]=a[1]=a[2]=attr(0);a[0].v[0].mask=0.0f;a[0].v[1].mask=-0.0f;a[2]=attr(999);}
 size_t bytes=bounce_scene_compact_required_bytes(a,n);assert(bytes);if(unique)assert(bytes==584+n*8+n*3*20);
 bounce_scene *legacy=NULL,*compact=NULL;assert(bounce_scene_build(&legacy,v,a,n,&l,1,g,262144)==BOUNCE_OK);
 assert(bounce_scene_build_ground_compact(&compact,v,a,n,&l,1,g,bytes-1,NULL)==BOUNCE_INVALID&&!compact);
 assert(bounce_scene_build_ground_compact(&compact,v,a,n,&l,1,g,bytes,NULL)==BOUNCE_OK);assert(compact->bytes==bytes&&legacy->bytes==584+n*64);
 for(size_t i=0;i<n;i++){assert(material_double_sided(compact,i)==a[i].double_sided);for(unsigned j=0;j<3;j++)assert(!memcmp(material_vertex(compact,i,j),&a[i].v[j],20));}
 assert(bounce_scene_overlaps(compact,(char*)compact+bytes-1,1));assert(!bounce_scene_overlaps(compact,(char*)compact+bytes,1));assert(bounce_scene_overlaps(compact,(char*)compact+580,4));
 memset(a,0xa5,n*sizeof(*a));vis_scene_release(v);
 size_t comparisons=0;for(size_t i=0;i<n;i++)for(int sign=-1;sign<=1;sign+=2)for(int side=-1;side<=1;side++)for(int bary=0;bary<4;bary++){
  legacy->orientation_sign=compact->orientation_sign=sign;vis_hit h={0};h.triangle_ordinal=(uint32_t)i;h.geometric_normal[2]=1;h.bary[0]=bary==0?1:.2;h.bary[1]=bary==1?.8:.3;h.bary[2]=1-h.bary[0]-h.bary[1];double in[3]={0,0,side},ns1[3]={0},ns2[3]={0},r1[3]={0},r2[3]={0};int x=7,y=7;bounce_counters c1={0},c2={0};
  bounce_status st=reference_hit_material(legacy,&h,in,ns1,r1,&x,&c1),st2=hit_material(compact,&h,in,ns2,r2,&y,&c2);assert(st==st2&&x==y&&!memcmp(ns1,ns2,sizeof ns1)&&!memcmp(r1,r2,sizeof r1)&&!memcmp(&c1,&c2,sizeof c1));comparisons++;
 }
 bounce_binding b={0};assert(bounce_binding_set(&b,compact,g)==BOUNCE_OK);size_t refs=compact->refs;compact->refs=SIZE_MAX;bounce_binding other={0};assert(bounce_binding_set(&other,compact,g)==BOUNCE_INVALID&&!other.scene);compact->refs=refs;bounce_scene_release(compact);assert(b.scene);bounce_binding_clear(&b);bounce_scene_release(legacy);free(a);printf("n=%zu unique=%d bytes=%zu hit comparisons=%zu PASS\n",n,unique,bytes,comparisons);
}
static void failures(void){bounce_generation g={{1,1,1},1,0},g2=g;g2.material++;FoxDiskScene l=lighting();vis_scene *v=geometry(2,g.visibility);bounce_triangle a[2]={attr(1),attr(2)};bounce_scene *s=NULL;assert(bounce_scene_build(&s,v,a,2,&l,1,g,262144)==BOUNCE_OK);bounce_scene *old=s;
 fail_alloc=1;assert(bounce_scene_build_ground_compact(&s,v,a,2,&l,1,g2,262144,NULL)==BOUNCE_ALLOC&&s==old);fail_alloc=0;fail_retain=1;assert(bounce_scene_build_ground_compact(&s,v,a,2,&l,1,g2,262144,NULL)==BOUNCE_VISIBILITY&&s==old);fail_retain=0;
 assert(bounce_scene_build_ground_compact(&s,v,a,2,&l,1,g,262144,NULL)==BOUNCE_GENERATION&&s==old);
 assert(bounce_scene_build_ground_compact(&s,v,a,2,&l,1,g2,262144,NULL)==BOUNCE_OK);assert(s->compact);g2.material++;assert(bounce_scene_build_ground(&s,v,a,2,&l,1,g2,262144,NULL)==BOUNCE_OK&&!s->compact);
 assert(!bounce_scene_compact_required_bytes(NULL,2));assert(!bounce_scene_compact_required_bytes(a,0));assert(!bounce_scene_compact_required_bytes(a,2049));assert(!bounce_scene_compact_required_bytes((void*)((char*)a+1),2));assert(!bounce_scene_compact_required_bytes((void*)(UINTPTR_MAX-3),2));
 bounce_triangle saved=a[0];for(int k=0;k<3;k++){a[0]=saved;a[0].padding[k]=1;assert(!bounce_scene_compact_required_bytes(a,2));}a[0]=saved;a[0].double_sided=2;assert(!bounce_scene_compact_required_bytes(a,2));
 for(int j=0;j<3;j++){for(int side=0;side<2;side++){for(int k=0;k<3;k++){a[0]=saved;(side?a[0].v[j].back:a[0].v[j].front)[k]=INT16_MIN;assert(!bounce_scene_compact_required_bytes(a,2));}a[0]=saved;memset(side?a[0].v[j].back:a[0].v[j].front,0,6);assert(!bounce_scene_compact_required_bytes(a,2));}for(int f=0;f<3;f++){a[0]=saved;a[0].v[j].mask=f==0?NAN:f==1?INFINITY:-INFINITY;assert(!bounce_scene_compact_required_bytes(a,2));}}
 bounce_scene_release(s);vis_scene_release(v);puts("failure/lifetime/validation PASS");}
int main(void){clock_t t=clock();check(31,0);check(2048,1);failures();printf("elapsed_cpu_seconds=%.6f\n",(double)(clock()-t)/CLOCKS_PER_SEC);return 0;}
