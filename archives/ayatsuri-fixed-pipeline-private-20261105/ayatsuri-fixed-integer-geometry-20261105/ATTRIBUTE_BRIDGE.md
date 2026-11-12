# Native source to lighting attribute bridge

New `attribute_bridge.c/.h` connects integer projected barycentrics to the existing integer lighting API without changing frozen geometry sources/results. It calls the existing `fk_scalar` signed16 interpolation kernel and `il_normalize_interpolated` normal bridge. No per-hit float operations or float weight preparation are invoked. `nm -u` of the optimized shared library has no math/runtime arithmetic function imports (recorded in `attributes-undefined-symbols.txt`); this is corroboration, not a target instruction/speed test.

## Callable interface

`ab_prepare(vertices[3], weights[3], frac, backface, visible[3], &hit)` returns `AB_OK`, `AB_INVALID`, `AB_LIGHT_RANGE`, or `AB_NORMAL_FALLBACK`. Output is unchanged on non-OK return. `ab_block` processes independent triangles with counts1/2/4/8, preserving failed lane outputs and returning per-lane statuses.

`ab_vertex` contains native-metre signed32 positions with fraction16/20, projected depth signed32 Q10 metres, unit native normal signed16 divisor32767, and linear reflectance signed16 divisor32767. Weights are nonnegative signed16 Q2.14 with exact sum16384 from geometry `sample`; no floating normalization/re-encoding is performed. Normal input validation uses the existing lighting unit-normal tolerance and excludes -32768; reflectance is0..32767.

`ab_hit.pixel` is directly usable as `il_pixel`: world position Q16, normalized world normal divisor32767, reflectance divisor32767, and **explicit caller-provided** disk16 visibility masks. `ab_hit.native_position` retains an interpolated copy rounded at source precision. `ab_hit.depth_q10` interpolates the three supplied depthQ10 values. Basis conversion is native `(x,y,z)` to Blender/world `(x,-z,-y)` for position and normal. Caller supplies backface0/1; backface negates all world normal components after basis conversion and before integer normalization. The bridge does not infer facing, intersections, material sidedness or visibility.

Position accumulation remains at raw Q(F+14) through the final lightQ16 conversion. The separately returned rounded native position is **not** used as an intermediate, avoiding double rounding. Tests include an explicit Q20 counterexample where retained native code8 would round to lightcode0 but the exact weighted accumulator correctly rounds to lightcode1.

## Domain and arithmetic proof

- Input source positions ≤128m inclusive in absolute component value (codes≤2^27 for F20), matching geometry domain. Input projected depth≤4096m inclusive (Q10 code≤2^22).
- Every weight≤16384, sum16384. Source weighted position accumulators have absolute value≤128×2^F×16384≤2^41; partial sums also lie within this bound by nonnegative weights. Signed64 is sufficient. Nearest-even rounding uses the existing explicit signed integer helper; its preconditions hold and no INT64_MIN negation is possible.
- The **exact weighted hit**, before any output rounding, must lie within±8m componentwise: accumulator magnitude≤8×2^F×16384≤2^37. This is stricter than the geometry source domain because current integer lighting only admits±8m. Reject before narrowing. Native rounded output stays within±8×2^F, and lighting output within±524288. Sign/permutation cannot overflow signed32.
- Final lightQ16 divisor is2^(14+F-16), either2^14 or2^18. Fractionbits20 source precision remains in projection/coverage and the native output, but conversion to lightQ16 loses four fractional bits for lighting coordinates. This is disclosed rather than described as an all-Q20 light path.
- Normal/rho MAC magnitude≤32767×16384<2^29; `fk_scalar` uses signed64, rounds ties even, and convex interpolation remains within component input min/max. Since no source normal component can be -32768, native/world/backface negations are representable signed16. Normalization may change componentwise convex-hull membership, as expected for unit normalization.
- The normal bridge checks squared interpolated length≥512²; near cancellation returns `AB_NORMAL_FALLBACK`, without guessing a face normal. Squared length≤3×32767²<2^32 and shifted squared length<2^48. Normal numerator≤32767×8388352<2^38. The normal bridge validates its final unit codes. Actual semantics and proof of its normalization belong to that module; this bridge does not reimplement it.
- Depth accumulation magnitude≤2^22×16384=2^36; one nearest-even division by16384 returns valid signed32 Q10. This is interpolation of the previously quantized projected depth, not recomputation from a rounded position.
- Each call uses local state and commits only after success. Source/camera/normal policy errors are explicit statuses, not saturation.

## Verification

Run `./run_attributes.sh`. Existing dependency headers require `-Wno-unused-function -Wno-misleading-indentation`; other warnings are errors. Tests run optimized and separately UBSan-instrumented libraries. Both pass5,231 deterministic scalar cases plus independent1/2/4/8 block comparisons and invalid-input checks. Python arbitrary-integer/math.isqrt oracle covers random source positions, exact weights, signed ties, endpoints, source and light bounds, convex-hull preservation of position/depth, basis/sign conversion, backfaces, cancelled normals, explicit masks, and direct-rounding behavior. No image, ray or renderer invocation is involved. Normalization approximation quality is assessed separately by its owning experiment.

## Future depth winner and AA/HDR contract (design only)

DepthQ10 is available for a future integer winner stage. Given the current camera forward axis toward the eye, larger orthographic depth is nearer. A future implementation must define clipping/validity and deterministic identity-based ties (for example stable part/triangle IDs). Q10 can coalesce formerly different depths; equivalence with existing visibility cannot be assumed. This bridge neither selects a winner nor proves a visibility policy.

For AA, resolve/illuminate each covered sample with the explicitly valid surface/background/visibility data, then average **linear HDR**, not tone-mapped RGB565. A practical bounded contract can admit1..16 outer samples, checked-add per-channel Q24 radiance into a wide accumulator, round-nearest-even once by sample count, convert to HDRQ19 once, then apply output mapping. Uncovered samples need an explicit background contribution; do not silently divide only by covered sample count. Before accumulating, either establish a radiance cap B with sample_count×B≤UINT64_MAX or use checked-add and return a range status on overflow. Disk16 averaging inside a light and outer pixel AA averaging are different operations and must not be conflated. Existing profile clamp/error status must remain visible; do not clamp silently. This is a proposed contract, not an implemented AA kernel or quality claim.

No baseline files, frozen geometry artifacts, public repository, device, or denied tree were modified.
