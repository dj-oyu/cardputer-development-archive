#include "../code/radiance_bridge.h"
#include <assert.h>
#include <string.h>
#include <stdio.h>
#include <inttypes.h>
static uint64_t random_state=UINT64_C(0x754196601d521a17);
static uint64_t next(void){random_state^=random_state<<13;random_state^=random_state>>7;random_state^=random_state<<17;return random_state;}
static rb_status oracle(const rb_rgb_q24*t,size_t n,const rb_rgb_q19*r,rb_rgb_q24*out){rb_rgb_q24 v;for(unsigned k=0;k<3;k++){__uint128_t x=(__uint128_t)r->channel[k]*32;if(x>UINT64_MAX)return RB_SCALE_OVERFLOW;if(x>AA_SAMPLE_MAX)return RB_AA_RANGE;v.channel[k]=(uint64_t)x;}for(size_t i=0;i<n;i++)for(unsigned k=0;k<3;k++){__uint128_t x=(__uint128_t)v.channel[k]+t[i].channel[k];if(x>AA_SAMPLE_MAX)return RB_AA_RANGE;v.channel[k]=(uint64_t)x;}*out=v;return RB_OK;}
int main(void){rb_rgb_q24 out,prior;memset(&out,0x5a,sizeof out);prior=out;rb_rgb_q19 q={{0,1,UINT64_C(8589934590)}};assert(rb_q19_to_q24(&q,&out)==0&&out.channel[0]==0&&out.channel[1]==32&&out.channel[2]==UINT64_C(274877906880));
 const uint64_t boundary[]={0,1,2,3,(AA_SAMPLE_MAX>>5)-1,AA_SAMPLE_MAX>>5,(AA_SAMPLE_MAX>>5)+1,UINT64_MAX>>5,(UINT64_MAX>>5)+1,UINT64_MAX};
 for(unsigned i=0;i<sizeof boundary/sizeof *boundary;i++){q=(rb_rgb_q19){{boundary[i],boundary[i],boundary[i]}};out=prior;rb_rgb_q24 want;rb_status s=oracle(0,0,&q,&want);assert(rb_q19_to_q24(&q,&out)==s);if(!s)assert(!memcmp(&out,&want,sizeof out));else assert(!memcmp(&out,&prior,sizeof out));}
 assert(rb_q19_to_q24(0,&out)==RB_INVALID&&rb_q19_to_q24(&q,0)==RB_INVALID);q=(rb_rgb_q19){{0,0,0}};assert(rb_merge(0,1,&q,&out)==RB_INVALID&&rb_merge(0,9,&q,&out)==RB_INVALID&&rb_merge(0,0,0,&out)==RB_INVALID);
 rb_rgb_q24 t={{AA_SAMPLE_MAX,AA_SAMPLE_MAX,AA_SAMPLE_MAX}};assert(rb_merge(&t,1,&q,&out)==0&&!memcmp(&out,&t,sizeof t));q.channel[0]=1;out=prior;assert(rb_merge(&t,1,&q,&out)==RB_AA_RANGE&&!memcmp(&out,&prior,sizeof out));
 unsigned counts[4]={0};uint64_t hash=UINT64_C(1469598103934665603);
 for(unsigned trial=0;trial<100000;trial++){rb_rgb_q24 terms[8];size_t n=next()%9;for(unsigned k=0;k<3;k++){q.channel[k]=next();if(trial%4==0)q.channel[k]&=(UINT64_C(1)<<33)-1;else if(trial%4==1)q.channel[k]&=(UINT64_C(1)<<36)-1;else if(trial%4==2)q.channel[k]=(AA_SAMPLE_MAX>>5)+(next()%5)-2;}
 for(size_t i=0;i<n;i++)for(unsigned k=0;k<3;k++)terms[i].channel[k]=trial%4==0?next()%((UINT64_C(1)<<36)):next();rb_rgb_q24 expected;rb_status a=oracle(terms,n,&q,&expected);out=prior;rb_status b=rb_merge(terms,n,&q,&out);assert(a==b);if(a==RB_OK)assert(!memcmp(&out,&expected,sizeof out));else assert(!memcmp(&out,&prior,sizeof out));counts[b]++;hash=(hash^(uint64_t)b)*UINT64_C(1099511628211);
 rb_job jobs[8];rb_rgb_q24 results[8],saved[8];for(unsigned j=0;j<8;j++){jobs[j].terms=terms;jobs[j].count=n;jobs[j].reflection=q;}for(unsigned width=1;width<=8;width*=2){memset(results,0x6a,sizeof results);memcpy(saved,results,sizeof results);assert(rb_merge_block(jobs,width,results)==a);if(a)assert(!memcmp(results,saved,sizeof results));else for(unsigned j=0;j<width;j++)assert(!memcmp(results+j,&expected,sizeof expected));}}
 /* Distinct successful lanes plus late error must not publish early lanes. */
 rb_job jobs[8]={0};rb_rgb_q24 results[8],saved[8];for(unsigned j=0;j<8;j++)for(unsigned k=0;k<3;k++)jobs[j].reflection.channel[k]=j*13+k;for(unsigned width=1;width<=8;width*=2){assert(rb_merge_block(jobs,width,results)==0);for(unsigned j=0;j<width;j++)for(unsigned k=0;k<3;k++)assert(results[j].channel[k]==32*(j*13+k));}memset(results,0x7b,sizeof results);memcpy(saved,results,sizeof results);jobs[7].reflection.channel[2]=UINT64_MAX;assert(rb_merge_block(jobs,8,results)==RB_SCALE_OVERFLOW&&!memcmp(results,saved,sizeof results));assert(rb_merge_block(jobs,3,results)==RB_INVALID&&!memcmp(results,saved,sizeof results));
 /* Domain mismatch is real, not machine overflow:49936 + (16384-2^-18). */
 rb_rgb_q24 direct={{UINT64_C(49936)<<24,UINT64_C(49936)<<24,UINT64_C(49936)<<24}};q=(rb_rgb_q19){{(UINT64_C(1)<<33)-2,(UINT64_C(1)<<33)-2,(UINT64_C(1)<<33)-2}};out=prior;assert(rb_merge(&direct,1,&q,&out)==RB_AA_RANGE&&!memcmp(&out,&prior,sizeof out));
 printf("PASS trials=100000 accepted=%u scale_overflow=%u aa_range=%u hash=%016" PRIx64 " widths1_2_4_8_mismatch=0 atomic_failures=1 conservative49936_plus_reflection_rejected=1\n",counts[0],counts[2],counts[3],hash);return 0;}
