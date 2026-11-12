#include "lease.h"
#include "lease_freertos.h"
#include "freertos/task.h"
#include "freertos/queue.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
#define main render_test_main
#include "../../test_render.c"
#undef main
static lease_pool pool;static lease_slot slots[2];static lease_reader readers[4];static int values[2];static lease_mutex mutex;
static QueueHandle_t queue;static TaskHandle_t owner;
typedef struct {lease_ticket ticket;const int *p;int value;} job;
static void consume(void*arg){(void)arg;printf("LEASE_CONSUMER_CORE=%d\n",xPortGetCoreID());for(;;){job j;assert(xQueueReceive(queue,&j,portMAX_DELAY));if(!j.p)break;assert(*j.p==j.value);taskYIELD();assert(*j.p==j.value);assert(lease_complete(&pool,j.ticket));assert(!lease_complete(&pool,j.ticket));}xTaskNotifyGive(owner);vTaskDelete(NULL);}
static void stress(void){lease_mutex_init(&mutex);slots[0].payload=values;slots[1].payload=values+1;lease_init(&pool,slots,2,readers,4,&mutex,lease_mutex_lock,lease_mutex_unlock);queue=xQueueCreate(2,sizeof(job));assert(queue);owner=xTaskGetCurrentTaskHandle();printf("LEASE_PRODUCER_CORE=%d CONFIG_FREERTOS_UNICORE=%d\n",xPortGetCoreID(),CONFIG_FREERTOS_NUMBER_OF_CORES==1);assert(xTaskCreatePinnedToCore(consume,"lease_consumer",4096,NULL,5,NULL,1)==pdPASS);
 lease_ticket stale={0};for(int i=0;i<2000;i++){lease_key k;void*w;while(!lease_acquire(&pool,&k,&w))vTaskDelay(1);*(int*)w=i;assert(lease_publish(&pool,k));lease_ticket t;const void*r;assert(lease_pin(&pool,k,&t,&r));assert(lease_retire(&pool,k));if(stale.serial)assert(!lease_complete(&pool,stale));job j={t,r,i};assert(xQueueSend(queue,&j,portMAX_DELAY));/* old completion tested only once consumer has completed, after drain below */stale=(lease_ticket){0};}
 lease_close(&pool);job end={0};assert(xQueueSend(queue,&end,portMAX_DELAY));assert(ulTaskNotifyTake(pdTRUE,portMAX_DELAY));assert(lease_drained(&pool));vQueueDelete(queue);puts("LEASE_FREERTOS_2000_HANDOFF_PASS");}
void lease_adversarial(void);
void lease_spi_mock_test(void);
void app_main(void){lease_spi_mock_test();lease_adversarial();stress();assert(render_test_main()==0);puts("FOX_EYE_QEMU_DONE LEASE_REAL_RENDER_PASS");}
