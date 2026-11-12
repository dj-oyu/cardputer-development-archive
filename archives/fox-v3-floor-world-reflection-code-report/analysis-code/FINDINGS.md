# Completed fixed-reference result

World OFF matches all ten completed prior floor-ON HDR, legacy565 and AgX565 buffers exactly and reproduces all formal v3 numeric values exactly. Source/reference/profile/threshold pins, both 10-frame capture manifests and both 10-frame composition manifests pass. Every original fixed domain and character-only shape is unchanged.

World ON reduces MAE and RMSE in the stable, uncertain and full-foreground color domains in all ten cases. Baseline fullFG RMSE is 0.173061057 → 0.164244206 front and 0.167253863 → 0.157511584 oblique. All eight stable delta-RGB RMSE values improve.

The ambient regression from adding floor-direct light is substantially recovered in this new conditional contrast. Ambient bright IoU improves 0.829254302 → 0.945889101 front and 0.826853292 → 0.945577056 oblique. Bright FN/active-to-inactive falls 890 → 280 and 996 → 308. Ambient direction, magnitude and delta-luma RMSE also improve in both views. Oblique ambient bright FP still increases 6 → 7.

Regressions remain. Albedo magnitude agreement falls 92.4801 → 89.1467 front and 94.2731 → 90.5089 oblique; albedo delta-luma RMSE worsens in both views despite lower delta-RGB RMSE. Direction dark IoU falls in both views and active-to-inactive grows 274 → 294 front / 282 → 305 oblique. Oblique-intensity direction, magnitude and dark IoU decline. The complete audit retains 22 formal-stable scalar regressions and 7,864 regressions among 63,050 overlapping diagnostic scalar leaves. They are not independent tests or votes.

Raw-component checks, separate from display scores, pass: ambient is bit-exact 2× baseline and direction/intensity are bit-exact baseline in both views. Albedo uses both source-derived receiver and floor reflectance, not a blanket 0.6 multiplier. Observed raw new-component channel-sum ratios are approximately [0.35965, 0.36170, 0.34866] front and [0.35910, 0.36050, 0.34856] oblique. Source-floor RGB ratios are [0.600000028383165, 0.6000000152832428, 0.6].

Profile-domain clamps are zero across every case/domain in both arms. Quantized endpoints remain separate. Both arms have 36 conditional MEETS and six N/A; global acceptance and goal60 are NOT_ESTABLISHED. This is not a source Principled-equivalence, device-fit, default-adoption or additive-gain claim.

All16 preparation tests pass. Prior-only formal and fixed-domain replay passed before new outputs arrived. The actual new scoring run then completed with all admission gates. No renderer, source, reference or profile was modified by this analysis; no raw image, HDR, depth, sample, geometry or LUT arrays were copied into the aggregate deliverable.
