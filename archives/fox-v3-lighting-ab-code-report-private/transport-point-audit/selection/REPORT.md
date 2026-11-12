# Frozen current-lid8 transport diagnostic point set

Selection completed before reference annotations and numerical transport audit results. PLAN SHA256 d51dcef666d8c44d583909c3b2499e16d513d83b334f66b85f18a0e0d6c6d8bc. Selection SHA256 d0d2a7031bd65a41445c036944ff2d74b846f1e7e431c4b36a094074c8d71044.

Actual final-winner buffers were supplied by the isolated capture harness. No independent GLB-ray winner surrogate was used. Source object, compiled face, compact remap, physical side and world/normal/rho provenance were verified by the producer and pinned; this selection script also independently checked original RGB565/depth/preclamp-HDR all bytes across4cases. It validates every covered record, source object dictionary, input hashes, finite vectors and positive normal length before selection.

## Fixed selection
Both formal views, baseline-selected112unique coordinates:56/view,7source-name groups ×4interior +4geometry/object-boundary. Boundary means any4-connected neighbour is out of frame, uncovered, or a DIFFERENT SOURCE OBJECT, not merely a different broad group. Interior is the complement. All candidate keys are ranked by the exact prescribed SHA256 ASCII tuple; first4pergroup/stratum, with no cross-stratum fill. All28strata have at least4points, so shortfall0. Direction at every chosen point has exact same node/face/physicalSide/sourceobject/depth/P/Ns/rho: blocked pairs0,224casequeries per numeric arm. No reference RGB, alpha, foreground, stability or render-error arrays participate in select.py.

Groups are exhaustively frozen over92sourceobjects: body2, head-muzzle10, eyes-lid16, ears10, tail15, legs20, other19. The unified Anatomy object is assigned body even where it contains head anatomy; no image-derived anatomical split is invented. The other group covers the remaining authored decorative ruffs/locks, not unknown unvalidated names.

The implementation owner accepts this maximum point set and a fixed5arm audit with view/case-cumulative direct1M/100M/50M and transport20M/800M/300M quotas. Estimated ray bound≈3.94M/case does not guarantee node/triangle completion. Partial/unattempted points must be retained as incomplete and cannot establish whole-set convergence. Query sampling and rendering are not performed by this selection task.

## Separate annotations and omitted coverage
Only after selection.json was written and its SHA frozen did label_after_selection.py read the original alpha/stability masks, write post-selection-labels.json and assert the selection SHA remained unchanged. The actual numerical renderer must consume only selected coordinates plus verified native geometry/shader inputs; these reference labels are reporting-only.

All selected points happen to lie in original foreground, without that being a selection condition. Front56: stable bright15/dark27/inactive3, uncertain11. Oblique56: bright9/dark36/inactive2, uncertain9. Partial source alpha8/9, actual native silhouette-edge selected7/10. These counts do not cause resampling.

Whole-image coverage is separately retained: nativecovered4698/5157, originalforeground5307/5868, native-missing sourceforeground620/719, nativeextra11/8. Native nohit pixels27702/27243; nohit adjacent to coverage466/540. Sourcepartial-alpha native-missing620/699. No-hit regions cannot have a transport query because there is no surface winner; they remain an explicit unresolved rendering/coverage contribution, not zero-error samples.

Equal allocation over sourcegroups/boundary strata deliberately overweights small parts and edges. This is not a uniform or area-weighted foreground sample. Report numeric differences by group/stratum and their maximum; do not interpret the overall sample mean as whole-frame error, worst-case bound, convergence, formal60% attainment or a device budget result.

## Reproduction / persistence
select.py reads PLAN, verified-winners-v2 and pinned original control artifacts, rejects existing selection.json, and emits selection.json/selection-frozen.sha256. label_after_selection.py requires that exact frozen file and emits a separate annotation file. For independent replay use a fresh output directory while preserving the pinned paths/plan. Original .blend/GLB, winner arrays and images are external private dependencies, not copied into the small code/report bundle. Selection entries contain coordinates and stable IDs, not raw world geometry or radiance. No renderer/default/source/reference/threshold changes, new rendering, public upload, PR or device operation occurred in this task.

Independent audit PASS: all112hash-ranked coordinates and28strata reproduced; full9855covered baseline/direction geometry agrees, not only selected points. An independent re-derivation from the original8seed references matches the post-selection labels, retaining11/9uncertain selectedpoints. Code sequencing and frozen hashes support selection before reference annotation. No population or whole-frame convergence claim follows. Evidence: independent-review.json.
