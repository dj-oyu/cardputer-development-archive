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
typedef enum { BOUNCE_GROUND_OFF=0, BOUNCE_GROUND_CONTROL=1, BOUNCE_GROUND_PRIMARY_LE=2, BOUNCE_GROUND_PRIMARY_LE_DIRECT=3 } bounce_ground_mode;
typedef struct {
 bounce_ground_mode mode;
 uint64_t object_id;
 uint32_t first_triangle, triangle_count;
 double le[3];
 double rho[3]; /* Source LINEAR RGB [0,1]; canonical zero for modes 0..2. */
} bounce_ground;
/* Separate host diagnostic reservations, never AA stages or CPU instructions.
 * The VIS query implementation retains its independent cumulative quotas. */
#define BOUNCE_FLOOR_MAX_SHADERS UINT64_C(17241)
#define BOUNCE_FLOOR_MAX_HITS UINT64_C(71667)
#define BOUNCE_FLOOR_WORK_CAP UINT64_C(875970912)
typedef enum {
 BOUNCE_FW_DESCRIPTOR, BOUNCE_FW_MERGE, BOUNCE_FW_NORMAL,
 BOUNCE_FW_ADMISSION, BOUNCE_FW_RECEIVER, BOUNCE_FW_KERNEL,
 BOUNCE_FW_CALLBACK, BOUNCE_FW_REDUCTION, BOUNCE_FW_ACCUMULATION,
 BOUNCE_FW_GUARDS, BOUNCE_FW_COUNT
} bounce_floor_work_category;
typedef struct {
 uint64_t limit[BOUNCE_FW_COUNT],used[BOUNCE_FW_COUNT],limit_total,used_total;
 uint64_t shader_limit,floor_hit_limit;
 uint64_t shader_calls,floor_hits,evaluations,zero_rho_hits,tangent_hits;
} bounce_floor_work;
/* Initialized once per frame, including exact predeclared caller workload bounds.
 * Limits may be lowered, never raised above the derived/fixed caps. Caller must
 * not reset consumed work. Failed calls retain prepaid reservations and counts. */
bounce_status bounce_floor_work_init(bounce_floor_work *,uint64_t shaders,uint64_t floor_hits);
const char *bounce_floor_work_category_name(unsigned category);
size_t bounce_floor_work_bytes(void);
typedef struct {
 /* Ground primary counts are subsets of primary_hits. Emission hits count
  * PRIMARY_LE and PRIMARY_LE_DIRECT events even for zero Le. Secondary count is
  * WORLD rays only. Reflection hits count invoked floor disk evaluators. */
 uint64_t primary_ground_hits,primary_ground_emission_hits,secondary_ground_hits;
 uint64_t primary_rays,primary_hits,primary_misses,secondary_world_rays;
 uint64_t primary_direct_queries,secondary_direct_queries;
 uint64_t zero_reflection_ns_v,back_single_discard,grazing_ng_v;
 uint64_t primary_ground_reflection_hits,primary_ground_direct_queries;
} bounce_counters;
typedef struct { double direct[3], world[3], bounce[3], ground[3], combined[3], ground_reflected[3]; bounce_counters counters; } bounce_result;
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
 * Constant emission is two-sided. Modes 0..2 never evaluate a floor BSDF. OFF does
 * not remove triangles: caller omits floor geometry for a floor-free legacy arm.
 * Mode/identity/range/Le changes require increased emission generation. Floor
 * rho changes require increased material generation. No added field is borrowed.
 * Floor placeholder attributes must still satisfy normal attribute validation. */
bounce_status bounce_scene_build_ground(bounce_scene **slot, vis_scene *geometry,
 const bounce_triangle *attributes, size_t count, const FoxDiskScene *lights,
 int orientation_sign, bounce_generation generation, size_t max_bytes,
 const bounce_ground *ground);
/* Explicit opt-in: bitwise lossless 20-byte interning, owned 8-byte indexed
 * triangles. Query validates attributes; returns zero on invalid input. Query
 * and constructor are bounded O((3*count)^2), without heap scratch. Count-only
 * required_bytes remains the legacy allocation size, NOT this layout's size.
 * Worst-case compact allocation may exceed legacy; max_bytes is never widened.
 * As with legacy, input objects must remain valid/unchanged during the call. */
size_t bounce_scene_compact_required_bytes(const bounce_triangle *attributes,size_t count);
bounce_status bounce_scene_build_ground_compact(bounce_scene **slot,vis_scene *geometry,
 const bounce_triangle *attributes,size_t count,const FoxDiskScene *lights,
 int orientation_sign,bounce_generation generation,size_t max_bytes,
 const bounce_ground *ground);
/* Explicit indexed caller input. Both arrays are borrowed only during this call.
 * Counts are 1..6144 vertices and 1..2048 triangles. All vertices, including
 * unused ones, must be valid; only referenced full representations are interned,
 * in triangle/corner order. The query returns zero for invalid/overlapping spans.
 * All span alignment/ranges, side, zero padding and indices are validated.
 * Builder rejects aliases among inputs, slot, geometry, old scene, lights and
 * ground. Caller objects must be readable and unchanged throughout the call.
 * No position deduplication, heap scratch or retained caller descriptor is used.
 * Worst case is bounded O((3*count)^2); max_bytes is never widened. */
#define BOUNCE_MAX_INPUT_VERTICES 6144u
typedef struct { uint16_t index[3]; uint8_t double_sided,padding; } bounce_indexed_triangle;
size_t bounce_scene_indexed_required_bytes(const bounce_vertex *vertices,size_t vertex_count,
 const bounce_indexed_triangle *records,size_t count);
bounce_status bounce_scene_build_ground_indexed(bounce_scene **slot,vis_scene *geometry,
 const bounce_vertex *vertices,size_t vertex_count,const bounce_indexed_triangle *records,
 size_t count,const FoxDiskScene *lights,int orientation_sign,bounce_generation generation,
 size_t max_bytes,const bounce_ground *ground);
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
 * This legacy entrypoint rejects mode3. No secondary ground emission, floor BSDF,
 * tertiary bounce, or image fitting. See the separately budgeted opt-in below. */
bounce_status bounce_eval(const bounce_binding *binding,bounce_generation expected,
 const double position[3],const double normal[3],const double rho[3],
 bounce_mode mode,unsigned outer_samples,unsigned inner_samples,
 vis_budget *direct_budget,vis_budget *transport_budget,bounce_result *out);
/* Only this entrypoint admits ground mode 3, only with BOUNCE_ONE. Whole shader
 *128, each tagged floor hit192 and each floor evaluator12000 are prepaid.
 * Zero rho follows old LE arithmetic with no new light queries/result counters.
 * Raw floor Ng is oriented against incoming ray; exact tangent reflects zero.
 * work must be disjoint from bindings, scene, all inputs, budgets and output. */
bounce_status bounce_eval_floor_experimental(const bounce_binding *,bounce_generation,
 const double position[3],const double normal[3],const double rho[3],
 bounce_mode,unsigned outer_samples,unsigned inner_samples,
 vis_budget *direct_budget,vis_budget *transport_budget,bounce_floor_work *,bounce_result *);

/* Isolated floor -> uniform world terminal path, fixed 16/16. Existing result
 * and counter ABIs are unchanged. OFF uses the previous entrypoint verbatim.
 * Work reservations are independent host semantic units, not CPU instructions.
 * Every visibility query charges the SAME cumulative transport vis_budget.
 * No heap, geometry copy, ray ownership/context or increased ray/node/tri cap. */
#define BOUNCE_FLOOR_WORLD_SAMPLES 16u
#define BOUNCE_FLOOR_WORLD_SHADER_WORK UINT64_C(64)
#define BOUNCE_FLOOR_WORLD_HIT_WORK UINT64_C(6272)
#define BOUNCE_FLOOR_WORLD_WORK_CAP (BOUNCE_FLOOR_MAX_SHADERS*BOUNCE_FLOOR_WORLD_SHADER_WORK+BOUNCE_FLOOR_MAX_HITS*BOUNCE_FLOOR_WORLD_HIT_WORK)
typedef struct {
 uint64_t shader_limit,hit_limit,work_limit,work_used,shader_calls,evaluations;
 uint64_t queries,misses,blocked_floor,blocked_character;
 vis_counters visibility_used;
} bounce_floor_world_work;
typedef struct { double reflected_world[3]; } bounce_floor_world_result;
bounce_status bounce_floor_world_work_init(bounce_floor_world_work *,uint64_t shaders,uint64_t hits);
/* 64 units per shader setup/merge; each eligible floor hit reserves:
 * 16*256 direction construction, 16*128 query control, 128 reduction/accumulation.
 * Traversal is separately charged by existing exact ray/node/triangle quotas.
 * All inputs/outputs and ledgers must be disjoint; outputs commit atomically.
 * Failed queries retain both prepaid semantic work and exact consumed traversal.
 * Fixed transport caps 20M/800M/300M, direct caps 1M/100M/50M. */
bounce_status bounce_eval_floor_world_experimental(const bounce_binding *,bounce_generation,
 const double position[3],const double normal[3],const double rho[3],
 bounce_mode,unsigned outer_samples,unsigned inner_samples,
 vis_budget *direct_budget,vis_budget *transport_budget,bounce_floor_work *,
 bounce_floor_world_work *,bounce_result *,bounce_floor_world_result *);
const char *bounce_status_string(bounce_status status);
#endif
