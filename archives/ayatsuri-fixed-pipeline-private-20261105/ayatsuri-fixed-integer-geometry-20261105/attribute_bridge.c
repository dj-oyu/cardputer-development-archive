#include "attribute_bridge.h"
#include "../ayatsuri-fixed-integer-light-20261105/normal_bridge.h"
#include "../ayatsuri-fixed-pipeline-20261105/kernel/fixed_kernel.h"
#include <string.h>
ab_status ab_prepare(const ab_vertex v[3],const int16_t w[3],int frac,int backface,const uint16_t visible[3],ab_hit *out){
 if(!v||!w||!visible||!out||(frac!=16&&frac!=20)||(backface!=0&&backface!=1))return AB_INVALID;
 int sum=0;int64_t max_source=INT64_C(128)*(INT64_C(1)<<frac);
 for(int j=0;j<3;j++){
  if(w[j]<0||w[j]>16384)return AB_INVALID;
  sum+=w[j];if(!il_normal_length(v[j].native_normal))return AB_INVALID;
  if(v[j].depth_q10<-(INT32_C(4096)<<10)||v[j].depth_q10>(INT32_C(4096)<<10))return AB_INVALID;
  for(int k=0;k<3;k++)if(v[j].native_position[k]<-max_source||v[j].native_position[k]>max_source||v[j].rho[k]<0)return AB_INVALID;
 }
 if(sum!=16384)return AB_INVALID;
 ab_hit hit;memset(&hit,0,sizeof hit);int16_t native_n[3];int32_t native_light[3];
 int64_t max_hit=INT64_C(8)*(INT64_C(1)<<frac)*16384;
 for(int k=0;k<3;k++){
  int64_t acc=0;int16_t normal[3],rho[3],r;
  for(int j=0;j<3;j++){acc+=(int64_t)v[j].native_position[k]*w[j];normal[j]=v[j].native_normal[k];rho[j]=v[j].rho[k];}
  if(acc < -max_hit||acc>max_hit)return AB_LIGHT_RANGE;
  hit.native_position[k]=(int32_t)il_signed_round(acc,16384);
  native_light[k]=(int32_t)il_signed_round(acc,UINT64_C(1)<<(14+frac-16));
  if(!fk_scalar(w,normal,&native_n[k])||!fk_scalar(w,rho,&r))return AB_INVALID;
  hit.pixel.rho[k]=(uint16_t)r;hit.pixel.visible[k]=visible[k];
 }
 hit.pixel.p[0]=native_light[0];hit.pixel.p[1]=-native_light[2];hit.pixel.p[2]=-native_light[1];
 int16_t world_n[3]={native_n[0],(int16_t)-native_n[2],(int16_t)-native_n[1]};
 if(backface)for(int k=0;k<3;k++)world_n[k]=(int16_t)-world_n[k];
 if(il_normalize_interpolated(world_n,hit.pixel.normal)!=IL_NORMAL_OK)return AB_NORMAL_FALLBACK;
 int64_t depth=0;for(int j=0;j<3;j++)depth+=(int64_t)v[j].depth_q10*w[j];
 hit.depth_q10=(int32_t)il_signed_round(depth,16384);*out=hit;return AB_OK;
}
bool ab_block(const ab_vertex v[][3],const int16_t w[][3],int frac,const int backface[],const uint16_t visible[][3],unsigned count,ab_hit out[],ab_status status[]){
 if(!v||!w||!backface||!visible||!out||!status||(count!=1&&count!=2&&count!=4&&count!=8))return false;
 for(unsigned i=0;i<count;i++)status[i]=ab_prepare(v[i],w[i],frac,backface[i],visible[i],out+i);
 return true;
}
