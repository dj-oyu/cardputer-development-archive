# Latest fox: read-only source audit and conversion feasibility

## Identity correction

This audit concerns **fox-bubble-bold.blend**,24,187,852 bytes, SHA256 `d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a`. Both the freshly retrieved read-only copy and approved private-save copy matched this hash before and after inspection. Earlier AYFQ Q16/Q20/source-light results concern the older standing/lid8 fixture only. They remain arithmetic experiments; none establishes appearance, conversion fidelity or speed for this latest source.

Existing preview provenance is in `ayatsuri-model-version-audit-20261105/REPORT.md`. `bold-still-01.png` SHA256 `fff05e2253f1a1d795f98923958fbc29c3d89e2ce3fb7c75ed38277e5098952b` is tied to this source path by script/log/save receipt, not by a contemporaneous historical input-SHA manifest. It is a face-close preview with Eye Style1, Brow Style1, highlights1, environment eye reflection0 at frame1. The saved source has Eye Style0, Brow Style0, highlights1 and reflection0.5. **That preview is not a neutral full-body or identical-control-state parity reference.** No new image or export was generated.

## Inspection method

Installed Blender4.3.2 was invoked with `--background --factory-startup --disable-autoexec` and new explicit data-only scripts. Autoexec remained false; Blender reported no autoexec failure. Scripts only read datablocks, socket defaults, graph links, raw flags, modifiers and driver descriptions. No embedded text/build.py or driver expression was executed by these scripts. No frame_set, evaluated_get, depsgraph update, render, bake, triangulation/export, source save, ray or BVH call was made. Opening Blender necessarily loads its data; the audit makes no claim that cached raw values constitute an independently evaluated pose.

Inventory artifacts:
- `inventory.json`: scene, all objects, materials and complete node socket/default/link/driver descriptions.
- `supplement.json`: color-ramp entries, named iris attributes and bounds/hashes, curve tessellation settings and shrinkwrap targets.
- `visibility-flags.json`: raw object/collection/view-layer flags, explicitly not queried/evaluated visibility.
- `SUMMARY.json`: source pins, counts, current controls and cap distinctions.

## Raw source inventory, NOT final-frame complexity

There are125 object datablocks:104 meshes,13 curves,3 empties,3 lights,1 armature and1 camera. Across all base meshes there are186,976 vertices and371,632 fan-triangle equivalents (`sum(face_corner_count-2)`, not evaluated triangulation). Raw hide_render=false selects74 meshes with164,772 base vertices and328,128 fan triangles;30 mesh objects have hide_render=true. These flags can be driven, and neither subset is claimed to be the actual rendered mesh set.

There are14 objects with raw hide_viewport=true. Three datablock collections have both hide_render and hide_viewport false: Collection(35 direct objects), FOX editable mesh parts(70), SOURCE unmerged anatomy hidden(16). Direct collection counts do not sum to all objects; use the raw membership/view-layer inventory, not collection names, to infer anything. No evaluated visibility or collection traversal queries were run.

Modifiers:48 SUBSURF instances at viewport/render level2,2 SHRINKWRAP instances on the surface brows,1 ARMATURE on the continuous nape/shoulder sculpt. The sculpt alone has123,602 base vertices/247,200 fan triangles; the cream throat bib has23,042/46,080. Subdivision and curve conversion would change these counts; no evaluated count is available.

The armature has HeadDeform and TorsoAnchor.22 mesh objects have112 non-Basis shape keys covering gaze, brow, eyelid and smile changes.160 SCRIPTED driver descriptions were inventoried:112 shape-key channels,20 object channels and28 material-node channels. There is one action: Expression ControlsAction, Bubble Pressure,5 keys, frame range1..49 with CYCLES modifier. Driver expressions were recorded as data, not invoked.

The scene is saved at frame1; scene range1..250,24fps,1000×1000 Cycles, AgX Medium High Contrast. Portrait camera is orthographic with stored ortho_scale4.800000190734863. There are no linked libraries or external image textures; the sole image datablock is Render Result/VIEWER. Lack of external textures does **not** imply simple materials.

### Separate existing capacity limits

- Current AYFQ experiment:≤256 parts,≤32 vertices/part,≤64 triangles/part. Thus≤8192 partition vertices and≤16,384 triangles total. This is a format/decoder admission limit.
- Existing full-renderer harness: visibility scene limits include2048 triangles,4095 nodes,524288 bytes, explicitly passed in `fox-v3-indexed-bvh-bounds/harness/native_render_row.c:172`. This is a separate downstream scene admission limit.

Neither limit was changed. The raw base source exceeds both, even before modifier/curve evaluation. This is not justification to silently discard hidden-looking objects, decimate geometry, raise bounds or change a visibility API. A separately approved LOD/representation design is required.

## Concrete material requirements

There are21 materials.14 Blink mask materials include Transparent BSDF/Mix Shader and object-coordinate mathematical masks. The two sclera materials each have188 nodes, including169 Math nodes,7 driven/value nodes,3 MixRGB nodes,2 SeparateXYZ nodes, a6-stop LINEAR RGB ColorRamp, Principled, Transparent and Mix Shader nodes. `Principled BSDF.Base Color` is linked to the procedural network: its stored white default is **not** its appearance.

The active coordinate input is `Head-local eye coordinates`, TexCoord.Object with object=None, linked to SeparateXYZ. It is object-local shader coordinate data, not UV. Geometry nodes present in these trees are unconnected; their mere presence is not an additional live dependency. World-baked positions alone would lose the coordinate frame unless a local-coordinate varying or original-object mapping is retained.

The eye graph drives blink, gaze offsets, Eye Style, Show Highlights, Environment Reflection and Bubble Pressure. Bubble Pressure also drives a quartic compensation coefficient. Graph math includes add/subtract/multiply/divide, sqrt, min/max and threshold comparisons. The newly accepted thick seam and bubble overlap are encoded in this graph, not in a constant material RGB. A separate material numerical-plan worker now has the full dump; no material execution or translation was attempted here.

Each iris uses ShaderNodeVertexColor with layer_name `Iris gradient`: POINT/FLOAT_COLOR,960 values per iris, matching data SHA256 `2f1af73cb5ac4c64dfc09c8e61c700b2e0c513b3ff7896b26c5d7d444e134e8c`. Linear RGB ranges are approximatelyR0.048..0.235,G0.0138..0.081,B0.0024..0.02,alpha1. AYFQ v1 has per-part material RGB but no vertex-color stream, so it cannot preserve this gradient. Existing signed16 varying interpolation arithmetic can be reused only after a versioned source attribute extension.

24 base meshes have UVMap CORNER/FLOAT2;80 do not. Preserving existing UVs is distinct from procedural-eye support: these eye shaders currently use local Object coordinates. A future texture-bake route would require an explicit UV/address/filter/alpha/color-space contract, but no bake is authorized or performed.

Even the7 simple two-node materials use Principled BSDF rather than the integer experiment's Lambert-only material model. Examples: coat roughness0.65/specular IOR level0.5; sclera roughness0.22 and driven specular; iris roughness0.23/specular0.25/coat0.1. Copying base RGB while discarding these terms would be a material approximation, not appearance preservation. Some updated simple source colors also differ from the old fixture, such as coat0.62/0.12/0.014 and ivory0.96/0.83/0.63.

## Preserve / unsupported / preparation matrix

| Feature | Current AYFQ position/normal/constantRGB path | Required preservation path; nothing silently dropped |
|---|---|---|
| Mesh positions/normals | Representable only after static evaluation, partition/range checks; exceeds count caps | New source-bound LOD/representation decision; retain source and topology/provenance mapping |
|13 bevelled curves | No curve primitive | Authorized explicit tessellation with bevel/resolution/material preservation; currently not performed |
|48 subdivisions | Base mesh is not render geometry | Freeze intended render level and evaluate under a separately authorized workflow; do not assume base mesh parity |
|2 brow shrinkwraps | No equivalent primitive | Preserve target and0.0025 offset; evaluation can perform surface queries, so **do not run it under the current no-query scope** |
|Rig,112 shapes,160 drivers | No joints/morphs/control evaluator | Choose explicitly frozen state or versioned morph/rig/control data; never run arbitrary driver scripts or discard expression support silently |
|Iris POINT colors | Unsupported storage despite available interpolation kernel | Versioned linear signed16 color stream, domain/split mapping and exact interpolation contract |
|Object-local eye coordinates | Absent after world baking | Preserve local varying/object mapping, original transforms and coordinate precision |
|Procedural sclera/bubble seam | Unsupported | Audited bounded material IR/analytic shader, or separately authorized bake route with explicit error/parameter limitations |
|Blink transparency/masks | No opacity/material-mask semantics | Versioned alpha/cutout/coverage semantics; cannot implement by constant color, and no visibility API changes are authorized here |
|Eye controls/animated pressure | No runtime parameter/state representation | Manifest controls and audited deterministic mapping; preserve animation only with a versioned evaluator, otherwise explicitly state frozen-only |
|Principled roughness/specular/coat | Lambert-only mismatch | Supported shading extension or explicitly approved approximation; not silently removed |
|Existing UVs | Absent in AYFQ v1 | Preserve CORNER mapping if required by chosen material path; UV alone does not reproduce local-coordinate shaders |
|Camera/lighting/color management | Old fixture's setup is not this model's state | Bind exact camera matrix/ortho/resolution, light/world graph and AgX settings to the new source/state manifest |

A raw GLB export is not proof that Blender's procedural nodes, transparency, rig drivers, expression controls or Cycles shading survived. GLB may carry some meshes/UVs/colors/morphs/PBR parameters, but this existing strict fixed-input/AYFQ path does not thereby support them. An importer must reject unsupported source features, not label a default-white eyed model as the latest source.

## Proposed frozen-static extraction contract, NOT executed

1. Bind source SHA and explicitly select one state. Candidate A is the saved frame1 state: Blink Both/-X/+X0, Smile0, Brow Raise/Furrow/side raises0, Gaze X/Up0, Head Turn/Tilt0, Brow Style0, Eye Style0, Show Highlights1, Environment Reflection0.5, Bubble Pressure0; use the stored Portrait camera matrix and1000×1000/ortho_scale. Candidate B is the accepted face-preview preset; it differs in controls and camera and must be separately recorded from its existing script/log. Do not mix A geometry/material state with B reference imagery.
2. Create a **new versioned snapshot manifest** recording original objects, source controls, shape weights, rig pose, all modifier settings, material DAG hashes, attribute mappings, curve settings, render/camera/light/color settings and source SHA. Raw defaults here are inventory, not a proof that all driven evaluated outputs match the chosen state.
3. Require a separately reviewed static-evaluation plan. Use explicitly audited control resolution rather than executing embedded scripts; preserve curves, modifiers, shapes and normals. Current no-query/no-evaluation scope blocks actually evaluating shrinkwrap or making a new evaluated snapshot. Do not use Blender evaluation as an alternate route around denied ray/visibility operations.
4. Resolve material representation **before** committing a geometry-only export. For appearance-preserving procedural eyes, carry local coordinates, varying iris RGB, explicit masks and chosen control parameters using a versioned material contract. A fixed-state bake, if later authorized, would preserve only that state/appearance model and must not be advertised as dynamic expression support.
5. Decide how to meet both count/resource caps without silently altering the model: source-bound LOD with explicit acceptance criteria or a separately approved representation redesign. No reduction/export is performed by this audit.
6. Only after source/state/material/geometry fidelity is established should a comparison be requested under a newly authorized scope. Record input SHA, all state/preset settings and output manifest contemporaneously. Old fixture images must not be reused as proof.

The immediate safe output is this inventory and precise unsupported-feature matrix. A faithful latest-model AYFQ asset cannot currently be produced with the existing v1 fields/caps. That is a representational blocker, not evidence that fixed-point arithmetic itself fails.
