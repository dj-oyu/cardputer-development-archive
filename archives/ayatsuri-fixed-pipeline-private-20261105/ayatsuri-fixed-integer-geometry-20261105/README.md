# Private bounded integer geometry prototype

This new, standalone experiment connects AYFQ fixed source positions to prepared orthographic camera coefficients, integer projection, integer edge/coverage decisions, and signed16 Q2.14 barycentric weights. `geometry.c` contains **no floating-point operation**. `evaluate.py` prepares camera coefficients once per view/frame and provides an independent arbitrary-precision integer oracle and a binary64 source-geometry reference. Nothing is integrated into the renderer, written to a device, or published. All existing source/model trees are read-only inputs.

Run `./run.sh` (host C compiler, Python 3 and NumPy required). Results are in `results.json`; separately instrumented undefined-behavior-sanitizer synthetic tests are in `sanitizer-results.json`. Widths 1/2/4/8 are alternative **scalar batching schedules**, not PIE implementations or evidence of SIMD speedup. There is no target timing claim.

## Admitted numeric domain and scales

- Static baked native-basis metre positions: signed32, fraction bits F = 16 or 20, each component in [-128,128] metres inclusive. This intentionally narrows AYFQ's representable range. Reject outside this experiment's domain, even if AYFQ can encode it.
- Camera input convention matches `ayatsuri_model.c` lines 645–655: eye minus target, normalized forward, right=(forward.z,0,-forward.x), down as the existing cross construction; basis rows stored as binary32. Source geometry has already baked transforms. There is no animated hierarchy transform implementation here.
- Pixel camera rows absorb the legacy world-units conversion 38: native source metres multiply by basis × zoom × 38. Depth row is basis in metres (legacy camera target divided by 38). Depth is output only; visibility ordering, ties, ray intersections, reflection, shading and final color remain outside this experiment.
- Three prepared affine rows: signed32 coefficients in Q20, each absolute coefficient ≤256 pixels/metre for x/y or 256 depth-metres/metre for z. Encoded magnitude ≤2^28. Reference camera setup rejects nonfinite/out-of-domain rows before rounding. Rounding is nearest, ties even.
- Prepared offsets: signed32 Qs, s=8 or 10; each absolute offset ≤4096 pixel/depth units. Offsets are quantized independently of the dot product. This is a deliberate two-rounding choice; an implementation with wider offset storage could combine them before one rounding.
- Dot product: signed64 sum of three signed32×signed32 products. Divide, with explicit nearest-ties-even handling, by 2^(F+20-s), then add the prepared offset. No floating normalization is inserted between stages; no signed right shift, negative left shift, accidental unsigned product or saturation is used.
- Projected x/y/z: signed32 Qs, each absolute coordinate ≤4096. Output outside the domain is rejected, not clipped. Offscreen coordinates within the domain remain legal. This is not a clipping implementation.
- Viewport admitted: width/height 1..2048 inclusive. Actual experiment 240×135. Sample API receives exact Qs screen coordinates within the same ±4096 domain; viewport clipping is a caller operation. Tested samples include negative/offscreen coordinates.
- Edges and triangle area: signed64 subpixel². Projected zero-area triangles have no coverage. Normalize negative winding locally, retaining original vertex index mapping. Positive-oriented edges use `dy < 0 || (dy == 0 && dx > 0)` as inclusive top/left edges for downward screen y. No epsilon or edge bias enters barycentric numerators.
- Barycentrics: covered samples only, nonnegative signed16 Q2.14 codes, each 0..16384 and **exact sum 16384**. Divide `edge*16384` by area, then apportion remaining one/two codes to largest remainders. Ties use projected vertex lexicographic x/y/z order so permutations/winding preserve vertex-associated weights. Weights are ready for the existing signed16 interpolation kernel; there is no double normalization in the hot path.

## Intermediate overflow proof

The following bounds cover all admitted inputs, not just observed source data. C widens operands before every relevant subtract or product. Rejection occurs before dependent arithmetic; outputs are not partially committed on projection or batch failure.

1. Position magnitude ≤128×2^F = 2^(F+7), at most 2^27. Coefficient magnitude ≤2^28. Every product magnitude ≤2^(F+35), at most 2^55. Every partial sum and full dot magnitude ≤3×2^55 <2^57, safely inside signed64. Negating for nearest-even division cannot reach INT64_MIN. Divisor shift is 26,28,30 or32 and safe in signed64. Quotient magnitude ≤3×2^(15+s), and adding ≤2^(12+s) offset remains below2^27 for s≤10, even before screen-range rejection. Thus narrowing only follows an explicit domain check.
2. Let M=4096×2^s=2^(12+s). Accepted coordinates and samples lie in [-M,M]. Any coordinate difference magnitude ≤2M=2^(13+s), computed in signed64. Each edge product magnitude ≤4M². The subtraction magnitude ≤8M²=2^(27+2s), at most2^47 for s=10 (2^43 for s=8). All differences, products, edge signs, area negation and winding normalization are safe.
3. On coverage, each unmodified edge is ≥0 and the exact edge identity is e0+e1+e2=area. Thus each e≤area≤2^47, and numerator `e*16384` ≤2^61, safely signed64. Quotient is0..16384 and each remainder0..area-1. Sum of three floors ≤16384, with deficit0..2. No weight exceeds16384 after apportionment. `int16_t` conversion is safe. Outside samples never enter this division.
4. Camera dimensions and source/batch lengths are validated. Batches contain ≤32 items; indices and memcpy byte counts cannot overflow. Scalar C uses no dynamic allocation. Null pointers are rejected; pointers must otherwise reference the documented number of elements (normal C caller responsibility).

This same straightforward proof **does not admit Q16 screen coordinates**: worst-case edge×16384 would exceed signed64. Finer encoding needs a narrower admitted screen/tile domain, multiword division, or a separately proved scaled reciprocal. No generic widening-free Q16 claim is made.

Worst-case admitted-domain x/y projection error relative to an exact, unquantized affine source is bounded by `768*2^(-F-1) + 384*2^-21 + 2^-s` pixels: source quantization, coefficient quantization using quantized |position|≤128, and two half-subpixel roundings. This is conservative. It is not a coverage or barycentric error bound. Arbitrarily thin triangles can amplify tiny position changes; no finite relative barycentric bound is asserted without an additional area/conditioning constraint.

## Source identity and reference boundary

`evaluate.py` verifies the exact private-fixed-source SHA256, both AYFQ file SHA256s against companion metadata, decoder structure/CRC, 54 part count/order, each source quantization code, each triangle index/order, and the current baseline AYNM file and native executable hashes against both front and oblique command records. 1,163 partition vertices and 1,564 triangles are tested per view/configuration. The source hash binds all material/provenance content; no claim of old AYNM packet-byte identity is inferred from this test.

This is a **geometry-only coverage experiment on the converted source** using the recorded camera convention. Its reference is binary64 projection of the unquantized native source using the existing binary32-stored camera basis. It is not the existing renderer's binary32 projection, clipping, epsilon rules, hierarchical transform evaluation, coverage/AA ledger, depth/visibility or final image. Current binary/model identity verification establishes the chosen baseline inputs, not pixel equivalence.

For each triangle, test the complete union reference/candidate projected bounding box clipped to240×135. Test pixel centers and four quarter-offset samples. Samples outside that union cannot be covered by either triangle. Counts measure **triangle-sample decisions**, not unique visible pixels; occluded and overlapping triangles count independently. Samples not on this five-location grid are untested. Barycentric source error is measured only at the first candidate-covered sample in each tested triangle, and the source may classify that sample outside. It is neither a maximum over all samples nor a final-image error metric.

## Main results

Position F=20:

| Screen fraction | View | Max projected component error (px) | Changed coverage decisions / comparisons | Max source barycentric difference at first covered sample |
|---|---|---:|---:|---:|
| 8 | front | 0.00365563749 | 148 / 468410 | 0.1632007075 |
| 8 | oblique | 0.00333518027 | 158 / 456140 | 0.1397540101 |
| 10 | front | 0.000756741316 | 28 / 468410 | 0.03134364252 |
| 10 | oblique | 0.000898330019 | 44 / 456140 | 0.01880550394 |

Position F=16 with screen Q10 gives36 changed front and52 changed oblique decisions, max projection error0.000942894347 /0.00108579177 px. Full eight configurations and exact hashes are in `results.json`. No source or projected triangle collapsed in these actual cases, but synthetic zero-area and unit-area projected triangles are explicitly handled. No bit-exact old coverage claim follows.

Synthetic tests include 13,900 random projection/edge oracle cases for each screen encoding, plus explicit positive/negative nearest-even ties, shared diagonal ownership, top/left ties, negative/offscreen samples, one-code area, degenerates, admitted maxima, range rejection, all six triangle permutations/winding, partial batches and 1/2/4/8 exact agreement. UBSan repeats these tests using separately instrumented C libraries. Actual parts also test all four projection batch widths against the integer oracle. First-covered actual barycentrics are compared through all four sample batch widths. Integer-triangle Q2.14 weight quantization error is independently checked <1/16384; the much larger source barycentric errors above arise from changed geometry, not a broken normalization sum.

## PIE assessment and next gate

Integer continuity is feasible within explicit bounds, and Q10 reduces coverage changes versus Q8 in this source. It does **not** make generic projection/coverage an8×16-bit multiplication problem: source positions and camera coefficients require signed32; projection and edges require wide64, and barycentrics require division. PIE8×16 is naturally applicable to the resulting Q2.14 weights and bounded signed16 normals/colors. Projecting with narrowed/rebased signed16 positions or using tile-local edges would be a different kernel with a separate range proof and conversion cost. Current geometry precision must not be silently discarded to fit an instruction.

Before production: decide allowed geometric/coverage error; examine thin triangle handling/conditioning; select screen precision and clipping contract; retain source identity; implement target kernels and integer depth/visibility policy; measure whole-frame speed including preparation/conversion and cache traffic. Preserve the floating renderer as a comparison path. No device work, renderer run or public change is part of this experiment.

## Error decomposition and mixed precision

Measured maxima are separate effects, not necessarily attained at the same vertex; they must not be subtracted from total error as if they were correlated:

| Position fraction | View | Source quantization only, pixels | Camera coefficient quantization only, pixels |
|---|---|---:|---:|
|16|front|0.000234883728|0.00000115256803|
|16|oblique|0.000286985977|0.00000111449143|
|20|front|0.0000152145548|0.00000115256928|
|20|oblique|0.0000175728556|0.00000111449268|

For screen Q10, independent offset quantization is0.000258915201 px front /0.000409481859 px oblique; final dot rounding is at most0.000488235 px in these cases. For Q8, offsets contribute0.00169420980 /0.00138604436 px and final dot rounding approaches0.001953125 px. Thus improving source F16→F20 helps, but the chosen screen representation and separately rounded offset dominate total positional error here. Combining offset and dot rounding is a possible further improvement, not implemented or claimed by these results.

For integer-triangle barycentrics, apportionment alone is strictly within1/16384 per component; measured maxima at the inspected actual samples are approximately0.0000404. These are distinct from up to0.03134/0.01881 source-vs-candidate barycentric changes at screen Q10 caused by geometric conditioning. A source-Q20 label does not solve a thin projected triangle's sensitivity.

Selective Q20 at edges or faces is not yet shown necessary:

- Existing source Q16 and Q20 both store three signed32 position codes, so selective source precision saves **zero bytes** in this format. Higher precision does not make the generic position multiplies signed16-compatible. Full Q20 source is the simpler current candidate.
- Q16 source with Q10 screen changed36/52 front/oblique decisions; Q20 source with Q8 screen changed148/158. In these cases, finer screen precision helps much more than a source-only precision upgrade. Effects need not be monotonic for each sample or scene.
- Shared physical vertices/edges need a consistent final projected grid across triangles and partitions. Independently rendering adjacent triangles on different grids can create cracks or double ownership despite each grid having correct top-left semantics. A higher-precision common projected representation, deterministic shared-vertex precision assignment, or proved conservative fallback policy is required. Vertex duplication in source partitions makes consistency especially important.
- Promoting already-quantized source Q16 values to Q20 only appends zero low bits; it cannot recover discarded source information. Retain higher-precision source if adaptive high precision is an intended path.
- Silhouettes and near-sample edges change with view, camera motion and deformation. A permanent “face” or “edge” semantic tag may reflect visual importance but is not a numerical error guarantee. Thin projected triangles or proximity of edge values to sample decisions are more direct numerical signals.
- A future adaptive policy might retain source Q20, use a common projected grid, and select a wider scalar calculation or finer grid only for ill-conditioned/near-boundary primitives, with shared-edge consistency and transition behavior proved. This is a proposed direction, not implemented validation. It adds branches/preparation and may weaken SIMD benefits; target measurements are still needed.

There is no asserted requirement for heuristic precision patches until an acceptable coverage/image-error policy is chosen. Q10 is merely a tested compromise with nonzero differences, not a declared production accuracy contract.
