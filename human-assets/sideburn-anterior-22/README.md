# Anterior temple flicks (v22)

Source: v21 `human-sideburn-seam-21.blend` (SHA-256 `19691a0c795a78a350d853a8285dabc5eb512a5f2aa076f1298510ea3f025229`).
Output: `human-sideburn-anterior-22.blend` (SHA-256 `6b9bb4fe2c05bbeb49aca31fc6735aff7256b4999b04a1e7957bebc2433e2021`).

Move the two tapered temple tips to the face side of both ears, rooted under the adjacent bangs, not the rear cap. Alter only the positions of the original sideburn vertices. Existing frontal hair, bob and ear geometry remain as authored.

```sh
blender -b -P seam_flick.py -- BASE.blend OUTPUT.blend
blender -b -P verify_flick.py -- BASE.blend OUTPUT.blend
blender -b -P visibility_flick.py -- BASE.blend OUTPUT.blend visibility.json
```

Use `preview_flick.py -- MODEL.blend DESTINATION` with destination folders `before` and `after` for the optional local preview, then `compare_flick.py` for the comparison. Rendered previews are not production sources. The native view is a 240×135 Blender render with RGB565 quantization for review, not firmware or a device measurement.
