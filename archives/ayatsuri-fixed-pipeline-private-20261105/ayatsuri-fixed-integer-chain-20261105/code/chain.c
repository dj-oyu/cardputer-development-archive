#include "chain.h"
#include <string.h>
bool chain_block(const il_scene*s,const il_pixel*p,unsigned n,agx_block_cache*c,chain_result*out){
 if(!s||!p||!c||!out||(n!=1&&n!=2&&n!=4&&n!=8)||!il_scene_valid(s))return false;
 uint64_t h[8][3];il_status st[8];if(!il_block(s,p,n,h,st))return false;
 for(unsigned i=0;i<n;i++){chain_result r;memset(&r,0,sizeof r);r.status=10+st[i];
 if(st[i]==IL_OK){uint32_t q[3];if(!il_hdr19(h[i],q))r.status=20;else{uint16_t px;int a=private_integer_profile_encode(c,q,&px);r.status=a<=1?a:30+a;if(a<=1){memcpy(r.hdr24,h[i],sizeof r.hdr24);memcpy(r.hdr19,q,sizeof r.hdr19);r.pixel=px;}}}out[i]=r;}
 return true;
}
