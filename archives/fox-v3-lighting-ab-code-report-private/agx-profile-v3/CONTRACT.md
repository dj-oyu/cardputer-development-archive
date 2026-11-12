# Fixed-v3 vertex display profile experiment

Reference v3, source scene, cameras, five scenarios, masks, all score equations and thresholds remain unchanged. The base is the frozen `fox-v3-lighting-ab/four-both-002` 1166-triangle physical DISK16 + linear arm. This is a new isolated host experiment, not recovery of the lost earlier 2400-triangle experiment.

## Independent display approximation gate
The installed Blender OCIO config is the only transform source: Linear Rec.709 input, sRGB display, AgX view, Medium High Contrast look, exposure 0, gamma 1. Generated synthetic colors, never reference image pixels, drive LUT generation and validation. A log1p shaper maps each nonnegative linear Rec.709 component onto a fixed [0, 5898.240000132513] domain. Runtime negative/nonfinite values reject atomically; values above the domain clamp explicitly with status. The supported-input score includes clamped values, with subgroup counts reported separately.

Before native image evaluation, each channel must pass fixed absolute error measured in RGB565 quanta (31,63,31): RMSE <= 0.5, P99 <= 1, maximum <= 2. Dark values, black, saturated axes, independent fixed-seed HDR ratios, domain edges and mixed-channel out-of-domain values are included. Float-transform error and final RGB565 rounding error are separate. These are transform approximation gates, not artistic or 60% quality acceptance.

Blender output dithering (reference value 1) is a final image-output stage; this C transform does not reproduce it. Generation uses 16-bit PNG and dither 0 to bound oracle quantization. Source PNG8 rendering must not be claimed byte-equivalent to this continuous profile.

## Vertex arm
`ayatsuri_model_instance_agx_profile(..., enabled)` defaults OFF. Values other than 0/1 reject; ON requires the explicit linear and physical modes. Disabling either prerequisite while profile is ON rejects. Ownership/generation/busy checks and invalidation follow existing instance API. Changed mode invalidates borrowed evaluated views; same mode preserves them. The shared immutable LUT requires no caller-owned storage or lifetime handling. No snapshot format changes.

ON replaces only `clamp HDR -> sRGB` with `unclamped scene-linear HDR -> official-profile approximation -> RGB565` at each mesh vertex, separately for front/back and A/B. Existing raster interpolation remains interpolation of display-encoded quantized vertex colors. It is NOT pixel-after-HDR profile application. No new visibility, GI, emission, specular, or light coefficients are introduced. OFF executes the exact prior formula. Profile evaluation/clamp counters are diagnostic cumulative instance counters; per-process render starts with a fresh instance.

## Separate postpixel diagnostic
The existing fixed grid3 baseline/direction × two views HDR buffer can be transformed by the same C profile after its existing sampling/filtering. This is a host diagnostic, not the owned RGB565 snapshot path, and does not prove a low-RAM product implementation. It is reported separately with its storage cost and four-case scope; it cannot substitute for the ten-case vertex arm.

No automatic default adoption, publication, PR, firmware or device operations. Config/LUT redistributability must be established before any public redistribution. Private bundle excludes source model, geometry, reference/candidate images and raw image buffers.
