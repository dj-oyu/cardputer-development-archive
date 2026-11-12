# AA workspace lifetime audit

Read-only inspection of `fox-v3-segmented-model-arena`, 2026-11-04. No render, builds, product edits, device operations, publication, or excluded trees used.

## Recommended next change

Keep one owned contiguous workspace, but overlay the center ID ring with quarter-pass winner depth. Replace the existing union's delayed-row member with an anonymous center-phase struct containing `double delayed_center_hdr[240][3]` followed by `uint16_t center_id[10*240]`; remove the separate leading center_id array. Keep the other union arm (winner_record, winner_face, winner_depth) unchanged. This is a proposed implementation, not a measured result.

- Quarter arm: 3,840 B records + 1,920 B faces + 7,680 B depth = 13,440 B.
- Center arm: 5,760 B delayed HDR + 4,800 B IDs = 10,560 B.
- Delayed HDR and center IDs remain disjoint and simultaneously live. IDs occupy the beginning of storage later used by winner_depth. Never overlay IDs with delayed HDR itself.
- Existing 77,312 B workspace should become 72,512 B on the pinned 64-bit ABI, saving 4,800 B, with no separate allocations, pointers, or extra overlap pairs.
- Conditional on unchanged compiled stacks, named render peak becomes 491,384 B (496,184 minus 4,800). Other phase peaks remain below render. Largest named heap allocation becomes 72,512 B instead of 77,312 B, still the AA workspace. The 83,792 B main stack is separately accounted and is not a heap allocation. This is not a target/device-fit claim.

## Lifetime evidence

`code/ksn_bounded_ring.h:5-20` declares these live storage groups:

- center_id: 4,800 B, only center strips and neighbor classification.
- targets: 4,050 B, initialized before centers, populated during centers, then read through quarter passes and exported after success. Cannot overlay with quarter winners/HDR.
- reuse: 46,080 B HDR / 9,920 B identity-key union. Keys are used only by ring_aa_bind before center shading. HDR holds an 8-row strip in center processing, then a 4-sample sum for each quarter strip.
- winner union: 13,440 B, currently also stores the 5,760 B delayed center HDR. Winner arrays are unused until all center rows finish.
- source: 7,040 B, offsets: 110 B, records, record_count, and report remain in use across phases; report and targets are consumed after successful return.

`code/ksn_depth_bands_impl.inc:49-63` completes every center row, including pending rows and final tail, before checking targets and the target-mask hash. `:65-74` then starts quarter processing. `code/ksn_bounded_ring_impl.inc:76-92` has the same phase barrier for contiguous depth. Both finish-row helpers are the only consumers of center_id beyond the center writer (`code/ksn_bounded_ring_center.inc:55`). `ring_sc_mask` reads targets only. `ring_aa_geometry` initializes every active winner record/face/depth before quarter consumption (`code/ksn_bounded_ring_helpers.inc:55-58`), so no dead ID bytes can enter quarter results. No harness consumer of final center_id was found.

Preserve the ten-row ring: eight current rows plus previous neighbor rows are needed while finishing the delayed row. This proposal changes storage placement, not row scheduling, numerical operations, source-ID representation, callbacks, or work counters.

## Admission, guards, and callbacks

The bridge validates one complete workspace span (`harness/row_transport_bridge.c:77-90`); depth-band core admission likewise validates one span (`code/ksn_depth_bands_impl.inc:28-36`). Retain this ownership and complete-range alias exclusion. The change adds no external span, descriptor snapshot, or nested call, so admission counts should stay unchanged (parent reports 985/1,024 world-ON budget). Guard margin is only 39; splitting workspace into multiple externally owned spans instead would require new pairwise accounting and callback-safe frozen descriptors, potentially exhausting that margin. A segmentation-only change reduces largest block, not payload RAM, and adds descriptor/allocator overhead.

Opaque shader, resolver and profile callbacks continue under current immutable/live input contracts. The proposed overlay creates no new rebinding surface. All consumers must be recompiled because offsets/sizeof change. Recheck compiler stack reports rather than assuming equality: main 83,792 B, renderer 5,008 B, background 4,080/4,096 B are baseline values, not new measurements.

## Late failure and publication protection

Core rendering is NOT transactional on supplied RGB/depth. Its documented contract says failure leaves private candidates partial (`code/ksn_bounded_hdr.h:6-9`). Centers and quarter rows write candidates before later callbacks/checks can fail. Do not reclaim, overlay, or directly publish private RGB (64,800 B) or depth (129,600 B) to save RAM.

`harness/native_render_row.c:190-205` allocates private RGB, depth bands, workspace and invokes rendering. Bridge finishing can fail after all pixel generation, during source re-hashing or background completion (`harness/row_transport_bridge.c:102-129`). Native checks preflight and shade counts afterward (`:207-208`), then rejects failure (`:216`) before pixel/depth artifact creation (`:223-224`). Diagnostics and snapshot files may exist earlier, and multiple file writes are not atomic. Preserve private-attempt/completion-marker publication semantics; a successful core flag alone is insufficient.

## Validation required before accepting implementation

Add static assertions for 72,512 B, delayed-row/winner-record shared start, center IDs at winner_depth offset, center-arm extent within union, and alignment. Preserve existing tests' legacy workspace size expectations, updating only new ring size checks. Run synthetic exact order/RGB/depth/mask/report cases including ring wraps, delayed rows 7/15, seven-row tail, forward/reverse, max source ID, and repeated renders with poisoned workspace. Run admission unchanged-output tests plus first/middle/final shader/profile/resolver failures and post-render verification failures. Re-measure named stack and guard accounting; verify late failures do not publish candidates. Actual byte-exact rendering needs separate authorization.
