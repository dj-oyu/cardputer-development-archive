# Offline source-to-integer scene preparation, fixed-input stage only

Use `prepared-baseline-v2.json` as the final fixture. `prepared-baseline-v1.json` is an earlier no-overwrite export retained for traceability; v2 adds preparer binding and numeric error diagnostics. Nothing here runs a renderer, BVH, intersection, visibility callback or ray query. No old loader is patched. No denied tree was accessed. This is independent fixed-input arithmetic preparation, not actual-frame integration.

## What was established

Pinned authored extraction → FOXDISK1 input → unchanged double scene preparation → explicit JSON fields → checked integer encoding is now usable without loading an opaque C snapshot struct.

- Baseline source light position, Euler XYZ, linear color, power, diameter and world values exactly equal all37 numbers in the current physical-baseline.txt.
- The exact existing double initializer produces all51 scene double fields **bit-identical** to the saved baseline snapshot's explicitly parsed little-endian fields. Zero mismatches.
- All144 disk16 sample-coordinate components are **bit-identical** to the samples calculated from the saved prepared fields and the unchanged disk16 constants. The snapshot does not itself store sample positions; this distinction is intentional.
- Both authored cameras map exactly to the recorded front/oblique command values and reproduce the frozen integer geometry experiment's Q20 coefficients/Q10 offsets. Operation order matters: zoom is `135 / verticalOrtho / 38`, not `135 / (verticalOrtho * 38)`, which differs by one binary64 ULP here.
- Ground vertices/triangles/linear emission exactly match FOXGROUND1. Eight mesh diffuse linear colors exactly correspond to the fixed source adapter's material IDs. The ninth authored material is explicitly identified as the studio ground, retained separately.

`reference_init.c` contains only the unchanged prefix of the pinned physical source through scene initialization plus a small explicit-field wrapper. Its exported symbols are scene_init, scene_validate and prepare_reference. It contains no evaluator or visibility/ray code. Compilation disables FMA contraction and fast math, and the wrapper rejects any floating rounding mode other than FE_TONEAREST. The snapshot is used only for offline fidelity comparison, not as the exported scene's source or runtime loader.

## Source/provenance boundary

Authoritative inputs for this experiment are the existing static extraction files in `fox-v3-floor-direct-reflection-evaluation/actual-002/inputs`: physical-source.json, ground-source.json, candidate-config.json and source-materials.json, together with the verified fixed-source material trace. Exact SHA256s of these inputs, physical/ground texts, snapshot, camera commands, unchanged physical source/header and consumer headers are embedded in the fixture. The preparer and wrapper also have embedded hashes.

The extraction claims source Blender SHA256 `9254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806`; **the original .blend is not independently reopened or animation-validated here**. The existing candidate config explicitly lists animation validation unsupported. Consequently this exporter admits only the pinned extracted-static fixture contract. It does not pretend to validate arbitrary Blender scenes, animation, rigs, parents, nonidentity scale, alternate rotation modes, non-DISK shapes, spread/normalization variants, textures or a general material graph. Such imports require a separate authored-source validation contract. Unknown/dynamic fields in the strict preparation envelope are rejected rather than guessed.

Authored Blender normal/tangent arrays are binary32-derived values. The established double initializer instead evaluates the saved Euler rotations in binary64; their maximum component difference is2.752625871682568e-8. Replacing the current prepared axes with the authored rounded arrays would change the preparation. The fixture deliberately retains the unchanged double calculation and records this difference.

## Exported fields and consumer mapping

- `source_input`: strict schema, explicit extracted-static mode, three DISK/XYZ/no-parent/identity-scale lights, linear colors, power/diameter, world color/strength, and visibility designation.
- `lights.high_precision`: complete double center, normal, u/v axes, power×color/π², radius, all16 sample coordinates, and world radiance. These are retained for a possible future fallback, **which is not implemented**.
- `lights.integer_scene.lights[]`: `center_q16`, `normal_s32767`, `power_q16`, `samples16_q16`; `world_q24` maps directly to the existing `il_scene` fields. No raw memory copy or struct-padding assumption is needed.
- `cameras[]`: original Blender/native values, stored binary32 camera/basis, prepared double rows/offsets, and signed32 `m_q20`, `offset_q10`, position_frac20/screen_frac10 and240×135 dimensions. Native source metres use `(Blender x,-Blender z,-Blender y)`. Pixel rows absorb scale38; depth row is metres. Native integer-i sample convention already uses centers119.5/67, subtracting Blender's halfpixel exactly once. Do not subtract it again.
- `materials[]`: original source-linear RGB, signed16 rho codes divisor32767, sidedness and explicit fixed-source material ID or retained-ground-only designation. No RGB565 round trip or sRGB decode is introduced.
- `ground`: all original high-precision world vertices, triangles, normals, linear emission and Q24 emission codes, plus **lighting_geometry_admitted=false**. Ground reaches±100m while the current lighting API admits only±8m. It is neither clipped nor silently fed to that API. Geometry representation within±128m does not remove the lighting limitation.

Visibility is **UNSET/caller-supplied per hit**. No all-visible mask is generated. An all-visible assumption may only be supplied by a separately labeled synthetic test. No current or future visibility policy is changed here. The fixture does not choose AA slots, background/floor replacements or winners. The independent AA module owns explicit KEEP/REPLACE selection and one-rounding `sum / (sample_count * 32)` Q24→Q19 before the profile. Averaging tone-mapped RGB565 or an extra Q24 rounding is not introduced by this preparation.

## Numeric contract and error

All JSON numbers must be finite actual numbers, not booleans; unknown schema fields, duplicates, nonfinite constants, oversized/deep JSON and malicious numeric values are rejected. Input colors are linear, bounded and nonnegative. Lights require centers and all prepared disk samples within±8m; derived power/π²×color≤256; world radiance≤16. Source power is conservatively limited to256π² and diameter≤16. Prepared normals must encode inside the consumer's32762²..32772² squared-length tolerance. Bad ranges are rejected before encoding; there is no saturation or partial scene publication.

Codes use nearest ties even on binary64-scaled values. Q16 positions have error≤0.5/65536m, signed normal/reflectance divisor32767 error≤0.5/32767, Q16 power error≤0.5/65536 and Q24 world error≤0.5/2²⁴. The offline module performs double calculations only; it adds no floating operations to a hit/shading hot path.

Actual baseline maximum errors:
- Centers:0.
- Disk samples:7.6017164376551705e-6m.
- Normal components:1.430304373972735e-5.
- Power coefficients:7.2659572012412355e-6.
- World radiance:2.9802322387695312e-8.

These are preparation/encoding errors, not image or visibility error bounds. Per-hit endpoint/plane guards, normal-cancellation rejection, HDR range/clamp policy and target performance remain responsibilities of their existing modules.

## Tests and reproduction

Run `./run.sh NEW_OUTPUT.json`. Output must be a new path inside this directory; all completed exports are published atomically using a temporary file, fsync and exclusive hard-link creation. Existing files and symlinks are never replaced. Serialization rejects NaN before publication; temporary files are removed on failure. A generated file is the completed atomic artifact, not a crash-atomic pair of independent files.

Six unittest groups pass: exact fidelity/determinism and frozen camera coefficients;16 schema/numeric/domain mutations; malicious JSON including duplicate keys, NaN/Infinity, huge exponents/integers and deep nesting; signed ties/endpoints/range rejection; no-overwrite/symlink/atomic cleanup; non-nearest floating rounding mode rejection. Input/source mutations fail before any export. This exporter is private test infrastructure, not a production asset loader or security boundary for arbitrary native pointers.

No additional input is needed for this pinned static baseline. Missing for broader use: an independently validated authored .blend/animation/static-export declaration, general supported-material/transform schema, a policy or implementation for floor points beyond±8m, and actual per-hit visibility/AA replacement inputs. None is inferred or obtained by expanding this task's authorization.
