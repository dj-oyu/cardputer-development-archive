# Human character: sagittal silhouette 04

Editable authoring checkpoint based on proportion-03. True side was too flat; this pass shapes the ribcage front and upper back, tucks the lumbar section just above the waist, broadens the rear pelvis/seat, and separates the thigh front, knee and calf contours. The front x/z coordinates, head, boots, topology, vertex weights, existing 20-bone rig and authored pose track are unchanged.

From this archive directory, with Blender:

    blender -b -t 4 --python-exit-code 2 --python ./shape_profile.py -- ../proportion-03/human-depth-03.blend ./rebuild/human-profile-04.blend
    blender -b -t 4 --python-exit-code 2 --python ./verify_profile.py -- ../proportion-03/human-depth-03.blend ./rebuild/human-profile-04.blend
    blender -b -t 4 --python-exit-code 2 --python ./pose_check.py -- --metrics-only ./rebuild/human-profile-04.blend ./rebuild

The render_profile.py script renders a 240×135 horizontal orthographic side frame. Run with the source blend and an output directory as its two final arguments. This is a Blender view, not device output. No third-party art, test render or illustration is embedded or distributed with the model.

Deep 95° elbow probe shows the same sleeve stretch. In the isolated two-foot weight-shift, both planted soles retain their source positions, but local stretch is higher on the shorts legs and on the shin/thigh meshes. This is a profile shape checkpoint, not a deformation fix or runtime asset.
