#ifndef FOX_PIXEL_VIS_BINDING_H
#define FOX_PIXEL_VIS_BINDING_H
#include "visibility.h"
#include "ui/kasane/ksn_mesh_depth.h"
typedef struct { vis_binding scene; uint64_t snapshot_hash; size_t snapshot_bytes; } fox_pixel_binding;
/* Initialize zero. Binding captures immutable snapshot bytes; caller builds scene
 * from same evaluated whole geometry before source disposal. Tokens alone do not
 * prove correspondence. Hash is accidental mutation detection, not authentication. */
vis_status fox_pixel_bind(fox_pixel_binding *,vis_scene *,vis_generation,const ksn_mesh_pixel_snapshot *);
bool fox_pixel_binding_matches(const fox_pixel_binding *,vis_generation,const ksn_mesh_pixel_snapshot *);
void fox_pixel_unbind(fox_pixel_binding *);
bool fox_pixel_render_bound(const fox_pixel_binding *,vis_generation,const ksn_mesh_pixel_snapshot *,uint16_t *,unsigned,unsigned,float *,unsigned,ksn_mesh_pixel_stats *,vis_budget *);
#endif
