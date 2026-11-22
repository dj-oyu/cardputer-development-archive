# v90: add proximal thigh yaw during the knee cross

Source is the user-reviewed v88 knee cross with the stationary right ankle,
SHA-256 `83d9ba5fa198bd34d86f99cc625cd40b6a7406da60e3654490e47207e3c64aaf`.
Only the existing knee-cross action was refined; this is unrelated to
stand-to-sit work or newer expression sources.

- The right thigh begins turning inward in the approach. The revised horizontal
  heading of the right hip-to-knee vector peaks at 15.44° versus the old 6.99°
  at frame 12.5, an additional 8.45°. It then settles to only 1.73° additional
  yaw during the crossed hold. The yaw target is applied about scene up before
  the two-bone solve; it is not extra twisting of the shoe or a change in its heading.
- The sole's position changes by at most 0.00017 BU between models when measured
  at the right ankle over the whole action. The right shoe rotation is unchanged
  and the left ankle keeps the same local foot-to-shin rotation. At crossed hold,
  shin versus sole measures 78.05° on the right and 78.00° on the left.
- A small shifting of the body's weight is animated only while turning to keep
  the thigh clear of the cushion, then settles. The temporary upper-body shift
  peaks at about 0.146 BU; it is 0.030 BU during hold. The chair, camera, limb
  lengths and all raw mesh/skin/material data are preserved. The original action
  is retained separately.
- Independent fresh reopen evaluated 193 quarter-frame samples. There were
  no detected leg/boot/clothing-limb intersections across the two legs or with
  chair and arms/sleeves, and the minimum sole z stayed above the z=0 floor plane.
  Separately the already-contacting shorts and seat cushion show up to 2 more
  triangle overlap pairs than v88; this is not a claim of zero total scene overlap.
  Start and end pose geometry match the source. 49 frames at 10 fps, 4.9 seconds.
  Blender review only; not a Cardputer performance or runtime claim.

## Reproduce

```sh
MODE=save PARAM="$(cat params.txt)" NAME=chair-knee-thigh-yaw-v90.blend \
  blender -b /path/to/v88.blend -t 2 --python-exit-code 1 --python yaw90.py
V88=/path/to/v88.blend blender -b chair-knee-thigh-yaw-v90.blend -t 2 \
  --python-exit-code 1 --python verify90.py
```

Review angles from `render90.py` are not edits to the saved camera.
Render media stay out of the authored source archive.
