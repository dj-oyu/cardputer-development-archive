# Human character v25: fuller lower cheeks
Editable authoring candidate. Compared with exact v24, three front-lateral head bands roll into a lower, wider cheek and broad chin; the underlying chin/neck contact, eye-height ring, decal UV, rig, expressions and hair are unchanged. No device test.

The chosen version is `smooth.blend`. Its lower cheek half-width (world |X|, Z 4.33–4.43) is 0.53754 rather than 0.42354; upper temple band stays 0.486. The intermediate and outer positions taper to avoid the earlier trial's far-cheek shelf at 35°. Per-model counts are unchanged: 6,697 raw and 7,057 Blender evaluated triangles across 70 rig-bound meshes, not a firmware export count. Neck overlap count is unchanged in the profile gate, and neither short temple curl has intersections with the head. Existing ear join overlap is not a new open seam.

Rebuild and independently verify:
```sh
blender -b -t 2 --python-exit-code 2 --python cheeks.py -- /path/to/contact-reduced.blend smooth.blend 1.0
blender -b -t 2 --python-exit-code 2 --python verify.py -- /path/to/contact-reduced.blend smooth.blend
```
