# Normal-only A/B: Ns versus Ng

Status: complete; independent full fresh-library/ray/metric rerun PASS. This is a fixed-geometry diagnostic, not adoption. Neither normal is declared the correct representation of the original model.

## Contract and controls
Actual native camera winners, positions,1166tri geometry, rho, threeDISK16 lights, world, output profile, coverage, reference images and uncertainty masks are unchanged. A uses captured-float32-weight interpolated SNORM Ns; B uses the actual winner's geometric face cross product Ng. Both pass through the same C normalization. Ng is oriented by physical selected side and the orthographic camera vector, not by Ns. Source-coordinate cross accounts for the native/source determinant−1 conversion. Original-triangle cyclic order/selected-side checks pass on every winner.

Finite, area and view-facing checks reject the whole case, with no problematic-pixel exclusion. The facing threshold is applied to rawcross·unitView, so it is area-dependent and is limited to this fixed geometry, not a general angular tolerance. Synthetic four winding/view orientations and six invalid/degenerate/edge-on inputs pass.

All48 light endpoints are ray-tested without reference to either normal. Ns and Ng endpoint coordinates are asserted exact. Visibility is the same opaque two-sided1166geometry with the previous1e-5 ray start/end inset. All four Ns raw float64 and RGB565 outputs exactly reproduce the prior visibility-ON diagnostic using the expanded cache. This control completed before Ng images were accepted. Coverage is unchanged, and no source RGB is used as a shading input.

## Stable-foreground results

| View | Normal | Bright IoU % | Dark IoU % | Baseline RGB % | Direction RGB % |
|---|---|---:|---:|---:|---:|
| front | Ns |63.2954|77.6808|73.7372|73.3736|
| front | Ng |63.0164|80.6651|74.7450|74.1480|
| oblique | Ns |39.0488|77.0934|72.6084|72.5280|
| oblique | Ng |33.9950|82.7082|73.5460|72.8159|

Ng does not repair the main bright-position mismatch. Oblique bright FP90→97 and FN397→435; front FP82→114 despite FN466→450. Improvements in dark response and RGB do not offset this task's regressions or certify the full goal. In the oblique view the unified sculpt object's bright FP+FN increases by21pixels and the ivory tail tip by10; the tail silhouette improves by7. Full object/sign counts are retained.

## Full foreground and uncertainty (descriptive, not PASS)
Full-foreground bright/dark IoU:
- front Ns57.4085/73.4385%, Ng55.4230/75.9937%.
- oblique Ns33.9181/73.6152%, Ng29.3153/78.5354%.

The original uncertain response regions remain729front /698oblique pixels. Their bright/dark IoU is shown only as a descriptive statistic:
- front Ns26.2411/23.4568%, Ng19.1223/26.9784%.
- oblique Ns15.8590/19.4757%, Ng12.9870/23.6025%.

No uncertain pixel counts as a success or zero error; no alpha boundary is removed. evaluation.json retains full conditional scores and each-seed comparisons. Whole foreground here is the unchanged source-foreground domain, NOT full-frame/background accuracy. The renderer's overall goal is not met.

## Cost
The normal-independent cache performs945,984rays. Cache tracing/setup per-case sum61.971seconds. Entire run160.309seconds includes validation, cache generation, the Ns replay control and Ng shading. Primary process user159.782seconds/system1.771seconds, peakRSS224,172KiB. This includes Blender, Python, compressed-array access, controls and result storage; it is not a benchmark of a product implementation or incremental firmware memory. The same normal-independent cache is reused across the two arms. No device operations or budget-limit changes.

## Conclusion
Reject a simple Ns→flatNg substitution as a fix for the current direction-brightening failure. The earlier Ns/Ng angle/error association did not establish causality; this test shows that changing only to Ng worsens the oblique target. It does not prove Ns correct, validate the reduced geometry against the original, or rule out richer source-normal interpolation. No default, original reference, material or geometry changes are recommended from this A/B.

## Reproduction
Requires the prior private candidate/reference/observer data; no assets are embedded in the code bundle.
blender -b -t 8 --python fox-v3-position-diagnostic/normal-ab/run_normal_ab.py -- fox-v3-position-diagnostic
python fox-v3-position-diagnostic/normal-ab/summarize_normal_ab.py

The existing visibility shader library must be built first using the preserved prior command. PLAN.md, pre-execution-hashes.txt, synthetic.json, NS_CONTROL_PASS.json and run-report.json preserve execution/control evidence. Zero/finite/winding synthetic tests can run independently: python fox-v3-position-diagnostic/normal-ab/normal_geometry.py.

## Independent final verification
Freshly compiled lighting library and all945,984geometry rays reproduced eight RGB565 arrays and all raw float64, Ng fields, visibility bits and coverage exactly. Blocked and near-hit counts match. Independent scoring matches616metric values and1788source-object table fields. Reference RGB enters scoring only. Independent wall154.022seconds/user152.266/system1.732/peakRSS220,280KiB; trace-only57.149seconds. Evidence: independent-time.json and independent-run-report.json. No device-fit or normal-correctness claim follows from reproducibility.
