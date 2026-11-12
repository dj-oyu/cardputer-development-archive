#include "conditional.h"
#include <assert.h>
#include <string.h>
#include <stdio.h>
#if MBITS==16
#include "fixtures-q16.inc"
#elif MBITS==20
#include "fixtures-q20.inc"
#else
#include "fixtures-q24.inc"
#endif
#define S (1u<<MBITS)
static uint64_t oracle(uint32_t w,uint64_t a,uint64_t b){__uint128_t n=(__uint128_t)w*a+(__uint128_t)(S-w)*b;uint64_t q=n/S,r=n%S;return q+(r>S/2||(r==S/2&&(q&1)));}
int main(void){
 agx_block_cache c;assert(private_integer_profile_bind(&c));tc_input in[8];aa_result out[8],before[8];unsigned total=sizeof source_inputs/sizeof *source_inputs;
 for(unsigned i=0;i<total;i++){
  uint64_t sum[3]={0};for(unsigned j=0;j<4;j++){uint64_t rgb[3];assert(!tc_mix(&source_inputs[i].slot[j],rgb));for(unsigned k=0;k<3;k++){assert(rgb[k]==oracle(source_inputs[i].slot[j].opaque_weight,source_inputs[i].slot[j].opaque[k],source_inputs[i].slot[j].continued[k]));sum[k]+=rgb[k];}}
  assert(!tc_block(source_inputs+i,1,&c,out));for(unsigned k=0;k<3;k++){uint64_t q=sum[k]/128,r=sum[k]%128;assert(out[0].hdr19[k]==q+(r>64||(r==64&&(q&1))));}
 }
 for(unsigned n=1;n<=8;n*=2){for(unsigned i=0;i<n;i++)in[i]=source_inputs[0];assert(!tc_block(in,n,&c,out));for(unsigned i=1;i<n;i++)assert(!memcmp(out,out+i,sizeof *out));
  for(unsigned bad=0;bad<4;bad++){tc_input saved=in[n-1];if(bad==0)in[n-1].slot[3].opaque_weight=S+1;if(bad==1)in[n-1].slot[3].continued_weight^=1;if(bad==2)in[n-1].slot[3].opaque[2]=UINT64_MAX;if(bad==3)in[n-1].slot[3].continued[2]=AA_SAMPLE_MAX+1;
   memset(out,0x58,sizeof out);memcpy(before,out,sizeof out);assert(tc_block(in,n,&c,out));assert(!memcmp(out,before,sizeof out));in[n-1]=saved;
  }
  agx_block_cache empty;agx_cache_init(&empty);assert(tc_block(in,n,&empty,out)==TC_ENCODE);assert(!memcmp(out,before,sizeof out));
  for(unsigned j=0;j<4;j++)for(unsigned k=0;k<3;k++)in[n-1].slot[j].opaque[k]=in[n-1].slot[j].continued[k]=AA_SAMPLE_MAX;
  assert(tc_block(in,n,&c,out)==TC_REDUCE);assert(!memcmp(out,before,sizeof out));
 }
 tc_slot t={S/2,S/2,{1,3,AA_SAMPLE_MAX},{1,0,AA_SAMPLE_MAX}};uint64_t z[3];assert(!tc_mix(&t,z));assert(z[0]==1&&z[1]==2&&z[2]==AA_SAMPLE_MAX); /* separate term rounding would give0 for first channel */
 uint32_t weights[]={0,1,S/2-1,S/2,S/2+1,S-1,S};uint64_t vals[]={0,1,2,3,AA_SAMPLE_MAX-1,AA_SAMPLE_MAX};
 for(unsigned w=0;w<7;w++)for(unsigned a=0;a<6;a++)for(unsigned b=0;b<6;b++){t.opaque_weight=weights[w];t.continued_weight=S-weights[w];for(int k=0;k<3;k++){t.opaque[k]=vals[a];t.continued[k]=vals[b];}assert(!tc_mix(&t,z));assert(z[0]==oracle(weights[w],vals[a],vals[b]));}
 for(unsigned j=0;j<4;j++){tc_slot*v=&in[0].slot[j];v->opaque_weight=j%2?S:0;v->continued_weight=S-v->opaque_weight;for(int k=0;k<3;k++){v->opaque[k]=j%2?0:3200;v->continued[k]=j%2?3200:0;}}
 assert(!tc_block(in,1,&c,out));assert(out[0].hdr19[0]==0&&out[0].hdr19[1]==0&&out[0].hdr19[2]==0);
 for(unsigned j=0;j<4;j++)for(int k=0;k<3;k++)in[0].slot[j].opaque[k]=in[0].slot[j].continued[k]=UINT64_C(3092376454)*32;
 assert(!tc_block(in,1,&c,out));assert(out[0].high_clamped==1);
 memset(out,0x58,sizeof out);memcpy(before,out,sizeof out);assert(tc_block(in,3,&c,out)==TC_INVALID);assert(!memcmp(out,before,sizeof out));printf("PASS %u material-weight groups (2635 latest geometry +18 synthetic-local supplemental); wide-integer oracle, endpoints, one-round ties, max bounds, width1/2/4/8 last-lane errors/atomicity\n",total);return 0;
}
