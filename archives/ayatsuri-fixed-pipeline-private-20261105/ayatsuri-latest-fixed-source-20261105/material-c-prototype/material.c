#include "material.h"
#include "../control-prototype/control.h"
#include <limits.h>
#include <string.h>
#ifndef MBITS
#define MBITS 20
#endif
#define S (INT64_C(1)<<MBITS)
static uint64_t mag(int64_t a){return a<0?(uint64_t)(-(a+1))+1:(uint64_t)a;}
static int64_t signedmag(uint64_t a,int neg,int *e){if(a>(neg?UINT64_C(9223372036854775808):INT64_MAX)){*e=4;return 0;}if(neg&&a==UINT64_C(9223372036854775808))return INT64_MIN;return neg?-(int64_t)a:(int64_t)a;}
static int64_t ad(int64_t a,int64_t b,int *e){if((b>0&&a>INT64_MAX-b)||(b<0&&a<INT64_MIN-b)){*e=4;return 0;}return a+b;}
static int64_t su(int64_t a,int64_t b,int *e){if((b<0&&a>INT64_MAX+b)||(b>0&&a<INT64_MIN+b)){*e=4;return 0;}return a-b;}
static int64_t rawmul(int64_t a,int64_t b,int *e){uint64_t x=mag(a),y=mag(b),lim=((a<0)^(b<0))?UINT64_C(9223372036854775808):INT64_MAX;if(y&&x>lim/y){*e=4;return 0;}return signedmag(x*y,(a<0)^(b<0),e);}
static int64_t roundiv(int64_t a,int64_t b,int *e){if(!b){*e=5;return 0;}uint64_t x=mag(a),y=mag(b),q=x/y,r=x%y;q+=(r>y-r)||(r==y-r&&(q&1));return signedmag(q,(a<0)^(b<0),e);}
static int64_t mu(int64_t a,int64_t b,int *e){int64_t p=rawmul(a,b,e);return roundiv(p,S,e);}
static int64_t di(int64_t a,int64_t b,int *e){int64_t p=rawmul(a,S,e);return roundiv(p,b,e);}
static int64_t mn(int64_t a,int64_t b){return a<b?a:b;}
static int64_t mx(int64_t a,int64_t b){return a>b?a:b;}
static int64_t cl(int64_t a){return mn(S,mx(0,a));}
static uint64_t root(uint64_t x){uint64_t r=0,bit=UINT64_C(1)<<62;while(bit>x)bit>>=2;while(bit){if(x>=r+bit){x-=r+bit;r=(r>>1)+bit;}else r>>=1;bit>>=2;}return r;}
static int64_t sq(int64_t a,int *e){int64_t p=rawmul(mx(0,a),S,e);if(*e)return 0;uint64_t v=(uint64_t)p,q=root(v);if(v-q*q>q)q++;return (int64_t)q;}
static int64_t ramp(const int64_t t[257][3],int64_t a,unsigned k,int *e){uint64_t f=(uint64_t)cl(a)*256,i=f/(uint64_t)S;int64_t w=(int64_t)(f%S);if(!w)return t[i][k];int64_t x=rawmul(S-w,t[i][k],e),y=rawmul(w,t[i+1][k],e);return roundiv(ad(x,y,e),S,e);}
#if MBITS==16
#include "generated-q16.inc"
#elif MBITS==20
#include "generated-q20.inc"
#elif MBITS==24
#include "generated-q24.inc"
#else
#error Unsupported MBITS
#endif
_Static_assert(NSLOTS<=MC_CAPACITY,"capacity");
#define TAG (0x4d430000u+MBITS)
unsigned mc_bits(void){return MBITS;}
int mc_prepare(const int32_t controls[9],int side,int diag,mc_frame *out){if(!out)return 1;int32_t u[8];int e=cp_eval(controls,side,MBITS,diag,u);if(e)return e;mc_frame tmp={0};tmp.side=side;tmp.tag=TAG;tmp.params[0]=ROUGHNESS;tmp.params[1]=3*S/2;tmp.params[2]=u[7];if(side<0)uniform_left(tmp.values,u,0,&e);else uniform_right(tmp.values,u,0,&e);if(e)return e;memcpy(out,&tmp,sizeof tmp);return 0;}
int mc_eval(const mc_frame *f,const int32_t xz[2],mc_output *out){if(!f||!xz||!out||f->tag!=TAG||(f->side!=-1&&f->side!=1))return 1;if(xz[0]<-S||xz[0]>S||xz[1]<2*S||xz[1]>16*S/5)return 2;int e=0;int64_t v[NSLOTS];memcpy(v,f->values,sizeof v);if(f->side<0)spatial_left(v,0,xz,&e);else spatial_right(v,0,xz,&e);if(e)return e;const unsigned *ix=f->side<0?color_left:color_right;mc_output tmp;for(unsigned k=0;k<3;k++){tmp.color[k]=v[ix[k]];tmp.params[k]=f->params[k];}tmp.mix=cl(v[f->side<0?mask_left:mask_right]);tmp.transparent=S-tmp.mix;memcpy(out,&tmp,sizeof tmp);return 0;}
int mc_block(const mc_frame *f,const int32_t *xz,unsigned n,mc_output *out){if(!out||!xz||(n!=1&&n!=2&&n!=4&&n!=8))return 1;mc_output tmp[8];for(unsigned i=0;i<n;i++){int e=mc_eval(f,xz+2*i,tmp+i);if(e)return e;}memcpy(out,tmp,n*sizeof *tmp);return 0;}
