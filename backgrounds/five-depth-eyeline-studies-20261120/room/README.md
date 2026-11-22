# Child’s room — eye-line and depth pass

Editable character-free scene. The perspective camera’s horizontal axis crosses y=67.5 of the 240×135 opaque RGB render. Three depths: near blurred picture books, the bedside toys and bed, and a sidelit recessed hallway. The final plate is a static raster; it does not occlude the character at runtime or use parallax.

Open `room.blend` and render frame 1 with Cycles, or run `blender -b --python-exit-code 1 --python build.py`. Append `-- --draft` to preview quickly.
