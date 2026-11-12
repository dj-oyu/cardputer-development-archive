#include "control.h"
#include <assert.h>
#include <string.h>
#include <stdio.h>
int main(void){int32_t in[72]={0},out[64],save[64],one[8];unsigned seed=123;
 for(int sign=-1;sign<=1;sign+=2)for(int n=1;n<=5;n+=2){in[8]=sign*n*128;assert(!cp_eval(in,-1,16,0,one));assert(one[5]==sign*(n==1?0:2));}
 in[8]=0;
 for(unsigned k=0;k<20000;k++){for(unsigned j=0;j<72;j++){seed=seed*1664525u+1013904223u;unsigned ix=j%9;in[j]=(int32_t)(seed%16777217u);if(ix==3||ix==4||ix==8)in[j]=(int32_t)(seed%33554433u)-16777216;if(ix==5)in[j]=(int32_t)(seed%3)*16777216;}
 for(unsigned w=1;w<=8;w*=2)for(unsigned b=16;b<=24;b+=4){assert(!cp_block(in,k&1?1:-1,b,0,w,out));for(unsigned i=0;i<w;i++){assert(!cp_eval(in+9*i,k&1?1:-1,b,0,one));assert(!memcmp(one,out+8*i,sizeof(one)));}}}
 memset(out,0x53,sizeof out);memcpy(save,out,sizeof out);in[71]=16777217;assert(cp_block(in,1,24,0,8,out));assert(!memcmp(out,save,sizeof out));assert(cp_block(in,1,24,0,3,out));assert(!memcmp(out,save,sizeof out));assert(cp_eval(0,1,24,0,out));assert(cp_eval(in,0,24,0,out));assert(cp_eval(in,1,17,0,out));assert(cp_eval(in,1,24,2,out));assert(!memcmp(out,save,sizeof out));
 puts("PASS20000 random batches, widths1/2/4/8, Q16/Q20/Q24, atomic invalid-final-lane and invalid-width/null");return 0;}
