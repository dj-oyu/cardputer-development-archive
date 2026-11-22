# Human character: overlay detail pass 05

Derives a production-source checkpoint from the exact profile-04 source. Original artwork was aligned privately to the 240×135 project render using uniform scale and translation, looking at the eye/crown/chin and collar rather than matching a posed illustration's full silhouette. The source blend contains no artwork or render; authoring detail, not a runtime mesh.

The near temples recede around the ear and preserve the lower cheek lock, so the face is framed rather than hidden in three-quarter and profile views. The eyes and smile are re-seated above the edited skin, upper dark eye line strengthened, and two editable, head-weighted iris rims add 40 triangles total. Small contrast and lapel lip adjustments retain existing jacket design. Existing torso, legs, boots and 20-bone rig/action are unchanged.

From this directory:

    blender -b -t 4 --python-exit-code 2 --python ./refine_detail.py -- ../anatomy-04/human-profile-04.blend ./rebuild/human-detail-05.blend
    blender -b -t 4 --python-exit-code 2 --python ./verify_detail.py -- ../anatomy-04/human-profile-04.blend ./rebuild/human-detail-05.blend
    blender -b -t 4 --python-exit-code 2 --python ./pose_check.py -- --metrics-only ./rebuild/human-detail-05.blend ./rebuild

Skin/head fundamental geometry and existing animation are preserved. 95° elbow and planted weight-shift probes are Blender-only tests; no device, export or performance claims. Original reference and comparison images remain outside the archive.
