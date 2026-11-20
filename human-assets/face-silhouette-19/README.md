# Human character v19 — rounded lower face

This editable Blender authoring candidate re-shapes the lower cheek, jaw and chin of the exact v18 source. The 26 changed vertices are localized to two front-lower head rings. The eye-height ring, neck-contact ring, back of the skull, hair, body, shoulder patch, and animation are unchanged. Facial overlay UVs and the four packed images are unmodified. The rounded version is selected over a gentler trial.

Head geometry remains manifold. Both releases have 6,701 base-mesh triangles and 7,061 dependency-graph evaluated triangles across the same 70 rig-bound Blender meshes (modifiers evaluated at frame 1; neither number is a firmware/export count). Blender camera tests cover fixed front, oblique, profile and native 240×135, plus three distinct head rotation checks. Existing lower-head/collar seam was not modified. No device test.

Rebuild and verify with Blender 4.3.2:
```sh
blender -b -t 2 --python-exit-code 2 --python shape.py -- /path/to/human-hidden-trim-18.blend human-face-round-19.blend 1.35
blender -b -t 2 --python-exit-code 2 --python verify.py -- /path/to/human-hidden-trim-18.blend human-face-round-19.blend
```
