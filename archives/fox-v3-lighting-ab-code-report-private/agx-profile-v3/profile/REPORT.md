# Private AgX host profile

PASS on the documented finite synthetic holdout, not a proof over all possible RGB values. No fox/reference image pixels were read or fitted in building this profile. No original model was modified. No download, upload, PR, or device operation occurred.

## Frozen contract

Input: finite, nonnegative scene-linear Rec.709 RGB. Output: sRGB-display floats [0,1], AgX, AgX - Medium High Contrast, exposure 0, gamma 1. Dither 0; reproducing the source image's dither 1 is not claimed. Official Blender 4.3.2 `Image.save_render` PNG16 supplies LUT nodes and held-out oracle values. The reference compositor/PNG8 pipeline is not claimed byte-identical to save_render; PNG16 quantization error is at most 1/65535 per channel before interpolation.

65^3 grid. Fixed shaper u=log1p(x/lo)/log1p(hi/lo), lo=2^-12.47393, hi=2^12.5260688117=5898.240000132513. This uses the official configuration's allocation endpoints but is deliberately a Rec.709 log1p approximation grid, not an assertion that the official AgX pipeline uses this exact shaper. The complete official transform is sampled at every node. Tetrahedral interpolation in shaped coordinates. No inverse E-gamut lattice is used, so negative E-gamut-derived lattice values cannot be silently clipped by the generator.

`int agx_profile_eval(const float in[3], float out[3])` returns 0 normally, 1 for any above-domain channel clamped to hi, 2 for negative/nonfinite or null input/output. Invalid input leaves output unchanged. In-place input/output is supported. No allocation, initialization, external file or runtime OCIO dependency. CLAMP_HIGH is diagnostic and must not be silently reported as in-domain. The nearest float to the exact upper endpoint is slightly above it and can receive the flag.

## Validation

Gates fixed before generation: per-channel errors scaled by RGB565 channel quantum (31,63,31), RMSE <=0.5, P99 <=1, max <=2. No exclusions to rescue gate. 84,981 accepted test samples include 50,000 independent log-HDR random colors, 5,000 linear HDR, 2,049 black/dark gray, 12,288 saturated-axis values, 36 domain endpoints, 1,000 all-high out-of-domain colors, 8,912 mixed-channel out-of-domain/float32-max cases, and 5,696 first-cell dark/saturated fixtures (seed 47501). The first-cell fixtures explicitly bracket lo*expm1(log1p(hi/lo)/64) with float neighbors, cube corners, random mixtures, and saturated axes; all have zero error and no clamping. These were added on independent review after initial success; no gate or profile parameters changed. Seeds 731994 and 901734, specified in scripts. Additional mixed out-of-domain tests were added after the initial pass to strengthen coverage, not to adjust the profile. 15 negative/nonfinite permutations reject atomically.

All-accepted per-channel RMSE: 0.0384644, 0.0316876, 0.0490717.
P99: 0.1152684, 0.1088768, 0.0841944.
Maximum: 1.1684546, 1.5846262, 1.2398997.
Rounded RGB565 code differences: maximum 2 in each channel. Full per-group counts, clamp counts, continuous and quantized results: validation.json. Out-of-domain oracle was evaluated at actual unclamped input, not at profile-clamped input. Error for tested out-of-domain colors is zero, but no guarantee is made for all untested out-of-domain colors.

## Size and provenance

LUT read-only data: 3,295,500 bytes, 823,875 float entries. Host object text/rodata total recorded with `size`; zero data/bss. This is a host-only prototype, with no ESP32/WASM memory-fit claim and no runtime speed claim.

`official-colormanagement/` preserves the installed config and all LUT dependencies exactly. provenance.json gives original paths, SHA256, settings, generator path, installed Blender binary hash and version. sha256-manifest.json hashes this deliverable. No image content determined the LUT. The exact installed config references `ocio-license.txt`, but this file is missing from the installed distribution and filesystem search. `/usr/share/doc/blender/copyright` is copied verbatim as installed-blender-copyright.txt; it is generic packaging provenance, NOT asserted to be the AgX-specific license. The `/usr/share/doc/blender/license` directory is empty of regular files. License clearance is incomplete; this remains private and must not be published or redistributed as cleared official material.

## Reproduce

From the workspace root:

1. `/usr/bin/blender -b -t 2 --python fox-v3-agx-profile/profile/generate.py`
2. `/usr/bin/blender -b -t 2 --python fox-v3-agx-profile/profile/extra_oracle.py`
3. `/usr/bin/blender -b -t 2 --python fox-v3-agx-profile/profile/dark_oracle.py`
4. `python fox-v3-agx-profile/profile/validate.py`
5. `cc -std=c99 -O2 -Wall -Wextra -Wpedantic -c fox-v3-agx-profile/profile/agx_profile.c -o fox-v3-agx-profile/profile/agx_profile.o`
6. `size fox-v3-agx-profile/profile/agx_profile.o`
7. `python fox-v3-agx-profile/profile/provenance.py`

Always run generation before extra_oracle and dark_oracle to avoid appending extra samples twice. CLI reads native-endian binary float32 RGB triples from stdin and writes float32 triples to stdout; invalid triples yield [-1,-1,-1]. Use the C API to obtain status flags. Build/link with libm. `validate.py` reads PNG16 via a lossless stdlib PNG decoder, compiles actual C, and checks actual CLI output against independent oracle values.

## Additional generator control

Independent seed 92031, 1,024 synthetic log-HDR/black/gray/primary samples: the official `Image.save_render` PNG16 dither0 and official `Image -> Composite` ONLY PNG16 dither0 were pixel-identical. No RenderLayers node or source scene pixels. `control-comparison.json` records zero differing pixels, zero max display error, zero PNG16 codes and zero RGB565 quantum error. This is evidence for the tested generator path/settings, not a universal identity claim for PNG8/dither1 or other display settings. Reproduce with `/usr/bin/blender -b -t 2 --python fox-v3-agx-profile/profile/control_oracle.py` and `python fox-v3-agx-profile/profile/control_compare.py` before the final provenance step.
