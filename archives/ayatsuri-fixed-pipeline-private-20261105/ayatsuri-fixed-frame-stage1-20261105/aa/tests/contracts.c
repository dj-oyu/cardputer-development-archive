#include "../code/integer_aa.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
static unsigned calls;static uint32_t received[3];static unsigned fail_at;
static int encode(void*ctx,const uint32_t q[3],uint16_t*out){(void)ctx;calls++;if(calls==fail_at)return 3;memcpy(received,q,12);*out=(uint16_t)q[0];return q[0]>3000000000u;}
int main(void){aa_state s;aa_result out,saved;memset(&out,0x5a,sizeof out);saved=out;assert(aa_init(&s,4)==AA_OK);uint64_t q[3]={128,256,384},replace[3]={640,768,896};aa_state before=s;
 assert(aa_put(&s,0,AA_KEEP,0,0)==AA_INVALID&&!memcmp(&s,&before,sizeof s));assert(aa_finish(&s,encode,0,&out)==AA_INCOMPLETE&&!memcmp(&out,&saved,sizeof out));
 for(unsigned j=0;j<4;j++){assert(aa_put(&s,j,j==2?AA_REPLACE:AA_KEEP,q,j==2?replace:0)==0);before=s;assert(aa_put(&s,j,AA_KEEP,q,0)==AA_INVALID&&!memcmp(&s,&before,sizeof s));}
 calls=0;assert(aa_finish(&s,encode,0,&out)==0&&calls==1);assert(received[0]==8&&received[1]==12&&received[2]==16); /* each of4 contributes, divide4 in HDR */
 /* Each of four single nonzero slots independently changes the exact sum. */
 for(unsigned hot=0;hot<4;hot++){aa_init(&s,4);uint64_t zero[3]={0};for(unsigned j=0;j<4;j++)assert(aa_put(&s,j,AA_KEEP,j==hot?q:zero,0)==0);uint32_t r[3];assert(aa_reduce(&s,r)==0&&r[0]==1&&r[1]==2&&r[2]==3);}
 /* Counterexample to double-rounding: sum65 => direct /128=1;
    rounded Q24 mean16 then /32 ties-even=0. */
 aa_init(&s,4);uint64_t z[3]={0},sixtyfive[3]={65,192,320};for(unsigned j=0;j<4;j++)assert(aa_put(&s,j,AA_KEEP,j?z:sixtyfive,0)==0);uint32_t r[3];assert(aa_reduce(&s,r)==0&&r[0]==1&&r[1]==2&&r[2]==2);
 /* Permutations preserve exact integer sum; extreme admitted slots safe. */
 aa_init(&s,4);uint64_t max[3]={AA_SAMPLE_MAX,AA_SAMPLE_MAX,AA_SAMPLE_MAX};for(unsigned j=0;j<4;j++)assert(aa_put(&s,3-j,AA_KEEP,max,0)==0);assert(s.sum[0]==4*AA_SAMPLE_MAX);assert(aa_reduce(&s,r)==AA_HDR19_OVERFLOW);before=s;max[0]++;aa_state fresh;aa_init(&fresh,4);aa_state copy=fresh;assert(aa_put(&fresh,0,AA_KEEP,max,0)==AA_RANGE&&!memcmp(&copy,&fresh,sizeof fresh));assert(!memcmp(&before,&s,sizeof s));
 aa_state states[8];aa_result results[8],prior[8];for(unsigned i=0;i<8;i++){aa_init(states+i,1);uint64_t value[3]={32*(i+1),0,0};aa_put(states+i,0,AA_KEEP,value,0);}for(unsigned n=1;n<=8;n*=2){calls=0;fail_at=0;assert(aa_finish_block(states,n,encode,0,results)==0&&calls==n);for(unsigned i=0;i<n;i++)assert(results[i].pixel==i+1);}
 memset(results,0x5a,sizeof results);memcpy(prior,results,sizeof results);calls=0;fail_at=3;assert(aa_finish_block(states,8,encode,0,results)==AA_ENCODE_ERROR&&!memcmp(results,prior,sizeof results));assert(calls==3);
 calls=0;fail_at=0;states[3].seen=0;states[3].sum[0]=0;assert(aa_finish_block(states,8,encode,0,results)==AA_INCOMPLETE&&!memcmp(results,prior,sizeof results));assert(calls==3);
 puts("PASS four-slot contribution, explicit replacement, one encode, ties-even, no double-round, bounded overflow, partial/error atomicity, widths1/2/4/8");return 0;}
