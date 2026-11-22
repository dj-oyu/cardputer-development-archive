# Hair v13: selectively painted core shadow

Fixed v12 geometry and expression rig. The two major bangs and rear cap alone change: broad light face → tapered dark core on the shadow side of the turn → broad, slightly cooler, higher-value reflected shadow. The band fades at its ends and is not applied to the small pieces or silhouette. The dark and light are albedo paint.

Three revised maps are packed in the editable Blender model; four smaller hair maps and all face maps retain their exact bytes. Both variants use the same geometry and reflected colors. The control disables only the narrow core, and can be regenerated locally:

```sh
blender -b --python-exit-code 1 --python hair_core.py -- human-hair-12.blend human-hair-core-13.blend core
blender -b --python-exit-code 1 --python hair_core.py -- human-hair-12.blend human-hair-control-13.blend control
blender -b --python-exit-code 1 --python verify_core.py -- human-hair-12.blend human-hair-core-13.blend
blender -b --python-exit-code 1 --python preview_hair.py -- human-hair-core-13.blend core
blender -b --python-exit-code 1 --python preview_hair.py -- human-hair-control-13.blend control
python compare_core.py
```

`rgb565-proof.json` reports head-crop pixel deltas on undithered 240×135 Blender renders converted to RGB565. This confirms the painted difference survives the quantization in these views; it does not establish firmware compatibility, LCD color or FPS.
