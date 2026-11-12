#ifndef SNAPSHOT_LEASE_FREERTOS_H
#define SNAPSHOT_LEASE_FREERTOS_H
/* Optional target task-context lock policy. Never call lease APIs from ISR.
 * Create before publishing pool. Keep until callback source is unregistered
 * and joined/drained. Static allocation support must be enabled. */
#include "freertos/FreeRTOS.h"
#include "freertos/semphr.h"
typedef struct { StaticSemaphore_t storage; SemaphoreHandle_t handle; } lease_mutex;
static inline void lease_mutex_init(lease_mutex*m){m->handle=xSemaphoreCreateMutexStatic(&m->storage);configASSERT(m->handle);}
static inline void lease_mutex_lock(void*p){lease_mutex*m=p;BaseType_t ok=xSemaphoreTake(m->handle,portMAX_DELAY);configASSERT(ok==pdTRUE);}
static inline void lease_mutex_unlock(void*p){lease_mutex*m=p;BaseType_t ok=xSemaphoreGive(m->handle);configASSERT(ok==pdTRUE);}
#endif
