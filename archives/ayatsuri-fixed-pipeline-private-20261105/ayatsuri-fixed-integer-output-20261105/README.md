# Integer HDR to RGB565 research prototype

Status: host correctness prototype, not firmware integration or a target-speed claim.
No device access, public operation, or modification of prior sources was performed.

## Boundary with upstream integer lighting

`integer_output(cache, profile, uint32_t rgb[3], uint16_t *pixel)` consumes unsigned
UQ13.19: code / 524288, representable real range 0 through 8191.999998092651.
It never converts to float. Upstream Q24 lighting can round ties-to-even right by
5 bits with a checked overflow into this format. Reject/fallback on negative,
nonfinite conversion input or a result above UINT32_MAX; never wrap/silently
saturate. The observed HDR maximum near 5.8678 is NOT an admission bound.

Profile-domain high clamp is explicit and returns AGX_PROFILE_CLAMP_HIGH (1).
The high_code is floor(profile HI * 2^19), so any integer input strictly above
profile HI is flagged. Domain exceeding UQ13.19 is unsupported by this API even
if a floating profile could clamp it; the upstream stage must handle that case
explicitly. The sibling direct-light prototype admits some radiance above this
format, so its checked conversion/fallback remains required.

Success/flag1 writes one RGB565 pixel; invalid argument (2) and decode error (3)
leave it untouched. Inputs, configuration and cache are caller-owned, live and
nonoverlapping; configuration is trusted output of offline preparation, not
an unvalidated input-data format. Cache state can change on a decode failure.
The direct-light-only sibling does not cover visibility/transport/AA, and this
prototype does not establish a full fixed-point scene-rendering equivalence.

## Shaper and rounding contract

Offline prepare.py creates PRIVATE shaper nodes from the pinned original log1p
profile function. Runtime uses exact nodes for codes0..256 and 24 power-of-two
bands with 256 intervals each, indexed using CLZ. Nodes and interpolated
coordinates are Q16 LUT-cell coordinates. The 6,425 uint32 nodes cost 25,700 B;
this is additional to the original compressed LUT and scalar decoder cache.
Endpoint log values are generated UNCLAMPED; runtime clamps input before
interpolation. Clamping table endpoints prematurely would introduce an extra
error at the high-domain crossing and is deliberately avoided.

For x>=256, interval relative width is at most1/256. With K=64/log_range,
|u''(x)| <= K/(lo+x)^2 gives linear interpolation error <=K/(8*256^2).
Rounded endpoints contribute <=0.5/65536 and integer interpolation rounding
<=0.5/65536. Total coordinate error bound at the quantized input is
K/(8*256^2)+1/65536 = about2.231e-5 LUT cells for this profile.
Codes0..256 use rounded exact nodes, with <=0.5/65536 error.
The table and interpolation are monotone nondecreasing, including band joins.
No monotonic RGB-output claim follows: the source 3D color transform need not
be channelwise monotone. Real-to-Q19 conversion adds at most2^-20 HDR absolute
error for nearest rounding, and at most about0.020038 LUT-cell error near zero;
this is larger than the interpolation error. At large radiance its effect is
much smaller. Float baseline conversion/arithmetic is an additional distinct
source of threshold differences.

## Tetrahedron and overflow contract

The same strict-`>` pairwise sort as the original orders fractional coordinates;
exact ties preserve original algorithm behavior. Near-ties may swap under
quantization. Shared tetrahedral faces remain continuous in exact arithmetic,
so near-tie ordering is not assumed bit-identical to float.

The four barycentric weights are [65536-f0,f0-f1,f1-f2,f2] after descending sort.
They are nonnegative, <=65536, and sum exactly65536. Every LUT channel is uint16;
each product and the complete nonnegative accumulation are bounded by
65535*65536 =4,294,901,760 < UINT32_MAX. No signed16 delta assumption is used.
The accumulation is quantized directly to31/63/31 with integer round-half-up;
the numerator (accumulator*63 + denominator/2) fits uint64. There is no extra
rounded uint16 display intermediary. Vertices remain inside the65^3 cube.
Shaper delta*remainder also uses uint64; uint32 multiplication is not assumed
safe. 64-cell endpoint uses base63 and fraction65536, never an out-of-range
base64 cell. Configuration/node generation and all input-code arithmetic have
explicit bounds; the decoder retains its existing checks.

Without a stronger profile-specific edge bound, normalized piecewise-linear
LUT output is1-Lipschitz per input coordinate because every edge channel
difference is <=1. Sum of three coordinate errors therefore bounds normalized
output error. This conservative analytic bound is much looser than observed
one-code differences and does not prove universal RGB565 equality. No finite
sample set proves all possible colors have maximum one-code error.

## Correctness evidence

`tests/run.sh` rebuilds private generated data, compares, and runs sanitizer
contracts. Reference is the pinned original float cache evaluator plus original
lroundf display packing. Its reconstructed results match ALL40 saved RGB565
images exactly, establishing that the comparison baseline really reproduces
the saved output rather than only a similar oracle.

- Saved40 images:1,296,000 pixels;44 changed RGB565 pixels (0.0033951%).
- Maximum RGB565 channel-code delta:[1,1,1].
- Input quantization alone changes42 pixels. Integer evaluation versus the
  float evaluator at the same Q19 input changes58. These counts overlap and
  cancel; they must not be added to explain44.
- Synthetic boundary/permutation/log-random set:31,477 pixels;2 changes,
  max channel delta[0,1,0]; integer versus float at quantized input:0 changes.
  This includes zero, LUT knots/neighbors, channel permutations/ties, high
  clamp and UINT32_MAX input.1,296 synthetic pixels return high-clamp flag.
-276,480 checked shaper codes are monotone. Maximum sampled coordinate error
  excluding real-input quantization:2.0210764e-5, below analytic2.231e-5 bound.
- ASan+UBSan contract run passes (leak detector disabled); null/alias rejection,
  error atomicity, high-clamp boundaries, six permutations and100,000 gray
  cases covered. This is not exhaustive fault injection of the reused decoder.
- Standalone optimized integer_output.o has only agx_cache_fetch4 unresolved;
  no libm calls. Runtime source uses only integer operations. Tests/offline
  preparation intentionally use float. No runtime measurement was taken.

Per-image metrics, source/frame SHA256 pins, generated table and binaries are
in private/. Never publish private/: profile redistribution permission is
unconfirmed. No LUT, original asset or rendered image is included in code/.
The generic code also depends on the existing decoder source, copied locally;
this is not a clearance decision for redistributing that source.

## PIE/SIMD implications

Four uint32 lanes can naturally batch additions, compares, clamp and masks.
Shaper table lookup/CLZ and four-vertex gather still need implementation-specific
support or scalar work. Barycentric weights can equal65536, so they are NOT
unconditionally uint16. LUT values and differences also do not fit signed16.
An eight16-lane interpolation scheme needs unsigned widening products and a
32-bit accumulation proof, plus explicit endpoint handling or a revised Q15
contract. Ordinary signed16 multiply-add would be incorrect here. Final packing
and shaper interpolation use64-bit intermediates/division in this reference;
generic32 multiply support is not evidence for accelerating those operations.
The scalar compressed decoder/cache can dominate and remains unchanged. No
ESP32-S3/PIE speedup, whole-device fit or production acceptance is claimed.
