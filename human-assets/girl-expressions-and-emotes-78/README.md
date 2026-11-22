# Girl v78: expressions and shared comic symbols

The editable model is based on [the v77 seated model](https://github.com/dj-oyu/cardputer-development-archive/tree/7e45dee131d5c6baba9fb80d761f5442d0aaf0fd/human-assets/gaming-chair-knee-over-knee-77). The existing mesh, UVs, weighted bones, knee-cross action, camera, and chair are retained. No additional triangle geometry for the face; the original neutral, blink, and smile render unchanged.

On the character armature, Custom Properties:
- Face Expression: 0 neutral, 1 worried, 2 surprised, 3 comic dot eyes and epsilon mouth, 4 sleepy.
- Face Blink and Face Smile retain their independent legacy toggles, affecting only their reserved regions.
- Comic Emote: 0 off, 1 sweat, 2 confusion, 3 anger. One symbol is visible at a time; independent of face state. Default is neutral and off. The symbols are camera-facing near the head in the composed view.

Symbols are from [the fox reference model](https://github.com/dj-oyu/cardputer-development-archive/tree/ba71ff28339200212297bef5fb4e98b385c2c5e2/fox-assets/ground-truth-20261119), which provides the same reference used for the cloud. Sweat and anger shape/material remain the same; the confusion spiral is simplified to 80 triangles with the original profile sampled within about 0.74 px at its reviewed scale. The active costs are 20/80/64 triangles respectively. Figure alone is 1,913 triangles; no extra face geometry; it stays at or under 2,000 with any single symbol, excluding the separate chair and rear-aperture overlay.

Review: Blender 4.3.2, files saved and reopened with script auto-run disabled, renders at 240×135. Device performance and runtime adaptation not tested. Generated review sheets are intentionally not in this archive.

To rebuild, first open exact v77 and run extract.py with Blender on v77 and draw78.py with Python (Pillow and NumPy) to regenerate the four face maps. Open v77 and run apply78.py with FACE_OUTPUT set to a new file. Then open that file and run:

    blender -b FACE.blend --disable-autoexec --python-exit-code 2 --python add_emotes.py -- --fox FOX.blend --out OUTPUT.blend

FOX.blend SHA-256 is checked in add_emotes.py. Reopen OUTPUT.blend with review_emotes.py to exercise all toggles in multiple views and generate new previews. The final .blend packs the face textures and stores the symbols without external inputs.
