# Independent integer hemisphere/reduction arithmetic

## Security and task boundary

This module performs **only pure fixed-input arithmetic verification**. It creates no rays, calls no visibility or BVH API, changes no geometry ownership, and integrates nothing into a renderer/frame. Previously denied ownership/context work is not retried or reimplemented. Any future connection to visibility, scene lifetime or real rendering requires separate review/confirmation; this artifact is not permission to do that. No device/public operations occurred.

It demonstrates16 direction vectors from an integer interpolated normal, and a separate reduction over explicitly supplied radiance terms. A direction vector is only an arithmetic result here. Even tiny angle errors can change silhouettes, intersections, blocker identity or reflection samples. Saved hits/masks cannot be presumed valid for changed directions. Direction-angle accuracy is **not** reflection/shadow quality.

## Interfaces

`integer_reflection.h`:
- `hr_directions16(interpolated_int16[3],out_int16[16][3],basis*)`: output /32767 unit direction codes in the original16 sample order. Input raw/interpolated normal has a common scale, usually /32767. The normal bridge rejects magnitude<512codes. Apply required coordinate-basis mapping before this call.
- `hr_block`: exact scalar adapter for widths1/2/4/8. Tests rotate input components per lane and compare each result against its scalar evaluation. This is not SIMD assembly.
- Status0 OK;1 nearzero;2 range;3 ambiguous basis. For3, candidate vectors are returned **for diagnostics only**, not as accepted rays/directions for downstream queries. For1/2 output remains unchanged. Basis output is written only with valid diagnostic vectors.
- `hr_reduce16(sample[16],rhoPrimary[3],out_uint64[3])`: pure reduction of supplied fixed inputs, below.
- `hr_reduce_block`: exact scalar1/2/4/8 reduction adapter, tested with lane-varying primary reflectance.

No interfaces expose scene/geometry/hit objects or visibility functions.

## Direction arithmetic and source fidelity

`frozen_direction.h` contains exact excerpts of dot, norm, cross and direction from the allowed `transport/bounce.c`; the source is unmodified. Reference uses original16 formula: two radial rings r=sqrt((ring+.5)/2), eight azimuths, odd ring half-angle offset, z=sqrt(1-r²). Offline C generator produces nearest-even signed32767-scale coefficients and saves them in `hemisphere_constants.h`. Neither runtime source nor integer core calls sin/cos/sqrt from libm.

The candidate first integer-normalizes the raw vector. The basis index is chosen from the **raw** integer component magnitudes before that normalization. It constructs u by ref-axis×n and integer-normalizes u. v=n×u is retained in signed32, not clipped or renormalized. The linear combination uses the original16 precomputed coefficients. To preserve range safely, its common scale is halved before final integer normalization; the half-scale is common to all components, not per-component saturation. Quantization differs from double and introduces measurable error.

### Basis theorem and its limits

Positive mathematical normalization preserves absolute-component order. Direct component round-to-nearest/ties-even quantization of raw Ns has monotone absolute magnitude. Thus a **unique minimum raw code** preserves the minimum of the original raw component magnitudes under exact mathematical normalization. Exact ties in the smallest raw codes can hide source ordering differences and are flagged conservatively. This removes extra branch ambiguity introduced by normalizing/rounding first.

This theorem is intentionally **not a universal parity claim for the existing floating-point norm implementation**: extremely close source values may theoretically collapse into a tie during floating normalization, and adjacent raw codes may straddle a rounding boundary with arbitrarily small source separation. Actual observed source-basis agreement is reported, not promoted to a proof. Likewise, when Q14 interpolation, source geometry quantization or other prior operations changed Ns, the theorem applies only to represented raw input, not to the original renderer's Ns. A production policy needs a separately validated input/error contract or broader rejection rule. No basis flag guarantees validity of saved hits.

Near ties matter: one synthetic pair differs only by1e-8 yet a same-index candidate direction differs by97.182°; another case gives77.603°. Both are flagged. Poles/axis normals also have mathematically tied minima and conservatively return status3, even when the diagnostic direction closely matches the old formula. This is deliberate and visible.

## Range and rounding

Integer normal bridge is reused unchanged from `ayatsuri-fixed-integer-light-20261105/normal_bridge.h`; see its proof. Every normalize uses guarded integer square root and nearest/ties-even division. It admits input magnitude>=512codes and outputs length below32768.1161codes. No floating-point rounding mode affects runtime integer arithmetic; offline/reference preparation requires FE_TONEAREST.

Cross(ref,n) only reorders/signs near-unit codes, which exclude -32768. The least-component basis makes its true magnitude safely nonzero; runtime normalization still checks the threshold. Each v cross-product numerator is a difference of two signed16 products, magnitude below2^31, evaluated in int64. From |n|,|u|<32768.1161, normalized cross magnitude before component rounding is below32769.233codes; after rounding each component is below32769.733. The declared check allows±32772 in signed32. The initial attempt to narrow v to16bits rejected15 real inputs; widening avoids that artificial failure without clipping or altering the original cross structure. It does mean this substep is not a pure16-bit PIE path.

Each direction combination contains three products, bounded by3×32767×32772<2^32, evaluated in int64. Division by65534 gives a common half-scale. With unit-length coefficient vector rounded at mostsqrt(3)/2codes and bounded basis-vector lengths, Cauchy-Schwarz bounds each resulting component below28383, within signed16. Runtime checks remain before narrowing, and final normalization guards nearzero/range. No signed-overflow UB, negative shifts, unchecked narrowing or silent saturation is used. This proves storage arithmetic safety, not a universal final direction-angle bound across branch changes.

## Fixed reflection-sample reduction

`hr_fixed_sample` contains uint32 Q19 `direct[3]`, uint32 Q19 `world[3]`, uint16 /32767 `rho_secondary[3]`, and an active0/1 flag. Caller supplies these fixed values; active is not computed via a query. Primary rho is0..32767. The mathematical term follows the existing pure bounce accumulation:

sum over16 active samples of rhoPrimary × (direct + rhoSecondary × world) /16.

Each secondary world/material product is rounded nearest-even to Q19, then primary multiplication is rounded, then the16 sample values are summed wide and the mean rounded. This is approximate fixed arithmetic, not bit-exact floating association. Output is uint64 Q19; no clamp to a display encoding.

Bounds: individual radiance<=2^32-1; world×rho<2^47; secondary sum<2^33; primary product<2^48; accumulated16 terms<2^37. Output<=2^33-2 in Q19, approximately16384 radiance. All intermediates fit uint64. Materials/flags are validated before output is written. Against the exact-real formula, at most1.5 Q19 codes absolute error results from the two per-sample rounds and final mean; measured frozen floating expression is separately reported. Zero/inactive/invalid-material/invalid-flag and scalar1/2/4/8 cases are tested.

**Missing actual reflection interface:** the saved7678 corpus provides P/Ns/rho, not the original16 reflection directions, hit/miss records and per-sample direct/secondary-world radiance terms with immutable provenance. Saved finalHDR cannot reconstruct these. Therefore only synthetic fixed reduction is tested; there is no actual reflected-light, shadow or bounce quality claim. Capturing or recomputing these through renderer/visibility changes is outside this authorized scope and was not attempted.

## Results

`bash run_tests.sh`: GCC14.2 O0/O2 + ASan/UBSan, explicit no-fast-math, contraction-off and standard excess precision. Outputs match byte-for-byte. Leak detection is disabled only for the known ptrace limitation.

Actual raw Ns corpus (component quantization first, no float-normalization before candidate):
-7678 normals, all7678 status0,0 ambiguous,0 failed;0 observed basis changes versus original floating source.
-122848 candidate directions, max angular error0.00689222572122°, RMS0.00207939148529°, p950.00350099336156°, p990.00425191779076°.
-Scalar1/2/4/8 lane agreement exact.

Synthetic boundaries cover poles, axes, equal/near-equal components, grazing components, zero/nearzero and the large flagged basis discontinuities described above. Synthetic fixed reduction:30000 channels, max absolute radiance error1.39193753057e-6, RMS5.62064540622e-7. No final image quality is inferred.

`basis-comparison.txt`: final raw-code basis vs retained wide-v/normalized-code-basis version has0 actual direction-bit changes and0 actual basis changes;1 conservative flag is removed. Historical initial15 range failures are retained as transcript-derived evidence in `HISTORICAL_INITIAL_RANGE.md`; the next wide-v version's source/binaries/results are retained under `historical-wide-normalized-axis/`.

## Integer object inspection and performance limits

`core.c` exports only the direction arithmetic and fixed reduction. Compiled with no LTO/vectorization; `core-undefined.txt` is empty on this host. Raw object disassembly is retained; a mnemonic scan finds no floating arithmetic/conversion instructions. SIMD register/memory moves are not float arithmetic. This is an x86-64 object observation, not target/S3 instruction evidence or a formal compiler proof.

Direction generation uses18 integer normalizations (input,u,16 outputs), hence18 integer square roots and54 variable-divisor rounding pairs, plus3 cross-component divisions and48 combination divisions by fixed constants. v needs signed32; final coefficient combination uses64-bit accumulation. Only some16-bit multiplies/SoA work map naturally to PIE; root/division and packing costs remain. No operation-count-to-speed inference or benchmark is supplied.

## Reproduction/provenance and future integration contract

Original source and saved-input hashes are in `SHA256SUMS`; original source files are read-only. Actual input records are the existing private9-double P/Ns/rho stream, with source provenance in the earlier lighting module. These tests use Ns only. `generate_constants.c` binds the offline coefficient formula; frozen reference remains unchanged.

Before any future integration, separate authorization/review must cover the exact renderer/visibility work. The technical contract would additionally require agreed input basis, normal-interpolation scaling/error, basis ambiguity policy, unchanged16 sample ordering, per-sample source identity/visibility/radiance provenance, wide-HDR merge scaling, explicit fallback, and end-to-end reference criteria. Nothing in this arithmetic module supplies those missing permissions or validates changed-direction old masks/hits.
