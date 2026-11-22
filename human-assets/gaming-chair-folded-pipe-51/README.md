# Continuous virtual intake tube

`human-chair-pipe-51.blend` has two editable scenes: the original seated chair with the two obsolete intake cards disabled, and an isolated virtual engine volume containing one round swept hose and both solid receiver fittings. The physical shell, pose, rig, and usable physical geometry are unchanged. The standalone virtual scene is a baking source, not a low-poly runtime asset. Its geometry is deliberately absent from the physical scene; default physical-scene render does not composite the tube.

The hose is a closed continuous sweep. Its left and right tips recede to 0.78 and 0.75 Blender units from aperture, vs .145 at the forward span. Both penetrate their receiver bodies. Matched rear views (0°, ±35°) render the true source with self-occlusion, then clip through the actual chair aperture. This preserves occlusion instead of duplicating the pipe in shallow image strips.

## Reproduce selected rear bakes (Blender and Python/Pillow)

1. `blender -b -t 4 --python-exit-code 1 --python pipe.py` to create the virtual scene and its transparent 240×135 tube pixels.
2. `blender -b ../chair-nine-50/human-chair-nine-50.blend -t 4 --python-exit-code 1 --python bake_aperture.py` for 240×135 physical aperture alpha. The v50 bake package provides base and unaffected strata.
3. `python compose.py` to install the clipped tube in the eighth draw slot, leave the obsolete sixth slot empty, and produce an offline RGBA reference. `full.png` is a composited reference, not a monolithic Blender render.
4. `blender -b ../chair-nine-50/human-chair-nine-50.blend -t 3 --python-exit-code 1 --python assemble.py -- human-chair-pipe-51.blend` to assemble the editable two-scene file. Native selected projection assets are in the Blender image browser under `v51 proof`.

`technical.py` renders the overhead design view from the same isolated tube. None of these renders is a Cardputer device test. A runtime frame uses angle-specific bakes through the normal Kasane path; the virtual mesh is not sent to the device.
