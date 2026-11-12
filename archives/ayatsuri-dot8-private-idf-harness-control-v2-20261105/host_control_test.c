#include "main/corpus.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
static unsigned raw_calls,case_index,inject_at=UINT32_MAX,inject_kind;
static Dot8Workspace workspace;
void dot8_pie_raw(const dot8_input *n,const dot8_input *d,dot8_packed *p) {
    raw_calls++;
    for(unsigned i=0;i<8;i++) {
        int64_t sum=0;for(unsigned k=0;k<3;k++) sum+=(int64_t)n->v[k][i]*d->v[k][i];
        uint64_t bits=(uint64_t)sum;uint8_t *v=(i<4?p->low:p->high)+(i%4)*5;
        for(unsigned j=0;j<5;j++) v[j]=(uint8_t)(bits>>(j*8));
    }
}
static bool checked_fault(const dot8_input *n,const dot8_input *d,dot8_packed *p,int32_t *out) {
    bool ok=dot8_checked(n,d,p,out);
    if(case_index==inject_at) {
        if(inject_kind==DOT8_NUMERIC) out[0]^=1;
        if(inject_kind==DOT8_GUARD) workspace.out.after[0]^=1;
        if(inject_kind==DOT8_PADDING) p->low[20]^=1;
        if(inject_kind==DOT8_REJECTION) return true;
    }
    return ok;
}
static Dot8Terminal run(unsigned fault,unsigned kind,unsigned stall) {
    raw_calls=0;inject_at=fault;inject_kind=kind;
    Dot8Control c;Dot8Suite s;dot8_control_start(&c,0);dot8_suite_init(&s);int64_t now=0;
    while(!dot8_control_ready(&c,now)) {
        if(s.progress.next_case==stall) {now=DOT8_DEADLINE_US+10000;break;}
        assert(dot8_control_permit(&c,now));case_index=s.progress.next_case;
        assert(dot8_suite_step(&workspace,&s,checked_fault));now+=1000;
        dot8_control_progress(&c,&s.progress,now);
    }
    assert(dot8_control_commit(&c,now));
    Dot8Terminal r;assert(dot8_control_take(&c,&r));unsigned calls=raw_calls;
    Dot8Control frozen=c;
    for(unsigned i=0;i<20;i++) {
        assert(!dot8_control_permit(&c,now));assert(!dot8_control_commit(&c,now));
        Dot8Progress bogus={.passed=9999,.done=true};dot8_control_progress(&c,&bogus,now);
        assert(!dot8_control_take(&c,&r));assert(!dot8_control_setup_error(&c,DOT8_CREATE_WORKER,now));
    }
    assert(!memcmp(&c,&frozen,sizeof c));assert(raw_calls==calls);
    if(s.progress.done) {for(unsigned i=0;i<20;i++) assert(!dot8_suite_step(&workspace,&s,checked_fault));assert(raw_calls==calls);}
    return c.result;
}
int main(void) {
    Dot8Terminal r=run(UINT32_MAX,0,UINT32_MAX);assert(r.status==DOT8_PASS&&r.passed==564&&r.failed==0&&r.invalid_rejected==48&&raw_calls==516&&r.first_case==-1);
    unsigned firsts[]={0,1,3,4,257,515,516,540,563};
    for(unsigned i=0;i<sizeof firsts/sizeof *firsts;i++) {
        unsigned f=firsts[i],kind=f<516?DOT8_NUMERIC:DOT8_REJECTION;
        r=run(f,kind,UINT32_MAX);assert(r.status==DOT8_FAIL&&r.first_case==(int32_t)f&&r.passed==f&&r.failed==1&&r.error==(Dot8Error)kind&&raw_calls==(f<516?f+1:516));
    }
    r=run(514,DOT8_GUARD,UINT32_MAX);assert(r.status==DOT8_FAIL&&r.error==DOT8_GUARD&&r.first_case==514);
    r=run(513,DOT8_PADDING,UINT32_MAX);assert(r.status==DOT8_FAIL&&r.error==DOT8_PADDING&&r.first_case==513);
    unsigned stalls[]={0,1,15,515,516,563};
    for(unsigned i=0;i<sizeof stalls/sizeof *stalls;i++) {unsigned n=stalls[i];r=run(UINT32_MAX,0,n);assert(r.status==DOT8_TIMEOUT&&r.first_case==(int32_t)n&&r.passed==n&&raw_calls==(n<516?n:516));}
    for(int delta=-1;delta<=1;delta++) for(unsigned fail=0;fail<2;fail++) {
        Dot8Control c;dot8_control_start(&c,0);Dot8Progress p={.passed=fail?3:564,.failed=fail,.invalid_rejected=fail?0:48,.next_case=fail?3:564,.done=true,.error=fail?DOT8_NUMERIC:DOT8_NO_ERROR};
        dot8_control_progress(&c,&p,DOT8_DEADLINE_US+delta);assert(dot8_control_commit(&c,DOT8_DEADLINE_US+100));
        assert(c.result.status==(delta<0?(fail?DOT8_FAIL:DOT8_PASS):DOT8_TIMEOUT));
    }
    /* Supervisor wins before a late completion; immutable terminal snapshot. */
    Dot8Control c;dot8_control_start(&c,0);assert(dot8_control_permit(&c,DOT8_DEADLINE_US-1));assert(dot8_control_commit(&c,DOT8_DEADLINE_US));Dot8Terminal frozen=c.result;
    Dot8Progress p={.passed=564,.done=true,.next_case=564};dot8_control_progress(&c,&p,DOT8_DEADLINE_US);assert(!memcmp(&frozen,&c.result,sizeof frozen));assert(!dot8_control_permit(&c,DOT8_DEADLINE_US));
    for(Dot8Error e=DOT8_CREATE_SUPERVISOR;e<=DOT8_REENTRY;e++) {dot8_control_start(&c,0);assert(dot8_control_setup_error(&c,e,1));assert(c.result.status==DOT8_SETUP_ERROR&&c.result.first_case==-1&&c.result.passed==0);assert(!dot8_control_permit(&c,2));assert(dot8_control_take(&c,&r));assert(!dot8_control_take(&c,&r));}
    dot8_control_start(&c,0);p=(Dot8Progress){.passed=1,.done=true,.next_case=1};dot8_control_progress(&c,&p,1);assert(dot8_control_commit(&c,2));assert(c.result.status==DOT8_FAIL&&c.result.error==DOT8_COUNTS);
    volatile uint32_t guard[2]={0,0};assert(dot8_claim_boot(guard));assert(!dot8_claim_boot(guard));guard[1]^=1;assert(dot8_claim_boot(guard));
    printf("HOST_CONTROL_PASS normal564 first_failure11 stalled_worker6 deadline_races7 setup3 exactly_once frozen_result no_raw_after_stop rtc_latch count_gate; task_scheduler_is_model raw_is_stub\n");
}
