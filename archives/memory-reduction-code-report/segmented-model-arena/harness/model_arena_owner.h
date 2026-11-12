#ifndef MODEL_ARENA_OWNER_H
#define MODEL_ARENA_OWNER_H
#include "ayatsuri/ayatsuri_model.h"
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
/* Host-only allocation owner, independent of the instance and its copied pointer
 * table. Never mutate this descriptor while live. Payload remains live through
 * the last borrowed view / world / pixel / snapshot copy and instance dispose.
 * Host LP64 control: 32 + node_count*16 bytes (912 for the fixed 55-node model).
 * 1 control + 1 metadata + node_count payload allocations; no stack node array.
 */
typedef struct {
 void *metadata;
 size_t metadata_bytes,node_count,payload_bytes;
 ayatsuri_model_node_storage slots[];
} model_arena_owner;
/* Only call after dispose (or before init publication). Clearing the owning
 * pointer makes repeat release harmless; no instance/caller descriptor is read. */
static void model_arena_owner_release(model_arena_owner **owned,void (*release)(void *)){
 if(!owned||!*owned)return;
 model_arena_owner *o=*owned;*owned=NULL;
 for(size_t j=0;j<o->node_count;j++)if(o->slots[j].data){memset(o->slots[j].data,0xa5,o->slots[j].bytes);release(o->slots[j].data);}
 if(o->metadata){memset(o->metadata,0xa5,o->metadata_bytes);release(o->metadata);}
 release(o);
}
/* On any failure, unwind every successful allocation and leave out unchanged.
 * Call only with fresh output. Init performs complete span validation before
 * its single publication, and has no fallible action after commit starts. */
static model_arena_owner *model_arena_owner_create(const ayatsuri_model *m,
 const void *token,uint32_t generation,ayatsuri_model_instance *out,
 void *(*allocate)(size_t),void (*release)(void *)){
 if(!m||!out||!allocate||!release)return NULL;
 size_t metadata_bytes=ayatsuri_model_instance_metadata_bytes(m),count=m->node_count;
 if(!metadata_bytes||!count||count>(SIZE_MAX-sizeof(model_arena_owner))/sizeof(ayatsuri_model_node_storage))return NULL;
 size_t control_bytes=sizeof(model_arena_owner)+count*sizeof(ayatsuri_model_node_storage);
 model_arena_owner *o=allocate(control_bytes);if(!o)return NULL;
 memset(o,0,control_bytes);o->metadata_bytes=metadata_bytes;o->node_count=count;o->payload_bytes=metadata_bytes;
 o->metadata=allocate(metadata_bytes);if(!o->metadata)goto failed;
 for(size_t j=0;j<count;j++){
  size_t bytes=ayatsuri_model_instance_node_bytes(m,(uint16_t)j);
  if(!bytes||bytes>SIZE_MAX-o->payload_bytes)goto failed;
  o->slots[j].bytes=bytes;o->slots[j].data=allocate(bytes);if(!o->slots[j].data)goto failed;
  o->payload_bytes+=bytes;
 }
 if(ayatsuri_model_instance_init_segmented(m,o->metadata,o->metadata_bytes,o->slots,count,token,generation,out)!=AYATSURI_MODEL_OK)goto failed;
 return o;
failed:
 model_arena_owner_release(&o,release);return NULL;
}
#endif
