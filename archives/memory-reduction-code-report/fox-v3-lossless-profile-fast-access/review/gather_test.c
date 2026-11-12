#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "../../fox-v3-profile-integration-feasibility/build-private/agx_lut.inc"
int lossless_fetch4(const uint8_t*,size_t,const uint32_t[4],uint16_t[4][3]);
static uint32_t rndstate=82731;static uint32_t rnd(void){rndstate^=rndstate<<13;rndstate^=rndstate>>17;rndstate^=rndstate<<5;return rndstate;}
static uint32_t u32(const uint8_t*p){return (uint32_t)p[0]|(uint32_t)p[1]<<8|(uint32_t)p[2]<<16|(uint32_t)p[3]<<24;}
static void check(uint8_t*b,size_t n,uint32_t v[4]){uint16_t o[4][3];assert(lossless_fetch4(b,n,v,o));for(unsigned j=0;j<4;j++)assert(!memcmp(o[j],agx_lut+3*v[j],6));}
static void reject(uint8_t*b,size_t n,uint32_t v[4]){uint16_t o[4][3],saved[4][3];memset(o,0x79,sizeof o);memcpy(saved,o,sizeof o);assert(!lossless_fetch4(b,n,v,o));assert(!memcmp(o,saved,sizeof o));}
int main(int argc,char**argv){assert(argc==2);FILE*f=fopen(argv[1],"rb");assert(f);fseek(f,0,2);size_t n=ftell(f);rewind(f);uint8_t*mem=malloc(n+64),*b=mem+32;assert(fread(b,1,n,f)==n);fclose(f);
for(uint32_t i=0;i<274625;i++){uint32_t v[4]={i,(i+1)%274625,(i+65)%274625,(i+4225)%274625};check(b,n,v);}for(unsigned t=0;t<20000;t++){uint32_t v[4]={rnd()%274625,rnd()%274625,rnd()%274625,rnd()%274625};if(t%4==0)v[1]=v[2]=v[3]=v[0];check(b,n,v);}
uint32_t v[4]={0,4,260,16900};for(unsigned j=0;j<4;j++){uint32_t saved=v[j];v[j]=274625;reject(b,n,v);v[j]=saved;}for(size_t len=0;len<19688;len++)reject(b,len,v);reject(b,n-1,v);reject(b,SIZE_MAX,v);reject(NULL,n,v);assert(!lossless_fetch4(b,n,NULL,(uint16_t[4][3]){{0}}));assert(!lossless_fetch4(b,n,v,NULL));
for(unsigned i=0;i<32;i++){uint8_t saved=b[i];b[i]^=128;reject(b,n,v);b[i]=saved;}
for(unsigned j=0;j<4;j++){unsigned id=j==0?0:j==1?1:j==2?17:289;size_t at=19688+u32(b+32+id*4);uint8_t saved=b[at];b[at]=255;reject(b,n,v);b[at]=saved;check(b,n,v);}
/* Same pointer after mutation/restore, fresh allocation and poison do not retain state. */
for(unsigned t=0;t<10000;t++){unsigned id=rnd()%4913;uint32_t p=((id/289)*4*65+(id/17%17)*4)*65+(id%17)*4;uint32_t q[4]={p,p,p,p};size_t at=19688+u32(b+32+id*4);uint8_t saved=b[at];check(b,n,q);b[at]=255;reject(b,n,q);b[at]=saved;check(b,n,q);}
for(int off=-22;off<32;off+=2){uint8_t saved[24];memcpy(saved,b+off,24);assert(!lossless_fetch4(b,n,v,(uint16_t(*)[3])(void*)(b+off)));assert(!memcmp(saved,b+off,24));}
/* uint16 writes may alias uint32 input only after all indices copied. */
union{uint32_t v[16];uint16_t o[32];} alias;for(unsigned off=0;off<=6;off++){memset(&alias,0xcc,sizeof alias);memcpy(alias.v,v,sizeof v);assert(lossless_fetch4(b,n,alias.v,(uint16_t(*)[3])(void*)(alias.o+off)));for(unsigned j=0;j<4;j++)assert(!memcmp(alias.o+off+j*3,agx_lut+3*v[j],6));}
puts("PASS gather exhaustive_vertices=274625 random_quads=20000 stale_mutation_restore=10000 public_atomicity_alias_overlap=checked");free(mem);}
