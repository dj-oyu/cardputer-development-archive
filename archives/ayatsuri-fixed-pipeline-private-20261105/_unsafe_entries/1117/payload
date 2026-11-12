#ifndef AGX_BLOCK_CACHE_H
#define AGX_BLOCK_CACHE_H
#include <stddef.h>
#include <stdint.h>
#define AGX_CACHE_SLOTS 4
#define AGX_CACHE_RECORD_MAX 396
#define AGX_PROFILE_DOMAIN_MAX 5898.240000132513
#define AGX_PROFILE_OK 0
#define AGX_PROFILE_CLAMP_HIGH 1
#define AGX_PROFILE_INVALID 2
#define AGX_PROFILE_DECODE_ERROR 3
/* Caller storage, internal fields: do not modify. No heap, ownership or lock. */
typedef struct {
 uint32_t block, start, end;
 uint16_t values[3][64];
 uint8_t encoded[AGX_CACHE_RECORD_MAX];
 uint8_t valid, age;
} agx_cache_entry;
typedef struct {
 const uint8_t *blob;
 size_t length;
 uint64_t hits, misses, invalidations;
 agx_cache_entry entries[AGX_CACHE_SLOTS];
} agx_block_cache;
void agx_cache_init(agx_block_cache *cache);
void agx_cache_clear(agx_block_cache *cache);
int agx_cache_bind(agx_block_cache *cache,const uint8_t *blob,size_t length);
int agx_cache_fetch4(agx_block_cache *cache,const uint32_t vertices[4],uint16_t rgb[4][3]);
int agx_cache_profile_eval(agx_block_cache *cache,const float in[3],float out[3]);
/* Explicit convenience bind to generated static const profile data. */
int agx_cache_bind_profile(agx_block_cache *cache);
#endif
