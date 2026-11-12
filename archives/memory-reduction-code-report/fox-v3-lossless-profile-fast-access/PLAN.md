# Frozen fast-access candidates
Frozen 2026-11-04 before any benchmarks. Base is research/block_decoder.c and profile/candidate_profile.c from fox-v3-lossless-profile-lut, using the unchanged 445248-byte blob (SHA256 ddb92d760c9359008a2c1a8bb179936b196c0e37d1b7f9c2f12d4c71fafcae5e).

Finite candidate set, no adaptive tuning after timings:
- fast_bits: baseline random fetch, replace per-bit extraction with bounded byte-window extraction. Rice unary remains bounded and exact.
- gather: baseline bit decoder, gather four vertices with one decode per distinct selected cube block within each call.
- gather_fast_bits: combine both.
Baseline remains unchanged. No persistent cache, caller-owned retained cache, globals containing mutable data, format changes, thresholds, interpolation arithmetic changes, or device/renderer integrations.

## Contracts
The public single-vertex fetch preserves baseline selected-header/index/channel validation and transactional RGB output. Four-vertex gather reads all input indices into locals before committing output, supporting indices/output alias. It rejects output/blob overlap without pointer-end overflow. It validates every selected block fully, including channel trailing bytes, even when only one vertex is requested. Invalid inputs, truncated/malformed selected data or any selected failure leave all public output unchanged. Private scratch may change on failure. Dimensions, modes, Rice bounds and modulo-uint16 predictor semantics remain baseline exact. No retained state means mutation, poisoned previous scratch, rebind, pointer reuse and blob lifetime cannot cause stale hits. Input must remain stable throughout a call, as baseline requires.

## Validation and selection
Independent exhaustive comparison of all 823875 channel values; four-corner profile comparisons preserving arithmetic; selected malformed records, header/index/truncation cases; input/output alias and overlap checks; overflow-safe length rejection; sanitizers and warning builds. Benchmarks are separately owned and must include measured real-row order, report workspace and code-size costs, and identify fixed candidates without post-timing changes. Synthetic unit tests may run after this freeze. No full renderer/device/SDK/public/model/image/reference-input access. Independent review and benchmark evidence determine recommendation, not assumptions.

## Pre-timing appendix: modeled retained-cache opportunity
Added 2026-11-04 13:49 UTC before any timing: benchmark worker will model fixed capacities 1 and 4 decoded blocks in real-row order, with explicit replacement/reset policy in its frozen bench plan. These are read-only hit/miss traces, not implemented candidates or measured cache speed claims. Persistent cache implementation is deferred because robust identity/generation, immutable blob lifetime, explicit rebind, stale pointer/ABA, malformed-selected-block and scratch poison guarantees add API and validation complexity. Such a cache is not forbidden; its trace benefit and SRAM tradeoff will be reported separately.
