#include "../implementation/block_cache.h"
#include <assert.h>
#include <math.h>
#include <string.h>
#include <stdio.h>
static unsigned calls;
int forced_failure(agx_block_cache*c,const uint32_t v[4],uint16_t o[4][3]){(void)c;(void)v;(void)o;calls++;return 0;}
int main(void){agx_block_cache c;agx_cache_init(&c);float out[3]={.12f,.34f,.56f},saved[3];memcpy(saved,out,12);float v[3]={1,2,3};assert(agx_cache_profile_eval(&c,v,out)==3);assert(calls==1&&!memcmp(out,saved,12));memcpy(v,saved,12);assert(agx_cache_profile_eval(&c,v,v)==3);assert(calls==2&&!memcmp(v,saved,12));
 float bad[4]={NAN,INFINITY,-INFINITY,-.00001f};for(unsigned k=0;k<4;k++)for(unsigned j=0;j<3;j++){float a[3]={1,2,3};a[j]=bad[k];assert(agx_cache_profile_eval(&c,a,out)==2);assert(calls==2&&!memcmp(out,saved,12));}
 agx_block_cache before=c;assert(agx_cache_profile_eval(&c,v,(float*)(void*)&c)==2);assert(!memcmp(&c,&before,sizeof c));assert(agx_cache_profile_eval(&c,(float*)(void*)&c,out)==2);assert(calls==2);puts("PASS forced decode failure transactional normal/aliased output; invalid HDR does not decode; context alias rejected");}
