/* Generic host-only evaluator adapter; contains no profile data. */
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <math.h>
int agx_profile_eval(const float in[3], float out[3]);
void profile_batch(const float *in, size_t n, float *out, int *status, uint16_t *packed) {
 for(size_t i=0;i<n;i++) {
  float v[3]={0.123f,0.456f,0.789f};
  status[i]=agx_profile_eval(in+3*i,v);
  memcpy(out+3*i,v,sizeof v);
  packed[i]=status[i]<2 ? (uint16_t)(((unsigned)lroundf(v[0]*31)<<11)|((unsigned)lroundf(v[1]*63)<<5)|(unsigned)lroundf(v[2]*31)) : 0;
 }
}
uint64_t profile_bench(const float *in, size_t n, unsigned repeats) {
 uint64_t hash=0;
 for(unsigned j=0;j<repeats;j++)for(size_t i=0;i<n;i++) {
  float out[3];uint32_t bits[3];int status=agx_profile_eval(in+3*i,out);
  memcpy(bits,out,sizeof bits); hash+=bits[0]+(uint64_t)bits[1]+bits[2]+(unsigned)status;
 }
 return hash;
}
