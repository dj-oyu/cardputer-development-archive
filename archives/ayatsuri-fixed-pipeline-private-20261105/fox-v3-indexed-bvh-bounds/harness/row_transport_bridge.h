#ifndef ROW_TRANSPORT_BRIDGE_H
#define ROW_TRANSPORT_BRIDGE_H
#include "pixel_transport.h"
#include "ksn_bounded_ring.h"
#include "background.h"
/* Constructor-owned aligned live objects only; forged pointers are not supported. */
typedef struct { uint64_t limit,used; } RowHostVerification;
typedef struct {
 fox_transport_context *tx; const ksn_mesh_pixel_snapshot *snapshot;
 uint16_t *pixels; float *depth; ksn_bounded_ring_workspace *workspace;
 const ksn_aa_identity *identity; const ksn_aa_ledger *limits;
 const KsnSceneBinding *composition; const KsnSceneLedger *composition_limits;
 KsnSceneReport *composition_report; KsnBandHDRReport *hdr_report;
 fox_bg_work *background_work; RowHostVerification *verification;
} RowRender;
bool row_transport_render(const RowRender *);
typedef struct {
 fox_transport_context *tx; const ksn_mesh_pixel_snapshot *snapshot;
 uint16_t *pixels; KsnDepthBands depth; ksn_bounded_ring_workspace *workspace;
 const ksn_aa_identity *identity; const ksn_aa_ledger *limits;
 const KsnSceneBinding *composition; const KsnSceneLedger *composition_limits;
 KsnSceneReport *composition_report; KsnBandHDRReport *hdr_report;
 fox_bg_work *background_work; RowHostVerification *verification;
} RowRenderBands;
bool row_transport_render_bands(const RowRenderBands *);
#include "../cache/block_cache.h"
typedef struct {
 fox_transport_context *tx; const ksn_mesh_pixel_snapshot *snapshot;
 uint16_t *pixels; KsnDepthBands depth; ksn_bounded_ring_workspace *workspace;
 const ksn_aa_identity *identity; const ksn_aa_ledger *limits;
 const KsnSceneBinding *composition; const KsnSceneLedger *composition_limits;
 KsnSceneReport *composition_report; KsnBandHDRReport *hdr_report;
 fox_bg_work *background_work; RowHostVerification *verification;
 agx_block_cache *cache;
} RowCachedRenderBands;
bool row_transport_render_cached_bands(const RowCachedRenderBands *);
#include "ksn_stream_depth.h"
typedef struct {
 fox_transport_context *tx; const ksn_mesh_pixel_snapshot *snapshot;
 uint16_t *pixels; KsnStreamDepth depth; ksn_bounded_ring_workspace *workspace;
 const ksn_aa_identity *identity; const ksn_aa_ledger *limits;
 const KsnSceneBinding *composition; const KsnSceneLedger *composition_limits;
 KsnSceneReport *composition_report; KsnBandHDRReport *hdr_report;
 fox_bg_work *background_work; RowHostVerification *verification;
 agx_block_cache *cache; KsnStreamDepthReport *depth_report;
} RowStreamRender;
bool row_transport_render_stream_depth(const RowStreamRender *);
#endif
