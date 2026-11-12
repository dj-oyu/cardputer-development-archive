#include "../code/profile_adapter.h"
#include "../../../fox-v3-indexed-bvh-bounds/cache/candidate_profile.c"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static uint16_t reference(agx_block_cache*c,const double rgb[3]){float f[3],v[3];uint32_t q[3];for(unsigned k=0;k<3;k++)f[k]=(float)rgb[k];assert(agx_cache_profile_eval(c,f,v)<=1);for(unsigned k=0;k<3;k++)q[k]=(unsigned)lroundf(v[k]*(k==1?63:31));return (q[0]<<11)|(q[1]<<5)|q[2];}
int main(int argc,char**argv){assert(argc==3);FILE*f=fopen(argv[1],"rb");assert(f);uint32_t n,count;assert(fread(&n,4,1,f)==1&&fread(&count,4,1,f)==1&&n<=32400&&(count==1||count==4));size_t values=(size_t)n*count*3;double*raw=malloc(values*8);uint64_t*q24=malloc(values*8);uint16_t*expected=malloc(n*2);assert(raw&&q24&&expected);assert(fread(raw,8,values,f)==values&&fread(q24,8,values,f)==values&&fread(expected,2,n,f)==n&&fgetc(f)==EOF);fclose(f);
 agx_block_cache oracle,cache;agx_cache_init(&oracle);assert(agx_cache_bind_profile(&oracle));assert(private_integer_profile_bind(&cache));
 /* STRICT baseline gate finishes for ALL records before any candidate runs. */
 for(unsigned i=0;i<n;i++){double sum[3]={0};for(unsigned j=0;j<count;j++)for(unsigned k=0;k<3;k++)sum[k]+=raw[(i*count+j)*3+k];for(unsigned k=0;k<3;k++)sum[k]/=count;assert(reference(&oracle,sum)==expected[i]);}printf("strict_float_baseline_parity=%u/%u candidate_not_run_before_gate=1\n",n,n);
 aa_state*states=malloc(n*sizeof *states);aa_result*out=malloc(n*sizeof *out);assert(states&&out);for(unsigned i=0;i<n;i++){assert(aa_init(states+i,count)==0);for(unsigned j=0;j<count;j++)assert(aa_put(states+i,j,AA_KEEP,q24+(i*count+j)*3,0)==0);assert(aa_finish(states+i,aa_private_profile,&cache,out+i)==0);}
 for(unsigned width=1;width<=8;width*=2){for(unsigned at=0;at<n;){unsigned m=n-at>=width?width:1;aa_result block[8];assert(aa_finish_block(states+at,m,aa_private_profile,&cache,block)==0);for(unsigned j=0;j<m;j++)assert(block[j].pixel==out[at+j].pixel&&block[j].high_clamped==out[at+j].high_clamped&&!memcmp(block[j].hdr19,out[at+j].hdr19,12));at+=m;}printf("width=%u mismatch=0\n",width);}
 FILE*r=fopen(argv[2],"w");assert(r);fprintf(r,"index,old565,new565,q24mean_float565,q19_float565,h19r,h19g,h19b,clamped\n");for(unsigned i=0;i<n;i++){double mean[3],h19[3];for(unsigned k=0;k<3;k++){mean[k]=(double)states[i].sum[k]/(count*16777216.0);h19[k]=out[i].hdr19[k]/524288.0;}fprintf(r,"%u,%u,%u,%u,%u,%u,%u,%u,%u\n",i,expected[i],out[i].pixel,reference(&oracle,mean),reference(&oracle,h19),out[i].hdr19[0],out[i].hdr19[1],out[i].hdr19[2],out[i].high_clamped);}fclose(r);free(raw);free(q24);free(expected);free(states);free(out);return 0;
}
