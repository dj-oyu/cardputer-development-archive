# Fixed 2×2 current-lid8 display/filter diagnostic

Ten color cases and eight baseline-relative responses per arm. No acceptance, selection, convergence, or product-fit conclusion. Profile is applied after the fixed HDR filter. Point/OFF reproduces actual-lid8-v2 bytes exactly.

| View/case | Point OFF RGB % | Point ON | Filter3 OFF | Filter3 ON | Interaction pp |
|---|---:|---:|---:|---:|---:|
| front/baseline | 72.846992 | 73.228123 | 74.662660 | 74.661916 | -0.381876 |
| front/direction | 71.978221 | 72.046078 | 73.715075 | 73.422208 | -0.360724 |
| front/intensity | 73.868694 | 73.026315 | 75.553400 | 74.302134 | -0.408887 |
| front/ambient | 71.167630 | 71.835838 | 73.100050 | 73.365970 | -0.402287 |
| front/albedo | 76.581547 | 75.224951 | 78.027647 | 76.264248 | -0.406802 |
| oblique/baseline | 71.558712 | 72.031914 | 73.231533 | 73.285158 | -0.419577 |
| oblique/direction | 70.796204 | 70.649286 | 72.561911 | 72.030655 | -0.384338 |
| oblique/intensity | 72.524404 | 72.020427 | 74.164766 | 73.197835 | -0.462954 |
| oblique/ambient | 69.990264 | 70.656152 | 71.714816 | 71.979129 | -0.401574 |
| oblique/albedo | 75.558356 | 74.608566 | 76.896456 | 75.523010 | -0.423656 |

| View / response / arm | Sign % | Luma RMSE | RGB RMSE | Magnitude % | Bright IoU | Dark IoU | Inactive FP |
|---|---:|---:|---:|---:|---:|---:|---:|
| front/direction/point-off | 82.365389 | 0.083530 | 0.112254 | 68.287454 | 0.654050 | 0.814556 | 69.000000 |
| front/direction/point-on | 84.624358 | 0.068733 | 0.104870 | 72.243789 | 0.712897 | 0.829899 | 102.000000 |
| front/direction/filter3-off | 86.174155 | 0.080017 | 0.109297 | 69.020975 | 0.674194 | 0.842435 | 134.000000 |
| front/direction/filter3-on | 88.058320 | 0.065253 | 0.101267 | 72.747616 | 0.738491 | 0.856596 | 137.000000 |
| front/intensity/point-off | 81.422925 | 0.042419 | 0.068054 | 91.871667 | UNKNOWN | 0.763078 | 10.000000 |
| front/intensity/point-on | 82.499418 | 0.032919 | 0.059325 | 97.407434 | UNKNOWN | 0.786130 | 6.000000 |
| front/intensity/filter3-off | 85.562486 | 0.041353 | 0.067213 | 90.267889 | UNKNOWN | 0.800416 | 38.000000 |
| front/intensity/filter3-on | 86.273148 | 0.031256 | 0.057856 | 95.782444 | UNKNOWN | 0.818750 | 29.000000 |
| front/ambient/point-off | 80.141573 | 0.026073 | 0.033996 | 63.835687 | 0.693897 | UNKNOWN | 0.000000 |
| front/ambient/point-on | 81.529637 | 0.024673 | 0.031636 | 66.275973 | 0.753346 | UNKNOWN | 3.000000 |
| front/ambient/filter3-off | 85.823608 | 0.024730 | 0.033269 | 65.211321 | 0.749570 | UNKNOWN | 0.000000 |
| front/ambient/filter3-on | 85.984704 | 0.023463 | 0.030743 | 66.567611 | 0.792352 | UNKNOWN | 3.000000 |
| front/albedo/point-off | 88.049010 | 0.060013 | 0.085224 | 84.858359 | UNKNOWN | 0.870877 | 0.000000 |
| front/albedo/point-on | 87.841659 | 0.053896 | 0.081051 | 81.704423 | UNKNOWN | 0.872385 | 0.000000 |
| front/albedo/filter3-off | 95.570217 | 0.058005 | 0.083512 | 86.882097 | UNKNOWN | 0.929312 | 0.000000 |
| front/albedo/filter3-on | 92.629595 | 0.051471 | 0.078558 | 83.679689 | UNKNOWN | 0.910273 | 0.000000 |
| oblique/direction/point-off | 79.535648 | 0.084611 | 0.118901 | 76.436371 | 0.392374 | 0.806096 | 85.000000 |
| oblique/direction/point-on | 80.905753 | 0.070182 | 0.112222 | 79.902493 | 0.444840 | 0.817877 | 120.000000 |
| oblique/direction/filter3-off | 82.767730 | 0.081829 | 0.116592 | 77.049799 | 0.452920 | 0.820152 | 139.000000 |
| oblique/direction/filter3-on | 83.728470 | 0.067159 | 0.109354 | 80.415500 | 0.492974 | 0.832180 | 153.000000 |
| oblique/intensity/point-off | 82.741017 | 0.043614 | 0.071470 | 98.226260 | UNKNOWN | 0.779501 | 7.000000 |
| oblique/intensity/point-on | 83.644218 | 0.034654 | 0.062818 | 96.819512 | UNKNOWN | 0.795013 | 7.000000 |
| oblique/intensity/filter3-off | 86.117094 | 0.043059 | 0.070881 | 96.802719 | UNKNOWN | 0.806540 | 21.000000 |
| oblique/intensity/filter3-on | 86.763266 | 0.033467 | 0.061653 | 97.854113 | UNKNOWN | 0.819659 | 21.000000 |
| oblique/ambient/point-off | 79.467220 | 0.024116 | 0.033300 | 68.282337 | 0.698322 | UNKNOWN | 0.000000 |
| oblique/ambient/point-on | 79.616514 | 0.022818 | 0.031708 | 70.491106 | 0.740542 | UNKNOWN | 8.000000 |
| oblique/ambient/filter3-off | 84.864210 | 0.022905 | 0.032593 | 68.614409 | 0.747449 | UNKNOWN | 0.000000 |
| oblique/ambient/filter3-on | 83.877657 | 0.021546 | 0.030822 | 70.367094 | 0.777432 | UNKNOWN | 6.000000 |
| oblique/albedo/point-off | 87.621483 | 0.065643 | 0.091264 | 76.408637 | UNKNOWN | 0.868542 | 0.000000 |
| oblique/albedo/point-on | 87.212276 | 0.061011 | 0.089504 | 75.818835 | UNKNOWN | 0.861722 | 0.000000 |
| oblique/albedo/filter3-off | 94.799659 | 0.063983 | 0.089925 | 78.235763 | UNKNOWN | 0.923274 | 0.000000 |
| oblique/albedo/filter3-on | 91.884058 | 0.059184 | 0.087975 | 77.398214 | UNKNOWN | 0.900767 | 0.000000 |

| View / case / arm | Total clamps | Native covered | Native background | Display support | Outside display support |
|---|---:|---:|---:|---:|---:|
| front/baseline/point-off | 0 | 0 | 0 | 0 | 0 |
| front/baseline/point-on | 0 | 0 | 0 | 0 | 0 |
| front/baseline/filter3-off | 0 | 0 | 0 | 0 | 0 |
| front/baseline/filter3-on | 0 | 0 | 0 | 0 | 0 |
| front/direction/point-off | 0 | 0 | 0 | 0 | 0 |
| front/direction/point-on | 0 | 0 | 0 | 0 | 0 |
| front/direction/filter3-off | 0 | 0 | 0 | 0 | 0 |
| front/direction/filter3-on | 0 | 0 | 0 | 0 | 0 |
| front/intensity/point-off | 0 | 0 | 0 | 0 | 0 |
| front/intensity/point-on | 0 | 0 | 0 | 0 | 0 |
| front/intensity/filter3-off | 0 | 0 | 0 | 0 | 0 |
| front/intensity/filter3-on | 0 | 0 | 0 | 0 | 0 |
| front/ambient/point-off | 0 | 0 | 0 | 0 | 0 |
| front/ambient/point-on | 0 | 0 | 0 | 0 | 0 |
| front/ambient/filter3-off | 0 | 0 | 0 | 0 | 0 |
| front/ambient/filter3-on | 0 | 0 | 0 | 0 | 0 |
| front/albedo/point-off | 0 | 0 | 0 | 0 | 0 |
| front/albedo/point-on | 0 | 0 | 0 | 0 | 0 |
| front/albedo/filter3-off | 0 | 0 | 0 | 0 | 0 |
| front/albedo/filter3-on | 0 | 0 | 0 | 0 | 0 |
| oblique/baseline/point-off | 0 | 0 | 0 | 0 | 0 |
| oblique/baseline/point-on | 0 | 0 | 0 | 0 | 0 |
| oblique/baseline/filter3-off | 0 | 0 | 0 | 0 | 0 |
| oblique/baseline/filter3-on | 0 | 0 | 0 | 0 | 0 |
| oblique/direction/point-off | 0 | 0 | 0 | 0 | 0 |
| oblique/direction/point-on | 0 | 0 | 0 | 0 | 0 |
| oblique/direction/filter3-off | 0 | 0 | 0 | 0 | 0 |
| oblique/direction/filter3-on | 0 | 0 | 0 | 0 | 0 |
| oblique/intensity/point-off | 0 | 0 | 0 | 0 | 0 |
| oblique/intensity/point-on | 0 | 0 | 0 | 0 | 0 |
| oblique/intensity/filter3-off | 0 | 0 | 0 | 0 | 0 |
| oblique/intensity/filter3-on | 0 | 0 | 0 | 0 | 0 |
| oblique/ambient/point-off | 0 | 0 | 0 | 0 | 0 |
| oblique/ambient/point-on | 0 | 0 | 0 | 0 | 0 |
| oblique/ambient/filter3-off | 0 | 0 | 0 | 0 | 0 |
| oblique/ambient/filter3-on | 0 | 0 | 0 | 0 | 0 |
| oblique/albedo/point-off | 0 | 0 | 0 | 0 | 0 |
| oblique/albedo/point-on | 0 | 0 | 0 | 0 | 0 |
| oblique/albedo/filter3-off | 0 | 0 | 0 | 0 | 0 |
| oblique/albedo/filter3-on | 0 | 0 | 0 | 0 | 0 |

Official OCIO-derived LUT approximation, not exact equality to the OCIO processor. Clamp totals and native-covered/native-background partitions are shown for every case and arm; auxiliary calls are outside timed measurements. Filter-expanded support can contain signal outside native coverage, so display-support/outside-support partitions are also shown.


All numeric metric contrasts, including signed correlations, uncertain/pooled/per-seed metrics and interaction, are retained in JSON. Reference-only stable masks include inactive pixels; scoring retains full source foreground, including native missing silhouette. No null is treated as zero/pass.

Support expansion is reported separately in support.json. Filter support comes from depth-mask union, not RGB positivity, and is not geometry improvement. Fixed weights retain outside/no-hit black samples with no covered-only renormalization.

Host costs: 3,295,500-byte read-only LUT; each full HDR array 777,600 bytes; RGB565 output 64,800 bytes; native observer HDR allocation separate. Python temporary arrays and library/code overhead are additional, not an established peak-RAM budget. Filter/display timing uses 11 identical-input repetitions, with min/median/max reported as host-only timings, not device benchmarks or a native-render-plus-transform performance estimate. Continuous profile conversion does not implement PNG dither=1.

No LUT regeneration or source-image fit. Local frozen profile manifest, installed 20 dependencies, all raw/reference/foreground/source inputs and fresh library binary are hash-checked. All five conditions are evaluated without selecting a winner or claiming global acceptance. False-positive/false-negative counts for each response domain are derived from the unchanged evaluator intersections and retained separately in responseConfusion.
