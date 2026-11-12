# Current lid8 bounded transport-point numerical audit (pre-execution contract)

Status: PLAN ONLY. Point-selection rule and final selected IDs are pending owner/audit freeze. No high-density execution or edits to existing artifacts. Geometry baseline is frozen actual-lid8-v2, external certificate a18011982c6e2338368a9e5bafacec6af5a5bad1c1206d05640cb075fcdb62c3. Original images/error maps must not select points, phases, weights, gains, exposures, thresholds or budgets.

## Existing API and minimum diagnostic changes

bounce_eval accepts outer/inner 16 or64; production16/16. Its current direction rule is count16→m2 (two radial rings ×eight azimuths), otherwise m4 (four×sixteen). Merely permitting256 is invalid: m8 (eight×thirty-two) must be explicit. All scene ownership, primary/secondary materials and normals, three DISK16 direct lights, finite source groundLe, BVH intersections, normalization, accumulations and result fields remain identical.

A private diagnostic implementation will add only: explicit256 outer acceptance/m8 and optional separate outer/inner azimuth rotations. Phase0 follows the original arithmetic path without even adding0. Production copies remain baseline behavior; native frame rendering uses the original evaluator. No product feature/default change. First prove old16/64 phase0 results/counters exact on independent known fixtures and actual selected16/16 query replays. Unit direction/norm/cosine-domain checks cover all sample patterns. 256 is higher density, not ground truth or a proven converged estimator.

Five arms, fixed before image/query-buffer inspection:
1.16/16 phase0 (actual baseline replay).
2.64/16 phase0 (outer-only change).
3.64/64 phase0 (inner-only change relative2).
4.256/64 phase0 (outer-only change relative3).
5.256/64 fixed alternate phase: outer0.38196601125 turns, inner0.61803398875 turns, converted using the existing2pi constant. No radial jitter or phase fitting. Arm5 tests one angular alias sensitivity, not all radial/phase bias.

## Actual final-winner capture and replay

Add host observer after successful actual shader return and before clamp/565. Final nearer winners overwrite the same absolute pixel. Capture final winner packet/node, packet-local face, vertex indices, side/frontback, barycentric weights, interpolated mask/sign/material codes, vertex front/back SNORM16, actual world position and exact shader-input unnormalized Ns/rho. Retain actual bounce_result direct/world/bounce/ground/combined and counters through a diagnostic callback, plus generation/material/ground/snapshot binding fingerprints. Preserve the exact values supplied to bounce_eval; do not reconstruct a nominal source surface and assume equality.

Map actual packet/node+face to frozen compiler parts/origins and source IDs only after independently checking native face-index/vertex orientation mapping. Source labels are annotation, not a substitute for the actual winner. No GLB ray is assumed identical. If mapping cannot be proven, report unmapped and do not guess.

First all selected capture frames must reproduce old RGB/depth AND prior final-winner HDR exactly, and compact snapshots/non-timing metadata/pins exactly. No diagnostic result is published from a failed/partial control. Actual frame budgets remain1M/100M/50M direct and20M/800M/300M transport, work8M and snapshot65536B.

Keep owned scene binding alive after ordinary frame/dispose/poison, then replay the selected stored exact query inputs against that SAME owned scene. Separate diagnostic budgets prevent consuming/resetting frame budget. First16/16 replay must match actual captured combined and all four component RGB bit-for-bit, with matching per-query counters; otherwise stop the point/case. This distinguishes a real receiver query from an approximate re-evaluation.

Private winner/query/component buffers contain geometry and remain outside bundles. Their exact allocated byte cost will be reported as diagnostic host RAM, not product fit. Renderer receives no reference images.

## Separate bounded diagnostic budgets

Selection must cap at100 receiver queries per view×case (smaller requested selection preferred). No full raster64-inner rendering. Budget is shared cumulatively over ALL selected points and ALL five arms for that view×case, never reset per point/arm. Predeclared separate diagnostic limits: direct1,000,000 rays/100,000,000 nodes/50,000,000 triangles; transport20,000,000/800,000,000/300,000,000. Existing scene cap262144B, visibility cap524288B and geometry max2048 unchanged. These are separate audited point-experiment caps, not an increase in frame allowances.

Conservative ray-query upper bound per point: direct≤48 per arm; transport outer×(1+48+inner), counting worst case every primary ray produces secondary direct48 and inner world queries:
-16/16:1040
-64/16:4160
-64/64:7232
-256/64:28928 each phase
-Total five arms:70288 transport and240 direct per point; N=100 gives≤7,028,800 transport/24,000 direct rays per case. Actual work can be much lower. Current scene has1023 BVH nodes/1566 triangles including ground. Naive all-tree/all-triangle worst bounds exceed node/triangle budgets; therefore ray bound does NOT guarantee completion. Actual node/tri limits still enforce failures without increasing caps.

Counters retained on failure; result is failure-atomic. Record attempted/complete/failed/unattempted points and arms, exact status, cumulative and incremental rays/nodes/triangles, wall time, and budget settings. Budget exhaustion makes the affected case incomplete; do not average missing arms as zero or silently drop hard points. Do not restart points with fresh unlimited budgets. Any later budget/config change requires a new explicitly labeled experiment and owner review.

## Reporting

Direct/world/bounce/groundLe/combined linear RGB separately. Absolute channel/RGB-L1/RGB-L2/luminance differences first; sign of change and samplewise counters. Any relative error reports denominator and low-luminance exclusion/count, never silently inflates tiny-denominator ratios. Predeclare descriptive luminance bins before querying: Y<=1e-6, (1e-6,1e-4], (1e-4,1e-2], >1e-2 using fixed Rec709 coefficients; absolute errors for every bin, no pass/fail threshold fit. Compare successive arms and both256 phases; report phase spread and any nonmonotonicity. Selected points are not a full-image convergence claim; finite high density is not an oracle. No gainfit, no 60% acceptance claim from sparse points, no product RAM/CPU fit claim.

Next gate: owner/audit freezes point selection before winner buffers are generated/inspected; reviewer closes observer/mapping/diagnostic diff and budget contract; only then capture controls and bounded replay proceed.

## Frozen selection and exact execution order addendum

Owner/audit selection is frozen at fox-v3-transport-point-selection/PLAN.json SHA256 d51dcef666d8c44d583909c3b2499e16d513d83b334f66b85f18a0e0d6c6d8bc. Baseline selects source-group order body/head-muzzle/eyes-lid/ears/tail/legs/other, interior then boundary, first four frozen SHA ranks per stratum, no replacement. Maximum56 points/view,112 unique spatial coordinates, baseline+direction paired224queries/arm. Earlier N≤100 is a conservative API ceiling per view×case, NOT total across views; the actual frozen maximum is56/view×case.

Execution order: view front then oblique; case baseline then direction; manifest group order, interior then boundary, point hash rank (ties y,x); for each point arms1→5 above. Only eligible paired queries execute; mismatch remains blocked and never reselected. All points/arms of each view×case share one fixed cumulative diagnostic direct and transport budget. Exhaustion leaves the case incomplete; successful prefix is not a representative population estimate, and summaries retain failed/unattempted denominator. No point-count reduction/phase dropping to rescue a failed case.

56-point bound per view×case: transport≤3,936,128 ray queries, direct≤13,440. Current1023nodes/1566triangles give conservative all-tree/all-triangle upper bounds transport4,026,658,944node/6,163,976,448tri visits; direct13,749,120nodes/21,047,040tri. These deliberately loose worst bounds exceed chosen transport node/triangle limits, so completion is not guaranteed. Retain proposed20M/800M/300M diagnostic transport limit and1M/100M/50M direct limit unchanged: they bound resource use and admit explicit incomplete outcomes rather than pre-authorizing billions of worst-case visits. Four view/cases combined ray upper≤15,744,512, but each case's budget remains independently accumulated as declared.

Per-query counters come from actual bounce_result and shader-call budget before/after deltas, not frame cumulative counters. Final-winner overwrite updates all query/component/counter fields together. Phase0 original evaluator code remains an unchanged prefix; added diagnostic function is never used by normal frame shader.
