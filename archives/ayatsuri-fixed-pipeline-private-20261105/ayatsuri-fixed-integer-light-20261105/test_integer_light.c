#include "integer_light.h"
#include "frozen/fox_disk_lighting.c"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <fenv.h>
#include <inttypes.h>
#define COUNT 2048
static uint64_t rng=0xab7312fe439d1567ULL;
static double unit(void){rng^=rng<<13;rng^=rng>>7;rng^=rng<<17;return (uint32_t)rng/4294967295.0;}
static int32_t pos(double x){assert(isfinite(x)&&fabs(x)<=8);return (int32_t)nearbyint(x*65536);}
static void prepare(const FoxDiskScene *d,il_scene *s){memset(s,0,sizeof(*s));for(unsigned k=0;k<3;k++)s->world[k]=(uint32_t)nearbyint(d->world_radiance[k]*16777216);for(unsigned l=0;l<3;l++){const FoxDiskLight *a=d->lights+l;il_light*b=s->light+l;for(unsigned k=0;k<3;k++){b->center[k]=pos(a->center[k]);b->normal[k]=(int16_t)nearbyint(a->normal[k]*32767);assert(a->power_rgb_over_pi_squared[k]<=256);b->power[k]=(uint32_t)nearbyint(a->power_rgb_over_pi_squared[k]*65536);}for(unsigned j=0;j<16;j++)for(unsigned k=0;k<3;k++)b->sample[j][k]=pos(a->center[k]+a->radius*(disk16[j][0]*a->axis_u[k]+disk16[j][1]*a->axis_v[k]));}assert(il_scene_valid(s));}
static void pixel(const double p[3],const double n[3],const double rho[3],const uint16_t masks[3],il_pixel*out){double nn[3];assert(normalize3(n,nn));for(unsigned k=0;k<3;k++){out->p[k]=pos(p[k]);out->normal[k]=(int16_t)nearbyint(nn[k]*32767);out->rho[k]=(uint16_t)nearbyint(rho[k]*32767);out->visible[k]=masks[k];}}
typedef struct {const FoxDiskScene*s;const uint16_t*m;} mask_context;
static bool visible(void*ctx,const double*p,const double*n,const double*q,bool*out){(void)p;(void)n;mask_context*c=ctx;for(unsigned l=0;l<3;l++)for(unsigned j=0;j<16;j++){bool match=true;for(unsigned k=0;k<3;k++){const FoxDiskLight*a=c->s->lights+l;double x=a->center[k]+a->radius*(disk16[j][0]*a->axis_u[k]+disk16[j][1]*a->axis_v[k]);if(x!=q[k])match=false;}if(match){*out=(c->m[l]&(1u<<j))!=0;return true;}}return false;}
static double err[COUNT*3],rel[COUNT*3];
static int cmp(const void*a,const void*b){double x=*(const double*)a,y=*(const double*)b;return (x>y)-(x<y);}
static void report(const char*name,double *a,unsigned n){double ss=0;for(unsigned i=0;i<n;i++)ss+=a[i]*a[i];qsort(a,n,sizeof(double),cmp);printf("%s n=%u max=%.12g rms=%.12g p50=%.12g p95=%.12g p99=%.12g\n",name,n,a[n-1],sqrt(ss/n),a[n/2],a[n*95/100],a[n*99/100]);}
int main(void){assert(fegetround()==FE_TONEAREST);for(uint64_t x=0;x<100000;x++){uint64_t r=il_sqrt(x);assert(r*r<=x&&(r+1)*(r+1)>x);}assert(il_sqrt(UINT64_MAX)==UINT32_MAX);assert(il_round(1,2)==0&&il_round(3,2)==2&&il_signed_round(-3,2)==-2);
 FoxDiskLightInput inputs[3]={0};for(unsigned l=0;l<3;l++){inputs[l].shape=FOX_DISK_SHAPE_DISK;inputs[l].center[0]=(double)l-.75;inputs[l].center[1]=.2*l;inputs[l].center[2]=2+.3*l;inputs[l].rotation_xyz[0]=.1*l;inputs[l].rotation_xyz[1]=-.15*l;inputs[l].color[0]=1;inputs[l].color[1]=.7;inputs[l].color[2]=.3;inputs[l].power=10+13*l;inputs[l].diameter=.5+.25*l;}
 double world[3]={.01,.02,.03};FoxDiskScene scene;assert(fox_disk_scene_init(&scene,inputs,world,1)==FOX_DISK_OK);il_scene fixed;prepare(&scene,&fixed);
 unsigned accepted=0,rejected=0,relative=0;double maxrgb=0;
 for(unsigned t=0;t<COUNT;t++){
  double p[3]={unit()*4-2,unit()*4-2,unit()*1.5-.5},n[3]={unit()*2-1,unit()*2-1,unit()*2-1},rho[3]={unit(),unit(),unit()};uint16_t masks[3]={(uint16_t)(unit()*65535),(uint16_t)(unit()*65535),(uint16_t)(unit()*65535)};
  if(t%8==0){n[0]=n[1]=0;n[2]=1;for(unsigned k=0;k<3;k++)masks[k]=65535;}
  il_pixel px;pixel(p,n,rho,masks,&px);uint64_t out[3]={UINT64_MAX,UINT64_MAX,UINT64_MAX};il_status st=il_eval(&fixed,&px,out);
  if(st!=IL_OK){rejected++;assert(out[0]==UINT64_MAX);continue;}
  double ref[3];mask_context ctx={&scene,masks};assert(fox_disk_eval16_visible(&scene,p,n,rho,visible,&ctx,ref)==FOX_DISK_OK);
  for(unsigned k=0;k<3;k++){double value=out[k]/16777216.0,e=fabs(value-ref[k]);err[accepted*3+k]=e;if(ref[k]>1e-6)rel[relative++]=e/ref[k];if(value>maxrgb)maxrgb=value;}
  accepted++;
  for(unsigned width=1;width<=8;width*=2){il_pixel pp[8];uint64_t oo[8][3];il_status statuses[8];for(unsigned lane=0;lane<width;lane++){pp[lane]=px;pp[lane].visible[0]^=(uint16_t)(lane*7919u);}assert(il_block(&fixed,pp,width,oo,statuses));for(unsigned lane=0;lane<width;lane++){uint64_t single[3];assert(il_eval(&fixed,pp+lane,single)==statuses[lane]);assert(!memcmp(single,oo[lane],sizeof single));}}
  uint32_t hdr[3];assert(il_hdr19(out,hdr));for(unsigned k=0;k<3;k++)assert(fabs(hdr[k]/524288.0-out[k]/16777216.0)<=1.0/1048576);
 }
 printf("random accepted=%u rejected=%u max_hdr=%.12g integer_lane_mismatch=0\n",accepted,rejected,maxrgb);report("radiance_absolute",err,accepted*3);report("relative_ref_gt_1e-6",rel,relative);
 /* Boundary receiver over disk center: conservative guard must reject near
    plane, including positions double accepts but this fast domain does not. */
 const double gaps[]={0,1e-10,1e-9,1e-8,.001,.124,.126,.127,.128,.25};
 for(unsigned i=0;i<sizeof(gaps)/sizeof(*gaps);i++){double p[3]={inputs[0].center[0],inputs[0].center[1],inputs[0].center[2]-gaps[i]},n[3]={0,0,1},rho[3]={1,1,1};uint16_t masks[3]={65535,65535,65535};il_pixel px;pixel(p,n,rho,masks,&px);uint64_t out[3]={7,8,9};il_status st=il_eval(&fixed,&px,out);double ref[3];FoxDiskStatus rs=fox_disk_eval16(&scene,p,n,rho,ref);printf("boundary gap=%.12g integer_status=%d double_status=%d",gaps[i],st,rs);if(st==IL_OK){assert(rs==FOX_DISK_OK);printf(" max_abs=%.12g",fmax(fabs(out[0]/16777216.0-ref[0]),fmax(fabs(out[1]/16777216.0-ref[1]),fabs(out[2]/16777216.0-ref[2]))));}else assert(out[0]==7&&out[1]==8&&out[2]==9);puts("");}
 /* Grazing receiver cosine around zero with narrow but finite disk. */
 FoxDiskScene grazing=scene;for(unsigned l=0;l<3;l++){grazing.lights[l].radius=.0001;for(unsigned k=0;k<3;k++)grazing.world_radiance[k]=0;}il_scene gf;prepare(&grazing,&gf);
 for(int e=-4;e<=4;e++){double p[3]={-.75,0,0},n[3]={1,0,e*1e-5},rho[3]={1,1,1};uint16_t masks[3]={65535,0,0};il_pixel px;pixel(p,n,rho,masks,&px);uint64_t out[3];assert(il_eval(&gf,&px,out)==IL_OK);double ref[3];mask_context ctx={&grazing,masks};assert(fox_disk_eval16_visible(&grazing,p,n,rho,visible,&ctx,ref)==FOX_DISK_OK);printf("grazing nz=%g reference=%.12g integer=%.12g abs=%.12g\n",n[2],ref[0],out[0]/16777216.0,fabs(out[0]/16777216.0-ref[0]));}

 /* Adversarial bright near-minimum domain: all three very small disks,
    maximum admitted radiometric coefficient, no world. */
 FoxDiskLightInput hi[3]={0};for(unsigned l=0;l<3;l++){hi[l].shape=FOX_DISK_SHAPE_DISK;hi[l].center[0]=.1*l;hi[l].center[2]=2;hi[l].power=256*PI*PI;hi[l].diameter=.0002;for(unsigned k=0;k<3;k++)hi[l].color[k]=1;}
 double dark[3]={0};FoxDiskScene hs;assert(fox_disk_scene_init(&hs,hi,dark,0)==FOX_DISK_OK);il_scene hf;prepare(&hs,&hf);
 for(unsigned i=5;i<10;i++){double p[3]={0,0,2-gaps[i]},n[3]={0,0,1},rho[3]={1,1,1};uint16_t masks[3]={65535,65535,65535};il_pixel px;pixel(p,n,rho,masks,&px);uint64_t out[3]={0};il_status st=il_eval(&hf,&px,out);printf("bright_boundary gap=%g integer_status=%d",gaps[i],st);if(st==IL_OK){double ref[3];assert(fox_disk_eval16(&hs,p,n,rho,ref)==FOX_DISK_OK);uint32_t h19[3];bool fit=il_hdr19(out,h19);printf(" reference=%.12g integer=%.12g abs=%.12g hdr19_fits=%d",ref[0],out[0]/16777216.0,fabs(out[0]/16777216.0-ref[0]),fit);}puts("");}
 il_scene invalid=fixed;invalid.world[0]=(16u<<24)+1;assert(!il_scene_valid(&invalid));invalid=fixed;invalid.light[0].sample[0][0]=IL_POSITION_MAX+1;assert(!il_scene_valid(&invalid));invalid=fixed;invalid.light[0].power[0]=(256u<<16)+1;assert(!il_scene_valid(&invalid));
 il_pixel bad={0};uint64_t unchanged[3]={7,8,9};assert(il_eval(&fixed,&bad,unchanged)==IL_INVALID);assert(unchanged[0]==7);uint64_t too_high[3]={UINT64_C(1)<<40,0,0};uint32_t untouched[3]={7,8,9};assert(!il_hdr19(too_high,untouched)&&untouched[0]==7);puts("PASS integer-only hot path, frozen source reference, statuses, masks, 1/2/4/8, HDR bridge");return 0;
}
