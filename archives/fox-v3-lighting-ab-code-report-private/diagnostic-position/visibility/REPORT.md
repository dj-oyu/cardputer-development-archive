# Fixed direct-visibility ablation

Status: measured host-only diagnostic; independent fresh-C-library and full-BVH-rerun PASS. No official reference, native default, sample count or epsilon was changed.

## Fixed experiment
Same actual native1166-triangle geometry and camera winners, float32-captured interpolation weights, interpolated SNORM (normalized by lighting evaluator without re-SNORM), samerho, threeDISK16 samples, unoccluded uniform world, sRGB/clamp/RGB565. All triangles are opaque and two-sided. BVH uses actual evaluated native vertices, not high-resolution source geometry. Start and endpoint inset are each1e-5 Blender units along the ray; BVH enlargement epsilon0. No face/object exclusion or Ng lighting mask was added. This ray-direction offset is not equivalent to a geometric-normal offset.

The all-visible control is completed before ablation: all four baseline/direction×2view raw float64 and RGB565 arrays exactly match the previous unoccluded pixel diagnostic. Synthetic BVH rays confirm hits from both triangle sides and endpoint-range rejection. No reference RGB enters BVH construction, light endpoints or shading. Reference images enter only the subsequent fixed scoring script.

## Results
Percent values below are on the unchanged v3 stable foreground; unknown pixels remain unresolved.

| View | Setting | Bright IoU | Dark IoU | Baseline RGB | Direction RGB |
|---|---|---:|---:|---:|---:|
| front | Original vertex arm |55.0779|76.8737|75.3097|75.7935|
| front | Pixel, visibility OFF |60.0512|71.9525|74.2665|74.3797|
| front | Pixel, visibility ON |63.2954|77.6808|73.7372|73.3736|
| oblique | Original vertex arm |29.7297|82.6805|74.6338|75.1154|
| oblique | Pixel, visibility OFF |33.8337|73.9518|73.4121|73.5369|
| oblique | Pixel, visibility ON |39.0488|77.0934|72.6084|72.5280|

Visibility OFF→ON reduces bright FP151→82 front and157→90 oblique. Bright FN473→466 and416→397. Source-dark/native-bright119→49 in oblique and110→44 in front. Specifically, the source tail silhouette's source-dark/native-bright pixels46→1 in BOTH views. The opposite tail error, source-bright/native-dark, regresses front9→13 and oblique3→5. Tail reverse-sign errors are not eliminated in general. This establishes a causal contribution from missing direct-light visibility under this fixed diagnostic. It does not establish visibility as the sole or majority cause of every residual.

Regressions remain visible: RGB loses0.53–1.01points relative to pixel OFF; source bright/native dark increases50→54 in oblique; oblique dark IoU remains below the original vertex arm82.68%. Oblique bright39.05% is far below60. Head/cheek and other residuals remain. The full goal is not met, and front's isolated bright score is not an overall success.

## Runtime and storage
-449,445 positive-kernel rays total over4cases; other samples have zero contribution and need no visibility query.
-154,621 blocked rays.725 blocked hits are within1e-4 distance from the offset origin. Some can be legitimate neighboring/self surfaces; epsilon robustness is not established and no epsilon tuning was performed.
-Per-case trace/shade/output wall times12.28,12.16,15.12,13.25seconds; sum52.81seconds.
-Total run143.34seconds includes setup AND the required all-visible control, so it is not the visibility-only time.
-Process peak RSS221,916KiB includes Blender/Python/runtime/analysis buffers. It is not incremental renderer RAM.
-The native geometry's packed float32 vertices + uint32 indices occupy24,180B. BVH actual allocation is not exposed by mathutils and remains unknown. No firmware resource-fit claim or limit increase.
-Observer storage2,679,808B from the earlier step remains host diagnostic overhead; ray bitsets/results and Python objects add more.

Independent full rerun measured user140.272s + system1.583s, wall141.876s including controls, visibility-only4case wall52.587s, and peakRSS211,448KiB. Primary run reported wall time and peak RSS, not isolated C shading CPU. Two failed environment/session starts were not interpreted as results; interrupted logs are retained. Only the completed fixed-plan run is scored.

## Next implementation basis
Direct visibility is a defensible missing lighting capability: it removes a localized, measured tail sign error without any image-dependent input. The next candidate implementation should expose a bounded geometry-visibility input to the lighting evaluation, with explicit geometry ownership, pose/version invalidation, sidedness, bias and ray budget tests. Do not copy this Blender/Python BVH into the product or claim its memory is acceptable. Keep it opt-in until the same checks, cost accounting and all five conditions are rerun.

Do not spend on more light samples or globalgain to hide the remaining direction-position error. Boundary coverage remains a separate large contributor. Normal/BRDF/AgX/GI differences have not been individually isolated. This two-condition diagnostic supports a next bounded feature test, not automatic adoption or a goal declaration.

## Reproduce
Compile shader_visibility.c with the existing frozen include paths and no separately linked fox_disk_lighting.c (it is included by the diagnostic translation unit):
cc -std=c11 -O2 -shared -fPIC -ffp-contract=off -fexcess-precision=standard -Ifox-v3-lighting-ab/product/main -Ifox-v3-lighting-ab/physical fox-v3-position-diagnostic/visibility/shader_visibility.c -lm -o fox-v3-position-diagnostic/visibility/shader_visibility.so

blender -b -t 8 --python fox-v3-position-diagnostic/visibility/run_visibility.py -- fox-v3-position-diagnostic
python fox-v3-position-diagnostic/visibility/summarize_visibility.py

Requires the preserved observer/pixel probe data regenerated by the preceding diagnosis scripts and the private v3 reference outputs. Formal reference hashes remain pinned. PLAN.md and pre-execution-hashes.txt retain the pre-run contract.

## Independent verification
Freshly compiled C library and separate Blender BVH run reproduced all449,445ray queries: four RGB565 arrays, raw float64, visibility bitmasks and coverage exact. Blocked/near-hit counts, all reported metrics, object counts and color regressions independently match. All six pinned original inputs were unchanged. Timing evidence: independent-time.json / independent-run-report.json. This is diagnostic reproducibility, not epsilon/quadrature convergence or product budget certification.
