# Settled fringe roots (v23)

Base: `human-sideburn-anterior-22.blend` SHA-256 `6b9bb4fe2c05bbeb49aca31fc6735aff7256b4999b04a1e7957bebc2433e2021`.
Output: `human-fringe-settled-23.blend` SHA-256 `4c0432313c0363bba3885d44dcfcde6038986dacfa7a5f20cee77577969d33e9`.

Tuck the roots of the two upper face-framing locks into the crown and blend normals near their contact with the cap. The six hair objects stay separately editable; lower lock geometry, original sideburns, cap, ears, face, rig and packed textures stay as authored. The middle/lower separation remains intentionally. The triangle count is unchanged.

```sh
blender -b -P settle_fringe.py -- BASE.blend OUTPUT.blend
blender -b -P verify_structure.py -- BASE.blend OUTPUT.blend
blender -b -P verify_visibility.py -- BASE.blend OUTPUT.blend fringe-visibility.json
```

`preview_fringe.py -- MODEL.blend DESTINATION` renders matched close/native views. Put the base renders in `before` and v23 renders in `pick` to run `compare_fringe.py`. Previews are not production source files. Native review is a 240×135 Blender render inspected with RGB565 quantization, not firmware or device testing.
