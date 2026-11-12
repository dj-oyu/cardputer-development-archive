# Fixed filter-weighted AA host diagnostic

The predeclared3×3 main arm improves direction bright IoU from63.30→66.28%front and39.05→46.09%oblique. The fixed5×5 diagnostic reaches68.79/48.65%, but oblique remains below60 and grid sensitivity remains substantial. No AA/default adoption, reference replacement or overall60%achievement. Only baseline/direction×2views were tested, not all5conditions.

## Fixed contract

Same1166geometry, same actual projection/float32 depth winner, selectedphysicalside SNORM Ns interpolation, DISK16×3 shader, geometry visibility and uniformworld. ReferenceRGB is used only in scoring. Current black nohit background remains black, with no floor reconstruction or source-color borrowing. BLACKMAN_HARRIS analytic separable weights use UIwidth1.5/support±1.5, all-grid normalization including nohit. Unclamped linearraw is summed first, then existing clamp/sRGB/565 happens once. This differs from averaging encoded/quantized samples. It does not reproduce Cycles' stochastic lookup table or AgX.

One-point control precedes grids: all4positions/normals/raw/RGB/coverage are exact vs previous Ns+visibility. Adapter's original24buffers are exact. Existing69input pins and9pre-execution code/plan pins are unchanged. Pre-execution manifestSHA256 dce886d413542d7cce8df3ecd68cfc1941e4fa37a71f1846ddc91390e2f8c532. Interrupted output is never overwritten by automatic resume; oldpartial/completed arms require a separate explicit attempt. This run completed all12cases.

## Results

|View/metric|Point control|3×3 main|5×5 diagnostic|
|---|---:|---:|---:|
|Front brightIoU%|63.295|66.278|68.795|
|Front darkIoU%|77.681|81.553|82.373|
|Front brightFP|82|131|124|
|Front brightFN|466|389|355|
|Oblique brightIoU%|39.049|46.089|48.649|
|Oblique darkIoU%|77.093|78.788|79.714|
|Oblique brightFP|90|122|105|
|Oblique brightFN|397|326|313|
|Front stableforegroundRGB baseline%|73.737|75.616|76.735|
|Front stableforegroundRGB direction%|73.374|75.167|76.252|
|Oblique stableforegroundRGB baseline%|72.608|74.365|75.352|
|Oblique stableforegroundRGB direction%|72.528|74.390|75.411|

False negatives fall but false positives increase in both views. Any-sample support outside the formal mask also rises from11→121front and8→143oblique in the3×3arm. This is not unqualified improvement. Full-frame descriptive RGB agreement remains only33.89–34.22%for3×3 and34.06–34.36%for5×5. The absent studio background/floor remains a large limitation, not a new required foreground acceptance gate. Outsideforeground error is retained and reported. Uncertain729front/698oblique pixels remain in descriptive reporting, never counted as success.

## Quadrature sensitivity, not convergence proof

The fixed3point offsets are−1,0,+1, so they land on neighboring integer pixel centers. Its raw output equals exactly the weighted3×3 neighborhood of the existing point raw image for all4cases (integer-grid-check.json). Thus3×3 introduces no new subpixel geometry samples in this fixture; its measured effect is linear filtering of point samples. The5point offsets−1.2,−.6,0,.6,1.2 do introduce fractional positions. These settings were fixed before rendering and were not selected for best score.

The central2Dweight differs strongly: about.810for3×3 versus.311for5×5. ForegroundRGB3→5 MAE is.0196–.0224, and2416–2477pixels differ across the4images; max channel differences reach.613. BrightIoU changes about2.52/2.56percentagepoints. These are material differences, not evidence of convergence. No further grid was tried or silently promoted to the main result.

## Measured host cost

|Arm(all4cases)|Shadingqueries|Positivekernelshadowrays|Wallseconds|CPUseconds|
|---|---:|---:|---:|---:|
|Pointcontrol|19708|449445|5.900|5.900|
|3×3|177372|4045005|50.752|50.748|
|5×5|492222|11218831|139.701|139.690|

Whole run wall196.445s, processuser197.273s/system.329s, peakRSS206404KiB including Blender/Python/BVH. Approximately8.60×/23.68× measured wall vs this pointcontrol implementation. Earlier estimates were much higher because earlier probes repeatedly decompressed input arrays; this run loads inputs once. The exact3×3 integer convolution identity means its measured repeated-shading cost is avoidable, but no runtime optimization or firmware implementation was made. BVH/host memory is not a product memory budget.

## Reproduce and preservation

From workspace root with matching private input packs present:

python3 fox-v3-position-diagnostic/weighted-aa/prepare.py && blender -b -t8 --python fox-v3-position-diagnostic/weighted-aa/run.py -- /absolute/workspace/fox-v3-position-diagnostic && python3 fox-v3-position-diagnostic/weighted-aa/summarize.py

Use a fresh output attempt for reruns; completedgrid files intentionally block overwrite. Code bundle excludes original .blend, media, geometry and raw buffers. Old advanced2400pack remains unrecovered and is not represented by this rebuilt1166candidate. Private original/ref/native input identities must be checked rather than approximated.

Independent verification PASS: freshC/raster full replay of689302shade queries and15713281rays reproduces all12RGB/raw/coverage/weightedCoverage outputs and hit counters exactly. All1116metrics, encoding results, fixed masks/uncertainty and all69source pins/9freeze pins independently match. O0/O2ASanUBSan tests pass. Independent run wall196.174s/user195.900s/system.268s/peakRSS235276KiB. Independent3×3convolution control is also float64exact.
