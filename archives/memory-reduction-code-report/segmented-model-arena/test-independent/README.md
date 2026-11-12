# Independent synthetic segmented-arena checks

Run `python test-independent/run.py` from the candidate directory (or invoke by absolute path). The runner compiles this independent C fixture generator and the candidate model/visibility/physical-light implementation directly. It never opens original assets, launches a renderer, executes the copied sidedness runner, or touches a device. All test artifacts are confined to this directory.

Six configurations: O2 and O2+ASan/UBSan, each at 5, 55, and 256 nodes. `RESULTS.json` records exact commands, assertion counts, and source/header hashes. The 55-node input is synthetic, not the product model or a product-memory measurement.

## Coverage

- Hand-written little-endian AYNM fixtures passed through the public loader: mixed group/ellipse/masked-blend/single-sided mesh/double-sided mesh, plus group/mesh-only fixtures. Section8 masked blend adds exactly24 bytes (448 total).
- Legacy contiguous versus segmented API parity for packet storage/material bytes, owned world geometry, owned pixel fields, patch/depth, node kind, pose, mutation epoch and every stats counter. Initial copy-byte count and cache/recompute stage counts have independent expected-value assertions.
- Same-camera cache reuse, changed camera, changed light, failed NaN evaluation and recovery; target no-op/change/last-node-invalid batch; color/opacity changes for ellipse; mesh-only linear light and independently constructed three-disk scene enable/no-op/disable. Epoch stays mutation-only.
- Simultaneous ordinary and sided borrowed views keep distinct stable patch/depth addresses and byte content while reading other node views and packets. Caller source descriptors are poisoned immediately after init; evaluation never reads them again.
- Invalid owner/generation/busy disposal; post-dispose access refusal; reinit at generation8 and stale-generation7 refusal. Init outputs start with byte0xA5, including the new flag, so legacy init must initialize its own mode.
- 40 base init rejection cases: null/short/misaligned/count/wrapping spans, metadata/node/output/descriptor/model/cold aliases, zero and257 node counts. Every rejected call compares the complete fixture, including all metadata, slots, output, cold/model and descriptors, byte-for-byte with the pre-call image.
- At5 and55 nodes,9 additional rejection variations per node: short, misalignment, metadata/model/cold/output/descriptor/other-node aliases and address wrap. A valid used span with SIZE_MAX advertised excess capacity succeeds, matching documented used-byte semantics.
- All output accessors and all four target-array guards exercised at first node, last node, metadata base and final copied pointer-table entry.
- Allocation-owner injection at every allocation, including final node:7,57 and258 failure points. Every successful allocation is tracked and freed exactly once, live balance is zero, output is unchanged, and a pre-existing unrelated live instance plus all its memory stays unchanged. Owner/gen initialization rejection after full allocation unwinds too. Success verifies payload/control accounting, disposes before release, poisons the instance pointer table, and proves cleanup uses the independent owner table. Repeat release after NULL is harmless.

## Limits

This proves candidate contiguous/segmented parity on synthetic inputs, not historical binary compatibility, actual-frame identity, target32 layout, device fit, or asset-specific capacity. No original existing test is silently treated as run. LSan is disabled for this environment; allocator live-balance assertions are a bounded helper ownership check, not a general process leak claim. Arbitrary invalid caller pointers are not made safe by C: wrapped spans are tested only where API validation promises to reject them before dereference. Allocation failure promises output/existing-instance preservation and cleanup, not rollback of temporary allocation bytes that cleanup poisons.
