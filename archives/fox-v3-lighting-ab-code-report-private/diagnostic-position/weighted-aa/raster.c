#include <math.h>
#include <stdint.h>
#include <string.h>
typedef struct{double a,b,c;int sign,closed;} Edge;
static Edge edge(const float*a,const float*b){double dx=(double)b[0]-a[0],dy=(double)b[1]-a[1];Edge e={.sign=1,.closed=dy<0||(dy==0&&dx>0)};if(a[0]>b[0]||(a[0]==b[0]&&a[1]>b[1])){const float*t=a;a=b;b=t;e.sign=-1;}e.a=(double)a[1]-b[1];e.b=(double)b[0]-a[0];e.c=((double)b[1]-a[1])*a[0]-((double)b[0]-a[0])*a[1];return e;}
/* Rows: node,face,side,ids[3], then3*(x,y,depth). */
int raster(const float*t,int n,double ox,double oy,int32_t*winner,float*weights){
 if(!t||!winner||!weights||n<1||n>16384||!isfinite(ox)||!isfinite(oy)||fabs(ox)>1.5||fabs(oy)>1.5)return 0;
 for(int i=0;i<n;i++){const float*v=t+15*i+6;for(int j=0;j<9;j++)if(!isfinite(v[j])||fabs(v[j])>4096)return 0;double a=((double)v[3]-v[0])*((double)v[7]-v[1])-((double)v[4]-v[1])*((double)v[6]-v[0]);if(!(a>1e-5))return 0;}
 float depths[240*135];for(int p=0;p<240*135;p++){depths[p]=-INFINITY;winner[p]=-1;}memset(weights,0,240*135*3*sizeof(float));
 for(int i=0;i<n;i++){const float*v=t+15*i+6;double area=((double)v[3]-v[0])*((double)v[7]-v[1])-((double)v[4]-v[1])*((double)v[6]-v[0]);const double inverse=1/area;Edge e[3]={edge(v+3,v+6),edge(v+6,v),edge(v,v+3)};
 int l=(int)ceil(fmin(v[0],fmin(v[3],v[6]))-ox),r=(int)floor(fmax(v[0],fmax(v[3],v[6]))-ox),top=(int)ceil(fmin(v[1],fmin(v[4],v[7]))-oy),bot=(int)floor(fmax(v[1],fmax(v[4],v[7]))-oy);if(l<0)l=0;if(r>239)r=239;if(top<0)top=0;if(bot>134)bot=134;
 for(int y=top;y<=bot;y++)for(int x=l;x<=r;x++){double w[3];int inside=1;for(int k=0;k<3;k++){w[k]=e[k].sign*(e[k].a*(x+ox)+e[k].b*(y+oy)+e[k].c);if(w[k]<0||(w[k]==0&&!e[k].closed)){inside=0;break;}}if(!inside)continue;for(int k=0;k<3;k++)w[k]*=inverse;float depth=(float)(w[0]*v[2]+w[1]*v[5]+w[2]*v[8]);if(!isfinite(depth))return 0;int p=y*240+x;if(depth<=depths[p])continue;depths[p]=depth;winner[p]=i;for(int k=0;k<3;k++)weights[3*p+k]=(float)w[k];}}
 return 1;}
