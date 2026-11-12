# Private fox eye contract (2026-11-11)

## Identity and boundaries

Read-only derived input: `fixed-recovery/extracted/fox-cardputer-latest-private/fox-cardputer-2k-v2.blend`, SHA-256 `384ada0c37da16d625b1e6612a0d2f7ca538c29fe0d8dff43a929841ec63fba8`. This is NOT immutable original `fox-bubble-bold.blend`, SHA-256 `d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a`. The neutral sidecar's source_sha256 refers to that original; it must not be used as the derived file identity. Blender 4.3.2 opened the derived input, evaluated changes in memory, and quit without saving. All deliverables are private, no hardware used, no public upload or repository changes.

## Files

- `evaluated-contract.json`: exact live node graphs, control UI/defaults, object and shape drivers, 13 fixture samples with all 74 original objects, evaluated local positions, matrix_world, triangles and material identities, visibility and shape values. Original triangle order is retained; no neutral degenerates are removed.
- `alpha-ir.json`: reachable alpha DAG and per-material constants.
- `eye_alpha.h`: C99 alpha evaluator and separate outer-corner visibility helper.
- `color-ir.json`: base-color graph reachability/driver mapping. No unsupported reachable nodes.
- `eye_color.h`: C99 source Principled Base Color evaluator. Linear RGB, unlit diagnostic only.
- `validation.json`: 54,000 float32 node-by-node alpha versus C comparisons, 182 shape-driver checks, and eyelid reconstruction checks.
- `color-validation.json`: independent node-graph versus generated C base-color checks.
- `extract.py`, `build_contract.py`, `build_color.py`, `validate.py`, `validate_color.py`: reproducible read-only extraction/generation/tests.

## Material IDs and coordinates

The six local C IDs are contour -X, contour +X, white -X, white +X, outer corner -X, outer corner +X. These are NOT global raster material indices. Map by exact `fox_eye_masks[i].name` to each source object's material slots.

The node named `Head-local eye coordinates` is a ShaderNodeTexCoord whose Object output is linked and whose object reference is None. Blender's Object output without an explicit object means the shaded object's own local position, NOT a head object selected by the node's label. At a shaded point, use `inverse(evaluated object matrix_world) * world position`; this is the deformed evaluated object-local position. For these fixtures, interpolate `vertices_local`, not undeformed basis coordinates. Under perspective rendering interpolate perspective-correctly; orthographic rendering uses affine barycentrics. Do not apply UV normalization, bounds normalization, head-space assumptions or legacy x38 scaling. The dependency on `Geometry` is disconnected for these alpha/base-color paths.

## Exact alpha formula

For side s = -1/+1: cx = s * float32(0.285), rx = float32(0.255), slope = s * float32(0.04), cz = float32(2.55), rz = float32(0.31). All six graphs have the same formula, changing only side. Use the exact extracted constants in the header, not rounded decimal replacements.

b = max(Blink Both, Blink side)
u = (local_x - cx) / rx
root = sqrt(max(1 - u*u, 0))
center = cz + slope*u
half = (rz*(1-b))*root
inside = (local_z < center+half) * (local_z > center-half)
alpha = clamp(max(inside, 1-min(1,50*b)),0,1)

Both comparisons are STRICT. Transparent BSDF is the first Mix Shader input; Principled is the second. Principled Alpha remains 1 and is not the material opacity. At b=0 the entire material is opaque, including points outside the ellipse. For 0<b<.02, outside pixels have fractional alpha. For b>=.02 the mask is binary. At b=1 all alpha is zero. Gaze, Eye Style, highlights, environment reflection and Bubble Pressure do not reach alpha, but several reach white Base Color.

Source UI blink domain is [0,1], gaze [-1,1], style integer 0/1/2. Header clamps blink controls defensively, with nonfinite blink defaulting to zero; nonfinite coordinates discard. This is a declared runtime guard, not a claim that the source driver has explicit blink clamping. `evaluated-contract.json` retains both actual source defaults and UI metadata defaults, which differ for Show Highlights and Environment Reflection. Actual defaults are highlights=1, reflection=.5.

## Geometry and visibility

Moving eyelid edge +/- has relative shape `Blink`, driven by max(Blink Both, Blink side). Position = Basis + b*(Blink-Basis), before remaining source modifiers. This formula matched Blender evaluated local positions for all supplied fixtures within 1.4e-7 metres. All 36 neutral eyelid triangles remain in topology; 32 activate with nonzero blink, four remain zero-area in these samples. Evaluate morphs first and skip zero-area triangles only at raster time. No topology pruning.

Outer eye corner objects additionally have `hide_render = max(Blink Both, Blink side)>=.98`. Respect this independently from material alpha. Other object/shape drivers are retained verbatim; don't substitute guessed changes.

## Depth/coverage contract

Evaluate alpha BEFORE writing opaque depth or color. Alpha zero discards without depth/color/ID writes; alpha one follows ordinary depth test/write. Fractional alpha requires transparency or deterministic coverage/dithering before the opaque depth write, not unconditional opaque submission. An explicit diagnostic threshold is permissible only when labeled a threshold approximation; .25/.5/1 fixtures avoid this fractional interval. This contract does not assert matching Blender DITHERED's exact pixel noise pattern.

## Base-color scope

The reachable source graph uses only supported Math operations, object-local TexCoord/SeparateXYZ, value drivers, three legacy MIX nodes and LINEAR RGB ColorRamp. The C evaluator returns source scene-linear RGB. Convert to display sRGB once before RGB565 packing for an unlit diagnostic. It does not evaluate Principled BSDF light response, metallic/roughness, reflections, film/view transform or shadows. Environment Reflection targets a Principled parameter rather than Base Color. Eye Style 0/1/2 selects normal/watery/comic blank behavior; Gaze X/Up shifts source shader coordinates, not an invented gaze geometry transformation. Full branch graph/driver definitions are retained for audit.

## Remaining limits

Alpha/C agreement validates the exact extracted node arithmetic, not a pixel-by-pixel Blender shader render. Source reference renders are retained separately in the private validation materials. Fixture extraction covers source control samples, not exhaustive joint control combinations or arbitrary out-of-domain controls. Source local coordinates are confirmed from the live node type/reference/link semantics; no alternate head coordinate object was inferred. General Principled lighting and renderer-wide translucent sorting are out of scope.

Additional source-evaluated fixtures at indices 10–12 are blink_0.01 (fractional coverage), blink_0.02 (binary boundary), and blink_0.98 (outer-corner visibility threshold). Existing first ten fixture indices are unchanged.

## Non-eye source colors

`non_eye_base_colors.json` and `non_eye_base_colors.h` export all six remaining materials by exact UTF-8 source name. Each is a direct, unanimated Principled BSDF with unlinked constant Base Color; all six constants match the retained sidecar exactly. No unsupported or procedural Base Color paths were found. Use these scene-linear RGBA values instead of material-ID diagnostic colors, then convert once to sRGB before RGB565. This remains an unlit source-color diagnostic, not a lighting match. `fox_non_eye_base_color(name)` returns the RGBA pointer or NULL for unknown names.
