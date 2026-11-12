#include "integer_aa.h"
#include <stddef.h>
#include <string.h>
static int overlap(const void*x,size_t nx,const void*y,size_t ny){uintptr_t a=(uintptr_t)x,b=(uintptr_t)y;return nx&&ny&&(a<=b?b-a<nx:a-b<ny);}
static int valid(const aa_state*s){if(!s||(s->count!=1&&s->count!=4)||s->seen&~((1u<<s->count)-1))return 0;unsigned used=0;for(unsigned j=0;j<s->count;j++)used+=(s->seen>>j)&1;for(unsigned k=0;k<3;k++)if(s->sum[k]>AA_SAMPLE_MAX*used)return 0;return 1;}
aa_status aa_init(aa_state*s,unsigned n){if(!s||(n!=1&&n!=4))return AA_INVALID;aa_state t;memset(&t,0,sizeof t);t.count=(uint8_t)n;*s=t;return AA_OK;}
aa_status aa_put(aa_state*s,unsigned slot,aa_action action,const uint64_t original[3],const uint64_t replacement[3]){
 if(!valid(s)||slot>=s->count||(s->seen&(1u<<slot))||(action!=AA_KEEP&&action!=AA_REPLACE))return AA_INVALID;
 const uint64_t*selected=action==AA_KEEP?original:replacement;if(!selected||overlap(s,sizeof *s,selected,24))return AA_INVALID;
 for(unsigned k=0;k<3;k++)if(selected[k]>AA_SAMPLE_MAX)return AA_RANGE;
 aa_state t=*s;for(unsigned k=0;k<3;k++)t.sum[k]+=selected[k];t.seen|=(uint8_t)(1u<<slot);*s=t;return AA_OK;
}
aa_status aa_reduce(const aa_state*s,uint32_t out[3]){
 if(!valid(s)||!out||overlap(s,sizeof *s,out,12))return AA_INVALID;if(s->seen!=(1u<<s->count)-1)return AA_INCOMPLETE;
 uint32_t q[3];uint64_t d=(uint64_t)s->count*32;for(unsigned k=0;k<3;k++){uint64_t x=s->sum[k]/d,r=s->sum[k]%d;x+=r>d-r||(r==d-r&&(x&1));if(x>UINT32_MAX)return AA_HDR19_OVERFLOW;q[k]=(uint32_t)x;}memcpy(out,q,sizeof q);return AA_OK;
}
aa_status aa_finish(const aa_state*s,aa_encoder encode,void*ctx,aa_result*out){
 if(!s||!encode||!out||overlap(s,sizeof *s,out,sizeof *out))return AA_INVALID;aa_result t;memset(&t,0,sizeof t);aa_status a=aa_reduce(s,t.hdr19);if(a)return a;int e=encode(ctx,t.hdr19,&t.pixel);if(e<0||e>1)return AA_ENCODE_ERROR;t.high_clamped=(uint8_t)e;*out=t;return AA_OK;
}
aa_status aa_finish_block(const aa_state*s,unsigned n,aa_encoder encode,void*ctx,aa_result*out){
 if(!s||!out||!encode||(n!=1&&n!=2&&n!=4&&n!=8)||overlap(s,n*sizeof *s,out,n*sizeof *out))return AA_INVALID;
 aa_result t[8];for(unsigned i=0;i<n;i++){aa_status a=aa_finish(s+i,encode,ctx,t+i);if(a)return a;}memcpy(out,t,n*sizeof *out);return AA_OK;
}
