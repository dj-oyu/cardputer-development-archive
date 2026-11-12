# Model-version correction and scope of prior measurements

2026-11-05: the displayed fixed-point comparison used an older validation model, not the user's latest approved fox. The latest approved model must be the source for future appearance comparisons. Prior frozen measurements are retained as historical-fixture evidence and must not be presented as results on the latest fox.

## Latest approved source

- Name: fox-bubble-bold.blend, the thick-boundary eye version.
- SHA256: d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a.
- Bytes: 24,187,852.
- Official retrieved file: latest-fox-source-readonly/fox-bubble-bold.blend.
- Existing private copy: fox-bubble-bold-private/fox-bubble-bold.blend; exact bytes/hash match.
- Private Space identity: libfile_4dee400f3a7c819184d5fcc2a4953de9, version0.
- Existing approved-version close-up: fox-bubble-bold-private/bold-still-01.png, SHA256 fff05e2253f1a1d795f98923958fbc29c3d89e2ce3fb7c75ed38277e5098952b, Space libfile_f2cc687bbd148191ab8392cf8450ef16.
- Preview evidence: still.py and still.log name this .blend and output image. No historical render-input hash manifest was recorded, so this is path/log evidence plus current source equality, not a claim of a historical SHA-bound rendering. The original scene is read-only.

## Historical fixture actually used

- Source GLB: fox-v3-floor-direct-reflection-evaluation/actual-002/inputs/geometry-source-sided.glb.
- GLB SHA256: 833ac7683872375f9e63f819618e0e25ed40e0ac761a35f7604cd45501207a8e; identical to the older lid-8 GLB used in upper-eyelid LOD tests.
- Native model: same actual-002/compiled/model-baseline/model.aynm.
- Native SHA256: 68985ce128275a4b50c9bbad791bcd9eff8a41e788e4b5672d65c80755aade9f.
- Counts: 1,163 partition vertices, 1,564 triangles,54 mesh packets.
- Inherited candidate config names new-candidate-v3-rebuilt-4a4d and states the earlier1200-budget reduced-mesh lineage. That config string is not proof of the current approved model.

The Q16 four-pixel difference, Q20 exact RGB565 result, 7,678 saved-hit lighting/direction tests,1,746 admitted AA pixels and primary-ray trace all concern this old fixture. They demonstrate arithmetic/provenance properties within their recorded domains; none certifies the latest model's appearance, controls, geometry budget or shader support.

## Required next comparison boundary

The new model has104 meshes, deformation/anchor structure, expression/gaze shape keys and a procedural eye-decal shader. A standard GLB or current AYFQ export does not automatically preserve those features. Inventory and an explicit preserve/bake/unsupported matrix must precede conversion. No expression, shader, mesh or control may be silently omitted and then called a matching conversion.

Future image results must state the exact source hash, static frame/control values, camera/light configuration and any deliberately unsupported features. Confirm the reference depicts the approved thick-boundary fox before numerical comparisons. Keep old and new fixtures in separate datasets and do not overwrite frozen historical evidence.
