# Standalone lossless-profile comparison

## Scope and status

The copied-vertex candidate preserves the pinned fixed65 uint16 evaluator's math, domain, order and invalid-input contract. It changes only LUT storage/access: four stateless bounded RGB fetches copy twelve uint16 values before the original float expression sequence. It has no mutable global cache, allocator, raw LUT fallback, renderer/SDK/device integration or physical rerender. A codec failure returns status3 before output writes; downstream callback acceptance remains unintegrated.

O2 and O0 standalone comparisons both PASS all1,756,224 inputs:460,224 synthetic plus1,296,000 retained HDR pixels across all40 frames (OFF20/ON20,32400 each). Every compared status, continuous float bit and nearest565 value matches the separate unchanged old control. Both candidates' actual565 bytes also equal every retained final565 frame, using the exact double-to-float conversion and `lroundf(v*31/63/31)` packing. Sources and data were hashed before/after. No threshold was changed and no new official-transform accuracy claim is made.

Synthetic coverage:84981 unchanged historical holdouts,274625 grid-node triples,603 nextafter/endpoint/tie samples,50000 seeded log-HDR triples,50000 seeded nonnegative finite float-bit triples, and15 explicit negative/nonfinite invalid cases. The603 endpoint/tie set includes3 nextafter(0,-inf) invalid inputs, so the combined corpus has18 invalid and1,756,206 accepted profiles. Null input/output, invalid output atomicity and300 full/partial aliases per implementation pass separately. A deliberately malformed one-byte immutable blob returns status3 atomically for valid inputs while preserving status2 precedence for invalid input (5 extra tests).

ASan+UBSan O2 replay passes all1,756,224 samples with no diagnostic. LeakSanitizer is unavailable under this runtime's ptrace environment: the initial process reported that limitation on exit, and the explicit retry with leak detection disabled passed. Both logs remain available; this is not a LeakSanitizer pass.

## Measured host storage and stack

Compiler: Debian GCC14.2.0, x86_64; `-std=c11 -O2 -fno-fast-math -ffp-contract=off -fPIC -fstack-usage` for separately compiled profile/decoder objects. No fast-math or new FMA reassociation.

- Primary immutable table:1,647,750→445,248 bytes, saving1,202,502 bytes (72.98%). No raw table symbol remains in the candidate object.
- All measured `.rodata*` for evaluator plus decoder:1,647,866→445,380 bytes, saving1,202,486 bytes. The compressed header/index are included in445,248, not additional omitted storage.
- `.text`:848→963+1619=2582 bytes, increase1734. Both variants have0 `.data` and0 `.bss`.
- Original profile own frame144 bytes. Candidate own frame192, fetch240, channel decoder56. The conservative named nested chain is488 bytes, +344 versus old144, with compiler-inlined bit reader accounted in these frames. This excludes libm/libc internals, caller stack and target ABI/cache/linker effects.
- Twelve gathered uint16 values consume24 bytes within the profile frame, not an extra separately added allocation. Channel scratch128 bytes is within fetch's240-byte frame. Do not double-count these.

These are standalone host measurements. Baseline renderer center/quarter chains cannot be claimed revalidated by substituting these numbers. Storage-span admission, decode-failure propagation, integration stack maxima, whole-frame publication, 32-bit target stack/link/flash latency and live target capacity remain untested.

## Work and speed

Every accepted profile invokes exactly4 RGB fetches, including repeated blocks; each decodes3 channels. Worst case is12 channel decodes ×64 values=768 reconstructed uint16 values, plus12 copied output values. Invalid original inputs cause no decode. Across the fullcorpus, exact original C coordinate arithmetic counts7,024,824 RGB decodes,21,074,472 channel decodes and1,308,223,647 reconstructed uint16 values. Unique-block counts are576026 profiles with1,1014771 with2,147404 with3 and18005 with4, but this implementation does not exploit those duplicates.

Initial warmed7-trial sequential AB/BA benchmark on8192 deterministic resident log-HDR inputs repeated8 times measured median133.45ns old versus3014.39ns new,22.59× profile-only slowdown. Inputs and checksum work are identical; checksums agree on every trial. These are descriptive host timings, not isolated-system or renderer/device timings. Final nine-trial sequential AB/BA measurements (8192 inputs ×16 repetitions after warmup) in `BENCHMARK.json` show seeded log-HDR median118.12ns old versus2926.87ns new (24.78×), and8192 uniformly seeded pixels drawn without replacement from all40 retained frames median118.11ns old versus9976.21ns new (84.47×). Every paired checksum matches. All local profile and independent-review test processes had stopped before this final benchmark; unrelated host load is not isolated. The sample selection seed20261104 is fixed, with no metric-driven input selection. Memory savings are not a CPU speedup.

## Sources and reproducibility

`INPUTS.json` pins original evaluator/header/LUT, compressed blob and every retained40 source/expected buffer; `RESULTS-O2.json` and `RESULTS-O0.json` preserve per-group/per-frame outcomes and source hashes. `WORK_COUNTS.json`, `FAILURE_RESULTS.json`, `build-O2/size.txt`, `.su` files and logs support the other claims. Independent codec/profile review is reported outside this directory.

`RESTORE.md`, `PROFILE_CONSTANTS.json` and `restore_header.py` explain restoring a standalone candidate from the saved generic blob without the excluded generated header. The tiny original evaluator/API are in `control/`; original raw LUT, historical holdout buffers and retained HDR/565 fixtures are not part of a generic backup. This backup alone does not rerun historical full40 comparisons. No original images/geometry are read or included.

## Independent review and restore check

The independent reviewer reported full same-flags replay of all1,756,224 inputs, direct40 double-HDR/565 replay, all87 original-source/data pins, exact embedded blob, named488-byte profile chain, and forced decode failures at allfour corner positions with atomic outputs including aliases: PASS. The durable separate review is authoritative for its scope.

Regenerating the private header from saved blob/constants yields byte-identical output, SHA-256 `faa75109ed2a318d6ae48d3f67ae300142e281a9fd6db54bf73f380a2c420ffa`. Candidate source SHA-256 remains `f2e720fcb581a1558a000e27ef16e854d81ae7b945afdcd546fe75fb5ebe30f3`; decoder remains `4edd59bb122619abfcd006e06e3bfb614ed116f25ce7f8788979f4f40d30f3e1`.
