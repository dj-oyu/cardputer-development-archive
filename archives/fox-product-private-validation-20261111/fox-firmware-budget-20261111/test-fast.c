unsigned long budget_fragments,budget_passes,budget_triangles,budget_batches;
#include "composite.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
#include "../fox-transfer-20261111/audit-extracted/fox-private-target-source/fox-rig-repair-private-20261107/integrated/scene.inc"
static scene_frame f;static scene_workspace scene;static fox_composite_workspace comp;
static unsigned ids[3];static unsigned error_id=99999;static float opacity[3]={.5,.5,1};
static bool shader(void*u,const fox_fragment*v,float rgb[3],float*a){(void)u;if(v->triangle==error_id)return false;for(unsigned i=0;i<3;i++)if(v->triangle==ids[i]){rgb[0]=i==0;rgb[1]=i==1;rgb[2]=i==2;*a=opacity[i];return true;}assert(0);return false;}
static float enc(float x){return x<=.0031308f?12.92f*x:1.055f*powf(x,1/2.4f)-.055f;}
static uint16_t expected(float r,float g,float b){return (uint16_t)(((unsigned)lroundf(enc(r)*31)<<11)|((unsigned)lroundf(enc(g)*63)<<5)|(unsigned)lroundf(enc(b)*31));}
static void setup(void){
 memset(&f,0,sizeof f);f.valid=true;bool used[SCENE_VERTICES]={0};unsigned n=0;
 for(unsigned t=0;t<SCENE_TRIANGLES&&n<3;t++){const scene_triangle*tri=source_triangles+t;bool conflict=false;for(unsigned k=0;k<3;k++)if(used[tri->v[k]])conflict=true;if(conflict)continue;ids[n++]=t;for(unsigned k=0;k<3;k++)used[tri->v[k]]=true;}
 assert(n==3);
 for(unsigned i=0;i<3;i++){const scene_triangle*t=source_triangles+ids[i];for(unsigned k=0;k<3;k++){f.projected[t->v[k]][0]=k==1?4:0;f.projected[t->v[k]][1]=k==2?4:0;f.projected[t->v[k]][2]=3-i;}f.bins[0][ids[i]/64]|=UINT64_C(1)<<(ids[i]%64);}
}
static void aliases(void){
 static float local[SCENE_VERTICES][3];
 static unsigned char saved_comp[sizeof comp],saved_scene[sizeof scene],saved_frame[sizeof f],saved_local[sizeof local];
 uint16_t output[960],saved_output[960];memset(output,0x5a,sizeof output);
 memset(&comp,0xa5,sizeof comp);memset(&scene,0x5a,sizeof scene);
 memcpy(saved_comp,&comp,sizeof comp);memcpy(saved_scene,&scene,sizeof scene);memcpy(saved_frame,&f,sizeof f);memcpy(saved_local,local,sizeof local);memcpy(saved_output,output,sizeof output);
 /* Every pair among frame, scene, output, compositor, optional local. */
 for(unsigned a=0;a<5;a++)for(unsigned b=a+1;b<5;b++){
  void *p[5]={&f,&scene,output,&comp,local};p[b]=p[a];
  assert(!fox_scene_composite(p[0],p[2],0,4,30,p[1],p[4],shader,NULL,3,p[3]));
  assert(!memcmp(saved_comp,&comp,sizeof comp));assert(!memcmp(saved_scene,&scene,sizeof scene));assert(!memcmp(saved_frame,&f,sizeof f));assert(!memcmp(saved_local,local,sizeof local));assert(!memcmp(saved_output,output,sizeof output));
 }
 /* Concrete regression: interior scratch alias, not merely identical bases. */
 assert(!fox_scene_composite(&f,comp.scratch,0,4,30,&scene,NULL,shader,NULL,3,&comp));assert(!memcmp(saved_comp,&comp,sizeof comp));
 /* Partial overlap in both address directions is rejected before access. */
 assert(!fox_scene_composite(&f,(uint16_t*)((unsigned char*)&comp+sizeof comp-2),0,4,30,&scene,NULL,shader,NULL,3,&comp));assert(!memcmp(saved_comp,&comp,sizeof comp));
 for(unsigned a=0;a<5;a++){
  void *p[5]={&f,&scene,output,&comp,local};p[a]=(void*)(uintptr_t)(UINTPTR_MAX-1);
  assert(!fox_scene_composite(p[0],p[2],0,4,30,p[1],p[4],shader,NULL,3,p[3]));
  assert(!memcmp(saved_comp,&comp,sizeof comp));assert(!memcmp(saved_scene,&scene,sizeof scene));assert(!memcmp(saved_frame,&f,sizeof f));assert(!memcmp(saved_local,local,sizeof local));assert(!memcmp(saved_output,output,sizeof output));
 }
}
int main(void){setup();aliases();uint16_t out[960],saved[960];memset(out,0,sizeof out);
 assert(fox_scene_composite(&f,out,0,4,30,&scene,NULL,shader,NULL,3,&comp));assert(out[241]==expected(.5,.25,.25));assert(comp.max_observed_layers==3);assert(comp.passes==4);
 /* Actual fractional case, no alpha cutoff: .01 opacity stays visible. */
 opacity[0]=.01f;opacity[1]=0;memset(out,0,sizeof out);assert(fox_scene_composite(&f,out,0,4,10,&scene,NULL,shader,NULL,3,&comp));assert(out[241]==expected(.01f,0,.99f));opacity[0]=opacity[1]=.5f;
 /* Too many layers and shader failure late in peel both preserve caller bytes. */
 memset(out,0x55,sizeof out);memcpy(saved,out,sizeof out);assert(!fox_scene_composite(&f,out,0,4,20,&scene,NULL,shader,NULL,2,&comp));assert(!memcmp(out,saved,sizeof out));
 error_id=ids[2];assert(!fox_scene_composite(&f,out,0,4,30,&scene,NULL,shader,NULL,3,&comp));assert(!memcmp(out,saved,sizeof out));error_id=99999;
 assert(fox_scene_composite(&f,out,0,4,30,&scene,NULL,shader,NULL,3,&comp));assert(out[241]==expected(.5,.25,.25));
 /* Equal depth is deterministic source triangle index ordering, not blend loss. */
 for(unsigned i=0;i<3;i++)for(unsigned k=0;k<3;k++)f.projected[source_triangles[ids[i]].v[k]][2]=1;
 memset(out,0,sizeof out);assert(fox_scene_composite(&f,out,0,4,30,&scene,NULL,shader,NULL,3,&comp));assert(out[241]==expected(.5,.25,.25));
 /* Opaque nearest ends peeling; deeper surfaces need not consume a layer. */
 opacity[0]=1;assert(fox_scene_composite(&f,out,0,4,30,&scene,NULL,shader,NULL,1,&comp));assert(out[241]==0xf800);assert(comp.max_observed_layers==1);
 opacity[0]=0;opacity[1]=0;opacity[2]=0;memset(out,0xa5,sizeof out);memcpy(saved,out,sizeof out);assert(fox_scene_composite(&f,out,0,4,30,&scene,NULL,shader,NULL,1,&comp));assert(!memcmp(out,saved,sizeof out));
 /* All 65536 RGB565 backgrounds round-trip through linear light unchanged. */
 for(unsigned base=0;base<65536;base+=960){unsigned count=65536-base<960?65536-base:960;for(unsigned i=0;i<960;i++)out[i]=(uint16_t)(base+i);memcpy(saved,out,sizeof out);assert(fox_scene_composite(&f,out,0,4,30,&scene,NULL,shader,NULL,1,&comp));assert(!memcmp(out,saved,count*2));}
 opacity[0]=.5;opacity[1]=.5;opacity[2]=1;assert(fox_scene_composite_preflight(&f,&scene,NULL,shader,NULL,3,&comp));
 /* A bad shader in the final band is rejected during full-frame preflight. */
 memset(f.bins,0,sizeof f.bins);
 for(unsigned i=0;i<3;i++){for(unsigned k=0;k<3;k++)f.projected[source_triangles[ids[i]].v[k]][1]+=132;f.bins[33][ids[i]/64]|=UINT64_C(1)<<(ids[i]%64);}
 error_id=ids[2];assert(!fox_scene_composite_preflight(&f,&scene,NULL,shader,NULL,3,&comp));error_id=99999;assert(fox_scene_composite_preflight(&f,&scene,NULL,shader,NULL,3,&comp));
 printf("PASS composite: exact linear blend, fractional .01, layer overflow, late failure/recovery, equal depth identity, opaque termination, 65536 RGB565 roundtrips, full-frame preflight, disjoint/overflow alias guards; workspace=%zu bytes\n",sizeof comp);
}
