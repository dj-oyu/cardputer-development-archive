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

bool reference_composite(const scene_frame*,uint16_t*,unsigned,unsigned,unsigned,scene_workspace*,const float(*)[3],fox_surface_fn,void*,unsigned,fox_composite_workspace*);
unsigned long budget_fragments,budget_passes,budget_triangles,budget_batches;
static unsigned rng=1234567;
static unsigned next(void){rng=rng*1664525u+1013904223u;return rng;}
int main(void){
 static scene_workspace ref_scene;static fox_composite_workspace ref_comp;
 uint16_t a[960],b[960],saved[960];
 const float alpha[]={0,1,.01f,.5f,-1,NAN,INFINITY};
 for(unsigned trial=0;trial<3000;trial++){
  setup();for(unsigned i=0;i<3;i++){
   opacity[i]=alpha[next()%7];float z=(float)(next()%4);
   for(unsigned k=0;k<3;k++)f.projected[source_triangles[ids[i]].v[k]][2]=z;
  }
  error_id=(next()%5==0)?ids[next()%3]:99999;
  for(unsigned i=0;i<960;i++)saved[i]=a[i]=b[i]=(uint16_t)next();
  unsigned layers=1+next()%3,limit=10*(1+next()%3);
  bool x=reference_composite(&f,a,0,4,limit,&ref_scene,NULL,shader,NULL,layers,&ref_comp);
  bool y=fox_scene_composite(&f,b,0,4,limit,&scene,NULL,shader,NULL,layers,&comp);
  assert(x==y);assert(!memcmp(a,b,sizeof a));if(!x)assert(!memcmp(a,saved,sizeof a));
 }
 puts("PASS 3000 deterministic differential cases: random binary/fractional/invalid alpha, errors, depth/ties, backgrounds, batch/layer limits, identical status/pixels and atomic failure");
}
