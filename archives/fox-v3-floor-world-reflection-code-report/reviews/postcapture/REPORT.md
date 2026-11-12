# Independent retained-output verification

PASS. No rerender or frozen input/code edit.

## Capture and composition

All 20 captures and all 20 compositions have valid completed-manifest links, file hashes and input pins. All ten world-OFF frames reproduce completed old-floor-ON raw numerical buffers and composed HDR/legacy RGB565/AgX RGB565 exactly. Original counter/component semantics match. New transport deltas equal separately reported world visibility work.

Checks include 191,040 quarter-sample rows across both arms and independent reconstruction of the world component from retained background keep events. Raw center and quarter radiance equal old radiance plus the new component exactly. The maximum composed addition residual is 8.881784197001252e-16 from averaging order.

Observed maxima: 9,014,748 transport rays, 446,208,267 nodes, 138,511,056 triangle tests. New component maxima: 1,146,672 rays, 35,212,432 nodes, 7,001,836 triangle tests. All are within unchanged transport caps. Maximum new semantic work is 450,583,488, below the 450,598,848 cap.

Ambient world input is exactly 2× baseline. Its new component is exactly 2× in both views, for all centers, all quarter samples and composed component arrays. Direction/intensity world components equal baseline exactly.

## Independent limited metrics

The formal scorer was not executed. All ten full-reference-foreground color MAE/RMSE pairs were independently recomputed from source PNG8 integer sums and scalar math.fsum reductions. Maximum difference from saved formal results is 2.7755575615628914e-17. Both MAE and RMSE improve in all ten cases.

Ambient response was independently classified with integer PNG luma numerators, an algebraic second-moment Student-t interval, and exact rational RGB565 candidate thresholds. Reconstructed reference masks equal frozen masks.

- Front: bright IoU 0.8292543021032505→0.9458891013384321; FN 890→280; FP 3→3.
- Oblique: bright IoU 0.8268532918610679→0.9455770559778853; FN 996→308; FP 6→7.

The oblique FP increase must remain visible. All ten color improvement is not universal response-metric improvement.

## Scope limits

Forward-only two-view/five-condition experiment; no fresh reverse rendering. Stored AgX hashes and OFF byte equality were checked, but the display encoding was not recomputed. Metric review covers only fullFG MAE/RMSE and ambient bright IoU/FN/FP, not all 13 domains or every scalar. Unknown reference pixels remain unknown. These results establish neither global acceptance, source Principled equivalence, device fit, legacy 8M work admission, nor a comprehensive security/API-ownership review. No stopped review was used or retried.

Only scripts and aggregate reports are included here. Source geometry, references, raw images, HDR, sample records and masks remain private and are not copied.
