#include "corpus.h"
#include <stdio.h>
#include <assert.h>
#include <inttypes.h>
static uint64_t digest=UINT64_C(14695981039346656037);
static unsigned calls;
static void hash(const void *p,unsigned n) {const uint8_t *b=p;for(unsigned j=0;j<n;j++) {digest^=b[j];digest*=UINT64_C(1099511628211);}}
void dot8_pie_raw(const dot8_input *n,const dot8_input *d,dot8_packed *p) {
    hash(n,sizeof *n);hash(d,sizeof *d);calls++;
    for(unsigned i=0;i<8;i++) {int64_t sum=0;for(unsigned k=0;k<3;k++) sum+=(int64_t)n->v[k][i]*d->v[k][i];uint64_t u=(uint64_t)sum;uint8_t *v=(i<4?p->low:p->high)+(i%4)*5;for(unsigned j=0;j<5;j++) v[j]=(uint8_t)(u>>(8*j));}
}
static Dot8Workspace w;
int main(void) {
#if PROBE_NEW
    Dot8Suite s;dot8_suite_init(&s);while(!s.progress.done) dot8_suite_step(&w,&s,dot8_checked);assert(s.progress.passed==564&&s.progress.failed==0&&s.progress.invalid_rejected==48);
#else
    volatile Dot8Results r;dot8_run_corpus(&w,&r);assert(r.passed==564&&r.failed==0&&r.invalid_rejected==48);
#endif
    printf("CORPUS_INPUT_IDENTITY raw_cases=%u fnv64=%016"PRIx64"\n",calls,digest);
}
