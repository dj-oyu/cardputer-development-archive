# Fox v5 baked shadow host trial

This is a visual trial for the 2k Fox, not a firmware change or physical-device result. It tests two warm shadow colors on the same cheek and chest masks. The illustration is placement guidance only; the build inputs are the model and this script, not an image used as a texture.

## Reproduce

1. Obtain `fox-host-v5.aynm` from the [v5 asset archive](https://github.com/dj-oyu/cardputer-development-archive/tree/aa7e8f1193e8a394b7b79c9539edd4755c6dc918/fox-assets/practical-2k-bilateral-20261119).
2. Obtain the files from the [idle host delivery](https://github.com/dj-oyu/cardputer-development-archive/tree/0454e0bfaf55503e88e0399331d656d974515582/fox-assets/practical-2k-idle-host-20261119) and a firmware checkout containing `5a3dedcba86f46bf74567fc07c42a85e7bb3e25f`.
3. With Python 3, Pillow, and a sanitizer-capable C compiler, run:

```sh
sh verify.sh /path/to/firmware /path/to/idle-host-delivery /path/to/fox-host-v5.aynm /path/to/new-output-directory
```

For bake only: `python3 bake.py /path/to/fox-host-v5.aynm /path/to/output-directory`. This rejects a source with a different SHA-256 instead of silently applying masks to a different packet or vertex ordering.

## Scope of the bake

Model-local signed fields on cream cheek and cream chest vertices use the existing RGB565 B color, selected by the zero crossing of the interpolated mask. They touch only the two authored object groups, preserving the eye, leg, orange fur, and all geometry. Authored positions and normals, topology, pose, names, and ordinary A color remain byte-identical. Shared positions within the same cream-colored object receive the same values; the authored cream/orange material boundary remains intentional.

Baseline and both derivatives are 122,024 bytes (429 bytes differ for each variant). Source Blender and animation adapter are untouched. The existing renderer and draw pass are unchanged; no network access or extra texture is introduced. In the tested host implementation, colored packets use more snapshot storage: peak 45,076→46,428 bytes (+1,352), within the 65,536-byte test capacity. Work score (peak 49,785), record count (125), and actor arena (211,556 bytes) are unchanged. This is not an on-device performance or memory measurement.

## Results

ASan/UBSan probe passed for all three models at both ±35° anchors. The native renderer saved 12 frames per model per angle, repeated in reverse for byte-exact determinism; periodic resets and 1-row vs 8-row draws match exactly. All three marks remain visible and track the head in the existing host tests. The nonzero pixel footprint is identical in all 24 comparable frames; rows 100–134 are pixel-identical. The changed region is localized, 241–278 pixels per frame depending on pose and view. The comparison PNG shows both anchors at rest and with the head turned.

The weak option is the recommended starting point: it adds a warmer plane beneath the cheek/chest without the strong version's conspicuous chest patch. This does not establish physical-device suitability.
