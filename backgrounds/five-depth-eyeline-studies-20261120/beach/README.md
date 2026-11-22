# Sunny beach — depth pass

Work from `beach.blend`. Render frame 1 in Cycles (240×135 RGB). To rebuild from source, use `blender -b --python-exit-code 1 --python build.py`.

Three planes of depth: near-corner dune grass with optical camera DOF; midground beach parasol and surf; distant horizon with light atmospheric scattering. The right-hand sun's bloom and streak are computed in Blender's compositor, not by the display device. The finished output is one opaque static image, so no props occlude the runtime character and there is no parallax.
