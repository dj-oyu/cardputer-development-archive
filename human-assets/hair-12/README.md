# Hair v12: temple flicks and chestnut value masses

Based on the exact expression v11 model. The two existing side pieces reuse the tapered cross-sections of the crown tuft, set on descending temple curves. The visible cheek ends taper rather than forming a square tip. The seven existing hair parts now use three broad painted warm-brown values each; the back has a diagonal S-edged light sweep over a dominant midtone and dark underside. The dark and light are albedo paint, not a recreated reference illustration or scene shadow.

The `.blend` packs all seven production-color maps and the existing face maps. Rebuilding `hair_value.py` writes the seven hair-only 128×128 texture files, which can also be packed into an atlas later. No Cardputer export or device performance claim is made. Private matched renders were checked at front, 35° and rear, with separate native 240×135 Blender renders.

```sh
blender -b --python-exit-code 1 --python hair_value.py -- human-expressions-11.blend human-hair-12.blend
blender -b --python-exit-code 1 --python verify_hair.py -- human-expressions-11.blend human-hair-12.blend
```
