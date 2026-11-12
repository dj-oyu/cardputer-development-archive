# Exact cached profile renderer

Host-only new opt-in integration based on completed fox-v3-aa-phase-overlay, preserving AA72512, segmented model/depth/transport/indexed BVH and fixed physical arithmetic. No rejected owned-ray-context or paged-BVH code used. No actual40 before source freeze, independent review and parent gate.

The private RowCachedRenderBands extends a separate descriptor with an explicit agx_block_cache pointer. Existing RowRender/RowRenderBands and generic callback APIs remain unchanged. A mechanical private core specialization threads that pointer in the old callback slot; it calls the unchanged exact cache evaluator. Core cache entry is adapter-only: callers must admit cache and blob first. There is no mutable renderer global/TLS state.

Caller makes one3224-byte allocation, explicitly initializes/binds to the single static445248-byte profile blob, checks admission, and retains storage through render and prediction checks. Clear/free occurs before final exports and on observer-begin failure. Rebinding resets even at the same address. Allocation failure rejects, never falls back to a global or raw LUT. Cache selected-record snapshot validation remains unchanged. Buffers must be valid/readable/stable and independent callers need distinct caches.

Existing descriptor span is replaced by the larger descriptor, encoded blob replaces raw LUT span, cache is sole appended span.29 spans gives406 OFF/435 ON pair checks, plus unchanged core210 =616/645. All old pair and owner overlap checks remain; unchanged admission cap1024, producer cap637599, ray/shader budgets and background cap4096. Setup4913 record range validation, hit/miss snapshot comparison/decode/copy and release clearing are separately disclosed, not hidden as free work.

Successful exact rendering must match baseline fixed40 raw outputs and old semantic reports except the explicit .row admission pair deltas. Sidecar records cache work and complete state after native prediction checks. Cached core failure may modify private pixels/depth; caller must require true, native postchecks and completion marker before accepting any exports. No whole-frame transactionality, atomic multi-file publication or general leak-clean claim.

Production legacy entrypoints use the separately validated stateless gather on the same encoded singleton rather than retaining the raw LUT. Original raw u16 evaluator appears only in synthetic oracle test binaries. Current entrypoint under evaluation is exclusively row_transport_render_cached_bands.
