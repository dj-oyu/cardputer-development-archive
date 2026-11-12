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

## Support, profile limits and cost

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
