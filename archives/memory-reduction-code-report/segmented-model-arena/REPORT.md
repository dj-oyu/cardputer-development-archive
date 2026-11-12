# Stable segmented model arena: fixed40 exact

## Result

Completed the authorized40 frames against the completed indexed-transport-input baseline, OFF20 then ON20 with canary-first gates. Independent retained-output audit passes:200 raw comparisons,280 report comparisons,80 forward/reverse comparisons. RGB565, float depth, snapshot, target bytes and HDR are byte-exact. Material fingerprints, physical counters, quotas and completion flags are unchanged. Only non-timing report difference is arenaBytes64bit81356→81796, reflecting copied pointer-table payload. No retries or rerenders; frozen source148 pins remain unchanged.

## Storage and limits

Opt-in segmented initialization retains all55 independent node caches. Metadata1760 combines states1320 and copied pointers440; node work totals80036, each84..1648 for this model. Caller descriptor lifetime ends at init, while model/cold, metadata and every node slot remain alive and immutable outside APIs until dispose. Existing borrowed views survive other reads; mutation/evaluation/dispose invalidation is unchanged. Epoch remains mutation-only.

Largest model allocation falls81356→1760. The largest named lifecycle allocation becomes AA workspace77312. This improves allocation granularity, not total memory: payload81796 (+440), independent allocation owner912, total model heap82708 (+1352),57 allocations including owner. Allocator metadata and fragmentation are excluded, so real overhead is additional. Cold remains47708.

Product main stack83792 (+32), diagnostic main83776 (+16), renderer5008 unchanged. Background4080 of4096 retains only16 bytes margin. Named product lifecycle peak is496184, up32 from496152. Host instance584 and new bool offset581 do not establish old-binary ABI compatibility; all consumers were recompiled. No target32/device/whole-host-fit or speedup claim.

## Safety and validation

The contiguous initializer remains unchanged and available. All13 previous arena-overlap predicates protect metadata and every used slot for segmented instances. Complete count/range/alignment/overlap validation precedes any storage/output write. A separate owner record unwinds partial allocations and frees saved handles after dispose without consulting mutated instance metadata.

Independent synthetic coverage passes863362 assertions over5/55/256-node O2 and ASan+UBSan configurations, including masked blend regions, copied-table and first/last-slot aliases,40 rejection cases, all7/57/258 allocation-failure positions, descriptor poisoning, simultaneous borrowed lifetime, mutation/evaluation/cache counters, physical-scene parity, reentrancy and stale-generation reinit. Legacy24 runs, integration48 compile/run records plus exact row parity, and adapter91+2 tests also pass. LSan was disabled after its documented ptrace-environment failure; explicit bounded allocation-balance tests passed, but no general leak-clean claim is made.

Maximum observed AA work7804336 remains within8000000. Maximum producer work441972 remains below637599. Guard budgets and renderer call chains are unchanged. New init/guard pointer checks and allocation work are real additional CPU costs, separately documented rather than hidden behind unchanged physical counters.

## Provenance and scope

SOURCE_FREEZE.json pins148 pre-render inputs; PHYSICAL_EXECUTION_GATE.json records parent approval and exact hashes. review/FINAL_REVIEW.json independently revalidates retained outputs, source/build/runtime pins and ledger arithmetic without rendering. FINAL_RESULT.json summarizes verified totals. AGGREGATE_CODE_ALLOWLIST.json permits only selected code, tests and aggregate evidence for preservation, excluding assets, raw frames, compiled models and binaries.

No source geometry, rig, reference, profile, thresholds, device, SDK, public repository or PR changes. Rejected owned-context and unfinished paged-BVH implementations were not used. Completed indexed-input baseline remains intact and is the fallback documented in RESTORE.md.
