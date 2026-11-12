# Frozen v3 conditional status audit

This file reads the existing saved statuses and independently checks their existing numeric rule. It introduces no new pass/fail threshold, combination rule, global acceptance definition or exclusion. All original analysis files remain unchanged.

## All10 stable and full-foreground MAE and RMSE

| Condition | Stable MAE legacy → AgX | Stable RMSE legacy → AgX | Full-FG MAE legacy → AgX | Full-FG RMSE legacy → AgX |
|---|---:|---:|---:|---:|
| front-baseline | 0.168215118 → 0.157690451 | 0.213472261 → 0.218409924 | 0.178972672 → 0.176587263 | 0.22255021 → 0.23401706 |
| front-direction | 0.1745526 → 0.166402222 | 0.223671943 → 0.230701731 | 0.183992789 → 0.185577048 | 0.231331602 → 0.245739512 |
| front-intensity | 0.151887128 → 0.15311709 | 0.198520573 → 0.212676471 | 0.161985226 → 0.171610288 | 0.205895556 → 0.225355608 |
| front-ambient | 0.18084777 → 0.162953925 | 0.226621872 → 0.226010102 | 0.190530557 → 0.180932951 | 0.234390858 → 0.240498093 |
| front-albedo | 0.137880527 → 0.146577158 | 0.18150272 → 0.202267201 | 0.144370703 → 0.158474075 | 0.187409641 → 0.211353959 |
| oblique-baseline | 0.176344028 → 0.163472189 | 0.22201182 → 0.223909169 | 0.189296027 → 0.186177186 | 0.233502867 → 0.242959974 |
| oblique-direction | 0.174418789 → 0.166467778 | 0.223429718 → 0.230523089 | 0.183949034 → 0.187634221 | 0.232305732 → 0.247722974 |
| oblique-intensity | 0.155594101 → 0.151214732 | 0.202778655 → 0.210509994 | 0.168399463 → 0.17538728 | 0.214034238 → 0.229607977 |
| oblique-ambient | 0.188831715 → 0.169704458 | 0.234400977 → 0.231839355 | 0.201028838 → 0.191772511 | 0.24471279 → 0.249862679 |
| oblique-albedo | 0.139598603 → 0.142342802 | 0.184390641 → 0.198606873 | 0.14783115 → 0.158750629 | 0.192794257 → 0.21273161 |

Full-foreground values remain descriptive. Stable color RGB agreement carries the frozen conditional status; RMSE has no frozen pass/fail threshold.

## Frozen status counts

| Arm | MEETS_60_ON_DECLARED_SUBSET | BELOW_60_ON_DECLARED_SUBSET | N/A_NOT_PASS | Total |
|---|---:|---:|---:|---:|
| legacy | 35 | 1 | 6 | 42 |
| agx | 36 | 0 | 6 | 42 |

The42 entries are10 stable color RGB-agreement statuses and4 stable response statuses for each of8 contrasts: direction, magnitude, brightening IoU and darkening IoU. MEETS is a conditional-subset pass only. N/A is undefined, never a pass. Baselines have no response contrast.

## Every all8 response conditional status

| Contrast | Direction legacy → AgX | Magnitude legacy → AgX | Bright IoU legacy → AgX | Dark IoU legacy → AgX |
|---|---|---|---|---|
| front-direction | PASS* → PASS* | PASS* → PASS* | PASS* → PASS* | PASS* → PASS* |
| front-intensity | PASS* → PASS* | PASS* → PASS* | undefined → undefined | PASS* → PASS* |
| front-ambient | PASS* → PASS* | PASS* → PASS* | PASS* → PASS* | undefined → undefined |
| front-albedo | PASS* → PASS* | PASS* → PASS* | undefined → undefined | PASS* → PASS* |
| oblique-direction | PASS* → PASS* | PASS* → PASS* | FAIL* → PASS* | PASS* → PASS* |
| oblique-intensity | PASS* → PASS* | PASS* → PASS* | undefined → undefined | PASS* → PASS* |
| oblique-ambient | PASS* → PASS* | PASS* → PASS* | PASS* → PASS* | undefined → undefined |
| oblique-albedo | PASS* → PASS* | PASS* → PASS* | undefined → undefined | PASS* → PASS* |

*PASS/FAIL applies only to the frozen declared stable subset. All10 stable color conditions are conditional PASS in both arms. All10 color and all8 response conditions still have uncertain reference pixels and retain UNRESOLVED_UNCERTAIN_REMAINDER.

Only one status changes: oblique-direction brightening IoU,0.455568054 →0.640223464, BELOW→MEETS. Six undefined response statuses remain: brightening IoU for intensity and albedo in both views, and darkening IoU for ambient in both views.

Stable/unknown/full-foreground/seed metrics and FP/FN regressions still matter. Every defined conditional status meeting60 does not override unknowns, undefined IoUs, RMSE/count regressions, unchanged shape limitations or old budget failures. The frozen scorer emits NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY and NOT_ESTABLISHED globally; this report preserves those conclusions.

Endpoint wording: any-channel zero means at least one quantized color channel is zero, not that all three channels are zero or the whole pixel is black. Quantized max endpoints are also separate from input LUT-domain clipping. No endpoint or clamp flag excludes any scored pixel.
