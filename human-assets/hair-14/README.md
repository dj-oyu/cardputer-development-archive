# Hair v14: slightly narrower mid-sides, full hem

The v13 paint, parting, ahoge, tapered temple locks and hem are preserved. Only X coordinates of 27 vertices on the structural back cap changed, with the displacement fading into the crown and hem. At one sampled middle height (Z 4.64 Blender units), hair width decreased 4.46% front/rear and 1.69% at 35° (cap alone: 4.03% oblique). At the two lower sampled heights width was exactly unchanged; the cut sides have no newly sampled reverse turn and overlapping temple joins have the same intersecting-triangle counts. Hair remains 908 evaluated triangles and seven parts. All eleven packed images, remaining 71 meshes and rig/pose data matched on reopening.

```sh
BASE=human-hair-core-13.blend
blender -b --python-exit-code 1 --python narrow_bob.py -- "$BASE" human-hair-14.blend
blender -b --python-exit-code 1 --python verify_trim.py -- "$BASE" human-hair-14.blend
blender -b --python-exit-code 1 --python preview_hair.py -- "$BASE" before
blender -b --python-exit-code 1 --python preview_hair.py -- human-hair-14.blend after
blender -b --python-exit-code 1 --python measure_outline.py -- "$BASE" before-projection.json
blender -b --python-exit-code 1 --python measure_outline.py -- human-hair-14.blend after-projection.json
python compare_outline.py
```

The 240×135 comparison is Blender output only. The 6/8/8 changing silhouette pixels are a no-material projected-mesh mask at front/35°/rear, not a hardware measurement.
