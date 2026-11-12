#ifndef FOX_COMPOSITE_H
#define FOX_COMPOSITE_H
#include "alpha_raster.h"
#define FOX_STRIP_PIXELS (240*4)
/* Linear, unpremultiplied source RGB; finite nonnegative values (HDR allowed).
   alpha in [0,1]. User callback must be deterministic and have no external effects. */
typedef bool (*fox_surface_fn)(void*,const fox_fragment*,float rgb[3],float *alpha);
typedef struct {
 float previous_depth[FOX_STRIP_PIXELS], next_depth[FOX_STRIP_PIXELS];
 unsigned previous_id[FOX_STRIP_PIXELS],next_id[FOX_STRIP_PIXELS];
 float next_rgb[FOX_STRIP_PIXELS][3],next_alpha[FOX_STRIP_PIXELS];
 float accumulated[FOX_STRIP_PIXELS][3],transmittance[FOX_STRIP_PIXELS];
 uint16_t scratch[FOX_STRIP_PIXELS];
 unsigned passes,max_observed_layers;
} fox_composite_workspace;
/* Bounded front-to-back depth peeling. On overflow or callback/geometry failure,
   out remains unchanged. All five supplied spans (frame, scene workspace,
   output, composite workspace, optional local array) must be pairwise disjoint.
   Overlap/wrapping spans fail before writes. Caller-owned callback context has
   unknown size: it must remain immutable and not alias either workspace/output.
   Existing scene/workspace/array lifetime rules apply.
   Equal-depth fragments sort by source triangle ID ascending. Background and
   final output are sRGB RGB565; blending takes place exclusively in linear RGB. */
bool fox_scene_composite(const scene_frame*,uint16_t*out,unsigned y,unsigned rows,unsigned batch_limit,scene_workspace*,const float (*local)[3],fox_surface_fn,void*,unsigned max_layers,fox_composite_workspace*);
/* Full-frame preflight before any streaming publication. Same immutable scene,
   local array, deterministic callback/context and max_layers MUST be reused.
   Does not itself make a hardware stream atomic against transport failure. */
bool fox_scene_composite_preflight(const scene_frame*,scene_workspace*,const float (*)[3],fox_surface_fn,void*,unsigned,fox_composite_workspace*);
#endif
