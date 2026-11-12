# Latest-source fixed-point material feasibility plan

## Source and scope

Authoritative user-corrected source: `fox-bubble-bold.blend`, SHA-256 `d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a`. All previous older-model actual-image/corpus results are historical only and do not validate this model. This analysis reads the latest data-only inventory/supplement/control metadata and official source text. No driver/build script execution, frame evaluation, render, bake, GLB export, geometry changes, visibility queries or renderer integration occurred. The prior denied ownership/context operation is not retried or bypassed.

Inventory was produced by the source worker with Blender4.3.2, autoexec disabled and no depsgraph/frame changes. Consequently saved socket defaults and raw control values are **stored state**, not proof of evaluated frame/shader state. Saved Eye Style0 must not be assumed to match a shown preview using style1.

## Actual graph, not constant RGB

Each `Blink mask Expressive eye white -1/1` stores188nodes,276links,169Math nodes. Source pointers: inventory `/materials/4/node_tree` and `/materials/5/node_tree`. `analyze_inventory.py` validates node/socket references, checks the DAG, follows Surface reachability, and emits complete socket-linked SSA-like listings. It never evaluates a driver string.

Only136nodes/118Math are reachable from Material Output Surface.52stored nodes are disconnected: the unconnected Geometry node and51Math nodes. Their exact list is in `dag-summary.json`. They may be omitted from a compiled recipe after confirming the source hash/output roots; they should remain in provenance, not be deleted from Blender. This is graph pruning, not an appearance simplification.

| Reachable Math classification, per eye | Operations |
|---|---|
|77 spatial/per-sample |27 multiply,18 subtract,10 add,9 divide,7 less-than,3 maximum,2 greater-than,1 sqrt|
|39 frame/control-uniform |16 multiply,10 add,7 subtract,2 less-than,1 greater-than,1 minimum,1 sqrt,1 divide|
|2 invariant constants |1 subtract,1 add|

Base Color reaches110nodes/98Math; Mix Shader Fac reaches23nodes/20Math, sharing the coordinate source. The remaining reachable nodes include3MixRGB nodes, a ColorRamp, Value bindings, Principled/Transparent BSDFs and Material Output.

**All9 per-sample DIVIDE denominators are nonzero stored constants:** approximately.255,.139,.172,.025,.031,.010,.014,.1002,.124. The only reachable variable division is uniform Math.151, `Math.120 / Math.124`. The second sqrt (Math.130) is also uniform. Thus a verified per-control-state preparation step can remove runtime variable divisions and one sqrt from the material pixel kernel. Constant reciprocal multiplication is approximate unless it reproduces the chosen reference division rounding; it requires its own error gate. One spatial sqrt remains in the blink boundary.

Left/right graphs have identical node type/property/socket/link structure; only3saved defaults differ (blink Xcenter±.285, blink tilt±.04, gaze Xcenter±.277144), plus side-specific driver expressions/targets. A single recipe template with distinct constant/control bindings is feasible, subject to structural/source hashes. See `eye-template-comparison.json`. Do not merge the per-eye bindings themselves.

## Coordinates and necessary attributes

Both Separate XYZ nodes actually read `Head-local eye coordinates.Object`, a Texture Coordinate node with `object=None`. Geometry is disconnected. Only X,Z outputs affect the reachable recipe. This is current object's **Object shading coordinate** semantics, not UV, Generated, camera or arbitrary world position. The label “Head-local” does not create a reference-object binding.

Current sclera objects have identity saved transforms and parent `Head Pivot • driven`; the recipe's original coordinate origin and object/parent relationship must be preserved through later transforms/LOD. An unrelated mesh-local origin chosen during quantization is not a valid substitute. Proposed sidecar carries signed32 local X,Z with declared units/basis/origin, initially Q20 for investigation, plus object/material/source-corner mappings. Preserve the source coordinate interpolation policy; re-meshing or perspective interpolation can move analytic features even when vertex colors match. The precision plan below is not approval to alter geometry.

Both amber iris objects have `Iris gradient`, POINT FLOAT_COLOR,960values each, no UV layer. LinearRGBA range is approximately R .048..235, G .0138..081, B .0024..020, A1; exact float32 hashes are in supplement. If these material/objects are included in a separately approved export, preserve POINT-domain values and topology/interpolation mapping; do not substitute one palette color. They are hidden in the saved render state, while visible sclera contains its own procedural iris/pupil/highlights. Do not add hidden iris geometry just to obtain a simpler material.

## Controls, time and geometry dependencies

Inventory tree drivers and `control-metadata.json` must accompany the recipe. Treat driver text as data to translate into an explicitly validated declarative parameter block, not executable script.

- Blink Both and per-side Blink±X feed `Blink driver=max(a,b)`. UI0..1 is advisory. Sclera object `hide_render` also has a separate `max(a,b)>=.98` driver; this is not the same as pixel transparency.
- Gaze X/Up set per-eye center offsets through asymmetric piecewise linear formulas. Gaze also controls shape keys on separate eye objects; do not assume shader uniform changes alone reproduce every object's geometry.
- Eye Style selects with strict thresholds .5 and1.5. Stored0 and preview1 are different material states, not noise. UI integer0..2 is not implicit runtime validation.
- Show Highlights is a distinct control; preserve its type/domain rather than unconditionally baking white spots.
- Environment Reflection drives Principled socket13, **Specular IOR Level**, not diffuse rho. The previous Lambert-only direct kernel does not implement this BSDF parameter.
- Bubble Pressure has two separate paths: Value.004 explicitly clamps p to[-1,1], while Value.005 uses raw p in the quartic `-0.003268858*p^4+0.000369206*p^3+0.011176145*p^2-0.04670431*p+0.944728911`. Do not replace both with the clamped value.
- Pressure action has BEZIER keys(1,0),(13,1),(25,0),(37,-1),(49,0), AUTO handles, unlimited CYCLES REPEAT before/after. UI[-1,1] is not a mathematical guarantee for arbitrary scripted assignments or other animation. Preserve handles, interpolation, time mapping and state hash. Frame/control preparation can remain high precision in a future design; per-pixel fixed-point does not require executing drivers on the device.

Analytical constant arithmetic, **conditional on validated raw p∈[-1,1]**, gives quartic derivative upper bound−.01016897, hence a decreasing positive range[.906301094,.998971302]. Math.124 denominator has conservative positive lower bound .55×.8×.906301094≈.39877248. Math.130 radicand A²+B²−AB is nonnegative algebraically; preserve rounding/domain behavior, do not reassociate without testing. Outside the validated p domain these bounds do not apply. `precision-budget.json` records this independent algebra; no Blender driver was evaluated.

## Numerical precision and PIE candidates

A minimum active feature radius is.01 coordinate units (Math.062), paired with.014 (Math.065). Coordinate half-step alone gives normalized uncertainty:

| Coordinate fractional bits | Half-step | Error divided by.01 |
|---|---:|---:|
|16|7.6294e−6|7.6294e−4|
|20|4.7684e−7|4.7684e−5|
|24|2.9802e−8|2.9802e−6|

These are not total errors: center/control/transform/interpolation/reciprocal/rounding uncertainty must be added. Q20 is a starting hypothesis, not a demonstrated acceptable image format. Absolute Z≈2.54 cannot fit a signed Q2.14 lane before recentering; retain32-bit Object coordinates, subtract uniform feature centers, then range-check and narrow normalized local values for16-bit lanes. Never silently clamp out-of-domain values merely to fit SIMD.

Squared ellipses, line predicates, multiplies/adds and binary comparisons are strong8×16-bit PIE candidates after bounded normalization. Source comparisons are strict `<`/`>`; quantizing near an edge may flip an entire mask. Interval/error margins should flag ambiguous decisions for a higher-precision path, not soften or widen masks without a new approved semantic change. The blink sqrt has unbounded derivative at the ellipse end, so a global linear error estimate is invalid there; test/preserve radicand clamps and near-tip cases separately.

Per-sample plan: stream feature subexpressions in SoA, reuse the shared X,Z values, evaluate masks/radius expressions, then ramp/mixes. Eight QR registers cannot retain all77Math values; compile liveness and stage reuse, not a register per node. Reciprocal constants/control blocks belong in prepared data.32-bit coordinate subtraction and potentially64-bit products/reductions remain outside straightforward16-bit SIMD. Integer sqrt remains a separate scalar or separately verified vector approximation. Operation counts are not a speed prediction.

## Ramp, mixes and transparency: primary-source correction

Official Blender4.3.2 source is pinned to commit `32f5fdce0a0a571a39198edf8d7b5d719bf59f2c`; tag→commit verified through GitHub. Read-only copies, original URLs and Git blob SHAs are in `primary-source/` and manifest. None were installed, compiled or executed.

The saved ramp is6-stop LINEAR/RGB (hue NEAR irrelevant to RGB), with positions0,.52,.57,.82,.95,.995 and exact stored float32 colors in supplement. **Cycles does not evaluate those six segments directly at every sample.** Shader sync samples the ColorRamp at i/256 into257RGBA values; SVM clamps factor, scales by256, takes the adjacent table entries and interpolates. A direct6-stop implementation differs near segment kinks. Preserve both original stop recipe and the target-specific257-entry preparation semantics. This is deterministic material data, not permission to run a shader bake.

Legacy MixRGB MIX always clamps its factor to[0,1] before `a+t*(b-a)`, even when `use_clamp=false`. That property controls output clamping, not factor clamping. All three saved nodes have result clamp false and alpha use false. Mix Shader likewise clamps its factor and distributes closure weights(1−f),f between Transparent and Principled; this is not simply multiplying diffuse RGB by alpha. Material has DITHERED surface method and transparent-shadow flag, while object hide-render is separate. Preserve these declarations; actual renderer transparency/coverage/shadow behavior remains unsupported.

See `PRIMARY_SEMANTICS.md` for exact paths/lines and remaining oracle limits.

## Minimal future material recipe contract

1. Latest .blend hash, object/material IDs, graph/template hash, exact source node/socket IDs, output roots, dead-node inventory and source version.
2. Object-coordinate X,Z stream or exact reconstructible object-space mapping, units/origin/basis, source-corner topology mapping, interpolation contract; normals/geometry remain separate scene attributes.
3. Optional named POINT linearRGBA streams for included iris materials, with domain/count/hash and mapping. No mandatory UV attribute is implied by this graph.
4. Exact float32 constant pool and per-eye overrides; active graph/control DAG; six ramp stops plus pinned257-entry Cycles preparation recipe; MixRGB/clamp flags and BSDF parameters.
5. Explicit control tuple, valid ranges/types, raw-vs-clamped distinction, per-eye binding, timing/animation metadata and prepared-state hash. Invalid/out-of-domain tuples reject rather than silently clamp beyond what the source graph clamps.
6. Separate outputs: base linear color, closure-mix factor/transparency declarations, and BSDF parameters such as roughness .22, IOR1.5 and driven Specular IOR Level. No “constant albedo only” fallback presented as faithful.
7. Declared arithmetic scales, bounds, rounding, constant-reciprocal precision, threshold ambiguity/fallback and source-semantic version.

Current AYFQv1 constant RGB/rho+geometry format cannot preserve this. A new version/sidecar material recipe is required. The contract was sent to the projection/source worker and root fit worker; it does not authorize export/integration.

## Remaining implementation/oracle boundary

Primary source now establishes operation-level behavior for this finite scalar subset, MixRGB and ramp preparation. It does **not** establish a bit-identical shader/image oracle across Cycles optimizations, CPU/GPU FMA/denorm behavior, evaluated Object coordinate/geometry, drivers, closure BSDF, lighting and alpha transport. A future independent test can explicitly declare a pinned float32 source-operation interpreter and compare fixed BaseColor/Fac/parameter outputs for validated coordinate/control tuples; that would be a numerical model, not Blender render parity. No broad compiler/runtime or such prototype was started in this task.

An appropriate next fixture would span feature centers/ellipse boundaries, sqrt tips, ramp knots and257-table cells, strict style/blink thresholds, pressure endpoints, and invalid control cases, with threshold-change counts alongside numeric error. Do not substitute the older model's captures or silently use unevaluated defaults as latest animation truth.
