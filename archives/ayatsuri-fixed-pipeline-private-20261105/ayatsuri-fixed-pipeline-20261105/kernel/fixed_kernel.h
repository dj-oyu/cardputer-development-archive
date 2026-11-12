#ifndef FIXED_KERNEL_H
#define FIXED_KERNEL_H
#include <stdbool.h>
#include <stdint.h>
#include <math.h>
enum { FK_ONE=16384, FK_LANES=8 };
/* Caller-owned SoA tile. One attribute at a time, unrelated triangles allowed. */
typedef struct { _Alignas(16) int16_t w[3][8]; _Alignas(16) int16_t a[3][8]; } fk_tile;
static inline bool fk_weights(const double b[3], int16_t w[3]) {
 double sum=0, rem[3]; int q[3], total=0;
 for(int j=0;j<3;j++){ if(!isfinite(b[j])||b[j]<0||b[j]>1)return false; sum+=b[j]; }
 if(fabs(sum-1)>1e-12)return false;
 for(int j=0;j<3;j++){double v=(b[j]/sum)*FK_ONE;q[j]=(int)floor(v);rem[j]=v-q[j];total+=q[j];}
 int left=FK_ONE-total; if(left<0||left>3)return false;
 for(int k=0;k<left;k++){int best=0;for(int j=1;j<3;j++)if(rem[j]>rem[best])best=j;q[best]++;rem[best]=-1;}
 for(int j=0;j<3;j++){if(q[j]<0||q[j]>FK_ONE)return false;w[j]=(int16_t)q[j];}return true;
}
/* Nearest ties-even via explicit floor/remainder, not nearbyint/rint.
 * Floating preparation (multiply, barycentric normalization) requires
 * FE_TONEAREST; the integer MAC rounding below is fenv-independent.
 * Range check applies after rounding, matching the versioned converter. */
static inline bool fk_encode(double x,double scale,int16_t *out){
 if(!isfinite(x)||!isfinite(scale)||scale<=0)return false;
 double v=x*scale;if(!isfinite(v)||v < -32769||v>32768)return false;
 double r=floor(v),fraction=v-r;
 if(fraction>.5||(fraction==.5&&fmod(r,2)!=0))r+=1;
 if(r < -32768||r>32767)return false;*out=(int16_t)r;return true;
}
/* Round nearest, ties to even. Precondition: valid interpolation accumulator. No negative shifts, signed-overflow UB,
 * implementation-dependent right shift, or reliance on QACC saturation. */
static inline int16_t fk_round(int64_t v){
 int64_t q=v/16384,r=v%16384,m=r<0?-r:r;
 if(m>8192||(m==8192&&q%2!=0))q+=v<0?-1:1;
 return (int16_t)q;
}
static inline bool fk_scalar(const int16_t w[3],const int16_t a[3],int16_t *out){
 int total=0;int64_t acc=0;for(int j=0;j<3;j++){if(w[j]<0)return false;total+=w[j];acc+=(int64_t)w[j]*a[j];}
 if(total!=FK_ONE)return false;*out=fk_round(acc);return true;
}
static inline bool fk_block(const fk_tile *t,unsigned n,int16_t out[8]){
 if(n!=1&&n!=2&&n!=4&&n!=8)return false;
 for(unsigned i=0;i<n;i++){int sum=0;for(int j=0;j<3;j++){if(t->w[j][i]<0)return false;sum+=t->w[j][i];}if(sum!=FK_ONE)return false;}
 int64_t acc[8]={0};for(int j=0;j<3;j++)for(unsigned i=0;i<n;i++)acc[i]+=(int64_t)t->w[j][i]*t->a[j][i];
 for(unsigned i=0;i<n;i++)out[i]=fk_round(acc[i]);return true;
}
#endif
