#include "../fox-snapshot-lifetime-20261111/lease.h"
#include <assert.h>
#include <pthread.h>
#include <stdio.h>
static void lock(void*p){assert(!pthread_mutex_lock(p));}static void unlock(void*p){assert(!pthread_mutex_unlock(p));}
int main(void){pthread_mutex_t m=PTHREAD_MUTEX_INITIALIZER;int payload=0;lease_pool p,q;lease_slot s={.payload=&payload},z={.payload=&payload};lease_reader r[1],rr[1];lease_init(&p,&s,1,r,1,&m,lock,unlock);lease_init(&q,&z,1,rr,1,&m,lock,unlock);lease_key k;void*w;const void*v;lease_ticket a,b;assert(lease_acquire(&p,&k,&w));assert(lease_publish(&p,k));assert(lease_pin(&p,k,&a,&v));assert(!lease_complete(&q,a));assert(lease_complete(&p,a));assert(lease_pin(&p,k,&b,&v));assert(!lease_complete(&p,a));assert(lease_retire(&p,k));assert(!lease_drained(&p));assert(lease_complete(&p,b));assert(lease_acquire(&p,&k,&w));assert(lease_publish(&p,k));assert(lease_pin(&p,k,&b,&v));assert(!lease_complete(&p,a));lease_close(&p);assert(!lease_drained(&p));assert(lease_complete(&p,b));assert(lease_drained(&p));puts("PASS wrong pool + same-generation serial reuse + recycled generation + close outstanding reader");}
