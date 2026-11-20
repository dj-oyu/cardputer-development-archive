# Human character: depth and profile study 03

This is an editable authoring checkpoint based on the sibling joint test, not a Cardputer runtime asset. Refines the temple strands around the nearer eye, cheek-to-nose transitions, shirt and shorts depth, and toe profile. Existing bone locations, vertex groups and authored pose track are unchanged. Keeps the authored neutral stance rather than distorting legs to match the concept's posed three-quarter view.

From this directory:

```sh
blender -b -t 4 --python-exit-code 2 --python ./adjust_depth.py -- ../joint-test-01/human-joints-provisional.blend ./rebuild/human-depth-03.blend
blender -b -t 4 --python-exit-code 2 --python ./verify_depth.py -- ../joint-test-01/human-joints-provisional.blend ./rebuild/human-depth-03.blend
blender -b -t 4 --python-exit-code 2 --python ./pose_check.py -- --metrics-only ./human-depth-03.blend .
```

The 240×135 Blender checks are presentation-size proxies, not a simulator or hardware check. The 95° elbow probe still exposes sleeve distortion, and an isolated two-foot weight shift exposes extra local stretch in the shorts hem region. The pose checks are not walking animation, ground collision, or performance evidence. The source illustration is not a calibrated turnaround; no global silhouette-match improvement is claimed.
