# Knee-over-knee, relaxed left ankle v82

Source: the v77 knee-over-knee motion in archive commit `7e45dee131d5c6baba9fb80d761f5442d0aaf0fd`. This is an isolated edit of that motion, not a merge of the later expression studies. The yaw-only interim adaptation did not change the angle between the shin and sole and is not used as the baseline for this reconstruction.

- At crossed hold, the measured angle between the lower-leg bone and the plane fitted to the evaluated outsole is 78.000° (was 23.063° in v77 and the yaw-only attempt). The 12° remainder from perpendicular deliberately allows gravity-like relaxation at the toe. It uses an 8° local clockwise heading relative to the anatomical alignment.
- The joint center is 0.136 BU below the boot rim at hold. The rim is fully weighted to the shank; the support transitions below the hem through the boot upper, while the vamp/sole follows the foot. Neutral was compensated against the original evaluated skin so the silhouette at the start and return is unchanged.
- The active action preserves the original 49-frame timing, knee-cross path and other pose channels. It adds and removes the ankle rotation while the left leg lifts and settles. Left ankle position, opposite leg, chair and camera are unchanged. All earlier actions, topology, UVs and materials are retained; only the left boot upper and two insert meshes have local weighting/bind compensation to keep the rim fixed.
- Fresh file reopen: 193 quarter-frame samples (frames 1–49); zero tested external mesh intersections with support leg, hands/sleeves, or chair, no floor penetration. Before/after endpoint renders were pixel-identical in front, three-quarter, and side views at native 240×135. This is a Blender evaluation, not a Cardputer test.

## Reproduction

From the v77 source run `MODE=save NAME=chair-knee-ankle-natural-v82.blend PITCH=12 YAW=-8 WEIGHT=1 blender -b /path/to/v77.blend -t 2 --python align82.py`. To verify, run `V77=/path/to/v77.blend blender -b chair-knee-ankle-natural-v82.blend -t 2 --python-exit-code 1 --python verify82.py`. Set `V80=/path/to/yaw-only.blend` only if that optional rejected comparison file is available. `render82.py` reproduces the review renders from fixed camera settings (`VIEW=front|quarter|side`, `LABEL=...`, `RENDER_FRAMES=1,25,49`, `SAMPLES=32`); rendered files are not archived.
