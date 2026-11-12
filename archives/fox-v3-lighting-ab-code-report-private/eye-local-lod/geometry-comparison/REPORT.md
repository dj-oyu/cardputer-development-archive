# Fixed source-eye geometry comparison: stage2 / A / B

Scope: read-only geometric diagnosis, not an actual-C image score or acceptance decision. Both eye units use the unchanged original seven-component projected bounding box plus2% per edge,32×32 centre-ray grid and full-character nearest-hit geometry. Original front/oblique and two held-out directions are reported separately. Same-object intersection distinguishes reduced-surface absence from being behind another surface. Extra winners are counted, not discarded.

Holdout directions were reported by the implementation owner as declared07:42:50 before candidate generation: sourceXY azimuth247.5/elevation12.5 and azimuth292.5/elevation27.5; target-to-camera vector. PLAN.json froze these before any holdout measurement. Existing A rendered-score information did not alter the geometry procedure. The stage2 four existing eye/view samples are exactly equal to the prior diagnostic, including source/coarse intersections and all transitions. All source and candidate hashes remain unchanged.

## Result
B improves diagnostic pupil, iris and white IoU in all8eye/view combinations. Pupil oblique IoU75.23→88.89% and74.29→90.65%; true pupil winners82/102→96/102 and78/102→97/102. The held-out pupil IoUs improve79.05/72.48/85.44/68.75→90.38/90.00/91.26/89.19%. This supports a real geometry improvement rather than a brightness-only change or one-camera fit.

All-object winner mismatches per1024rays (stage2/A/B): front−1 228/235/205; front1 350/310/262; oblique−1 225/223/199; oblique1 357/318/268; holdout247.5−1 224/221/200; holdout247.5 side1 383/338/285; holdout292.5−1 242/247/225; holdout292.5 side1 335/311/249. B improves this aggregate in every group. This is not a universal or thresholded PASS.

## Regressions and unresolved contours
Near-side white B true-winner counts fall in every view, e.g oblique183→179, despite IoU increasing because false extra white shrinks57→38. Socket extra coverage grows for near-side eyes, e.g oblique59→69. Therefore improved IoU does not mean every originally correct ray remained correct.

Upper eyelid geometry is unchanged. Oblique source eyelid winners51/37 still have only5/9correct reduced winners in B; extra eyelid winners28→31 and95→85. The remaining contour issue is substantial and not solved by the six-ellipsoid replacement. A increases extra lid visibility more strongly and loses white true winners in most views. Main/small glint counts remain unchanged across arms; their original losses remain.

A's pupil improvement is weaker and near-side full-object mismatches regress in front and one holdout. Do not select A or B solely from these geometric indicators. Formal image response/color, memory admission, rendering cost and non-eye regressions are independently measured by the implementation owner.

## Limits and next use
Finite32²rays, float32BVH, two original plus two fixed held-out directions do not guarantee whole-surface topology, all-view occlusion preservation or every rasterpixel. No source imagery enters the geometry comparison. Source-derived construction is view-independent, but its rendered shading changes with normals and geometry; those effects are not isolated here. No new geometry, coefficient, threshold or image retouch was made by this review.

Use B's demonstrated pupil/iris improvement as one piece of evidence. Remaining eyelid/socket geometry and shared memory limits must be handled explicitly before claiming the whole eye contour is repaired. No public upload/PR/device action or formal reference change occurred.

Reproduction: from workspace, invoke Blender -b -t2 --python fox-v3-eye-diagnostic/ab/compare_geometry.py -- stage2/eyeA/eyeB in fresh output directories, then python summarize.py. Completed output paths reject overwrite; copy the diagnostic root/update output directory for replay while retaining frozen input paths. Original private .blend/GLBs are external dependencies and must not be embedded in the code/report bundle. Save PLAN.json, base-geometry.py, compare_geometry.py, summarize.py, summary.json, REPORT.md, input/code hashes and independent compact review. Exclude *-geometry.json because they contain private world-coordinate intersections.
