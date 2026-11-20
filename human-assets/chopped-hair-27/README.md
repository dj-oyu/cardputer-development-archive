# Faceted bob cut (v27)

Source: v26 `lowered.blend`, SHA-256 `45a1b182dfa99c78c9cebdd94775e739c8075d5f2de64e1bd2d973aa8a649404`.
Result: `human-hair-cut-27.blend`, SHA-256 `1f6fa35a6f18cb0962e61819045bb80a88f781fad878e878604c01ff648b92dd`.

The rear cap keeps its broad outline, with a shorter lower bevel and several broad facets instead of a rolled hem. Only the exposed bang crests change, with no welded pieces, geometry additions, added texture or halo. Six hair parts remain separately editable. The lower-neck revision's pre-existing collar contact remains; see the recorded before/after pose checks instead of treating the model as collision-free.

```sh
blender -b -P cut.py -- BASE.blend OUTPUT.blend
blender -b -P verify_structure.py -- BASE.blend OUTPUT.blend
blender -b -P verify_visibility.py -- BASE.blend OUTPUT.blend visibility.json
```

`preview.py -- MODEL.blend DESTINATION` renders local comparison frames. Use destinations `before` and `final` with `compare.py`. The RGB565 inset is a Blender preview at 240×135, not a firmware or hardware test.
