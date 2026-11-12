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
