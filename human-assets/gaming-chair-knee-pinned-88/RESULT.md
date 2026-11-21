# v88: right knee anticipation with anchored right ankle

Source is the original, accepted v82 left ankle correction (SHA-256
`901316cf227cb6aac985dbd5f7986aa0bd3841f231a5c9cba94f03382d15f997`);
it does not include the v86/v87 translating-foot trials or the later facial work.

- The right knee travels 0.237 BU toward the character center, x = −0.337→−0.100 BU. It arrives by frame 12, before the left knee crosses the body center at frame 17 and settles at x = −0.105 BU. The knees are then stacked nearly directly above one another in lateral coordinates. The right shank is angled rather than moved wholesale.
- The right ankle is fixed in the analytical two-link solve. In the exported action the maximum evaluated positional change is 0.000093 BU (Euler interpolation between keys), and at the hold it is below 0.000004 BU. There is no foot-placement step. The boot rotates in place by 16.0° overall, of which only 1° is world yaw input; the right shin-to-sole-plane angle is 78.29°. The sole rocks toward the floor; the lowest evaluated sample is z=0.00107 BU above the actual z=0 preview floor.
- The lifted left ankle retains its existing internal boot articulation and 78.00° hold. Its local shin-to-foot rotation is unchanged through the 193 tested samples to numerical precision. Bone lengths and raw mesh coordinates, topology, UVs, weights, chair and camera are unchanged. A subtle pelvis accommodation is permitted to clear the right thigh from the seat (2.14° roll, about 0.028 BU along the seat, and about 0.001 BU vertically). Blender's rig transmits a slight positional motion to the upper body (around 0.034 BU); the chair does not move.
- Fresh reopen and evaluation of all 193 quarter-frame samples finds zero intersections for the animated leg/boot meshes against the opposite leg, arms/sleeves and chair, and no floor penetration. Separately, the already contacting waist fabric and cushion acquire up to 9 extra triangle pairs. At frames 6, 25 and 44 the new intersection points are all on the top cushion fabric (z=1.493), not the seat rim; the points are all occluded in the oblique and side camera positions, and entirely occluded from all three views on the hold. Some front-facing points at approach/release are at the visible cloth–seat contact itself, but no protrusion is seen in the rendered crop. These are not zero total scene overlaps.
- Opening and closing front renders are pixel-identical to the v82 source at the same 240×135 review camera settings. The source and its editable active action are 49 frames at 10 fps. This is Blender geometry and rendering, not Cardputer execution.

## Reproduce

Run from the archive directory, passing the exact v82 input:
```sh
MODE=save PARAM="$(cat params.txt)" NAME=chair-knee-ankle-pinned-v88.blend \
  blender -b /path/to/v82.blend -t 2 --python-exit-code 1 --python anticipate88.py
V82=/path/to/v82.blend blender -b chair-knee-ankle-pinned-v88.blend -t 2 \
  --python-exit-code 1 --python verify88.py
```
`render88.py` only generates review files and does not modify the saved source.
