# Current lid8 bounded transport point audit

## Result and limits

All 224 original16/16 receiver-query replays match the actual shader components, counters and consumed work exactly. All1120 five-arm queries complete, no failures or unattempted queries. Direct light is bit-exact across every sampling arm. The original four frame RGB/depth/HDR/snapshot outputs and non-timing metadata remain exact.

The finite sampling ladder changes selected linear-HDR values, predominantly outer-sampling sensitivity, but it does not establish truth, full-image convergence or improvement toward the60% image goal. Higher density does not consistently improve stable post-label classification. No immediate full-frame/product high-sample implementation is recommended by this diagnostic alone.

## Frozen contract and controls

Selection was frozen before winner capture/transport results: seven source-object groups × interior/boundary × four hashed-rank points × two views =112 spatial points, reused for baseline/direction =224queries/arm. No deficits, replacement, reference RGB, precision-mask selection, error fitting or gain/exposure adjustment. Source labels were attached only after actual compact-index→rawpatch→compiler source-face/world correspondence was checked for all19,710 covered winner records. Baseline selects, paired direction inputs match exactly. Source foreground/stability labels are later annotations only.

Native coverage remains4698 front/5157 oblique; original source foreground missing620/719 pixels is outside this covered-receiver sample. Stratified point means are NOT pixel-area-weighted image means. The source Anatomy object remains body even where anatomically head. All selected uncertain points remain unknown/non-PASS, never omitted from the reported denominator.

Observer records actual successful shader return before output clamp, last depth winner overwrite, exact world P/unnormalized Ns/rho, physical side, palettes/masks/SNORM vertices, components and per-shader budget deltas. It captures no approximate GLB ray surrogate. Fresh capture002 adds an explicit source/patch vertex-count guard. Initial Python3.12 sum reconstruction was replaced with explicit C-order += accumulation to avoid compensated-sum differences; captured data were not changed.

Original bounce_eval is an exact unchanged source prefix. Private diagnostic function alone adds explicit256→m8 and angular phase arguments; original16/64 phase0 arithmetic is retained without adding zero. Fixture suite includes36 exact comparisons, direction/hemisphere/radial checks, rejected counts/phases, six failure-atomic budget cases and original regressions. ASan/UBSan pass with LeakSanitizer disabled because ptrace prevents its operation; leak checking is not claimed.

Five predeclared arms:16/16;64/16;64/64;256/64 phase0;256/64 with fixed outer0.38196601125turn/inner0.61803398875turn. Three DISK16 lights, source groundLe, geometry, materials, scene ownership, normal handling and transport equations are unchanged. One alternate angular phase is not a radial/phase bias bound.

## Absolute linear-HDR differences (selected56 points per case)

RGB-L2 differences, not errors against known truth.

| Case |16→256 phase0 mean/max|256 phase difference mean/max|
|---|---:|---:|
|front-baseline|0.02194685/0.36381439|0.00283510/0.01936279|
|front-direction|0.02543908/0.53455282|0.00286996/0.02601045|
|oblique-baseline|0.01467639/0.08832419|0.00226638/0.01205906|
|oblique-direction|0.01446595/0.10560104|0.00194113/0.00952020|

The selected mean change from outer16→64 is0.01296–0.02274 RGB-L2; changing only inner16→64 at outer64 is0.000239–0.000266; outer64→256 is0.00557–0.00660. These component-wise finite comparisons are not an asymptotic convergence proof. A few points (2–3 per case) have phase256 spread larger than their16→256 phase0 change.

Maximum0.53455282 is front/direction, Eye white1, boundary stratum. Luminance is1.60602646 at16 versus1.29199626 at256, so this is not a tiny-denominator/low-light artifact. Component RGB-L2 changes: direct0, world0.01726507, bounce0.55765217, ground0.00597470. Components can cancel; their norms do not add to combined norm. Both direction-case RGB triplets exceed1 in every channel, so legacy sRGB clamps both to white despite this large HDR difference; this is another reason not to equate HDR change with image improvement.

For direction-minus-baseline response, changing16→256 affects only bounce (direct/world/ground differences across arms are exactly zero for that paired response). Mean response RGB-L2 change is0.00656079 front /0.00719406 oblique; maximum0.17204310/0.08577163. Phase256 response difference means0.00120327/0.00104560. No source-reference correctness is inferred from HDR response change.

All component/group/stratum absoluteRGB-L1/L2/maxchannel and luminance, signed differences, median/p95/max are retained in point-summary.json. Predetermined luminance bins use abs(Y_from):≤1e−6,(1e−6,1e−4],(1e−4,1e−2],>1e−2. Combined baseline16 has no point≤1e−4;4/6/7/9 of56 points are≤1e−2 across front baseline/direction and oblique baseline/direction (7.14%/10.71%/12.50%/16.07%). Component and response low-amplitude bins are separately retained, including zero/null domains. Relative luminance difference uses an explicitly reported denominator and is inapplicable at≤1e−4; absolute differences remain reported for every bin.

## Fixed-display response classes, descriptive only

Existing legacy sRGB565 and official-OCIO-derived AgX LUT565 approximation are separate columns, no filter. Existing library/LUT/settings/20 installed dependencies are pinned. All16/16 selected outputs match their previous full-frame display controls. Candidate bright/dark/inactive uses the unchanged ±2/255 decoded565 luminance threshold. Source comparison reads only frozen postselection labels, never reference RGB.

| View/display |Class changes16→256|Class changes256phase|Stable eligible / uncertain|Incorrect→correct / correct→incorrect16→256|
|---|---:|---:|---:|---:|
|front/legacy-srgb565|3|2|45/11|1/1|
|front/fixed-agx-lut565|4|2|45/11|0/3|
|oblique/legacy-srgb565|2|0|47/9|1/1|
|oblique/fixed-agx-lut565|2|0|47/9|0/1|

sRGB has one newly correct and one newly incorrect stable point in each view. AgX has zero newly correct and three newly incorrect front/one oblique. This distinguishes estimator sensitivity from a60% image-improvement claim: the latter is not supported here. Unknowns remain separate, and these counts must not be called full-frame scores or population accuracy. Full confusion/transition/group/stratum counts are in display-summary.json.

## Bounded work and cost

Frame caps are unchanged. Every case uses one separate cumulative diagnostic budget across all selected points/arms: direct1M rays/100M nodes/50M triangles; transport20M/800M/300M. Original16 preflight has its own separately bounded cumulative pair, never per-point unlimited reset. Point order follows frozen group/stratum/hash manifest; each point uses arms0–4. Failure would stop the case, keep consumed counters and mark all remaining queries unattempted, with no representative-prefix claim.

Conservative56point five-arm ray bound is3,936,128 transport/13,440 direct per case.1023 BVH nodes/1566 triangles yield loose worst-case bounds above node/triangle caps; completion was measured, not assumed. Actual diagnostic totals across four cases:2,296,797 transport rays/178,090,467 nodes/59,302,991 triangles;25,955 direct rays/1,830,600 nodes/540,400 triangles. Case maxima604,408/46,284,576/15,435,579 are below the frozen limits.

|Case|Completed/failed/unattempted|Transport rays/nodes/triangles|
|---|---:|---:|
|front-baseline|280/0/0|541620/42822628/14239610|
|front-direction|280/0/0|550996/43181275/14445409|
|oblique-baseline|280/0/0|599773/45801988/15182393|
|oblique-direction|280/0/0|604408/46284576/15435579|

Host observer static storage is19,837,576 bytes including600-byte full-raster query records and mapping/last-result storage. This is intentionally diagnostic and is not product RAM fit. Source/owned-scene allocations are unchanged; query JSON, Python arrays and library overhead are additional. Four end-to-end control-render/dump/replay processes each took about9.66–9.93s; these include rendering and diagnostics, not isolated high-density-query time, a controlled performance benchmark, or real-device speed. No full-frame high-density render was run.

Raw winner/mapping/query snapshots, coordinates, source geometry, images and HDR buffers are private and excluded from save bundles. Save code/tests/reports/aggregate metrics/cost/hash evidence only. No original edits, upload/public PR/device/default change.

## Independent verification

Independent fresh C reproduced four cases, all32 files including point results, all224 original preflight queries and all1120 diagnostic queries exactly, with cumulative counters and bounds checked. Independent metric/display/post-label classification review matched262,493 numerical values and found no blocker. Evidence: /tmp/lid-point-replay-independent/independent-review.json and /tmp/transport-point-metrics-independent-review.json. These checks establish reproducibility of this bounded experiment, not correctness of256 as truth or product fit.
