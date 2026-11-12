#include "normal_bridge.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fenv.h>
#define NORMAL_TESTS 100000
static uint64_t state=0x638b829df0231567ULL;
static uint32_t random32(void){state^=state<<13;state^=state>>7;state^=state<<17;return (uint32_t)state;}
static double angle(const double a[3],const int16_t b[3]){double c[3]={a[1]*b[2]-a[2]*b[1],a[2]*b[0]-a[0]*b[2],a[0]*b[1]-a[1]*b[0]};double dot=a[0]*b[0]+a[1]*b[1]+a[2]*b[2];return atan2(hypot(hypot(c[0],c[1]),c[2]),dot)*57.2957795130823208768;}
static double angles[NORMAL_TESTS],actual[10000],encoded[10000];
static int cmp(const void*a,const void*b){double x=*(const double*)a,y=*(const double*)b;return (x>y)-(x<y);}
static void report(const char*name,double*a,unsigned n){double ss=0;for(unsigned i=0;i<n;i++)ss+=a[i]*a[i];qsort(a,n,sizeof(double),cmp);printf("%s n=%u angular_deg_max=%.12g rms=%.12g p95=%.12g p99=%.12g\n",name,n,a[n-1],sqrt(ss/n),a[n*95/100],a[n*99/100]);}
int main(int argc,char**argv){assert(argc==2&&fegetround()==FE_TONEAREST);unsigned accepted=0,rejected=0;for(unsigned i=0;i<NORMAL_TESTS;i++){int16_t n[3],o[3]={7,8,9};for(unsigned k=0;k<3;k++)n[k]=(int16_t)((int)(random32()%65536)-32768);il_normal_status s=il_normalize_interpolated(n,o);if(s!=IL_NORMAL_OK){assert(s==IL_NORMAL_NEAR_ZERO&&o[0]==7);rejected++;continue;}assert(il_normal_length(o));double ref[3]={n[0],n[1],n[2]};angles[accepted++]=angle(ref,o);int16_t alias[3];memcpy(alias,n,sizeof alias);assert(il_normalize_interpolated(alias,alias)==IL_NORMAL_OK&&!memcmp(alias,o,sizeof o));}printf("synthetic accepted=%u nearzero=%u\n",accepted,rejected);report("same_integer_input",angles,accepted);
 const int16_t edges[][3]={{0,0,0},{1,0,0},{511,0,0},{512,0,0},{-512,0,0},{32767,0,0},{-32768,0,0},{32767,32767,32767},{-32768,-32768,-32768},{512,1,1},{300,300,300},{295,295,295}};
 for(unsigned i=0;i<sizeof edges/sizeof*edges;i++){int16_t o[3]={7,8,9};il_normal_status s=il_normalize_interpolated(edges[i],o);printf("edge in=%d,%d,%d status=%d",edges[i][0],edges[i][1],edges[i][2],s);if(s==IL_NORMAL_OK){double ref[3]={edges[i][0],edges[i][1],edges[i][2]};printf(" out=%d,%d,%d angular_deg=%.12g",o[0],o[1],o[2],angle(ref,o));assert(il_normal_length(o));}else assert(o[0]==7&&o[1]==8&&o[2]==9);puts("");}
 FILE*f=fopen(argv[1],"rb");assert(f);double x[9];unsigned count=0,near=0;double minnorm=1e100;while(fread(x,sizeof(double),9,f)==9){int16_t n[3],o[3];for(unsigned k=0;k<3;k++){double q=nearbyint(x[k+3]*32767);assert(q>=-32768&&q<=32767);n[k]=(int16_t)q;}double norm=hypot(hypot(x[3],x[4]),x[5]);if(norm<minnorm)minnorm=norm;il_normal_status s=il_normalize_interpolated(n,o);if(s!=IL_NORMAL_OK){near++;continue;}assert(count<10000);actual[count]=angle(x+3,o);double ref[3]={n[0],n[1],n[2]};encoded[count]=angle(ref,o);count++;}assert(feof(f));fclose(f);printf("actual accepted=%u nearzero=%u input_norm_min=%.12g\n",count,near,minnorm);report("actual_including_input_quantization",actual,count);report("actual_same_integer_input",encoded,count);
 puts("PASS integer normal bridge, alias safety, magnitude boundary, extreme codes, actual corpus");return 0;}
