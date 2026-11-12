#define _POSIX_C_SOURCE 200809L
/* Diagnostic-only codec; does not include or modify product sources. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#define DIAG 0xe4u
#define CAP 65536u
static volatile uint64_t consumed;
static unsigned u16(const uint8_t *p){return (unsigned)p[0]|((unsigned)p[1]<<8);}
static int32_t s16(const uint8_t *p){unsigned x=u16(p);return x<32768u?(int32_t)x:(int32_t)x-65536;}
static void w16(uint8_t *p,unsigned x){p[0]=(uint8_t)x;p[1]=(uint8_t)(x>>8);}
static size_t aligned(size_t x){return (x+3u)&~(size_t)3u;}
static uint64_t ns(void){struct timespec t;if(clock_gettime(CLOCK_MONOTONIC,&t))abort();return (uint64_t)t.tv_sec*UINT64_C(1000000000)+(uint64_t)t.tv_nsec;}
static int record(const uint8_t *p,size_t avail,int decoding,size_t *raw,size_t *bytes,unsigned *stride){
 if(avail<12||p[0]<3||p[0]>32||!p[1]||p[1]>64||p[3]||u16(p+6)||u16(p+8))return 0;
 if(p[2]!=4&&(!decoding||p[2]!=DIAG))return 0;
 *stride=p[2]==DIAG?50u:56u;*raw=12u+*stride*p[0]+3u*p[1]+(p[1]+7u)/8u;*bytes=aligned(*raw);
 if(u16(p+10)!=*bytes||*bytes>avail)return 0;
 const uint8_t *ix=p+12u+*stride*p[0];for(unsigned t=0;t<p[1];t++){unsigned a=ix[3*t],b=ix[3*t+1],c=ix[3*t+2];if(a>=p[0]||b>=p[0]||c>=p[0]||a==b||a==c||b==c)return 0;}
 if(p[1]%8u&&(p[*raw-1]>>(p[1]%8u)))return 0;for(size_t i=*raw;i<*bytes;i++)if(p[i])return 0;return 1;
}
#if defined(__GNUC__)
__attribute__((noinline))
#endif
static size_t codec(const uint8_t *input,size_t n,uint8_t *out,size_t cap,int decoding){
 if(n<416||cap<416)return 0;memcpy(out,input,416);size_t src=416,dst=416;
 while(src<n){size_t raw,bytes;unsigned stride;const uint8_t *p=input+src;if(!record(p,n-src,decoding,&raw,&bytes,&stride))return 0;unsigned nv=p[0],nt=p[1];int compact=0;
 if(!decoding){compact=1;for(unsigned v=0;v<nv;v++)for(unsigned k=0;k<3;k++){const uint8_t *x=p+12u+56u*v;int32_t f=s16(x+44+2*k),b=s16(x+50+2*k);if(b!=-f)compact=0;}}
 if((!decoding&&!compact)||(decoding&&stride==56)){if(bytes>cap-dst)return 0;memcpy(out+dst,p,bytes);src+=bytes;dst+=bytes;continue;}
 unsigned target=decoding?56u:50u;size_t out_raw=12u+target*nv+3u*nt+(nt+7u)/8u,out_bytes=aligned(out_raw);if(out_bytes>cap-dst)return 0;uint8_t *q=out+dst;memset(q,0,out_bytes);memcpy(q,p,12);q[2]=(uint8_t)(decoding?4u:DIAG);w16(q+10,(unsigned)out_bytes);
 for(unsigned v=0;v<nv;v++){const uint8_t *x=p+12u+stride*v;uint8_t *y=q+12u+target*v;memcpy(y,x,50);if(decoding)for(unsigned k=0;k<3;k++){int32_t f=s16(x+44+2*k);if(f==-32768)return 0;int32_t b=-f;w16(y+50+2*k,(unsigned)(b<0?b+65536:b));}}
 memcpy(q+12u+target*nv,p+12u+stride*nv,3u*nt+(nt+7u)/8u);src+=bytes;dst+=out_bytes;
 }
 return src==n?dst:0;
}
#if defined(__GNUC__)
__attribute__((noinline))
#endif
static size_t simple_copy(const uint8_t *p,size_t n,uint8_t *q){memcpy(q,p,n);return n;}
static size_t load(const char *path,uint8_t *p){FILE *f=fopen(path,"rb");if(!f)return 0;size_t n=fread(p,1,CAP,f);int extra=fgetc(f);fclose(f);return extra==EOF?n:0;}
static uint8_t input[CAP],expected[CAP],output[CAP];
int main(int argc,char **argv){
 if(argc!=4)return 2;unsigned iterations=(unsigned)strtoul(argv[3],NULL,10);if(!iterations||iterations>100000)return 2;size_t n=load(argv[1],input),en=load(argv[2],expected);if(!n||!en)return 2;
 size_t got=codec(input,n,output,CAP,0);if(got!=en||memcmp(output,expected,en))return 3;got=codec(expected,en,output,CAP,1);if(got!=n||memcmp(output,input,n))return 4;
 uint64_t times[3][3]={{0}};for(unsigned rep=0;rep<3;rep++)for(unsigned step=0;step<3;step++){
  unsigned op=(step+rep)%3;const uint8_t *src=op==2?expected:input;size_t size=op==2?en:n;const uint8_t *want=op==1?expected:input;size_t want_n=op==1?en:n;
  for(unsigned warm=0;warm<10;warm++){got=op==0?simple_copy(src,size,output):codec(src,size,output,CAP,op==2);if(got!=want_n||memcmp(output,want,want_n))return 5;consumed+=output[(warm*131u)%got];}
  uint64_t start=ns();for(unsigned i=0;i<iterations;i++){got=op==0?simple_copy(src,size,output):codec(src,size,output,CAP,op==2);if(got!=want_n)return 6;consumed+=output[(i*131u)%got];}times[op][rep]=ns()-start;
  if(memcmp(output,want,want_n))return 7;
 }
 printf("{\"inputBytes\":%zu,\"encodedBytes\":%zu,\"iterationsPerBatch\":%u,\"allBatchOutputBytesExact\":true,\"consumed\":%llu,\"batchNs\":{",n,en,iterations,(unsigned long long)consumed);
 const char *names[3]={"copy","encode","decode"};for(unsigned op=0;op<3;op++)printf("%s\"%s\":[%llu,%llu,%llu]",op?",":"",names[op],(unsigned long long)times[op][0],(unsigned long long)times[op][1],(unsigned long long)times[op][2]);puts("}}");return 0;
}
