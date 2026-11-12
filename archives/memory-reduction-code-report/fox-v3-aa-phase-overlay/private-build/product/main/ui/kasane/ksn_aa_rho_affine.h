#ifndef KSN_AA_RHO_AFFINE_H
#define KSN_AA_RHO_AFFINE_H
#include <stdbool.h>
#include <math.h>
#include <float.h>
/* Private host-only helper. Reads all inputs before committing any output,
 * including if out aliases bary storage. Actual caller uses distinct locals.
 * Original finite/range64epsilon/clamp rules remain unchanged. */
static inline bool ksn_aa_rho_affine(const float decoded[3][3],const double bary[3],double out[3]){
 for(unsigned j=0;j<3;j++)if(!isfinite(bary[j]))return false;
 for(unsigned j=0;j<3;j++)for(unsigned k=0;k<3;k++)if(!isfinite(decoded[j][k]))return false;
 double result[3];
 for(unsigned k=0;k<3;k++){
  const double a=decoded[0][k],b=decoded[1][k],c=decoded[2][k];
  const double first=a+bary[1]*(b-a);
  result[k]=first+bary[2]*(c-a);
  if(!isfinite(result[k])||result[k]<-64*DBL_EPSILON||result[k]>1+64*DBL_EPSILON)return false;
  result[k]=fmax(0,fmin(1,result[k]));
 }
 for(unsigned k=0;k<3;k++)out[k]=result[k];
 return true;
}
#endif
