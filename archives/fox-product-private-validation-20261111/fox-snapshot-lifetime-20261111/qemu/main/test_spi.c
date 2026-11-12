#include "lease_spi.h"
#include "lease_freertos.h"
#include <assert.h>
#include <stdio.h>
static spi_transaction_t*queued[2];static unsigned count;static esp_err_t submit_error,reap_error;static bool unknown;
esp_err_t __wrap_spi_device_queue_trans(spi_device_handle_t h,spi_transaction_t*t,uint32_t ticks){(void)h;(void)ticks;assert(count<2);queued[count++]=t;return submit_error;}
esp_err_t __wrap_spi_device_get_trans_result(spi_device_handle_t h,spi_transaction_t**out,uint32_t ticks){(void)h;(void)ticks;if(unknown){*out=(spi_transaction_t*)1;return ESP_OK;}if(!count)return ESP_ERR_TIMEOUT;*out=queued[--count];return reap_error;}
void lease_spi_mock_test(void){lease_spi a={.device=(spi_device_handle_t)1};lease_pool p;lease_slot slots[2]={0};lease_reader readers[4];unsigned data[2];lease_mutex mutex;lease_mutex_init(&mutex);slots[0].payload=data;slots[1].payload=data+1;lease_init(&p,slots,2,readers,4,&mutex,lease_mutex_lock,lease_mutex_unlock);
 for(unsigned i=0;i<2;i++){lease_key key;void*w;assert(lease_acquire(&p,&key,&w));*(unsigned*)w=i;assert(lease_publish(&p,key));submit_error=i?ESP_ERR_INVALID_STATE:ESP_OK;assert(lease_spi_submit(&a,&p,key,sizeof(unsigned),0,sizeof(unsigned),0)==submit_error);assert(lease_retire(&p,key));}
 lease_close(&p);assert(!lease_drained(&p));assert(!lease_spi_idle(&a));unknown=true;assert(lease_spi_reap(&a,0)==ESP_ERR_INVALID_STATE);assert(!lease_drained(&p));unknown=false;reap_error=ESP_ERR_INVALID_STATE;assert(lease_spi_reap(&a,0)==ESP_ERR_INVALID_STATE);assert(!lease_drained(&p));reap_error=ESP_OK;assert(lease_spi_reap(&a,0)==ESP_OK);assert(lease_spi_idle(&a));assert(lease_drained(&p));assert(lease_spi_reap(&a,0)==ESP_ERR_TIMEOUT);puts("LEASE_SPI_MOCK_EXACT_DESCRIPTOR_PASS_NOT_DMA");}
