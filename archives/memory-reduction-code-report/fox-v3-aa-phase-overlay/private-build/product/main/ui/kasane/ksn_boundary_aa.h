#ifndef KSN_BOUNDARY_AA_H
#define KSN_BOUNDARY_AA_H
#include "ksn_mesh_depth.h"
/* Host-only experimental API: subpixel passes shade FINAL visible winners.
 * Hidden/intermediate shader failures are deliberately unobserved. This is
 * NOT legacy error equivalence. Existing APIs/defaults remain unchanged.
 * On false, all caller outputs are partial and MUST remain unpublished. */
enum { KSN_AA_PIXELS=240*135, KSN_AA_BAND_PIXELS=240*8,
 KSN_AA_MAX_RECORDS=54, KSN_AA_MAX_FACES=1564, KSN_AA_NOHIT=65535,
 KSN_AA_WORKSPACE_CAP=147456, KSN_AA_IDENTITY_RO_CAP=8192,
 KSN_AA_NEW_STACK_RESERVE=8192 };
typedef enum {
 AA_LEGACY_CENTER, AA_CENTER_ID_INIT, AA_CENTER_ID_UPDATE, AA_MASK_CLEAR,
 AA_NEIGHBOR_COMPARE, AA_HDR_CLEAR, AA_SAMPLE_CLEAR, AA_RECORD_VISIT,
 AA_FACE_SETUP, AA_BBOX_MASK, AA_TARGET_GEOMETRY, AA_FINAL_SCAN,
 AA_FINAL_SHADE, AA_FINAL_ENCODE, AA_SOURCE_VALIDATE,
 AA_IDENTITY_KEY_CLEAR, AA_IDENTITY_HASH, AA_SNAPSHOT_BINDING_HASH,
 AA_CONTROL, AA_COUNTER_GUARDS, AA_FINAL_OUTPUT_SCAN, AA_CATEGORY_COUNT
} ksn_aa_category;
typedef struct { uint64_t value[AA_CATEGORY_COUNT]; } ksn_aa_ledger;
typedef struct {
 const uint8_t *bytes; size_t size; unsigned records,faces;
 uint64_t fingerprint; /* pinned table FNV1a64, never inferred from current bytes */
 uint64_t snapshot_fingerprint; /* expected already-bound owned snapshot FNV1a64 */
} ksn_aa_identity;
typedef struct {
 ksn_aa_ledger reserved, observed;
 uint64_t reserved_total, observed_total;
 uint64_t center_shades, sample_shades, targets, covered_targets, nohit_targets;
 uint64_t sample_hits[4], sample_nohits[4];
 uint64_t source_fingerprint, snapshot_fingerprint;
 unsigned failed_category;
 bool complete;
} ksn_aa_report;
typedef struct {
 uint16_t center_id[KSN_AA_PIXELS];
 uint8_t targets[(KSN_AA_PIXELS+7)/8];
 union { double hdr[KSN_AA_BAND_PIXELS][3]; uint16_t identity_key[4960]; } reuse;
 union {
  struct { uint16_t winner_record[KSN_AA_BAND_PIXELS];
   uint8_t winner_face[KSN_AA_BAND_PIXELS];
   float winner_depth[KSN_AA_BAND_PIXELS]; };
  double delayed_center_hdr[240][3];
 }; /* Mutually exclusive center-phase pending row / quarter winner lifetime. */
 uint16_t source[KSN_AA_MAX_RECORDS+1][64];
 uint16_t offsets[KSN_AA_MAX_RECORDS+1];
 co_view records[KSN_AA_MAX_RECORDS];
 unsigned record_count;
 ksn_aa_report report;
} ksn_aa_workspace;
typedef struct {
 unsigned x,y,sample; bool hit;
 uint16_t record_offset,node,source_id; uint8_t face; bool back; float depth;
 double position[3],normal[3],rho[3],linear_rgb[3];
} ksn_aa_sample;
/* Optional output-only synchronous diagnostic observer. No retained pointers.
 * Called once/selected sample, including black nohit. False aborts publication.
 * Observer I/O and its caller-owned storage are separate diagnostic overhead. */
typedef bool (*KsnAASampleObserver)(void *,const ksn_aa_sample *);
/* Immutable identity layout: (records+1) little-endian uint16 offsets followed
 * by faces*(original ordered local vertex indices[3],sourceID little-endian16).
 * Nodes are pinned 1..records. Each node maps a unique unordered triangle key;
 * actual winding parity relative to original must equal physical_back.
 * RGB must be initialized black by caller, as in the legacy adapter.
 * Full frame RGB and center depth are caller-owned (194400B separately).
 * Workspace, outputs, identity, snapshot and shader-owned state must be disjoint.
 * Caller provides conservative per-category reservations; total must <=8M.
 * Only owned snapshot data is read after caller model disposal. */
bool ksn_mesh_pixel_render_boundary_experimental(
 const ksn_mesh_pixel_snapshot *,uint16_t *,float *,ksn_aa_workspace *,
 const ksn_aa_identity *,const ksn_aa_ledger *,FoxPixelShader,void *,
 KsnAASampleObserver,void *);
const char *ksn_aa_category_name(unsigned);
size_t ksn_aa_workspace_bytes(void);
#endif
