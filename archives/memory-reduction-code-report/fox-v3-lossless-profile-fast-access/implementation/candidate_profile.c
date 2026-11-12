#include "agx_profile.h"
#include <math.h>
#include "profile_data.h"
#include <stddef.h>
int lossless_fetch(const uint8_t*,size_t,uint32_t,uint16_t[3]);
int lossless_fetch4(const uint8_t*,size_t,const uint32_t[4],uint16_t[4][3]);
#define AGX_PROFILE_DECODE_ERROR 3
int agx_profile_eval(const float in[3],float out[3]) {
 if(!in||!out)return AGX_PROFILE_INVALID;
 for(int c=0;c<3;c++)if(!isfinite(in[c])||in[c]<0)return AGX_PROFILE_INVALID;
 int flags=0,base[3],order[3]={0,1,2}; float f[3];
 for(int c=0;c<3;c++) { double x=in[c]; if(x>AGX_HI){x=AGX_HI; flags|=AGX_PROFILE_CLAMP_HIGH;}
 double u=log1p(x/AGX_LO)/AGX_LOG_RANGE*(AGX_N-1); base[c]=(int)floor(u); if(base[c]>=AGX_N-1)base[c]=AGX_N-2; f[c]=(float)(u-base[c]); }
 for(int i=0;i<2;i++)for(int j=i+1;j<3;j++)if(f[order[j]]>f[order[i]]){int t=order[i];order[i]=order[j];order[j]=t;}
 int ix=(base[0]*AGX_N+base[1])*AGX_N+base[2];int stride[3]={AGX_N*AGX_N,AGX_N,1};
 uint16_t vertex[4][3]; int fetch_ix=ix;
#if GATHER
 uint32_t indices[4];for(int k=0;k<4;k++){indices[k]=(uint32_t)fetch_ix;if(k<3)fetch_ix+=stride[order[k]];}
 if(!lossless_fetch4(agx_encoded,sizeof agx_encoded,indices,vertex))return AGX_PROFILE_DECODE_ERROR;
#else
 for(int k=0;k<4;k++){if(!lossless_fetch(agx_encoded,sizeof agx_encoded,(uint32_t)fetch_ix,vertex[k]))return AGX_PROFILE_DECODE_ERROR;if(k<3)fetch_ix+=stride[order[k]];}
#endif
 float result[3];for(int c=0;c<3;c++)result[c]=((float)vertex[0][c]/65535.0f);
 for(int k=0;k<3;k++){int nx=ix+stride[order[k]]; for(int c=0;c<3;c++)result[c]+=f[order[k]]*(((float)vertex[k+1][c]/65535.0f)-((float)vertex[k][c]/65535.0f));ix=nx;}
 for(int c=0;c<3;c++) { out[c]=fminf(1,fmaxf(0,result[c])); }
 return flags;
}
