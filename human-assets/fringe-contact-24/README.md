# Fringe belly contact (v24)

From approved v22, retain the roots and tips and bring only the inner middle of both bangs into contact with the existing bob. The middle skin-colored opening is covered without blending the bangs into the crown. The six hair pieces remain separately editable.

- `contact.blend`: body contact only; 916 hair triangles.
- `contact-reduced.blend`: accepted geometry plus the conservative closed backside reduction; 912 hair triangles and 7,057 evaluated rig-bound triangles.
- `contact-reduced.json`: old and replacement faces are entirely inside the closed, head-rigid bob; both edge collapses retain closed meshes.
- `pinned-structure.json`, `verified-structure.json`, `contact-visibility.json`, `reduced-layers.json`: reopen and coverage gates. The two root and two tip rings are coordinate-identical to v22, and the buried reduction did not change visible object ownership in any of ten sampled views.

```sh
blender -b -P contact.py -- BASE.blend contact.blend
blender -b -P reduce.py -- contact.blend contact-reduced.blend
blender -b -P verify_pins.py -- BASE.blend contact.blend contact-reduced.blend pinned-structure.json
blender -b -P verify_structure.py -- BASE.blend contact-reduced.blend
blender -b -P verify_visibility.py -- BASE.blend contact-reduced.blend contact-visibility.json
blender -b -P verify_layers.py -- contact.blend contact-reduced.blend reduced-layers.json
```

`preview_fringe.py` and `compare.py` regenerate local comparison renders. The 240×135 RGB565 comparison is a Blender preview, not a hardware test. Rendered comparison images are not production sources.
