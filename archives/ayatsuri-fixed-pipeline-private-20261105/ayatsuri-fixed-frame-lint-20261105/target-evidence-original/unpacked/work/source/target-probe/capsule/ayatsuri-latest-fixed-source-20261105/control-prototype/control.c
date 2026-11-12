#include "control.h"
#include <string.h>
#define C INT64_C(16777216)
/* Called only with magnitude below2^57, so negation/rounding cannot overflow. */
static int64_t rne(int64_t n,int64_t d){int neg=n<0;uint64_t a=(uint64_t)(neg?-n:n),q=a/(uint64_t)d,r=a%(uint64_t)d;q+=(r>(uint64_t)d-r)||(r==(uint64_t)d-r&&(q&1));return neg?-(int64_t)q:(int64_t)q;}
static int64_t prod(int64_t a,int64_t b){return rne(a*b,C);}
int cp_eval(const int32_t in[9],int side,unsigned bits,int diag,int32_t out[8]){
 if(!in||!out||(side!=-1&&side!=1)||(bits!=16&&bits!=20&&bits!=24)||(diag!=0&&diag!=1))return 1;
 for(unsigned i=0;i<9;i++){int64_t lo=(i==3||i==4||i==8)?-C:0,hi=i==5?2*C:C;if(in[i]<lo||in[i]>hi)return 2;}
 if(!diag&&in[5]%C)return 3;
 int64_t x=in[3],z=in[4],p=in[8],xp=x>0?x:0,xn=x<0?-x:0,zp=z>0?z:0,zn=z<0?-z:0;
 int64_t cx=(side<0?-INT64_C(297581104):INT64_C(297581104))+prod(side<0?28238336:25789131,xp)-prod(side<0?25789131:28238336,xn);
 int64_t cz=INT64_C(2727601659)+prod(16114717,zp)-prod(16412144,zn);
 int64_t h=-3509910;h=prod(h,p)+396432;h=prod(h,p)+12000294;h=prod(h,p)-50148371;h=prod(h,p)+1014394944;
 int64_t vals[8]={ (int64_t)(in[0]>in[side<0?1:2]?in[0]:in[side<0?1:2])*64,cx,cz,(int64_t)in[5]*64,(int64_t)in[6]*64,p*64,h,(int64_t)in[7]*64};
 int32_t temp[8];for(unsigned i=0;i<8;i++)temp[i]=(int32_t)rne(vals[i],INT64_C(1)<<(30-bits));
 memcpy(out,temp,sizeof(temp));return 0;
}
int cp_block(const int32_t *in,int side,unsigned bits,int diag,unsigned width,int32_t *out){
 if(!in||!out||(width!=1&&width!=2&&width!=4&&width!=8))return 1;
 int32_t temp[64];for(unsigned i=0;i<width;i++){int e=cp_eval(in+9*i,side,bits,diag,temp+8*i);if(e)return e;}memcpy(out,temp,width*8*sizeof(int32_t));return 0;
}
