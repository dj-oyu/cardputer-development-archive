# Human character v18: hidden-surface reduction

Editable Blender source based on the verified six-part hair and contact shading in v17. The head and jacket are not joined. The rear skull is reduced only inside the co-skinned, closed bob geometry; the replacement remains closed. Portions of each fringe's underside are flattened, retaining the visible arcs and extreme-angle coverage.

- Fringes: 136 → 124 triangles each. Total hair: 940 → 916.
- Cranium: 316 → 286 evaluated triangles.
- Non-target meshes, animation, 20 bones, expression controls and 4 packed facial textures retained.
- The v17 base is in the sibling `hair-17` directory. Open `human-hidden-trim-18.blend` directly for the current editable source. The JSON files document the component and combined Blender checks; not hardware or firmware verification.

Rebuild with Blender 4.3.2 from the v17 base:
```sh
blender -b -t 2 --python-exit-code 2 --python trim_rear_skull.py -- ../hair-17/human-hair-six-detail-17.blend /tmp/human-skull-trim.blend
FLAT_RINGS=056 FLAT_COLS=78 blender -b -t 2 --python-exit-code 2 --python flatten_protected.py -- /tmp/human-skull-trim.blend /tmp/human-hidden-trim.blend
```
