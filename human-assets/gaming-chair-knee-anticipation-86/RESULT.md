# Right-foot anticipation v86

Source is the exact v82 corrected ankle file, SHA-256
`901316cf227cb6aac985dbd5f7986aa0bd3841f231a5c9cba94f03382d15f997`.
The left-side shape, cuff transitions, and existing 78° shin-to-sole hold are retained.
This is an independent pose edit, not a merge with the later facial study.

- The seated girl lifts the right support shoe a small amount, moves it 0.120 BU toward the center, and plants by f12. The left knee first crosses the center on f12.5. The right sole stays fixed at its new placement through f37 and then returns gently once the left leg is coming back.
- In the evaluated animation, the peak vertical separation of the right sole from its original planted floor is 0.0583 BU. The hold adds negligible fore-aft travel (0.0075 BU). Its planted sole shows zero sampled vertex drift from f12 to f37.
- The source motion's timings, keyframes and left leg are retained. Only two new rotation curves groups, right shin and right ankle, were added to a copy of the active action. The right knee position, other bones, chair, camera and unmodified object meshes are identical at all sampled frames; all raw topology and mesh skin remain identical.
- Reopened QA: 193 quarter-frame samples spanning f1–49. Zero overlap samples for the changed right leg/boot against the left leg, chair, or sleeves/arms, and no meaningful floor penetration. Front endpoint render pixels are identical to v82. This is Blender evaluation, not a device result.

```sh
MODE=save PARAM=0.12,0.058,6,3,12,37,47,0 NAME=chair-knee-anticipation-v86.blend \
  blender -b /path/to/v82.blend -t 2 --python-exit-code 1 --python anticipate86.py
V82=/path/to/v82.blend blender -b chair-knee-anticipation-v86.blend -t 2 \
  --python-exit-code 1 --python verify86.py
```

The optional Blender review rendering script never changes the model file. Preview images and GIFs are not archived with this source.
