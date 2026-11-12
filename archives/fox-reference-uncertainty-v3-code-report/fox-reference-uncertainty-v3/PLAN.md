# Frozen reference-stability plan v3 (input restoration incomplete)

User authorized separately evaluating repeatable Blender response and reporting uncertain components without counting them as success. No old criterion/result is erased. Current latest v2 image/candidate pack is unavailable in this environment; no old byte identity or measured old result is reconstructed from inference.

## Fixed experiment, before new reference images
- Eight distinct seed values, in this exact order: 11, 29, 47, 71, 101, 131, 173, 211. Seed 0 and prior probes are historical context, not members of this new sample.
- Cycles maximum samples 2048, thread count 8. Eight repetitions × five cases (baseline, direction, intensity, ambient, albedo) × two views (front, oblique) = 80 images, no optional stopping or score-driven seed/sample additions.
- Within each seed, use that same seed for all cases. Different seed pairs supply the eight observations of each response. Keep adaptive sampling, denoising, clamping, Light Tree, materials, geometry, camera, light-case definitions, exposure, AgX/look/gamma, output precision, dither and AA settings unchanged from the verified input contract.
- Candidate never participates in choosing seeds, masks, confidence levels or threshold. No native renderer modification.
- Rendering is blocked until the source/camera/scenario contract and intended reference masks are verified or an explicitly named new reference contract is authorized. Missing old artifacts are not replaced by approximate substitutes claiming old identity.

## Reference-only classification
Read each rendered 8-bit display PNG as RGB/255 first, then compute per-seed encoded luminance delta using Y = .2126 R + .7152 G + .0722 B. Do not average HDR before AgX. Threshold t = 2/255 is unchanged.

At each pixel, take the eight paired deltas d_i. Calculate mean m, sample standard deviation s (ddof 1), and pointwise model-based 95% Student-t interval m ± t(.975, 7) s/sqrt(8). This is a mean interval under its statistical assumptions, not a predictive interval for future renders, not a confidence guarantee for all pixels jointly, and not proof of independent identically distributed finite-path error. Eight distinct pseudorandom seeds do not establish those assumptions. Quantized/heavy-tail/rare-event errors and adaptive stopping can violate approximations.

A pixel is:
- observed stable bright if every d_i > t AND the lower interval bound > t;
- observed stable dark if every d_i < -t AND the upper interval bound < -t;
- observed stable inactive if every d_i is in [-t,t] AND the whole interval is in [-t,t];
- uncertain otherwise.

Equality at ±t is inactive, never bright/dark. Nonfinite/missing/malformed inputs are errors, not uncertain pixels or zero values. Zero observed sample variance yields a zero-width interval, with no claim that rare outcomes are impossible.

All three stable classes form the evaluation domain. Stable inactive pixels are retained, so candidate false brightening/darkening there remains penalized. Reference classification is saved before candidate scoring. No candidate-dependent deletion.

For each view/case/channel, color precision is observed stable when the pointwise 95% mean interval half-width is ≤ 2/255 in all three channels. This is only reference precision, not a color-match pass. Color and response precision masks are separate. Geometry is reported only from verified fixed source coverage and candidate depth, never inferred from RGB blackness.

## Scoring and explicit scope
- Use the reference mean of already-encoded RGB samples as the representative input. Preserve all eight individual metrics and the pooled full-foreground comparison alongside stable-subset metrics; the pooled values do not replace the old fixed v2 score.
- On the stable domain, preserve existing formulas for RGB agreement, response magnitude, delta error, sign, brightening/darkening IoU and centroid. Direction-sign calculations keep the existing significant-if-either rule. No new acceptance threshold is assigned to correlation/centroid.
- Report uncertain-domain errors separately where definable; never fill them with zero, remove them from denominators without stating the changed domain, or add them to PASS counts.
- Report all area counts/percentages relative to the same declared foreground, stable bright/dark/inactive counts, uncertain locations and sign frequencies, relevant response-area coverage, and source-only spatial/part summaries where verified mappings exist. Background full-frame diagnostics remain informational.
- Stable-subset finite scores ≥60 can be labeled as meeting 60 **on that observed subset only**. Any uncertain remainder keeps the whole condition's completion unresolved, without invalidating a separately reported result on another condition's stable subset.
- The 90% domain-coverage flag is a newly proposed descriptive warning only, not a user requirement or mandatory PASS/FAIL gate. Low coverage must be prominent, never hidden by a high subset score.
- Empty stable domain has no score. Empty bright/dark union is N/A for the stable subset, not a pass; if uncertainty remains, the whole directional-location result is still unresolved. Whole-foreground all-uncertain is never success. No candidate means no renderer quality score.
- Eight repetitions complete the experiment. Failures may be retried at identical settings; incomplete repetitions block analysis rather than reducing n. No sample-increase loop or after-the-fact threshold fitting.

## Statistics reference
The mean interval formula and its frequentist interpretation follow NIST's [Confidence Limits for the Mean](https://www.itl.nist.gov/div898/handbook/eda/section3/eda352.htm). Spatial pixels are correlated; no multiple-testing or simultaneous-confidence claim is made. The interval and 8/8 agreement are an operational, conservative-looking observed-stability rule, not a calibrated global guarantee.

## Current stopping condition
Implement/test the evaluator and document missing artifacts now. Start new image generation only after independent plan review and verification of the new/old input-contract boundary. End with scoped results plus held uncertainty, or an exact missing-input report. Public upload, PR and device actions are outside scope.
