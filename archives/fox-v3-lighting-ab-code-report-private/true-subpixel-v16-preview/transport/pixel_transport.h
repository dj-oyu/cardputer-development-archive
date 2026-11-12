#ifndef FOX_PIXEL_TRANSPORT_H
#define FOX_PIXEL_TRANSPORT_H
#include "bounce.h"
#include "../visibility/pixel_binding.h"
typedef struct {
 const fox_pixel_binding *snapshot_binding;
 bounce_binding binding;
 bounce_generation expected;
 bounce_mode mode;
 bounce_ground ground; /* expected owned descriptor; validated against scene */
 unsigned outer,inner;
 vis_budget *direct_budget,*transport_budget;
 bounce_counters counters;
} fox_transport_context;
/* Synchronous host-only context, initialized/owned by caller. Work counters
 * accumulate across all bands; failed bands are unpublished and discarded. */
bool fox_transport_render(fox_transport_context *,const ksn_mesh_pixel_snapshot *,uint16_t *,unsigned,unsigned,float *,unsigned,ksn_mesh_pixel_stats *);
#endif
