#include "../implementation/block_cache.h"
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "../../fox-v3-profile-integration-feasibility/build-private/agx_lut.inc"
int lossless_fetch4(const uint8_t*,size_t,const uint32_t[4],uint16_t[4][3]);
static uint32_t seed=8263941;static uint32_t rnd(void){seed^=seed<<13;seed^=seed>>17;seed^=seed<<5;return seed;}
static uint32_t rd(const uint8_t*p){return p[0]+256u*p[1]+65536u*p[2]+16777216u*p[3];}
static void wr(uint8_t*p,uint32_t v){for(int i=0;i<4;i++)p[i]=(uint8_t)(v>>(8*i));}
static unsigned block(uint32_t v){return ((v/4225/4)*17+(v/65%65)/4)*17+(v%65)/4;}
static uint32_t origin(unsigned b){return ((b/289*4)*65+(b/17%17*4))*65+b%17*4;}
static void reject(agx_block_cache*c,const uint32_t*v){uint16_t out[4][3],copy[4][3];memset(out,0xa5,sizeof out);memcpy(copy,out,sizeof out);assert(!agx_cache_fetch4(c,v,out));assert(!memcmp(out,copy,sizeof out));}
static void compare(agx_block_cache*c,uint8_t*p,size_t n,uint32_t*v){uint16_t a[4][3],b[4][3];memset(a,0xa5,sizeof a);memset(b,0xa5,sizeof b);int x=agx_cache_fetch4(c,v,a),y=lossless_fetch4(p,n,v,b);assert(x==y&&!memcmp(a,b,sizeof a));}
int main(int argc,char**argv){assert(argc==2);agx_block_cache c;agx_cache_init(&c);uint32_t v[4]={0,1,65,4225};uint16_t out[4][3];reject(&c,v);
 const size_t sn=19688+4913*12;uint8_t*s=calloc(sn,1);assert(s);memcpy(s,"AGXL4R01",8);s[8]=65;s[10]=4;wr(s+12,4913);wr(s+16,sn);wr(s+20,32);wr(s+24,19688);for(unsigned b=0;b<=4913;b++)wr(s+32+4*b,b*12);for(unsigned b=0;b<4913;b++)for(unsigned k=0;k<3;k++){unsigned t=b+k*7000;s[19688+b*12+k*4+2]=t&255;s[19688+b*12+k*4+3]=t>>8;}
 assert(agx_cache_bind(&c,s,sn));for(unsigned b=0;b<4913;b++){for(unsigned k=0;k<4;k++)v[k]=origin(b);assert(agx_cache_fetch4(&c,v,out));for(unsigned k=0;k<4;k++)for(unsigned ch=0;ch<3;ch++)assert(out[k][ch]==b+ch*7000);}
 /* Independent exact-LRU order oracle with repeated hits and live mutations. */
 assert(agx_cache_bind(&c,s,sn));unsigned lru[4]={0},count=0;
 for(unsigned t=0;t<20000;t++){unsigned bi=rnd()%9;for(unsigned j=0;j<4;j++)v[j]=origin(bi);if(t%3==0)s[19688+bi*12+2]^=0x33;compare(&c,s,sn,v);
 unsigned pos=0;while(pos<count&&lru[pos]!=bi)pos++;if(pos==count&&count<4)count++;for(unsigned j=pos<4?pos:3;j>0;j--)lru[j]=lru[j-1];lru[0]=bi;
 unsigned found=0;for(unsigned j=0;j<4;j++)if(c.entries[j].valid){assert(c.entries[j].age<count);assert(c.entries[j].block==lru[c.entries[j].age]);found++;}assert(found==count);}
 /* Repeated live same-address A/B/A replacement, selected mutation detection. */
 for(unsigned i=0;i<1000;i++){unsigned b=rnd()%4913;for(unsigned j=0;j<4;j++)v[j]=origin(b);compare(&c,s,sn,v);s[19688+b*12+2]^=0x55;compare(&c,s,sn,v);s[19688+b*12+2]^=0x55;compare(&c,s,sn,v);assert(agx_cache_bind(&c,s,sn));assert(c.hits==0&&c.misses==0);compare(&c,s,sn,v);}
 /* Transactional failure at every selected corner, after valid earlier corners. */
 for(unsigned j=0;j<4;j++)v[j]=origin(j);for(unsigned fail=0;fail<4;fail++){assert(agx_cache_bind(&c,s,sn));compare(&c,s,sn,v);s[19688+fail*12]=4;reject(&c,v);s[19688+fail*12]=0;compare(&c,s,sn,v);}
 /* Full bind index validation catches unselected bad entry. */
 wr(s+32+4000*4,0);assert(!agx_cache_bind(&c,s,sn));assert(!c.blob&&!c.length);reject(&c,v);wr(s+32+4000*4,4000*12);assert(agx_cache_bind(&c,s,sn));
 for(unsigned at=0;at<32;at++){uint8_t old=s[at];s[at]^=128;reject(&c,v);s[at]=old;compare(&c,s,sn,v);}
 assert(!agx_cache_bind(&c,NULL,sn));reject(&c,v);assert(agx_cache_bind(&c,s,sn));agx_cache_clear(&c);free(s);reject(&c,v); /* No source dereference after clear. */
 FILE*f=fopen(argv[1],"rb");assert(f);fseek(f,0,SEEK_END);size_t n=ftell(f);rewind(f);uint8_t*p=malloc(n);assert(p&&fread(p,1,n,f)==n);fclose(f);assert(agx_cache_bind(&c,p,n));
 for(uint32_t x=0;x<274625;x++){v[0]=x;v[1]=(x+1)%274625;v[2]=(x+65)%274625;v[3]=(x+4225)%274625;assert(agx_cache_fetch4(&c,v,out));for(unsigned j=0;j<4;j++)assert(!memcmp(out[j],agx_lut+3*v[j],6));}
 for(unsigned i=0;i<20000;i++){for(unsigned j=0;j<4;j++)v[j]=rnd()%274625;compare(&c,p,n,v);unsigned bi=block(v[rnd()%4]);size_t st=19688+rd(p+32+bi*4),end=19688+rd(p+36+bi*4);size_t at=st+rnd()%(end-st);uint8_t old=p[at];p[at]^=1+rnd()%255;compare(&c,p,n,v);p[at]=old;compare(&c,p,n,v);}
 /* Alias output to indices permitted, blob/cache writes rejected. */
 union{uint32_t indices[6];uint16_t rgb[4][3];}u;for(unsigned j=0;j<4;j++){u.indices[j]=v[j];}uint16_t expected[4][3];assert(agx_cache_fetch4(&c,v,expected));assert(agx_cache_fetch4(&c,u.indices,u.rgb));assert(!memcmp(expected,u.rgb,24));
 agx_block_cache saved=c;assert(!agx_cache_fetch4(&c,v,(uint16_t(*)[3])(void*)&c));assert(!memcmp(&c,&saved,sizeof c));assert(!agx_cache_fetch4(&c,(uint32_t*)(void*)&c,out));assert(!memcmp(&c,&saved,sizeof c));
 for(unsigned at=0;at+24<n;at+=444){uint8_t before[24];memcpy(before,p+at,24);assert(!agx_cache_fetch4(&c,v,(uint16_t(*)[3])(void*)(p+at)));assert(!memcmp(before,p+at,24));}
 v[3]=274625;reject(&c,v);agx_cache_clear(&c);free(p);reject(&c,v);
 printf("PASS synthetic_blocks=4913 same_address_cycles=1000 real_four_vertex_groups=274625 mutation_cycles=20000 transactional_failures=4 alias_and_unbind=checked cache_bytes=%zu\n",sizeof c);return 0;}
