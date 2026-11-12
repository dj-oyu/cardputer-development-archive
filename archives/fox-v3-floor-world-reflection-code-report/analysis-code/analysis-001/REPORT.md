# Floor-world OFF versus ON at fixed floor-direct/background/AgX

World OFF independently reproduces all ten completed prior floor-ON HDR, legacy RGB565 and AgX RGB565 buffers and original formal values. Both new arms retain original character-only depth, reference, thresholds and all fixed domains.

This is one fixed contrast, not global acceptance, additivity, source Principled equivalence, device fit or default adoption. Unknown and undefined values are not passes. No domain-clamp or endpoint flags exclude pixels.

## All10 color errors

Cells are world OFF → ON. All errors are normalized RGB pixel×channel means.

| Condition | Stable MAE | Stable RMSE | Uncertain MAE | Uncertain RMSE | FullFG MAE | FullFG RMSE |
|---|---:|---:|---:|---:|---:|---:|
| front-baseline | 0.107554032 → 0.0985060077 | 0.163977757 → 0.155793432 | 0.166239264 → 0.151913819 | 0.205713237 → 0.194685119 | 0.11919819 → 0.109103035 | 0.173061057 → 0.164244206 |
| front-direction | 0.110341461 → 0.10050993 | 0.16791018 → 0.160133859 | 0.153725845 → 0.139728288 | 0.19413463 → 0.185401635 | 0.12065823 → 0.109836022 | 0.174503853 → 0.16649041 |
| front-intensity | 0.112269415 → 0.103110076 | 0.169824583 → 0.162486243 | 0.148416796 → 0.134504204 | 0.185459632 → 0.176839896 | 0.12209807 → 0.111646297 | 0.174214783 → 0.166511596 |
| front-ambient | 0.114589842 → 0.098170096 | 0.172076324 → 0.156396156 | 0.181241299 → 0.153398602 | 0.220540013 → 0.198904097 | 0.126294978 → 0.107869167 | 0.181526416 → 0.164657576 |
| front-albedo | 0.120456236 → 0.115749324 | 0.17509953 → 0.171611032 | 0.14417302 → 0.136288745 | 0.185164838 → 0.179759893 | 0.126194384 → 0.120718726 | 0.1775871 → 0.173617683 |
| oblique-baseline | 0.103698255 → 0.0934697216 | 0.15455441 → 0.145054341 | 0.166781256 → 0.15207507 | 0.203230565 → 0.192620627 | 0.118501475 → 0.107222204 | 0.167253863 → 0.157511584 |
| oblique-direction | 0.104433535 → 0.0935176862 | 0.158737051 → 0.150111742 | 0.135912851 → 0.120178377 | 0.174317843 → 0.163735566 | 0.11378935 → 0.101441382 | 0.163522861 → 0.154286503 |
| oblique-intensity | 0.104580909 → 0.0948232432 | 0.157180389 → 0.149497877 | 0.142782293 → 0.127533504 | 0.177625481 → 0.167556057 | 0.116891546 → 0.105364331 | 0.164047442 → 0.15554635 |
| oblique-ambient | 0.112573456 → 0.0937401165 | 0.165133931 → 0.146864083 | 0.182613138 → 0.15434433 | 0.217816687 → 0.196142808 | 0.127576844 → 0.106722307 | 0.177738384 → 0.158713211 |
| oblique-albedo | 0.114276625 → 0.109416736 | 0.167112741 → 0.163485429 | 0.137124379 → 0.12814589 | 0.175911151 → 0.168950895 | 0.121051522 → 0.11497037 | 0.169769242 → 0.165124937 |

## All8 formal stable response

| Contrast | Direction % | Magnitude % | Bright IoU | Dark IoU | Δ RGB RMSE | Δ Luma RMSE |
|---|---:|---:|---:|---:|---:|---:|
| front-direction | 91.103941 → 90.921659 | 88.2626744 → 93.9817908 | 0.779650437 → 0.78097622 | 0.880181122 → 0.875304772 | 0.0675640258 → 0.0607277197 | 0.0484529955 → 0.045806062 |
| front-intensity | 97.1670094 → 97.3479652 | 93.441236 → 97.4906213 | N/A → N/A | 0.929403701 → 0.929583905 | 0.0447050207 → 0.041907261 | 0.0251423674 → 0.0247008045 |
| front-ambient | 90.1529637 → 98.0879541 | 86.3186427 → 96.4851277 | 0.829254302 → 0.945889101 | N/A → N/A | 0.0217498937 → 0.0200671979 | 0.0168114217 → 0.0125162892 |
| front-albedo | 100 → 100 | 92.4800503 → 89.1467125 | N/A → N/A | 1 → 1 | 0.0646402805 → 0.0618839209 | 0.0306264343 → 0.0318776901 |
| oblique-direction | 92.0267803 → 92.0470684 | 96.7801084 → 96.9907002 | 0.655328798 → 0.662844037 | 0.909657321 → 0.908829175 | 0.0737701504 → 0.0662663095 | 0.0492713432 → 0.0475226297 |
| oblique-intensity | 97.7713178 → 97.6735169 | 98.6691952 → 97.2201571 | N/A → N/A | 0.947868217 → 0.947072509 | 0.0473967134 → 0.043722061 | 0.0256133673 → 0.0254266564 |
| oblique-ambient | 88.6988077 → 97.1492744 | 83.7607605 → 94.8538245 | 0.826853292 → 0.945577056 | N/A → N/A | 0.0234752093 → 0.0209264745 | 0.0182800724 → 0.013076984 |
| oblique-albedo | 99.9658994 → 99.9829497 | 94.2731323 → 90.5088587 | N/A → N/A | 0.999147485 → 0.999317988 | 0.0717931005 → 0.0677588963 | 0.0317858377 → 0.0325439127 |

## All8 full-foreground confusion

These counts retain stable reference classes and report reference-uncertain pixels separately.

| Contrast | Bright FP | Bright FN | Dark FP | Dark FN | Reverse | Active→inactive | Inactive FP | Unknown |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| front-direction | 191 → 187 | 162 → 163 | 98 → 98 | 246 → 260 | 134 → 129 | 274 → 294 | 155 → 156 | 729 → 729 |
| front-intensity | 0 → 0 | 0 → 0 | 86 → 83 | 223 → 225 | 0 → 0 | 223 → 225 | 86 → 83 | 696 → 696 |
| front-ambient | 3 → 3 | 890 → 280 | 0 → 0 | 0 → 0 | 0 → 0 | 890 → 280 | 3 → 3 | 74 → 74 |
| front-albedo | 0 → 0 | 0 → 0 | 0 → 0 | 0 → 0 | 0 → 0 | 0 → 0 | 0 → 0 | 2 → 2 |
| oblique-direction | 173 → 163 | 131 → 131 | 100 → 95 | 277 → 285 | 126 → 111 | 282 → 305 | 147 → 147 | 698 → 698 |
| oblique-intensity | 0 → 0 | 0 → 0 | 74 → 72 | 195 → 201 | 0 → 0 | 195 → 201 | 74 → 72 | 533 → 533 |
| oblique-ambient | 6 → 7 | 996 → 308 | 0 → 0 | 0 → 0 | 0 → 0 | 996 → 308 | 6 → 7 | 69 → 69 |
| oblique-albedo | 0 → 0 | 0 → 0 | 0 → 0 | 5 → 4 | 0 → 0 | 5 → 4 | 0 → 0 | 3 → 3 |

## Ambient/color tradeoff

- front ambientDirectionAgreementPercent: 90.1529637 → 98.0879541.
- front ambientMagnitudeAgreementPercent: 86.3186427 → 96.4851277.
- front ambientBrightIoU: 0.829254302 → 0.945889101.
- front ambientDeltaRGBRMSE: 0.0217498937 → 0.0200671979.
- front ambientDeltaLumaRMSE: 0.0168114217 → 0.0125162892.
- front baselineSignedLumaError: -0.0939764515 → -0.083532459.
- oblique ambientDirectionAgreementPercent: 88.6988077 → 97.1492744.
- oblique ambientMagnitudeAgreementPercent: 83.7607605 → 94.8538245.
- oblique ambientBrightIoU: 0.826853292 → 0.945577056.
- oblique ambientDeltaRGBRMSE: 0.0234752093 → 0.0209264745.
- oblique ambientDeltaLumaRMSE: 0.0182800724 → 0.013076984.
- oblique baselineSignedLumaError: -0.0914797981 → -0.0799482568.

## Completeness and limits

- Conditional status counts: {"off": {"MEETS_60_ON_DECLARED_SUBSET": 36, "N/A_NOT_PASS": 6}, "on": {"MEETS_60_ON_DECLARED_SUBSET": 36, "N/A_NOT_PASS": 6}}.
- Scalar regressions: 7864. They are overlapping diagnostic scalars, not independent tests or votes.
- Complete saved aggregates retain all 13 domains, stable/uncertain/full-foreground values, eight reference seeds, every confusion class and every scalar regression. Formal per-pixel uncertainty locations are stored only as counts and hashes.
- Character shape is unchanged; reflected lighting does not restore missing geometry. Original resource-budget failures are not reclassified. Reverse render controls are historical unless independently reported elsewhere.
- Profile-domain clamp is separate from quantized channel endpoints; endpoint flags do not exclude pixels.

## Separate raw-component checks

Ambient is bit-exact 2× baseline in both views before display. Direction and intensity world components are bit-exact baseline. Albedo is source-derived for both receiver and floor, not assumed to be a blanket 0.6 multiplier. Per-channel source floor reflectances and observed component ratios are retained in RAW_COMPONENT_INVARIANTS.json.gz. These raw invariants do not imply equal nonlinear display responses.
