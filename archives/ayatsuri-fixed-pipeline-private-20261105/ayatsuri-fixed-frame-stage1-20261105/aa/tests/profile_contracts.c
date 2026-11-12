#include "../code/profile_adapter.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
static unsigned calls;
static int counted(void*ctx,const uint32_t q[3],uint16_t*out){calls++;return aa_private_profile(ctx,q,out);}
static void fixture(aa_state*s,unsigned bright){assert(aa_init(s,4)==0);uint64_t z[3]={0},b[3]={(uint64_t)bright<<24,(uint64_t)bright<<24,(uint64_t)bright<<24};for(unsigned j=0;j<4;j++)assert(aa_put(s,j,AA_KEEP,j==3?b:z,0)==0);}
int main(void){agx_block_cache c;assert(private_integer_profile_bind(&c));aa_state s;aa_result r;fixture(&s,4);calls=0;assert(aa_finish(&s,counted,&c,&r)==0&&calls==1);uint32_t one[3]={1u<<19,1u<<19,1u<<19};uint16_t expected;assert(private_integer_profile_encode(&c,one,&expected)==0&&r.pixel==expected);
 uint16_t zero565,four565;uint32_t zero[3]={0},four[3]={4u<<19,4u<<19,4u<<19};assert(private_integer_profile_encode(&c,zero,&zero565)==0&&private_integer_profile_encode(&c,four,&four565)==0);unsigned packedmean[3],shift[3]={11,5,0},mask[3]={31,63,31};for(unsigned k=0;k<3;k++)packedmean[k]=(3*((zero565>>shift[k])&mask[k])+((four565>>shift[k])&mask[k])+2)/4;uint16_t wrong=(packedmean[0]<<11)|(packedmean[1]<<5)|packedmean[2];assert(wrong!=r.pixel);
 /* Per-sample HDR can exceed output Q19 range; only the averaged HDR must fit. */
 fixture(&s,20000);assert(aa_finish(&s,counted,&c,&r)==0&&r.hdr19[0]==5000u*524288&&r.high_clamped==0);
 fixture(&s,30000);assert(aa_finish(&s,counted,&c,&r)==0&&r.hdr19[0]==7500u*524288&&r.high_clamped==1);
 fixture(&s,40000);aa_result saved=r;assert(aa_finish(&s,counted,&c,&r)==AA_HDR19_OVERFLOW&&!memcmp(&r,&saved,sizeof r));
 /* Replacement is not blending: unselected overflowing original is ignored. */
 aa_init(&s,1);uint64_t poison[3]={UINT64_MAX,UINT64_MAX,UINT64_MAX},replacement[3]={1u<<24,1u<<24,1u<<24};assert(aa_put(&s,0,AA_REPLACE,poison,replacement)==0&&aa_finish(&s,counted,&c,&r)==0&&r.pixel==expected);
 agx_cache_clear(&c);saved=r;assert(aa_finish(&s,counted,&c,&r)==AA_ENCODE_ERROR&&!memcmp(&r,&saved,sizeof r));
 printf("PASS real profile exactly once aftermean, pack-before-average counterexample correct=%u wrong=%u, late clamp, late overflow, replacement, decode error atomicity\n",expected,wrong);return 0;}
