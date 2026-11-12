#ifndef PRIVATE_NATIVE_RIG_H
#define PRIVATE_NATIVE_RIG_H
#include <math.h>
#include <stdbool.h>
#include "ayatsuri_skin_dq.h"
/* Restricted source contract: neutral facial controls, XYZ pitch/yaw only.
   The 2-bone body rest frames are translation-only and head pivot agrees with
   HeadDeform rest head. Caller owns palette and head delta; no static scratch. */
static bool native_rig(float turn,float tilt,ayatsuri_transform palette[2],float delta[12]){
 if(!isfinite(turn)||!isfinite(tilt)||!palette||!delta)return false;
 double z=.16*fmax(-1.,fmin(1.,turn)),y=.12*fmax(-1.,fmin(1.,tilt));
 double cz=cos(z),sz=sin(z),cy=cos(y),sy=sin(y);
 double r[9]={cz*cy,-sz,cz*sy,sz*cy,cz,sz*sy,-sy,0,cy};
 const double pivot[3]={0,.05000000074505806,2.0399999618530273};
 const double body_translation[3]={0,.1599999964237213,1.1374000310897827};
 for(unsigned i=0;i<3;i++){
  double t=pivot[i],localpivot=pivot[i]-body_translation[i];
  for(unsigned j=0;j<3;j++){delta[i*4+j]=(float)r[i*3+j];palette[0].m[i*4+j]=(float)r[i*3+j];palette[1].m[i*4+j]=i==j;t-=r[i*3+j]*pivot[j];localpivot-=r[i*3+j]*(pivot[j]-body_translation[j]);}
  delta[i*4+3]=(float)t;palette[0].m[i*4+3]=(float)localpivot;palette[1].m[i*4+3]=0;
 }
 return true;
}
static void native_apply(const float m[12],const float v[3],float out[3]){for(unsigned i=0;i<3;i++)out[i]=(float)((double)m[i*4]*v[0]+(double)m[i*4+1]*v[1]+(double)m[i*4+2]*v[2]+m[i*4+3]);}
#endif
