# Eye A/B actual-C evaluation

Baseline is the frozen stage2 muzzle candidate, not the original low-resolution model. Renderer, lighting, material mapping, compiler, host adapter/run and formal scorer remain byte-identical to v23. Reference, masks, thresholds and camera settings remain unchanged. No new admission-only branch is used.

Both eye candidates completed all ten cases with forward/reverse RGB565 and depth exactly equal, and all fixed admission/direct/transport caps satisfied. Their independent eye-geometry diagnosis is separate; inherited muzzle complete-occlusion-preservation FAIL remains. Neither is formally adopted here. Global 60% reproduction remains NOT_ESTABLISHED.

## Capacity

| Candidate | Compiled V / T | Parts | Cold B | Arena B | Actual snapshot B | Spare B |
|---|---:|---:|---:|---:|---:|---:|
| Stage2 baseline | 1016 / 1314 | 51 | 41788 | 75524 | 62104 | 3432 |
| Eye A | 1034 / 1350 | 51 | 42508 | 75812 | 63232 | 2304 |
| Eye B | 1066 / 1414 | 51 | 43788 | 76324 | 65216 | 320 |

## Stable-subset RGB agreement (%)

| Condition | Stage2 | Eye A | Eye B | A delta pp | B delta pp |
|---|---:|---:|---:|---:|---:|
| front-baseline | 72.748959 | 72.696143 | 72.817272 | -0.052816 | +0.068313 |
| front-direction | 71.822759 | 71.765325 | 71.929406 | -0.057434 | +0.106647 |
| front-intensity | 73.730384 | 73.694834 | 73.817145 | -0.035550 | +0.086761 |
| front-ambient | 71.084588 | 71.031061 | 71.141769 | -0.053527 | +0.057181 |
| front-albedo | 76.438433 | 76.422382 | 76.534502 | -0.016051 | +0.096069 |
| oblique-baseline | 71.443736 | 71.384758 | 71.456166 | -0.058978 | +0.012430 |
| oblique-direction | 70.654883 | 70.602709 | 70.722049 | -0.052174 | +0.067166 |
| oblique-intensity | 72.422050 | 72.360532 | 72.446899 | -0.061518 | +0.024849 |
| oblique-ambient | 69.866525 | 69.817291 | 69.888696 | -0.049233 | +0.022171 |
| oblique-albedo | 75.394257 | 75.373260 | 75.445684 | -0.020997 | +0.051427 |

A worsens stable RGB agreement in all ten cases (−0.016051 to −0.061518 pp). B improves all ten (+0.012430 to +0.106647 pp).

## Regressions and limits retained

- A: response magnitude declines in 6/8, direction agreement in 1/8, signed correlation in 3/8. Luma/RGB response RMSE worsen in 4/8 each.
- B: response magnitude declines in 4/8 (worst −0.318141 pp), direction agreement in 3/8 (worst −0.138384 pp). Signed correlation improves in all eight; luma/RGB response RMSE improve in seven, worsen in one.
- Both: oblique missing source pixels increase by one in all five scenarios, front shape unchanged, extra pixels unchanged.
- B leaves only 320 B snapshot headroom. This does not permit raising any cap or imply future edits will fit.

## Fixed oblique face ROI (descriptive, no new threshold)

Crop x108:168, y12:76 is inherited from prior previews. Metrics below use source foreground within that crop. This is not an eye-only mask and cannot rule out regressions in individual glints/pupils/eyelids.

| Case | Stage2 MAE | Eye A MAE | Eye B MAE |
|---|---:|---:|---:|
| baseline | 0.265814895 | 0.266301603 | 0.264863153 |
| direction | 0.268856214 | 0.269738826 | 0.267429101 |
| intensity | 0.247597468 | 0.247952016 | 0.246599932 |
| ambient | 0.279289156 | 0.279959352 | 0.278382087 |
| albedo | 0.240840887 | 0.241077482 | 0.239871826 |

A worsens face-source-foreground MAE in all five; B improves all five. Exact-black crop counts in the JSON include missing source pixels and should not be interpreted as isolated eye defects.

## Evidence and scope

- actual-eyeA/functional.json and actual-eyeB/functional.json: all10 forward/reverse and functional audit.
- score-eyeA/evaluation.json and score-eyeB/evaluation.json: unchanged formal-v3 score with source/mask provenance.
- actual-comparison.json and face-comparison.json: per-condition values, deltas, maximum actual counters.
- Input GLB SHA A: 214a3044c4ca75ea3b512a2c5ac86f1972e6f239b79f3fde9f05c50a306c1f1f
- Input GLB SHA B: a0ba7e5b536aa292437e589ee44362d686c02ed2769aacb284d5e580cfdcab2b
- External compile certificate A: 2492c3ccef7916a72a151c07d220d37c2bc76f9a58c30751d6668dda9315c1ce
- External compile certificate B: a8b9778f4915b6bab4a9c2312397f361280c4ef787353a466082fe87e803b116

Timing in these functional runs is not a controlled CPU benchmark. No performance comparison, source/reference editing, device run, model/media upload or publication was performed.

## Same-density baseline face diagnostic

Both candidates completed the prior 2x-density oblique camera with the same crop (60,2,180,130), nearest3x display, binary, ground/light settings and caps. No new reference score. Images: density-eyeA/density2-face-nearest3x.png and density-eyeB/density2-face-nearest3x.png.

- eyeA: COMPLETE_DIAGNOSTIC_ONLY; snapshot 63232 B, work 5919984/8000000, transport node visits 522587450/800000000, triangle tests 166048115/300000000.
- eyeB: COMPLETE_DIAGNOSTIC_ONLY; snapshot 65216 B, work 5953451/8000000, transport node visits 533726374/800000000, triangle tests 183559083/300000000.

## Prospective native holdout views

Completed four functional frames (stage2 and eyeB at each of two prospectively specified cameras): source azimuth/elevation (247.5°,12.5°) and (292.5°,27.5°), fixed target [-0.28,0.25,1.8], distance8, verticalOrtho4.8, center119.5/67, mapping [38x,-38z,-38y]. All baseline light/pose/material/transport settings unchanged. Not reference-scored, not a replacement for all10, and separate from geometry audit.

Outputs and camera/input hashes: holdout-002/result.json; fixed plan: holdout-002/camera-plan.json. Full images and nearest3x images are named by azimuth/elevation and arm. All four render/cap/camera checks passed.

holdout-001 is an incomplete wrapper-verification attempt: its first native render succeeded, but an unrounded-double camera echo comparison rejected normal strtof float32 rounding. The corrected verifier checks echo against the planned float32 camera. Camera-plan bytes are identical between attempts; no camera fitting or native changes. The four-frame fresh holdout-002 is authoritative.

## CPU preparation (subsequently completed below)

measure_actual_cost.py is prepared for stage2/eyeA/eyeB × baseline front/oblique × three alternating repeats (18 sequential renders), same O2 flags, all output byte parity and pre/post pins. Owner subsequently confirmed independent heavy work ended and authorized the controlled run recorded below.

## Controlled host CPU cost

Owner confirmed no independent heavy process at 07:59:46 UTC. This sequential 18-render measurement ran approximately 08:00:00–08:02:31 UTC. Three repeats per arm/view, alternating lead arm, identical O2 flags; all 36 RGB565/depth outputs matched the corresponding functional runs exactly and all input/code pins were unchanged. Baseline is stage2, not old v16.

| Arm/view | Evaluation ms min / median / max | Append ms min / median / max | Raster+lighting s min / median / max |
|---|---:|---:|---:|
| stage2/front | 8.386316 / 8.878746 / 9.364939 | 3.587365 / 4.090475 / 4.331299 | 8.269942 / 8.539397 / 9.120240 |
| stage2/oblique | 8.947836 / 9.712736 / 9.746882 | 3.936451 / 4.081791 / 5.033310 | 8.141551 / 8.155069 / 8.403942 |
| eyeA/front | 8.700614 / 10.420286 / 10.467758 | 3.896691 / 4.074030 / 4.206730 | 7.430109 / 8.262736 / 8.800840 |
| eyeA/oblique | 8.728980 / 8.991233 / 10.037126 | 4.548267 / 4.649776 / 5.273933 | 8.002845 / 8.096696 / 8.117011 |
| eyeB/front | 8.368440 / 8.922321 / 10.560579 | 4.197536 / 4.448506 / 4.875352 | 8.437878 / 8.748128 / 8.815745 |
| eyeB/oblique | 8.249523 / 8.592831 / 8.665040 | 3.857141 / 4.596399 / 6.988967 | 8.225665 / 8.481683 / 8.556474 |

Render median ratios versus stage2:
- eyeA/front: 0.967602x (-3.240%).
- eyeA/oblique: 0.992842x (-0.716%).
- eyeB/front: 1.024443x (+2.444%).
- eyeB/oblique: 1.040050x (+4.005%).

These are three-repeat single-host monotonic timings, not target-device timings. Variation is material (for example A/front spans 7.430–8.801 s), so do not infer general speedups from this sample. Functional/density/holdout run times were not used for performance comparison. Full per-run metadata, pins and order are retained in cpu-001/progress.json and cpu-001/COMPLETED.json.
