# Child’s room and beach

Two editable Blender backdrops rendered with Cycles, at 240×135, RGB, with no character or transparent pixels. Each backdrop is static. The warm room has real furniture, toy geometry, a lighting volume, and geometric rays and shadows. The beach uses geometric surf, a textured reflective ocean and a scattering horizon. Nothing is evaluated in 3D on Cardputer.

Open `room.blend` or `beach.blend` and render frame 1. To recreate the scene procedurally from scratch in Blender, use `blender -b --python-exit-code 1 --python build.py -- room` (or replace `room` with `beach`). Append `--draft` for a fast preview.
