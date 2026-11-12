#ifndef SNAPSHOT_LEASE_H
#define SNAPSHOT_LEASE_H
#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>
/* Task context only. lock/unlock must supply mutual exclusion and acquire/release
 * ordering. Neither payload work nor external callbacks execute under the lock.
 * Storage, lock and pool outlive ALL callbacks (including duplicates). */
typedef struct { uint64_t generation; unsigned slot; } lease_key;
struct lease_pool;
typedef struct { uint64_t serial; lease_key key; const struct lease_pool *pool; } lease_ticket;
typedef struct { void *payload; uint64_t generation; unsigned readers; unsigned state; } lease_slot;
typedef struct { lease_ticket ticket; bool active; } lease_reader;
typedef struct lease_pool {
 lease_slot *slots; size_t count; lease_reader *readers; size_t capacity;
 uint64_t next; bool closed; void *lock_ctx;
 void (*lock)(void*); void (*unlock)(void*);
} lease_pool;
void lease_init(lease_pool*,lease_slot*,size_t,lease_reader*,size_t,void*,void(*)(void*),void(*)(void*));
bool lease_acquire(lease_pool*,lease_key*,void**); /* sole writer until publish/abort */
bool lease_publish(lease_pool*,lease_key); /* release publication; caller stops writing */
bool lease_abort(lease_pool*,lease_key); /* only writer may abort; no further writes */
bool lease_pin(lease_pool*,lease_key,lease_ticket*,const void**);
bool lease_complete(lease_pool*,lease_ticket); /* only AFTER reader actually stops */
bool lease_retire(lease_pool*,lease_key); /* no new readers; does NOT cancel existing readers */
void lease_close(lease_pool*); /* rejects new work; writing leases still require abort */
bool lease_drained(lease_pool*); /* no active writer/readers; not callback quiescence */
#endif
