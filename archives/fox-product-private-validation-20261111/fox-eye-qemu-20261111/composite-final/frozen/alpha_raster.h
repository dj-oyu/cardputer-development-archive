#ifndef FOX_ALPHA_RASTER_H
#define FOX_ALPHA_RASTER_H
#include "scene.h"
/* Opaque=1 / transparent=0 only. Fractional, NaN and infinite return fail.
   Callback applies only after coverage/depth pass; may not mutate scene/workspace.
   Accumulate failure can dirty its private workspace; fox_scene_band is atomic to out. */
typedef double (*fox_alpha_fn)(void*,unsigned face,const double weights[3]);
typedef double (*fox_sample_fn)(void*,unsigned,const double[3],int,int,float);
bool fox_accumulate_samples(const ksn_mesh_prepared*,uint16_t*,unsigned,unsigned,float*,fox_sample_fn,void*);
typedef struct {unsigned triangle,material,object; double local[3]; int x,y; float depth;} fox_fragment;
typedef double (*fox_fragment_fn)(void*,const fox_fragment*);
bool fox_accumulate(const ksn_mesh_prepared*,uint16_t*,unsigned,unsigned,float*,fox_alpha_fn,void*);
bool fox_scene_band(const scene_frame*,uint16_t*,unsigned,unsigned,unsigned,scene_workspace*,int,fox_fragment_fn,void*);
/* The optional array has exactly SCENE_VERTICES evaluated local positions in
 frozen vertex order, remains immutable for the frame, and must be supplied to
 BOTH prepare and band. All original topology is retained; bins are rebuilt.
 Body pose skinning still takes precedence for vertices <229 when pose>=0.
 Object transforms remain frozen source transforms plus existing head rig. */
bool fox_scene_prepare_local(const scene_frame*,scene_frame*,scene_workspace*,int,unsigned,int,scene_times*,const float (*)[3]);
bool fox_scene_band_local(const scene_frame*,uint16_t*,unsigned,unsigned,unsigned,scene_workspace*,int,fox_fragment_fn,void*,const float (*)[3]);
#endif
