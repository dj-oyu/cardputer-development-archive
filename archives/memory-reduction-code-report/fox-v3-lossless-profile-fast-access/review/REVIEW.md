# Independent fast-access review

Correctness gate PASS for all three frozen stateless candidates. Timing results are pending separate review.

- Root PLAN was read before reviewer tests. Finite candidates are bounded byte-window reads, per-call distinct-block gather, and their combination. No persistent cache exists. Fixed 1/4-block LRU figures are modeled reference counts, not executable cache performance.
- All 823,875 uint16 values recovered exactly with fast reads, all 14,739 records independently compared, 425,560 channel truncations checked, 24,637 public rejection cases, 20,000 payload mutations and 448 synthetic shape/mode cases passed.
- Gather with both bit modes passed 274,625 exhaustive four-vertex groups, 20,000 random groups, 10,000 mutate/fail/restore cycles, transactional failure in each selected block, null/length/index/header rejection and blob/output overlap checks. Input indices/output overlap passed.
- All three profile arms preserve status, float output bits and nearest RGB565 for 1,756,224 inputs, including 18 invalid and 85,388 clamp cases. Combined arm also replayed the original float64 files directly for all 40 retained frames (1,296,000 pixels) and matched stored RGB565.
- Forced gather-decode failure leaves all public profile output unchanged, including overlapping profile input/output. Invalid HDR does not invoke decoder.
- Independent ASan+UBSan runs of exhaustive decoder and gather suites passed. Leak detection disabled because of known ptrace environment restriction; no leak-safety claim is made.
- All 87 original input pins and full float32 corpus hash checked. Source alpha, images, model/reference-input generation, renderer, SDK and device were not used. Original retained HDR/profile fixtures were read only.

## Code reasoning

Byte-window reads are bounded by the original bit-capacity check. Width is at most 16, offset at most 7, so at most 3 bytes are loaded, with shifts below 32. Zero-width reads consume nothing. Predictor and Rice arithmetic remain unchanged. Gather obtains every index before output writes, preserves per-selected-block full channel/trailing-byte validation, stores results in private scratch and commits only after all blocks succeed. Duplicate block targets are filled from the same decoded channels. Output/blob overlap checks use differences rather than overflowing pointer ends. There are only immutable static magic arrays and no mutable global/cache state. Thus stale cache, generation, ownership/rebind and eviction contracts do not exist in these arms; mutation/restoration was still exercised between calls. Caller memory must remain stable during a call.

## Benchmark review before timings

Inspected build.py, batch_bridge.c, benchmark_ordered.py, locality.py and generated trace source. All arms use the same wrapper, O2/no-fast-math/no-contract settings. Input manifest, per-frame float64-to-float32 conversion, 40-frame count, primary order, declared off/on alternate order and no extra reversal are correct. Nine rotated/reversed arm-order trials check paired per-frame checksums. Median total and per-frame calculations are separate. Locality trace resets state per frame and uses matching index math. Verified all 40 names/pixel counts and reference/hit/miss identities. Runtime cache bytes are zero; modeled 388/1552 bytes are only payload/tag lower-bound models. No cache timing claim follows from modeled hits.

Independent test sources and logs are in this review directory. Tests read the preserved raw table solely as a numerical oracle, and generate no new renderer/model/reference inputs.

## Final benchmark verification

PASS. Independently recomputed all input hashes, all 40 frame names/counts in each declared order, nine rotated/reversed trial orders, paired per-frame checksums, trial totals, per-frame medians, total medians, per-profile times and ratios. Binary pins and exact object-section costs match. Verification source: verify_benchmark.py; machine-readable results: REVIEW.json.

Primary row-major gather takes 4292.206 ns/profile versus baseline 9597.798 and raw 99.328: 2.236× faster than compressed baseline, still 43.212× raw. Alternate off/on order gather takes 4349.365 ns/profile versus baseline 9498.079 and raw 103.649: 2.184× faster than compressed baseline, still 41.962× raw. Fast-byte reads regress by 16.5%/16.2% versus compressed baseline in these two representative orders. Cold synthetic diagnostic remains separate.

Gather is the best measured compressed arm of the finite set. Its conservative named host stack chain is 648 bytes versus baseline 488 and raw 144. Text is 3634 bytes versus baseline 2582 and raw 848, including both exported fetch functions. Immutable encoded blob stays 445248 bytes; measured read-only object sections total 445380 bytes versus raw 1647866. Mutable static and retained cache RAM remain zero. Stack excludes libm/ABI overhead and is compiler-frame accounting, not target high-water measurement. This does not establish target/device fit, physical render performance, or whole-renderer speed.

Fixed 1/4-block LRU rates remain modeled locality only, with per-frame reset and 388/1552-byte payload/tag lower-bound models. No cache implementation, lifetime contract, hit runtime, or cache speedup was tested. Byte-window variant is not recommended by these results. No correctness blockers found.
