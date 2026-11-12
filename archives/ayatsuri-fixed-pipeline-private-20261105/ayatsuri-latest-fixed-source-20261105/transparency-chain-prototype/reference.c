#include "conditional.h"
#include <stdlib.h>
void* ref_cache(void){agx_block_cache*c=malloc(sizeof *c);if(!c||!private_integer_profile_bind(c)){free(c);return 0;}return c;}
void ref_free(void*c){free(c);}
size_t ref_size(unsigned i){const size_t a[]={sizeof(tc_slot),sizeof(tc_input),sizeof(aa_result),sizeof(aa_state),sizeof(agx_block_cache)};return i<5?a[i]:0;}
