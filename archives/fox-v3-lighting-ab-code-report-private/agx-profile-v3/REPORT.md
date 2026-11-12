# Fixed v3: explicit AgX vertex profile A/B

## Result

The profile is a valid opt-in host prototype, not a default adoption or a 60% goal pass. The fixed original, ten conditions, uncertainty masks and thresholds are unchanged. Original images never enter rendering or LUT generation.

Direction brightening position IoU improves front 55.08 → 61.85%, oblique 29.73 → 33.79%. The oblique failure remains. Direction response magnitude regresses front 82.23 → 75.03%, oblique 76.20 → 69.83%. Baseline RGB improves modestly; front intensity and both albedo RGB regress. All conditional values and uncertain results are retained in metrics.json and the complete score artifacts. No N/A or uncertain area becomes PASS.

## Fixed synthetic accuracy before native application

The installed official OCIO config and all dependencies are hash-pinned in profile/provenance.json and preserved privately. Source is Linear Rec.709 → sRGB display / AgX / AgX - Medium High Contrast / exposure 0 / gamma 1. A newly generated 65³ LUT uses a fixed log1p Rec709 shaper, not the lost earlier E-gamut experiment.

84,981 independent accepted HDR test colors pass the predeclared per-channel RGB565-quantum gates RMSE≤0.5, P99≤1, max≤2. Max errors are 1.16845 / 1.58463 / 1.23990 quanta. All-domain includes mixed-channel out-of-range samples; out-of-domain is explicitly flagged, never omitted to pass. Additional first-cell 5,696 samples are exact, 15 invalid-input atomic rejects pass. Profile/report contains group counts and continuous versus quantized error.

Official Image.save_render PNG16/dither0 and Image→Composite ONLY PNG16/dither0 agree exactly on 1,024 independent synthetic colors. This does not claim byte equality to reference PNG8/dither1. Native output remains RGB565 with no added dithering.

## Native implementation and compatibility

Inputs and model are the preserved 1166-triangle / 849-partition-vertex export. `ayatsuri_model_instance_agx_profile` requires explicit linear + physical lighting and defaults OFF. Wrong owner/generation, busy state, non-boolean enable and prerequisite violations reject. Changes invalidate borrowed evaluated views, same value does not. OFF restores the original arena bytes. Shared LUT lifetime is static read-only.

The transform replaces only the final HDR clamp/sRGB step, at each vertex and each front/back A/B color. Existing rasterization interpolates the resulting RGB565 display colors. This is not post-interpolation HDR display mapping. Area/world occlusion, ground emission/reflection, GI, PBR/specular and general asset-unit API remain unsupported.

All 40 OFF RGB/depth buffers match old four-both-002 exactly. All 20 ON depth buffers also match. Every ON frame makes 3,396 profile calls, zero high-domain clamps. Reverse-order and post-disposal snapshot tests pass. No geometry, normal, face order, lighting, reference or score threshold was edited.

## All conditions (conditional stable subsets)

| Condition | RGB OFF→ON % | bright IoU OFF→ON % | dark IoU OFF→ON % | magnitude OFF→ON % | bright false positives OFF→ON |
|---|---:|---:|---:|---:|---:|
|front-baseline|75.310 → 75.921|N/A|N/A|N/A|N/A|
|front-direction|75.793 → 76.305|55.078 → 61.853|76.874 → 78.415|82.233 → 75.030|194 → 230|
|front-intensity|76.413 → 76.081|N/A|81.585 → 85.388|73.527 → 75.811|0 → 0|
|front-ambient|74.621 → 76.580|81.844 → 85.668|N/A|70.361 → 69.851|0 → 6|
|front-albedo|78.472 → 77.540|N/A|87.955 → 87.955|78.927 → 80.768|0 → 0|
|oblique-baseline|74.634 → 75.424|N/A|N/A|N/A|N/A|
|oblique-direction|75.115 → 75.670|29.730 → 33.788|82.681 → 83.949|76.199 → 69.826|216 → 244|
|oblique-intensity|75.632 → 75.936|N/A|84.315 → 87.390|69.001 → 69.610|0 → 0|
|oblique-ambient|74.158 → 76.290|82.703 → 84.980|N/A|66.377 → 63.665|6 → 18|
|oblique-albedo|77.692 → 77.430|N/A|87.383 → 87.332|72.695 → 76.300|0 → 0|

Full-frame shape IoU remains 88.1346% front / 87.6106% oblique. Missing source foreground remains 620 / 720 pixels; extra remains 11 / 8. Missing pixels are not dropped from foreground RGB error. All stable inactive false positives, sign/correlation/RMSE, pooled descriptive values and uncertain subsets remain in metrics.json. A null empty-union IoU stays N/A, never becomes perfect.

## Separate postpixel diagnostic

The pre-existing grid3 3×3 Blackman-Harris HDR average is transformed after sampling/filtering. It includes pixel shading and direct area visibility absent from the main vertex arm, so its scores cannot be attributed solely to a vertex implementation. The raw image is generated entirely from geometry/material/lights, not original image samples. Four baseline/direction cases only. OFF outputs exactly match previous grid3 RGB565. Both arms preserve coverage/background.
- front bright IoU 66.2776 → 72.0975%; dark 81.5534 → 84.0181%.
- oblique bright IoU 46.0890 → 49.8826%; dark 78.7879 → 81.4682%.

This is much smaller than the ~20–22pt same-rich-HDR oracle effect: the native HDR field itself is not rich Blender HDR. A profile alone does not close that gap. Postpixel processing requires the existing 777,600-byte float64 RGB image (or a separately designed streaming/owned HDR path), a 64,800-byte output, and existing host geometry/filter/visibility resources. That storage is not implemented in the product snapshot. The four-case diagnostic is not full goal acceptance. Final postpixel-003 adds source/LUT/binary/reference/foreground pre/post hash guards and a fixed32400-pixel API bound; all eight RGB buffers and metrics are exactly equal to preserved001/002.

## Cost and ownership

- Shared immutable LUT: **3,295,500 bytes** (float, not the old 1.65MB U16 LUT). Profile object text/RO total 3,296,516 bytes, zero data/BSS. Runtime has local scratch only. This is not a device-fit claim.
- Instance control: **584 → 592 bytes**, +8 even while OFF (boolean fits prior padding; counters add storage). Arena 65,892 bytes and cold model 35,636 bytes unchanged.
- All conditions: 45 records, **24,628 used snapshot bytes**, capacity65,536 unchanged. Maximum work56,462 unchanged. Depth scratch7,680 and colorband3,840 unchanged. No quota increase or precision reduction.
- O2 unsanitized 11 alternating process repetitions per arm/condition. Evaluation includes initialization; no device timing. Significant host noise means ratios below1 are not claimed speedups. Raw/min/max remain timing-001/results.json.

| Condition | eval OFF→ON ms | ratio | raster OFF→ON ms |
|---|---:|---:|---:|
|front-baseline|6.836 → 7.661|1.121|2.318 → 2.358|
|front-direction|7.220 → 7.391|1.024|2.403 → 2.509|
|front-intensity|6.746 → 7.555|1.120|2.411 → 2.427|
|front-ambient|7.958 → 7.868|0.989|2.641 → 2.528|
|front-albedo|7.794 → 9.598|1.231|2.989 → 2.588|
|oblique-baseline|10.221 → 9.319|0.912|2.893 → 3.125|
|oblique-direction|8.647 → 7.964|0.921|2.699 → 2.511|
|oblique-intensity|7.618 → 8.313|1.091|2.648 → 2.480|
|oblique-ambient|7.060 → 8.509|1.205|2.434 → 2.500|
|oblique-albedo|7.682 → 8.792|1.144|2.765 → 2.486|

## Validation and provenance

Functional profile API test passed; scorer38 tests retain previous29 plus strict profile flag/name/counter/dependency and five-file provenance pin regressions. Coordinated rehash changes do not bypass the pin. Native source snapshots are off-001 and on-001; exact binary/source/input hashes are in their manifests. The root profile final report adds synthetic/compositor controls completed after the snapshots, with identical C/header/LUT/frozen contract hashes. Scoring only uses pinned core files, not evolving narrative reports.

Independent main review passed: O2 ASan/UBSan 40 renders / 80 RGB-depth buffers exactly match; 84,981 profile samples independently re-evaluated with FFmpeg PNG16 decoding, all metrics match; O0/O2 tetrahedral boundaries/alias/atomic rejection and model API/snapshot lifetime tests pass; 2,260 independently recomputed score values and scorer38 tests pass. Final independent postpixel rebuild matches all eight buffers, rejects incorrect size atomically, and verifies all52 input hashes. All independent checks are complete; this is verification of the experiment, not achievement of the quality goal.

## Reproduce

From this task root, run generation commands in profile/REPORT.md, then:
```sh
HONE_LINEAR_LIGHT=1 HONE_PHYSICAL_LIGHT=1 HONE_AGX_PROFILE=0 python code/run.py /absolute/fresh-off
HONE_LINEAR_LIGHT=1 HONE_PHYSICAL_LIGHT=1 HONE_AGX_PROFILE=1 python code/run.py /absolute/fresh-on
python scoring/score_candidate.py /absolute/fresh-off/candidate-manifest.json --output /absolute/fresh-score-off
python scoring/score_candidate.py /absolute/fresh-on/candidate-manifest.json --output /absolute/fresh-score-on
```
These commands need the same private source/geometry/reference assets at their manifest paths. Those assets are intentionally not in the code/report bundle. The pure profile generator and synthetic tests require only the pinned installed Blender config, not fox images.

## Distribution

The installed config refers to ocio-license.txt, which is absent from this installation. Generic Debian Blender copyright is not treated as specific AgX license clearance. Derived LUT and dependency assets remain private; no public redistribution or product acceptance is authorized by this report. Original models, images, raw image buffers and geometry are excluded from the saved bundle.
