#include "lease_spi.h"
#include <limits.h>
#include <string.h>
bool lease_spi_idle(const lease_spi*a){return !a->entries[0].active&&!a->entries[1].active;}
esp_err_t lease_spi_submit(lease_spi*a,lease_pool*p,lease_key key,size_t size,size_t offset,size_t bytes,TickType_t wait){
 if(!a||!a->device||offset>size||!bytes||bytes>size-offset||bytes>SIZE_MAX/8)return ESP_ERR_INVALID_ARG;
 lease_spi_entry*e=NULL;for(unsigned i=0;i<2;i++)if(!a->entries[i].active){e=a->entries+i;break;}
 if(!e)return ESP_ERR_TIMEOUT;
 const void*payload;lease_ticket ticket;if(!lease_pin(p,key,&ticket,&payload))return ESP_ERR_INVALID_STATE;
 memset(&e->descriptor,0,sizeof e->descriptor);e->descriptor.length=bytes*8;e->descriptor.tx_buffer=(const unsigned char*)payload+offset;
 e->pool=p;e->ticket=ticket;e->active=true;
 /* v6.0.1 can return error after xQueueSend (bg_request). All errors retain
  * until exact descriptor retirement; do not assume failure means unborrowed. */
 return spi_device_queue_trans(a->device,&e->descriptor,wait);
}
esp_err_t lease_spi_reap(lease_spi*a,TickType_t wait){
 if(!a||!a->device)return ESP_ERR_INVALID_ARG;
 spi_transaction_t*done=NULL;esp_err_t result=spi_device_get_trans_result(a->device,&done,wait);
 if(done){for(unsigned i=0;i<2;i++){lease_spi_entry*e=a->entries+i;if(e->active&&done==&e->descriptor){
   /* This SDK sets done only after ret_queue receive + uninstall_priv_desc.
    * DMA failure flags can make result nonzero AFTER retirement. */
   if(!lease_complete(e->pool,e->ticket))return ESP_ERR_INVALID_STATE;
   e->active=false;return result;
  }}return ESP_ERR_INVALID_STATE;}
 return result==ESP_OK?ESP_ERR_INVALID_STATE:result;
}
