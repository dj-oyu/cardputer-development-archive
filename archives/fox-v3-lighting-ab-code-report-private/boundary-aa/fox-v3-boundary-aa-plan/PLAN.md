# Fixed center-detected geometry-selected true four-sample AA: preimplementation plan

No implementation/rendering is authorized by this file alone: parent/reviewer contract approval precedes changes. Frozen actual-lid8 current geometry, lights, material generations, normal-pair codec and all physical/transport/display math remain unchanged. RGB, reference images/masks/errors are not inputs to target selection. Only owned projected geometry, final center depth winner and source-object identity are used. This is NOT complete geometric-edge AA: all-center-miss thin features and overlapping boundaries inside the same source object can be missed.

## Fixed target rule

Frame240×135. Center object token is actual source object ID0..91 at the final center depth winner, or uint16 sentinel65535 for nohit. Source identity is compiled origin identity, not packet/node/partition identity (partitions can merge objects). Frame-exterior neighbors are also65535. A pixel is selected if ANY of its four center neighbors (up,left,right,down) has a different token. Select both covered and nohit sides, only inside the frame. Do not select again after AA. No face-interior-edge expansion, dilation, error ranking, adaptive threshold, fallback subset or fit.

Geometry-only preliminary counts: front2385 targets =1919 covered+466 nohit; oblique2391=1851+540. Non-target30015/30009. Independent uint8 row-major target masks hash front eebd4a3432074c6e6d84cf7e6a03b34c7dbd9d4309bd3fbd003b7caa47eeb4f6, oblique a7b9fb46c60810bb1047503c80b15e7e0cc84d546faadc3f8a2af988bf8550a0. Current frame edges are nohit, but sentinel rule is explicit for fixtures. Bounds/targets must be reproduced at runtime from owned geometry; precomputed selection is only a control, not shader input.

## New winner-only algorithm, separate from legacy

OFF uses the unchanged existing renderer. ON first runs the same full center renderer including every successful intermediate depth-winner shader invocation. An observational hook writes source identity whenever that same depth winner changes; it does not change shading/math or add a second center geometry pass. Preserve complete center RGB565/depth. Once the center map is complete, freeze the target bitset.

Then process8-row bands sequentially. For each band and fixed offset order(-.25,-.25),(+.25,-.25),(-.25,+.25),(+.25,+.25), traverse every owned record/triangle. Bbox center indices are ceil(min−offset)..floor(max−offset), frame/band clipped. Scan and charge every bbox point, including non-target mask tests. Evaluate true floating sample positions only at targets using the same canonical edge/top-left rule. Float-depth comparison/tie rule stays the same: strictly closer wins; exact ties keep the first face in that traversal. A separate double-coordinate helper leaves OFF integer arithmetic unchanged. Do not translate/requantize snapshot vertices.

Resolve all sample geometry first, with NO shader call on intermediate winners. Store an owned-snapshot record offset plus face index and sample depth. After the band geometry pass, invoke the existing shader exactly once per covered selected sample, using reconstructed actual barycentric worldP/front-or-back SNORM/rho. Nohit samples are black and invoke no shader. Sequentially accumulate four linear HDR samples, divide by4 including nohits, then the existing sRGB float encode/lroundf565 once. Non-target RGB565 bytes remain the center output; depth output remains center depth everywhere. AA support is separate sample coverage, not a geometry repair or new source mask.

Bindings, snapshot, scene and budgets stay alive after the existing caller-data poison/free boundary. Winner references may not point into freed model/arena. A pinned source-identity lookup binds node+rawtriangle to compiler origins and is checked against owned snapshot indices; it must not confuse merged parts with one source object. Reject unmapped/ambiguous cases. Snapshot capacity stays65536, actual wire64208. No side/color/normal/codec precision changes.

## Work accounting: explicitly new ledger, not an old49 discount

The simplest extension reserving old49 units for EVERY selected sample triangle-bbox candidate is infeasible for front:8,199,728>8M (oblique7,670,414). Preserve that finding. Do not call the tighter algorithm the same accounting or silently replace historical counters.

New ON-only ledger starts with the ENTIRE unchanged legacy center reservation (front2,750,272, oblique2,641,786). New work stages are charged cumulatively, with upfront conservative reservation and matching measured counters. Work units are explicit bounded renderer stages, not CPU instructions or timing-equivalent cycles. The old center49 meaning is not retrospectively changed.

- Center identity initialization1/pixel, updates1 per successful center depth update (upper bound center bbox points).
- Target bitset clear1/byte and four neighbor comparisons/pixel.
- Band HDR initialization3/pixel, sample depth/winner clear2/pixel/sample, final-winner enumeration1/pixel/sample.
- Each record visit1; each triangle setup16 stages per band/sample, covering loop/decode indices/side/three vertices/area/bbox/edge construction. This includes all17bands×4samples×1564triangles, not only triangles intersecting target pixels.
- Every bbox visit plus mask lookup2 units, including skipped non-targets.
- Each target candidate12 stages, conservatively covering three edges, coverage, barycentric/depth computation/comparison and winner writes. Charge all candidates even if outside/occluded.
- Each final covered target sample64 stages:48 existing disk quadrature stages plus16 for vertex fetch/reinterpolation/palette/finite validation/shader-dispatch and HDR accumulation. This reservation applies once because intermediate shader calls are prohibited.
- Final target pixel8 stages for average/encode/write and sample-support record.

Upper reservation is front7,520,714, oblique7,295,782 of8,000,000, using all selected samples as hits, all candidate worst branches, and repeated band setup. winner-only-ledger.json specifies every category. Implementation must not omit source-table build/validation, counter guard or new traversal costs: assign them explicit additional reservation before admission, and reject if this consumes remaining headroom. Actual measured category counters must not exceed their reserved bounds. No subset reduction after failure.

This new ledger requires explicit contract review; it is not claimed identical to old bbox49. Old fallback estimate remains in estimate.json. Source identity validation receives a separate32,768-stage upper reservation. A frozen generated table stores sorted local triangle indices plus sourceID (5bytes×1564) and55 uint16 part offsets:7,930bytes RO. Runtime verifies each owned packet face matches that exact local triangle identity and node/source mapping, binds the table generation/fingerprint to the existing owned scene/snapshot, and copies only validated IDs/record offsets into owned workspace. No quadratic face matching, mutable compiler metadata or model pointer survives caller-data disposal. Proposed validation bound is16stages/triangle +16/record +table clear/offset initialization (under32,768); implementation counters must confirm it. Preliminary actual packet/source face index order is identical for both views; do not silently reorder a mismatching runtime input.

## Transport, scratch, ownership and failure

Use one direct budget1M rays/100M nodes/50M triangles and one transport budget20M/800M/300M for the entire center+four-sample frame; never reset per band, sample or condition within a frame. Existing scene/BVH caps remain unchanged. Extra final sample calls≤9540/9564; direct rays≤457920/459072 and transport rays≤9,921,600/9,946,560 (1040 each). Baseline center plus these ray upper bounds fits ray caps, but loose BVH node/triangle worst bounds do NOT prove completion. Actual bounded execution is required; partial/failure is never scored. All ten conditions and both orders must be checked, not inferred from baseline.

Provisional bounded ON workspace (no full HDR-frame arrays): center uint16 ID64800B; target bitset4050B;8-row RGB-double sum46080B; sample record-offset uint16+face uint8 arrays3840+1920B; sample float-depth7680B; owned source-map54×64 plus sentinel-row7040B; record offsets110B. Sum135520B before alignment/controls/temporary decoded fields. Commit workspace cap147456B (144KiB), then assert actual sizeof and high-water use before proceeding. A maximum8192B additional immutable identity table is separately counted/pinned. Full-frame retained RGB56564800B and center float-depth129600B are caller-owned ON outputs,194400B, additional to band-only legacy streaming; do not omit them from memory claims. ON workspace+retained outputs≤341856B plus≤8192B RO. These are diagnostic resource bounds, not a device-memory-fit assertion. Snapshot64208, vis438496 and transport100784 owned bytes remain separate/unraised; original model/arena are freed before rendering. No new owned snapshot content is smuggled beyond65536.

Whole-frame output is private temporary data until all center/samples and quotas succeed. Publish completed raw/manifest only after success; retain failed counters separately and do not reset/retry to turn a partial into a pass. OFF outputs must byte-match old all10/order controls. Test exact depth ties/top-left shared edges, first-winner retention and reverse traversal, center identity neutrality, final-only versus intermediate shading final RGB, nohit black denominator, clipped frame boundary, non-target byte identity, malformed lookup, and failures/budget exhaustion.

## Gates and outcomes

1. Freeze target/capacity/ledger contract with parent/reviewer; independent geometry-only masks/counts.
2. If approved, isolated opt-in implementation and source diff, lifecycle/negative fixtures, actual memory-size and admission bounds. OFF untouched and exact controls first.
3. ON full10conditions×bothorders actual C with one cumulative frame budget; all actual winners/coverage/linear-average/precision proof. Failure means incomplete/unscored, not lowered targets.
4. Fixed v3 metrics/uncertainty/fullFG/FPFN/support and non-target identities; no new reference threshold. Increased sample coverage is not changed geometry.
5. CPU after independent heavy finishes, separate functional timing, memory/RO/stack accounting, code/report-only allowlist. No default/product deployment, publication/PR/device/original edits.
