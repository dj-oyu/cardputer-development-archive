# Display-only metric findings

All10 legacy reconstructed RGB565 controls, legacy-v38 formal/descriptive numerical parity, fixed-domain hashes and character-only shape metrics passed. This admits the comparison, not its quality as a global pass.

## Mixed result

- Background and full-frame MAE improve in all10 conditions. Those domains remain descriptive and never contribute to goal60.
- Formal stable-foreground color MAE improves in7/10 and worsens in front-intensity, front-albedo and oblique-albedo. Stable-foreground RGB RMSE worsens in8/10; only the two ambient conditions improve.
- Full-foreground color MAE worsens in 6/10: direction, intensity and albedo in both views. Baseline and ambient improve in both views. Full-foreground RGB RMSE worsens in all 10 conditions.
- All8 formal stable response delta-luma and delta-RGB RMSE values improve. Direction and magnitude agreement improve for direction/intensity/ambient in both views, but both agreement metrics worsen for albedo in both views.
- Active-to-inactive counts fall in all8 contrasts, but direction reversals increase125→132(front) and117→121(oblique), and multiple false-positive counts worsen.
- No LUT-domain-clipped pixel occurs in any frame or stratum, and no pixel is excluded. AgX quantized zero endpoints increase substantially; these are distinct from domain clipping or proof of lost total intensity.
- Shape is unchanged. Filled scene RGB is not geometry repair. Old1M/8M failure gates, no product-fit/device claim and no global acceptance remain unchanged.

## All10 formal stable color, including RMSE

| Condition | RGB MAE legacy → AgX | RGB RMSE legacy → AgX |
|---|---:|---:|
| front-baseline | 0.168215118 → 0.157690451 | 0.213472261 → 0.218409924 |
| front-direction | 0.174552600 → 0.166402222 | 0.223671943 → 0.230701731 |
| front-intensity | 0.151887128 → 0.153117090 | 0.198520573 → 0.212676471 |
| front-ambient | 0.180847770 → 0.162953925 | 0.226621872 → 0.226010102 |
| front-albedo | 0.137880527 → 0.146577158 | 0.181502720 → 0.202267201 |
| oblique-baseline | 0.176344028 → 0.163472189 | 0.222011820 → 0.223909169 |
| oblique-direction | 0.174418789 → 0.166467778 | 0.223429718 → 0.230523089 |
| oblique-intensity | 0.155594101 → 0.151214732 | 0.202778655 → 0.210509994 |
| oblique-ambient | 0.188831715 → 0.169704458 | 0.234400977 → 0.231839355 |
| oblique-albedo | 0.139598603 → 0.142342802 | 0.184390641 → 0.198606873 |

## Exhaustive scalar counts

- unchanged: 27906
- totalScalarLeaves: 63050
- neutralScalarLeaves: 20478
- improvement: 18098
- directionalScalarLeaves: 42572
- regression: 11747
- neutralChanged: 3571
- bothUndefined: 1721
- undefinedTransition: 7

There are481 formal regressions across stable/unknown/full-foreground/per-seed scalar branches, including37 stable-subset metric/count regressions. There are11,266 descriptive regressions across overlapping fixed domains and seed branches. Sixteen named full-foreground confusion counts worsen. These overlapping counts are not independent tests, a vote, or an aggregate quality score. Seven undefined→defined changes remain separately classified, never passes.

## Every formal stable metric/count regression

- formal/front-baseline/colorMeanPrecision/candidateScores/stableSubset/rgbRMSE: 0.213472261 → 0.218409924
- formal/front-direction/colorMeanPrecision/candidateScores/stableSubset/rgbRMSE: 0.223671943 → 0.230701731
- formal/front-direction/response/candidateScores/stableSubset/brightening/union: 1552 → 1600
- formal/front-direction/response/candidateScores/stableSubset/brightening/centroidDistanceDiagonal: 0.0055505375 → 0.0100495477
- formal/front-direction/response/candidateScores/stableSubset/darkening/union: 2864 → 2868
- formal/front-direction/response/candidateScores/stableSubset/darkening/centroidDistanceDiagonal: 0.00486220397 → 0.00655866795
- formal/front-intensity/colorMeanPrecision/candidateScores/stableSubset/rgbMAE: 0.151887128 → 0.15311709
- formal/front-intensity/colorMeanPrecision/candidateScores/stableSubset/rgbRMSE: 0.198520573 → 0.212676471
- formal/front-intensity/colorMeanPrecision/candidateScores/stableSubset/rgbAgreementPercent: 84.8112872 → 84.688291
- formal/front-intensity/response/candidateScores/stableSubset/darkening/union: 4341 → 4360
- formal/front-intensity/response/candidateScores/stableSubset/darkening/centroidDistanceDiagonal: 0.0132458818 → 0.0147470604
- formal/front-ambient/response/candidateScores/stableSubset/signedCorrelation: 0.68425971 → 0.669176562
- formal/front-ambient/response/candidateScores/stableSubset/brightening/union: 5227 → 5230
- formal/front-ambient/response/candidateScores/stableSubset/brightening/centroidDistanceDiagonal: 0.00701000836 → 0.00711474078
- formal/front-albedo/colorMeanPrecision/candidateScores/stableSubset/rgbMAE: 0.137880527 → 0.146577158
- formal/front-albedo/colorMeanPrecision/candidateScores/stableSubset/rgbRMSE: 0.18150272 → 0.202267201
- formal/front-albedo/colorMeanPrecision/candidateScores/stableSubset/rgbAgreementPercent: 86.2119473 → 85.3422842
- formal/front-albedo/response/candidateScores/stableSubset/responseMagnitudeAgreementPercent: 91.7768053 → 84.8517756
- formal/front-albedo/response/candidateScores/stableSubset/directionAgreementPercent: 99.8868992 → 99.868049
- formal/front-albedo/response/candidateScores/stableSubset/darkening/centroidDistanceDiagonal: 0.000750562038 → 0.000973533549
- formal/oblique-baseline/colorMeanPrecision/candidateScores/stableSubset/rgbRMSE: 0.22201182 → 0.223909169
- formal/oblique-direction/colorMeanPrecision/candidateScores/stableSubset/rgbRMSE: 0.223429718 → 0.230523089
- formal/oblique-direction/response/candidateScores/stableSubset/brightening/union: 889 → 895
- formal/oblique-direction/response/candidateScores/stableSubset/darkening/union: 4152 → 4161
- formal/oblique-direction/response/candidateScores/stableSubset/darkening/centroidDistanceDiagonal: 0.00742572059 → 0.00945660058
- formal/oblique-intensity/colorMeanPrecision/candidateScores/stableSubset/rgbRMSE: 0.202778655 → 0.210509994
- formal/oblique-intensity/response/candidateScores/stableSubset/darkening/union: 5145 → 5154
- formal/oblique-intensity/response/candidateScores/stableSubset/darkening/centroidDistanceDiagonal: 0.00990838098 → 0.0128914253
- formal/oblique-ambient/response/candidateScores/stableSubset/signedCorrelation: 0.594797755 → 0.576895562
- formal/oblique-ambient/response/candidateScores/stableSubset/brightening/union: 5781 → 5787
- formal/oblique-ambient/response/candidateScores/stableSubset/brightening/centroidDistanceDiagonal: 0.0071187294 → 0.00780130771
- formal/oblique-albedo/colorMeanPrecision/candidateScores/stableSubset/rgbMAE: 0.139598603 → 0.142342802
- formal/oblique-albedo/colorMeanPrecision/candidateScores/stableSubset/rgbRMSE: 0.184390641 → 0.198606873
- formal/oblique-albedo/colorMeanPrecision/candidateScores/stableSubset/rgbAgreementPercent: 86.0401397 → 85.7657198
- formal/oblique-albedo/response/candidateScores/stableSubset/responseMagnitudeAgreementPercent: 83.5893886 → 78.5417181
- formal/oblique-albedo/response/candidateScores/stableSubset/directionAgreementPercent: 99.9829497 → 99.7101449
- formal/oblique-albedo/response/candidateScores/stableSubset/darkening/centroidDistanceDiagonal: 0.000884228649 → 0.00127524139

## Full-foreground endpoint diagnostics

Any-channel zero means at least one quantized R/G/B code is zero; it does not mean the whole RGB pixel is black. Any-channel max similarly means a channel endpoint, not necessarily a white pixel. Legacy saturation counts raw averaged HDR with any channel >1. All rows retain every foreground pixel.

| Condition | Legacy input saturation | LUT-domain clamp | Zero-channel pixels legacy → AgX | Max-channel pixels legacy → AgX |
|---|---:|---:|---:|---:|
| front-baseline | 1662 | 0 | 170 → 1938 | 1793 → 3 |
| front-direction | 1335 | 0 | 339 → 2327 | 1392 → 4 |
| front-intensity | 815 | 0 | 265 → 2569 | 887 → 1 |
| front-ambient | 2060 | 0 | 111 → 1770 | 2160 → 5 |
| front-albedo | 416 | 0 | 387 → 2946 | 456 → 0 |
| oblique-baseline | 1783 | 0 | 349 → 2550 | 1900 → 27 |
| oblique-direction | 1195 | 0 | 742 → 3109 | 1238 → 6 |
| oblique-intensity | 925 | 0 | 539 → 3215 | 989 → 7 |
| oblique-ambient | 2146 | 0 | 244 → 2376 | 2258 → 45 |
| oblique-albedo | 549 | 0 | 804 → 3444 | 617 → 0 |

The source report contains all10/all8 values; SCALAR_AUDIT.json retains every regression and transition; CLAMP_STRATA.json retains all13 original domains and their color/response stable/unknown subsets. Formal and descriptive arm reports retain all eight seeds and all FP/FN/unknown diagnostics.

Host profile timing was measured while another modeling agent was active. Treat the parent COST.json eleven repetitions as concurrent-host reference measurements, not uncontended timings, device speed or renderer benchmarks.
