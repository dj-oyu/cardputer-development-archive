#include "lease.h"
#include <string.h>
enum { FREE, WRITING, LIVE, RETIRED };
#define LOCK(p) (p)->lock((p)->lock_ctx)
#define UNLOCK(p) (p)->unlock((p)->lock_ctx)
static lease_slot *match(lease_pool*p,lease_key k){return k.slot<p->count&&k.generation&&p->slots[k.slot].generation==k.generation?&p->slots[k.slot]:NULL;}
static void reclaim(lease_slot*s){if(s->state==RETIRED&&!s->readers)s->state=FREE;}
void lease_init(lease_pool*p,lease_slot*s,size_t n,lease_reader*r,size_t c,void*x,void(*l)(void*),void(*u)(void*)){
 *p=(lease_pool){.slots=s,.count=n,.readers=r,.capacity=c,.next=1,.lock_ctx=x,.lock=l,.unlock=u};
 for(size_t i=0;i<n;i++){s[i].generation=0;s[i].readers=0;s[i].state=FREE;}memset(r,0,c*sizeof(*r));
}
bool lease_acquire(lease_pool*p,lease_key*k,void**out){bool ok=false;LOCK(p);
 if(!p->closed)for(size_t i=0;i<p->count;i++){lease_slot*s=p->slots+i;if(s->state==FREE&&s->generation!=UINT64_MAX){s->generation++;s->state=WRITING;*k=(lease_key){s->generation,(unsigned)i};*out=s->payload;ok=true;break;}}
 UNLOCK(p);return ok;}
bool lease_publish(lease_pool*p,lease_key k){LOCK(p);lease_slot*s=match(p,k);bool ok=s&&s->state==WRITING&&!p->closed;if(ok)s->state=LIVE;UNLOCK(p);return ok;}
bool lease_abort(lease_pool*p,lease_key k){LOCK(p);lease_slot*s=match(p,k);bool ok=s&&s->state==WRITING;if(ok)s->state=FREE;UNLOCK(p);return ok;}
bool lease_pin(lease_pool*p,lease_key k,lease_ticket*t,const void**out){bool ok=false;LOCK(p);lease_slot*s=match(p,k);
 if(!p->closed&&s&&s->state==LIVE&&p->next!=UINT64_MAX)for(size_t i=0;i<p->capacity;i++)if(!p->readers[i].active){*t=(lease_ticket){p->next++,k,p};p->readers[i]=(lease_reader){*t,true};s->readers++;*out=s->payload;ok=true;break;}
 UNLOCK(p);return ok;}
bool lease_complete(lease_pool*p,lease_ticket t){if(t.pool!=p)return false;bool ok=false;LOCK(p);
 for(size_t i=0;i<p->capacity;i++){lease_reader*r=p->readers+i;if(r->active&&r->ticket.serial==t.serial&&r->ticket.key.slot==t.key.slot&&r->ticket.key.generation==t.key.generation){lease_slot*s=match(p,t.key);if(s&&s->readers){s->readers--;r->active=false;reclaim(s);ok=true;}break;}}
 UNLOCK(p);return ok;}
bool lease_retire(lease_pool*p,lease_key k){LOCK(p);lease_slot*s=match(p,k);bool ok=s&&(s->state==LIVE||s->state==RETIRED);if(ok){s->state=RETIRED;reclaim(s);}UNLOCK(p);return ok;}
void lease_close(lease_pool*p){LOCK(p);p->closed=true;for(size_t i=0;i<p->count;i++){lease_slot*s=p->slots+i;if(s->state==LIVE)s->state=RETIRED;reclaim(s);}UNLOCK(p);}
bool lease_drained(lease_pool*p){bool ok=true;LOCK(p);for(size_t i=0;i<p->count;i++)if(p->slots[i].state!=FREE)ok=false;UNLOCK(p);return ok;}
