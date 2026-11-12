#include "control.h"
void dot8_control_start(Dot8Control *c,int64_t now) { *c=(Dot8Control){.start_us=now}; }
bool dot8_control_permit(Dot8Control *c,int64_t now) {
    if(c->terminal || c->pending_done) return false;
    if(now-c->start_us>=DOT8_DEADLINE_US) { c->pending=DOT8_DEADLINE;c->pending_done=true;c->event_at=now;return false; }
    return true;
}
void dot8_control_progress(Dot8Control *c,const Dot8Progress *p,int64_t now) {
    if(c->terminal || c->pending_done) return;
    c->progress=*p;
    if(p->done) {c->pending=p->error;c->pending_done=true;c->event_at=now;}
}
bool dot8_control_ready(const Dot8Control *c,int64_t now) { return !c->terminal && (c->pending_done || now-c->start_us>=DOT8_DEADLINE_US); }
bool dot8_control_commit(Dot8Control *c,int64_t now) {
    if(!dot8_control_ready(c,now)) return false;
    Dot8Terminal r={.first_case=(int32_t)c->progress.next_case,.passed=c->progress.passed,.failed=c->progress.failed,.invalid_rejected=c->progress.invalid_rejected,.elapsed_us=now-c->start_us,.event_us=c->pending_done?c->event_at-c->start_us:now-c->start_us};
    /* Strict-before deadline wins; equality is timeout. A published completion
     * before the deadline remains valid even if supervisor observes it later. */
    if(c->pending_done && c->event_at-c->start_us<DOT8_DEADLINE_US) {
        r.status=c->pending==DOT8_NO_ERROR?DOT8_PASS:DOT8_FAIL;r.error=c->pending;
        if(r.status==DOT8_PASS && (c->progress.passed!=DOT8_CASES || c->progress.failed!=0 || c->progress.invalid_rejected!=48 || c->progress.next_case!=DOT8_CASES)) {r.status=DOT8_FAIL;r.error=DOT8_COUNTS;}
        r.first_case=r.status==DOT8_PASS?-1:(int32_t)c->progress.next_case;
    } else {r.status=DOT8_TIMEOUT;r.error=DOT8_DEADLINE;}
    c->result=r;c->terminal=true;return true;
}
bool dot8_control_setup_error(Dot8Control *c,Dot8Error error,int64_t now) {
    if(c->terminal) return false;
    c->result=(Dot8Terminal){.status=DOT8_SETUP_ERROR,.error=error,.first_case=-1,.elapsed_us=now-c->start_us,.event_us=now-c->start_us};c->terminal=true;return true;
}
bool dot8_control_take(Dot8Control *c,Dot8Terminal *r) {
    if(!c->terminal || c->emitted) return false;
    *r=c->result;c->emitted=true;return true;
}
bool dot8_claim_boot(volatile uint32_t g[2]) {
    if(g[0]==DOT8_BOOT_MAGIC && g[1]==~DOT8_BOOT_MAGIC) return false;
    g[0]=DOT8_BOOT_MAGIC;g[1]=~DOT8_BOOT_MAGIC;return true;
}
const char *dot8_status_name(Dot8Status s) {
    switch(s) {case DOT8_PASS:return "PASS";case DOT8_FAIL:return "FAIL";case DOT8_TIMEOUT:return "TIMEOUT";case DOT8_SETUP_ERROR:return "SETUP_ERROR";default:return "RUNNING";}
}
