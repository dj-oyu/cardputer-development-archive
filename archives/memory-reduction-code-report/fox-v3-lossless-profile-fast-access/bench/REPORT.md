# Ordered host-only fixed-profile benchmark

All 87 baseline fixture pins verified before and after. All 40 retained frames are full 240x135 row-major float64-to-float32 inputs, 1,296,000 profiles per ordered trial. Nine trials per scenario after one warmup per arm; sequential rotating/reversing arm order. No implementation/review CPU tests overlapped. Host is not reserved against unrelated load. No new renderer/device test.

## Measured medians

| Scenario | Raw ns/profile | Four-fetch baseline | Byte-window | Gather | Gather + byte-window |
|---|---:|---:|---:|---:|---:|
| manifest_order | 99.328 | 9597.798 | 11182.132 | 4292.206 | 5083.291 |
| alternate_off_on | 103.649 | 9498.079 | 11041.410 | 4349.365 | 4961.117 |
| cold_seeded_log_hdr | 221.172 | 2890.353 | 3973.826 | 1544.029 | 2092.748 |

Primary gather is 2.236x faster than compressed baseline (55.28% lower time), but 43.212x slower than raw fixed-u16 lookup. Alternate off/on order gives 2.184x faster than baseline, still 41.962x raw. Byte-window extraction alone regresses 16.51% on primary order. Gather without byte-window is the fastest of the frozen candidates. The old 84.47x seeded-subset result is not a comparable ordered-frame baseline.

The cold_seeded_log_hdr label denotes the fixed first8192 synthetic inputs with stateless decoders, not a measured cold CPU cache and not a persistent-cache timing. No decoder state survives calls in any arm. Initialization/reset cost is zero because no reset/init operation exists.

## Costs

| Arm | Text bytes | Read-only bytes | Static writable/cache bytes | Conservative stack-chain bytes |
|---|---:|---:|---:|---:|
| raw | 848 | 1647866 | 0 | 144 |
| baseline | 2582 | 445380 | 0 | 488 |
| fast_bits | 3941 | 445380 | 0 | 616 |
| gather | 3634 | 445380 | 0 | 648 |
| gather_fast_bits | 3954 | 445380 | 0 | 776 |

Host cc -O2 objects, excluding identical benchmark wrapper, linker/ELF metadata and alignment. Decoder includes both public fetch functions even if one is not called. Conservative stack sum adds compiler .su maxima on active nested chain, not instrumented high-water; excludes libm internal stack and ABI caller overhead. No embedded/device RAM or timing claim.

## Exact work counts and hypothetical locality

Primary forty frames require 5,184,000 baseline block decodes versus 2,254,054 stateless gather decodes (43.48%). Baseline reconstructs 995,328,000 uint16 values; gather 432,778,368. Worst case remains four blocks and 768 uint16 values per profile.

Separate LRU simulation starts empty per frame and uses actual four-vertex access order: one-slot hits 3,321,602 / misses 1,862,398 (64.0741% hit); four-slot hits 5,078,554 / misses 105,446 (97.9659%). Hypothetical full-block payloads are384/1536B; explicit uint32 tag model totals388/1552B before context/alignment. These are modeled locality/payload counts, not implemented-cache RAM or measured cache speed. All actual arms have zero retained cache RAM.

## Evidence and reproduction

BUILD.json pins source and compiler/flags. BENCHMARK.json contains source-plan hash, binary hashes, input hashes, all trial/per-frame times and medians, CPU/platform metadata, load/process snapshots. COSTS.json and build/*.su/size.txt contain object/stack evidence. LOCALITY.json contains per-frame exact modeled counts. Correctness and sanitizers are independently owned under review/.

Run build.py, costs.py and locality.py, then benchmark_ordered.py --libraries LIBRARIES.json only after coordinated CPU-heavy workers are quiet. Raw HDR, profile data headers, .o/.so binaries embedding data and private inputs are excluded from shareable artifact allowlist.
