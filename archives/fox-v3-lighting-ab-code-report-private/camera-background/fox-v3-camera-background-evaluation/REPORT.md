# Camera floor/world composition: host experiment in progress

Fixed lid8 geometry, original references and formal v3 thresholds are unchanged. This arm starts from A2 affine-rho correction and v32 quarter samples (±.25), with the unchanged geometry-bound target mask. It does not enable the previous floor-reflection transport experiment. No new model, rig, filter, display profile, exposure fit, or device implementation is included.

## Scope and preserved failures

The original no-character-hit-only contract failed: the source floor is closer than three retained front camera samples on the current actual 1564-triangle character. Independent all-triangle double ray tests confirmed those intersections. Two are final quarter samples; the third is a target center discarded by the quarter average. The source-original geometry is different and its separate ray results do not repair or replace the actual character geometry.

The approved replacement is explicitly a scene-composition arm with floor-depth precedence and character precedence on exact float depth ties. Original character-only depth/coverage remains unchanged and is the only shape input. Floor RGB outside it is not character geometry success. Background-only control hides character from camera but keeps its shadow occlusion; it is a counterfactual diagnostic, not a source renderer or a formal character candidate.

Old direct 1M and work8M admission fail. Separate host background shadow limits 2M rays / 200M nodes / 100M triangles, core stage1,680,000 and resolver semantic1,540,298,112 are fixed beforehand. These do not increase or borrow unused old character direct/transport quotas. Node/triangle completion is not inferred from geometry-only ray counts. Any failure leaves private partial files but no successful all-condition manifest or quality score.

Floor radiance is direct3DISK16 Lambert + unoccluded rho times constant world + source Le once. It is not full Principled, specular, GI, or occluded ambient. True finite-floor/clip miss uses world radiance. Original character shading is performed unchanged even for later floor occlusion. Final four samples are averaged in linear space then encoded once with the existing sRGB565 path.

## Implementation and control status

Core and resolver synthetic fixtures and independent O2/ASan/UBSan checks passed. The first integrated stack claim omitted the bridge caller: actual named chain4656B failed4096B, with physical render0. It is retained in actual-001 and history/stack-fail-001. The replacement uses non-overlapping validation/logging helper lifetimes, without removing checks or changing arithmetic. Independent measured complete named chain4064B; logging2256B; validation656B. Main and libc/libm remain outside this named-chain measurement, so this is not device-fit evidence.

actual-002 OFF20, ON20 and background-only20 have completed. OFF all20 RGB/depth/snapshot/target/old raw samples and counters equal A2. ON preserves all character-only depth and raw character HDR; two fixed front quarters are replaced by the closer floor. Background-control has no character camera shading and is never a formal candidate. Each new arm admits20 actual positive reports before rejecting10940 type/value mutations. Both composition audits reconstruct every final pixel by exact coordinate/sample join and the existing C encoder. Independent fresh O2 reproduction passed all28 frames (ON20, OFFbaseline4, background-controlbaseline4), including all buffers, observer events, reports and non-timing counters. Independent numeric/strict/sample closure has passed. Fresh CPU002 completed all12 byte/pin controls; its independent timing aggregation also passed (84 raw timing values,168 summary values,36 buffer hashes,2016 non-timing metadata values,196 input pins and before/after raw jiffies). No unresolved audit blocker remains.

The old inherited code/score_actual_v2.py and code/audit_samples.py are not used for the new composition arm. A new loader must enforce exact output/input pins, all20 keys, actual metadata, the background contract, and retained character-only depth. New composition sample validation joins exact coordinates/sample IDs; it must never reshape adjacent sample-major rows into four-sample pixels.

## Memory scope

Actual single-generation construction peak7178B; separate retained-old/new-scene peak8154B, both below16384B. The resolver/core-only two-generation8138B excludes the16B diagnostic observer increment. Current run retains one generation. These are named owned/requested storage bounds, not total process RSS or device fit. See memory-v2/OWNED_SCOPE.json and STACK_REPORT.json.

Raw geometry, snapshots, buffers, images and source model data are private and excluded from eventual code/report bundle. No publication, PR, upload or device action is performed here.

## Quality result, independently reproduced

All10 fixed stable-foreground RGB MAE values decreased. Baseline front .25402270→.16821512 and oblique .26992631→.17634403. This is background/edge composition, not changed character lighting or repaired geometry. Full-frame/background errors also fall substantially but their area-dominated values are descriptive only.

Preserved regressions include front-direction bright IoU .687789→.675258, direction reversed signs110→125 front and111→117 oblique, increased direction/intensity inactive false positives, and ambient response RMSE worse in both views. Oblique-direction bright IoU .444444→.455568 remains below .60. Unknowns and all10 shape results are unchanged; source foreground missing620/719 remains. The comparison records10 worsening formal scalar metrics,11 worsening confusion counts and4 overlapping descriptive-domain error entries. These are overlapping measures, not independent failed trials. No default adoption or global goal60 success is claimed. Full condition, per-seed, uncertain, full-foreground, background and fixed-stratum results are in analysis-code/all-analysis-001 and all-comparison-001.

## Resource results

Original character counters remain exact: maximum direct441552 rays; transport4808773 rays/329358214 nodes/117192737 triangles. Additional ON background maximum1203920 rays/29695689 nodes/5486111 triangles; background-only maximum1656192/41170710/7555382. Each retains its independent cap and counter domain. The maximum sum of character direct plus new background rays is1642832, so the original1M combined interpretation still fails.

Additional core observed maxima are1358655 ON and1655363 background-only; additional resolver semantic maxima1150615632 and1535388624. These are not old8M-equivalent or instruction counts. Actual camera rays all intersect the finite floor: world-miss shading is validated by fixtures but not exercised by these images. Per-query floor depth/classification is diagnostic; no scene-depth result is used for character shape. Current functional-run timings are concurrent and must not be used as speed comparisons.

## Preserved integration issues

The first background-control launcher attempted to use the already-existing background source directory as an output directory and rejected it before launching native code. It made no source edits and produced no successful frame. run_actual_v2.py changes only the output name to background-control. Original failed launcher log and code remain. audit_composition_v3.py carries the corresponding output path plus strict action types, all character hit/depth comparisons, fixed override keys and depth/tie precedence checks.

The inherited source-preservation script can report zero original files after relocation if its relative source path is missing. Its original author evidence contains70 files; independent review used an absolute path and required exactly70. No success claim relies on a zero-file comparison.

Metric definition: RGB MAE is the mean absolute error over all selected pixels and all three decoded RGB channels in [0,1], not a channel-summed L1 value. The existing formal rgbAgreementPercent is 100×(1−MAE). Baseline increases are +8.58076 percentage points front and +9.35823 oblique. This is distinct from response brightening IoU and its .60 condition. Covered non-target interior and opaque-covered interior reports remain exact OFF=ON for every condition, including per-seed/unknown/response entries; improvement is predominantly partial-alpha and center-missing scene composition. See analysis-code/ATTRIBUTION_SUMMARY.md.

Independent final review confirms68,130 formal/descriptive/per-seed numbers and7,770 comparison values,18,501 admission mutations rejected plus14 unit tests, and all40 composed frames (1,296,000 pixels) independently C-encoded exactly. All1,582,560 composition event keys, original character inputs and the two fixed quarter overrides match. A NumPy-only power calculation differs at one bg-only oblique-direction quantization-boundary pixel (both orders); the independently compiled legacy float32 powf/lroundf calculation matches exactly, so this is not a renderer discrepancy. The10 main stable regressions summarized above are a subset: scanning all formal uncertain/per-seed scalar metrics retains152 worsening entries. They are not152 independent conditions.

## Host timing and footprint

Primary timing is fresh cost-002, fixed OFF→ON order for each of two views and three repeats. cost-001 is preserved but not selected for comparison because a short independent encoder compile overlapped its beginning. No sample-by-sample replacement or minimum-time selection was used. Independent review confirmed compile/C/renderer completion before cost-002. Both runs retain before/after raw /proc/stat jiffies, load, and namespace-limited process observations; these are not proof of universal host isolation.

Cost002 render-time medians: front12.974028645s OFF→14.115180991s ON (ratio of medians1.08795667); oblique12.546249088→13.698088085s (1.09180744). Median paired ratios differ:1.08018961/1.08747137. Three samples and fixed order are limited evidence. Both arms include original quarter-sample JSON I/O; ON additionally includes every background-composition event's JSON I/O. This is host elapsed timing, not pure shader, device latency or a guaranteed performance bound. Build/evaluate/append/background-build timing is separated in raw RESULT.json. All36 image/depth/snapshot hashes and all non-timing original metadata match the functional run; input pins and binary remain unchanged.

Whole-host ELF comparison to A2: text+33792B, rodata+9248B, relocatable-read-only data+384B; .data/.bss unchanged. Named new camera/material rows4960B + stage tables640B + mask fingerprints16B =5616B of new read-only tables. These sizes include diagnostic code and strings, not an embedded deployment claim. Main diagnostic caller stack86640B (old81776B, +4864B) is explicitly outside the fixed4096B callback-chain contract. See memory-v2/RO_AND_CALLER_SCOPE.json.

## Artifact chronology

PLAN/CORE_DESIGN/work contracts, STACK_FIX_REPORT and preflight freezes intentionally retain their pre-execution wording and rejected-design history. This final REPORT and independently checked completion artifacts describe the eventual execution status. The first prepared stack-failing build and first directory-collision launch are not successful arms. CPU001 is retained only as the known-interference history; CPU002 is the sole primary timing comparison. None of these records changes the original model/reference or default product APIs.
