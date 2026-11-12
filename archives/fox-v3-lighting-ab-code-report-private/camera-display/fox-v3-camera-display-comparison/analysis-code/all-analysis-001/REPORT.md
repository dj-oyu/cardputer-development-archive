# Fixed composed HDR: legacy display versus AgX float65

Both arms use the identical reconstructed v38 camera-floor HDR. All10 legacy RGB565 files must first match the saved v38 scene-composition bytes exactly. The alternate arm applies the previously frozen official-OCIO-derived LUT approximation once after the fixed quarter average, not an exact OCIO processor.

Original character-only depth, original reference images, stable/uncertain/full-foreground masks and formal v3 math are unchanged. There is no exposure, filtering, sample, geometry, light, material, threshold, mask or reference change. Shape is not inferred from composed RGB.

Goal60 and global acceptance remain unestablished. Full-frame/background results, unknowns, full-foreground pooled scores and per-seed results are descriptive; they are never pooled into a formal acceptance score. LUT-domain clipping is retained in all metrics, with no exclusion or normalization.

## All10 color errors

| Condition | Formal stable RGB MAE | Full foreground RGB MAE | Full frame RGB MAE | Background RGB MAE |
|---|---:|---:|---:|---:|
| front-baseline | 0.1682151 → 0.1576905 | 0.1789727 → 0.1765873 | 0.08367782 → 0.03514194 | 0.06501139 → 0.007435514 |
| front-direction | 0.1745526 → 0.1664022 | 0.1839928 → 0.185577 | 0.08407229 → 0.03692114 | 0.06449977 → 0.007802292 |
| front-intensity | 0.1518871 → 0.1531171 | 0.1619852 → 0.1716103 | 0.08090789 → 0.03440359 | 0.06502639 → 0.007527429 |
| front-ambient | 0.1808478 → 0.1629539 | 0.1905306 → 0.180933 | 0.1129884 → 0.03648686 | 0.09779934 → 0.008192637 |
| front-albedo | 0.1378805 → 0.1465772 | 0.1443707 → 0.1584741 | 0.07100791 → 0.0363419 | 0.05663754 → 0.01241855 |
| oblique-baseline | 0.176344 → 0.1634722 | 0.189296 → 0.1861772 | 0.09172275 → 0.03987609 | 0.07014278 → 0.007519133 |
| oblique-direction | 0.1744188 → 0.1664678 | 0.183949 → 0.1876342 | 0.09088744 → 0.04043456 | 0.0703053 → 0.00787887 |
| oblique-intensity | 0.1555941 → 0.1512147 | 0.1683995 → 0.1753873 | 0.08817256 → 0.03786824 | 0.07042903 → 0.007453582 |
| oblique-ambient | 0.1888317 → 0.1697045 | 0.2010288 → 0.1917725 | 0.119618 → 0.04157589 | 0.1016126 → 0.008357366 |
| oblique-albedo | 0.1395986 → 0.1423428 | 0.1478311 → 0.1587506 | 0.07641914 → 0.03845582 | 0.06062517 → 0.01185059 |

All arrows are legacy → AgX; lower MAE is better.

## All8 formal stable response contrasts

| Contrast | Direction % | Magnitude % | Bright IoU | Dark IoU | Δ luma RMSE | Δ RGB RMSE |
|---|---:|---:|---:|---:|---:|---:|
| front-direction | 86.18038 → 88.69926 | 68.80963 → 72.55636 | 0.6752577 → 0.741875 | 0.8358939 → 0.8525105 | 0.08031608 → 0.06590819 | 0.1096218 → 0.1019809 |
| front-intensity | 87.79083 → 88.21101 | 89.54067 → 96.38122 | N/A → N/A | 0.8099516 → 0.8279817 | 0.04188711 → 0.03118955 | 0.06758792 → 0.05781259 |
| front-ambient | 92.78745 → 95.10516 | 73.66893 → 95.4526 | 0.8146164 → 0.8950287 | N/A → N/A | 0.02735721 → 0.01506472 | 0.03452138 → 0.0246735 |
| front-albedo | 99.8869 → 99.86805 | 91.77681 → 84.85178 | N/A → N/A | 0.9881244 → 0.994345 | 0.0565467 → 0.04693653 | 0.08239614 → 0.07525459 |
| oblique-direction | 84.07799 → 87.01114 | 76.59787 → 80.0698 | 0.4555681 → 0.6402235 | 0.8277938 → 0.8409036 | 0.08219442 → 0.06744952 | 0.1169933 → 0.1099056 |
| oblique-intensity | 87.38581 → 88.51378 | 96.12251 → 97.38675 | N/A → N/A | 0.8110787 → 0.8265425 | 0.04332605 → 0.03325128 | 0.07105673 → 0.06180926 |
| oblique-ambient | 92.0429 → 93.50268 | 74.39006 → 95.25337 | 0.8188895 → 0.8875065 | N/A → N/A | 0.02780563 → 0.01589681 | 0.0358028 → 0.02711972 |
| oblique-albedo | 99.98295 → 99.71014 | 83.58939 → 78.54172 | N/A → N/A | 0.9890878 → 0.9904518 | 0.06356964 → 0.05563221 | 0.08945243 → 0.08508143 |

## Full-foreground response counts

| Contrast | Active→inactive | Reversed | Bright FN | Dark FN | Bright FP | Dark FP | Inactive FP | Unknown |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| front-direction | 617 → 420 | 125 → 132 | 363 → 224 | 379 → 328 | 141 → 189 | 91 → 95 | 107 → 152 | 729 → 729 |
| front-intensity | 775 → 681 | 0 → 0 | 0 → 0 | 775 → 681 | 0 → 0 | 50 → 69 | 50 → 69 | 696 → 696 |
| front-ambient | 969 → 546 | 0 → 0 | 969 → 546 | 0 → 0 | 0 → 3 | 0 → 0 | 0 → 3 | 74 → 74 |
| front-albedo | 63 → 30 | 0 → 0 | 0 → 0 | 63 → 30 | 0 → 0 | 0 → 0 | 0 → 0 | 2 → 2 |
| oblique-direction | 823 → 589 | 117 → 121 | 304 → 136 | 636 → 574 | 180 → 186 | 79 → 88 | 142 → 153 | 698 → 698 |
| oblique-intensity | 913 → 826 | 0 → 0 | 0 → 0 | 913 → 826 | 0 → 0 | 59 → 68 | 59 → 68 | 533 → 533 |
| oblique-ambient | 1047 → 645 | 0 → 0 | 1047 → 645 | 0 → 0 | 0 → 6 | 0 → 0 | 0 → 6 | 69 → 69 |
| oblique-albedo | 64 → 56 | 0 → 0 | 0 → 0 | 64 → 56 | 0 → 0 | 0 → 0 | 0 → 0 | 3 → 3 |

## Exhaustive regression audit

SCALAR_AUDIT.json retains every directional regression, improvement, neutral scalar/count change and defined/undefined transition across formal and all fixed descriptive strata, including all eight reference seeds. The detailed arm reports retain every metric and all reference unknown diagnostics. No metric is selected based on output.
- unchanged: 27906
- totalScalarLeaves: 63050
- neutralScalarLeaves: 20478
- improvement: 18098
- directionalScalarLeaves: 42572
- regression: 11747
- neutralChanged: 3571
- bothUndefined: 1721
- undefinedTransition: 7

These are overlapping scalar diagnostic counts, not independent tests or a quality vote. A candidate-only class population, significant-pixel count, unknown-class count or response sum has no assumed monotone quality direction. Such changes remain visible as neutral diagnostics. Unknowns and undefined values are never passes.

## Limits

No renderer execution, new renderer benchmark, background reflection transport, model/source edit, reference edit, product HDR-storage implementation, device result or budget-fit claim is made. Original negative old1M/8M gates are unchanged. Profile payload, HDR/output buffers and host timing are reported separately by the reconstruction/display run. The saved analysis allowlist contains code and aggregate reports only; it excludes source assets, raw HDR, composition/sample events, depth buffers, generated pixels, masks and raw LUT assets.
