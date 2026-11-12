#include "integer_output.h"
#include <stdint.h>
static int overlaps(const void *x,size_t nx,const void *y,size_t ny){uintptr_t a=(uintptr_t)x,b=(uintptr_t)y;return nx&&ny&&(a<=b?b-a<nx:a-b<ny);}
uint32_t integer_shape(const integer_profile *p,uint32_t x){
 if(x>p->high_code)return 64u<<16;
 if(x<=256)return p->shape[x];
 unsigned e=31u-(unsigned)__builtin_clz(x),s=e-8u;
 uint32_t k=x>>s, rem=x-(k<<s);
 const uint32_t *t=p->shape+257u+(e-8u)*257u;
 uint32_t a=t[k-256u],b=t[k-255u];
 if(!s)return a;
 return a+(uint32_t)(((uint64_t)(b-a)*rem+(UINT64_C(1)<<(s-1)))>>s);
}
int integer_output(agx_block_cache *cache,const integer_profile *p,const uint32_t rgb[3],uint16_t *pixel){
 if(!cache||!p||!p->shape||!rgb||!pixel)return AGX_PROFILE_INVALID;
 if(overlaps(cache,sizeof *cache,rgb,12)||overlaps(cache,sizeof *cache,pixel,2)||overlaps(cache->blob,cache->length,pixel,2)||overlaps(p,sizeof *p,pixel,2)||overlaps(p->shape,25u*257u*4u,pixel,2)||overlaps(rgb,12,pixel,2))return AGX_PROFILE_INVALID;
 uint32_t base[3],f[3];unsigned o[3]={0,1,2};int flags=0;
 for(unsigned c=0;c<3;c++){if(rgb[c]>p->high_code)flags|=AGX_PROFILE_CLAMP_HIGH;uint32_t u=integer_shape(p,rgb[c]);base[c]=u>>16;if(base[c]>=64)base[c]=63;f[c]=u-(base[c]<<16);}
 /* Same strict > sorting network/order as pinned float implementation. */
 for(unsigned i=0;i<2;i++)for(unsigned j=i+1;j<3;j++)if(f[o[j]]>f[o[i]]){unsigned t=o[i];o[i]=o[j];o[j]=t;}
 const uint32_t stride[3]={4225,65,1};uint32_t ix=(base[0]*65+base[1])*65+base[2],indices[4];uint16_t v[4][3];
 for(unsigned k=0;k<4;k++){indices[k]=ix;if(k<3)ix+=stride[o[k]];}
 if(!agx_cache_fetch4(cache,indices,v))return AGX_PROFILE_DECODE_ERROR;
 uint32_t w[4]={65536-f[o[0]],f[o[0]]-f[o[1]],f[o[1]]-f[o[2]],f[o[2]]},q[3];
 for(unsigned c=0;c<3;c++){uint32_t a=0;for(unsigned k=0;k<4;k++)a+=(uint32_t)v[k][c]*w[k];
 /* Denominator = 65535*65536. Exact round-half-up of normalized weighted LUT. */
 q[c]=(uint32_t)(((uint64_t)a*(c==1?63:31)+UINT64_C(2147450880))/UINT64_C(4294901760));}
 *pixel=(uint16_t)((q[0]<<11)|(q[1]<<5)|q[2]);return flags;
}
