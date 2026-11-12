# Fixed camera-composition HDR, display-only comparison

Scope: reuse the completed v38 camera-floor scene-composition arm, fixed lid8/A2 quarter ±.25 samples, fixed mask, camera, lights, source floor/world and geometry. No renderer execution or change, new exposure, filter, sample count, gain, model, reference or threshold. No floor-reflection transport arm. This is a private host postprocess diagnostic, not a product HDR-storage implementation or device result.

## HDR reconstruction gate

Pin the prior completed60-frame camera experiment and its external ALL_OUTPUT_PINS inventory before reading inputs. For each of10 forward view/case frames, join every composition event by exact integer(x,y,sample), with exactly one center UINT32_MAX event for each non-target pixel and exactly one of each quarter0..3 for every target pixel. No sample-major reshape. Floor/world replacements use the exact saved linear returnedRGB. KEEP quarters use the saved actual character linearRGB and all character hit/depth identities must agree. Accumulate quarters0,1,2,3 in the original double order then multiply by .25.

KEEP non-target centers are not present in the AA-quarter observer. Reuse the pre-existing all10 current-lid8 finalwinner/preclamp center HDR capture in fox-v3-lid-display-combination/run-001 only after independently proving its geometry/snapshot/lighting/material and unchanged center-shader lineage to A2/v38. This is reused historical raw HDR, not newly captured HDR and never inverse RGB565. Input/source hash and depth controls are mandatory. If this provenance is not supportable, stop rather than infer HDR from quantized color.

Before applying the alternate profile, encode the complete reconstructed HDR with the existing legacy C float32 sRGB/lroundf565 routine and require every pixel of all10 existing scene-composition RGB565 files to match exactly. Character-only depth and masks remain immutable. This control supplements, not replaces, the center-HDR provenance proof.

## Display arm fixed before output

Reuse the existing synthetic-validated official-OCIO-derived float65 LUT without regeneration: fox-v3-agx-profile/profile. Frozen size65, shaper log1p(x/lo)/log1p(hi/lo), domain0..5898.240000132513; float tetrahedral evaluator and RGB565 rounding unchanged. Display sRGB, view AgX, look AgX - Medium High Contrast, exposure0, gamma1, dither0. Check sha256-manifest, frozen.json, validation.json, provenance, Blender4.3.2 installed config and all20 installed/copied OCIO dependency hashes against the existing pins. This is a LUT approximation, not exact OCIO processor equality.

Use the same fully composed linear HDR in both arms. Apply the profile only once after the quarter average. No additional convolution or pixel weights. Negative/nonfinite/float-overflow input is failure; finite values outside the existing LUT domain are clamped and flagged, never discarded from scoring. Separately count legacy sRGB input saturation above1, LUT-domain clipping, display endpoint saturation, and foreground/background/edge/interior/center-missing strata. No clamp exclusion or normalization.

## Evaluation, resources and completion

Reuse unchanged formal v3 math and original reference-only stable/uncertain/full-foreground masks. Shape uses original character-only depth, not background radiance. Preserve all10 color, all8 response contrasts, all seeds/unknowns, FP/FN, reverse/inactive classifications and every regression. Fullframe/background descriptive gains are never added to goal60. Use the existing fixed attribution domains; no new output-dependent masks. Compare legacy-v38 against AgX on identical HDR only.

Report profile RO bytes separately (65^3*3*4=3295500 LUT payload plus code), diagnostic HDR777600B and output64800B plus reconstruction scratch/host RSS. The old product snapshot/owned limits are unchanged; this separate fullframe HDR array is not a product fit claim. Measure reconstruction separately from profile application. For display host timing use11 recorded repetitions per arm/frame, all outputs consumed/byte-checked, raw nanoseconds retained; no renderer benchmarking. Coordinate short compile/timing with independent review. Treat elapsed host measurements as limited reference, not device speed.

Completion requires all10 legacy controls before alternate profile output/quality, pinned inputs unchanged, independent reconstruction/profile/metrics review, explicit code/report-only allowlist. Source geometry, original images, raw HDR/events, generated pixels and LUT raw assets are excluded from the new saved bundle. Parent handles private saving; no public PR/upload/device action.
