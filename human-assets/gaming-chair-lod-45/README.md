# Cardputer human: seated mesh LOD and gaming chair v45

The approved high-detail standing master remains at the earlier v44 archive. This separate Blender file opens on a static seated pose, with both the original action and the new seated hold action retained. The chair is a separate editable `Gaming Chair Prop` collection. Materials and texture images are embedded.

At frame 1, evaluated visible triangle counts excluding the preview floor: 1,913 human (original 6,739), 248 chair, 2,161 combined. These are Blender mesh counts, not an export/runtime count or FPS. Match normal and stress poses before any optimization beyond this version.

Both knee meshes are clean in the sampled original and seated poses, and chair contact is limited to the intended slight seat cushion overlap. The jacket back and elbows sit slightly forward/above the supports. Seated shorts and sleeves retain some internal shell intersections present already in the seated full-detail test; checked views show no open knee mesh or seat gap. No native export, simulator test, or device measurement was performed.

To recreate: open the pinned v44 in Blender with seat.py, opening its output with lod.py with environment LOD=lite. Run build_chair.py to generate a separate chair, then assemble.py takes (seated LOD blend, chair blend, output blend). Exact archived .blend is the reviewed source of record. The counts report names the human and chair source digests.
