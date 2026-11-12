# Current lid8 full-v3 HDR display/filter experiment

Observer controls passed before postprocessing: actual shader final-winner linear RGB captured immediately before clamp/encoding, one fresh process per frame, finite nonnegative values and zero no-hit background. All 20 original RGB/depth buffers, all ten original compact snapshots, all non-timing metadata and input pins match frozen actual-lid8-v2. No reference image is supplied to the native renderer. Only two copied sources contain observer additions; production geometry, lighting, material, transport, codec, precision and 65,536-byte snapshot budget are unchanged. Source diff and exact copied-source hashes are retained.

The observer's 777,600-byte static HDR array is diagnostic RAM, not a product allocation proposal. The ten functional captures took 83.646 seconds wall time on this host; this is neither a production render benchmark nor an incremental observer-cost estimate. Postprocessing was measured after capture and before independent heavy work.

The original BH3x3 integer-neighbor filter and display math are unchanged. All no-hit/out-of-image samples remain black with their fixed weights, then HDR average → display → RGB565 once. It is not subpixel antialiasing. LUT/settings/dependency pins are unchanged. Point/sRGB conversion reproduces original RGB565 in every condition. PNG dither=1 is not implemented by the continuous profile approximation.

Full evaluator data preserve reference-only stable/uncertain masks, full foreground including native missing pixels, per-seed scores, all unknowns, bright/dark FP/FN and inactive false positives. No threshold, exposure, weights or fit is selected from these results. The inherited geometry preservation limitation and unsupported higher transport/product lifecycle remain. There is no default adoption or global 60% establishment.

# Current-lid8 fixed display/filter comparison summary

All ten captured RGB/depth controls and all ten point/OFF conversions are exact to actual-lid8-v2. Four arms each retain all ten color scores and eight response scores over stable, uncertain, pooled full foreground and all eight individual reference seeds. Inputs, frozen evaluator, reference settings, official dependency pins and compiled profile binary passed their checks.

## Conditional color results

- profileAtPoint: stable RGB agreement delta -1.356596 to +0.668208 percentage points; 5/10 improved, 5/10 worsened.
- profileAtFilter3: stable RGB agreement delta -1.763398 to +0.265920 percentage points; 3/10 improved, 7/10 worsened.
- filterAtProfileOff: stable RGB agreement delta +1.338100 to +1.932420 percentage points; 10/10 improved, 0/10 worsened.
- filterAtProfileOn: stable RGB agreement delta +0.914444 to +1.530132 percentage points; 10/10 improved, 0/10 worsened.
- Color metric interaction is negative in all ten cases: -0.462954 to -0.360724 pp. Separate filter/profile improvements cannot be added.

## Conditional response results

- Critical oblique direction brightening IoU is point/OFF 0.392374, point/ON 0.444840, filter3/OFF 0.452920, filter3/ON 0.492974. Even the largest of these remains below 0.60. No combination establishes the global 60% goal.

- Filtering with profile OFF improves direction-sign agreement in all eight responses and reduces luma/RGB RMSE in all eight. It decreases intensity-response magnitude agreement in both views while improving that metric for the other six responses.
- Adding the profile after filtering reduces luma/RGB RMSE in all eight responses but worsens albedo sign agreement in both views and ambient sign agreement in the oblique view. It also reduces albedo response magnitude agreement and albedo darkening IoU in both views.
- Direction inactive false positives rise from point/OFF 69 to filter3/ON 137 (front), and 85 to 153 (oblique). Intensity inactive false positives rise 10 to 29 and 7 to 21. Ambient rises 0 to 3 and 0 to 6; albedo stays zero. These are tradeoffs, not a clean dominance result.
- Empty bright/dark IoU domains remain null/UNKNOWN, never zero or pass. FN/FP for every stable/uncertain/pooled/per-seed response domain are in evaluation.json responseConfusion. Full metricwise contrasts and interactions are preserved, including signed correlation.

## Full-foreground and uncertain diagnostics

Adding AgX worsens pooled full-foreground RGB agreement in all ten conditions: point profile delta -1.853015 to -0.029788 pp; after filter delta -2.204568 to -0.366145 pp. Stable-subset gains must not hide this full-foreground regression.

The filter reduces missing support but grows outside-source support: front native missing/extra 620/11 becomes filtered75/121; oblique719/8 becomes112/144. These are fixed-filter support counts, not new geometry or improved native depth coverage. Native coverage is unchanged.


These ranges retain every case without masking away native missing silhouette. They are descriptive, not acceptance criteria. Each-seed ranges cover 80 color and 64 response scores per arm.

| Arm / domain | RGB agreement range % | Response luma RMSE range | Bright IoU unknown | Dark IoU unknown |
|---|---:|---:|---:|---:|
| point-off / uncertainSubsetDescriptiveNotAcceptance | 73.936114 to 81.362624 | 0.009163 to 0.041579 | 4/8 | 2/8 |
| point-off / pooledFullForegroundDescriptive | 70.835515 to 77.609078 | 0.023995 to 0.080702 | 4/8 | 2/8 |
| point-off / eachReferenceSeedFullForeground | 70.826116 to 77.609043 | 0.024050 to 0.080987 | 16/64 | 14/64 |
| point-on / uncertainSubsetDescriptiveNotAcceptance | 70.677548 to 77.987327 | 0.007681 to 0.040416 | 4/8 | 2/8 |
| point-on / pooledFullForegroundDescriptive | 70.660735 to 75.756063 | 0.022702 to 0.067223 | 4/8 | 2/8 |
| point-on / eachReferenceSeedFullForeground | 70.650666 to 75.763277 | 0.022776 to 0.067583 | 16/64 | 14/64 |
| filter3-off / uncertainSubsetDescriptiveNotAcceptance | 74.888607 to 82.125397 | 0.010106 to 0.038571 | 4/8 | 2/8 |
| filter3-off / pooledFullForegroundDescriptive | 72.394682 to 78.953117 | 0.022797 to 0.077952 | 4/8 | 2/8 |
| filter3-off / eachReferenceSeedFullForeground | 72.385551 to 78.953558 | 0.022857 to 0.078244 | 16/64 | 14/64 |
| filter3-on / uncertainSubsetDescriptiveNotAcceptance | 71.551891 to 78.624461 | 0.007609 to 0.037210 | 4/8 | 2/8 |
| filter3-on / pooledFullForegroundDescriptive | 71.887609 to 76.748549 | 0.021435 to 0.064282 | 4/8 | 2/8 |
| filter3-on / eachReferenceSeedFullForeground | 71.877217 to 76.755230 | 0.021528 to 0.064643 | 16/64 | 14/64 |

Null/unknown counts are reported, never imputed. Inactive false positives use unchanged reference-only stable inactive pixels and the frozen 2/255 candidate luma threshold; full per-case counts are retained alongside all response-domain FP/FN.

## Support, profile limits and original-run cost (superseded by run002 below)

- Filter support expansion is 655 pixels front and 743 oblique. Foreground-support IoU rises from 0.881346 to 0.963891 front and 0.876276 to 0.957418 oblique. This is descriptive support expansion, not geometry improvement; missing/extra pixels remain scored.
- Official OCIO-derived LUT approximation, not processor-exact equivalence. All forty arm/case high-domain-clamp counts are zero; covered/background and support/outside-support counts are separately zero. The fixed C flag reports input >5898.240000132513 only, not old display clipping at 1.0 or output gamut clipping. Black input clamp flag is zero.
- Read-only LUT is 3,295,500 bytes. Each full float64 HDR array is 777,600 bytes; RGB565 output is 64,800 bytes. Native observer allocation, HDR/filter arrays, depth and mask temporaries are separate; Python and library overhead mean these are not a proven peak-RAM or product-fit budget.

- point-off: case-median host time 0.500908–0.593959 ms, each from eleven repetitions. Display and filter time are separate; clamp-attribution calls are excluded.
- point-on: case-median host time 1.859174–2.214441 ms, each from eleven repetitions. Display and filter time are separate; clamp-attribution calls are excluded.
- filter3-off: case-median host time 0.508249–0.679638 ms, each from eleven repetitions. Display and filter time are separate; clamp-attribution calls are excluded.
- filter3-on: case-median host time 1.930040–2.194782 ms, each from eleven repetitions. Display and filter time are separate; clamp-attribution calls are excluded.
- filterOnly: case-median host time 0.727531–0.955096 ms, each from eleven repetitions. Display and filter time are separate; clamp-attribution calls are excluded.

These are host postprocessing timings, not device or total renderer performance. No exposure/threshold/mask/profile fit or regeneration, no adoption, no global 60% acceptance claim.

## Artifacts

- postprocess-001/REPORT.md: all ten color cases, all 32 arm/response rows and all 40 clamp rows.
- postprocess-001/evaluation.json, contrasts.json, interaction.json, support.json, cost.json, clamps.json: full metrics and costs.
- postprocess-001/input-hashes-before.json, input-hashes-after.json, output-hashes.json, scope.json, COMPLETED.json: checks and provenance.
- filter-tests.json: original filter tests plus unchanged math function ASTs, null handling and FP/FN checks.
- SUMMARY.json: machine-readable concise comparison with all eight response deltas per metric.


# Postprocessing v2: timing evidence and clipping counts

Postprocess-002 preserves every one of the 40 RGB565 buffers, all metrics, contrasts, interactions, support arrays, old clamp fields and non-timing cost fields from postprocess-001. All original input/output pins remain valid. No mathematical/profile/reference change.

## Eleven-repetition host timing evidence

cost.json now retains rawNs for every eleven-repetition timing set. Independently reaggregated min/median/max pass for 40 display sets and 10 filter sets (filter measurements are shared by the two filter arms). Auxiliary clipping attribution remains outside timing.

- point-off display: case-median range 0.502410–0.582541 ms.
- point-on display: case-median range 1.911410–2.189851 ms.
- filter3-off display: case-median range 0.505143–0.627218 ms.
- filter3-on display: case-median range 1.936458–2.267829 ms.
- Filter alone: case-median range 0.716694–0.820531 ms.

Host postprocessing only, not device or total renderer performance. RO/RAM limitations and all quality tradeoffs in SUMMARY.md remain unchanged.

## Different clipping meanings

AgX high-domain clamp flag remains zero everywhere, with threshold 5898.240000132513. That is not legacy sRGB clipping at 1.0. preDisplayAboveOnePixels counts any channel >1.0 in the actual arm source; preDisplayAboveOneChannels counts those channels. legacySrgbInputClippedPixels equals that pixel count for OFF and is null (not applicable) for ON. Counts below independently recompute from raw HDR or a direct zero-padded nine-neighbor stencil.

| View / case | Point HDR >1 pixels / channels | Filter HDR >1 pixels / channels |
|---|---:|---:|
| front/baseline | 1509 / 2109 | 1489 / 2054 |
| front/direction | 1130 / 1658 | 1124 / 1622 |
| front/intensity | 673 / 990 | 642 / 926 |
| front/ambient | 1804 / 2538 | 1794 / 2486 |
| front/albedo | 348 / 489 | 325 / 444 |
| oblique/baseline | 1522 / 2081 | 1502 / 2016 |
| oblique/direction | 881 / 1287 | 868 / 1257 |
| oblique/intensity | 708 / 972 | 665 / 904 |
| oblique/ambient | 1768 / 2446 | 1765 / 2403 |
| oblique/albedo | 431 / 570 | 401 / 520 |

Quality conclusions remain unchanged: oblique direction brightening IoU best measured 49.2974%, still below 60%; inactive false positives 85→153; filter support expansion is not geometry improvement; profile-after-filter has mixed color and response tradeoffs. Full foreground/uncertain/per-seed/unknown summaries remain in SUMMARY.md and are numerically identical here.

Artifacts: postprocess-002/cost.json and clamps.json; postprocess-v2-comparison.json; verify_postprocess_v2.py; SUMMARY-v2.json. Original postprocess.py, test_filter.py, postprocess-001 outputs, SUMMARY.md and SUMMARY.json were preserved.


## Independent verification

Independent fresh C capture reproduced all ten observer frames: 40 files (ten HDR, twenty RGB/depth, ten snapshots) exactly match run001 and all baseline non-timing metadata match. Separate BH convolution, LUT tetrahedral interpolation, sRGB and quantization reproduced all forty arm RGB565 images. Independent cost002 reaggregation confirmed 180 timing summary values from the retained raw eleven samples. Full input/output pins remain unchanged. Native observer verification: /tmp/lid-display-observer-independent/independent-review.json. Cost evidence: /tmp/lid-display-cost-independent.json.
