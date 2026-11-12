/* Single encoded static profile, explicit cache and stateless legacy bridge. */
#include "../cache/candidate_profile.c"
#include "../cache/gather_profile.inc"
const void *row_profile_storage(size_t *bytes){*bytes=sizeof agx_encoded;return agx_encoded;}
int row_profile_is_bound(const agx_block_cache *c){return c&&c->blob==agx_encoded&&c->length==sizeof agx_encoded;}
