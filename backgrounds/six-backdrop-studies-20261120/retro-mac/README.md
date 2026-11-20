# Retro CG room and early Macintosh-inspired desktop

- **Pipe Dream-inspired room:** an original instrument stage built around oversized bent copper and red enamel tubes, mallet bars, drum heads, and chrome pinballs in visible flight arcs. The reference is Wayne Lytle’s [*Pipe Dream*, SIGGRAPH 2001 program](https://history.siggraph.org/wp-content/uploads/2021/05/SVR-Issue-138-2001-Electronic-Theater.pdf#page=19); the room's lighting/palette are a late-1990s CG interpretation, not a frame recreation.
- **Early Macintosh-inspired desktop:** editable orthographic monochrome geometry, with original pixel-style icons, title-bar stripes, menu bar, overlapping Finder-like windows, and a stippled desktop. Historical reference: [Computer History Museum, Hello. The Apple Mac @ 40](https://computerhistory.org/exhibits/hello-the-mac-at-40/). No screenshot, font file, or third-party bitmap was used.

Open either .blend to edit. Rebuild and render opaque 240×135 PNGs:
```sh
blender -b --python-exit-code 1 --python build_pipe_v2.py -- pipe
blender -b --python-exit-code 1 --python build_early_mac.py -- mac
```
