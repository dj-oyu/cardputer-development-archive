# Exact profile access acceleration

Three stateless candidates were fixed before timing: bounded byte-window bits, same-call unique-block gather, and their combination. The445,248-byte compressed LUT and all interpolation arithmetic remain unchanged. No new approximation, smaller grid, source-image fit or threshold changes.

## Fidelity and failures

All three preserve823,875 table values and exact float/status/565 results across1,756,224 inputs each, including saved40-frame HDR. Independent exhaustive, direct-f64, malformed/truncated/overflow, input/output alias, public-output failure and sanitizer tests passed. Gather reads indices to locals and commits only after every selected block validates; private scratch may change on failure. It holds no persistent cache and has no mutable static state. This is standalone profile validation, not fullrenderer integration or physical rerendering.

## Ordered real-input benchmark

All40 frames, each full240×135 row-major stream, one warmup then nine alternating sequential trials per order. Also tested fixed OFF/ON interleaving. No CPU-heavy tests ran concurrently; unrelated host load was not isolated. Every checksum and87 inputpins matched. The original84.47× result used a sampled corpus; compare new methods to the paired baseline in THIS run, not divide ratios across experiments.

Primary median ns/profile: raw99.328; compressed baseline9597.798; byte-window11182.132; gather4292.206; combined5083.291. Gather is2.236× faster than compressed baseline but43.212× slower than raw. Alternate order: gather2.184× baseline speed,41.962× raw slowdown. Byte-window alone regresses16.5% and is not recommended. All planned results, including regressions, remain recorded.

Gather host code: text3634B (+1052 vs compressed baseline), RO445380B unchanged, writable static0, named profile/decoder stack648B (+160). Stack excludes libm/caller and is not a target watermark. No heap or retained cache was added. Current renderer RAM/stack/flash admission remains unchanged until explicit integration/build accounting.

## Cache opportunity, not cache performance

Real-order4-corner references total5,184,000; same-call gather requires2,254,054 block decodes (43.48% of baseline). Fixed reset-per-frame LRU trace predicts64.07% hits with1 block and97.97% with4. The data+uint32tag models are388/1552B, excluding control/replacement/alignment/lifetime bookkeeping. No cache implementation or cache timing was performed. Hit ratio is not a speed estimate.

A fixed4-block cache is the remaining promising independent speed experiment, but it needs a separately validated binding/immutable-blob lifetime/rebind/invalidated-or-poisoned state/failure contract and honest RAM/setup accounting. It was deferred, not treated as forbidden. Do not adopt cache or claim performance from this trace.

## Preservation and limits

review/REVIEW.json independently checks fidelity, timing arithmetic, ordered inputs, nine trials, checksums and costs. bench/REPORT.md and full BENCHMARK.json retain per-frame observations. Generic compressed blob is preserved in the prior lossless-profile package; this extension adds code/tests/aggregates only. No original images, fox geometry or raw HDR input arrays are included. No device rendering, target build, SDK installation, PR, publication or rejected-code reuse occurred. Gather is the best tested stateless candidate, not a deployed renderer or a device-fit claim.
