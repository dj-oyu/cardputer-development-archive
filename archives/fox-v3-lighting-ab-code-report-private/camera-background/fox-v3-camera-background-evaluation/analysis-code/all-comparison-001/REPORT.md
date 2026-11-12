# Fixed camera-background scene comparison

OFF and ON retain identical original character geometry. Scene color filling a center-missing pixel does not repair shape.
Formal scores use unchanged v3 mathematics and original foreground. Global acceptance and goal60 remain unestablished. Full-frame, background and control results are descriptive and never pooled into formal quality.

## All10 stable-foreground color and fixed full-frame errors

| Case | Formal stable RGB MAE OFF | ON | Δ ON−OFF | Full-frame MAE OFF | ON | Background MAE ON |
|---|---:|---:|---:|---:|---:|---:|
| front-baseline | 0.254023 | 0.168215 | -0.0858076 | 0.663352 | 0.0836778 | 0.0650114 |
| front-direction | 0.263564 | 0.174553 | -0.0890111 | 0.663987 | 0.0840723 | 0.0644998 |
| front-intensity | 0.244714 | 0.151887 | -0.0928271 | 0.653674 | 0.0809079 | 0.0650264 |
| front-ambient | 0.269886 | 0.180848 | -0.0890381 | 0.711559 | 0.112988 | 0.0977993 |
| front-albedo | 0.219622 | 0.137881 | -0.0817417 | 0.615428 | 0.0710079 | 0.0566375 |
| oblique-baseline | 0.269926 | 0.176344 | -0.0935823 | 0.66278 | 0.0917228 | 0.0701428 |
| oblique-direction | 0.277164 | 0.174419 | -0.102745 | 0.66273 | 0.0908874 | 0.0703053 |
| oblique-intensity | 0.260043 | 0.155594 | -0.104449 | 0.651809 | 0.0881726 | 0.070429 |
| oblique-ambient | 0.285182 | 0.188832 | -0.0963501 | 0.708141 | 0.119618 | 0.101613 |
| oblique-albedo | 0.232414 | 0.139599 | -0.0928155 | 0.612978 | 0.0764191 | 0.0606252 |

Negative MAE deltas are lower error. These values are not a new acceptance score.

## All8 formal stable response contrasts

| Contrast | Direction % OFF→ON | Magnitude % OFF→ON | Bright IoU OFF→ON | Dark IoU OFF→ON |
|---|---:|---:|---:|---:|
| front-direction | 85.2095 → 86.1804 | 68.8388 → 68.8096 | 0.687789 → 0.675258 | 0.836471 → 0.835894 |
| front-intensity | 84.1421 → 87.7908 | 89.66 → 89.5407 | N/A → N/A | 0.786162 → 0.809952 |
| front-ambient | 83.6426 → 92.7874 | 65.3657 → 73.6689 | 0.731777 → 0.814616 | N/A → N/A |
| front-albedo | 91.2347 → 99.8869 | 87.3631 → 91.7768 | N/A → N/A | 0.902733 → 0.988124 |
| oblique-direction | 81.7623 → 84.078 | 76.6396 → 76.5979 | 0.444444 → 0.455568 | 0.820709 → 0.827794 |
| oblique-intensity | 84.8057 → 87.3858 | 96.2219 → 96.1225 | N/A → N/A | 0.799372 → 0.811079 |
| oblique-ambient | 83.0998 → 92.0429 | 69.4403 → 74.3901 | 0.737416 → 0.818889 | N/A → N/A |
| oblique-albedo | 90.7758 → 99.9829 | 78.6652 → 83.5894 | N/A → N/A | 0.899915 → 0.989088 |

## All8 full-foreground confusion counts

| Contrast | Active→inactive OFF→ON | Reverse OFF→ON | Inactive FP OFF→ON | Unknown OFF→ON |
|---|---:|---:|---:|---:|
| front-direction | 633 → 617 | 110 → 125 | 89 → 107 | 729 → 729 |
| front-intensity | 905 → 775 | 0 → 0 | 16 → 50 | 696 → 696 |
| front-ambient | 1402 → 969 | 0 → 0 | 0 → 0 | 74 → 74 |
| front-albedo | 516 → 63 | 0 → 0 | 0 → 0 | 2 → 2 |
| oblique-direction | 883 → 823 | 111 → 117 | 98 → 142 | 698 → 698 |
| oblique-intensity | 1014 → 913 | 0 → 0 | 8 → 59 | 533 → 533 |
| oblique-ambient | 1518 → 1047 | 0 → 0 | 0 → 0 | 69 → 69 |
| oblique-albedo | 587 → 64 | 0 → 0 | 0 → 0 | 3 → 3 |

## Preserved regressions

10 worsening formal metrics and 11 worsening full-foreground confusion counts. Every worsening fixed-domain color subset is retained in COMPARISON.json (4 overlapping descriptive entries).
- front-direction responseMagnitudeAgreementPercent: 68.8388 → 68.8096
- front-direction brighteningIoU: 0.687789 → 0.675258
- front-direction darkeningIoU: 0.836471 → 0.835894
- front-intensity responseMagnitudeAgreementPercent: 89.66 → 89.5407
- front-ambient deltaLumaRMSE: 0.0253368 → 0.0273572
- front-ambient deltaRGBRMSE: 0.0334918 → 0.0345214
- oblique-direction responseMagnitudeAgreementPercent: 76.6396 → 76.5979
- oblique-intensity responseMagnitudeAgreementPercent: 96.2219 → 96.1225
- oblique-ambient deltaLumaRMSE: 0.0233974 → 0.0278056
- oblique-ambient deltaRGBRMSE: 0.0328731 → 0.0358028
- front-direction reverse: 110 → 125
- front-direction darkFN: 374 → 379
- front-direction brightFP: 104 → 141
- front-direction inactiveFP: 89 → 107
- front-intensity darkFP: 16 → 50
- front-intensity inactiveFP: 16 → 50
- oblique-direction reverse: 111 → 117
- oblique-direction brightFP: 110 → 180
- oblique-direction inactiveFP: 98 → 142
- oblique-intensity darkFP: 8 → 59
- oblique-intensity inactiveFP: 8 → 59

The JSON companion includes every fixed stratum for all10 cases, all FP/FN and unknown counts, and background-control errors. Full detailed reports retain per-seed and uncertain metrics. Unknowns are never counted as passes. Baseline has no response contrast.

Full-frame/background gains do not imply foreground response gains, character lighting improvements, repaired geometry, old-budget compliance, device fit or global acceptance. Original old1M/8M negative composition gates remain negative; added host-budget accounting is reported separately.
