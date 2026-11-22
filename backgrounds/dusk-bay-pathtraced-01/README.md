# Dusk bay, Cycles variant

Editable 3D landscape for a single static Cardputer backdrop. This variant replaces
the previous flat color cards with lit heightfield ridges, a rippled reflective
water surface, warm low-angle lights, and a real heterogeneous Cycles volume
that scatters the lights. Nothing is lit or composited on the Cardputer by this
file. It includes no character, image textures, or parallax.

- Open `cloud-dusk-pathtraced.blend` and render frame 1 to get a 240×135 opaque RGB PNG.
- To rebuild from source: `blender -b --python-exit-code 1 --python build_dusk_pathtraced.py`.
- A quicker lighting draft: append `-- --draft`.
- To compare the lighting contribution, disable render on **Regional marine scattering volume** and render again from the same camera.
- The scene uses high samples rather than denoising so it also works on Blender builds without OpenImageDenoise.

## Cardputer backdrop

Render from Blender first, then convert the image with Pillow installed:

```sh
python3 encode_rgb565.py cloud-dusk-pathtraced-240x135.png dusk-bay.rgb565 --header companion_raster_test_pixels.h
python3 -m unittest -v
```

The background is opaque RGB565, 240×135, top-to-bottom / left-to-right,
little-endian and 64,800 bytes. The optional C header matches the
compile-time diagnostic background contract in
[firmware PR #135](https://github.com/dj-oyu/cardputer-adv-pocketjs/pull/135)
at `fea78dce956a75d027b6fb24f3d89bd345e74f1c`. An aftermarket raw-file
runtime loader is not assumed. The host result uses that revision’s
native Ayatsuri/Kasane renderer and raster compositor with the
[1,775-triangle Cloud pose 001](https://github.com/dj-oyu/cardputer-development-archive/tree/ac3f7f20bb44c69eca646d4b444b31d137e012c5/cloud-assets/cloud-character-20261120/practical-trim-01).
All background pixels and covered character pixels were checked in
the RGB565 framebuffer. The host result does not verify firmware
deployment, LCD, or device FPS. Rendered previews are not archived.
