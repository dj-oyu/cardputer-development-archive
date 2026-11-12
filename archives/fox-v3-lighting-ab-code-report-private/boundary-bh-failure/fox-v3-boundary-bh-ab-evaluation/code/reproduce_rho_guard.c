/* Read-only one-point numerical reproduction; no renderer or quota changes. */
#include "ayatsuri/compact_opaque.h"
#include "ayatsuri/ayatsuri_shade.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <float.h>
#include <math.h>
typedef struct {double a,b,c;int sign;} edge;
static edge make(const co_vertex*a,const co_vertex*b){edge e={.sign=1};if(a->x>b->x||(a->x==b->x&&a->y>b->y)){const co_vertex*t=a;a=b;b=t;e.sign=-1;}e.a=(double)a->y-b->y;e.b=(double)b->x-a->x;e.c=((double)b->y-a->y)*a->x-((double)b->x-a->x)*a->y;return e;}
int main(int argc,char**argv){assert(argc==2);FILE*f=fopen(argv[1],"rb");assert(f);unsigned char b[65536];size_t n=fread(b,1,sizeof b,f);fclose(f);co_view v;assert(n==64208&&co_read(b+416+35460,n-416-35460,&v));uint8_t ix[3];bool back;assert(co_triangle_at(&v,4,ix)&&co_triangle_side(&v,4,&back));co_vertex q[3];for(int j=0;j<3;j++)assert(co_vertex_at_side(&v,ix[j],back,q+j));double area=((double)q[1].x-q[0].x)*((double)q[2].y-q[0].y)-((double)q[1].y-q[0].y)*((double)q[2].x-q[0].x),inv=1/area;edge e[3]={make(q+1,q+2),make(q+2,q),make(q,q+1)};double x=123-0x1.272062ae104d0p-2,y=53-0x1.272062ae104d0p-2,w[3],rho=0,sum=0;for(int j=0;j<3;j++){w[j]=e[j].sign*(e[j].a*x+e[j].b*y+e[j].c)*inv;sum+=w[j];assert(q[j].color_a==q[j].color_b);rho+=w[j]*ayatsuri_srgb_decode((q[j].color_a>>11)/31.0f);}double limit=1+64*DBL_EPSILON;assert(rho>limit);printf("{\"status\":\"EXPECTED_EXISTING_GUARD_REJECTION\",\"pixel\":[123,53],\"sample\":0,\"back\":%s,\"barySum\":%.17g,\"rhoRed\":%.17g,\"upperLimit\":%.17g,\"excessAboveOne\":%.17g,\"noShaderCalled\":true,\"noThresholdChanged\":true}\n",back?"true":"false",sum,rho,limit,rho-1);return 0;}
