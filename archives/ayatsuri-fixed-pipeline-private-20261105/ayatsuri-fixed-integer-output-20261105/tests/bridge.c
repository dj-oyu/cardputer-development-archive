#include "integer_output.h"
#include "../private/shaper.h"
#include "../../fox-v3-indexed-bvh-bounds/cache/candidate_profile.c"
#include <math.h>
static agx_block_cache a,b;
int setup(void){agx_cache_init(&a);agx_cache_init(&b);return agx_cache_bind_profile(&a)&&agx_cache_bind_profile(&b);}
void batch(const double *in,unsigned n,uint16_t *old,uint16_t *neo,uint16_t *samecode,uint32_t *codes,int *status){
 for(unsigned i=0;i<n;i++){
  float f[3],out[3];uint32_t u[3];
  for(unsigned c=0;c<3;c++){double x=in[i*3+c];f[c]=(float)x;u[c]=(uint32_t)llrint(x*524288);codes[i*3+c]=u[c];}
  int r=agx_cache_profile_eval(&a,f,out);unsigned q[3];for(unsigned c=0;c<3;c++)q[c]=(unsigned)lroundf(out[c]*(c==1?63:31));old[i]=(q[0]<<11)|(q[1]<<5)|q[2];
  status[i]=integer_output(&b,&profile,u,&neo[i]);
  for(unsigned c=0;c<3;c++)f[c]=(float)((double)u[c]/524288);
  r|=agx_cache_profile_eval(&a,f,out);for(unsigned c=0;c<3;c++)q[c]=(unsigned)lroundf(out[c]*(c==1?63:31));samecode[i]=(q[0]<<11)|(q[1]<<5)|q[2];(void)r;
 }
}
uint32_t shape_code(uint32_t c){return integer_shape(&profile,c);}
