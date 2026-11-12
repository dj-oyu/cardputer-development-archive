#include "compact.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "../kernel-chain-prototype/fixtures.inc"
static int checked_block(const mc_frame*f,const il_scene*s,const kc_input*i,unsigned n,agx_block_cache*c,kc_output*out){
 aa_result compact[8],before[8];memset(compact,0x35,sizeof compact);memcpy(before,compact,sizeof compact);
 int status=kcc_block(f,s,i,n,c,compact);int audit=kc_block(f,s,i,n,c,out);assert(status==audit);
 if(status)assert(!memcmp(compact,before,sizeof compact));else for(unsigned j=0;j<n;j++)assert(!memcmp(compact+j,&out[j].final,sizeof *compact));return status;
}
#define kc_block checked_block
int main(void){
 int32_t q[9]={0,0,0,0,0,0,16777216,0,0};mc_frame f;assert(!mc_prepare(q,-1,1,&f));
 agx_block_cache c;assert(private_integer_profile_bind(&c));il_scene s;memset(&s,0,sizeof s);
 for(int l=0;l<3;l++){s.light[l].center[1]=-4*65536;s.light[l].normal[1]=32767;for(int j=0;j<16;j++)memcpy(s.light[l].sample[j],s.light[l].center,12);for(int k=0;k<3;k++)s.light[l].power[k]=65536;}
 s.world[0]=s.world[1]=s.world[2]=1<<22;
 kc_input in[8];memset(in,0,sizeof in);for(int i=0;i<8;i++)for(int j=0;j<4;j++){kc_slot*v=&in[i].slots[j];v->bary[0]=16384;for(int n=0;n<3;n++){v->local[n][0]=-(277144LL*(1<<20)/1000000);v->local[n][1]=27LL*(1<<20)/10;v->world[n][2]=2831155;v->normal[n][1]=-32767;}for(int k=0;k<3;k++)v->visible[k]=65535;}
 kc_output out[8],before[8],one[8];
 for(unsigned n=1;n<=8;n*=2){int e=kc_block(&f,&s,in,n,&c,out);assert(!e);for(unsigned i=0;i<n;i++){assert(!kc_block(&f,&s,in+i,1,&c,one+i));assert(!memcmp(out+i,one+i,sizeof *out));}
  agx_block_cache empty;agx_cache_init(&empty);memset(out,0x6b,sizeof out);memcpy(before,out,sizeof out);assert(kc_block(&f,&s,in,n,&empty,out)==KC_ENCODE);assert(!memcmp(before,out,sizeof out));
  for(int bad=0;bad<4;bad++){kc_input saved=in[n-1];if(bad==0)in[n-1].slots[3].bary[0]=65535;if(bad==1)in[n-1].slots[3].world[2][0]=INT32_MAX;if(bad==2)memset(in[n-1].slots[3].normal,0,sizeof in[0].slots[0].normal);if(bad==3)for(int k=0;k<3;k++)in[n-1].slots[3].local[k][1]=0;memset(out,0x6b,sizeof out);memcpy(before,out,sizeof out);assert(kc_block(&f,&s,in,n,&c,out));assert(!memcmp(before,out,sizeof out));in[n-1]=saved;}
 }
 uint16_t r=123;assert(kc_rho(-1,&r)&&r==123);assert(kc_rho((1LL<<MBITS)+1,&r)&&r==123);assert(kc_rho(INT64_MAX,&r)&&r==123);assert(!kc_rho(1LL<<(MBITS-1),&r)&&r==16384);assert(!kc_rho(0,&r)&&r==0);assert(!kc_rho(1LL<<MBITS,&r)&&r==32767);
 aa_state a;uint32_t h[3];for(uint64_t x=0;x<1024;x++){assert(!aa_init(&a,4));uint64_t z[3]={x,x,x};assert(!aa_put(&a,0,AA_KEEP,z,0));z[0]=z[1]=z[2]=0;for(int j=1;j<4;j++)assert(!aa_put(&a,j,AA_KEEP,z,0));assert(!aa_reduce(&a,h));assert(h[0]==il_round(x,128));}
 aa_state hi;assert(!aa_init(&hi,4));uint64_t maximal[3]={AA_SAMPLE_MAX,AA_SAMPLE_MAX,AA_SAMPLE_MAX};for(int j=0;j<4;j++)assert(!aa_put(&hi,j,AA_KEEP,maximal,0));uint32_t unchanged[3]={7,8,9};assert(aa_reduce(&hi,unchanged)==AA_HDR19_OVERFLOW&&unchanged[0]==7&&unchanged[1]==8&&unchanged[2]==9);
 assert(il_round(65,128)==1 && il_round(il_round(65,4),32)==0);
 memset(out,0x6b,sizeof out);memcpy(before,out,sizeof out);assert(kc_block(&f,&s,in,3,&c,out));assert(!memcmp(before,out,sizeof out));unsigned accepted=0,rejected=0;
 for(int l=0;l<3;l++){int y=l==1?-4:4;int x=l==0?0:l==1?2:-2;s.light[l].center[0]=x*65536;s.light[l].center[1]=y*65536;s.light[l].center[2]=3*65536;s.light[l].normal[1]=y>0?-32767:32767;for(int j=0;j<16;j++)memcpy(s.light[l].sample[j],s.light[l].center,12);for(int k=0;k<3;k++)s.light[l].power[k]=(k+1)*65536;}
 s.world[0]=1<<21;s.world[1]=1<<22;s.world[2]=1<<23;
 for(unsigned state=0;state<sizeof latest_controls/sizeof *latest_controls;state++)for(unsigned fi=0;fi<sizeof latest_inputs/sizeof *latest_inputs;fi++){
  assert(!mc_prepare(latest_controls[state],latest_sides[fi],1,&f));
  for(unsigned v=0;v<3;v++){in[0]=latest_inputs[fi];for(int j=0;j<4;j++)for(int k=0;k<3;k++)in[0].slots[j].visible[k]=v==0?65535:v==1?0:k==0?21845:k==1?43690:3855;
   memset(out,0x23,sizeof out);memcpy(before,out,sizeof out);int e=kc_block(&f,&s,in,1,&c,out);assert(e==KC_OK||e==KC_NONOPAQUE);if(e){rejected++;assert(!memcmp(out,before,sizeof out));}else accepted++;
  }
 }
 assert(accepted==4473&&rejected==1107);printf("Latest source tuples: %u accepted groups, %u nonopaque rejected groups\n",accepted,rejected);
 puts("PASS widths 1/2/4/8, last-slot atomic rejection, rho bounds/ties, sum/128 ties, integer chain");return 0;
}
