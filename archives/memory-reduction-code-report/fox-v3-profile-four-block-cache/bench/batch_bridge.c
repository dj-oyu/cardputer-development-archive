/* Host-only adapter. No profile data. Identical loop/checksum across arms. */
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#if CACHE_ARM
#include "block_cache.h"
static agx_block_cache context;
#define EVAL(in,out) agx_cache_profile_eval(&context,in,out)
#else
int agx_profile_eval(const float in[3],float out[3]);
#define EVAL(in,out) agx_profile_eval(in,out)
#endif
int profile_setup(void) {
#if CACHE_ARM
 return agx_cache_bind_profile(&context);
#else
 return 1;
#endif
}
size_t profile_context_size(void) {
#if CACHE_ARM
 return sizeof context;
#else
 return 0;
#endif
}
void profile_counters(uint64_t out[3]) {
#if CACHE_ARM
 out[0]=context.hits;out[1]=context.misses;out[2]=context.invalidations;
#else
 out[0]=out[1]=out[2]=0;
#endif
}
uint64_t profile_bench(const float *in,size_t n) {
 uint64_t hash=0;
 for(size_t i=0;i<n;i++) {
  float out[3]={0.123f,0.456f,0.789f}; uint32_t bits[3];
  int status=EVAL(in+3*i,out);
  if(status>=2)return UINT64_MAX;
  memcpy(bits,out,sizeof bits);hash+=bits[0]+(uint64_t)bits[1]+bits[2]+(unsigned)status;
 }
 return hash;
}
