# Runtime integer normal interpolation → normalization bridge

## Boundary correction

Earlier `test_integer_light.c` fixture `pixel()` normalizes saved double Ns before encoding. That is offline/test preparation; it was **not** a runtime integer normal-normalization bridge. The direct core's internal integer normalization only accepts already-near-unit codes. Existing core/source/results are preserved and must not be relabeled as tests of this new path.

New separate `normal_bridge.h` exposes:

`il_normal_status il_normalize_interpolated(const int16_t in[3], int16_t out[3])`

Input is an arbitrary interpolated signed16 vector with a common scale, ordinarily /32767. It permits -32768. The caller can use the existing Q14 partitioned-weight `fk_scalar`/`fk_block` interpolation, then apply native→Blender-world axis/sign/backface mapping, then call this bridge and `il_eval`. Handle sign reversal in int32 if INT16_MIN is possible. All inputs must share the intended coordinate basis. Applying an orthogonal sign/permutation before normalization makes the contract explicit.

Statuses: 0 success, 1 nearzero fallback, 2 unexpected output range failure. If magnitude is less than512 codes, reject. For /32767 inputs this is about0.0156255 in normal-vector length, a **new bounded fast-path policy**, not the old double nonzero test. Exact512 is admitted. Output is /32767 near-unit codes satisfying `il_eval`'s norm envelope. No clipping/saturation and no floating arithmetic. Output remains unchanged on failure, and in/out aliasing is supported.

## Range and error proof

Let s=sum(input component²). Inputs are in [-32768,32767], so s<=3×2^30<2^32. Reject s<512². `s<<16`<2^48 fits uint64. Integer restoring sqrt gives L=floor(256*sqrt(s)), with L>=131072. Every output component is nearest/ties-even of input×32767×256/L. Signed numerator magnitude<=32768×32767×256<2^38, far from INT64_MIN/overflow. No signed shifts or floating rounding mode assumptions occur.

Before component rounding, the vector is exactly parallel to input. Its magnitude B=32767×256*sqrt(s)/L lies in [32767,32767.250). Each output rounding error is at most0.5 code, so total perturbation norm<=sqrt(3)/2. Thus output length lies within [32766.1339,32768.1161], comfortably inside accepted [32762,32772]. A component cannot round outside±32767: the unrounded absolute maximum is below32767.25. Code nevertheless checks component and squared-length bounds rather than silently narrowing an unexpected result.

Normalization-only angular error against the *same integer input vector* is bounded by asin((sqrt(3)/2)/32767), approximately0.00151431 degrees. This does not include upstream position/normal interpolation, Q14 weights or original-float→integer quantization. Near cancellation, that earlier input error can change direction substantially; the magnitude fallback limits but does not erase that risk. No universal end-to-end angular bound is claimed.

## Tests

`bash run_normal_bridge.sh` uses GCC14.2 O0/O2, ASan+UBSan, strict floating-reference flags. Outputs compare byte-identical. Scalar normalization itself is entirely integer. Reference angular measurement uses robust atan2(|cross|,dot), not acos near1. Leak detection disabled for the known ptrace limitation.

- 100000 deterministic full-range signed16 synthetic vectors: all admitted, normalization-only maximum0.00148744851°, RMS0.00071392693°.
- Explicit zero,1,511-code vectors rejected;512 accepted. Negative-axis INT16_MIN, both all-component extremes, threshold-near diagonal vectors, and in/out aliasing tested.
- Actual7678 saved raw interpolated Ns: each component first encoded /32767 **without double normalization**, then integer-normalized. All7678 accepted, minimum raw input norm0.235194655377.
- Actual maximum angular error against raw double Ns direction, including component quantization:0.00363806472°, RMS0.00114334380°.
- Actual normalization-only error against encoded vector direction: max0.00138228435°, RMS0.00071919073°.

These normal-only tests do not replace the earlier direct-radiance results; combined-path error is measured separately by the chain worker.

## Core operation census, not timing

For a fully admitted pixel with all48 source/receiver cosines positive and visibility bits set:

- **52 integer square roots:** 1 receiver-normal length +3 emitter-normal lengths +48 sample distances. Restoring sqrt uses at most32 bit-pair iterations and no division. Scene validation is separate and calls3 normal-length roots once per validation.
- **351 quotient/remainder rounding pairs:**48×(3 direction +2 cosine +1 inverse-distance +1 kernel reduction)=336, plus3 light means,9 RGB power reductions,3 final material reductions=351. Source contains `/` and `%` per pair, so702 C operators; a compiler may fuse a pair into one division, but target code has not been inspected.
- Of those351, **288 have runtime divisors** (directions144, cosines96, reciprocal distance48);63 use fixed divisors (kernel48, means3, powers9, rho3) and may compile to shifts/multiplies. No instruction-cycle claim is made.
- A masked/back-facing sample still computes distance sqrt and three direction divisions before the existing test; four later rounding pairs are skipped. With every sample inactive, total is159 rounding pairs and52 square roots. Plane/sample rejection can return earlier.
-3×16 prepared sample-vector loads, masks,3 emitter normals and power/world values; no exp/log or runtime trigonometric/sRGB lookup in direct core. Sample coordinates are offline-prepared, not regenerated.
- New normal bridge adds **1 sqrt +3 variable-divisor rounding pairs** per accepted pixel. Q24→Q19 output adapter adds3 constant-divisor rounding pairs outside the direct core.

Strongest PIE candidates remain batched normal×direction dots (three signed16 MACs per dot) and positive Q14 cosine×cosine products. Wide squared distances, roots, runtime64-bit division, Q24 products and HDR accumulation remain likely bottlenecks, but only target measurement can establish their cost. Emitter-normal roots could be cached during immutable scene preparation; receiver normalization duplication can be redesigned only under an explicit revised contract. Neither optimization is implemented here. Block8 currently changes organization only, not arithmetic parallelism.
