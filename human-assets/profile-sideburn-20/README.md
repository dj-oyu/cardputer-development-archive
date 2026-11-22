# Human character v20: ear-length sideburns and side profile

Editable follow-up to face-silhouette-19. The two temple locks remain separate with their roots intact, but their ends now sit at ear height. The bangs and sculpted rear cap stay intact. The prior cheek width is preserved; 18 lower jaw vertices move only in depth and height so the chin and neck contour meet without the v19 ledge.

The rig, expression UVs, packed images, topology, and animation remain unchanged. This is Blender authoring data, not a device result. Private renders and references are excluded.

Rebuild with Blender 4.3.2:
```sh
blender -b -t 2 --python-exit-code 2 --python short_sideburn.py -- ../face-silhouette-19/human-face-round-19.blend /tmp/human-short-sideburn.blend
blender -b -t 2 --python-exit-code 2 --python soften_ledge.py -- ../hidden-trim-18/human-hidden-trim-18.blend /tmp/human-short-sideburn.blend human-profile-sideburn-20.blend
blender -b -t 2 --python-exit-code 2 --python verify.py -- ../face-silhouette-19/human-face-round-19.blend human-profile-sideburn-20.blend
```
