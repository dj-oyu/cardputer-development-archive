#include "sampler.h"
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <limits.h>
#include "data.h"
#include "oracle-data.h"
static __int128 floor128(__int128 a,__int128 b){return a>=0?a/b:-((-a+b-1)/b);}
static unsigned source(int m,int x,int y){return x<0||x>=128||y<0||y>=64?0:raw[m*8192+y*128+x];}
static uint8_t oracle(FaceQuery q){
 int g=q.mask/4;int bounds[2][5]={{-420000,420000,2680000,3130000,-450000},{-380000,380000,2075000,2340000,-850000}};
 int*b=bounds[g]; __int128 scale=q.frac?((__int128)1<<q.frac):1,mul=q.frac?1000000:1;
 __int128 xx=q.x*mul,yy=q.y*mul,zz=q.z*mul;
 if(xx<b[0]*scale||xx>=b[1]*scale||zz<=b[2]*scale||zz>b[3]*scale||yy>=b[4]*scale)return 0;
 __int128 u=(xx-b[0]*scale)*128,v=(b[3]*scale-zz)*64,w=(b[1]-b[0])*scale,h=(b[3]-b[2])*scale;
 if(q.mode!=2){unsigned val=source(q.mask,(int)(u/w),(int)(v/h));return (uint8_t)(q.mode==0?(val>=128?255:0):val);}
 __int128 a=floor128(u*65536,w)-32768,c=floor128(v*65536,h)-32768;
 int x=(int)floor128(a,65536),y=(int)floor128(c,65536);__int128 rx=a-(__int128)x*65536,ry=c-(__int128)y*65536,total=0;
 for(int j=0;j<2;j++)for(int i=0;i<2;i++)total+=(__int128)source(q.mask,x+i,y+j)*(i?rx:65536-rx)*(j?ry:65536-ry);
 return (uint8_t)((total+((__int128)1<<31))/((__int128)1<<32));
}
static uint32_t seed=0x71428ab1;static uint32_t rng(void){seed^=seed<<13;seed^=seed>>17;seed^=seed<<5;return seed;}
static unsigned long checks;
static void check(FaceQuery q){uint8_t out=77;assert(face_scalar(&q,&out)==0);assert(out==oracle(q));checks++;}
int main(void){
 /* Exhaustive source pixel validation of both exact encodings and binary threshold. */
 for(int m=0;m<8;m++)for(int y=0;y<64;y++)for(int x=0;x<128;x++){
  int c=m*128+x,p=spanoff[c],lo=spans[p],n=spans[p+1];unsigned v=y>=lo&&y<lo+n?spans[p+2+y-lo]:0;assert(v==source(m,x,y));v=0;
  for(int r=off[c];r<off[c+1];r++)if(y>=runs[r*3]&&y<runs[r*3]+runs[r*3+1])v=runs[r*3+2];
  assert(v==source(m,x,y));
  assert((source(m,x,y)>=128)==(binary[c*2]!=255&&y>=binary[c*2]&&y<=binary[c*2+1]));
 }
 for(int m=0;m<8;m++)for(int mode=0;mode<4;mode++){
  int x0=m<4?-420000:-380000,w=m<4?840000:760000,z1=m<4?3130000:2340000,h=m<4?450000:265000,gate=m<4?-450000:-850000;
  /* Every texel boundary and center, plus +/-1 micro-unit; all Y gate edges. */
  for(int i=0;i<=256;i++)for(int j=0;j<=128;j++)for(int d=-1;d<=1;d++){
   FaceQuery q={x0+(int)((int64_t)i*w/256)+d,gate-1,z1-(int)((int64_t)j*h/128)+d,(uint8_t)m,(uint8_t)mode,0};check(q);
  }
  for(int d=-1;d<=1;d++){FaceQuery q={0,gate+d,z1-h/2,(uint8_t)m,(uint8_t)mode,0};check(q);}
 }
 for(int f=16;f<=24;f+=4)for(int m=0;m<8;m++)for(int mode=0;mode<4;mode++){
  int64_t sc=(int64_t)1<<f;int x0=m<4?-420000:-380000,w=m<4?840000:760000,z1=m<4?3130000:2340000,h=m<4?450000:265000,gate=m<4?-450000:-850000;
  for(int i=0;i<=256;i++)for(int j=0;j<=128;j++)for(int d=-1;d<=1;d++){
   FaceQuery q={(int32_t)floor128(((__int128)x0*256+(__int128)i*w)*sc,256000000)+d,(int32_t)floor128((__int128)gate*sc,1000000)-1,(int32_t)floor128(((__int128)z1*128-(__int128)j*h)*sc,128000000)+d,(uint8_t)m,(uint8_t)mode,(uint8_t)f};check(q);
  }
  for(int d=-1;d<=1;d++){FaceQuery q={0,(int32_t)floor128((__int128)gate*sc,1000000)+d,(int32_t)((int64_t)(z1-h/2)*sc/1000000),(uint8_t)m,(uint8_t)mode,(uint8_t)f};check(q);}
 }
 unsigned gate_checks=0;
 for(int f=0;f<=24;f=(f==0?16:f+4))for(int m=0;m<8;m++){
  int pos=0;while(raw[m*8192+pos]<200)pos++;int px=pos%128,py=pos/128;
  int x0=m<4?-420000:-380000,w=m<4?840000:760000,z1=m<4?3130000:2340000,h=m<4?450000:265000,gate=m<4?-450000:-850000;
  int64_t sc=f?((int64_t)1<<f):1000000;
  for(int d=-1;d<=1;d++){
   FaceQuery q={(int32_t)floor128(((__int128)x0*256+(2*px+1)*w)*sc,256000000),(int32_t)floor128((__int128)gate*sc,1000000)+d,(int32_t)floor128(((__int128)z1*128-(2*py+1)*h)*sc,128000000),(uint8_t)m,1,(uint8_t)f};
   uint8_t result=0;assert(!face_scalar(&q,&result));int pass=(__int128)q.y*1000000<(__int128)gate*sc;assert(pass?result>=200:result==0);gate_checks++;check(q);
  }
 }
 printf("Strict gate probes: %u, at nonzero mask pixels, direct rational predicate unchanged.\n",gate_checks);
 for(int t=0;t<100000;t++){
  FaceQuery q[8];uint8_t out[8],expected[8];
  for(int i=0;i<8;i++){int m=rng()%8;q[i]=(FaceQuery){(int32_t)(rng()%1600001)-800000,-1000000+(int32_t)(rng()%600001),1800000+(int32_t)(rng()%1600001),(uint8_t)m,(uint8_t)(rng()%4),0};if(t%4){q[i].frac=(uint8_t)(12+4*(t%4));int64_t sc=(int64_t)1<<q[i].frac;q[i].x=(int32_t)((int64_t)q[i].x*sc/1000000);q[i].y=(int32_t)((int64_t)q[i].y*sc/1000000);q[i].z=(int32_t)((int64_t)q[i].z*sc/1000000);}
 expected[i]=oracle(q[i]);}
  for(size_t n=1;n<=8;n*=2){memset(out,77,8);assert(!face_block(q,n,out));assert(!memcmp(out,expected,n));for(size_t i=n;i<8;i++)assert(out[i]==77);checks+=n;}
 }
 FaceQuery q[8];for(int i=0;i<8;i++)q[i]=(FaceQuery){0,-1000000,2900000,0,2,0};uint8_t out[8];
 for(int i=0;i<8;i++)for(int kind=0;kind<9;kind++){FaceQuery save=q[i];if(kind==0)q[i].mask=8;if(kind==1)q[i].mode=4;if(kind==2)q[i].x=INT32_MIN;if(kind==3)q[i].z=INT32_MAX;if(kind==4)q[i].y=16000001;if(kind==5)q[i].x=-16000001;if(kind==6)q[i].z=-16000001;if(kind==7)q[i].y=-16000001;if(kind==8)q[i].frac=15;memset(out,77,8);assert(face_block(q,8,out)==-1);for(int j=0;j<8;j++)assert(out[j]==77);q[i]=save;}
 for(size_t n=0;n<=10;n++)if(n!=1&&n!=2&&n!=4&&n!=8){memset(out,77,8);assert(face_block(q,n,out)==-1);for(int j=0;j<8;j++)assert(out[j]==77);}
 assert(face_block(NULL,8,out)==-1);assert(face_block(q,8,NULL)==-1);
 for(int d=-1;d<=1;d+=2){FaceQuery edge={d*16000000,d*16000000,d*16000000,0,2,0};check(edge);}
 printf("PASS: 65536 encoding pixels; %lu sample/group comparisons; transactional invalid cases.\n",checks);return 0;
}
