# Integer visibility and shadow predicate study

## Decision

A coherent integer visibility path is feasible, but Q20 triangle predicates are not a simple 16-bit PIE substitution. Keep one shared quantized vertex lattice across adjacent faces, BVH bounds, primary geometry and shadow geometry. Use integer broad-phase/interval filters and an explicitly wider exact or floating fallback for unresolved predicates. Do not quantize individual face planes/edges independently and assume the old double renderer remains equivalent.

This study implements bounded integer triangle and box predicates, not a full replacement BVH or rendered scene. It ran 64,009 synthetic predicate/oracle cases total, no scene rays, full renders, device tests or benchmarks. Only permitted visibility.c/h and already frozen preflight exports were read as task source data.

## Existing behavior that must be preserved or explicitly versioned

`fox-v3-indexed-bvh-bounds/private-build/visibility/visibility.c`:

- 74–78: centroid sorting stable by original triangle ordinal.
- 83–105,111–112: BVH bounds are exact owned vertex witnesses; tree median split, leaves <=4.
- 144–161: current source admits finite coordinates up to1e50 and rejects zero-cross triangles. This is far wider than any proposed fast fixed domain.
- 190–193: inclusive slab box test, exact zero direction special case, division in double.
- 195–208,236–248: dominant-axis projected/sheared edge tests, inclusive edges, two-sided. Segment test distance is strictly between endpoint epsilon limits; nearest test is strictly >epsilon and <=far.
- 220–230: segment direction is normalized, segments of length<=2epsilon rejected, both endpoints excluded.
- 261–270: nearest unit input tolerance1e-12, accepted direction normalized, far bound derived from root sphere with nextafter margin.
- 282–292: nearest tie is exact double distance equality then smaller original triangle ordinal. Far expands outward so equal-distance candidates are not culled by slab roundoff.

`visibility.h:10–13,63–94`: vertex/triangle/node bounds4096/2048/4095; world epsilon1e-5m; generation/lifetime/budget and failure-atomic output contracts. Failure must never be interpreted as unoccluded. Integer representation requires new geometry/pose generation identities, not old float fingerprints.

## Exact arithmetic bounds

All prototype vertices AND segment endpoints lie in [-8,+8] metres, integer lattice step2^-F. Every difference is at most D=16·2^F ticks. The scalar triple product is a sum of six signed products, so magnitude<=6D³. This is an intentionally conservative proof independent of cancellation.

| Quantity | Q16 | Q20 |
|---|---:|---:|
| D | 1048576 | 16777216 |
| Cross component bound2D² | 2199023255552 | 562949953421312 |
| Triple bound6D³ | 6917529027641081856 | 28334198897217871282176 |
| Signed bits for triple bound |64|76|
| Signed bits for product of two triple bounds |127|151|
| epsilon in ticks |0.65536|10.48576|

Q16 individual cubic determinants fit signed64 narrowly; Q20 requires wider than64. Comparing two rational hit distances by naive cross multiplication can require signed151 bits for Q20, so even __int128 is insufficient for that generic comparison. The prototype uses exact Euclidean quotient/remainder rational comparison, avoiding multiplication and terminating as denominators decrease. Q16 naive comparison fits signed128 within this domain. Do not generalize determinant fit to all expressions: adding two maximum Q16 determinants can overflow64. A narrow implementation must test v<=det then u<=det-v, or widen the addition.

The prototype uses __int128 for all triple work and 128-bit Euclidean ratio comparisons. Box slab intervals use exact signed differences and positive denominators; inclusive rational intersection with [0,1] avoids approximate reciprocals. Dot-length squared<=3D² fits U64. Integer sqrt brackets length by floor/ceil. All admitted arithmetic bounds are explicit; out-of-domain values return a status, never clamp.

Actual frozen geometry is not wholly inside8m: character maxabs3.6494783100328947m, but four ground vertices are at±100m. A dedicated analytic floor, larger proven format or explicit fallback is mandatory. Light endpoints, ray origins and extents also need independent admission, not just character vertices. A local tile origin can reduce coordinate magnitude but cannot shrink a long segment or triangle edge automatically.

## Prototype contract

`predicate.c` exports:

- `qtriangle(int32[15], F, uint64[5])`: three triangle vertices then segment origin/end. Exact inclusive barycentric determinant signs. Returns0 miss,1 hit,2 epsilon interval unresolved,3 unsupported F/out-of-domain/conservatively too-short segment. Output on an accepted geometric candidate contains numerator/denominator high/low U64 halves, plus whether all individual determinant values fit signed64. This does not imply all a real64-bit implementation's intermediate expressions fit.
- `qbox(int32[12], F)`: lo,hi,origin,end. Conservative inclusive segment-vs-AABB broad phase; no epsilon clipping here, so a true narrow hit is not discarded by endpoint rounding.
- `qratio_compare`: exact positive rational comparison with up to128-bit values, no overflowing cross multiplication. Equal ratio results can then use original triangle ordinal for deterministic ownership.

Positions are EXACT integer lattice inputs. This is not an error interval enclosing the original Blender/F32 positions. It therefore establishes correctness for the new lattice contract, not equivalence to the original unquantized surface.

The near-endpoint physical distance is min(t,1-t)·sqrt(lengthSquared)/2^F. Epsilon=1/100000m is retained as a rational, not rounded to an integer tick. Floor/ceil sqrt produce an enclosing threshold interval. A value strictly beyond the upper threshold is a definite hit; a value at/below the lower threshold is a definite miss; otherwise status2 requests a refined/exact/floating path. The conservative short-segment status3 can also occur in a tiny interval around the minimum length; a caller preserving the broad source domain must fallback/recheck, not silently return clear. No fallback is executed secretly by this prototype.

A fully exact squared comparison can resolve the remaining epsilon case using multiword arithmetic, but intermediate degree and widths must be reproved. Using floating fallback is practical only if its semantics are stated: either exact-lattice predicate resolution, or compatibility with the prior float predicate. They are not interchangeable.

## Evidence

`reference.c` includes the unchanged permitted visibility.c and calls its actual static tri_hit as the float comparator; no edited imitation of its formula. `test_predicates.py` compares the integer kernel with Python arbitrary-precision determinant and squared-epsilon oracle and Fraction box/rational oracle.

- 20000 random Q16 triangle cases:1890 hits, no unresolved/domain cases, no mismatches with exact oracle or current double hit classification;1890/1890 accepted determinant sets fit64.
- 20000 random Q20 triangle cases:1815 hits, no unresolved/domain cases, no oracle/double hit mismatches;0/1815 accepted determinant sets fit64.
- 1000 shared-diagonal pairs each format (4000 triangle calls): integer accepts both neighbors in all pairs. Existing double accepts both only375(Q16)/362(Q20); it never rejects both. Thus watertight coverage does NOT establish the same winning primitive. Inclusive exact edge ownership can select a lower ordinal previously rejected by floating edge rounding, changing material/shading normal/bounce behavior.
- 10000 exact box cases and10000 up-to76-bit rational comparisons pass their arbitrary-precision oracles.
- Additional endpoint tests show an explicit unresolved interval: Q20 segment dx31,dz3 ticks crossing a plane one z-tick from origin returns2; exact near distance10.3816077 ticks is below epsilon10.48576. Adjacent dx30 is definite miss, dx32 definite hit.
- 64009 total cases across runs. `RESULT.json` preserves the initial64005-case result; `BOUNDARIES.json` records4 additional cases. Inputs and seeds are reproducible. This is not a performance/fallback-rate estimate for real scenes.

Fallback frequency can only be quantified for this corpus:0/40000 random triangle cases unresolved; deliberately difficult endpoint cases include1 unresolved among4 added tests. Domain fallback is certain for the current four floor vertices under±8m admission. No real rendered/shadow ray population was sampled, so no production fallback percentage is claimed.

## Watertight mixed-precision design

Quantize a shared vertex ID once, globally or within an explicitly shared lattice. The same world position must be used by every adjacent triangle and every BVH bound witness. Preserve original triangle ordinal and do not weld distinct hard-normal/material identity just because positions coincide.

Face-only Q20 or independently rounded edge/plane coefficients can move a common boundary differently on either side. Resulting cracks/overlap can change any-hit shadows; nearest-hit changes can alter material, physical side, normal and secondary rays even when silhouettes look identical. If mixed Q16/Q20 storage is desired, promote Q16 coordinates exactly onto the common Q20 lattice, promote all shared vertices coherently, rebuild conservative bounds from that same representation and prove shared-edge predicates use identical arithmetic. A face-quality heuristic alone is insufficient.

For preserving original surface uncertainty rather than adopting new geometry, BVH bounds need outward-rounded/expanded intervals that include the original coordinates and deformation/transform error. Rounding min/max to nearest is unsafe. Robust interval predicates must carry those input errors, not only arithmetic-rounding error. Any uncertain cull/hit/tie goes to the documented wider path.

Nearest traversal should retain rational distance until selection, compare exact ratios with a safe method, and apply ordinal tie rules. Keep far-bound inclusion conservative so equal-distance candidates remain traversable. Convert distance/barycentrics/geometric normals only at the explicit next-stage boundary. Integer visibility alone does not remove floating shading normal normalization, ray-direction construction or physical lighting.

## PIE suitability and next implementation boundary

Good candidates: SIMD integer AABB interval rejection, batched coherent shadow-ray setup, shared-vertex gathers, coarse signed edge/dot interval filters and active-lane masks. Poor direct candidates: data-dependent BVH traversal, long-division rational comparison and software128-bit exact determinants. ±8m Q16 coordinates already need21 signed bits including inclusive extrema (differences need22 signed bits); they do not fit16-bit lanes without a tighter local range or a different scale. Q20 magnifies this issue. No native128-bit PIE throughput or speed gain is assumed.

Recommended path: keep Q20/shared topology as canonical geometry; build a conservative packed32-bit integer BVH/broad phase; use certified bounded local blocks or interval filters for SIMD triangle rejection; send uncertain/grazing/overflow/tie lanes to scalar wider exact code. Measure fallback rate on separately approved bounded representative rays before claiming acceleration. For full integer mode, replace that fallback with a proven multiword kernel and separately address direction normalization and endpoint distance. The first implementation target should be robust any-hit segment shadows, then nearest hits with ordinal/material consistency and matching budget/generation behavior.

No old files, frozen preflight outputs, gates or device state were changed. Source hashes and exact bounds are in BOUNDS.json; final artifact hashes in FREEZE.json.
