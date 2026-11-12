#include "../implementation/block_cache.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(void){agx_block_cache c;agx_cache_init(&c);assert(agx_cache_bind_profile(&c));uint32_t v[4]={0,1,65,4225};uint16_t out[4][3];assert(agx_cache_fetch4(&c,v,out));agx_block_cache before=c;assert(!agx_cache_bind(&c,(uint8_t*)(void*)&c,sizeof c));assert(!memcmp(&c,&before,sizeof c));assert(agx_cache_fetch4(&c,v,out));assert(!agx_cache_bind(&c,NULL,SIZE_MAX));assert(!c.blob&&!c.length);uint16_t saved[4][3];memcpy(saved,out,sizeof out);assert(!agx_cache_fetch4(&c,v,out));assert(!memcmp(saved,out,sizeof out));
 assert(agx_cache_bind_profile(&c));assert(agx_cache_fetch4(&c,v,out));assert(agx_cache_bind_profile(&c));for(unsigned j=0;j<4;j++)assert(!c.entries[j].valid);assert(!c.hits&&!c.misses);agx_cache_clear(&c);puts("PASS forbidden alias bind preserves cache/source; ordinary failed bind unbinds; same pointer bind resets slots/counters");}
