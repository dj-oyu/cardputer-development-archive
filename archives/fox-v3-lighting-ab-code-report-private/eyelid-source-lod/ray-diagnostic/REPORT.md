# Fixed source-ring eyelid comparison: eyeB / lid8 / lid9

Private read-only geometry diagnosis; no actual-C colour/lighting or formal acceptance score. The same original seven-component eye bounding box+2% each edge,32×32centre rays and full-character nearest BVH method is reused. Front/oblique and the two historically named holdout directions are ALL SEEN validation now. No new direction or threshold was selected. The baseline eyeB eight eye/view raw records match the previously frozen records exactly. All input .blend/GLB hashes remain unchanged.

## Improvement and remaining errors
Both source-ring eyelid candidates improve eyelid geometry in every eye/view group. For oblique side−1 the correct source eyelid winners increase5/51→40/51(lid8)→43/51(lid9); side+1 increases9/37→29/37for both. Pupil and iris role metrics remain exactly unchanged in all8groups. Correct white winners improve in all8groups, because fewer original white rays are incorrectly hidden by the old lid.

Summed counts across8distinct eye/view strata (not unique imagepixels):

|Role/count|eyeB|lid8|lid9|
|---|---:|---:|---:|
|Original visible eyelid|360|360|360|
|Correct eyelid winner|64|301|317|
|Eyelid same-surface miss|245|44|29|
|Eyelid exists but hidden|51|15|14|
|Extra eyelid winners|441|174|172|
|Extra socket winners|476|324|316|
|Correct white winners|1185|1261|1261|
|Extra white winners|424|457|458|
|All-object winner mismatches|1893|1503|1493|

These are geometric counts, not aesthetic weights or a new gate. Full transitions and all7roles are in summary.json; no missing/extra/occluded sample is dropped.

## Trade-offs retained
Lid9 is better at restoring the near-side curve but not uniformly superior to lid8. The far-side eyelid true winners are identical in both. Extra far-side eyelid coverage grows8→9 in front19→23, oblique27→28 and seen292.5degreeview19→21, worsening eyelid IoU in those three cases. The other far-side view ties. Near-side lid9 improves true winners and extra counts in all4knownviews.

White extra winners grow relative to eyeB in most groups, despite increased true white visibility. Lid9 has one extra white winner beyond lid8 in seen247.5degree side+1. Thus the correction restores substantial original silhouette/ordering but still exposes some inaccurate white/socket geometry. Socket extra decreases strongly overall but is not eliminated. Glint, pupil and iris metrics are unchanged; their pre-existing errors remain.

Do not declare the whole eye repaired or choose9solely from summedcounts. Actual admission, full10condition rendered results, same-density images, CPU/memory and non-eye regressions belong to the independent actual-C evaluation. The geometric result supports a causal effect of changing the eyelid representation only. It does not measure normal-dependent shading changes, source pixel-filter integration or all-view quality.

## Contract, reproducibility and persistence
PLAN.json pins input hashes and method before this run. compare_geometry.py differs from the previous approved comparator only in its output root; arm paths are supplied by PLAN. Each arm fresh-loads the same original and asserts input hashes before/after. No source scene save, model edit, image fit, public upload, PR or device operation occurred.

Commands (completed paths reject overwrite): Blender -b -t2 --python compare_geometry.py -- eyeB/lid8/lid9, then python summarize.py. For a replay use a fresh diagnostic output root and preserved PLAN input paths. Save scripts, PLAN, pre-execution hashes, summary, report and independent compact review. Exclude *-geometry.json and private .blend/GLB files from code/report bundles because they contain private intersection coordinates or geometry.

Finite32²source-derived samples and float32BVH do not prove continuous surface or all-view correctness. Seen-view improvements are not unseen validation. Frozen formal reference, uncertain masks and thresholds are untouched.
