# Fixed-four-block cache measured ordered host benchmark

All 87 fixture pins and all compiled-source pins verified before and after. Each scenario uses all 40 frames, 1,296,000 full row-major pixels. One empty-start warmup plus nine independent trials, rotating/reversing sequential arm order. Cache binding/index validation and resets are included in primary batch wall time. Pixel-only and setup-only intervals are retained separately. Host was coordinated against known tests, not reserved against unrelated load. No device or full-renderer speed claim.

## Primary setup-inclusive wall time

| Scenario | Raw ns/profile | Baseline | Gather | Cache4 | Cache4 speedup vs gather | Cache4/raw |
|---|---:|---:|---:|---:|---:|---:|
| manifest_order/cold_per_frame | 112.966 | 10415.911 | 4692.297 | 440.117 | 10.661x | 3.896x |
| manifest_order/warm_across_frames | 103.142 | 9753.836 | 4570.948 | 405.002 | 11.286x | 3.927x |
| alternate_off_on/cold_per_frame | 109.525 | 10211.248 | 4432.637 | 407.825 | 10.869x | 3.724x |
| alternate_off_on/warm_across_frames | 100.220 | 9742.476 | 4325.913 | 384.686 | 11.245x | 3.838x |

## Setup, actual cache counters and shared-host variation

- manifest_order/cold_per_frame: actual hits 5,078,554, misses 105,446, invalidations 0; hit rate 97.9659%. Median total setup 0.2434 ms; median pixel-only 567.844 ms. Cache batch wall range 493.747–759.260 ms across nine trials.
- manifest_order/warm_across_frames: actual hits 5,078,559, misses 105,441, invalidations 0; hit rate 97.9660%. Median total setup 0.0076 ms; median pixel-only 523.408 ms. Cache batch wall range 488.604–598.282 ms across nine trials.
- alternate_off_on/cold_per_frame: actual hits 5,078,554, misses 105,446, invalidations 0; hit rate 97.9659%. Median total setup 0.2267 ms; median pixel-only 526.943 ms. Cache batch wall range 475.499–592.785 ms across nine trials.
- alternate_off_on/warm_across_frames: actual hits 5,078,556, misses 105,444, invalidations 0; hit rate 97.9660%. Median total setup 0.0074 ms; median pixel-only 497.627 ms. Cache batch wall range 450.130–592.385 ms across nine trials.

Misses on these successful fixed-data evaluations correspond to decoded blocks. Evictions/encoded bytes/decoded symbols are not instrumented, so no measured values are claimed. Counters are enabled in timing. Cold-per-frame rebinds and fully validates the index every frame; warm-across-frame binds once per trial and starts empty, never retaining warmup/trial state. Primary batch wall also includes Python dispatch and counter snapshots, with the exact gap recorded in BENCHMARK.json.

## Measured object and storage costs

| Arm | Text B | Read-only B | Writable static B | Caller cache sizeof B | Conservative stack chain B |
|---|---:|---:|---:|---:|---:|
| raw | 848 | 1647866 | 0 | 0 | 144 |
| baseline | 2582 | 445380 | 0 | 0 | 488 |
| gather | 3634 | 445380 | 0 | 0 | 648 |
| cache4 | 4543 | 445372 | 0 | 3224 | 520 |

Host cc -O2 objects excluding benchmark bridge, linker metadata and alignment. Fixed caller cache is stored by bridge as a host convenience and is reported separately, not omitted. Conservative stack sums compiler .su values on nested chain; cache decode_channel is inlined into agx_cache_fetch4. Excludes libm/memcpy/memcmp internals and ABI caller overhead. Not observed stack high-water, embedded RAM, or device timing. Bind fully validates index and empties cache/counters; clear unbinds. No allocations. Cache snapshots encoded bytes as well as 1536-byte decoded payload, explaining larger actual sizeof.

The cache includes encoded snapshots to check mutable-input freshness in addition to 1536 B of decoded values. Binding performs full index validation; per-evaluation checks and hit snapshot comparisons are included. Heap allocation is absent.

## Evidence and reproduction

BUILD.json records flags/compiler/source pins; COSTS.json and build/*.su/size.txt record object/stack evidence. BENCHMARK.json retains every warmup, trial, frame time, setup time, checksum, actual counter delta, binary/input hashes and start/end host snapshots. Exact correctness and lifecycle evidence lives in the independently owned tests directory. Checksum parity is supplementary only. Run build.py, costs.py, then benchmark_ordered.py --quiet-window-approved only after correctness and coordinated test-idle approval, followed by report.py. Share only BUNDLE_ALLOWLIST entries, never private inputs or linked data-bearing binaries.
