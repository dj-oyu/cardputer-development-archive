# Private lower-level scene target handoff harness

## Boundary
`frame_harness.c/.h` is a portable lower-level benchmark/ownership adapter over existing integrated `scene_prepare` / `scene_band`. It is NOT the actual Kasane fixed-UI/core/completion seam. That separate seam was validated in the previous frozen owner fixture. This benchmark excludes Kasane UI/core, original BSDF/transparency, platform driver and firmware. Geometry is diagnostic opaque material-ID color with the declared eight neutral-face head-control poses.

Callers supply monotonic, nonwrapping `now_us`, submit-borrow and drain callbacks. One owner is zero-initialized and used serially. Owner/port/times buffers must not alias; callbacks and immutable source are trusted. Callback implementations must be bounded and must not recursively enter or mutate owner/snapshots. Each frame uses at most two four-row half-strips in flight; before reusing either, drain is required. `drain=true` MUST attest successful final completion of ALL accepted transfers AND release of all borrowed inputs, not merely descriptor release. A failed submit may retain its input; it is conservatively included in the pending borrow count.

Old projected snapshot remains owned. Candidate promotion occurs only after successful final drain. Prepare failure makes no transfer. Send/raster failure aborts and drains without promotion; display remains unknown. Failed drain quarantines the candidate and buffers and blocks another frame. Explicit `fh_recover` retries drain; successful recovery releases pins but does NOT repair display, promote candidate or imply pixel rollback. No forced repair, asynchronous event-token queue, device-driver implementation or frame-atomic display is claimed.

## Validation
O2 and ASan/UBSan pass 30 excluded warmup frames followed by 120 measured full frames. Assertions prove exactly 8 poses × 3 cameras × 5 samples. Failure tests cover prepare failure, failed submit retaining a borrow, final drain failure, blocked attempt during quarantine, failed recovery drain, successful recovery without promotion, then successful full-frame promotion. Test-only witnesses verify borrowed half-strip bytes remain immutable, including during quarantine. 7,765 witness checks pass. Leak detection disabled; no sanitizer errors.

The fake transport checks/consumes bytes and completes fake transfers; it does not model SPI duration or produce a panel image. Earlier integrated reference tests establish pixel comparisons independently. Portable code has no full-frame output/oracle copies.

## Authoritative host wall-clock timing
All stage boundaries and total use callback monotonic elapsed time. Total starts immediately before prepare and ends after final drain/promotion. Existing internal `scene_times` CPU-clock values are ignored: they are not interchangeable with callback wall time. Stage sum differs from total by loop/clearing/timer overhead.

Final O2 sample (microseconds; p95 is nearest rank, sample 114 of 120):

| Stage | min | mean | p95 | max |
|---|---:|---:|---:|---:|
| prepare | 320 | 385.392 | 420 | 3549 |
| raster | 1095 | 1233.008 | 1426 | 4247 |
| submit | 0 | 2.392 | 5 | 8 |
| drain | 0 | 1.083 | 3 | 5 |
| full frame | 1440 | 1625.150 | 1943 | 4750 |

Host scheduling and 1µs quantization explain zeros/outliers. These are neither target FPS nor real SPI measurements. The 20fps target requires actual complete-frame ≤50ms with the real platform and quality contract; this fixture does not establish that.

## Memory and compiler evidence
No runtime heap allocations in portable owner or its callbacks in the compile probe.

- Two snapshots: 48,640 B.
- Shared rig/raster workspace: 14,512 B.
- Both four-row half-strips: 3,840 B.
- Owner metadata/padding: 16 B.
- `sizeof(fh_owner)`: 67,008 B.
- Immutable source: 55,266 B; control samples: 64 B. Conservatively count as RAM until target placement is verified.
- Logical owner+source/control subtotal: 122,338 B, excluding stack and platform state.
- Host portable ELF: .bss 67,040 B, .data 8 B, .rodata 55,712 B. Counting all three as RAM gives 122,760 B before stack/runtime; do not add source counts a second time.
- Test-only mock witnesses/state: 3,904 B; saved snapshot 24,320 B; samples 4,800 B; coverage-count array and reporting scratch are also test-only.

No painted stack or target stack-HWM measurement was performed. Compiler `.su` reports include `fh_frame` 176 B dynamic bounded, `scene_prepare` 640 B, `scene_band` 224 B, `stream_accumulate` 224 B. These are individual frames, not summed call-chain peaks; unused functions can appear in compiler reports despite link GC. Use the five compile units in runtime-dependencies.json, not stale auxiliary `.su` reports from the initial broader link. Do not add a previous fixture's painted stack and call it this harness's measured peak. Neither 16KiB combined fit nor total firmware RAM fit is established.

## Dependency handoff
`runtime-dependencies.json` records 18 non-system source/header paths and hashes from compiler `-MM`. Five compile units: portable_probe, frame_harness, integrated scene, private prepared_accumulate, compact_opaque. `portable-command.json` uses function/data sections and linker GC. `portable_probe.c` is compile/link/section inspection only; its no-op transport and zero timer are not a target benchmark implementation. Supply real callbacks through `frame_harness` for a real benchmark.

`portable-symbols.txt` confirms no scene_reference, ksn_mesh_render, decoded oracle buffer, panel, witness, saved snapshot, samples or mock board in the portable executable. The integrated source still contains unused oracle function text, removed by link GC. No images or Blender files are needed in a runtime-source bundle. Private generated geometry remains private.

Reproduce from workspace root:
```
python fox-target-handoff-private-20261107/harness/run.py
python fox-target-handoff-private-20261107/harness/dependencies.py
```
Exact O2/sanitizer/portable commands, maps, symbols, sections and logs are saved. No actual target compiler, device operation, upload or public change occurred here. Parent coordinates any separate packaging/target action.
