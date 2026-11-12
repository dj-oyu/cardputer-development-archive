#include "bounce.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
static vis_budget budget(void){vis_budget b={{20000000,800000000,300000000},{0,0,0}};return b;}
static FoxDiskScene light_scene(void){FoxDiskScene s;FoxDiskLightInput l[3]={0};for(int i=0;i<3;i++){l[i].shape=FOX_DISK_SHAPE_DISK;l[i].center[0]=i*2;l[i].center[2]=5;l[i].power=1;l[i].diameter=.2;}double world[3]={.25,.5,1};assert(fox_disk_scene_init(&s,l,world,1)==FOX_DISK_OK);return s;}
static bounce_triangle attr(unsigned color){bounce_triangle a={0};a.double_sided=1;for(int v=0;v<3;v++){a.v[v].front[2]=32767;a.v[v].back[2]=-32767;a.v[v].a565=0;a.v[v].b565=color;}return a;}
static vis_scene *plane(double z,vis_generation g){double p[]={-100,-100,z,100,-100,z,100,100,z,-100,100,z};uint32_t idx[]={0,1,2,0,2,3};vis_scene *s=NULL;vis_limits lim={2048,4095,524288};assert(vis_scene_build(&s,p,4,idx,2,g,lim)==VIS_OK);return s;}
static bounce_scene *scene(vis_scene *v,bounce_triangle a[2],FoxDiskScene *l,bounce_generation g,int sign){bounce_scene *s=NULL;assert(bounce_scene_build(&s,v,a,2,l,sign,g,262144)==BOUNCE_OK);return s;}
static bounce_result eval(bounce_scene *s,bounce_generation g,bounce_mode mode,unsigned outer,const double rho[3]){bounce_binding b={0};assert(bounce_binding_set(&b,s,g)==BOUNCE_OK);double p[3]={0,0,0},n[3]={0,0,1};vis_budget db=budget(),bu=budget();bounce_result r;assert(bounce_eval(&b,g,p,n,rho,mode,outer,16,&db,&bu,&r)==BOUNCE_OK);bounce_binding_clear(&b);return r;}
static void close3(const double a[3],const double b[3]){for(int k=0;k<3;k++)assert(fabs(a[k]-b[k])<1e-11);}
static float decode(float x){return x<=.04045f?x/12.92f:powf((x+.055f)/1.055f,2.4f);}
int main(void){
 bounce_generation g={{1,1,1},1};FoxDiskScene lights=light_scene();double rho[3]={.3,.6,.9},zero[3]={0,0,0},want[3];bounce_triangle a[2]={attr(0xffff),attr(0xffff)};
 vis_scene *v=plane(-1,g.visibility);bounce_scene *s=scene(v,a,&lights,g,1);
 assert(sizeof(bounce_triangle)==64&&sizeof(bounce_vertex)==20);assert(bounce_scene_required_bytes(2048)<=262144);assert(!bounce_scene_required_bytes(2049));
 for(int k=0;k<3;k++)want[k]=rho[k]*lights.world_radiance[k];
 for(int mode=0;mode<=2;mode++){bounce_result r=eval(s,g,(bounce_mode)mode,16,rho);close3(r.combined,want);if(mode)assert(r.counters.primary_misses==16&&r.counters.primary_hits==0);}
 assert(bounce_scene_matches_lights(s,&lights));FoxDiskScene changed=lights;changed.world_radiance[0]+=.1;assert(!bounce_scene_matches_lights(s,&changed));
 bounce_scene_release(s);vis_scene_release(v);
 v=plane(1,g.visibility);a[0]=a[1]=attr(0x8410);s=scene(v,a,&lights,g,1);double ry[3]={decode(16/31.0f),decode(32/63.0f),decode(16/31.0f)};
 for(int k=0;k<3;k++)want[k]=rho[k]*ry[k]*lights.world_radiance[k];
 bounce_result r=eval(s,g,BOUNCE_ONE,16,rho);close3(r.combined,want);assert(r.counters.primary_hits==16&&r.counters.secondary_world_rays==256&&r.counters.primary_misses==0);assert(r.counters.zero_reflection_ns_v==0);r=eval(s,g,BOUNCE_ONE,64,rho);close3(r.combined,want);assert(r.counters.secondary_world_rays==1024);r=eval(s,g,BOUNCE_WORLD_VISIBLE,16,rho);close3(r.combined,zero);r=eval(s,g,BOUNCE_ONE,16,zero);close3(r.combined,zero);
 /* Owned copies survive caller mutation and retained geometry release. */
 memset(a,0,sizeof(a));vis_scene_release(v);r=eval(s,g,BOUNCE_ONE,16,rho);close3(r.combined,want);
 bounce_binding binding={0};assert(bounce_binding_set(&binding,s,g)==BOUNCE_OK);bounce_scene_release(s);s=binding.scene;
 double p[3]={0,0,0},n[3]={0,0,1};vis_budget db=budget(),bu=budget();bu.limit.rays=2;bounce_result sentinel;memset(&sentinel,0x5a,sizeof(sentinel));bounce_result before=sentinel;
 assert(bounce_eval(&binding,g,p,n,rho,BOUNCE_ONE,16,16,&db,&bu,&sentinel)==BOUNCE_BUDGET);assert(!memcmp(&before,&sentinel,sizeof(before)));assert(bu.used.rays==2);
 bounce_generation bad=g;bad.material++;bu=budget();assert(bounce_eval(&binding,bad,p,n,rho,BOUNCE_ONE,16,16,&db,&bu,&sentinel)==BOUNCE_GENERATION);assert(!memcmp(&before,&sentinel,sizeof(before)));
 bounce_binding_clear(&binding);
 /* Single-sided back hits and shading-normal disagreement give zero, separately. */
 v=plane(1,g.visibility);a[0]=a[1]=attr(0xffff);a[0].double_sided=a[1].double_sided=0;s=scene(v,a,&lights,g,1);r=eval(s,g,BOUNCE_ONE,16,rho);close3(r.combined,zero);assert(r.counters.back_single_discard==16);bounce_scene_release(s);
 a[0]=a[1]=attr(0xffff);for(int t=0;t<2;t++)for(int j=0;j<3;j++)a[t].v[j].back[2]=32767;s=scene(v,a,&lights,g,1);r=eval(s,g,BOUNCE_ONE,16,rho);close3(r.combined,zero);assert(r.counters.zero_reflection_ns_v==16);bounce_scene_release(s);
 /* Orientation sign flips which separately stored side is chosen. */
 for(int t=0;t<2;t++)for(int j=0;j<3;j++)a[t].v[j].front[2]=-32767;
 s=scene(v,a,&lights,g,-1);r=eval(s,g,BOUNCE_ONE,16,rho);for(int k=0;k<3;k++)want[k]=rho[k]*lights.world_radiance[k];close3(r.combined,want);
 bounce_scene *old=s;assert(bounce_scene_build(&s,v,a,2,&lights,-1,g,262144)==BOUNCE_GENERATION);assert(s==old);bad=g;bad.material++;a[0].v[0].front[0]=INT16_MIN;assert(bounce_scene_build(&s,v,a,2,&lights,-1,bad,262144)==BOUNCE_INVALID);assert(s==old);a[0].v[0].front[0]=0;a[0].v[0].mask=NAN;assert(bounce_scene_build(&s,v,a,2,&lights,-1,bad,262144)==BOUNCE_INVALID);a[0].v[0].mask=0;
 assert(bounce_binding_set(&binding,s,g)==BOUNCE_OK);assert(bounce_scene_build(&s,v,a,2,&lights,-1,bad,262144)==BOUNCE_OK);r=eval(binding.scene,g,BOUNCE_ONE,16,rho);close3(r.combined,want);bounce_binding_clear(&binding);bounce_scene_release(s);vis_scene_release(v);
 puts("bounce tests passed: uniform-world, blocked-world, rhoX*rhoY, zero-rho, 16/64, sign/sides, generations, lifetime, failure atomicity and budgets");return 0;
}
