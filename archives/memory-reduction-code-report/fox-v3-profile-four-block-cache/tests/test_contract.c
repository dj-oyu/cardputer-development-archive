#include "block_cache.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
static void put32(uint8_t *p,unsigned v){for(unsigned i=0;i<4;i++)p[i]=(uint8_t)(v>>(i*8));}
static uint8_t *make(size_t *n){
 *n=19688+4913*12;uint8_t *p=calloc(1,*n);assert(p);
 memcpy(p,"AGXL4R01",8);p[8]=65;p[10]=4;put32(p+12,4913);put32(p+16,(unsigned)*n);put32(p+20,32);put32(p+24,19688);
 for(unsigned i=0;i<=4913;i++)put32(p+32+4*i,i*12);
 for(unsigned i=0;i<4913;i++)for(unsigned c=0;c<3;c++){p[19688+i*12+c*4+2]=(uint8_t)(100+c);}
 return p;
}
static void fetch(agx_block_cache *c,unsigned block){uint32_t v[4]={block*4,block*4,block*4,block*4};uint16_t out[4][3];assert(agx_cache_fetch4(c,v,out));for(unsigned i=0;i<4;i++)for(unsigned k=0;k<3;k++)assert(out[i][k]==100+k);}
int main(void){
 size_t n;uint8_t *p=make(&n);agx_block_cache c,before;uint32_t v[4]={0,1,2,3};uint16_t out[4][3],saved[4][3];memset(out,0x5a,sizeof out);memcpy(saved,out,sizeof out);
 agx_cache_init(&c);assert(!agx_cache_fetch4(&c,v,out));assert(!memcmp(out,saved,sizeof out));assert(agx_cache_bind(&c,p,n));
 fetch(&c,0);fetch(&c,1);fetch(&c,2);fetch(&c,3);fetch(&c,1);fetch(&c,4);
 int has[5]={0};for(unsigned i=0;i<4;i++)has[c.entries[i].block]=1;assert(!has[0]&&has[1]&&has[2]&&has[3]&&has[4]);
 assert(!agx_cache_bind(&c,NULL,SIZE_MAX));assert(!c.blob&&!c.length);assert(agx_cache_bind(&c,p,n));
 before=c;assert(!agx_cache_bind(&c,(const uint8_t*)&c,sizeof c));assert(!memcmp(&c,&before,sizeof c));
 assert(agx_cache_bind(&c,p,n));assert(c.hits==0&&c.misses==0);fetch(&c,0);
 p[19688+2]=150;assert(agx_cache_fetch4(&c,v,out)&&out[0][0]==150&&c.invalidations==1);
 p[19688]=4;memcpy(out,saved,sizeof out);assert(!agx_cache_fetch4(&c,v,out));assert(!memcmp(out,saved,sizeof out));
 p[19688]=0;p[19688+2]=100;fetch(&c,0); /* A -> B -> A live-storage reuse */
 p[0]='X';memcpy(out,saved,sizeof out);assert(!agx_cache_fetch4(&c,v,out));assert(!memcmp(out,saved,sizeof out));assert(!agx_cache_bind(&c,p,n));assert(!c.blob&&!c.length);p[0]='A';
 assert(agx_cache_bind(&c,p,n));before=c;assert(!agx_cache_fetch4(&c,v,(uint16_t(*)[3])&c));assert(!memcmp(&c,&before,sizeof c));
 assert(!agx_cache_fetch4(&c,(const uint32_t*)&c,out));assert(!memcmp(&c,&before,sizeof c));
 uint8_t old[24];memcpy(old,p,24);assert(!agx_cache_fetch4(&c,v,(uint16_t(*)[3])p));assert(!memcmp(old,p,24));
 union {uint32_t v[6];uint16_t rgb[4][3];} alias;for(unsigned i=0;i<4;i++)alias.v[i]=i;
 assert(agx_cache_fetch4(&c,alias.v,alias.rgb));assert(alias.rgb[3][2]==102);
 v[3]=274625;memcpy(out,saved,sizeof out);assert(!agx_cache_fetch4(&c,v,out));assert(!memcmp(out,saved,sizeof out));v[3]=3;
 /* Failure in a later selected block must not expose earlier decoded values. */
 v[3]=4;p[19688+12]=4;memcpy(out,saved,sizeof out);assert(!agx_cache_fetch4(&c,v,out));assert(!memcmp(out,saved,sizeof out));p[19688+12]=0;v[3]=3;
 /* Each live valid age is unique and contiguous after invalidation/failure. */
 fetch(&c,1);fetch(&c,2);fetch(&c,3);p[19688+24]=4;uint32_t q[4]={8,8,8,8};assert(!agx_cache_fetch4(&c,q,out));p[19688+24]=0;fetch(&c,2);
 unsigned ranks=0,count=0;for(unsigned i=0;i<4;i++)if(c.entries[i].valid){ranks|=1u<<c.entries[i].age;count++;}assert(ranks==(1u<<count)-1);
 float in[3]={1,2,3},fout[3]={.2f,.3f,.4f},fsaved[3];assert(agx_cache_profile_eval(&c,in,fout)==0);
 memcpy(fsaved,fout,sizeof fout);in[0]=NAN;assert(agx_cache_profile_eval(&c,in,fout)==AGX_PROFILE_INVALID);assert(!memcmp(fsaved,fout,sizeof fout));in[0]=1;
 agx_cache_clear(&c);assert(!c.blob&&!c.length);assert(agx_cache_profile_eval(&c,in,fout)==AGX_PROFILE_DECODE_ERROR);assert(!memcmp(fsaved,fout,sizeof fout));free(p);
 assert(agx_cache_bind_profile(&c));assert(agx_cache_profile_eval(&c,in,in)==0);agx_cache_clear(&c);
 printf("PASS contract lifecycle, alias, mutation/ABA, malformed atomic output, exact LRU; cache=%zu entry=%zu\n",sizeof c,sizeof(agx_cache_entry));return 0;
}
