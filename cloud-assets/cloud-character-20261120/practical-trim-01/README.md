# Cloud practical opaque 1,775-triangle export

Slightly trimmed static practical proxy of the unchanged original V3 Blender model (SHA-256 `148426cb676261c32dfe6bac01d8cb38e71b2ec66c478c0852cb3243c16c4d5c`). Each of the four original evaluated poses (frames 001, 084, 166, 241) drops from 2,019 to 1,775 triangles. Body 660 → 640, separate hands 104 → 72 each, five halo ribbons 120 → 88 each. Face mesh caps and sources are unchanged. Raw render media is not stored here.

The edited proxy meshes are connected closed manifolds with positive volume prior to GLB material seam splitting. The fixed 240×135 native host comparison against the old export uses matching camera, 3 yaws, 4 evaluated poses and 2 direct lights. All 24 exact firmware-rendered conditions keep the dark face-pixel mask unchanged; worst body-and-accessories binary silhouette IoU 99.60% (up to 26 changed mask pixels in the whole frame). Camera hand gaps are at least two background pixels. Native host snapshot peak falls from 34,644 B to 30,408 B. This does not prove actual-device speed, memory fit, authored transmission, or playback of the separately archived motion studies.

## Rebuild

Requires Blender 4.3.2, Node.js, and the public firmware repository containing commit `5a3dedcba86f46bf74567fc07c42a85e7bb3e25f`.

```sh
blender -b -t 3 --python-exit-code 1 --python tools/export_trim.py -- /path/to/cloud-delivery.blend /path/to/new-pose-dir balanced
mkdir /path/to/native-tools
git -C /path/to/cardputer-adv-pocketjs archive 5a3dedcba86f46bf74567fc07c42a85e7bb3e25f tools/ayatsuri | tar xf - -C /path/to/native-tools
for n in 001 084 166 241; do
  node tools/pack_scene.cjs /path/to/native-tools "/path/to/new-pose-dir/cloud-opaque-$n.glb" "/path/to/new-pose-dir/cloud-opaque-$n.aynm"
done
```

`verification.json` records per-pose and per-object triangle counts, hashes, and the host comparison. The alternative 1,775-triangle budget that removed additional body geometry was not adopted because the output changed face ink in the primary view.
