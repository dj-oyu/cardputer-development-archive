# PVC-style hair study

This editable prototype is derived from the packed face texture study. Hair uses seven sculpted pieces rather than 20, with larger asymmetrical bangs and a single reshaped rear cap. Raised silhouette and exterior contour remain geometry; diagonal tapered groupings are editable UV albedo, without added strand geometry or baked scene shadows. The renderer evaluated 2,148 → 928 hair triangles (-1,220 / -56.8%). All 65 non-hair meshes, 20 bones, the existing action keys and the packed face texture passed reopen comparison. The 240×135 previews are Blender renders, not firmware or device performance results.

## Rebuild

Run Blender 4.3 headlessly with the blank or mapped human face texture model:

```sh
blender -b --python-exit-code 1 --python hair_pvc.py -- human-face-texture-08.blend human-pvc-hair-09.blend
blender -b --python-exit-code 1 --python verify_hair.py -- human-face-texture-08.blend human-pvc-hair-09.blend
```

The seven procedural paint images are packed in the output .blend; matching standalone PNGs are generated in `flow_textures/` for editing, baking, or packing into an atlas. Firmware export and texture-memory costs have not been tested. Do not treat close-up/240×135 comparison images as production assets.
