#ifndef ROW_PROFILE_CACHE_OWNER_H
#define ROW_PROFILE_CACHE_OWNER_H
#include "../cache/block_cache.h"
#include <stdlib.h>
static agx_block_cache *row_profile_cache_create(void *(*allocate)(size_t),void(*release)(void*)){
 if(!allocate||!release)return NULL;
 agx_block_cache *c=allocate(sizeof*c);if(!c)return NULL;
 agx_cache_init(c);if(!agx_cache_bind_profile(c)){agx_cache_clear(c);release(c);return NULL;}return c;
}
static void row_profile_cache_release(agx_block_cache **p,void(*release)(void*)){
 if(p&&*p&&release){agx_cache_clear(*p);release(*p);*p=NULL;}
}
#endif
