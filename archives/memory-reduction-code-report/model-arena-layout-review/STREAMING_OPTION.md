# Static construction streaming option (read-only design review)

## Decision

One-mesh work reuse is computationally plausible for an explicit, immutable, mesh-only construction/export API. It is **not** a compatible replacement behind today's instance/view API, and it is more invasive than full-arena segmentation if the only objective is reducing the largest allocation below 81,356 bytes. Do not implement a shared work pointer under existing `work()` and call it equivalent.

The tempting budget `states 1320 + maximum mesh slot 1648 = 2968` omits hierarchy state. `model_node_state` contains opacity, offset, color, enabled and world_enabled, **not world transforms** (model C 8–12). Every world transform is held in its node's work prefix; evaluation reads a parent's 48-byte matrix from that parent's slot (584–588). A straightforward static exporter retains 55 × 48 = 2640 bytes of matrices in addition to the 1320-byte state array and one 1648-byte mesh slot: **5608 bytes**, plus control, alignment, ownership/alias descriptors, traversal/geometry-offset bookkeeping and existing view scratch. This is a design subtotal, not a measured allocation or peak. General dynamic behavior also needs independent local poses (55 × 36 = 1980 bytes) or equivalent storage; immutable construction can read cold poses directly.

The 1320 state subtotal is the existing host type, not a minimal redesigned static state and not target-32 ABI proof. Avoid optimistically deleting all noncurrent work without either storing needed ancestor transforms or charging for deterministic recomputation. A special root-only hierarchy optimization requires explicit validated topology admission, not assumed properties of the current asset.

## Exact inspected sources

All paths below are relative to `fox-v3-indexed-transport-input/`:

- `private-build/product/main/ayatsuri/ayatsuri_model.c`: SHA256 `5d65fc53ff2f1175e8a44829c4acf07a23e3601f773486454f167dcbd0c194f0`.
- `private-build/product/main/ayatsuri/ayatsuri_model.h`: SHA256 `de593d84b5591804aa5252dc05ba55d6beb14b86f88e499db89f0961524f7b27`.
- `harness/native_render_row.c`: SHA256 `5768f03a31f366f91fc0d14b2941663a8659860c33aa0cc3af4ee1205fd065ab`.
- `MEMORY_LEDGER.json`: SHA256 `b8a5a2aaf2ee49dbfd4ff8be9fb7780602ad0f23ef373d618787a5c8d12a7381`.
- `build-adapter/ayatsuri_model.su`: SHA256 `1ed4bc5e1b7fff84e8788d5b94e434f9ab721e648382cc2c84aa0bff7fde4507`.
- `build-adapter/native_render_row.su`: SHA256 `5c0904698f6e03971c6caa3fd771367a40f00f7e03d9f853d79a46832163b00d`.

`FINAL_RESULT.json` reports fixed40 completion and named peak 496152. The memory ledger retains preactual status text; it supplies phase accounting, not independent actual-run proof. Prior `fox-v3-model-memory-audit/REPORT.md` supplies host decomposition: 55 states 1320; group84 +54 mesh slots79952 = work80036; full81356; cold47708. This review did not rerun or alter that measurement.

## Contract barriers

1. **Simultaneous borrowed packets are an existing promise.** Header 71–73, 83–85 and 97–110 permit patch/depth borrows until mutation/evaluation/dispose. Reading a second node view is not an invalidation event. `next()` returns a slot pointer (C596–614). A shared slot overwritten during another read silently violates this even if the particular harness copies promptly. Pixel vertices and side bits are owned, but patch/depth are not. World view is entirely owned (H115–126).
2. **Mutation epoch cannot identify scratch ownership.** H108–110 explicitly says it is not an evaluation-generation token. A new stream must specify current node, scratch generation, invalidation and immediate copy (or callback-only access), rather than reusing epoch checks to pretend stale pointers are valid.
3. **Validation/alias surface changes.** Existing init checks a whole contiguous arena (C235–259); targets and views reject aliases against that span (266–294, 650–657, 699–706). New state/matrix/scratch/output spans must all be validated for size, alignment, overlap, wraparound, lifetime and owner/reentrancy. Reusing a fake small arena with out-of-range offsets is not a solution.
4. **Static is not the product contract.** Existing targets/read_pose/evaluate support pose and visibility mutation and same-camera/light cached evaluation (C266–311, 562–594). The actual harness makes one init/configure/evaluate and no targets call (harness70–93), so a separately gated one-shot exporter can be narrow without narrowing those APIs. It should explicitly reject unsupported kinds/holes and unsupported mutable usage. Mesh-only lighting already rejects non-group/non-mesh kinds (C219–232), but that is not a streaming lifetime gate.

## Actual construction and a candidate sequence

Current harness:

- Allocate/read cold model and full arena, evaluate everything (67–94).
- Start owned snapshot; `next()` gathers camera-selected logical packet IDs ascending (96–100).
- Count full source world geometry, allocate attributes and xyz/tri arrays, then fetch both world and pixel views for each mesh in original node order (106–129). Exact `memcmp` between world and raw pixel world triples is enforced at120. Geometry indices use original source faces, not camera-selected/reversed faces.
- Build visibility and poison/free xyz/tri (138–139). Build transport and poison/free attributes (140–148).
- Fetch pixel views again and append snapshot in forward/reverse packet order, reversing selected triangle order and side bits for reverse (151–159).
- Bind snapshot, build background; only then dispose/poison/free cold model and arena (162–180).

A possible **new adapter**, not a claim of existing API compatibility:

1. Validate the immutable model and camera/light with existing mathematical rules. Preflight exact geometry capacities and original node-order offsets from validated cold descriptors. Preserve group/mesh hierarchy and enabled inheritance. Compute transforms in parent-before-child order using the exact existing transform routine and binary32 matrix storage; keep all matrices. Keep camera basis and light preparation arithmetic unchanged (C573–581).
2. Visit meshes in desired packet order, load that node's exact matrix/pose prefix into one work slot, execute the unchanged mesh arithmetic, immediately derive both world and pixel owned views, enforce existing byte parity, and fill xyz/attribute arrays at precomputed **original-node-order offsets**. Append only selected visible/nonempty packets with the current reverse triangle/side-bit operation. Never reverse geometry or material array ordering. Empty projected selections still contribute source occluders. The current harness attempts world views for every mesh and fails on inherited-hidden meshes; a replacement must preserve that failure or explicitly reject hidden meshes in its admission gate, not silently omit them. Existing full evaluation still generates packets for disabled nodes before iteration filters them (C588–592); do not skip their validation merely because they are hidden. This step needs a new selected-mesh evaluator/export surface: today's full instance evaluator cannot do it safely.
3. Complete all node work, validate final counts/packet stream, seal the private snapshot, then dispose the stream and poison/free all model inputs before visibility/transport/background builds. Builders can continue in their existing order; snapshot binding remains after visibility exists.

Potential advantage: one mesh shading/projection pass, one extraction, and one snapshot copy per mesh. Potential blocker: reverse evaluation changes order of mesh failures and work counters from current evaluation; precomputing all transforms first also changes failure-stage sequencing. If exact failure identity/counter order is mandatory, use a second deterministic packet pass or a separate validated staging plan and charge its cost. An O(N²) geometry-offset scan could avoid an offset array but increases operations; prefer bounded explicit offsets and account for them.

A simpler two-pass stream evaluates/extracts in forward order, then reevaluates in packet append order. This avoids scatter bookkeeping but doubles mesh packet generation and physical-light samples. It is not a memory-only change in measured operation counts/timing. Do not claim unchanged `geometry_updates`, `projection_updates`, `shade_updates`, or eval counters without specifying separate exporter accounting. Public existing instance statistics should remain unchanged by keeping the old API untouched.

## Arithmetic and equality requirements

Preserve float parent/result matrices and the exact arithmetic used by C584–588. Do not switch the hierarchy cache to doubles, reconstruct from snapshot coordinates, bake altered assets, or change transforms to fit geometry. Both raw world pathways use the same double expression against float matrices and original float source vertices (C686 and718); preserve the operation order, no contraction and no excess precision (H10–13). Preserve inverse-transpose, asymmetric front/back SNORM rounding, determinant treatment, source indices and selection (C496–558, 665–724). Physical light evaluation occurs during mesh generation (486–538), even though pixel raw views export material albedos: omitting it changes behavior/counters and possible failures.

## Memory, stack and failure accounting

- Full segmentation retains all 81356 payload bytes plus span descriptors/padding but preserves random-access borrows and single evaluation. Streaming can remove roughly 75748 bytes of that payload using the illustrative 5608 subtotal, but that number excludes new metadata and is **not a lifecycle-peak reduction**.
- Existing caller geometry temporary is46800; indexed transport attributes35868; together82668. They still exist during extraction. Snapshot payload65536 is on main stack, not an extra heap reduction. A stream does not eliminate any of these owned outputs.
- Early disposal alone removes cold47708 + full arena81356 =129064 from later build phases. Current conservative visibility441612 would become312548 before newly introduced stack/metadata; transport383852 becomes254788; background349680 becomes220616. These are phase substitutions, not measured results, and extraction needs a new ledger row. Streaming reduces source overlap during extraction further, but cannot subtract its full savings again from builds after source disposal.
- Render already occurs after model disposal. Existing named render peak496152 remains unless independent render storage changes. Largest render allocation77312 remains; therefore removing the81356 construction arena only moves global largest named allocation down to at least77312, not1648 or2640.
- Existing main frame83760 includes payload and local views. Existing `.su` records evaluate1152, mesh_packet1520, pixel_view2384, world_view1264. Moving 5608 or more scratch onto `main` can permanently inflate its frame and the render-phase ledger, erasing some benefit or increasing the current peak. Use explicit separate-lifetime owned spans or a non-inlined construction helper, then remeasure compiled main and call chains. A callback invoked inside mesh_packet can overlap its frame with append/view work; do not sum only the old maximum or assume lexical scopes reclaim stack.
- Current evaluation marks instance unevaluated before work and only publishes after all nodes succeed (C572–594); view result assignment occurs at end (694,725). A streaming visitor must not publish partially appended snapshots or partially filled arrays as success. Use private candidate outputs, commit only after all nodes/capacities succeed, reject reentrancy, and poison/free every owned span on failure. Callback failure must invalidate/discard candidate output and active borrows. No rollback to a prior cached frame is promised by a new one-shot API; preserve prior externally visible files/frames separately.
- Allocation-failure tests, late-node failure, alias/size/alignment/wraparound tests, hidden-parent and nested hierarchy, reflection, empty packet selection, reverse ordering, hole rejection, stale borrow rejection, and all fixed40 snapshot/world/material/raw/raster comparisons are required before any equivalence claim. Main/call-chain stack, allocator counts, zero-fill/copy bytes and shading work need fresh measurements. No tests were run here.

## Recommendation

For the immediate maximum-block objective, full storage segmentation is the narrower semantics-preserving candidate. For a larger construction-memory reduction, investigate a **separate opt-in static owned-export API** with explicit scratch lifetime, matrix cache, output ownership and failure semantics. Do not promise a2968-byte complete replacement or put streaming beneath the current borrowed-view interface. Early snapshot/extraction reordering is independently useful but does not lower the current render peak or largest original model block.

No code edits, renders, public writes, device/SDK actions or model-asset changes were performed. No owned-context or paged-BVH source was read or used.
