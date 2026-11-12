# Independent retained-output review

Status: PASS_RETAINED_ACTUAL40.

Scope: the new indexed floor-world integration only. This is not a review or retry of the stopped owned-ray-context/paged operation. The reviewer ran no renderer, compiler, or scorer, and changed no frozen code, baseline, model, reference, or existing artifact. Only this aggregate review package was saved.

## Retained outputs

- OFF20 and ON20 are complete. Independently hashed all 480 files in the per-run completion manifests and the final output index. The index contains exactly those 480 entries.
- All 40 raw HDR and AgX RGB565 outputs are byte-identical to the completed floor-world composition for the corresponding arm, view, and scenario. All 40 depth, target-mask and snapshot outputs equal the corresponding indexed baseline order. OFF20 RGB565 also equals indexed RGB565 directly.
- Within each arm, all ten forward/reverse pairs have exactly equal HDR, RGB565, depth and target-mask bytes. Snapshots were compared against the corresponding indexed order; no forward/reverse snapshot identity claim is made.
- Checked 200 runtime report pairs. Every value is unchanged except the declared seven timing fields, context 576→608 B, ON additive world traversal, ON +24 span pairs, and the final composition's clamp count.
- The runtime model argument, all later command arguments, and existing HONE environment values equal the indexed baseline. HONE_FLOOR_WORLD selects the arm. Runtime input hashes, gate hash and binary hash match. No failure marker, pending stdout, or nonempty stderr remains in either actual output directory.

## Accounting

- Each ON run uses its own-order indexed shader/hit counts. World work is exactly 64 × shaderCalls + 6272 × eligibleFloorHits, and queries/rays are exactly 16 × eligibleFloorHits. Misses plus blocked-character plus blocked-floor counts equal queries. Blocked-floor count is zero in these fixed scenes.
- Each total transport counter minus its own-order indexed baseline equals the corresponding world ledger counter. Forward world ledgers exactly match the completed standalone experiment. Reverse ledgers satisfy their own-order identities; they are not falsely equated with forward workloads.
- Maximum total transport: 9,134,101 rays, 461,923,659 nodes, 144,185,556 triangle tests. Caps remain 20,000,000 / 800,000,000 / 300,000,000.
- Maximum added world queries: 1,146,672. Maximum added world node visits: 35,212,432. Maximum added world triangle tests: 7,012,260. Maximum separate world semantic work: 450,583,488, below the unchanged 450,598,848 bound.
- Row admission stays at 276 span pairs OFF and 300 ON, an addition of one span and 24 pairs. Guard reservation remains 1,024 and producer cap remains 637,599. Maximum observed producer units are 441,776. The grouped guard-dispatch interpretation and opaque existing predicate-kernel caveat remain as documented in the prerequisite review.
- Independently recomputed the final operation-cost rows, maxima and descriptive timing sums. Timings are not a speed benchmark.

## Sources, memory and score reuse

- Source freeze remains 92f0e104b106c746adf33212f9f619acb12b3bd3d7a9ede8651ed76b0f1a6412. All 91 source entries and 121 baseline pins match, as do both compiled builds and their dependency hashes. The four transport files still equal the completed standalone floor-world files; indexed visibility remains byte-identical.
- Product named render memory is 628,192 B excluding named RO and 2,290,608 B including named RO. Diagnostic totals are 1,405,816 B and 3,068,232 B. The diagnostic difference is a separate 777,600 B HDR buffer and 24 B control. Initialization writes 259,200 B; capture and dump each write 777,600 B. Every actual observer report shows 32,400 samples, complete and no shading feedback.
- Rechecked named stack hashes and summed every listed chain: background 4,048 B under 4,096, renderer 4,976 B under 8,192, main 83,616 B separately. The product binary contains no row_hdr observer symbols.
- All 952 original formal analysis input pins remain unchanged. Since final image bytes are exact, existing formal scores and the earlier limited independent score checks carry over. No fresh score calculation was needed or performed.

## Limits

All 40 actual frames were produced by the diagnostic build. Observer-free product equality has the completed independent synthetic parity evidence, not 40 additional product renders. Named memory excludes libc/libm, allocator metadata/fragmentation, executable and unnamed read-only constants, test-only buffers and unrelated caller state. No whole-host/device fit, target timing, FPS, CPU-instruction bound, combined legacy8M admission, universal image-quality acceptance, or comprehensive security/ownership certification is claimed.

This package contains code and aggregate counters only, with no raw render buffers, reference images or geometry. The verifier initially corrected two reviewer-only fixture assumptions before its successful run: the standalone transport path is capture/transport, and the retained byte mask is 32,400 B rather than its 4,050 B internal bitset. No candidate defect or candidate change resulted.

Reproduce read-only: python verify_retained_outputs.py. It prints aggregate JSON to stdout and invokes only nm for a binary symbol inspection; it does not render or write inputs.

Checks in the final successful run: 4068 SHA-256 checks over 1921 distinct files, 306 direct byte comparisons and 200 report comparisons.
