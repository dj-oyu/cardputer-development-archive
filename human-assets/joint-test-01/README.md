# Provisional anatomical pivot test

Build from the unchanged artist source (overlay #02, SHA-256 d4ef06944c9aede91c2a762c401709d81abdb1a9d7a7901150ef39d9d78b10f9):

    blender -b cardputer-human-overlay-02/human-overlay-02.blend -t 4 --python-exit-code 2 --python cardputer-human-joints-01/build_joints.py -- cardputer-human-joints-01/new-output --render
    blender -b -t 2 --python-exit-code 2 --python cardputer-human-joints-01/verify_rest.py -- cardputer-human-overlay-02/human-overlay-02.blend cardputer-human-joints-01/new-output/human-joints-provisional.blend
    python cardputer-human-joints-01/annotate.py cardputer-human-joints-01/new-output

Frame 1 = original rest; 30 = mild elbow + knee hinge probe, not animation choreography or planted-feet IK. The 20-bone edit rig adds regional interpolation over shoulder/elbow/wrist/hip/knee/ankle and the torso; original object seams/materials remain editable. Independently compared all 3,982 evaluated rest vertices of 79 meshes (max positional residual 4.93×10^-7 Blender units). Curled cuff, shirt/shorts seam and boot should be reviewed before deeper bends; the test reports their relative edge extension. No claim of collision-free mesh, foot planting, Cardputer playback, or performance. PNGs are chat review only.

Exact source: [human-overlay-02.blend](../overlay-fit-02/human-overlay-02.blend).
Review PNGs are not included here.
