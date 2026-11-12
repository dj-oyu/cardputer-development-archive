# Fixed comparison domains

Original formal v3 code, thresholds, reference seed aggregation and uncertainty masks stay unchanged. Arm OFF reuses/replays A2-compatible character result. Arm ON only changes camera-empty sample radiance. Do not present opaque source color alpha as character shape.

Required comparisons per all10 view/condition cases, all8 reference seeds where existing scorer uses them:
- Original stable/full-foreground color metrics, uncertainty counts and unchanged geometry missing/extras.
- Original four response contrasts: bright/dark/inactive confusion, FP/FN, reverse signs, magnitudes and unknowns; unknown never counted as PASS.
- Predetermined original reference character foreground, original opaque interior, partial-alpha/foreground edge, center-missing foreground, and native center-covered interior/boundary. Use the existing attribution mask definitions/hashes; do not select strata from new image errors.
- Entire image and original reference character-background complement: descriptive RGB565 decoded absolute errors and signed response differences. Background area dominates these domains, so they cannot be aggregated into goal60 or substitute for formal foreground performance.
- Center character depth/support and four-sample character hit support remain original. Background type (floor/world/invalid) and background depth are separate labels, not filled character geometry.
- Background-only is a complete synthetic camera-hidden/shadow-kept control. It must have its own admission/completion, not be assembled from partial combined-arm misses. Its values are not original-reference pixels and never enter point selection.

Raw sample diagnostics retain x/y/sample and hit type; per-pixel sums must join complete unique keys rather than reshape sample-major rows. For ON, sample character HDR stays exact; background radiance, direct/world/Le components and final HDR mean are validated independently. No positivity or clipping count inferred from adjacent JSONL rows. Failed attempts and auxiliary-version corrections remain explicit.
