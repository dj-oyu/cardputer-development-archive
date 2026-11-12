# Four-block lossless profile cache

Host-only independent prototype. Profile, LUT values, interpolation, original references and thresholds are unchanged. No rejected owned-ray-context operations or code were used. No renderer wiring, physical ray rerender, device drawing or firmware fit claim.

## Result

Four fixed scenarios (manifest order / alternating OFF-ON order, cold per frame / warm across frames), nine alternating sequential trials each, show 10.66–11.29× speedup versus prior stateless gather. Setup-inclusive median 384.686–440.117 ns/profile remains 3.72–3.93× slower than the uncompressed uint16 table. Actual cache hit rate is approximately 97.966%. All 40 frames are evaluated in full row-major order; checksums and 87 input pins remain identical. Shared-host noise is retained in bench/REPORT.md rather than hidden.

Independent correctness tests establish all 823875 LUT scalar values and 1756224 profile inputs exact (statuses, float bits, RGB565), plus direct original-f64 replay of 40 retained frames. Malformed selected records, mutation, same-address rebinding, output aliasing, failed calls and exact LRU replacement have independent tests and ASan/UBSan coverage. This does not establish arbitrary C caller memory safety or leak detection.

## Costs and lifecycle

Exact blob remains 445248 bytes, saving 1202502 bytes versus the 1647750-byte raw LUT. Host measured total RO 445372 bytes; text 4543 bytes (gather 3634, +909). Caller-owned cache sizeof is 3224 bytes, no heap or mutable implementation globals. Conservative named stack chain 520 bytes (gather 648, -128), excluding library internals and caller ABI. Retained cache plus this stack is 3744 versus gather 648, a net +3096 bytes for those named stores; allocator/device layout and whole-renderer memory remain unmeasured.

The previous 1552-byte cache trace estimate included decoded values/tags only. This actual design also retains up to 396 encoded bytes per block for mutation checks. Every hit validates selected offset bounds and compares encoded snapshots. Bind resets even at the same address and validates the complete index. Ordinary failed bind leaves unbound; overlapping context/blob bind fails without modifying either, so the old binding remains and callers must check return status. Output is transactional, internal cache state may change on failure. Unselected corruption is not checked until selected; this is not cryptographic authentication.

Storage is borrowed and must remain valid/readable/stable during each call. Unbind before release and rebind after logical replacement. The cache cannot detect dangling pointers or actual asset identities. Independent contexts are required for concurrent users. It must not be described as the rejected renderer owned-context implementation.

## Status and next boundary

The standalone cache is a promising exact host acceleration, not an adopted renderer. Integration would need explicit caller storage/lifetime binding, alias/work admission, fixed-output regressions and whole-chain memory/stack accounting. No automatic claim that the roughly 3.2 KB extra retained RAM fits the device. Device timing remains unavailable by instruction.

Evidence: implementation/SOURCE_FREEZE.sha256, tests/contract.log, review/REVIEW.md and REVIEW.json, bench/PLAN.md, BENCHMARK.json, COSTS.json and VALIDATION.json. Build commands are in tests/run.sh and bench/build.py. Profile replay uses review/run_profiles.sh; it needs the intentionally excluded original private HDR fixtures. The private backup includes code, synthetic tests, counts/timings and the already retained generic profile blob, not fox images, geometry or HDR arrays.
