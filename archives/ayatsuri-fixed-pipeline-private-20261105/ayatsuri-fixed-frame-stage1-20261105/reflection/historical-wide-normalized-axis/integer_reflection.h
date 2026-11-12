#ifndef INTEGER_REFLECTION_H
#define INTEGER_REFLECTION_H
#include "../../ayatsuri-fixed-integer-light-20261105/normal_bridge.h"
#include "hemisphere_constants.h"
typedef enum {HR_OK=0,HR_NEAR_ZERO=1,HR_RANGE=2,HR_BASIS_AMBIGUOUS=3} hr_status;
/* Pure arithmetic only. No scene, ray, hit, visibility, BVH or ownership API.
 * AMBIGUOUS output is diagnostic only: caller must not use it as accepted
 * directions without a separately approved policy. No output on other failure. */
static hr_status hr_directions16(const int16_t interpolated[3],int16_t out[16][3],unsigned *basis){
 int16_t n[3],u[3],candidate[16][3];int32_t v[3];if(il_normalize_interpolated(interpolated,n)!=IL_NORMAL_OK)return HR_NEAR_ZERO;
 unsigned axis=0;int a[3];for(unsigned k=0;k<3;k++)a[k]=n[k]<0?-(int)n[k]:n[k];for(unsigned k=1;k<3;k++)if(a[k]<a[axis])axis=k;
 bool ambiguous=false;for(unsigned k=0;k<3;k++)if(k!=axis&&a[k]-a[axis]<=2)ambiguous=true;
 int16_t cross[3]={0};cross[(axis+1)%3]=(int16_t)-n[(axis+2)%3];cross[(axis+2)%3]=n[(axis+1)%3];
 if(il_normalize_interpolated(cross,u)!=IL_NORMAL_OK)return HR_RANGE;
 for(unsigned k=0;k<3;k++){unsigned j=(k+1)%3,h=(k+2)%3;int64_t x=il_signed_round((int64_t)n[j]*u[h]-(int64_t)n[h]*u[j],32767);if(x < -32772||x>32772)return HR_RANGE;v[k]=(int32_t)x;}
 for(unsigned i=0;i<16;i++){int16_t half[3];for(unsigned k=0;k<3;k++){int64_t x=(int64_t)hemisphere16[i][0]*u[k]+(int64_t)hemisphere16[i][1]*v[k]+(int64_t)hemisphere16[i][2]*n[k];x=il_signed_round(x,65534);if(x < -32768||x>32767)return HR_RANGE;half[k]=(int16_t)x;}if(il_normalize_interpolated(half,candidate[i])!=IL_NORMAL_OK)return HR_RANGE;}
 for(unsigned i=0;i<16;i++)for(unsigned k=0;k<3;k++)out[i][k]=candidate[i][k];*basis=axis;return ambiguous?HR_BASIS_AMBIGUOUS:HR_OK;
}
static bool hr_block(const int16_t in[8][3],unsigned width,int16_t out[8][16][3],unsigned basis[8],hr_status status[8]){if(width!=1&&width!=2&&width!=4&&width!=8)return false;for(unsigned p=0;p<width;p++)status[p]=hr_directions16(in[p],out[p],&basis[p]);return true;}
typedef struct {uint32_t direct[3],world[3];uint16_t rho_secondary[3];uint8_t active;} hr_fixed_sample;
/* Supplied radiances UQ13.19; material /32767. Reduction output uint64 Q19.
 * Active flag encodes an externally determined contribution, not a ray query. */
static bool hr_reduce16(const hr_fixed_sample sample[16],const uint16_t rho[3],uint64_t out[3]){
 for(unsigned k=0;k<3;k++)if(rho[k]>32767)return false;
 for(unsigned i=0;i<16;i++){if(sample[i].active>1)return false;for(unsigned k=0;k<3;k++)if(sample[i].rho_secondary[k]>32767)return false;}
 uint64_t acc[3]={0};for(unsigned i=0;i<16;i++)if(sample[i].active)for(unsigned k=0;k<3;k++){uint64_t secondary=sample[i].direct[k]+il_round((uint64_t)sample[i].world[k]*sample[i].rho_secondary[k],32767);acc[k]+=il_round(secondary*rho[k],32767);}
 for(unsigned k=0;k<3;k++)out[k]=il_round(acc[k],16);return true;
}
static bool hr_reduce_block(const hr_fixed_sample in[8][16],const uint16_t rho[8][3],unsigned width,uint64_t out[8][3],bool ok[8]){if(width!=1&&width!=2&&width!=4&&width!=8)return false;for(unsigned i=0;i<width;i++)ok[i]=hr_reduce16(in[i],rho[i],out[i]);return true;}
#endif
