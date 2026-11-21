# Gaming-chair engine bay: foreground / valve cover / radiator

The same human rig, pose, chair shape, and physical aperture from v48, with stronger visual depth cues inside the rear opening. A close cloth-wrapped elbow and copper headers occlude the silver valve cover, with framed radiator fins behind them and an auxiliary radiator on the virtual sidewall for oblique views. Surface intersections are shading-only: near .10 BU; middle .60 BU; far radiator 1.04 BU; bulkhead 2.85 BU. Physical rear shell remains .22 BU.

- `human-chair-portal-49.blend`: editable scene with the v49 texture atlases and inherited bulkhead packed.
- `build_layers.py`: rebuild on top of the v48 .blend. Requires textures/engine-crossing.png, engine-block.png, and engine-radiator.png (these are authored texture inputs, also packed in the scene).
- `verify.py`: verify evaluated geometry, pose, UVs, and weights against v48.
- Same 1,913 character triangles + 370 chair triangles = 2,283 triangles. Compare rear 0° and ±35° in Blender at 240×135. This is not a Cardputer simulator result or hardware timing.
- The runtime mesh importer is not a UV/alpha/portal shader implementation. An angle-indexed Kasane overlay or a dedicated textured path is still needed for Cardputer.
