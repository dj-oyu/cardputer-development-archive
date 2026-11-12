# Current lid8 full-frame direction-response correspondence

Read-only analysis of existing renders and evaluated original geometry; no illumination render, candidate/reference/mask/threshold edits or source save. Proxy rendering is a separate worker's experiment. All four display variants are retained, not selected for a favorable result.

## Complete foreground census
Rows use original reference stable class; columns use native bright/dark/inactive at the unchanged +/-2/255 decoded565 luma threshold. Uncertain and outside-source domains are separate, never counted as success.

|view/arm|bright→dark|dark→bright|bright→inactive|dark→inactive|inactive→active|
|---|---:|---:|---:|---:|---:|
|front point sRGB|55|56|371|389|69|
|front point AgX|55|65|256|332|102|
|front filter sRGB|47|60|319|291|134|
|front filter AgX|49|67|207|245|137|
|oblique point sRGB|57|56|333|658|85|
|oblique point AgX|52|62|282|598|120|
|oblique filter sRGB|62|54|267|576|139|
|oblique filter AgX|47|61|241|526|153|

This corrects the inference one might draw from the fixed112-point set: that set contained zero oblique stable full-sign reversals, whereas the full foreground contains113 in the original display. Inactive responses are more numerous than complete sign reversals. Missing native foreground620/719 remains scored as no receiver/black, not transport error zero. Full matrices are in census.json, including per-native-source-object totals, unknowns, extras and partial-alpha/boundary strata.

Original point/sRGB reverse counts are largest on unified Anatomy42 front/40 oblique and sweeping Tail18/9. Unified Anatomy spans several anatomical regions; its label is not a hand-defined head/body segmentation. All objects, not only these maxima, remain in tables.

## Center-ray correspondence
Read-only original evaluated MESH/CURVE geometry including ground is intersected at every native-covered center. Common origin is native source-world P+20V; native distance is20. Maximum camera reprojection residual2.324488e-5pixels. Native source positions/normals were confirmed already inverse-B transformed by producer. No normal is flipped to match another, and source Ng/view and Ns/view signs are saved.

|view|native covered|same original object|different object|source ray nohit|
|---|---:|---:|---:|---:|
|front|4698|4120|573|5|
|oblique|5157|4584|569|4|

For original point/sRGB full-sign reversals:
- front111: same-object79, different-object32; native object-boundary54, partial source alpha6.
- oblique113: same-object83, different-object30; boundary67, partial alpha26.
Boundary and partial-alpha columns overlap. None is removed from census.

Same-object reversal points still differ geometrically. Source corner-Ns dot normalized native-Ns has front median.843438/min.435697, oblique median.857322/min.242602. Source-ahead distance has median.006218/.022547, ranges[-.073738,.237268]/[-.130743,.225977]. Therefore matching object names is not matching receiver positions or normals. These are measured evaluated-surface comparisons, not an attribution of shading error to normals alone.

BVH and mathutils use float32. Descriptive numerical warning bands |depthgap|<=1e-5 and min barycentric<=1e-5 are recorded separately; counts across all centers are1/1 and3/1, respectively, with zero such points among full-sign reversals. These warning bands do not establish exact visibility ordering elsewhere, certify source geometry, or exclude any pixel.

## Interpretation and next link
The old1166 rich/Lambert oracle is not current1564 geometry and cannot isolate current transport error. The authorized current proxy can remove that confound. Compare its response with native at the same center/object, but retain original-versus-proxy correspondence as a distinct axis. Raw center-ray Ng/cornerNs are not Cycles safe shading normals. Original BH-filtered radiance can mix surfaces even at alpha255; a matching center ray does not prove a unique filtered receiver.

Missing floor BSDF reflection is a plausible transport hypothesis, not established by this census. World and primary groundLe direction differences are zero in the existing native equations, while the original scene can carry light-direction changes through indirect paths. However, current reversals include original geometry/normal differences and display threshold effects. Do not assign all reversals to floor transport. The proxy's component deltas should first distinguish direct/indirect contribution; indirect dominance alone would not identify the floor as the source.

## Reproduction / audit / persistence
python census.py; blender -b -t2 --python source_rays.py; python summarize_correspondence.py, from this workspace with private pinned inputs present. No source save occurs, and source SHA is checked before/after. Raw source-rays-private.json contains intersection geometry and must not be included in persistent code/report bundles. Save PLAN/code/this report/aggregate census/correspondence-summary/hash evidence only.

Initial census labeled foreground-external mask entries as inactive. Independent review caught this; initial code/output preserved under initial-outside-label-bug. Corrected labels require source alpha>0, preserving outside rows. All foreground conclusions above are unchanged. This was a reporting-domain bug, not a render or threshold change.

Independent final PASS:10,260 census cells and15,044 correspondence/depth/normal summary values reproduced. This independently reaggregates saved ray observations and audits source/code; it is not a fresh independent original-ray execution or illumination render. Evidence independent-review.json. Additional all8 view/display domain-partition checks sum to32400 and retain reference uncertain729/698.
