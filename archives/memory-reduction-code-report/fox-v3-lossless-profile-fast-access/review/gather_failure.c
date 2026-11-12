#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
int new_eval(const float*,float*);
static unsigned calls;
int lossless_fetch4(const uint8_t*b,size_t n,const uint32_t v[4],uint16_t o[4][3]){(void)b;(void)n;(void)v;memset(o,0x7f,24);calls++;return 0;}
int main(void){for(unsigned off=0;off<3;off++){float a[5]={.1f,.2f,.3f,.4f,.5f},save[5];memcpy(save,a,sizeof a);calls=0;assert(new_eval(a,a+off)==3&&calls==1&&!memcmp(a,save,sizeof a));}float in[3]={.1f,.2f,.3f},out[3]={1,2,3},saved[3];memcpy(saved,out,sizeof out);calls=0;assert(new_eval(in,out)==3&&calls==1&&!memcmp(out,saved,sizeof out));in[0]=-1;calls=0;assert(new_eval(in,out)==2&&!calls&&!memcmp(out,saved,sizeof out));puts("PASS gather decoder failure output atomic including overlapping input/output; invalid skips decode");}
