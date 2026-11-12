#ifndef PRIVATE_RENDER_ADAPTER_H
#define PRIVATE_RENDER_ADAPTER_H
#include "lease.h"
#include "../fox-eye-runtime-20261111/eye_runtime.h"
#include "composite.h"
typedef struct { unsigned y, height; uint16_t pixels[960]; } leased_strip;
typedef struct { scene_frame frame; scene_workspace workspace; fox_composite_workspace composite; } render_scratch;
/* Caller owns exclusive scratch for entire call. Snapshot is already published.
 * submit receives immutable strip and ticket, may complete inline or later.
 * It MUST eventually complete even after failure/cancel, only after all readers
 * stop. false means render failure, NOT permission to reclaim the borrow.
 * pump may retire transport work to provide bounded backpressure. false stops
 * rendering; outstanding strips remain pinned. No callbacks run under locks. */
bool render_leased(lease_pool *snapshots,lease_key snapshot,lease_pool *strips,
 render_scratch*,bool(*submit)(void*,const leased_strip*,lease_ticket),
 bool(*pump)(void*),void*);
#endif
