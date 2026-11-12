#ifndef KSN_BOUNDED_RING_H
#define KSN_BOUNDED_RING_H
#include "ksn_bounded_hdr.h"
/* Opt-in bounded-HDR-only ABI. Generic AA retains its full-frame IDs. */
typedef struct {
 uint16_t center_id[10*240];
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
} ksn_bounded_ring_workspace;
bool ksn_mesh_pixel_render_bounded_ring_experimental(
 const ksn_mesh_pixel_snapshot *,uint16_t *,size_t,float *,size_t,
 ksn_bounded_ring_workspace *,size_t,const ksn_aa_identity *,const ksn_aa_ledger *,
 FoxPixelShader,void *,size_t,const KsnSceneBinding *,const KsnSceneLedger *,
 KsnSceneReport *,KsnBandProfile,KsnBandHDRReport *);

/* Fixed-size opt-in depth storage. Caller descriptor and all five exact spans
 * stay live through return; caller must prevent concurrent mutation. The core
 * snapshots pointers/lengths before callbacks, never following later rebinding.
 * Callbacks must not free/reallocate the original admitted storage. */
enum { KSN_DEPTH_BANDS=5, KSN_DEPTH_BAND_ROWS=32 };
typedef struct { float *band[5]; size_t bytes[5]; } KsnDepthBands;
bool ksn_mesh_pixel_render_depth_bands_experimental(
 const ksn_mesh_pixel_snapshot *,uint16_t *,size_t,const KsnDepthBands *,
 ksn_bounded_ring_workspace *,size_t,const ksn_aa_identity *,const ksn_aa_ledger *,
 FoxPixelShader,void *,size_t,const KsnSceneBinding *,const KsnSceneLedger *,
 KsnSceneReport *,KsnBandProfile,KsnBandHDRReport *);
#endif
