# Exact indexed BVH bounds: completed validation

All42 accepted diagnostic executions pass independent retained-output verification:40 full-depth HDR conditions and2 no-depth-capture HDR canaries. All208 raw comparisons,378 strict numeric report comparisons and80 forward/reverse checks pass. Rendering outputs and all ray, node, triangle, shader and work counters remain exact. The only permitted non-timing report change is visibilitySceneBytes106104→69276. Caller geometry temporary reporting remains46800.

Original model, reference and coefficients are unchanged. There is no measured image-quality change and no new quality-improvement claim. Full-depth equality covers40 conditions; only2 no-depth canaries were executed. The pure production binary without HDR was compiled, not executed.

## Compiled and accounted storage

Named lifecycle peak373552→336724 bytes, saving36828. The largest named allocation remains the72512-byte AA workspace. Construction is312580, conversion301544 and render336724. The constructor named stack is2464, up32 from the baseline. Main83760, renderer4944 and background4016/4096 remain unchanged.

These numbers are requested storage and compiler named-stack accounting, not observed process RAM or target-device fit. Retained older scenes, allocator metadata, fragmentation, unnamed library/runtime stacks and target placement are additional or excluded as documented in MEMORY_LEDGER.json. Diagnostic storage remains separately charged.

## Implementation and cost

The original full-double BVH builder remains unchanged. After centroid release, a sixth allocation holds compact nodes; every final bound is matched to exact bits in the scene-owned coordinates before atomic publication. The original tree is freed before publication. Initial per-merge and local-accumulation variants failed signed-zero equivalence and were rejected; original-builder-first conversion resolves those same-flags test failures without normalizing zeros.

Final nodes contain six16-bit coordinate witnesses and four unchanged32-bit topology fields. The conversion scan and traversal indirection add work. Physical ray/work counters do not imply identical CPU instructions. Six allocation-failure sites and exact ownership/rollback are tested. The generic temporary formula covers both construction and conversion, including the one-triangle transition edge case.

## Actual observations and limits

Maximum observed combined producer work478224 remains below unchanged637599. Diagnostic elapsed times and process RSS are recorded separately in FINAL_RESULT.json. The same40 diagnostic cases took749.36s versus historical702.41s in separate host runs; this is descriptive and does not establish causation. They neither measure pure-product RAM nor justify a speedup claim. O0/O2, ASan/UBSan, exact canonical bounds, zero-sign permutations, ownership and allocation tests pass. LeakSanitizer was not available in this host's tracing environment; explicit tracked balances finish at zero.

All242 frozen preactual files remain unchanged. Source freeze: f94d00f94de91574a42d499c4fc59d22a3ebb43ec87e9767e91a736e2c4c321a. Independent final review: 6fe8fe65d4912832caa7a4437d31e8cd1890bde197572b91a6627a72ba521a2e.

## Delivery scope

The final private backup contains changed code/tests and numeric aggregate/frame reports only. Raw rendered arrays, snapshots, geometry/model assets, binaries, generated LUT data and per-frame command/input records are excluded. The generic10-file public candidate is local and separately reviewed; no new publication or push is claimed. No device, SDK or firmware integration occurred.
