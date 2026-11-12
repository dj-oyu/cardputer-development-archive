#ifndef KSN_CACHED_PROFILE_H
#define KSN_CACHED_PROFILE_H
#include "ksn_bounded_ring.h"
#include "../cache/block_cache.h"
/* PRIVATE: only the admitted cached adapter may call this function. Cache and
 * static blob are fully admitted by that caller, live and stable until return. */
bool ksn_mesh_pixel_render_cached_depth_bands_private(
 const ksn_mesh_pixel_snapshot *,uint16_t *,size_t,const KsnDepthBands *,
 ksn_bounded_ring_workspace *,size_t,const ksn_aa_identity *,const ksn_aa_ledger *,
 FoxPixelShader,void *,size_t,const KsnSceneBinding *,const KsnSceneLedger *,
 KsnSceneReport *,agx_block_cache *,KsnBandHDRReport *);
#endif
