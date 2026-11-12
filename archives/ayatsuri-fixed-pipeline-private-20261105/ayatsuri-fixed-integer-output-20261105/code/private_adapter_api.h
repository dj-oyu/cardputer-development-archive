#ifndef PRIVATE_ADAPTER_API_H
#define PRIVATE_ADAPTER_API_H
#include "integer_output.h"
/* Implementation requires local-only private profile; do not ship table. */
int private_integer_profile_bind(agx_block_cache *cache);
int private_integer_profile_encode(agx_block_cache *cache,const uint32_t hdr_q19[3],uint16_t *rgb565);
#endif
