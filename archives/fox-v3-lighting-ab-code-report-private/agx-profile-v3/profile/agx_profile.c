#include "agx_profile.h"
#include <math.h>
#include "agx_lut.inc"
int agx_profile_eval(const float in[3],float out[3]) {
 if(!in||!out)return AGX_PROFILE_INVALID;
 for(int c=0;c<3;c++)if(!isfinite(in[c])||in[c]<0)return AGX_PROFILE_INVALID;
 int flags=0,base[3],order[3]={0,1,2}; float f[3];
 for(int c=0;c<3;c++) { double x=in[c]; if(x>AGX_HI){x=AGX_HI; flags|=AGX_PROFILE_CLAMP_HIGH;}
 double u=log1p(x/AGX_LO)/AGX_LOG_RANGE*(AGX_N-1); base[c]=(int)floor(u); if(base[c]>=AGX_N-1)base[c]=AGX_N-2; f[c]=(float)(u-base[c]); }
 for(int i=0;i<2;i++)for(int j=i+1;j<3;j++)if(f[order[j]]>f[order[i]]){int t=order[i];order[i]=order[j];order[j]=t;}
 int ix=(base[0]*AGX_N+base[1])*AGX_N+base[2];int stride[3]={AGX_N*AGX_N,AGX_N,1};
 float result[3];for(int c=0;c<3;c++)result[c]=agx_lut[ix*3+c];
 for(int k=0;k<3;k++){int nx=ix+stride[order[k]]; for(int c=0;c<3;c++)result[c]+=f[order[k]]*(agx_lut[nx*3+c]-agx_lut[ix*3+c]);ix=nx;}
 for(int c=0;c<3;c++) { out[c]=fminf(1,fmaxf(0,result[c])); }
 return flags;
}
