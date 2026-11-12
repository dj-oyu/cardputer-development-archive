#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "../../fox-v3-profile-integration-feasibility/build-private/agx_lut.inc"
size_t lossless_decode_channel(const uint8_t*,size_t,unsigned,unsigned,unsigned,uint16_t[64]);
int lossless_fetch(const uint8_t*,size_t,uint32_t,uint16_t[3]);
static uint32_t rng=712367;static uint32_t rnd(void){rng^=rng<<13;rng^=rng>>17;rng^=rng<<5;return rng;}
static uint32_t u32(const uint8_t*p){return (uint32_t)p[0]|((uint32_t)p[1]<<8)|((uint32_t)p[2]<<16)|((uint32_t)p[3]<<24);}
static void put32(uint8_t*p,uint32_t v){for(int i=0;i<4;i++)p[i]=(uint8_t)(v>>(8*i));}
static size_t rejections;
static void reject(uint8_t*b,size_t n,uint32_t v){uint16_t out[3]={1357,2468,9999};assert(!lossless_fetch(b,n,v,out));assert(out[0]==1357&&out[1]==2468&&out[2]==9999);rejections++;}
static void setbit(uint8_t*b,size_t*pos,uint32_t v,unsigned n){for(unsigned i=0;i<n;i++,(*pos)++)if((v>>i)&1)b[*pos/8]|=(uint8_t)(1u<<(*pos%8));}
static int32_t predictor(uint16_t*v,unsigned i,unsigned mode,unsigned a,unsigned b,unsigned c){
 (void)a;if(mode==1)return i?v[i-1]:0;if(mode==2)return i?2*(int32_t)v[i-1]-(i>1?v[i-2]:0):0;
 unsigned x=i/(b*c),y=i/c%b,z=i%c;int32_t p=0;
 for(unsigned dx=0;dx<2;dx++)for(unsigned dy=0;dy<2;dy++)for(unsigned dz=0;dz<2;dz++)if(dx+dy+dz&&x>=dx&&y>=dy&&z>=dz)p+=((dx+dy+dz)%2?1:-1)*(int32_t)v[i-dx*b*c-dy*c-dz];return p;
}
int main(int argc,char**argv){assert(argc==2);FILE*f=fopen(argv[1],"rb");assert(f);fseek(f,0,SEEK_END);size_t n=(size_t)ftell(f);rewind(f);uint8_t*b=malloc(n);assert(b&&fread(b,1,n,f)==n);fclose(f);
 uint16_t rgb[3];for(uint32_t v=0;v<274625;v++){assert(lossless_fetch(b,n,v,rgb));assert(!memcmp(rgb,agx_lut+v*3,6));}
 for(unsigned t=0;t<10000;t++){uint32_t v=rnd()%274625;assert(lossless_fetch(b,n,v,rgb));assert(!memcmp(rgb,agx_lut+v*3,6));}
 size_t channels=0,truncs=0;for(unsigned bi=0;bi<4913;bi++){unsigned bx=bi/289,by=bi/17%17,bz=bi%17;unsigned sx=bx==16?1:4,sy=by==16?1:4,sz=bz==16?1:4;
 size_t at=19688+u32(b+32+bi*4),end=19688+u32(b+36+bi*4);for(unsigned c=0;c<3;c++){struct {uint16_t pre;uint16_t val[64];uint16_t post;}o;o.pre=123;o.post=456;size_t used=lossless_decode_channel(b+at,end-at,sx,sy,sz,o.val);assert(used&&used<=end-at&&o.pre==123&&o.post==456);
 for(unsigned x=0;x<sx;x++)for(unsigned y=0;y<sy;y++)for(unsigned z=0;z<sz;z++)assert(o.val[(x*sy+y)*sz+z]==agx_lut[(((bx*4+x)*65+by*4+y)*65+bz*4+z)*3+c]);
 for(size_t len=0;len<used;len++){assert(!lossless_decode_channel(b+at,len,sx,sy,sz,o.val));assert(o.pre==123&&o.post==456);truncs++;}at+=used;channels++;}assert(at==end);}
 for(size_t len=0;len<19688;len++)reject(b,len,0);reject(b,n-1,0);reject(b,n,274625);reject(NULL,n,0);assert(!lossless_fetch(b,n,0,NULL));
 for(unsigned at=0;at<32;at++){uint8_t save=b[at];b[at]^=128;reject(b,n,0);b[at]=save;}
 for(unsigned bi=0;bi<4913;bi++){uint32_t v=((bi/289)*4*65+(bi/17%17)*4)*65+(bi%17)*4;size_t at=32+bi*4;uint32_t old=u32(b+at);put32(b+at,UINT32_MAX);reject(b,n,v);put32(b+at,old);}
 for(unsigned t=0;t<20000;t++){uint32_t v=rnd()%274625;unsigned bi=((v/4225/4)*17+(v/65%65)/4)*17+(v%65)/4;size_t st=19688+u32(b+32+bi*4),en=19688+u32(b+36+bi*4),at=st+rnd()%(en-st);uint8_t old=b[at];b[at]^=(uint8_t)(1+(rnd()%255));uint16_t o[3]={1357,2468,9999};int ok=lossless_fetch(b,n,v,o);assert(ok==0||ok==1);if(!ok)assert(o[0]==1357&&o[1]==2468&&o[2]==9999);b[at]=old;}
 for(unsigned a=1;a<=4;a++)for(unsigned bb=1;bb<=4;bb++)for(unsigned c=1;c<=4;c++)for(unsigned mode=0;mode<=7;mode++){if(mode==4)continue;uint16_t expect[64],out[64];uint8_t record[512]={0};record[0]=mode;record[1]=16;size_t pos=(mode?2:4)*8;for(unsigned i=0;i<a*bb*c;i++){expect[i]=(uint16_t)rnd();uint32_t r=expect[i];if(mode){int32_t d=(int32_t)((expect[i]-predictor(expect,i,mode>=5?mode-4:mode,a,bb,c)+32768)&65535)-32768;r=d<0?(uint32_t)(-d*2-1):(uint32_t)d*2;}if(mode>=5)setbit(record,&pos,1,1);setbit(record,&pos,r,16);}assert(lossless_decode_channel(record,(pos+7)/8,a,bb,c,out)==(pos+7)/8);assert(!memcmp(expect,out,a*bb*c*2));}
 uint8_t unary[8195]={5,0};uint16_t o[64];unary[8193]=128;assert(!lossless_decode_channel(unary,8194,1,1,1,o));unary[8193]=0;unary[8194]=1;assert(!lossless_decode_channel(unary,sizeof(unary),1,1,1,o));

 /* Every Rice parameter, zero/maximum permitted quotient and modular zigzag extrema. */
 for(unsigned k=0;k<=16;k++)for(unsigned mode=5;mode<=7;mode++)for(unsigned edge=0;edge<3;edge++){
 uint32_t r=edge==0?0:edge==1?65535:32768;unsigned q=r>>k;size_t bits=16+q+1+k,bytes=(bits+7)/8;uint8_t rec[8196]={0};rec[0]=(uint8_t)mode;rec[1]=(uint8_t)k;size_t bit=16+q;setbit(rec,&bit,1,1);setbit(rec,&bit,r&((1u<<k)-1),k);
 size_t used=lossless_decode_channel(rec,bytes,1,1,1,o);if(bytes<=396){assert(used==bytes);int32_t d=(r&1)?-(int32_t)(r/2)-1:(int32_t)(r/2);assert(o[0]==(uint16_t)d);}else assert(!used);
 }
 {uint8_t bad[8]={0,16,255,255,1,0};assert(!lossless_decode_channel(bad,6,1,1,1,o));bad[0]=5;bad[1]=16;bad[2]=0;assert(!lossless_decode_channel(bad,6,1,1,1,o));
 for(unsigned d=0;d<6;d++){unsigned v=d==0?0:5;assert(!lossless_decode_channel(bad,6,v,1,1,o));assert(!lossless_decode_channel(bad,6,1,v,1,o));assert(!lossless_decode_channel(bad,6,1,1,v,o));}
 assert(!lossless_decode_channel(NULL,6,1,1,1,o));assert(!lossless_decode_channel(bad,6,1,1,1,NULL));assert(!lossless_decode_channel(bad,SIZE_MAX,1,1,1,o));reject(b,SIZE_MAX,0);}
 {uint8_t *wrapped=malloc(n+16);assert(wrapped);memcpy(wrapped+8,b,n);for(unsigned at=4;at<=6;at+=2){uint8_t save[6];memcpy(save,wrapped+at,6);assert(!lossless_fetch(wrapped+8,n,0,(uint16_t*)(void*)(wrapped+at)));assert(!memcmp(save,wrapped+at,6));}free(wrapped);}
 /* Aliased public output must reject and leave blob unchanged. */
 for(size_t at=0;at+6<=n;at+=2+(n/100/2)*2){uint8_t saved[6];memcpy(saved,b+at,6);assert(!lossless_fetch(b,n,0,(uint16_t*)(void*)(b+at)));assert(!memcmp(saved,b+at,6));}
 printf("PASS exhaustive_values=823875 random_vertices=10000 channels=%zu record_truncations=%zu public_rejections=%zu mutations=20000 synthetic_shapes_modes=448 alias=checked\n",channels,truncs,rejections);free(b);return 0;
}
