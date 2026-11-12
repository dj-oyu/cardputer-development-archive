/* Private bounded integer geometry experiment. No float in this translation unit. */
#include "geometry.h"
#include <stddef.h>
#include <string.h>
#ifndef SUBPIX
#define SUBPIX 8
#endif
#if SUBPIX != 8 && SUBPIX != 10
#error "Only proved SUBPIX values 8 and 10 are supported"
#endif
#define SCREEN (INT32_C(4096)<<SUBPIX)
#define COEF (INT32_C(1)<<28)
/* All APIs return 0 success, -1 rejected input; sample returns 1 covered, 0 outside,
 * -1 rejected. Degenerate projected triangles are outside. No clipping. */
static int valid_camera(const Camera *c){
 if(!c || (c->frac!=16 && c->frac!=20) || c->width<1 || c->width>2048 || c->height<1 || c->height>2048)return 0;
 for(int k=0;k<9;k++)if(c->m[k]<-COEF||c->m[k]>COEF)return 0;
 for(int k=0;k<3;k++)if(c->offset[k]<-SCREEN||c->offset[k]>SCREEN)return 0;
 return 1;
}
/* nearest ties-even, no signed right shifts or negative left shifts. n safely > INT64_MIN. */
static int64_t rounded(int64_t n,int shift){
 int sign=n<0?-1:1; int64_t a=n<0?-n:n, d=INT64_C(1)<<shift;
 int64_t q=a/d,r=a%d; if(r>d/2 || (r==d/2 && (q%2)))q++;
 return sign*q;
}
int project(const Camera *c,const int32_t p[3],Point *out){
 if(!p||!out||!valid_camera(c))return -1;
 int64_t lim=INT64_C(128)*(INT64_C(1)<<c->frac);
 for(int k=0;k<3;k++)if(p[k]<-lim||p[k]>lim)return -1;
 Point v; int32_t r[3];
 for(int j=0;j<3;j++){
  int64_t dot=0; for(int k=0;k<3;k++)dot+=(int64_t)p[k]*c->m[3*j+k];
  int64_t s=rounded(dot,c->frac+20-SUBPIX)+c->offset[j];
  if(s < -SCREEN || s > SCREEN)return -1;
  r[j]=(int32_t)s;
 }
 v.x=r[0];v.y=r[1];v.z=r[2];*out=v;return 0;
}
/* Batching is a scalar reference schedule, NOT an instruction-level SIMD implementation. */
int project_batch(const Camera *c,const int32_t *p,Point *out,int n,int lanes){
 if(!c||!p||!out||n<0||n>32||(lanes!=1&&lanes!=2&&lanes!=4&&lanes!=8))return -1;
 Point tmp[32]; for(int b=0;b<n;b+=lanes)for(int l=0;l<lanes&&b+l<n;l++)if(project(c,p+3*(b+l),tmp+b+l))return -1;
 memcpy(out,tmp,(size_t)n*sizeof(Point));return 0;
}
static int valid_point(Point p){return p.x>=-SCREEN&&p.x<=SCREEN&&p.y>=-SCREEN&&p.y<=SCREEN&&p.z>=-SCREEN&&p.z<=SCREEN;}
static int64_t edge(Point a,Point b,Point p){return ((int64_t)b.x-a.x)*((int64_t)p.y-a.y)-((int64_t)b.y-a.y)*((int64_t)p.x-a.x);}
/* Screen y increases downward; positive oriented triangle's inclusive edges are top/left. */
static int inclusive(Point a,Point b){int64_t dx=(int64_t)b.x-a.x,dy=(int64_t)b.y-a.y;return dy<0||(dy==0&&dx>0);}
static int lex_before(Point a,Point b){return a.x<b.x||(a.x==b.x&&(a.y<b.y||(a.y==b.y&&a.z<b.z)));}
int sample(const Point original[3],int32_t x,int32_t y,int16_t weights[3]){
 if(!original||!weights||x< -SCREEN||x>SCREEN||y< -SCREEN||y>SCREEN)return -1;
 for(int k=0;k<3;k++)if(!valid_point(original[k]))return -1;
 Point t[3]={original[0],original[1],original[2]},p={x,y,0};int idx[3]={0,1,2};
 int64_t area=edge(t[0],t[1],t[2]);if(!area)return 0;
 if(area<0){Point s=t[1];t[1]=t[2];t[2]=s;idx[1]=2;idx[2]=1;area=-area;}
 int64_t e[3],rem[3];int32_t w[3],sum=0;
 for(int k=0;k<3;k++){
  int a=(k+1)%3,b=(k+2)%3;e[k]=edge(t[a],t[b],p);
  if(e[k]<0||(e[k]==0&&!inclusive(t[a],t[b])))return 0;
 }
 for(int k=0;k<3;k++){int64_t n=e[k]*16384;w[k]=(int32_t)(n/area);rem[k]=n%area;sum+=w[k];}
 /* Largest remainder ensures exact sum 16384. Geometric tie-break preserves permutations. */
 for(int left=16384-sum;left>0;left--){int best=-1;for(int k=0;k<3;k++)if(rem[k]>=0&&(best<0||rem[k]>rem[best]||(rem[k]==rem[best]&&lex_before(t[k],t[best]))))best=k;w[best]++;rem[best]=-1;}
 for(int k=0;k<3;k++)weights[idx[k]]=(int16_t)w[k];
 return 1;
}
int sample_batch(const Point t[3],const int32_t *xy,int n,int lanes,int8_t *covered,int16_t *weights){
 if(!t||!xy||!covered||!weights||n<0||n>32||(lanes!=1&&lanes!=2&&lanes!=4&&lanes!=8))return -1;
 int8_t c[32];int16_t w[96]={0};
 for(int b=0;b<n;b+=lanes)for(int l=0;l<lanes&&b+l<n;l++){int i=b+l;c[i]=(int8_t)sample(t,xy[2*i],xy[2*i+1],w+3*i);if(c[i]<0)return -1;}
 memcpy(covered,c,(size_t)n);memcpy(weights,w,(size_t)n*3*sizeof(int16_t));return 0;
}
