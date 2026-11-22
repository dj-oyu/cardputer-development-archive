# Occupied chair turntable

The Blender source is [chair-rear-topdown-v109.blend](../chair-back-topdown-v109/chair-rear-topdown-v109.blend), SHA-256 `4142a7b7b2b0659065a0823203e83b926f17df697420909f5127670d22df8a52`. Its frame 84 supplies the seated pose. The scripts animate the seat, character, and rear aperture together, keep the base and casters fixed, and advance the three optical effect loops at their original cadence.

Use Blender 4.3.2 from this directory. Rear view:

```sh
EXPECTED_BLEND_SHA256=4142a7b7b2b0659065a0823203e83b926f17df697420909f5127670d22df8a52 OUT=rear-frames blender --disable-autoexec -b ../chair-back-topdown-v109/chair-rear-topdown-v109.blend --python-exit-code 1 -P occupied-chair-turntable-v109.py
```

For the fixed front-three-quarter comparison, use `occupied-chair-review-camera-v109.py` instead with `YAW=145 PITCH=12 SCALE=7.9 STEP=3 OUT=front-frames`. `STEP=3` samples every third frame of the same turn. The camera is fixed in both views. Review renders are not included.
