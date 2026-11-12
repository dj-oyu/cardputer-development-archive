#include "attributes.h"
#include <string.h>
bool chain_attributes(const il_pixel v[3],const int16_t w[3],il_pixel*out){
 if(!v||!w||!out)return false;unsigned sum=0;for(unsigned j=0;j<3;j++){if(w[j]<0||w[j]>16384||!il_position(v[j].p)||!il_normal_length(v[j].normal))return false;sum+=(unsigned)w[j];for(unsigned k=0;k<3;k++)if(v[j].rho[k]>32767)return false;}if(sum!=16384)return false;
 il_pixel p;memset(&p,0,sizeof p);int64_t raw[3];uint64_t norm2=0;
 for(unsigned k=0;k<3;k++){int64_t pos=0,n=0;uint64_t rho=0;for(unsigned j=0;j<3;j++){pos+=(int64_t)v[j].p[k]*w[j];n+=(int64_t)v[j].normal[k]*w[j];rho+=(uint64_t)v[j].rho[k]*w[j];}p.p[k]=(int32_t)il_signed_round(pos,16384);raw[k]=il_signed_round(n,16384);norm2+=(uint64_t)(raw[k]*raw[k]);p.rho[k]=(uint16_t)il_round(rho,16384);p.visible[k]=65535;}
 /* Reject near-cancelled interpolated normals; no guessed fallback normal. */
 if(norm2<UINT64_C(1024)*1024)return false;uint64_t norm=il_sqrt(norm2<<16);
 for(unsigned k=0;k<3;k++){int64_t n=il_signed_round(raw[k]*32767*256,norm);if(n<-32767||n>32767)return false;p.normal[k]=(int16_t)n;}
 if(!il_normal_length(p.normal))return false;*out=p;return true;
}
