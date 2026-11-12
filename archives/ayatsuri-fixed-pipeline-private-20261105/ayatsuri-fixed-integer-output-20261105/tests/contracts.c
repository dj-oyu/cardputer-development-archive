#include "integer_output.h"
#include "../private/shaper.h"
#include "../../fox-v3-indexed-bvh-bounds/cache/candidate_profile.c"
#include <assert.h>
#include <stdio.h>
#include <string.h>
int main(void){agx_block_cache c;agx_cache_init(&c);assert(agx_cache_bind_profile(&c));uint32_t in[3]={0,0,0};uint16_t out=123;
 assert(integer_output(&c,&profile,in,&out)==0);assert(integer_output(0,&profile,in,&out)==2);assert(integer_output(&c,0,in,&out)==2);assert(integer_output(&c,&profile,0,&out)==2);assert(integer_output(&c,&profile,in,0)==2);
 for(unsigned channel=0;channel<3;channel++){in[channel]=UINT32_MAX;assert(integer_output(&c,&profile,in,&out)==1);in[channel]=0;}
 in[0]=profile.high_code;assert(integer_output(&c,&profile,in,&out)==0);in[0]++;assert(integer_output(&c,&profile,in,&out)==1);
 assert(integer_output(&c,&profile,in,(uint16_t*)in)==2);assert(integer_output(&c,&profile,in,(uint16_t*)&c)==2);
 agx_cache_clear(&c);out=123;assert(integer_output(&c,&profile,in,&out)==3);assert(out==123);
 /* Endpoint and all six ordering permutations plus tied-fraction edges. */
 assert(agx_cache_bind_profile(&c));unsigned perms[6][3]={{0,1,2},{0,2,1},{1,0,2},{1,2,0},{2,0,1},{2,1,0}};
 uint32_t sample[3]={123,4567,89012};for(unsigned i=0;i<6;i++){for(unsigned j=0;j<3;j++)in[j]=sample[perms[i][j]];assert(integer_output(&c,&profile,in,&out)==0);}
 for(unsigned i=0;i<100000;i++){uint32_t x=i*42949u;in[0]=in[1]=in[2]=x;assert(integer_output(&c,&profile,in,&out)==(x>profile.high_code));}
 puts("contracts OK");return 0;}
