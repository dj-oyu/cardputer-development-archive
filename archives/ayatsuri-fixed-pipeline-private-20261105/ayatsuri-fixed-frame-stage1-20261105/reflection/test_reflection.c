#include "integer_reflection.h"
#include "frozen_direction.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fenv.h>
#define CAP 200000
static double errors[CAP],stable[CAP];
static uint64_t state=0xd2956ba73180c42fULL;
static uint32_t random32(void){state^=state<<13;state^=state>>7;state^=state<<17;return (uint32_t)state;}
static double angle(const double a[3],const int16_t b[3]){double c[3]={a[1]*b[2]-a[2]*b[1],a[2]*b[0]-a[0]*b[2],a[0]*b[1]-a[1]*b[0]};return atan2(hypot(hypot(c[0],c[1]),c[2]),a[0]*b[0]+a[1]*b[1]+a[2]*b[2])*57.2957795130823208768;}
static int cmp(const void*a,const void*b){double x=*(const double*)a,y=*(const double*)b;return(x>y)-(x<y);}
static void report(const char*tag,double*a,unsigned n){if(!n){printf("%s empty\n",tag);return;}double ss=0;for(unsigned i=0;i<n;i++)ss+=a[i]*a[i];qsort(a,n,sizeof(double),cmp);printf("%s n=%u angle_deg_max=%.12g rms=%.12g p95=%.12g p99=%.12g\n",tag,n,a[n-1],sqrt(ss/n),a[n*95/100],a[n*99/100]);}
static unsigned old_basis(const double n[3]){unsigned a=0;if(fabs(n[1])<fabs(n[a]))a=1;if(fabs(n[2])<fabs(n[a]))a=2;return a;}
static void corpus(const char*path){FILE*f=fopen(path,"rb");assert(f);double row[9];unsigned count=0,ok=0,amb=0,fail=0,swaps=0,missedflag=0,ne=0,ns=0;while(fread(row,sizeof(double),9,f)==9){int16_t n[3];for(unsigned k=0;k<3;k++){double q=nearbyint(row[k+3]*32767);assert(q>=-32768&&q<=32767);n[k]=(int16_t)q;}int16_t out[16][3];unsigned axis;hr_status s=hr_directions16(n,out,&axis);count++;if(s!=HR_OK&&s!=HR_BASIS_AMBIGUOUS){fail++;continue;}if(s==HR_OK)ok++;else amb++;double original[3];assert(norm(row+3,original));bool changed=axis!=old_basis(original);swaps+=changed;missedflag+=changed&&s==HR_OK;for(unsigned i=0;i<16;i++){double d[3];direction(original,16,i,d);double e=angle(d,out[i]);assert(ne<CAP);errors[ne++]=e;if(!changed)stable[ns++]=e;}
 for(unsigned width=1;width<=8;width*=2){int16_t in[8][3],outs[8][16][3];unsigned axes[8];hr_status sts[8];for(unsigned j=0;j<width;j++)for(unsigned k=0;k<3;k++)in[j][k]=n[(k+j)%3];assert(hr_block(in,width,outs,axes,sts));for(unsigned j=0;j<width;j++){int16_t single[16][3];unsigned ax;hr_status z=hr_directions16(in[j],single,&ax);assert(sts[j]==z);if(z==HR_OK||z==HR_BASIS_AMBIGUOUS)assert(axes[j]==ax&&!memcmp(outs[j],single,sizeof single));}}}
 assert(feof(f));fclose(f);printf("actual normals=%u ok=%u ambiguous=%u failure=%u source_basis_changes=%u unflagged_changes=%u widths_mismatch=0\n",count,ok,amb,fail,swaps,missedflag);report("actual_all_candidates",errors,ne);report("actual_same_basis",stable,ns);}
int main(int argc,char**argv){assert(argc==2&&fegetround()==FE_TONEAREST);corpus(argv[1]);
 const double edges[][3]={{0,0,1},{0,0,-1},{1,0,0},{0,1,0},{1,1,1},{1,1.00000001,1},{1.00000001,1,1},{0,0,0},{.0001,0,0},{1,0,1e-8},{.2,.200000001,.9},{.200000001,.2,.9}};
 for(unsigned j=0;j<sizeof edges/sizeof*edges;j++){int16_t n[3];double length=hypot(hypot(edges[j][0],edges[j][1]),edges[j][2]),scale=length>1?1/length:1;for(unsigned k=0;k<3;k++)n[k]=(int16_t)nearbyint(edges[j][k]*scale*32767);int16_t out[16][3];unsigned a=99;hr_status s=hr_directions16(n,out,&a);double max=0;if(s==HR_OK||s==HR_BASIS_AMBIGUOUS){double nn[3];assert(norm(edges[j],nn));for(unsigned i=0;i<16;i++){double d[3];direction(nn,16,i,d);double e=angle(d,out[i]);if(e>max)max=e;}}printf("boundary %u status=%d integer_basis=%u max_angle_deg=%.12g\n",j,s,a,max);}
 double max_error=0,ss=0;for(unsigned t=0;t<10000;t++){hr_fixed_sample sample[16];uint16_t rho[3];for(unsigned k=0;k<3;k++)rho[k]=(uint16_t)(random32()%32768);double ref[3]={0};for(unsigned i=0;i<16;i++){sample[i].active=random32()%2;for(unsigned k=0;k<3;k++){sample[i].direct[k]=random32();sample[i].world[k]=random32();sample[i].rho_secondary[k]=(uint16_t)(random32()%32768);if(sample[i].active)ref[k]+=(rho[k]/32767.0)*(sample[i].direct[k]/524288.0+(sample[i].rho_secondary[k]/32767.0)*(sample[i].world[k]/524288.0))/16;}}
 uint64_t out[3];assert(hr_reduce16(sample,rho,out));
 if(t%100==0)for(unsigned width=1;width<=8;width*=2){hr_fixed_sample many[8][16];uint16_t rr[8][3];uint64_t oo[8][3];bool ok[8];for(unsigned lane=0;lane<width;lane++){memcpy(many[lane],sample,sizeof sample);for(unsigned k=0;k<3;k++)rr[lane][k]=(uint16_t)((rho[k]+lane)%32768);}assert(hr_reduce_block(many,rr,width,oo,ok));for(unsigned lane=0;lane<width;lane++){uint64_t single[3];assert(hr_reduce16(many[lane],rr[lane],single)&&ok[lane]&&!memcmp(single,oo[lane],sizeof single));}}
for(unsigned k=0;k<3;k++){double e=fabs(out[k]/524288.0-ref[k]);if(e>max_error)max_error=e;ss+=e*e;assert(e<3.0/524288);}}
 printf("synthetic_fixed_reduction components=30000 abs_max=%.12g rms=%.12g\n",max_error,sqrt(ss/30000));
 hr_fixed_sample zero[16]={0};uint16_t rho[3]={32767,32767,32767};uint64_t out[3]={1,2,3};assert(hr_reduce16(zero,rho,out)&&out[0]==0);zero[0].active=2;assert(!hr_reduce16(zero,rho,out));zero[0].active=1;zero[0].rho_secondary[0]=32768;assert(!hr_reduce16(zero,rho,out));puts("PASS independent arithmetic only; no visibility/ray/hit queries");return 0;}
