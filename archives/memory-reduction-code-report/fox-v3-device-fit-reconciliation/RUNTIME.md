# Runtime required-storage reconciliation (read-only design)

Scope: current validated `fox-v3-aa-phase-overlay` only. No implementation, compilation, renders, device access, SDK installation, publication, or PR. Rejected owned-context and unfinished paged-BVH work were not inspected or used. Paths below are relative to the current validated root unless stated otherwise.

## Finding

The highest-impact independent renderer redesign is **bounded center-depth scratch with the existing full private RGB candidate retained**. Current 129,600-byte center-depth retention is an API and diagnostic-output contract, not a need of the quarter-sample algorithm. A conservative proposed shape is 8 rows of float depth (7,680 bytes) plus one delayed row (960 bytes), total 8,640 bytes. This is a design opportunity, not implemented or proven bit-exact.

Gross render-phase opportunity: 129,600 − 8,640 = 120,960 bytes. Holding all other compiled-stack and requested-allocation terms fixed, render would be 370,424 bytes, but unchanged visibility build remains 442,996 bytes. Therefore the next whole named peak would be **at least 442,996**, a maximum 48,388-byte reduction from 491,384 before new overhead. Do not report 120,960 as whole-runtime peak savings or 370,424 as the new overall peak. New admission, stack, copying and private diagnostic storage must be measured and added; full-depth diagnostics retained in RAM erase the proposed gain.

## Baseline and phase accounting

`MEMORY_LEDGER.json:27-82` names these host sums:
- Render: 402,584 heap + 83,792 main stack + 5,008 named child stack = 491,384 bytes.
- Visibility build conservative: 442,996 bytes; this includes model/cold and build inputs/temporary that are not present during rendering.
- Transport build conservative: 385,236 bytes.
- Background build conservative: 351,064 bytes.

The ledger is frozen pre-actual evidence, not the completion record (`MEMORY_LEDGER.json:2-3`). `FINAL_RESULT.json` reports COMPLETE_FIXED40_INDEPENDENT_PASS and confirms the same 491,384 / 83,792 / 5,008 accounting. Existing report validation is evidence for the current baseline only, not this proposal.

Named RO is 1,662,416 bytes, separately classified (`MEMORY_LEDGER.json:85-95`). Do not add it automatically to internal writable SRAM, nor assume it all maps to target flash: linker placement, target ABI, firmware stack/heap and physical addressable regions remain unknown. Host binary text/data/bss in HOST_BINARY_SIZE are a different accounting category. Allocator metadata, fragmentation, libc/libm internals, unrelated caller state and unnamed constants remain excluded. The 777,600-byte diagnostic full-frame HDR observer is already excluded from this product named ledger; omitting it is not a new saving. There is no whole-host or device-fit claim.

## Largest items: required state versus current representation

### Center depth: 129,600 bytes

- Host allocation is five separate float spans, four 30,720-byte and one 6,720-byte, not one contiguous 129,600-byte allocation (`harness/depth_band_alloc.h:5-15`). It lowers largest allocation, not total storage.
- All five are currently mandatory to the exported opt-in API. Exact sizes, alignment, disjoint spans and a frozen descriptor are admission rules (`code/ksn_bounded_ring.h:25-37`; `code/ksn_depth_bands_impl.inc:18-43`). Calling the existing API with 8,640 bytes would be invalid.
- Depth is initialized and z-tested inside each 8-row center strip (`code/ksn_bounded_ring_center.inc:1-35`), then consumed by `db_finish_row` only for its center composition query (`code/ksn_depth_bands_impl.inc:3-15`). Last row waits for next strip's center IDs, so its depth must survive one strip advance (lines 49-61).
- The quarter phase starts after the complete center mask is checked and uses `winner_depth`, not center depth (lines 63-74; `code/ksn_bounded_ring_helpers.inc:55-78,87-121`). Full historical center-depth values therefore have no later rendering reader in this path.
- Full depth survives currently because the harness checks and writes the complete .f32le result after success (`harness/native_render_row.c:190-224`). It is a valuable equivalence artifact, not free production scratch.

Keep the old full-depth API and its output-lifetime contract unchanged. Introduce a separately named opt-in scratch-depth producer only; no silent contract weakening. A test-only diagnostic observer can own/reassemble the full 129,600-byte depth result, but that diagnostic build has no product depth-memory saving from the observer-owned storage.

Proposed next opt-in producer: unchanged center and quarter traversal, 8-row depth scratch, a copied last-row depth retained alongside delayed HDR, and a private diagnostic sink if complete depth evidence is needed. A depth sink can receive each finalized row before reuse, writing to an unpublished temporary artifact and committing only after adapter/source checks. If sinks/callbacks are unnecessary in production, leave them out of its ABI. There are 17 center strips and 16 delayed-row boundaries for 135 rows at height 8: copying 240 floats at each boundary adds 3,840 float copies / 15,360 copied bytes per frame. This count excludes diagnostic emission, validation and any additional initializations. New copy categories/reserves and admission pair budgets must be derived explicitly, without hiding work under unchanged counters. Any sink introduces new failure, alias, lifetime and work-accounting obligations. No externally visible display or successful output may be published early. A separate diagnostic full-depth build remains possible, but must carry its real extra memory.

### Private RGB565: 64,800 bytes

`harness/native_render_row.c:190,201,216-224` retains one complete private candidate through all success tests. Center pass writes non-target pixels, quarter pass revisits targets (`code/ksn_depth_bands_impl.inc:13-14,55,65-73`). With current two-pass order and all-or-nothing success publication, this complete writable candidate is functional retained state. Removing it safely requires an additional external candidate store, a changed pass schedule, or rerendering; simple direct display streaming exposes partial failed frames. Thus it is not the first independent proposal. Merely moving it to a display buffer or excluded caller state is not memory elimination.

### Main stack: 83,792 bytes

This is the compiler-reported caller frame, not a runtime stack watermark; it is **not heap**, and remains charged across child calls (`MEMORY_LEDGER.json:27-34,46-47,117`). `harness/native_render_row.c:99-100` alone owns a 65,536-byte payload array whose snapshot pointers remain live throughout rendering and final verification. The current front baseline reports 64,208 snapshot bytes, only 1,328 bytes below that capacity (`actual-on-001/native-front-baseline.json`); all variants would need checking before exact-capacity specialization. This array cannot disappear simply because model memory was freed.

`native_render_row.c:71-98,101-183` also contains preparation/model controls, packet lists, camera/light/input records and construction/report locals. Splitting preparation/render/report into separate non-inlined functions could shorten dead-local lifetimes and lower caller stack, but moved live snapshot/context memory must still be charged on heap/static/stack. No claim that all 83,792 is removable, or that subtracting 65,536 yields exact removable overhead: compiler stack-slot reuse/alignment determine the actual frame. Recompile and inspect full call-chain peaks before any saving claim. Model ownership/cold is released only after final snapshot extraction and context construction (line 183), not early during borrowed views.

### AA workspace: 72,512 bytes

`code/ksn_bounded_ring.h:5-23` contains target mask, HDR/identity-key reuse, union of quarter winners and center pending-HDR/IDs, source maps, parsed record views and report. Current improvement already overlays 10,560-byte center state with the 13,440-byte quarter winner side; it saves 4,800 bytes, not both union members (`MEMORY_LEDGER.json:118-129`). HDR for 1,920 pixels × 3 doubles is 46,080 bytes. Smaller strips might shrink HDR/winner buffers, but alter scheduling, scan/setup overhead and possibly callback order; they require independent proof and are not free savings. Current center-depth redesign can keep this workspace unchanged initially. Optional overlay of delayed depth into union slack is a later refinement, not included in the conservative 8,640-byte proposal.

### Shared visibility scene: 106,104 bytes

This is one shared retained scene, not three copies for direct/transport/background consumers (`MEMORY_LEDGER.json:42`; `native_render_row.c:165-181,235-238`). Current type split is owned double XYZ, indexed triangle records and BVH nodes (`private-build/visibility/visibility.c:11-15,32-47,119-138`). Current counts 1,167 vertices / 1,566 triangles / 1,023 nodes give 28,008 XYZ + 12,528 triangle + 65,472 tree + 96 host control = 106,104 bytes. Tree topology and precision are current acceleration representation, not an information-theoretic minimum; reducing or eliminating it changes traversal cost and potentially order/ties, so no automatic quality/work preservation claim.

Builder separately keeps 37,584 bytes of centroids (`visibility.c:45-47,123,137`) and the harness supplies 46,800 bytes geometry input and 35,868 bytes attributes (`native_render_row.c:114-120,142-151`). These are build-phase copies/admission/ownership, not recurring render buffers. Builder copies input before atomically replacing the output scene, frees build-only work before publication, and frees candidate on failure (`visibility.c:105-138`). Caller poison/free at `native_render_row.c:142,149` is deliberate ownership evidence. Streaming/direct-fill construction would need a new ownership contract, validation, rollback and stale-generation tests rather than skipping copies informally. No such redesign is proposed or borrowed from rejected branches here.

## Constraints for the next design gate

1. Keep snapshot bytes, normal-pair decoding, float depth arithmetic/ties, shader/camera/material inputs, quarter order, target mask, profile and sample counts unchanged. Preserve callback order initially. Test bit equality; do not promise it from inspection.
2. Freeze new scratch/sink descriptors before callbacks. Validate all exact spans, alignments, overflow, aliases against mutable context, retained scene/RO storage and reports before mutation. Do not free/rebind original admitted storage mid-call. Keep current source hashes/generations and finish verification.
3. Preserve failure meaning: core candidates may be partial on failure, reports must not claim completion; publication only after complete core, source verification and background finish. `harness/row_transport_bridge.c:98-124` can reject after the producer returns true. Existing outputs are private attempts with completion markers, not transactional multi-file publication (`FINAL_RESULT.json` publication field).
4. Synthetic first/middle/last shader/profile/composition/sink failures; all strip boundaries including 7/8,31/32,127/128,134; last-row pending state; depth +/-0, ties and invalid values; target/non-target transitions; both traversal orders; descriptor mutation and alias tests; exact full-depth stream plus RGB/mask/HDR/query/profile comparisons against the pinned baseline. Charge new depth copy/sink operations honestly; changed counters must be explained rather than hidden.
5. Rebuild all ABI consumers and measure main plus nested stack, all heap spans, largest individual allocation, phase peaks and exclusions. The 4,096-byte background child-chain cap currently has only 16 bytes margin; added wrappers must not silently exceed it.
6. Target32 layout, pointer widths/alignment, stack reserve, allocator/free-region availability, flash placement, driver/DMA buffers and latency remain unmeasured. No SDK/device work is needed or authorized by this read-only design task.

## Source hashes (SHA-256)

- `MEMORY_LEDGER.json`: `b4ffe508104c8d405797d1e7deec2b95a964cc60e921b078c41fd0a3a7ed4f67`
- `FINAL_RESULT.json`: `0de7cb6da7ffdc26d98848e8172092fb5ac4627572c485852f48dd6f8ac6c95f`
- `PRODUCT_NAMED_STACK.json`: `2a03794f06d1351c9a5c6430c7b4d1c62121d7ce9b66a5998e3f4934c2b6c276`
- `HOST_BINARY_SIZE.json`: `8478eb4794b4934a49feb9426d6d4775f6dfb27a5d0de54729307d3d8f211dc2`
- `harness/native_render_row.c`: `b32ad46b178722dee668e0e9d883cf941f2f686e599ccd18dc332e682ed6af2a`
- `harness/row_transport_bridge.c`: `fe9c600acb81d8ab78f22ce63af4a1787cc666d1cbece221c3cedc2a36f4bc6c`
- `harness/depth_band_alloc.h`: `cf0a98abe80e95789cfd16e3f08e91a478be112241ac397253b649421f6748b3`
- `code/ksn_bounded_ring.h`: `ae800f7f73e8b75d8c32ba5b3d0a77fe197f96507c58a1da473cd28297062a6c`
- `code/ksn_bounded_hdr.h`: `6c5c9165affa8938b98aef9a5e75d56f25a5cc23ad5e3c381ba98d710c7d58d7`
- `code/ksn_depth_bands_impl.inc`: `c6e708859ea0a79533548e5644f9de5a932d057029ed7f6396565c01d7fa1e7c`
- `code/ksn_bounded_ring_center.inc`: `e92d8cd6046e3a9358a03e7be2e157220964cb51f0d55b78a3c9ffbecfe5a42a`
- `code/ksn_bounded_ring_helpers.inc`: `b6ed1d058167cee8dcdddf8321c10df7c684034c4137f898cda6cbeb841115d2`
- `private-build/visibility/visibility.c`: `8eb08314bd75441c1f77699a7b56a30a71986d8112dec0cf39e56be770dd42f8`
- `actual-on-001/native-front-baseline.json`: `5fa78024ceb84a090e90a3e836190cca33aa9effba1525166fb4ec3f2049f09e`
