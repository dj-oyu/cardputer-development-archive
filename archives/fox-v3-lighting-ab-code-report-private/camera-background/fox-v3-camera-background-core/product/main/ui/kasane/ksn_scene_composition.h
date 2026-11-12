#ifndef KSN_SCENE_COMPOSITION_H
#define KSN_SCENE_COMPOSITION_H
#include "ksn_boundary_aa.h"
/* Explicit host experiment. Original A2 entry points remain unchanged. */
enum { KSN_SCENE_COMPOSITE=0, KSN_SCENE_BACKGROUND_ONLY=1 };
enum { KSN_SCENE_KEEP_CHARACTER=0, KSN_SCENE_REPLACE_FLOOR=1, KSN_SCENE_REPLACE_WORLD=2 };
enum { KSN_SCENE_CLASS_UNKNOWN=0, KSN_SCENE_FLOOR_HIT=1, KSN_SCENE_SCENE_MISS=2 };
enum { KSN_SCENE_CORE_CAP=1680000, KSN_SCENE_OWNED_CAP=16384, KSN_SCENE_NEW_STACK_CAP=4096 };
typedef struct {
 uint32_t x,y,sample,character_hit;
 float character_depth; /* canonical0 when !character_hit */
 uint32_t mode;
} KsnSceneQuery; /*24B; UINT32_MAX center,0..3 fixed quarter offsets */
typedef struct {
 uint32_t action,floor_classification;
 double floor_native_depth; /* exact compared float promoted;0 on SCENE_MISS */
 double linear_rgb[3];
} KsnSceneResult; /*40B; entire object zeroed; successful KEEP RGB is canonical+0 */
typedef bool (*KsnSceneCompose)(void *,const KsnSceneQuery *,KsnSceneResult *);
/* Must report every resolver-owned allocation, retained scene, budget/work
 * allocation and callback state overlap. It must not mutate anything. */
typedef bool (*KsnSceneOwnedOverlap)(void *,const void *,size_t);
typedef struct {
 KsnSceneCompose compose;
 KsnSceneOwnedOverlap overlaps;
 void *context;size_t context_bytes;
 const void *descriptor;size_t descriptor_bytes;
 void *shadow_budget;size_t shadow_budget_bytes;
 size_t resolver_owned_bytes; /* includes all new resolver-owned state once */
 uint64_t snapshot_fingerprint,identity_fingerprint,target_mask_fingerprint;
 uint32_t mode,expected_targets;
} KsnSceneBinding;
typedef enum {
 SC_BINDING,SC_MASK_COPY,SC_MASK_HASH,SC_CENTER_STATE,SC_HDR_CLEAR,
 SC_SAMPLE_SCAN,SC_OUTPUT_SCAN,SC_QUERY,SC_RESULT_ZERO,SC_DISPATCH,
 SC_RGB_VALIDATE,SC_DECISION_VALIDATE,SC_EVENTS,SC_REPLACEMENT_COPY,
 SC_ORIGINAL_MISS_ACCUM,SC_CONTROL_ACCUM,SC_CENTER_ENCODE,SC_CONTROL_ENCODE,
 SC_GUARDS,SC_DESCRIPTOR_HASH,SC_CATEGORY_COUNT
} KsnSceneCategory;
typedef struct {uint64_t value[SC_CATEGORY_COUNT];} KsnSceneLedger;
typedef struct {
 KsnSceneLedger reserved,observed;
 uint64_t reserved_total,observed_total;
 uint64_t queries,centers,quarters,kept,floor,world,occluded_character;
 unsigned failed_category;bool complete,descriptor_fingerprint_executed;
} KsnSceneReport;
/* Exact source-frozen category names. Core never hashes opaque descriptor
 * padding: optional descriptor-hash reservation is retained, observed0. */
const char *ksn_scene_category_name(unsigned);
/* Background binding NULL directly dispatches to frozen A2. Caller initializes
 * RGB black. False leaves partial outputs private; no image rollback promise.
 * Source/geometry target masks, character depth and old A2 report stay separate.
 * Explicit byte lengths cover shader/observer contexts, not one-byte checks.
 * Invalid admission preserves caller outputs, including a prior complete report.
 * Always check the boolean return before interpreting report.complete. */
bool ksn_mesh_pixel_render_scene_composition_experimental(
 const ksn_mesh_pixel_snapshot *,uint16_t *,float *,ksn_aa_workspace *,
 const ksn_aa_identity *,const ksn_aa_ledger *,FoxPixelShader,void *,size_t,
 KsnAASampleObserver,void *,size_t,
 const KsnSceneBinding *,const KsnSceneLedger *,KsnSceneReport *);
/* Separate camera-hidden control. Mask is geometry-bound and copied into
 * workspace.targets; no camera character shading or character-depth output.
 * Resolver frame admission must already bind snapshot/identity/camera/scene.
 * Mask input stays live for this synchronous call; caller includes its4050B
 * construction storage in the separately approved new-owned peak. */
bool ksn_mesh_pixel_render_background_control_experimental(
 uint16_t *,ksn_aa_workspace *,const uint8_t *,size_t,
 const KsnSceneBinding *,const KsnSceneLedger *,KsnSceneReport *);
#endif
