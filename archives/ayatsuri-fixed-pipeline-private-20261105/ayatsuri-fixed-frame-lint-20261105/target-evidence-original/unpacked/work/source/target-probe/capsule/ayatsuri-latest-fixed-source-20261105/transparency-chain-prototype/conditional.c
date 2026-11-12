#include "conditional.h"
#include <string.h>
#if MBITS != 16 && MBITS != 20 && MBITS != 24
#error unsupported weight precision
#endif
#define SCALE (UINT32_C(1)<<MBITS)
int tc_mix(const tc_slot*s,uint64_t out[3]){
 if(!s||!out)return TC_INVALID;
 if(s->opaque_weight>SCALE||s->continued_weight>SCALE||s->continued_weight!=SCALE-s->opaque_weight)return TC_WEIGHT;
 uint64_t result[3];for(unsigned k=0;k<3;k++){
  if(s->opaque[k]>AA_SAMPLE_MAX||s->continued[k]>AA_SAMPLE_MAX)return TC_RANGE;
  /* Complementary weights bound the SUM by AA_SAMPLE_MAX*SCALE < 2^64.
   * Do not round either term, and do not add half-scale to this numerator. */
  uint64_t n=s->opaque[k]*s->opaque_weight+s->continued[k]*s->continued_weight;
  uint64_t q=n>>MBITS,r=n&(SCALE-1);result[k]=q+(r>SCALE/2||(r==SCALE/2&&(q&1)));
 }
 memcpy(out,result,sizeof result);return TC_OK;
}
int tc_block(const tc_input*in,unsigned width,agx_block_cache*cache,aa_result*out){
 if(!in||!cache||!out||(width!=1&&width!=2&&width!=4&&width!=8))return TC_INVALID;
 aa_result staged[8];for(unsigned lane=0;lane<width;lane++){
  aa_state sum;if(aa_init(&sum,4))return TC_REDUCE;
  for(unsigned j=0;j<4;j++){uint64_t rgb[3];int e=tc_mix(&in[lane].slot[j],rgb);if(e)return e;if(aa_put(&sum,j,AA_KEEP,rgb,0))return TC_REDUCE;}
  aa_status a=aa_finish(&sum,aa_private_profile,cache,&staged[lane]);if(a)return a==AA_ENCODE_ERROR?TC_ENCODE:TC_REDUCE;
 }
 memcpy(out,staged,width*sizeof *out);return TC_OK;
}
