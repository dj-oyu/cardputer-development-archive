# Human character v26: shorter neck trial

The tiny.blend candidate lowers the connected head joint and whole head package by 0.020 Blender units along the existing neck axis. The neck deforms continuously toward the unchanged torso attachment. Hair, expressions, cheeks and ears retain their relative positions; clothing, body, face UV, packed art and original animation curves are unchanged.

The sampled 30 authored frames remain free of new chin/garment intersections at this setting. Separate unkeyed forced head-rotation stress views increase collision pairs near the raised collar, so this is not a universal clearance guarantee. The stronger study increased contacts in the existing animation and is not included.

Rebuild and check from the exact v25 source:
    blender -b -t 2 --python-exit-code 2 --python lower.py -- /path/to/v25/smooth.blend tiny.blend .020
    blender -b -t 2 --python-exit-code 2 --python verify_rigid.py -- /path/to/v25/smooth.blend tiny.blend
    blender -b -t 2 --python-exit-code 2 --python check_neck.py -- /path/to/v25/smooth.blend tiny.blend clearance.json
