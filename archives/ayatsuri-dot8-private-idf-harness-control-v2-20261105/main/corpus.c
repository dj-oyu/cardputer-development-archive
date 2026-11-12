#include "corpus.h"
#include <string.h>
#define GUARD UINT32_C(0xa53cc35a)
static void guards(uint32_t a[4]) { for(unsigned i=0;i<4;i++) a[i]=GUARD; }
static bool guard_ok(const uint32_t a[4]) { for(unsigned i=0;i<4;i++) if(a[i]!=GUARD) return false; return true; }
static bool all_guards(const Dot8Workspace *w) { return guard_ok(w->n.before)&&guard_ok(w->n.after)&&guard_ok(w->d.before)&&guard_ok(w->d.after)&&guard_ok(w->packed.before)&&guard_ok(w->packed.after)&&guard_ok(w->out.before)&&guard_ok(w->out.after); }
static void reset(Dot8Workspace *w) {
    memset(w,0,sizeof *w);guards(w->n.before);guards(w->n.after);guards(w->d.before);guards(w->d.after);guards(w->packed.before);guards(w->packed.after);guards(w->out.before);guards(w->out.after);
    memset(&w->packed.value,0xa5,sizeof w->packed.value);memset(w->out.value,0x5a,sizeof w->out.value);
}
static uint32_t next(uint32_t *s) { *s=*s*UINT32_C(1664525)+UINT32_C(1013904223);return *s; }
void dot8_suite_init(Dot8Suite *s) { *s=(Dot8Suite){.seed=UINT32_C(0x44d08a21)}; }
bool dot8_suite_step(Dot8Workspace *w,Dot8Suite *s,Dot8CheckedFn checked) {
    Dot8Progress *p=&s->progress;if(p->done) return false;
    unsigned c=p->next_case;reset(w);Dot8Error error=DOT8_NO_ERROR;
    if(c<516) {
        for(unsigned k=0;k<3;k++) for(unsigned i=0;i<8;i++) {
            if(c<4) {
                w->n.value.v[k][i]=c==0?0:c==1?1:(i+k)%2?INT16_MIN:INT16_MAX;
                w->d.value.v[k][i]=c==0?0:c==1?1:c==2?((i+k)%2?-16385:16385):((i+k)%2?16385:-16385);
            } else {
                w->n.value.v[k][i]=(int16_t)((int32_t)(next(&s->seed)%65536)-32768);
                w->d.value.v[k][i]=(int16_t)((int32_t)(next(&s->seed)%32771)-16385);
            }
        }
        bool scalar=dot8_scalar(&w->n.value,&w->d.value,w->expected);
        bool ok=checked(&w->n.value,&w->d.value,&w->packed.value,w->out.value);
        if(!scalar || !ok || memcmp(w->expected,w->out.value,sizeof w->expected)) error=DOT8_NUMERIC;
        if(error==DOT8_NO_ERROR && !all_guards(w)) error=DOT8_GUARD;
        if(error==DOT8_NO_ERROR) for(unsigned i=20;i<32;i++) if(w->packed.value.low[i]!=0xa5 || w->packed.value.high[i]!=0xa5) {error=DOT8_PADDING;break;}
    } else {
        unsigned j=c-516,k=j/16,i=(j/2)%8;w->d.value.v[k][i]=(j%2)?16386:-16386;
        dot8_packed packed=w->packed.value;int32_t out[8];memcpy(out,w->out.value,sizeof out);
        bool ok=!checked(&w->n.value,&w->d.value,&w->packed.value,w->out.value)&&!memcmp(&packed,&w->packed.value,sizeof packed)&&!memcmp(out,w->out.value,sizeof out)&&all_guards(w);
        if(!ok) error=DOT8_REJECTION;else p->invalid_rejected++;
    }
    if(error!=DOT8_NO_ERROR) {p->failed++;p->error=error;p->done=true;return true;}
    p->passed++;p->next_case++;if(p->next_case==DOT8_CASES) p->done=true;
    return true;
}
