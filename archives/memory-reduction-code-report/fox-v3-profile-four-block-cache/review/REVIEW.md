# Independent fixed4 cache correctness review

PASS on final cache source SHA256 7e06ed0436d9e6be0783f0b31c208f75034be297f450e10f813e00d04a13fff6. Source freeze verified after all tests. No remaining correctness blocker found. Numerical correctness and lifecycle review do not establish firmware or renderer integration, target memory fit, or device speed.

## Exactness and independent tests

- Compared every LUT vertex in 274625 four-vertex groups directly against preserved raw uint16 table (all 823875 unique channel values covered, with additional neighboring fetches).
- Compared cache against frozen stateless gather in 20000 randomized live payload mutation/fail/restore cycles. Public outputs match on success and remain sentinel-identical on failure.
- Generated a separate valid 4913-block synthetic constant-record blob, checked every block including boundary shapes, 1000 same-address live A/B/A mutation/rebind cycles, and malformed selected record at each of four requested corners.
- Checked 20000 independent exact-LRU oracle steps, including repeated hits and valid middle-slot record changes. Checked malformed unselected index at bind, all header-byte corruptions during use, clear-before-free, unbound calls, ordinary failed bind and explicit same-pointer reset.
- Alias tests cover output/indices overlap, forbidden cache/output and cache/indices overlap, blob/output overlap, and alias-invalid bind preserving its source/context. NULL with SIZE_MAX must fail and unbind; this regression passed on final code.
- Full 1756224-input corpus preserves status, float output bits and nearest RGB565 exactly against frozen raw profile: 18 invalid and 85388 clamped cases included. Direct float64-to-float32 replay of all 40 retained frames (1296000 pixels) also matches stored RGB565. Verified all 87 input pins.
- Forced profile decoder failure preserves public output including input/output aliasing. Invalid HDR does not invoke decoder; profile/cache alias rejects.
- Final exhaustive/mutation/LRU suite passes ASan+UBSan. Leak detection disabled for environment compatibility; no leak-safety claim. This cache uses no allocation.
- Independently compared copied bit reader/channel decoder source with frozen fast-access source; it is unchanged except internal function name/linkage. Review builds explicitly use FAST_BITS=0.

Tests and logs are alongside this report. No raw fixture arrays, images, geometry or new renderer inputs are emitted by these tests.

## Corrections found before final freeze

Initial saturated age updates lost true LRU ordering after repeated hits. First fix still left rank gaps after invalidation/decode failure. Final code removes entries while compacting older ranks and inserts at current valid count before touch; independent order oracle passes. Initial bind cleared overlapping source storage; it now returns unchanged before any write for that forbidden alias. A further NULL/SIZE_MAX case incorrectly entered that alias exception; final code guards overlap with a nonnull source.

## Contract and limits

The 3224-byte host cache is caller-owned, holds four decoded RGB blocks plus up to 396 encoded bytes per block, and borrows source bytes. It does not own the blob or make dangling pointers safe. Source memory must remain live/readable and stable during each call, and callers explicitly bind after logical asset replacement and clear before freeing. Same-pointer bind clears entries and counters. Ordinary failed bind unbinds; forbidden source/context overlap is a documented unchanged-state exception whose failure must be checked.

Header and selected offsets are checked on each fetch. A hit compares the selected current record with its encoded snapshot; changed selected bytes cause invalidation and fresh decode. This detects between-call selected-record changes, not global corruption, asset identity, concurrent mutation, or freed storage. Unselected payload is not checked until selected, and all index entries are revalidated only at bind. No UAF or ownership guarantee is claimed.

Decode failure may update internal entries/counters but never commits public output. A partial slot is invalid. Input indices are copied before output commit; forbidden context and blob output aliases are rejected. Profile arithmetic/order remains unchanged. No mutable global cache exists.

## Timing handoff

All reviewer CPU-heavy tests finished at 2026-11-04 14:19 UTC, and parent was notified that benchmark may start. Reviewed declared benchmark plan: four manifest/alternate by cold-per-frame/warm-across-frame scenarios, explicit empty starting state, nine fixed rotated/reversed arm trials, setup-inclusive timing, retained actual snapshots/counters and no hidden prefill. Timing evidence is not yet part of this correctness report.

## Final independent timing and cost audit

PASS, with no new timing runs. Independently recomputed all four scenarios' nine trial orders, full-frame names and counts, checksums/counter consistency across 6400 warmup plus measured frame-arm observations (5760 measured), setup/pixel/wall sums and gaps, median totals, median frame times, ratios and ns/profile. Reconstructed both exact float32 input-stream hashes from original float64 files; all 87 fixture pins, source, harness and binary pins match. Artifact and source freeze manifests pass.

Primary setup-inclusive cache times are 440.117, 405.002, 407.825 and 384.686 ns/profile in declared scenario order. This is 10.661–11.286 times faster than measured gather in the same trials, still 3.724–3.927 times slower than raw. Actual successful cache hits plus misses equal four per pixel; invalidations are zero for immutable fixtures. Cold trials rebind every frame; warm trials start empty and bind once. Bind, full index validation, snapshots, active counters, Python dispatch and snapshot calls remain included in primary wall time. Separate pixel/setup intervals and dispatch gap are correctly recorded.

Object sections and compiler stack records independently reproduce cache text 4543 B, read-only data 445372 B, no writable implementation static storage, 3224 B caller cache, and named stack chain 520 B. Bridge storage is separately 3224 B. Verified compressed .rodata in all three compiled compressed profile objects byte-for-byte against frozen blob, and raw object's .rodata against frozen raw table. Cache plus named stack is 3744 B versus gather 648 B, net +3096 B, excluding caller/library/ABI/device layout. The prior 1552 B trace was only a payload/tag model; it is not this implementation's memory size or timing evidence.

Parent FINAL_REPORT.md cost, lifetime and scope statements reviewed and consistent. Results are shared-host evaluator timings with observed trial variation, not target/device or whole-renderer performance. No eviction, decoded-symbol or encoded-byte counters were instrumented; no such measured counts are inferred. Correctness checksums alone are weak additive summaries and supplement the earlier exhaustive exact tests.

Safe private backup: use bench/BUNDLE_ALLOWLIST.txt for bench source/plans/aggregate artifacts and textual size/stack records. Review/SAFE_ALLOWLIST.txt names reviewer code/logs/reports. Do not recursively include review/ or bench/build/: executables, .o and .so files embed raw or encoded private data. No fixture arrays, HDR, images or geometry are in the allowlists. Include the already-authorized generic encoded blob only through its separately approved path.
