# Human character v21: short locks emerging by the ears

Editable follow-up to `profile-sideburn-20`. Only the two temple locks change. The upper root rings sit inside the existing rear cap; sampled front, profile and three-quarter views show the tapered lower ends but no exposed roots. The v20 jaw, ears, fringe, bob, animation, UVs and rig are unchanged. There are six hair parts and 916 hair triangles, unchanged. Blender evidence only; no Cardputer runtime claim.

Rebuild in Blender 4.3.2:

```sh
blender -b -t 2 --python-exit-code 2 --python seam_flick.py -- ../profile-sideburn-20/human-profile-sideburn-20.blend human-sideburn-seam-21.blend
blender -b -t 2 --python-exit-code 2 --python verify_flick.py -- ../profile-sideburn-20/human-profile-sideburn-20.blend human-sideburn-seam-21.blend
```
