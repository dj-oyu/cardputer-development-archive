#ifndef FOX_BOUNCE_H
#define FOX_BOUNCE_H
#include "../visibility/visibility.h"
#include "../physical/fox_disk_lighting.h"
#define BOUNCE_MAX_TRIANGLES 2048u
/* Exactly 20 bytes/vertex and 64/triangle. SNORM is signed /32767; -32768 is rejected. Mask sign chooses B for >=0, A otherwise, before RGB interpolation. */
typedef struct { int16_t front[3], back[3]; float mask; uint16_t a565,b565; } bounce_vertex;
typedef struct { bounce_vertex v[3]; uint8_t double_sided; uint8_t padding[3]; } bounce_triangle;
typedef struct { vis_generation visibility; uint64_t material, emission; } bounce_generation;
typedef enum { BOUNCE_OK=0, BOUNCE_INVALID, BOUNCE_ALLOC, BOUNCE_GENERATION, BOUNCE_BUDGET, BOUNCE_VISIBILITY, BOUNCE_LIGHTING } bounce_status;
typedef struct bounce_scene bounce_scene;
typedef struct { bounce_scene *scene; bounce_generation generation; } bounce_binding;
typedef enum { BOUNCE_OFF=0, BOUNCE_WORLD_VISIBLE=1, BOUNCE_ONE=2 } bounce_mode;
typedef enum { BOUNCE_GROUND_OFF=0, BOUNCE_GROUND_CONTROL=1, BOUNCE_GROUND_PRIMARY_LE=2 } bounce_ground_mode;
typedef struct {
 bounce_ground_mode mode;
 uint64_t object_id;
 uint32_t first_triangle, triangle_count;
 double le[3];
} bounce_ground;
typedef struct {
 /* Ground primary counts are subsets of primary_hits. Emission hits count
  * PRIMARY_LE events even for zero Le. Secondary count is WORLD rays only. */
 uint64_t primary_ground_hits,primary_ground_emission_hits,secondary_ground_hits;
 uint64_t primary_rays,primary_hits,primary_misses,secondary_world_rays;
 uint64_t primary_direct_queries,secondary_direct_queries;
 uint64_t zero_reflection_ns_v,back_single_discard,grazing_ng_v;
} bounce_counters;
typedef struct { double direct[3], world[3], bounce[3], ground[3], combined[3]; bounce_counters counters; } bounce_result;
/* Copies attributes and lights, retains geometry; atomic replacement. Geometry,
 * pose, light and material tokens are nonzero; legacy emission defaults to zero. Replacement tokens cannot regress and at least one must increase.
 * orientation_sign is +1 for standard world winding, -1 for mirrored native B.
 * Padding must be zero. Hard byte cap is 262144. max_bytes bounds this scene's control+attributes, not retained vis allocations.
 * Caller accounts for retained old/new peaks. No borrowed arrays survive. */
bounce_status bounce_scene_build(bounce_scene **slot, vis_scene *geometry,
 const bounce_triangle *attributes, size_t count, const FoxDiskScene *lights,
 int orientation_sign, bounce_generation generation, size_t max_bytes);
/* Ground is an immutable owned descriptor. NULL means canonical OFF. Enabled
 * ground requires nonzero object_id, nonempty valid original-ordinal range and
 * generation.emission>0. Le is finite nonnegative LINEAR HDR, never sRGB-decoded.
 * Constant emission is two-sided. Tagged ground never evaluates a BSDF. OFF does
 * not remove triangles: caller omits floor geometry for a floor-free legacy arm.
 * Descriptor changes require a strictly increased emission generation.
 * Floor placeholder attributes must still satisfy normal attribute validation. */
bounce_status bounce_scene_build_ground(bounce_scene **slot, vis_scene *geometry,
 const bounce_triangle *attributes, size_t count, const FoxDiskScene *lights,
 int orientation_sign, bounce_generation generation, size_t max_bytes,
 const bounce_ground *ground);
int bounce_scene_matches_ground(const bounce_scene *scene,const bounce_ground *ground);
size_t bounce_scene_required_bytes(size_t count);
size_t bounce_scene_bytes(const bounce_scene *scene);
int bounce_scene_overlaps(const bounce_scene *scene,const void *ptr,size_t bytes);
int bounce_scene_matches_lights(const bounce_scene *scene,const FoxDiskScene *lights);
bounce_status bounce_scene_retain(bounce_scene *scene);
void bounce_scene_release(bounce_scene *scene);
bounce_status bounce_binding_set(bounce_binding *binding,bounce_scene *scene,bounce_generation expected);
void bounce_binding_clear(bounce_binding *binding);
/* Two shared caller-owned budgets per frame, never reset between bands. Suggested
 * primary direct uses direct_budget, all other queries use transport_budget. Suggested
 * hard transport limits: 20M rays / 800M node visits / 300M triangle tests.
 * outer_samples and inner_samples each 16 or 64; production is 16/16. Inner64
 * is diagnostic only, caller restricts it to synthetic/first100 hit queries.
 * OFF keeps direct-visible + unoccluded world. Outputs failure-atomic, counters
 * retain consumed work. Ground Le is only on primary hemisphere first hits.
 * No secondary ground emission, floor BSDF, tertiary bounce, or image fitting. */
bounce_status bounce_eval(const bounce_binding *binding,bounce_generation expected,
 const double position[3],const double normal[3],const double rho[3],
 bounce_mode mode,unsigned outer_samples,unsigned inner_samples,
 vis_budget *direct_budget,vis_budget *transport_budget,bounce_result *out);
const char *bounce_status_string(bounce_status status);
#endif
