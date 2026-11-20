# Vaporwave Temple — distant ultra-wide effect

The foreground floor remains horizontal and rectilinear. A level 32 mm camera retains the same frame and y=67.5 eye line. Distant ruin and surviving colonnade vertices alone receive camera-space radial barrel compression, preserving depth and the optical axis; the distortion is not a planet or a physically arched floor. The sunset remains circular, with the top 40% uninterrupted and progressively fading bands below. Thin horizontal atmospheric fog partially obscures the ruin’s base.

Open `temple.blend` and render frame 1 to get the opaque 240×135 RGB background. Recreate it with `blender -b --python-exit-code 1 --python build.py -- temple`. Run with `-- temple --draft --undistorted` for the same layout without distant ray compression.
