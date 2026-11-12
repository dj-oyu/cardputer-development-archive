#include "chain.h"
#include <stdlib.h>
void* ref_cache(void){agx_block_cache*c=malloc(sizeof *c);if(!c||!private_integer_profile_bind(c)){free(c);return 0;}return c;}
void ref_free(void*c){free(c);}
int ref_normal(const int16_t*x,int16_t*y){return il_normalize_interpolated(x,y);}
int ref_light(const il_scene*s,const il_pixel*p,uint64_t*out){return il_eval(s,p,out);}
size_t ref_size(unsigned i){size_t a[]={sizeof(mc_frame),sizeof(kc_slot),sizeof(kc_input),sizeof(kc_output),sizeof(agx_block_cache),sizeof(aa_state),sizeof(il_scene)};return i<7?a[i]:0;}
