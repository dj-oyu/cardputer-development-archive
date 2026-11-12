# Private actual-C geometry comparison

All three runs completed all ten conditions and forward/reverse RGB565/depth equality with unchanged admission caps. Frozen reference/masks/thresholds and renderer/light/transport implementations unchanged. Old fresh control matched all 40 frozen buffers and all ten score/domain results exactly.

Neither candidate is formally adopted. The separate complete-occlusion-preservation geometry gate remains FAIL. Global 60% reproduction remains NOT_ESTABLISHED. These are conditional/descriptive quality comparisons, not a geometry guarantee.

## Stable-subset RGB agreement (%)

| Condition | Old | Stage 1 | Stage 2 | Stage 1 delta pp | Stage 2 delta pp |
|---|---:|---:|---:|---:|---:|
| front-baseline | 72.646989 | 72.706314 | 72.748959 | +0.059325 | +0.101970 |
| front-direction | 71.774828 | 71.790289 | 71.822759 | +0.015462 | +0.047932 |
| front-intensity | 73.644677 | 73.688793 | 73.730384 | +0.044116 | +0.085707 |
| front-ambient | 70.989221 | 71.039498 | 71.084588 | +0.050277 | +0.095366 |
| front-albedo | 76.328243 | 76.393109 | 76.438433 | +0.064865 | +0.110190 |
| oblique-baseline | 71.282040 | 71.375879 | 71.443736 | +0.093839 | +0.161696 |
| oblique-direction | 70.504242 | 70.578458 | 70.654883 | +0.074216 | +0.150641 |
| oblique-intensity | 72.264339 | 72.336469 | 72.422050 | +0.072130 | +0.157711 |
| oblique-ambient | 69.725547 | 69.799492 | 69.866525 | +0.073945 | +0.140978 |
| oblique-albedo | 75.257303 | 75.325468 | 75.394257 | +0.068165 | +0.136954 |

## Regressions retained

Stage 1: response magnitude declines in 3/8 conditions (worst -0.457537 pp), signed correlation in 3/8, response luma/RGB RMSE worsen in 2/8 each. Direction agreement improves in seven and is unchanged in one. Shape IoU/missing/extra pixels unchanged.

Stage 2: response magnitude declines in 4/8 (worst -0.308459 pp), direction agreement declines in 1/8 (-0.018850 pp), signed correlation in 2/8, luma RMSE worsens in 3/8 and RGB RMSE in 2/8. Oblique source-missing pixels improve by one in all five cases; front unchanged.

## Fixed face ROI (descriptive)

Oblique fixed x108:168, y12:76; no candidate-derived fitting or new threshold. Source-foreground crop RGB MAE improves in all five cases for both candidates. Baseline MAE old 0.269367, stage1 0.267386, stage2 0.265815. No dedicated eye mask exists. This does not rule out eye/other local occlusion regressions; unchanged non-target source geometry is not evidence that rendered occlusion is unchanged. Exact-black counts include missing source-foreground pixels and must not be read as isolated black-dot counts.

## Admission

Stage 1 snapshot 53760/65536 B, max work 2766785/8000000. Stage 2 snapshot 62104/65536 B, max work 2772420/8000000. All direct/transport scene/ray/node/triangle counters are within unchanged caps. See actual-comparison.json for maxima and per-condition accounting in each actual run.

## Evidence

- old-control-parity.json: fresh all40 buffer and all10 score/domain equality.
- actual-stage1/functional.json and actual-stage2/functional.json: complete order/admission/negative-test audit.
- actual-comparison.json: full per-condition metric values/deltas and actual counter maxima.
- face-comparison.json: fixed face ROI error and RGB565 pixel change counts.
- Each score-stage*/evaluation.json and COMPLETED.json: frozen-v3 score provenance.

All renders in this comparison are quality/admission experiments. Some ran concurrently. Their wall times are not a controlled CPU benchmark. No model/media upload, public push, device render or source/reference modification was performed.

## Same-density face diagnostic

Both candidates completed one baseline oblique 2x-density render using exactly the previous diagnostic camera mapping q=(2*px-155.5,2*py-21.5), cx83.5/cy112.5. Crop (60,2,180,130) is shown nearest-neighbor 3x. This is not a new reference score or full-view comparison.

- Stage 1: snapshot 53760 B, work 5952618/8000000, transport nodes 512675148/800000000, triangles 177652023/300000000.
- Stage 2: snapshot 62104 B, work 5967710/8000000, transport nodes 545215005/800000000, triangles 168333541/300000000.
- `density-stage1/density2-face-nearest3x.png`, `density-stage2/density2-face-nearest3x.png`; full PNG/RGB565/depth, exact camera, input/output hashes and counters in each result.json.

## CPU benchmark preparation (subsequently executed below)

`measure_actual_cost.py --independent-heavy-finished --output FRESH_ABSOLUTE_DIR` is prepared for old/stage1/stage2 × baseline front/oblique × three alternating repeats (18 sequential renders). It verifies identical O2 flags, all output bytes against each functional run, pins before/after, and reports min/median/max evaluation, append and render ns. Owner authorized the subsequent run after independent heavy work finished. Parallel functional-run timings above are not speed comparisons.

## Controlled host timing: cpu-001

Owner confirmed independent heavy work ended at 07:32:02 UTC. This sequential 18-render session ran approximately 07:32:26–07:34:50 UTC, with no other heavy work scheduled by the coordinating agents. Three repeats per arm/view, alternating lead arm, identical O2 flags. All 36 output RGB565/depth files matched their corresponding functional-run bytes exactly; model/code/input pins unchanged.

| Arm/view | Evaluation ms min / median / max | Append ms min / median / max | Raster+lighting s min / median / max |
|---|---:|---:|---:|
| old/front | 7.734271 / 7.937047 / 8.815845 | 2.774243 / 3.788647 / 3.802938 | 8.084388 / 8.098987 / 8.122607 |
| old/oblique | 6.949815 / 7.359284 / 8.096158 | 2.849557 / 3.273518 / 3.351836 | 7.596613 / 8.197390 / 8.356398 |
| stage1/front | 7.097678 / 7.339082 / 7.427407 | 3.043170 / 3.083571 / 3.322583 | 7.749428 / 7.770472 / 7.963739 |
| stage1/oblique | 7.462188 / 7.674430 / 9.739260 | 3.241980 / 3.387100 / 3.870439 | 7.605084 / 7.967217 / 8.090279 |
| stage2/front | 7.939821 / 8.292004 / 11.972306 | 3.340579 / 3.413540 / 4.358318 | 7.889264 / 8.188348 / 8.936899 |
| stage2/oblique | 8.079731 / 8.583244 / 9.023649 | 3.374619 / 3.734635 / 36.941587 | 7.661199 / 7.661577 / 8.221442 |

The median render ratios versus old are:
- stage1/front: 0.959437x (-4.056%).
- stage1/oblique: 0.971921x (-2.808%).
- stage2/front: 1.011034x (+1.103%).
- stage2/oblique: 0.934636x (-6.536%).

These are three-sample single-host monotonic timings, not target-device timings or proof of general speedup. Old oblique raster spans 7.597–8.356 s; stage2 oblique append has a 36.942 ms outlier. Report min/median/max rather than hide this variation. Functional-run concurrent timings were not used. Full records/pins/order: cpu-001/progress.json and cpu-001/COMPLETED.json.
