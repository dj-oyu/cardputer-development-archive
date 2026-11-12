/* Generic test-only work counter; exact evaluator index arithmetic. */
#include <math.h>
#include <stdint.h>
#include <stddef.h>
#include "agx_profile.h"
#define AGX_N 65
#define AGX_LO 0.00017578139478918766
#define AGX_HI 5898.2400001325132
#define AGX_LOG_RANGE 17.328678720134185
void trace(const float *inputs,size_t n,uint64_t stats[12]) {
for(size_t sample=0;sample<n;sample++) {
 const float *in=inputs+sample*3;int valid=1;
 for(int c=0;c<3;c++)if(!isfinite(in[c])||in[c]<0)valid=0;
 if(!valid){stats[0]++;continue;}
 int flags=0,base[3],order[3]={0,1,2}; float f[3];
 for(int c=0;c<3;c++) { double x=in[c]; if(x>AGX_HI){x=AGX_HI; flags|=AGX_PROFILE_CLAMP_HIGH;}
 double u=log1p(x/AGX_LO)/AGX_LOG_RANGE*(AGX_N-1); base[c]=(int)floor(u); if(base[c]>=AGX_N-1)base[c]=AGX_N-2; f[c]=(float)(u-base[c]); }
 for(int i=0;i<2;i++)for(int j=i+1;j<3;j++)if(f[order[j]]>f[order[i]]){int t=order[i];order[i]=order[j];order[j]=t;}
 int ix=(base[0]*AGX_N+base[1])*AGX_N+base[2];int stride[3]={AGX_N*AGX_N,AGX_N,1};

 unsigned values=0,blocks[4],unique=0;
 for(unsigned k=0;k<4;k++){
  unsigned x=(unsigned)ix/4225,y=(unsigned)ix/65%65,z=(unsigned)ix%65;
  unsigned bx=x/4,by=y/4,bz=z/4,block=(bx*17+by)*17+bz;
  unsigned sx=bx==16?1:4,sy=by==16?1:4,sz=bz==16?1:4;
  values+=3*sx*sy*sz;unsigned found=0;
  for(unsigned j=0;j<unique;j++)if(blocks[j]==block)found=1;
  if(!found)blocks[unique++]=block;
  if(k<3)ix+=stride[order[k]];
 }
 stats[1]++;stats[2]+=4;stats[3]+=12;stats[4]+=values;
 if(values>stats[5])stats[5]=values;
 stats[5+unique]++;
}
}
