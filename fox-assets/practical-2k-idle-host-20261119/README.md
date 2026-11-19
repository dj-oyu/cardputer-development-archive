# Fox v5: runtime idle / glance handoff

This addon uses the unchanged [v5 AYNM and editable Blender baseline](https://github.com/dj-oyu/cardputer-development-archive/tree/aa7e8f1193e8a394b7b79c9539edd4755c6dc918/fox-assets/practical-2k-bilateral-20261119).
The immutable AYNM retains 1,754 neutral and 1,934 stored triangles; it has the larger host eyes and manga marks. The separate Blender asset remains the source of the default breathing curve, with the original rig and sit/face actions intact. The package does not touch the Blender file, modify the user branch, or install itself into firmware.

## Integration

1. Verify the exact AYNM SHA-256 (`616033c06602ae3fe7ee8c14536ffba7654aa57bab257c67c19b25c63a584225`). Compile `fox_idle.c` and include `fox_idle.h` and the checked-in `breath_data.h`.
2. Open the AYNM and initialize an actor normally. Keep one caller-owned, long-lived `fox_idle` state per actor (not on the frame stack); `fox_idle_bind` once on its fresh cold pose. This binding assumes the v5 model's root identity, rigid neck hierarchy and authored node names. It is not an arbitrary AYNM adapter.
3. Choose a fixed camera anchor of +35° or −35°. For idle, use the caller's elapsed `uint64_t` milliseconds and apply `fox_idle_apply` before native evaluate/submit. Call `fox_idle_mark` only when selection changes (−1 none, 0 sweat, 1 confusion, 2 anger). Check return status before rendering or committing. The caller retains its existing clock, pause, presentation and lifecycle responsibilities. Start with a fresh bound actor when switching to unrelated animation states; blending with sit or expression control was not tested.
4. The phase is deterministic: the sampled four-second breathing loop repeats continuously. Every 12 seconds the head glances toward the selected camera (650 ms ease-in, 650 ms dwell, 850 ms ease-out). Eye/face parts and optional marks follow the same pivot; no topology changes or asset loads on tick.

The breathing envelope samples the Blender action at 12 Hz with linear interpolation. Chest and upper-foreleg motions use local per-axis affine fits of Blender's breathing shape keys; they do **not** claim full shape-key/skinning equivalence. At default peak, the independent maximum geometric residual at the tested 32 px/unit scale is at most 0.95 px at the chest, 0.26 px at either shoulder (geometric projection bound, not a raster difference guarantee).

## Reproduce

With the firmware checkout containing `5a3dedcba86f46bf74567fc07c42a85e7bb3e25f`:

```sh
sh verify.sh /path/to/firmware /path/to/fox-host-v5.aynm /path/to/new-output-dir
blender -b /path/to/fox-2k-bilateral.blend --python export_breath.py -- /path/to/generated-breath-data.h
```

The checksum-pinned host probe builds with ASan/UBSan (LSan disabled) against the real native model and shared-depth renderer, not a mock. At 240×135 and both anchors, it checks 12 forward and reverse samples, starts/returns/period boundaries, stationary-eye breath, glance entry/peak/exit, all three marks attached and rendered, invalid owner/generation/anchor, framing and equality of 1/8-row rendering. See `verification.json` for the measured capacities and explicit limits.

The host preview uses a fixed test camera at 13.57° elevation, 32 px/unit. The tail is visually obscured at the tested +35° angle even in the unchanged neutral frame; this addon does not change that pose/camera art. This is not a firmware app build, target memory-fit test, FPS result, deployment or physical-device validation.
