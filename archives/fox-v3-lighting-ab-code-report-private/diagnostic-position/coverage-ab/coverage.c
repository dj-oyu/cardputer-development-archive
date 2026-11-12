#include <math.h>
#include <stdint.h>
#include <string.h>
typedef struct{double a,b,c;int sign,closed;} Edge;
static Edge edge(const float*a,const float*b){double dx=(double)b[0]-a[0],dy=(double)b[1]-a[1];Edge e={.sign=1,.closed=dy<0||(dy==0&&dx>0)};if(a[0]>b[0]||(a[0]==b[0]&&a[1]>b[1])){const float*t=a;a=b;b=t;e.sign=-1;}e.a=(double)a[1]-b[1];e.b=(double)b[0]-a[0];e.c=((double)b[1]-a[1])*a[0]-((double)b[0]-a[0])*a[1];return e;}
/* Rows: node, x0,y0,x1,y1,x2,y2. Projected winding must be positive. */
int coverage(const float*t,int n,int grid,double radius,uint16_t*out){
 if(!t||!out||n<1||n>16384||grid<1||grid>255||!isfinite(radius)||radius<0||radius>1.5)return 0;
 for(int i=0;i<n;i++){const float*v=t+7*i+1;for(int j=0;j<6;j++)if((!isfinite(v[j])||fabs(v[j])>4096))return 0;double a=((double)v[2]-v[0])*((double)v[5]-v[1])-((double)v[3]-v[1])*((double)v[4]-v[0]);if(!(a>1e-5))return 0;}
 memset(out,0,240*135*sizeof(uint16_t));uint8_t hit[240*135];
 for(int gy=0;gy<grid;gy++)for(int gx=0;gx<grid;gx++){
 double ox=-radius+(gx+.5)*2*radius/grid,oy=-radius+(gy+.5)*2*radius/grid;memset(hit,0,sizeof hit);
 for(int i=0;i<n;i++){const float*v=t+7*i+1;Edge e[3]={edge(v+2,v+4),edge(v+4,v),edge(v,v+2)};
 int l=(int)ceil(fmin(v[0],fmin(v[2],v[4]))-ox),r=(int)floor(fmax(v[0],fmax(v[2],v[4]))-ox),top=(int)ceil(fmin(v[1],fmin(v[3],v[5]))-oy),bot=(int)floor(fmax(v[1],fmax(v[3],v[5]))-oy);if(l<0)l=0;if(r>239)r=239;if(top<0)top=0;if(bot>134)bot=134;
 for(int y=top;y<=bot;y++)for(int x=l;x<=r;x++){int inside=1;for(int k=0;k<3;k++){double w=e[k].sign*(e[k].a*(x+ox)+e[k].b*(y+oy)+e[k].c);if(w<0||(w==0&&!e[k].closed)){inside=0;break;}}if(inside)hit[y*240+x]=1;}}
 for(int i=0;i<240*135;i++)out[i]+=hit[i];}return 1;}
