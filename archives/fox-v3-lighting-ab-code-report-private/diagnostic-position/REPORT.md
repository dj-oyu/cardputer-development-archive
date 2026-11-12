# Direction-position diagnosis on rebuilt 4a4d / v3

Status: limited host-only diagnosis, no product adoption or reference change. The lost advanced candidate is not reconstructed. Inputs are the preserved 1166-triangle candidate four-both-002 and fixed eight-seed v3 reference masks. No original image is used as a lighting input.

## Findings

1. **Boundary coverage is a large, insufficient contributor.** Existing direction brightening IoU is reproduced exactly: front 884 TP / 194 FP / 527 FN =55.0779%; oblique 275 /216 /434 =29.7297%. Missing native coverage accounts for101 front and208 oblique bright FN. Of those,101/101 and204/208 lie on partial-alpha source boundary pixels. Keeping every other prediction fixed and granting perfect responses at all missing-coverage FN would reach at most61.3707% /52.2162%. This is an attribution upper bound, not a proposed fitted rendering or an acceptance result. Oblique cannot reach60 through coverage repair alone.

2. **The remaining sign errors are spatial, not just deficient response magnitude.** On the fixed stable domain, oblique full-alpha pixels still contain183 bright FP and161 bright FN. The source object's exact name `Anatomy • unified live sculpt surface` contributes111 FP/76 FN, including106 source-dark/native-bright pixels; the tail silhouette contributes53 FP/5 FN, including43 source-dark/native-bright. The unified source object contains the sculpted anatomy and should not be read as a precisely segmented torso. Cheek/muzzle/ruff areas instead show mainly missed brightening. Full source-object counts are in object-sign-errors.json.

3. **Vertex color interpolation is a real but inadequate explanation.** An isolated non-output-changing observer records actual C raster winners, vertex indices/weights, world coordinates, SNORM normals and physical face side. All four original baseline/direction×2view RGB565 and depth outputs remain byte-identical (8 buffers). Re-shading every observed vertex with the same C DISK16 formula reproduces all2094 unique view/case vertex queries, with0 RGB565 mismatches. A diagnostic then shades actual winner position/interpolated normal once per pixel with the same material, light samples, sRGB encode, clamp and RGB565 packing. Nothing is fitted to reference images.

   - Front bright IoU55.0779→60.0512%; dark76.8737→71.9525%.
   - Oblique bright29.7297→33.8337%; dark82.6805→73.9518%.
   - Source-dark/native-bright falls149→110 and178→119, but substantial residuals remain.

   This changes shading evaluation/interpolation granularity and quantization placement together. It is not evidence that interpolation alone accounts for the residual or that a new renderer should be adopted. Two cases do not certify other parameters. Same geometry, actual raster coverage, fixed16 area sampling and output profile are maintained.

## Two hypotheses and next minimal tests

**H1: missing antialias/coverage integration causes a large boundary component.** Evidence: almost all missing-coverage bright FN lie in partial-alpha pixels. The source foreground uses alpha>0 from a128sample source mask; rich reference pixels on the boundary also mix the lit backdrop, while the native result is a single-sample opaque silhouette on black. Geometry simplification and sampling/filter differences are not yet separated. Test a separately declared native fixed-subpixel coverage resolve with source-matched camera/filter semantics, maintaining geometry/material/light formulas, then report boundary and interior changes against the unchanged full foreground. Do not exclude edge pixels or threshold-fit the mask. Preserve all current scores. Even perfect recovery of these FN alone cannot meet oblique60.

**H2 (priority for shading): absent geometry visibility changes the direction response sign.** Current physical DISK16 is unoccluded Lambert plus uniform unoccluded world; source response includes shadows, material lobes and indirect transport. Body/tail opposite-sign errors survive exact same-formula pixel shading, so simply spending on per-pixel evaluation is unlikely to solve them. Minimal causal test: at these same native winner positions and interpolated normals, toggle only direct-light visibility using fixed16 sample endpoints and ray intersections against the fixed native1166 geometry; preserve world, samples, profile, rho, coverage and all other terms. Validate all-visible control exactly against the current pixel diagnostic. Report total IoU plus predeclared object/sign FP/FN changes, including regressions. This visibility test is proposed, NOT executed and NOT proved the dominant cause. If it fails to remove the interior sign errors, the next distinction is source-normal/BRDF/AgX/GI rather than more gain or sample fitting.

The two hypotheses concern different populations. The first is already localized but insufficient; the second remains a falsifiable proposed causal test. No source simplification, threshold change, unstable-pixel exclusion, or result-selected sample count is recommended.

## Attribution limitations
Source object labels use a diagnostic primary pixel-center ray into the original evaluated geometry, not antialiased object coverage. Unassigned source-center pixels remain explicitly labeled:400 front/456 oblique stable pixels, all partial-alpha. This ray map never replaces formal v3 foreground or stable masks. Native field capture uses actual raster winners, not a nearest source vertex or approximate reference lookup. Object labels describe what the source ray sees; a native pixel may show a different simplified surface. We have not yet measured source/native normal-angle mismatch, source-material BRDF isolation, official AgX-only transformation, or ray-visibility ablation.

## Cost and controls
Observer arrays add2,679,808B host diagnostic storage (2,073,600 winner fields +589,824 world/front/back normal fields +16,384 physical side map), excluding files and temporary analysis arrays. It is deliberately not a firmware layout or performance/fit claim. Per-pixel shading cost is unbudgeted and not adopted. Original product and formal reference files are unchanged; observer changes exist only under observer/product and observer/native_render.c.

Reproduce locally (existing private inputs required):
- blender -b -t 8 --python fox-v3-position-diagnostic/code/source_map.py -- fox-v3-position-diagnostic
- python fox-v3-position-diagnostic/code/aggregate.py
- python fox-v3-position-diagnostic/code/capture_observer.py
- Build shader_probe.c with the same frozen fox_disk_lighting.c and flags shown in build-command.txt.
- python fox-v3-position-diagnostic/code/pixel_probe.py

Numerical results: object-sign-errors.json, coverage-error-budget.json, coverage-boundary-detail.json, observer-parity.json, pixel-control.json, pixel-results.json. Raw-sign-errors.json is supplementary only: it counts even small raw same-channel sign differences and is not a thresholded accuracy score.

Observer precision note: winner weights are captured as float32 from the C rasterizer’s double weights; the host diagnostic uses those captured float32 weights. Interpolated SNORM is normalized by eval16 without a new SNORM rounding step. This is therefore a float32-weight per-pixel shading/precision-placement experiment, not a claim of identical double interpolation arithmetic. The actual compact-to-source vertex mapping was captured separately and verified identity on every winner vertex occurrence (front14094 / oblique15468 per case); source indices are not inferred from color equality. See compact-remap-check.json.

## Subsequent visibility test
The predeclared direct-visibility ablation is now complete and independently reproduced. See visibility/REPORT.md for both improvements and regressions. This closes H2 as a demonstrated contributor under the fixed reduced-geometry diagnostic, not a sole-cause claim. The native default and formal reference remain untouched.
