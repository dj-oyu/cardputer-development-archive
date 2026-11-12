#include "fox_disk_lighting.h"
#include <assert.h>
#include <float.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

#define PI 3.141592653589793238462643383279502884
static unsigned checks=0;
#define CHECK(x) do { ++checks; if (!(x)) { fprintf(stderr,"FAIL %s:%d: %s\n",__FILE__,__LINE__,#x); return 1; } } while(0)
static int near(double a,double b,double tolerance) { return fabs(a-b)<=tolerance*fmax(1,fmax(fabs(a),fabs(b))); }
static void canonical(FoxDiskLightInput input[3]) {
    unsigned j;
    memset(input,0,3*sizeof(*input));
    for(j=0;j<3;j++) { input[j].shape=FOX_DISK_SHAPE_DISK; input[j].center[2]=2; input[j].power=1; input[j].diameter=2; }
    input[0].color[0]=input[0].color[1]=input[0].color[2]=1;
}
static int unchanged_eval(FoxDiskStatus expected, const FoxDiskScene *s,
    const double p[3], const double n[3], const double rho[3]) {
    double out[3]={11,22,33}, sentinel[3]={11,22,33};
    return fox_disk_eval16(s,p,n,rho,out)==expected && !memcmp(out,sentinel,sizeof(out));
}
static unsigned long long rng=0xbadc0ffeeULL;
static double random_unit(void) { rng=rng*6364136223846793005ULL+1442695040888963407ULL; return (double)(rng>>11)*0x1.0p-53; }

int main(void) {
    FoxDiskLightInput inputs[3], invalid[3];
    FoxDiskScene scene,saved,changed;
    const double zero[3]={0,0,0}, normal[3]={0,0,1}, white[3]={1,1,1};
    double result[3],base[3],other[3];
    double exact=1/(5*PI*PI), normalized[3]={0,0,DBL_MIN};
    unsigned k,j;
    canonical(inputs);
    CHECK(fox_disk_scene_init(&scene,inputs,zero,0)==FOX_DISK_OK);
    saved=scene;
    CHECK(fox_disk_eval16(&scene,zero,normal,white,base)==FOX_DISK_OK);
    CHECK(fabs(base[0]/exact-1)<0.0033);
    CHECK(fox_disk_eval_diagnostic(&scene,zero,normal,white,256,result)==FOX_DISK_OK);
    CHECK(fabs(result[0]/exact-1)<2.1e-7);
    CHECK(fox_disk_eval_diagnostic(&scene,zero,normal,white,2,result)==FOX_DISK_OK);
    for(k=0;k<3;k++) CHECK(near(base[k],result[k],1e-16));
    CHECK(fox_disk_eval16(&scene,zero,normalized,white,result)==FOX_DISK_OK);
    for(k=0;k<3;k++) CHECK(near(base[k],result[k],1e-16));
    normalized[2]=DBL_MAX;
    CHECK(fox_disk_eval16(&scene,zero,normalized,white,result)==FOX_DISK_OK);
    CHECK(near(base[0],result[0],1e-16));

    /* Energy, spectral color, material factor, all three lights, world once. */
    inputs[0].power=2.5;
    CHECK(fox_disk_scene_init(&changed,inputs,zero,0)==FOX_DISK_OK);
    CHECK(fox_disk_eval16(&changed,zero,normal,white,result)==FOX_DISK_OK);
    CHECK(near(result[0],base[0]*2.5,1e-15));
    canonical(inputs); inputs[0].color[0]=0.2; inputs[0].color[1]=0.5; inputs[0].color[2]=0.9;
    CHECK(fox_disk_scene_init(&changed,inputs,zero,0)==FOX_DISK_OK);
    { const double rho[3]={0.3,0.6,0.8};
      CHECK(fox_disk_eval16(&changed,zero,normal,rho,result)==FOX_DISK_OK);
      for(k=0;k<3;k++) CHECK(near(result[k],base[k]*inputs[0].color[k]*rho[k],1e-15)); }
    canonical(inputs);
    for(j=1;j<3;j++) for(k=0;k<3;k++) inputs[j].color[k]=1;
    CHECK(fox_disk_scene_init(&changed,inputs,zero,0)==FOX_DISK_OK);
    CHECK(fox_disk_eval16(&changed,zero,normal,white,result)==FOX_DISK_OK);
    CHECK(near(result[0],base[0]*3,1e-15));
    canonical(inputs);
    { const double w[3]={0.2,0.4,0.8},rho[3]={0.3,0.5,0.9};
      CHECK(fox_disk_scene_init(&changed,inputs,w,0.35)==FOX_DISK_OK);
      CHECK(fox_disk_eval16(&changed,zero,normal,rho,result)==FOX_DISK_OK);
      for(k=0;k<3;k++) CHECK(near(result[k],rho[k]*(base[k]+w[k]*0.35),1e-15));
      CHECK(fox_disk_scene_init(&changed,inputs,w,0.7)==FOX_DISK_OK);
      CHECK(fox_disk_eval16(&changed,zero,normal,rho,other)==FOX_DISK_OK);
      for(k=0;k<3;k++) CHECK(near(other[k]-result[k],rho[k]*w[k]*0.35,1e-15)); }
    /* One-sided emitter and receiver; changing size at constant total power. */
    { double back[3]={0,0,-1};
      CHECK(fox_disk_eval16(&scene,zero,back,white,result)==FOX_DISK_OK);
      CHECK(result[0]==0 && result[1]==0 && result[2]==0); }
    canonical(inputs); inputs[0].rotation_xyz[0]=PI;
    CHECK(fox_disk_scene_init(&changed,inputs,zero,0)==FOX_DISK_OK);
    CHECK(fox_disk_eval16(&changed,zero,normal,white,result)==FOX_DISK_OK);
    CHECK(result[0]==0 && result[1]==0 && result[2]==0);
    canonical(inputs); inputs[0].diameter=4;
    CHECK(fox_disk_scene_init(&changed,inputs,zero,0)==FOX_DISK_OK);
    CHECK(fox_disk_eval_diagnostic(&changed,zero,normal,white,256,result)==FOX_DISK_OK);
    CHECK(fabs(result[0]/(1/(8*PI*PI))-1)<2.3e-6);
    canonical(inputs); inputs[0].center[2]=4;
    CHECK(fox_disk_scene_init(&changed,inputs,zero,0)==FOX_DISK_OK);
    CHECK(fox_disk_eval_diagnostic(&changed,zero,normal,white,256,result)==FOX_DISK_OK);
    CHECK(fabs(result[0]/(1/(17*PI*PI))-1)<2e-8);
    /* Rz Ry Rx sends local -Z to world -X for y=pi/2. */
    canonical(inputs); inputs[0].rotation_xyz[1]=PI/2;
    CHECK(fox_disk_scene_init(&changed,inputs,zero,0)==FOX_DISK_OK);
    CHECK(near(changed.lights[0].normal[0],-1,1e-15));
    CHECK(fabs(changed.lights[0].normal[2])<1e-15);
    CHECK(near(changed.lights[0].axis_u[2],-1,1e-15));
    /* Scene immutability, failed initialization and endpoint/range atomicity. */
    canonical(inputs);
    memcpy(invalid,inputs,sizeof(invalid)); invalid[1].shape=(FoxDiskShape)2;
    changed=saved; CHECK(fox_disk_scene_init(&changed,invalid,zero,0)==FOX_DISK_UNSUPPORTED_SHAPE);
    CHECK(!memcmp(&changed,&saved,sizeof(changed)));
    memcpy(invalid,inputs,sizeof(invalid)); invalid[2].power=NAN;
    CHECK(fox_disk_scene_init(&changed,invalid,zero,0)==FOX_DISK_INVALID_INPUT);
    CHECK(!memcmp(&changed,&saved,sizeof(changed)));
    memcpy(invalid,inputs,sizeof(invalid)); invalid[2].diameter=0;
    CHECK(fox_disk_scene_init(&changed,invalid,zero,0)==FOX_DISK_INVALID_INPUT);
    memcpy(invalid,inputs,sizeof(invalid)); invalid[2].color[1]=-0.1;
    CHECK(fox_disk_scene_init(&changed,invalid,zero,0)==FOX_DISK_INVALID_INPUT);
    memcpy(invalid,inputs,sizeof(invalid)); invalid[0].power=DBL_MAX; invalid[0].color[0]=100;
    CHECK(fox_disk_scene_init(&changed,invalid,zero,0)==FOX_DISK_NUMERIC_RANGE);
    CHECK(!memcmp(&changed,&saved,sizeof(changed)));
    { double p[3]={0.1,0.1,2}, badn[3]={NAN,0,1}, badrho[3]={1.1,1,1};
      CHECK(unchanged_eval(FOX_DISK_NEAR_ENDPOINT,&scene,p,normal,white));
      p[2]+=0.5e-9; CHECK(unchanged_eval(FOX_DISK_NEAR_ENDPOINT,&scene,p,normal,white));
      CHECK(unchanged_eval(FOX_DISK_INVALID_INPUT,&scene,zero,badn,white));
      CHECK(unchanged_eval(FOX_DISK_INVALID_INPUT,&scene,zero,zero,white));
      CHECK(unchanged_eval(FOX_DISK_INVALID_INPUT,&scene,zero,normal,badrho));
      p[0]=INFINITY; CHECK(unchanged_eval(FOX_DISK_INVALID_INPUT,&scene,p,normal,white)); }
    changed=scene; changed.lights[0].power_rgb_over_pi_squared[0]=DBL_MAX;
    { const double p[3]={0,0,1.99999};
      CHECK(fox_disk_eval16(&changed,p,normal,white,result)==FOX_DISK_OK);
      CHECK(isfinite(result[0])); }
    changed=scene; changed.lights[0].radius=1e-6; changed.lights[0].power_rgb_over_pi_squared[0]=DBL_MAX;
    { const double p[3]={0,0,1.99999};
      CHECK(unchanged_eval(FOX_DISK_NUMERIC_RANGE,&changed,p,normal,white)); }
    changed=scene; changed.lights[0].center[0]=-DBL_MAX;
    { const double p[3]={DBL_MAX,0,0};
      CHECK(unchanged_eval(FOX_DISK_NUMERIC_RANGE,&changed,p,normal,white)); }
    CHECK(!memcmp(&scene,&saved,sizeof(scene)));
    canonical(inputs);
    memcpy(invalid,inputs,sizeof(invalid)); invalid[0].power=0;
    CHECK(fox_disk_scene_init(&changed,invalid,zero,0)==FOX_DISK_INVALID_INPUT);
    memcpy(invalid,inputs,sizeof(invalid)); invalid[0].rotation_xyz[1]=INFINITY;
    CHECK(fox_disk_scene_init(&changed,invalid,zero,0)==FOX_DISK_INVALID_INPUT);
    memcpy(invalid,inputs,sizeof(invalid)); invalid[0].diameter=INFINITY;
    CHECK(fox_disk_scene_init(&changed,invalid,zero,0)==FOX_DISK_INVALID_INPUT);
    CHECK(fox_disk_scene_init(&changed,inputs,zero,-0.1)==FOX_DISK_INVALID_INPUT);
    CHECK(fox_disk_scene_init(NULL,inputs,zero,0)==FOX_DISK_BAD_ARGUMENT);
    CHECK(fox_disk_eval16(&scene,zero,normal,white,NULL)==FOX_DISK_BAD_ARGUMENT);
    CHECK(unchanged_eval(FOX_DISK_BAD_ARGUMENT,NULL,zero,normal,white));
    changed=scene; changed.lights[0].normal[2]=0;
    CHECK(unchanged_eval(FOX_DISK_INVALID_INPUT,&changed,zero,normal,white));
    { double out[3]={11,22,33},sentinel[3]={11,22,33};
      CHECK(fox_disk_eval_diagnostic(&scene,zero,normal,white,0,out)==FOX_DISK_BAD_ARGUMENT);
      CHECK(!memcmp(out,sentinel,sizeof(out)));
      CHECK(fox_disk_eval_diagnostic(&scene,zero,normal,white,513,out)==FOX_DISK_BAD_ARGUMENT);
      CHECK(!memcmp(out,sentinel,sizeof(out))); }
    /* Deterministic admissible random geometry/material smoke checks. */
    for(j=0;j<10000;j++) {
        double p[3],n[3],rho[3];
        for(k=0;k<3;k++) { p[k]=(random_unit()-0.5)*20; n[k]=random_unit()-0.5; rho[k]=random_unit(); }
        CHECK(fox_disk_eval16(&scene,p,n,rho,result)==FOX_DISK_OK);
        for(k=0;k<3;k++) CHECK(isfinite(result[k]) && result[k]>=0);
    }
    printf("{\"passed_checks\":%u,\"sizeof_input\":%zu,\"sizeof_light\":%zu,\"sizeof_scene\":%zu,\"static_quadrature_bytes\":256,\"heap_bytes\":0,\"sample_points_per_eval16\":48,\"sample_points_per_eval64\":192,\"axis16\":%.17g,\"axis_analytic\":%.17g,\"axis16_relative_error\":%.17g}\n",checks,sizeof(FoxDiskLightInput),sizeof(FoxDiskLight),sizeof(FoxDiskScene),base[0],exact,base[0]/exact-1);
    return 0;
}
