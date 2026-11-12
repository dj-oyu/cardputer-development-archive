#define _POSIX_C_SOURCE 200809L
#include "fixed_kernel.h"
#include "reference.h"
#include <assert.h>
#include <fenv.h>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <inttypes.h>
#define PIXELS 4096
#define REPS 120
#define TRIALS 6
static double bary[PIXELS][3],source[PIXELS][3],result[PIXELS];
static int16_t encoded[PIXELS][3],integer_result[PIXELS],expected[PIXELS];
static fk_tile packed[PIXELS];
static volatile uint64_t sink;
static uint64_t state=0xbac313a5cf90e12dULL;
static uint32_t random32(void){state^=state<<13;state^=state>>7;state^=state<<17;return (uint32_t)state;}
/* GCC noipa keeps independent calls from being folded/hoisted across repetitions. */
__attribute__((noipa)) static void baseline(unsigned width){
 for(unsigned p=0;p<PIXELS;p+=width)for(unsigned lane=0;lane<width;lane++)result[p+lane]=ref_rho(bary[p+lane],source[p+lane]);
}
__attribute__((noipa)) static void compute(unsigned width){
 for(unsigned p=0;p<PIXELS;p+=width){int16_t out[8];bool ok=fk_block(&packed[p/width],width,out);assert(ok);for(unsigned lane=0;lane<width;lane++)integer_result[p+lane]=out[lane];}
}
__attribute__((noipa)) static void mixed(unsigned width){
 for(unsigned p=0;p<PIXELS;p+=width){fk_tile t;int16_t out[8];
  for(unsigned lane=0;lane<width;lane++){int16_t w[3];bool ok=fk_weights(bary[p+lane],w);assert(ok);for(unsigned j=0;j<3;j++){t.w[j][lane]=w[j];t.a[j][lane]=encoded[p+lane][j];}}
  bool ok=fk_block(&t,width,out);assert(ok);for(unsigned lane=0;lane<width;lane++)result[p+lane]=out[lane]/32767.0;
 }
}
static double now(void){struct timespec ts;assert(clock_gettime(CLOCK_PROCESS_CPUTIME_ID,&ts)==0);return ts.tv_sec+ts.tv_nsec*1e-9;}
static void prepare(unsigned width){
 for(unsigned p=0;p<PIXELS;p+=width)for(unsigned lane=0;lane<width;lane++){int16_t w[3];assert(fk_weights(bary[p+lane],w));for(unsigned j=0;j<3;j++){packed[p/width].w[j][lane]=w[j];packed[p/width].a[j][lane]=encoded[p+lane][j];}}
}
static void run(unsigned width,unsigned trial,unsigned variant,unsigned order){
 void(*fn)(unsigned)=variant==0?baseline:variant==1?compute:mixed;
 double start=now();for(unsigned rep=0;rep<REPS;rep++){fn(width);unsigned at=(rep*7919u)%PIXELS;uint64_t v=variant==1?(uint16_t)integer_result[at]:(uint64_t)(result[at]*1e12);sink=(sink^(v+0x9e3779b97f4a7c15ULL))*0x100000001b3ULL;}
 double elapsed=now()-start;printf("%u,%u,%u,%s,%.9f,%.6f\n",width,trial,order,variant==0?"double":variant==1?"fixed_prepared":"fixed_mixed",elapsed,elapsed*1e9/(PIXELS*REPS));
}
int main(void){
 assert(fegetround()==FE_TONEAREST);
 for(unsigned p=0;p<PIXELS;p++){double sum=0;for(unsigned j=0;j<3;j++){bary[p][j]=1.0+random32();sum+=bary[p][j];source[p][j]=random32()/4294967295.0;assert(fk_encode(source[p][j],32767,&encoded[p][j]));}for(unsigned j=0;j<3;j++)bary[p][j]/=sum;}
 double max_error=0;for(unsigned width=1;width<=8;width*=2){prepare(width);compute(width);for(unsigned p=0;p<PIXELS;p++){if(width==1)expected[p]=integer_result[p];assert(integer_result[p]==expected[p]);double error=fabs(integer_result[p]/32767.0-ref_rho(bary[p],source[p]));assert(error<.00022);if(error>max_error)max_error=error;}
  mixed(width);for(unsigned p=0;p<PIXELS;p++)assert(result[p]==expected[p]/32767.0);
 }
 fprintf(stderr,"preflight: pixels=%d widths=1/2/4/8 integer mismatch=0 mixed mismatch=0 max_rho_error=%.12g reps=%d trials=%d\n",PIXELS,max_error,REPS,TRIALS);
 puts("width,trial,order,variant,cpu_seconds,ns_per_pixel");
 for(unsigned width=1;width<=8;width*=2){prepare(width);baseline(width);compute(width);mixed(width);for(unsigned trial=0;trial<TRIALS;trial++)for(unsigned order=0;order<3;order++){unsigned variant=trial%2?2-order:order;run(width,trial,variant,order);}}
 fprintf(stderr,"sink=%" PRIu64 "\n",sink);return 0;
}
