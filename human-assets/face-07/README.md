# Human character: gentle face 07

Editable authoring checkpoint based on the saved varsity-06 model. Softens the lower cheeks and tapered nose and replaces the dark wedge around the eyes with a thin, tapered eyelid. Refits the warm brown eyes, lowers/softens the brows and adds a subtle closed smile. These details are actual editable geometry and material slots. No artwork is linked or embedded. The rig, authored animation, hair and clothing are unchanged.

From this archive directory:

    blender -b -t 4 --python-exit-code 2 --python ./soften_face.py -- ../varsity-06/human-varsity-06.blend ./rebuild/human-face-07.blend smile
    blender -b -t 4 --python-exit-code 2 --python ./verify_face.py -- ../varsity-06/human-varsity-06.blend ./rebuild/human-face-07.blend
    blender -b -t 4 --python-exit-code 2 --python ./pose_check.py -- --metrics-only ./rebuild/human-face-07.blend ./rebuild

The chosen smile pass can be rendered at fixed front and three-quarter cameras with render_face.py. No eyelid or mouth animation was authored in this pass. Authoring model 9,567 triangles (previously 8,521), not a runtime mesh. Blender native-frame and motion comparisons are not device validation.
