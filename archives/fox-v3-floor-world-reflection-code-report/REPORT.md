# Floor-world reflection: fixed contrast result

The isolated physical term improved all ten fixed color comparisons and the ambient display response while preserving exact OFF behavior. It is a useful experimental candidate, not default adoption or a claim of complete renderer equivalence.

## What changed

At a primary floor hit, add only rho_receiver * rho_floor * source Lworld * the miss fraction of the existing 16 cosine-hemisphere rays / outer 16. Original floor emission and direct lighting are unchanged. Blocked terminal-world rays contribute zero. The component is stored and counted separately, and uses the existing visibility API, floor side rule, epsilon, range and cumulative caps.

This is an addition to the completed older host floor-direct/background/display version. It is **not integrated into the row-HDR or indexed/lightweight renderer variants**. No stopped/unverified ownership-context work was included or represented as complete.

## Completed evidence

- O2 and ASan+UBSan synthetic tests, original regressions and byte-exact synthetic OFF AA raster pass. LeakSanitizer is unavailable under ptrace and is not claimed as a pass.
- A separate physical-term review passed 41 independent scenarios, including analytically partial occlusion, original directions, side behavior and budget failure semantics.
- Exactly ten OFF and ten ON forward cases completed: front/oblique × baseline/direction/intensity/ambient/albedo. No retries, changed samples, threshold sweep or fitted coefficient.
- All ten OFF captures and composites reproduce completed prior floor-direct ON RGB/depth/HDR, old semantic counters and original formal scores. Truthful host-context size metadata differs by 32 B; old shading/counter ABI does not.
- ON retains all old components and counters. The total traversal delta equals the new path's distinct charges. All ten original depths, geometry/snapshot bindings, AA masks, two front floor overrides, background events and fixed profiles are preserved.
- Independent retained-output review verified all 20 captures/compositions and 191,040 quarter-sample records. A separate limited metric calculation reproduced all ten full-foreground MAE/RMSE pairs within 2.78e-17 and matched both ambient bright IoU/FN/FP counts, including the oblique FP increase 6→7.
- Source world doubling produces a bit-exact 2× new raw component in both views. Direction/intensity conditions leave that component bit-exact. Albedo uses both actual receiver and source floor rho, not a blanket 0.6 scale.

## Quality on the frozen domains

All ten stable, uncertain and full-foreground color MAE/RMSE improve. Baseline full-foreground MAE falls from 0.119198 to 0.109103 front and 0.118501 to 0.107222 oblique. All eight stable delta-RGB RMSE comparisons improve.

Ambient bright IoU improves from 0.829254 to 0.945889 front and 0.826853 to 0.945577 oblique. Full-foreground bright false negatives fall 890→280 and996→308; bright false positives remain 3 front and change 6→7 oblique. Ambient direction agreement improves 90.153%→98.088% and 88.699%→97.149%.

This is not uniform improvement. Albedo magnitude agreement decreases 92.480%→89.147% front and 94.273%→90.509% oblique; albedo delta-luma RMSE increases 0.0306264→0.0318777 and 0.0317858→0.0325439. Some direction/intensity classification measures also regress. All 7864 overlapping scalar regressions, all 13 domains and undefined/unknown results remain in the complete aggregate audit; they are not independent votes or omitted failures. Missing geometry and shape errors are unchanged.

Detailed tables and exhaustive compressed aggregates: analysis-code/analysis-001/REPORT.md and its COMPLETED.json manifest. No source/reference/threshold/profile/domain changes were made.

## Resource results and limits

Maximum ON traversal was 9,014,748 rays /446,208,267 nodes /138,511,056 triangles, below unchanged 20M/800M/300M caps. Maximum added world traversal was 1,146,672 rays / 35,212,432 nodes / 7,001,836 triangles. New semantic work is explicit and bounded; neither this work nor the older floor work is reclassified as passing the legacy 8M combined-work contract.

Measured ten-frame host render sums: 156.22 s OFF and 168.05 s ON. These are single diagnostic runs with observers and possible overlapping work, not isolated speed measurements or device timings. Core additions are 32 B in the host context, 104 B world ledger and 24 B local result; no scene/geometry heap growth. The separate host center-component observer adds 777600 B plus 16 B control. Relevant O2 stack deltas are +96 B bounce evaluator, +48 B shade callback, +112 B native main, with boundary-AA stack unchanged. Whole-renderer firmware fit remains unresolved.

## Retention and scope

The allowlisted private code/report ZIP contains changed code, tests, aggregate metrics, manifests, review evidence and this report. It excludes source geometry, model files, snapshots, per-pixel/quarter records, HDR/depth/RGB images, LUT data and binaries. Raw outputs remain local and private. No blend save, device operation, SDK installation, public push, PR or upload was performed.
