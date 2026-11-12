#ifndef FOX_CAMERA_BACKGROUND_H
#define FOX_CAMERA_BACKGROUND_H
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include "../visibility/visibility.h"
#include "../physical/fox_disk_lighting.h"
#include "ui/kasane/ksn_scene_composition.h"
/* Private host-only opt-in. All quotas are cumulative for one declared frame.
 * No original character, physical, visibility or transport API is changed. */
#define FOX_BG_WORK_CAP UINT64_C(1540298112)
#define FOX_BG_MAX_SLOTS UINT64_C(39573)
#define FOX_BG_GEOMETRY_RESERVATION UINT64_C(41964)
#define FOX_BG_OWNED_CAP 16384u
#define FOX_BG_SHADOW_RAYS UINT64_C(2000000)
#define FOX_BG_SHADOW_NODES UINT64_C(200000000)
#define FOX_BG_SHADOW_TRIANGLES UINT64_C(100000000)
typedef enum { FOX_BG_OK=0, FOX_BG_INVALID, FOX_BG_ALLOC, FOX_BG_GENERATION,
 FOX_BG_BUDGET, FOX_BG_NUMERIC, FOX_BG_VISIBILITY, FOX_BG_LIGHTING } fox_bg_status;
typedef struct { vis_generation visibility; uint64_t camera,material,emission,illumination; } fox_bg_generation;
typedef struct {
 fox_bg_generation generation;
 uint64_t snapshot_fingerprint,identity_fingerprint;
 float camera[9];
 double source_origin[3],source_view[3],clip[2];
 double floor[4][3]; uint32_t indices[6];
 double rho[3],le[3]; FoxDiskScene lights;
} fox_bg_input;
typedef struct fox_bg_scene fox_bg_scene;
typedef struct { fox_bg_scene *scene; fox_bg_generation expected; } fox_bg_binding;
typedef enum {
 BGW_CONSTRUCT, BGW_FRAME, BGW_SLOT, BGW_CAMERA, BGW_TRIANGLES, BGW_ORDER,
 BGW_COMMIT, BGW_DISK_ADMISSION, BGW_DISK_RECEIVER, BGW_DISK_KERNEL,
 BGW_DISK_CONTROL, BGW_SHADOW_BRIDGE, BGW_DISK_REDUCTION,
 BGW_FLOOR_COMPOSITION, BGW_WORLD, BGW_COUNT
} fox_bg_work_category;
typedef struct {
 uint64_t limit[BGW_COUNT],used[BGW_COUNT],limit_total,used_total;
 uint64_t slot_limit,shade_limit,slots,floor_evaluations,world_misses;
} fox_bg_work;
typedef enum { FOX_BG_FLOOR_HIT=0, FOX_BG_PARALLEL=1, FOX_BG_NEGATIVE_T=2,
 FOX_BG_OUTSIDE=3, FOX_BG_CLIP=4 } fox_bg_miss;
typedef struct {
 uint32_t x,y,sample,action,miss_reason,triangle;
 float character_depth,floor_depth;
 double position[3],normal[3],direct[3],world[3],emission[3],combined[3];
 uint64_t snapshot_fingerprint,identity_fingerprint,positive_queries,blocked_queries;
} fox_bg_result;
typedef struct {
 uint64_t slots,keep,floor,world,parallel,negative_t,outside,clip,
 positive_queries,blocked_queries;
} fox_bg_counters;
typedef struct {
 fox_bg_binding binding; fox_bg_work *work; vis_budget *shadow_budget;
 fox_bg_counters counters; fox_bg_result last_result; uint32_t mode,reserved;
} fox_bg_context;
/* All input arrays are copied. The existing BVH is retained, not rebuilt.
 * Initialized slot/binding/context objects only; forged pointers unsupported.
 * Detectable input/owned aliases reject. Replacement is failure-atomic.
 * Scene group changes require their own monotonic token; illumination is
 * independent from retained visibility.light. All tokens must be nonzero. */
fox_bg_status fox_bg_scene_build(fox_bg_scene **slot,vis_scene *geometry,
 const fox_bg_input *input,fox_bg_work *work,size_t max_bytes);
fox_bg_status fox_bg_scene_retain(fox_bg_scene *scene);
void fox_bg_scene_release(fox_bg_scene *scene);
size_t fox_bg_scene_bytes(const fox_bg_scene *scene);
size_t fox_bg_scene_required_bytes(void);
int fox_bg_scene_overlaps(const fox_bg_scene *,const void *,size_t);
fox_bg_generation fox_bg_scene_generation(const fox_bg_scene *);
fox_bg_status fox_bg_binding_set(fox_bg_binding *,fox_bg_scene *,fox_bg_generation);
void fox_bg_binding_clear(fox_bg_binding *);
fox_bg_status fox_bg_work_init(fox_bg_work *,uint64_t slot_bound,uint64_t shade_bound);
const char *fox_bg_work_category_name(unsigned);
/* Fingerprints are canonical byte FNV1a, never opaque structure hashes. */
uint64_t fox_bg_fingerprint(const void *,size_t);
/* Once-per-frame admission retains scene/copies input identities; snapshot and
 * identity buffers may be released after success. Work and shadow-budget
 * controls remain caller-owned and must stay live throughout the frame.
 * The dedicated shadow budget starts at zero and stays cumulative.
 * Current snapshot prepared lights and world must exactly match descriptor.
 * Current snapshot and identity bytes are hashed once, not per query.
 * Failed output/context mutations are atomic; accepted work remains consumed.
 * A later failed query invalidates the entire private/unpublished frame. */
fox_bg_status fox_bg_context_begin(fox_bg_context *,fox_bg_scene *,fox_bg_generation,
 uint32_t mode,fox_bg_work *,vis_budget *,const void *snapshot,size_t snapshot_bytes,
 const void *identity,size_t identity_bytes);
void fox_bg_context_clear(fox_bg_context *);
/* Read-only completeness/fee/counter gate, prepaid by frameAdmission. */
fox_bg_status fox_bg_context_finish(const fox_bg_context *);
bool fox_bg_context_overlaps(void *,const void *,size_t);
size_t fox_bg_context_owned_bytes(const fox_bg_context *);
/* Only retained final slots. sample UINT32_MAX=center; 0..3=quarter offsets.
 * Canonical no-character depth is zero. KEEP returns zero RGB. Exact native
 * float floor depth controls precedence, never an analytic-depth tolerance.
 * Work/VIS counters survive failure; result and aggregate counters do not. */
fox_bg_status fox_bg_resolve(fox_bg_context *,const KsnSceneQuery *,fox_bg_result *);
bool fox_bg_compose(void *,const KsnSceneQuery *,KsnSceneResult *);
const char *fox_bg_status_string(fox_bg_status);
#endif
