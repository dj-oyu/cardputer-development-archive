/* Minimal semantic counterexample, not a production AA implementation.
 * Exact quarter-translation is a fixture-only way to exercise the unchanged
 * integer-center renderer at the chosen true sample (.25,.25). */
#include "ui/kasane/ksn_mesh_depth.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static FoxDiskScene scene(void){
 FoxDiskLightInput l[3]={0};for(unsigned j=0;j<3;j++){
  l[j].shape=FOX_DISK_SHAPE_DISK;l[j].center[0]=j*2;l[j].center[2]=10;
  l[j].color[0]=l[j].color[1]=l[j].color[2]=1;l[j].power=1;l[j].diameter=1;
 }
 double world[3]={1,1,1};FoxDiskScene s;assert(fox_disk_scene_init(&s,l,world,.1)==FOX_DISK_OK);return s;
}
static void append(ksn_mesh_pixel_snapshot *s,float offset,float depth,int badnormal){
 co_pixel_vertex *v=calloc(3,sizeof *v);uint16_t *ix=malloc(6);uint8_t *bits=calloc(8,1);assert(v&&ix&&bits);
 const float xy[3][2]={{10,10},{14,10},{10,14}};
 for(unsigned j=0;j<3;j++){
  v[j].front=(co_vertex){xy[j][0]-offset,xy[j][1]-offset,1,depth,65535,65535};
  v[j].world[0]=xy[j][0];v[j].world[1]=xy[j][1];v[j].world[2]=depth;
  v[j].normal_front[0]=badnormal?(j?-28672:4096):32767;
  v[j].normal_back[0]=-v[j].normal_front[0];ix[j]=j;
 }
 co_pixel_input p={v,ix,bits,(uint16_t)depth,3,1};assert(co_append_pixel_normal_pair(&s->mesh.packets,&p));
 /* Actual source lifetime boundary, not just a claim. */
 memset(v,0xa5,3*sizeof *v);memset(ix,0xa5,6);memset(bits,0xa5,8);free(v);free(ix);free(bits);
}
static int render(float offset,int badnormal,int order,int foregroundonly,uint64_t *updates){
 uint8_t *owned=malloc(65536);ksn_mesh_pixel_snapshot s;FoxDiskScene lights=scene();
 assert(ksn_mesh_pixel_begin(&s,owned,65536,&lights,8000000));
 if(foregroundonly)append(&s,offset,2,0);
 else if(order){append(&s,offset,2,0);append(&s,offset,1,badnormal);}
 else{append(&s,offset,1,badnormal);append(&s,offset,2,0);}
 s.mesh.work=10000;
 uint16_t rgb[240]={0};float depth[240];ksn_mesh_pixel_stats stats={0};
 int ok=ksn_mesh_pixel_render(&s,rgb,10,1,depth,1,&stats);*updates=stats.shade_updates;
 /* Both surfaces cover (10.25,10.25), depth 2 strictly wins; therefore the
  * foreground-only arm is exactly the shader work a final-only resolver sees. */
 if(ok)assert(depth[10]==2);free(owned);return ok;
}
static bool controlled(void *p,const FoxDiskScene*s,const double w[3],const double n[3],const double rho[3],double rgb[3]){
 (void)s;(void)n;(void)rho;unsigned *calls=p;(*calls)++;if(w[1]>-.04)return false;rgb[0]=rgb[1]=rgb[2]=.25;return true;
}
static int callbackcase(int foregroundonly,unsigned *calls){
 uint8_t *owned=malloc(65536);ksn_mesh_pixel_snapshot s;FoxDiskScene lights=scene();assert(ksn_mesh_pixel_begin(&s,owned,65536,&lights,8000000));
 if(!foregroundonly)append(&s,.25,1,0);append(&s,.25,2,0);s.mesh.work=10000;
 uint16_t rgb[240]={0};float depth[240];ksn_mesh_pixel_stats stats={0};int ok=ksn_mesh_pixel_render_shaded(&s,rgb,10,1,depth,1,&stats,controlled,calls);free(owned);return ok;
}
int main(void){
 uint64_t center,old,newer,rev;int c=render(0,1,0,0,&center),o=render(.25,1,0,0,&old),f=render(.25,1,0,1,&newer),r=render(.25,1,1,0,&rev);
 unsigned oc=0,fc=0;int co=callbackcase(0,&oc),cf=callbackcase(1,&fc);
 assert(c&&!o&&f&&r&&!co&&cf);
 printf("{\"fixtureExecuted\":true,\"centerOldSuccess\":%s,\"sampleOldSuccess\":%s,\"sampleFinalOnlySuccess\":%s,\"sampleReverseOldSuccess\":%s,\"centerShadeUpdates\":%llu,\"sampleFinalOnlyShadeUpdates\":%llu,\"oldCallbackSuccess\":%s,\"finalOnlyCallbackSuccess\":%s,\"oldCallbackCalls\":%u,\"finalOnlyCallbackCalls\":%u,\"oldFailureParity\":\"FAIL\",\"reason\":\"Hidden intermediate zero normal or shader failure disappears in final-visible-only semantics\",\"sourceArraysPoisonedAndFreedBeforeRender\":true}\n",c?"true":"false",o?"true":"false",f?"true":"false",r?"true":"false",(unsigned long long)center,(unsigned long long)newer,co?"true":"false",cf?"true":"false",oc,fc);
}
