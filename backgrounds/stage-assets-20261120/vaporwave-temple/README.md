# Vaporwave Temple — spectral lens

Strong cyan columns and blue-green glints contrast with a pronounced magenta
sky and reflections. Blender's compositor radially splits the color channels
relative to image center (approximately four pixels of separation near the
left and right edges, falling to zero at center). There is no effect at
runtime; the delivered frame is a static opaque 240×135 RGB background.

The level camera, flat foreground, distant projection and progressive sunset
silhouette are carried over. The foreground column plinths now meet the floor. Open `stage.blend` and render frame 1, or rebuild
with `blender -b --python-exit-code 1 --python build.py -- temple`. Add
`--draft --no-fringe` to omit the channel separation in a quick test render.
