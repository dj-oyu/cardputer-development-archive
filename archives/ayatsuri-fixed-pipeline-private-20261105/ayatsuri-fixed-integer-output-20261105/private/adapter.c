/* PRIVATE profile adapter. Never publish this directory. No runtime float. */
#include "../code/private_adapter_api.h"
#include "shaper.h"
#include "profile_data.h"
int private_integer_profile_bind(agx_block_cache *cache){agx_cache_init(cache);return agx_cache_bind(cache,agx_encoded,sizeof agx_encoded);}
int private_integer_profile_encode(agx_block_cache *cache,const uint32_t hdr_q19[3],uint16_t *rgb565){return integer_output(cache,&profile,hdr_q19,rgb565);}
