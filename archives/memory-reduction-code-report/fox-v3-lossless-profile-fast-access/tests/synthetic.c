/* Synthetic, deterministic safety checks. No model/profile/reference data. */
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
size_t lossless_decode_channel(const uint8_t*,size_t,unsigned,unsigned,unsigned,uint16_t[64]);
size_t old_decode_channel(const uint8_t*,size_t,unsigned,unsigned,unsigned,uint16_t[64]);
int lossless_fetch(const uint8_t*,size_t,uint32_t,uint16_t[3]);
int lossless_fetch4(const uint8_t*,size_t,const uint32_t[4],uint16_t[4][3]);
static uint32_t state=0x01924788u;
static uint32_t rnd(void){state^=state<<13;state^=state>>17;state^=state<<5;return state;}
static void put32(uint8_t *p,uint32_t n){for(unsigned k=0;k<4;k++)p[k]=(uint8_t)(n>>(k*8));}
int main(void){
 uint8_t bytes[396];uint16_t a[64],b[64];
 for(unsigned trial=0;trial<12000;trial++){
  size_t len=2+rnd()%395;for(size_t i=0;i<len;i++)bytes[i]=(uint8_t)rnd();
  bytes[0]=(uint8_t)(rnd()%9);bytes[1]=(uint8_t)(rnd()%18);
  unsigned sx=1+rnd()%4,sy=1+rnd()%4,sz=1+rnd()%4;
  memset(a,0xA5,sizeof a);memset(b,0x5A,sizeof b);
  size_t na=old_decode_channel(bytes,len,sx,sy,sz,a),nb=lossless_decode_channel(bytes,len,sx,sy,sz,b);
  assert(na==nb);if(na)assert(!memcmp(a,b,sx*sy*sz*sizeof *a));
 }
 const size_t len=19688+4913*12;uint8_t *blob=calloc(1,len);assert(blob);
 memcpy(blob,"AGXL4R01",8);blob[8]=65;blob[10]=4;put32(blob+12,4913);put32(blob+16,(uint32_t)len);put32(blob+20,32);put32(blob+24,19688);
 for(unsigned i=0;i<=4913;i++)put32(blob+32+4*i,i*12);
 for(unsigned i=0;i<4913;i++)for(unsigned c=0;c<3;c++){unsigned v=(i*3+c)%65536;blob[19688+i*12+c*4+2]=(uint8_t)v;blob[19688+i*12+c*4+3]=(uint8_t)(v>>8);}
 for(unsigned trial=0;trial<2000;trial++){
  uint32_t v[4];uint16_t rgb[4][3],ref[4][3];
  for(unsigned j=0;j<4;j++){v[j]=rnd()%274625;assert(lossless_fetch(blob,len,v[j],ref[j]));}
  if(trial%2)v[1]=v[0];if(trial%3==0)v[2]=v[0];
  for(unsigned j=0;j<4;j++)assert(lossless_fetch(blob,len,v[j],ref[j]));
  assert(lossless_fetch4(blob,len,v,rgb));assert(!memcmp(rgb,ref,sizeof rgb));
 }
 uint32_t v[4]={0,1,65,274624};uint16_t out[4][3],saved[4][3];memset(out,0x81,sizeof out);memcpy(saved,out,sizeof out);
 assert(!lossless_fetch4(blob,SIZE_MAX,v,out));assert(!memcmp(out,saved,sizeof out));
 assert(!lossless_fetch4(blob,len,v,(uint16_t (*)[3])(blob+100)));assert(!memcmp(out,saved,sizeof out));
 uint8_t keep=blob[len-4];blob[len-4]=4;
 assert(!lossless_fetch4(blob,len,v,out));assert(!memcmp(out,saved,sizeof out));blob[len-4]=keep;
 assert(lossless_fetch4(blob,len,v,out)); /* no stale failure or poisoned scratch */
 v[3]=274625;memcpy(saved,out,sizeof out);assert(!lossless_fetch4(blob,len,v,out));assert(!memcmp(out,saved,sizeof out));v[3]=274624;
 union {uint32_t indices[6];uint16_t colors[4][3];} alias;
 memcpy(alias.indices,v,sizeof v);assert(lossless_fetch4(blob,len,alias.indices,alias.colors));assert(!memcmp(alias.colors,out,sizeof out));
 assert(!lossless_fetch4(NULL,len,v,out));assert(!lossless_fetch4(blob,len,NULL,out));assert(!lossless_fetch4(blob,len,v,NULL));
 free(blob);puts("PASS: 12000 channel differential cases, 2000 gather cases, atomicity/overlap/alias/overflow/malformed/recovery/null checks");return 0;
}
