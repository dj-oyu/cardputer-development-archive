#include "lease.h"
#include <assert.h>
#include <pthread.h>
#include <stdio.h>
#include <limits.h>
#include <sched.h>
static void lock(void*p){assert(!pthread_mutex_lock(p));}static void unlock(void*p){assert(!pthread_mutex_unlock(p));}
static int payload[2];static lease_slot slots[2];static lease_reader readers[4];static lease_pool pool;static pthread_mutex_t mutex=PTHREAD_MUTEX_INITIALIZER;
static void init(void){slots[0].payload=payload;slots[1].payload=payload+1;lease_init(&pool,slots,2,readers,4,&mutex,lock,unlock);}
static void adversarial(void){init();lease_key a,b,c;void*w;const void*r;lease_ticket t,u,v;
 assert(lease_acquire(&pool,&a,&w));*(int*)w=41;assert(lease_publish(&pool,a));
 assert(lease_pin(&pool,a,&t,&r));assert(*(const int*)r==41);assert(lease_pin(&pool,a,&u,&r));
 assert(lease_retire(&pool,a));assert(!lease_pin(&pool,a,&v,&r));
 assert(lease_acquire(&pool,&b,&w));assert(!lease_acquire(&pool,&c,&w));
 assert(lease_complete(&pool,u));assert(!lease_complete(&pool,u));assert(!lease_acquire(&pool,&c,&w));
 assert(lease_complete(&pool,t));assert(lease_acquire(&pool,&c,&w));assert(c.generation!=a.generation);
 assert(!lease_complete(&pool,t));assert(!lease_publish(&pool,a));assert(lease_abort(&pool,c));
 /* Failed build aborts writer without touching published storage. */
 assert(lease_publish(&pool,b));assert(lease_pin(&pool,b,&t,&r));lease_close(&pool);assert(!lease_drained(&pool));
 assert(!lease_acquire(&pool,&c,&w));assert(lease_complete(&pool,t));assert(lease_drained(&pool));
 /* Close during build cannot free storage under writer. */
 init();assert(lease_acquire(&pool,&a,&w));lease_close(&pool);assert(!lease_drained(&pool));assert(!lease_publish(&pool,a));assert(lease_abort(&pool,a));assert(lease_drained(&pool));
 /* Ticket exhaustion and generation exhaustion fail closed; never wrap. */
 init();assert(lease_acquire(&pool,&a,&w));assert(lease_publish(&pool,a));lease_ticket ts[4];for(int i=0;i<4;i++)assert(lease_pin(&pool,a,ts+i,&r));assert(!lease_pin(&pool,a,&t,&r));for(int i=3;i>=0;i--)assert(lease_complete(&pool,ts[i]));pool.next=UINT64_MAX;assert(!lease_pin(&pool,a,&t,&r));assert(lease_retire(&pool,a));slots[0].generation=slots[1].generation=UINT64_MAX;assert(!lease_acquire(&pool,&a,&w));
}
static lease_key key;static void *reader(void*arg){(void)arg;for(int n=0;n<20000;n++){lease_ticket t;const void*r;if(lease_pin(&pool,key,&t,&r)){assert(*(const int*)r==12345);assert(lease_complete(&pool,t));}}return NULL;}
static void threaded(void){init();void*w;assert(lease_acquire(&pool,&key,&w));*(int*)w=12345;assert(lease_publish(&pool,key));pthread_t t[3];for(int i=0;i<3;i++)assert(!pthread_create(t+i,NULL,reader,NULL));for(int i=0;i<3;i++)assert(!pthread_join(t[i],NULL));assert(lease_retire(&pool,key));assert(lease_drained(&pool));}
static struct { lease_ticket ticket; const int *p; int expected; } queue[2];
static unsigned head,tail,queued;static bool stop;static pthread_mutex_t qm=PTHREAD_MUTEX_INITIALIZER;
static void *consumer(void*arg){(void)arg;for(;;){lock(&qm);if(!queued){bool done=stop;unlock(&qm);if(done)return NULL;sched_yield();continue;}lease_ticket t=queue[head].ticket;const int*p=queue[head].p;int expected=queue[head].expected;head^=1;queued--;unlock(&qm);assert(*p==expected);sched_yield();assert(*p==expected);assert(lease_complete(&pool,t));}}
static void handoff(void){init();head=tail=queued=0;stop=false;pthread_t t;assert(!pthread_create(&t,NULL,consumer,NULL));for(int i=0;i<10000;i++){lease_key k;void*w;while(!lease_acquire(&pool,&k,&w))sched_yield();*(int*)w=i;assert(lease_publish(&pool,k));lease_ticket read;const void*r;assert(lease_pin(&pool,k,&read,&r));assert(lease_retire(&pool,k));lock(&qm);assert(queued<2);queue[tail].ticket=read;queue[tail].p=r;queue[tail].expected=i;tail^=1;queued++;unlock(&qm);}lease_close(&pool);lock(&qm);stop=true;unlock(&qm);assert(!pthread_join(t,NULL));assert(lease_drained(&pool));}
int main(void){adversarial();threaded();handoff();printf("PASS adversarial + 60000 pthread pins + 10000 producer/consumer generations; sizes pool=%zu slot=%zu reader=%zu\n",sizeof(lease_pool),sizeof(lease_slot),sizeof(lease_reader));}
