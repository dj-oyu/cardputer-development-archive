#include <assert.h>
#include <stdio.h>
#include "material.c"
int main(void){
 int e=0;assert(ad(INT64_MAX,1,&e)==0&&e==4);e=0;assert(su(INT64_MIN,1,&e)==0&&e==4);e=0;assert(rawmul(INT64_MIN,-1,&e)==0&&e==4);e=0;assert(rawmul(INT64_MIN,1,&e)==INT64_MIN&&!e);e=0;assert(roundiv(INT64_MIN,-1,&e)==0&&e==4);e=0;assert(di(S,0,&e)==0&&e==5);e=0;assert(sq(INT64_MAX,&e)==0&&e==4);e=0;assert(sq(-1,&e)==0&&!e);assert(sq(S,&e)==S);assert(roundiv(1,2,&e)==0&&roundiv(3,2,&e)==2&&roundiv(5,2,&e)==2&&roundiv(-1,2,&e)==0&&roundiv(-3,2,&e)==-2&&roundiv(-5,2,&e)==-2);
 assert(ramp(lut_shared,-1,0,&e)==lut_shared[0][0]);assert(ramp(lut_shared,S+1,1,&e)==lut_shared[256][1]);
 int32_t q[9]={0},xz[16];mc_frame f;mc_output out[8],saved[8];unsigned seed=72;
 for(unsigned n=0;n<2000;n++){
  for(unsigned j=0;j<9;j++){seed=seed*1664525u+1013904223u;q[j]=(int32_t)(seed%16777217u);if(j==3||j==4||j==8)q[j]=(int32_t)(seed%33554433u)-16777216;if(j==5)q[j]=(int32_t)(seed%3)*16777216;}
  assert(!mc_prepare(q,n&1?1:-1,0,&f));
  for(unsigned j=0;j<8;j++){seed=seed*1664525u+1013904223u;xz[j*2]=(int32_t)(seed%(2*S+1))-S;seed=seed*1664525u+1013904223u;xz[j*2+1]=2*S+(int32_t)(seed%(6*S/5+1));}
  for(unsigned w=1;w<=8;w*=2){assert(!mc_block(&f,xz,w,out));for(unsigned i=0;i<w;i++){mc_output single;assert(!mc_eval(&f,xz+2*i,&single));assert(!memcmp(&single,out+i,sizeof single));}}
 }
 memset(out,0x39,sizeof out);memcpy(saved,out,sizeof out);xz[15]=4*S;assert(mc_block(&f,xz,8,out)==2);assert(!memcmp(out,saved,sizeof out));assert(mc_block(&f,xz,3,out));assert(!memcmp(out,saved,sizeof out));mc_frame old=f;q[8]=16777217;assert(mc_prepare(q,1,0,&f));assert(!memcmp(&f,&old,sizeof f));assert(mc_eval(0,xz,out));assert(mc_eval(&f,0,out));f.tag=0;assert(mc_eval(&f,xz,out));assert(!memcmp(out,saved,sizeof out));
 printf("PASS Q%d helper extrema/ties/zero/sqrt/ramp,2000 native batches,width1/2/4/8,atomic failures\n",MBITS);
 printf("frame_bytes=%zu slots=%d scratch_values_bytes=%zu output_bytes=%zu batch8_staging_bytes=%zu shared_lut_bytes=%zu shipping_lut_bytes=%zu\n",sizeof(mc_frame),NSLOTS,(size_t)NSLOTS*sizeof(int64_t),sizeof(mc_output),8*sizeof(mc_output),sizeof(lut_shared),sizeof(lut_shared)+0);return 0;
}
