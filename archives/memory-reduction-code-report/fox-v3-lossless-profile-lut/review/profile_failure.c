#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
int new_eval(const float*,float*);
static unsigned calls,fail_at;
int lossless_fetch(const uint8_t *p,size_t n,uint32_t v,uint16_t out[3]){(void)p;(void)n;(void)v;calls++;if(calls==fail_at)return 0;out[0]=0;out[1]=32768;out[2]=65535;return 1;}
int main(void){for(fail_at=1;fail_at<=4;fail_at++){float in[3]={.1f,.2f,.3f},out[3]={.4f,.5f,.6f},copy[3];memcpy(copy,out,sizeof copy);calls=0;assert(new_eval(in,out)==3&&calls==fail_at&&!memcmp(out,copy,sizeof copy));for(unsigned offset=0;offset<3;offset++){float a[5]={.1f,.2f,.3f,.4f,.5f},saved[5];memcpy(saved,a,sizeof a);calls=0;assert(new_eval(a,a+offset)==3&&calls==fail_at&&!memcmp(a,saved,sizeof a));}}
float in[3]={-1,0,0},out[3]={1,2,3};calls=0;assert(new_eval(in,out)==2&&calls==0&&out[0]==1&&out[1]==2&&out[2]==3);puts("PASS forced_decoder_failures=16 invalid_skips_decode=1");}
