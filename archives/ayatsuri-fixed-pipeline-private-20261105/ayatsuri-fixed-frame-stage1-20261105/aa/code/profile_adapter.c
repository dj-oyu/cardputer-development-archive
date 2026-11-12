#include "profile_adapter.h"
int aa_private_profile(void*ctx,const uint32_t hdr[3],uint16_t*out){return private_integer_profile_encode((agx_block_cache*)ctx,hdr,out);}
