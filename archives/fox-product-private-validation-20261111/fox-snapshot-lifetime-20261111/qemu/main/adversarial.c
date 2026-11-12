#include "lease.h"
#include <assert.h>
#include "lease_freertos.h"
typedef lease_mutex pthread_mutex_t;
#define PTHREAD_MUTEX_INITIALIZER {0}
static int pthread_mutex_lock(lease_mutex*m){lease_mutex_lock(m);return 0;}
static int pthread_mutex_unlock(lease_mutex*m){lease_mutex_unlock(m);return 0;}
#include <stdio.h>
#include <limits.h>
static void lock(void*p){assert(!pthread_mutex_lock(p));}static void unlock(void*p){assert(!pthread_mutex_unlock(p));}
static int payload[2];static lease_slot slots[2];static lease_reader readers[4];static lease_pool pool;static pthread_mutex_t mutex=PTHREAD_MUTEX_INITIALIZER;
static void init(void){if(!mutex.handle)lease_mutex_init(&mutex);slots[0].payload=payload;slots[1].payload=payload+1;lease_init(&pool,slots,2,readers,4,&mutex,lock,unlock);}
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
void lease_adversarial(void){adversarial();puts("LEASE_FREERTOS_ADVERSARIAL_PASS");}
