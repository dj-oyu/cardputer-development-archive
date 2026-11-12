#include "fox_disk_lighting.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

/* Independent copy of the documented fixed samples checks callback endpoints. */
static const double uv[16][2] = {
 {0.5,0}, {0.35355339059327379,0.35355339059327373}, {0,0.5},
 {-0.35355339059327373,0.35355339059327379}, {-0.5,0},
 {-0.35355339059327384,-0.35355339059327373}, {0,-0.5},
 {0.35355339059327368,-0.35355339059327384},
 {0.80010314519126557,0.33141357403559180},
 {0.33141357403559185,0.80010314519126546},
 {-0.33141357403559174,0.80010314519126557},
 {-0.80010314519126546,0.33141357403559191},
 {-0.80010314519126557,-0.33141357403559168},
 {-0.33141357403559224,-0.80010314519126524},
 {0.33141357403559196,-0.80010314519126546},
 {0.80010314519126524,-0.33141357403559230}
};
typedef struct {
 const FoxDiskScene *scene;
 const double *position;
 double normal[3];
 unsigned calls, fail_at;
 int mode;
} Query;
static bool query(void *context,const double p[3],const double n[3],
                  const double sample[3],bool *visible) {
 Query *q=context;
 unsigned i=q->calls%16,j=q->calls/16,k;
 const FoxDiskLight *l=&q->scene->lights[j];
 for (k=0;k<3;k++) {
  double expected=l->center[k]+l->radius*(uv[i][0]*l->axis_u[k]+uv[i][1]*l->axis_v[k]);
  assert(isfinite(p[k]) && isfinite(n[k]) && isfinite(sample[k]));
  assert(p[k]==q->position[k]);
  assert(n[k]==q->normal[k]);
  assert(memcmp(&sample[k],&expected,sizeof(double))==0);
 }
 q->calls++;
 if (q->fail_at && q->calls==q->fail_at) return false;
 *visible=q->mode==1 || (q->mode==2 && (i%2)==0);
 return true;
}
static double dot(const double a[3],const double b[3]) {
 return a[0]*b[0]+a[1]*b[1]+a[2]*b[2];
}
static void selective_expected(const FoxDiskScene *s,const double p[3],
 const double n[3],const double rho[3],double out[3]) {
 unsigned j,i,k;
 for(k=0;k<3;k++) out[k]=s->world_radiance[k];
 for(j=0;j<3;j++) {
  const FoxDiskLight *l=&s->lights[j];
  double sum=0,delta[3];
  for(k=0;k<3;k++) delta[k]=l->center[k]-p[k];
  for(i=0;i<16;i++) {
   double d[3],wi[3],length,inv,value;
   for(k=0;k<3;k++) d[k]=delta[k]+l->radius*(uv[i][0]*l->axis_u[k]+uv[i][1]*l->axis_v[k]);
   length=hypot(hypot(d[0],d[1]),d[2]); inv=1/length;
   for(k=0;k<3;k++) wi[k]=d[k]*inv;
   value=fmax(0,-dot(l->normal,wi))*fmax(0,dot(n,wi))*inv*inv;
   if(i%2) value=0;
   sum+=value;
  }
  for(k=0;k<3;k++) out[k]+=l->power_rgb_over_pi_squared[k]*(sum/16);
 }
 for(k=0;k<3;k++) out[k]*=rho[k];
}
#ifdef FOX_TEST_BASELINE
FoxDiskStatus baseline_eval16(const FoxDiskScene *,const double *,const double *,const double *,double *);
FoxDiskStatus baseline_diagnostic(const FoxDiskScene *,const double *,const double *,const double *,unsigned,double *);
#endif
int main(void) {
 FoxDiskLightInput lights[3]={0}; FoxDiskScene s;
 double world[3]={0.125,0.25,0.5},p[3]={0.17,-0.11,-0.7};
 double n[3]={0,0,7},rho[3]={0.2,0.6,1},old[3],out[3],expected[3];
 const double sentinel[3]={-91,-92,-93}; unsigned j,k,pass;
 Query q={0};
 for(j=0;j<3;j++) {
  lights[j].shape=FOX_DISK_SHAPE_DISK;
  lights[j].center[0]=(double)j*0.3;
  lights[j].center[1]=-(double)j*0.2;
  lights[j].center[2]=3+(double)j;
  lights[j].rotation_xyz[0]=0.03*(double)j;
  lights[j].rotation_xyz[1]=-0.06*(double)j;
  lights[j].rotation_xyz[2]=0.2*(double)j;
  lights[j].power=10+13*(double)j; lights[j].diameter=1.5;
  for(k=0;k<3;k++) lights[j].color[k]=0.4+0.2*(double)k;
 }
 assert(fox_disk_scene_init(&s,lights,world,0.7)==FOX_DISK_OK);
 q.scene=&s;q.position=p;q.normal[2]=1;
 for(pass=0;pass<100;pass++) {
  p[0]=0.17+(double)pass/200;
  assert(fox_disk_eval16(&s,p,n,rho,old)==FOX_DISK_OK);
  q.calls=0;q.mode=1;
  assert(fox_disk_eval16_visible(&s,p,n,rho,query,&q,out)==FOX_DISK_OK);
  assert(q.calls==48 && memcmp(old,out,sizeof(out))==0);
#ifdef FOX_TEST_BASELINE
  assert(baseline_eval16(&s,p,n,rho,expected)==FOX_DISK_OK);
  assert(memcmp(expected,old,sizeof(old))==0);
  for(j=1;j<=8;j*=2) {
   assert(baseline_diagnostic(&s,p,n,rho,j,expected)==FOX_DISK_OK);
   assert(fox_disk_eval_diagnostic(&s,p,n,rho,j,out)==FOX_DISK_OK);
   assert(memcmp(expected,out,sizeof(out))==0);
  }
#endif
 }
 /* Exercise actual normalization, not only axis-aligned unit direction. */
 n[0]=1;n[1]=2;n[2]=7;
 for(k=0;k<3;k++) q.normal[k]=n[k]/7;
 {
  double length=sqrt(dot(q.normal,q.normal));
  for(k=0;k<3;k++) q.normal[k]/=length;
 }
 q.calls=0;q.mode=1;
 assert(fox_disk_eval16(&s,p,n,rho,old)==FOX_DISK_OK);
 assert(fox_disk_eval16_visible(&s,p,n,rho,query,&q,out)==FOX_DISK_OK);
 assert(q.calls==48 && memcmp(old,out,sizeof(out))==0);
 q.calls=0;q.mode=0;
 assert(fox_disk_eval16_visible(&s,p,n,rho,query,&q,out)==FOX_DISK_OK);
 for(k=0;k<3;k++) expected[k]=s.world_radiance[k]*rho[k];
 assert(q.calls==48 && memcmp(expected,out,sizeof(out))==0);
 q.calls=0;q.mode=2;
 assert(fox_disk_eval16_visible(&s,p,n,rho,query,&q,out)==FOX_DISK_OK);
 selective_expected(&s,p,q.normal,rho,expected);
 assert(q.calls==48 && memcmp(expected,out,sizeof(out))==0);
 for(j=1;j<=48;j++) {
  q.calls=0;q.fail_at=j;memcpy(out,sentinel,sizeof(out));
  assert(fox_disk_eval16_visible(&s,p,n,rho,query,&q,out)==FOX_DISK_VISIBILITY_FAILURE);
  assert(q.calls==j && memcmp(out,sentinel,sizeof(out))==0);
 }
 q.fail_at=0;q.calls=0;n[0]=0;n[1]=0;n[2]=-7;
 assert(fox_disk_eval16_visible(&s,p,n,rho,query,&q,out)==FOX_DISK_OK);
 assert(q.calls==0);
 for(k=0;k<3;k++) assert(out[k]==s.world_radiance[k]*rho[k]);
 n[2]=7;for(j=0;j<3;j++) for(k=0;k<3;k++) s.lights[j].normal[k]*=-1;
 assert(fox_disk_eval16_visible(&s,p,n,rho,query,&q,out)==FOX_DISK_OK);
 assert(q.calls==0);
 memcpy(out,sentinel,sizeof(out));
 assert(fox_disk_eval16_visible(&s,p,n,rho,NULL,&q,out)==FOX_DISK_BAD_ARGUMENT);
 assert(memcmp(out,sentinel,sizeof(out))==0);
 assert(strcmp(fox_disk_status_string(FOX_DISK_VISIBILITY_FAILURE),"visibility query failed")==0);
 puts("PASS: all-visible bit exact, blocked world only, selective exact, 48 atomic failures, exact finite endpoints/normalized normals, zero-kernel skip, NULL rejection");
#ifdef FOX_TEST_BASELINE
 puts("PASS: pre-change eval16 + diagnostic byte exact across 100 receiver positions and diagnostic bands 1,2,4,8");
#endif
 return 0;
}
