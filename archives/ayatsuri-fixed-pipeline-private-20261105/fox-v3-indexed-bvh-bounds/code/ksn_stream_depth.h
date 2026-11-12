#ifndef KSN_STREAM_DEPTH_H
#define KSN_STREAM_DEPTH_H
#include "ksn_cached_profile.h"
/* PRIVATE opt-in scratch contract. Original descriptor and every admitted span
 * remain live through synchronous return. Descriptor fields are frozen before
 * callbacks; callbacks must not free/reallocate original admitted storage.
 * capture is NULL/0 in production, or a private diagnostic129600-byte span.
 * No full-depth lifetime is promised for strip/pending. Old APIs are unchanged. */
typedef struct {
 float *strip; size_t strip_bytes;
 float *pending; size_t pending_bytes;
 float *capture; size_t capture_bytes;
} KsnStreamDepth;
typedef struct {
 uint64_t pending_copy_floats, capture_copy_floats;
 bool complete;
} KsnStreamDepthReport;
/* Adapter-only: caller admits cache/static profile asset and all other context.
 * Failure may leave scratch/RGB/capture partial; reports do not authorize publish. */
bool ksn_mesh_pixel_render_stream_depth_private(
 const ksn_mesh_pixel_snapshot *,uint16_t *,size_t,const KsnStreamDepth *,
 ksn_bounded_ring_workspace *,size_t,const ksn_aa_identity *,const ksn_aa_ledger *,
 FoxPixelShader,void *,size_t,const KsnSceneBinding *,const KsnSceneLedger *,
 KsnSceneReport *,agx_block_cache *,KsnBandHDRReport *,KsnStreamDepthReport *);
#endif
