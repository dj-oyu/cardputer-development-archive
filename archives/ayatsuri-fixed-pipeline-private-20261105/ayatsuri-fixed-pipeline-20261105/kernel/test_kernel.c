#include "fixed_kernel.h"
#include "reference.h"
#include <stdio.h>
#include <fenv.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#define N 100000
static uint64_t state=0xa5b43920e727c1d3ULL;
static uint32_t rng(void){state^=state<<13;state^=state>>7;state^=state<<17;return (uint32_t)state;}
static double unit(void){return rng()/4294967295.0;}
static int cmp(const void*a,const void*b){double x=*(const double*)a,y=*(const double*)b;return (x>y)-(x<y);}
static double errors[3][N];
static void negatives(void){
 int16_t w[3],v;double b[3]={0,0,0};assert(!fk_weights(b,w));b[0]=NAN;assert(!fk_weights(b,w));b[0]=INFINITY;assert(!fk_weights(b,w));b[0]=1.0000001;b[1]=-.0000001;assert(!fk_weights(b,w));b[0]=.5;b[1]=.5;b[2]=1e-8;assert(!fk_weights(b,w));
 assert(!fk_encode(NAN,1,&v));assert(!fk_encode(INFINITY,1,&v));assert(!fk_encode(1,0,&v));assert(!fk_encode(32768,1,&v));assert(!fk_encode(-32769,1,&v));assert(!fk_encode(1e300,1e300,&v));
 int16_t a[3]={-32768,32767,123};w[0]=16384;w[1]=w[2]=0;assert(fk_scalar(w,a,&v)&&v==-32768);w[0]=0;w[1]=16384;assert(fk_scalar(w,a,&v)&&v==32767);w[0]=-1;assert(!fk_scalar(w,a,&v));w[0]=1;assert(!fk_scalar(w,a,&v));
 assert(fk_round(8192)==0&&fk_round(-8192)==0&&fk_round(8191)==0&&fk_round(-8191)==0);
 for(int k=-5;k<=5;k++){double x=k*.5;int16_t expect=(int16_t)(k==1||k==-1?0:k==3?2:k==-3?-2:k==5?2:k==-5?-2:k/2);assert(fk_encode(x,1,&v)&&v==expect);assert(fk_round((int64_t)k*8192)==expect);}
 assert(fk_encode(-32768.5,1,&v)&&v==-32768);assert(fk_encode(32767.49,1,&v)&&v==32767);assert(!fk_encode(32767.5,1,&v));assert(!fk_encode(-32768.5001,1,&v));
 assert(fk_round((int64_t)-32768*16384+8192)==-32768);assert(fk_round((int64_t)32767*16384-8192)==32766);
 double thirds[3]={1.0/3,1.0/3,1.0/3};assert(fk_weights(thirds,w));assert(w[0]==5462&&w[1]==5461&&w[2]==5461);
 fk_tile t={0};int16_t o[8];assert(!fk_block(&t,3,o));assert(!fk_block(&t,8,o));
 for(int j=0;j<3;j++){double b2[3]={0};b2[j]=1;assert(fk_weights(b2,w));assert(w[j]==16384);}
}
int main(void){
 assert(fegetround()==FE_TONEAREST);negatives();double palette_max=0;
 for(unsigned c=0;c<65536;c++)for(unsigned k=0;k<3;k++){double x=ref_color((uint16_t)c,k);int16_t q;assert(fk_encode(x,32767,&q));double e=fabs(q/32767.0-x);if(e>palette_max)palette_max=e;}
 unsigned mismatches=0;double max_weight=0;
 for(unsigned n=0;n<N;n++){
  double b[3]={unit(),unit(),unit()},s=b[0]+b[1]+b[2];for(int j=0;j<3;j++)b[j]/=s;
  if(n<3){b[0]=b[1]=b[2]=0;b[n]=1;}if(n==3){b[0]=b[1]=.5;b[2]=0;}if(n==4){b[0]=b[1]=b[2]=1.0/3;}
  int16_t w[3];assert(fk_weights(b,w));assert(w[0]+w[1]+w[2]==FK_ONE);
  for(int j=0;j<3;j++){double e=fabs(w[j]/16384.0-b[j]);if(e>max_weight)max_weight=e;}
  for(unsigned mode=0;mode<3;mode++){
   double a[3],scale=mode==2?1024:32767;int16_t q[3],o;
   for(int j=0;j<3;j++){a[j]=mode==0?ref_color((uint16_t)rng(),n%3):mode==1?((int)(rng()%65535)-32767)/32767.0:(unit()*63.9990234375-32);assert(fk_encode(a[j],scale,&q[j]));}
   assert(fk_scalar(w,q,&o));errors[mode][n]=fabs(o/scale-(mode==0?ref_rho(b,a):ref_affine(b,a)));
   fk_tile t={0};for(int j=0;j<3;j++)for(int lane=0;lane<8;lane++){t.w[j][lane]=w[j];t.a[j][lane]=(int16_t)(lane%2?q[j]:-1-j);}
   for(int lane=1;lane<8;lane++){double bb[3]={unit(),unit(),unit()},ss=bb[0]+bb[1]+bb[2];for(int j=0;j<3;j++)bb[j]/=ss;int16_t ww[3];assert(fk_weights(bb,ww));for(int j=0;j<3;j++){t.w[j][lane]=ww[j];t.a[j][lane]=(int16_t)((int)(rng()%65536)-32768);}}
   for(unsigned lanes=1;lanes<=8;lanes*=2){int16_t out[8];assert(fk_block(&t,lanes,out));for(unsigned lane=0;lane<lanes;lane++){int16_t aa[3],ww[3],expected;for(int j=0;j<3;j++){aa[j]=t.a[j][lane];ww[j]=t.w[j][lane];}assert(fk_scalar(ww,aa,&expected));mismatches+=out[lane]!=expected;}}
  }
 }
 assert(!mismatches);printf("samples=%d per attribute; scalar/block mismatches=%u; palette max=%.12g; weight max=%.12g\n",N,mismatches,palette_max,max_weight);
 for(int m=0;m<3;m++){double ss=0;for(int i=0;i<N;i++)ss+=errors[m][i]*errors[m][i];qsort(errors[m],N,sizeof(double),cmp);printf("%s max=%.12g rms=%.12g p50=%.12g p95=%.12g p99=%.12g\n",m==0?"linear_rho":m==1?"normal":"local_position",errors[m][N-1],sqrt(ss/N),errors[m][N/2],errors[m][95*N/100],errors[m][99*N/100]);}
 puts("PASS: endpoints, half ties, invalid domains, exhaustive RGB565 palette, 1/2/4/8 lanes");return 0;
}
