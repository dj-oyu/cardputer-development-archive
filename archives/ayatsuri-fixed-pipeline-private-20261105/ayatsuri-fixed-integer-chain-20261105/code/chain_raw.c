#include "chain.h"
#include "../../ayatsuri-fixed-integer-light-20261105/normal_bridge.h"
#include <string.h>
bool chain_block_raw_normals(const il_scene*s,const il_pixel*p,unsigned n,agx_block_cache*c,chain_result*out){
 if(!s||!p||!c||!out||(n!=1&&n!=2&&n!=4&&n!=8)||!il_scene_valid(s))return false;
 for(unsigned i=0;i<n;i++){il_pixel q=p[i];il_normal_status st=il_normalize_interpolated(q.normal,q.normal);if(st!=IL_NORMAL_OK){memset(out+i,0,sizeof *out);out[i].status=40+st;continue;}if(!chain_block(s,&q,1,c,out+i))return false;}
 return true;
}
