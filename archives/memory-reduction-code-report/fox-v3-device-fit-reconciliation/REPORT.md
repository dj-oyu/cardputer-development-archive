# Device-fit reconciliation and next proposal

Read-only review of validated AA-phase overlay. Current renderer remains unchanged; no device rendering, build, implementation or rejected operation was performed.

## Current accounting

Derived named render peak is 491,384 B: requested heap 402,584 B plus compiled main frame 83,792 B plus named child chain 5,008 B. This is not an allocator/runtime watermark. Heap comprises depth129,600; shared visibility106,104; AA72,512; RGB64,800; transport28,592; background976. Largest requested heap block is AA72,512. Main includes a live65,536-byte snapshot; moving it to heap is not a RAM saving.

Conservative other phases: visibility construction442,996; transport385,236; background351,064 B. Model/cold, caller geometry/attributes and builder centroids are build-only and already absent during rendering. Model storage segmentation improves allocation granularity but increases owner/pointer bookkeeping; do not count it as a total saving. Diagnostic full HDR storage is already excluded and cannot be removed again as a new saving.

Separate named RO is1,662,416 B, of which the exact current uint16 AgX LUT is1,647,750 B. Host const data is not automatically SRAM, nor proof of target flash placement. Old successful4a4d firmware had544,048 B factory remainder and PSRAM disabled, but did not contain this high-quality renderer. The LUT alone exceeds that old remainder by1,103,702 B before new code. Map/ELF/bin hashes are recorded in retained evidence, not locally rehashed binary artifacts. Historical free36,872/largest23,552 came from a different loaded runtime; neither those values nor linker static remainder160,548 are current hard caps or simultaneous measurements.

## One recommended next renderer step

Implement a separately named opt-in bounded center-depth producer: keep float arithmetic, eight-row order, full private RGB and all success/publication checks; retain only current8 depth rows plus the delayed previous row. Design scratch8,640 B versus129,600 B has a gross render-phase opportunity120,960 B. The old API must retain its full-depth lifetime contract. A diagnostic-only sink can reconstruct exact full depth for comparisons and must disclose its own memory; no early display publication.

This is not implemented or proven. Before acceptance: alias/descriptor/lifetime and first/middle/last failure tests, pending-row/tie/sign-zero tests, exact output/callback/counter validation against existing40 conditions, explicit new copy work and compiled stack accounting. Added pending copies are16×240 floats=15,360 bytes per frame; do not hide them in old counters. Core scratch may be partial on failure; external completion stays guarded.

Even with zero new overhead, render would370,424 B and construction442,996 B would dominate. Thus whole named peak improvement is at most48,388 B, not120,960 B; largest AA block remains72,512. This alone cannot establish device fit. Flash remains a separate blocker. Lossless blocked LUT storage is a later evidence-gathering option, not an approved ratio/quality/fit claim and not a profile approximation. Changing partitions or removing product features is not part of this proposal.

## Evidence and limits

RUNTIME.md and RO_DEVICE.md contain source lines/hashes and classify all major items. SUMMARY.json is the machine-readable arithmetic. Independent REVIEW.json checks the plan only, not a new implementation. No new renderer/source/reference/model/profile changes. No current target-linked layout, current simultaneous runtime heap/stack, allocator/DMA placement or timing evidence exists here; retain those gaps explicitly.
