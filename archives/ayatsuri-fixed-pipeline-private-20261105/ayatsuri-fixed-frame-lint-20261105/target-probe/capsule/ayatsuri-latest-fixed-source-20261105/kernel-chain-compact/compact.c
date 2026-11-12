#include "compact.h"
#include <string.h>
/* All inputs/cache/output must be disjoint and immutable except cache/output.
 * Batch output commits only after all lanes finish. Cache may warm on failure. */
static int compact_rho(int64_t x,uint16_t *out){if(!out||x<0||x>(INT64_C(1)<<MBITS))return KC_RHO;*out=(uint16_t)il_round((uint64_t)x*32767,UINT64_C(1)<<MBITS);return 0;}
static int lane(const mc_frame*f,const il_scene*s,const kc_input*in,agx_block_cache*c,aa_result*out){
 aa_result t;memset(&t,0,sizeof t);aa_state a;if(aa_init(&a,4))return KC_ACCUMULATE;
 for(unsigned j=0;j<4;j++){
  mc_output material;int32_t world[3],local[2];int16_t unit_normal[3];uint16_t rho[3];uint64_t radiance[3];
  const kc_slot*v=&in->slots[j];if((unsigned)v->bary[0]+v->bary[1]+v->bary[2]!=16384)return KC_INVALID;
  for(unsigned n=0;n<3;n++)for(unsigned k=0;k<3;k++)if(v->world[n][k]<-(8<<20)||v->world[n][k]>(8<<20))return KC_INVALID;
  for(unsigned n=0;n<3;n++)for(unsigned k=0;k<2;k++)if(v->local[n][k]<-(128LL<<20)||v->local[n][k]>(128LL<<20))return KC_INVALID;
  int16_t raw[3];for(unsigned k=0;k<3;k++){int64_t w=0,r=0;for(unsigned n=0;n<3;n++){w+=(int64_t)v->bary[n]*v->world[n][k];r+=(int64_t)v->bary[n]*v->normal[n][k];}world[k]=(int32_t)il_signed_round(il_signed_round(w,16384),16);raw[k]=(int16_t)il_signed_round(r,16384);}
  for(unsigned k=0;k<2;k++){int64_t x=0;for(unsigned n=0;n<3;n++)x+=(int64_t)v->bary[n]*v->local[n][k];int64_t q20=il_signed_round(x,16384);
#if MBITS == 16
q20=il_signed_round(q20,16);
#elif MBITS == 24
q20*=16;
#endif
if(q20<INT32_MIN||q20>INT32_MAX)return KC_INVALID;local[k]=(int32_t)q20;}
  if(mc_eval(f,local,&material))return KC_MATERIAL;
  if(material.mix!=(INT64_C(1)<<MBITS))return KC_NONOPAQUE;
  for(unsigned k=0;k<3;k++)if(compact_rho(material.color[k],&rho[k]))return KC_RHO;
  if(il_normalize_interpolated(raw,unit_normal))return KC_NORMAL;
  il_pixel p;memcpy(p.p,world,sizeof p.p);memcpy(p.normal,unit_normal,sizeof p.normal);memcpy(p.rho,rho,sizeof p.rho);memcpy(p.visible,v->visible,sizeof p.visible);
  if(il_eval(s,&p,radiance))return KC_LIGHT;
  if(aa_put(&a,j,AA_KEEP,radiance,0))return KC_ACCUMULATE;
 }
 if(aa_finish(&a,aa_private_profile,c,&t))return KC_ENCODE;
 *out=t;return 0;
}
int kcc_block(const mc_frame*f,const il_scene*s,const kc_input*in,unsigned n,agx_block_cache*c,aa_result*out){
 if(!f||!s||!in||!c||!out||(n!=1&&n!=2&&n!=4&&n!=8)||!il_scene_valid(s))return KC_INVALID;
 aa_result temp[8];for(unsigned i=0;i<n;i++){int e=lane(f,s,in+i,c,temp+i);if(e)return e;}memcpy(out,temp,n*sizeof *out);return 0;
}
