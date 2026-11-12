# Versioned latest-source attribute sidecar proposal

**Design only. No converter, model export, renderer capability, opacity test or visibility API was implemented. Existing AYFQ v1 and all admission gates are unchanged.** This logical sidecar is not evidence that a latest-source asset currently fits or renders correctly.

## Minimal data identified from actual shader graphs

Coordinate/material worker `/root/evaluate_parallel_pixel_color/prototype_fixed_color_kernel` independently traced the saved DAG. The live sclera/bink graph uses TexCoord.Object, object=None, X/Z components. It does not use UV or Generated coordinates. Store the coordinate inputs the graph actually needs, rather than treating existing UVMap as an automatic replacement.

Required for the studied eye materials:
1. Original source object/material IDs and exact source/state/geometry/recipe binding.
2. **Object-local XZ** varying, with explicit Blender-local axes/units and shader-coordinate semantics. Retain parent HeadPivot relationship and source object transforms in the preparation manifest. Never substitute world P or native `(x,-z,-y)` coordinates without the defined inverse mapping. Raw base coordinates are not yet proof of deformed/evaluated shader-coordinate equivalence.
3. **Linear RGBA** for the iris POINT attribute `Iris gradient`, mapped through output corner splits. Its actual alpha is1 everywhere. The source gradient's current hidden separate mesh must not be assumed active; retain its mapping without forcing visibility.
4. An external versioned **material recipe and state manifest** describing procedural albedo, mask, ramp, material parameters and controls. The transparency mask is a separate program result, not the iris alpha field or a per-vertex approximation.

UV should be an optional typed channel only if the selected future representation consumes it. Merely adding UV cannot preserve the procedural eye DAG. A third local Y channel can be added under an explicit capability if another supported material needs it; the present minimum is XZ.

## Proposed logical schema: `ayatsuri-attribute-sidecar-v1`

The eventual loader must require an explicit capability handshake; the existing AYFQ reader must not silently ignore a required sidecar. The outer asset manifest, not a permissive comment in AYFQ, must say which sidecar/material capabilities are mandatory.

Header/binding fields:
- schema and semantic version; source .blend SHA256.
- frozen state-manifest SHA256, including chosen frame/control preset, camera-independent object transforms, source curves/modifiers/shape/rig resolution policy and evaluation provenance.
- exact geometry payload SHA256, coordinate/basis contract and topology/partition mapping version. A sidecar for old lid8 geometry cannot bind to latest geometry by matching a name.
- material-recipe SHA256 and explicit required capability list such as `local_xz`, `linear_rgba`, `procedural_mask_recipe`. This advertises data requirements, **not** implemented renderer support.
- primitive count, corner count and original object/material ID table. Stable IDs should be source-hash-scoped datablock identity plus an explicit source topology identifier, not display name alone.

Per output triangle/corner logical record:
- geometry part ID, local triangle index and corner0/1/2, plus original object/material and source point/loop IDs or an explicit mapped/barycentric LOD provenance record.
- optional local_xz signed32 codes, fraction20, Blender-object local metres, admitted coordinate magnitude≤128. This proposed range must be checked on the eventual resolved coordinate stream, not inferred from today's raw bounds.
- optional linear_rgba signed16 codes, divisor32767, each0..32767. Source alpha remains source alpha. Do not bake a discontinuous procedural mask into these corner samples and call it equivalent.
- optional UV signed32 fraction20 with a separately declared admitted range and texture addressing convention. Signed coordinates may lie outside0..1; do not clamp/wrap without that material's explicit contract.
- missing optional channels must be distinguished from zero-valued channels. Required channels cannot be omitted or replaced by material defaults.

Why per-corner logical association: source UV uses CORNER domain; colors use POINT but normals/material boundaries/LOD may split vertices. Association must remain exact through those splits and part reordering. This need not mandate wasteful duplicated runtime storage: later packing may deduplicate identical attribute tuples, but only with an identity/topology proof and explicit indices. No packed binary layout is selected here.

## Integer interpolation contract, without shading/coverage integration

Use exact-sum nonnegative Q2.14 weights from the existing integer triangle sampler. For local coordinate codes±2^27, the convex weighted accumulator magnitude≤2^41, so signed64 MAC and nearest-even division by16384 are sufficient. Interpolate directly at local Q20; do not narrow to lighting Q16 first. For RGBA0..32767, signed64 MAC bound32767×16384<2^29; existing signed16 interpolation can be reused. Preserve shared physical vertex/corner consistency across part splits.

These bounds cover **attribute interpolation only**. They do not prove the material graph's divisions, sqrt, thresholds, polynomial, output opacity or dynamic coordinate domain. Those require the separate material numerical contract. UI slider limits are metadata, not enforced clamps. The raw Bubble Pressure input and its explicit shader clamp[-1,1] must remain distinct: one driver uses the unclamped input in a quartic.

Frame/control preparation records must retain BlinkBoth and per-eye blink, GazeX/GazeUp, EyeStyle, ShowHighlights, EnvironmentReflection and BubblePressure, plus exact constants/ramp and supported-driver mapping. Data-only `control-metadata.json` records UI bounds and exact action keys/handles/CYCLES settings. Nothing in this proposal executes drivers or promises animated support.

## Admission and fidelity requirements

Reject source/state/geometry/hash mismatches, unknown mandatory capabilities, missing corners/channels, duplicate/conflicting corner bindings, nonfinite or out-of-range source values, invalid integer domains, unsupported material recipes and unsupported dynamic state. Never use default-white/constantRGB as a fallback for a linked procedural color input. Keep source/high-precision metadata for diagnosis; it is not an implemented runtime fallback.

Separate tests should first verify typed encoding, exact interpolation/batch agreement, topology/corner correspondence, affine local-coordinate mapping and source IDs on synthetic data. Material tests may use fixed coordinates/control tuples only within the authorization granted to that worker. No opacity-driven geometry admission, ray/visibility query or actual frame integration follows from this sidecar proposal.

## Memory and scope warning

A naive localXZ+RGBA payload is16 bytes/corner before IDs/indexing. Even an eventual2048-triangle mesh would need98,304 bytes at three fully duplicated corners each. This is not a device-fit claim or chosen packing. The source's hundreds of thousands of base triangles cannot be solved by attaching a sidecar to the current format; LOD/resource work is separate and assigned elsewhere.

The next safe engineering decision is the exact logical attribute/material contract, followed by standalone encoding/interpolation tests. Rendering, reduction, baking, export, dynamic evaluation and visibility behavior remain separately scoped. No latest-model comparison is claimed until the actual new source/state/geometry/material binding and appearance fidelity exist.
