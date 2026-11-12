#include "../code/radiance_bridge.h"
#include "../../aa/code/profile_adapter.h"
#include "../../reflection/integer_reflection.h"
#include <assert.h>
#include <stdio.h>
static unsigned calls;
static int encode(void*c,const uint32_t q[3],uint16_t*p){calls++;return aa_private_profile(c,q,p);}
int main(void){
 /* Frozen reducer supplied terms only: all direct/world max, rho=1. */
 hr_fixed_sample samples[16]={0};uint16_t rho[3]={32767,32767,32767};for(unsigned i=0;i<16;i++){samples[i].active=1;for(unsigned k=0;k<3;k++){samples[i].direct[k]=UINT32_MAX;samples[i].world[k]=UINT32_MAX;samples[i].rho_secondary[k]=32767;}}
 rb_rgb_q19 reflected;assert(hr_reduce16(samples,rho,reflected.channel));for(unsigned k=0;k<3;k++)assert(reflected.channel[k]==(UINT64_C(1)<<33)-2);rb_rgb_q24 converted;assert(rb_q19_to_q24(&reflected,&converted)==0);for(unsigned k=0;k<3;k++)assert(converted.channel[k]==(UINT64_C(1)<<38)-64);
 aa_state state;assert(aa_init(&state,4)==0);rb_rgb_q24 direct={{1u<<24,1u<<24,1u<<24}};for(unsigned slot=0;slot<4;slot++){rb_rgb_q19 supplied_reflection={{(uint64_t)slot<<19,(uint64_t)slot<<19,(uint64_t)slot<<19}};rb_rgb_q24 merged;assert(rb_merge(&direct,1,&supplied_reflection,&merged)==0);assert(aa_put(&state,slot,AA_KEEP,merged.channel,0)==0);}uint32_t hdr[3];assert(aa_reduce(&state,hdr)==0);for(unsigned k=0;k<3;k++)assert(hdr[k]==5u*262144); /* mean(1,2,3,4)=2.5 */
 agx_block_cache cache;assert(private_integer_profile_bind(&cache));aa_result result;calls=0;assert(aa_finish(&state,encode,&cache,&result)==0&&calls==1);uint16_t reference;assert(private_integer_profile_encode(&cache,hdr,&reference)==0&&reference==result.pixel);
 /* Keep world/primary weighting ownership outside this arithmetic seam:
    reducer reflection is merged once, not multiplied by rho again. */
 printf("PASS frozen_reducer_bound_Q19=%llu exact_Q24=%llu merged_four_slots_mean_Q19=%u profile_calls=%u rgb565=%u\n",(unsigned long long)reflected.channel[0],(unsigned long long)converted.channel[0],hdr[0],calls,result.pixel);return 0;}
