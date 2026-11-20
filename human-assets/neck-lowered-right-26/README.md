# Human character v26: selected shorter neck

This is the exact RIGHT study (lowered.blend), selected for its proportions. The head is lowered 0.085 Blender units along the connected neck axis; neck bone length is 0.50214 → 0.41677. Face geometry, visible hair/ears, packed texture assets, UVs, weights and animation keys are retained. Clothing and the body meshes are unchanged.

In Blender, this pose choice trades collar clearance for proportions: jaw/garment overlap pairs were 0 → 44 across the 30 authored animation frames; hair/garment were 30 → 91. The six forced turns show up to 52 jaw/garment and 165 hair/garment pairs. These are collision pair counts, not a measure of visible area or firmware performance.

Rebuild from exact v25 smooth.blend and verify in Blender:
    blender -b -t 2 --python-exit-code 2 --python lower.py -- /path/to/v25/smooth.blend lowered.blend .085
    blender -b -t 2 --python-exit-code 2 --python verify_rigid.py -- /path/to/v25/smooth.blend lowered.blend
    blender -b -t 2 --python-exit-code 2 --python check_neck.py -- /path/to/v25/smooth.blend lowered.blend lowered-clearance.json
