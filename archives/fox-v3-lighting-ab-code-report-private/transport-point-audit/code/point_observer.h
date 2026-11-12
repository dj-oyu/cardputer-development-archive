#ifndef PRIVATE_POINT_OBSERVER_H
#define PRIVATE_POINT_OBSERVER_H
#include "bounce.h"
#include "ayatsuri/ayatsuri_model.h"
#include "ayatsuri/compact_opaque.h"
typedef struct {
 unsigned covered,node,face,back,second;uint8_t indices[3];
 double weights[3],position[3],normal[3],rho[3],rgb[3];
 co_pixel_vertex vertices[3];bounce_result result;vis_counters direct,transport;
} point_query;
extern bounce_result point_last_result;
extern vis_counters point_last_direct,point_last_transport;
extern point_query point_queries[240*135];
bool point_capture(unsigned,unsigned,unsigned,unsigned,bool,bool,const uint8_t[3],const double[3],const double[3],const double[3],const double[3],const double[3],const co_pixel_vertex[3]);
bool point_map(unsigned,const ksn_proc_gouraud_patch *,const ayatsuri_model_world_mesh_view *);
bool point_dump(const char *);
#endif
