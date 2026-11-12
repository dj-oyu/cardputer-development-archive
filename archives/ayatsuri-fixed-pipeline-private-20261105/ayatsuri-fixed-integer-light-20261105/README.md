# Bounded integer direct disk lighting: private experiment

## What is demonstrated

A complete direct radiometric hot path from integer position, shading normal, material and externally supplied 48-bit visibility data to wide integer linear HDR, with **no floating arithmetic or float conversions inside the core**. Integer sqrt, division, normalization, cosine products, inverse-square distance, source weighting, world term and material multiplication are included. It uses the same three disk lights and 16 source sample positions per light as the current frozen implementation, quantized offline. It does not replace the original reference/tests, and output is approximate.

`integer_light.h` is the portable model; `core.c` exports a standalone translation unit. `frozen/fox_disk_lighting.c` and its header are byte-for-byte copies of the existing reference. Tests call that original reference, not a simplified new formula. `core.o` has no undefined symbols on this GCC/x86-64 host (`nm -u core.o`); this does not prove S3 instruction selection. No target assembly, device run or performance benchmark was performed.

## API and failure semantics

Call `il_scene_valid` on the prepared immutable scene before using `il_eval`. Scene memory/input arrays must remain valid and immutable. Offline scene preparation validates original FoxDiskScene, computes the original disk16 positions in original order, then quantizes. Test preparation code is a fixture, not a production exporter. `il_eval` accepts one pixel; `il_block` is an exact scalar-lane adapter for widths1/2/4/8. `il_hdr19` converts Q24 HDR to the agreed uint32 UQ13.19 display interface, ties-even, rejecting overflow rather than clamping. Outputs remain unchanged on failure (block has independent per-lane statuses).

Status 0 OK; 1 invalid input; 2 conservative plane-domain fallback; 3 sample-distance fallback; 4 arithmetic/range rejection. Keep original data for double fallback: dequantization cannot recover singular/grazing information already lost by conversion. This prototype only reports fallback, it does not silently execute one.

## Scales and admitted domain

- Position/center/sample coordinates: signed32 Q16 metres, every component in [-8,+8]. Differences are up to ±16, not ±8. Original preparation input must satisfy the same range. Runtime coordinates originate from already-quantized geometry; tests include that input quantization error.
- Receiver and emitting normals: signed16 /32767, each component excludes -32768. Squared integer norm must lie in [32762²,32772²]. This admits normalized-vector quantization and limited input tolerance. Runtime normalizes the represented vector using integer sqrt with eight fractional guard bits. Original receiver double normal is independently normalized by frozen reference.
- Reflectance: unsigned storage 0..32767, scale32767. Scene power RGB /π²: unsigned Q16 in [0,256]. World radiance: unsigned Q24 in [0,16]. Those are **new fast-path limits**, not source API limits. No negative powers/materials admitted.
- Direction and clamped-positive cosines: Q2.14. Direction fits signed16. Cosines may reach slightly above16384 from quantization, up to checked16387; they are not silently clamped to one. Original max(0,cosine) behavior is retained at the integer dot-sign stage.
- Inverse squared distance and kernel: unsigned Q24. Reduction/output: uint64 Q24 linear radiance. No saturation.
- Display handoff: uint32 /2^19, approximately [0,8192). Larger direct HDR is rejected by the adapter, even though the core safely represents it. Profile high-clamping is a separate output-stage policy.

## Conservative near-disk admission

Original disk code rejects distance <=1e-9 from the *complete* emitting disk, including nonsampled locations. Q16 metre positions cannot resolve this threshold. The integer fast path instead requires quantized absolute distance from each infinite disk plane to be at least approximately0.127m: abs(dot(center-p, normal_codes)) >=272722101, in Q16×32767 units. This is more conservative than disk distance, rejecting even far-away points close to a disk's extended plane. All three planes are checked regardless of visibility or cosine sign, matching the reference's requirement to admit geometry first.

For properly prepared inputs, each original normal-component error is <=0.5/32767 and each center-minus-position component error <=1/65536. With |delta component|<=16, plane-distance error is conservatively below0.0008m. Therefore accepted0.127m leaves more than the required0.125m clearance from the true disk plane and hence the disk. A separate quantized sample squared-distance check requires at least0.125². This deliberately falls back for many double-valid cases; it is not claimed to preserve original endpoint admission. Normal-domain validation alone cannot authenticate that a supplied scene was generated from the declared source pattern: scene preparation/provenance is required.

## Arithmetic and overflow proof

All signed intermediates are explicitly promoted to int64 before subtraction/multiplication; negative shifts are avoided. Unsigned division rounds to nearest, ties-even, by comparing remainder r with d-r, avoiding 2*r overflow. Signed rounding only receives bounded numerators, never INT64_MIN. All internal divisors are positive after validation. Integer restoring sqrt returns floor sqrt, with a maximum32 digit iterations and no floating helper.

- |coordinate delta|<=2^20; r²=sum(d²)<=3×2^40<2^42. r²<<16<2^58, safe in uint64. Floor sqrt of this value represents distance in position-code units with8 guard bits. Minimum r is8192 position codes.
- Direction numerator d×2^22 has magnitude<=2^42. Division by sqrt(r²<<16) yields Q14 direction; rounding fits [-16384,+16384]. The sqrt truncation at the minimum radius changes this ratio by less than0.008 code before rounding.
- Normal squared lengths are around2^30; shifting16 stays below2^47. Normal-length root is below2^24. Three normal×direction products have absolute sum<=3×32767×16384<2^31. Multiplication by256 before normal-length division stays below2^39. Runtime rejects any positive cosine exceeding16387.
- Reciprocal numerator is2^56, denominator r²>=2^26, so inverse squared distance<=2^30 in Q24.
- cr×cs<2^29; multiplying reciprocal stays below2^59. Reducing by2^28 gives the Q24 kernel. More tightly, kernel<65×2^24. Sixteen-kernel sum<1040×2^24<2^35; ties-even mean remains<65×2^24.
- Power<=256×2^16; power×mean<2^55. After /2^16, three lights plus world remain below(3×256×65+16)×2^24=49936×2^24<2^40. Multiplying rho<=32767 remains<2^55. Final Q24 HDR is safe in uint64. No wide product requires compiler-specific128-bit integers.
- Optional HDR19 rounding divides by32 and checks UINT32_MAX before any narrowing. Max-domain brightness can exceed this interface; this is tested.

These prove integer range safety under the declared contract, **not a universal radiance error bound**. There is no useful uniform relative-error guarantee near zero/grazing or original near-singular endpoints.

## Current source audit and pipeline gaps

`physical/fox_disk_lighting.c` validates finite data, three unit orthogonal emitter bases, positive radius and unbounded finite power; normalizes receiver normals; checks nearest complete-disk distance; evaluates16 cosine/inverse-square samples; applies visibility only to positive kernels; adds unoccluded world then multiplies rho. This model preserves the source pattern/count and radiometric structure but moves source preparation offline and adds explicit fast-domain restrictions.

`transport/bounce.c` is not just this direct kernel. It creates secondary hemisphere directions with sqrt/trigonometry, traces primary/secondary visibility, interpolates/selects materials and normals, handles front/back/grazing decisions, samples world visibility, computes ground emission and ground direct/world reflection, and sums transport terms. Its direct calls zero the world's term before evaluating disks; world contributions are added separately. To use this core there, prepare world=0 for the direct component and preserve the transport accounting. None of that traversal/transport was replaced here. The actual tests below compare direct disks plus the unoccluded world term, not saved final transport RGB.

The earlier converter's coordinates are in native metres, while FoxDiskScene expects Blender-world coordinates. An eventual all-integer integration must explicitly preserve the existing axis/sign transform and dynamic pose/camera semantics. Do not connect equal-looking integer arrays without that basis contract. Integer projection/coverage, visibility traversal, near-plane policy, material decisions, normal interpolation, secondary rays and all HDR merge terms remain separate integration work.

## PIE mapping: candidates, not a speed claim

With eight pixels in lanes, Q15-normal×Q14-direction products can use EE.VMULAS.S16.QACC, three component MACs per dot. Positive cosine pairs also fit signed16 multiplication. Three direction vectors and three receiver-normal vectors consume six128-bit QR registers; two remain for broadcast/light/temp values. Source-normal dot can stream/broadcast common light components and reuse direction registers. Eight-lane QACC is40-bit, ample for these dot products.

Coordinate differences/squares use32/64-bit work; sqrt, reciprocal divisions, Q24 weighting, wide HDR products and accumulation are scalar in this prototype. No generic32-bit PIE multiplication or double SIMD is assumed. Extracting QACC, packing directions and normals, masks, state, eight-lane temporary storage and refilling only eight QR registers all cost work. `il_block` presently loops scalar evaluations, **not** a vectorized implementation, so exact equality across widths establishes semantics only. No claim that integer-only automatically makes the expensive stages SIMD or faster.

## Tests and numeric results

Run `bash run_tests.sh` and `bash run_actual.sh`. GCC14.2, O0/O2, ASan+UBSan, explicit -ffp-contract=off -fexcess-precision=standard -fno-fast-math. Outputs compare byte-identical across optimization levels. Leak detection disabled because LeakSanitizer cannot operate under this environment's ptrace. Floating offline/reference preparation requires FE_TONEAREST; core integer operations are fenv-independent.

Synthetic:2048 varying receivers/normals/materials and explicit masks; zero integer-lane mismatches for1/2/4/8 with lane-varying masks. Absolute radiance maximum3.24564335501e-5, RMS2.57033419672e-6. Separate endpoint, tiny-disk/grazing, maximum-power and HDR-overflow cases are deliberately retained, not mixed into the random aggregate:
- Grazing example: reference5.77863703195e-6 becomes1.54376029968e-5; some positive reference values become zero. Small absolute does not mean small relative error.
- Bright minimum-domain example at0.128m: reference22969.6042889, integer22967.967041, absolute error1.63724791248. HDR19 adapter rejects this safely. At0.25m: reference8662.89740155, error0.00575091894, still rejects HDR19 overflow.
- Near-plane cases from0 through0.127m explicitly fall back. In tilted multi-light scene, another light's plane can still force fallback at0.128m.

Actual saved hit corpus:7678 P/Ns/rho inputs, source position |component|max3.63221167066m. Prepared snapshot light-sample |component|max7.21325278336m, power coefficient max86.123006096. Both are inside new domain; this is observed for this scene only. All7678 admitted, zero invalid/plane/sample/range/HDR19 rejections.

| Mode | Max absolute | RMS absolute | p95 absolute | p99 absolute |
|---|---:|---:|---:|---:|
| All visible | 0.000229430060172 | 0.0000211380113598 | 0.0000424919403949 | 0.0000646817672227 |
| Explicit synthetic masks | 0.000126177599599 | 0.000012864562546 | 0.0000259968719478 | 0.0000408361975506 |

All-visible max HDR5.717700243; synthetic-mask max3.99619871378. Maximum relative error for reference>1e-6 is0.00239369 and0.00239541 respectively. These masks are synthetic, **not actual shadow visibility**. Final RGB565, bounce, ground, world occlusion and end-to-end image parity are not assessed here. See full results for p50/relative metrics. Existing exact acceptance tests were neither edited nor relaxed.

## Provenance

`actual-provenance.json` binds original saved input and snapshot hashes. Snapshot magic KSPX v1 and original FoxDiskScene validator checked; this host fixture reads the documented408-byte51-double scene after the8-byte header. `SHA256SUMS` binds frozen original source, transport source, prototype, binaries and reports. Original files are read-only. All new artifacts reside in this directory; no public writes/device actions.
