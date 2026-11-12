# Geometry-only diagnostic bridge

`geometry_bridge.py` prepares private copies for a later stage-isolated geometry comparison. It does not render, run a shadow query, change an existing gate, or replace old inputs.

The unchanged source-to-old-model control is checked for every position and normal: `float32(source_native_metres * 38)` must equal original AYNM XYZ bytes, and `float32(source_normal)` must equal original normal bytes. Part descriptor order/count, every triangle index, and fixed candidate sidedness are matched explicitly. It then substitutes only XYZ from decoded AYFQ, scaled once by 38 into legacy Float32. Every non-position byte is asserted unchanged. This is deliberately not an all-fixed runtime implementation.

Results for the current private input:

- Q16 metre candidate: 3466 / 3489 XYZ components differ from old F32; max physical change 7.62939453125e-6 m, RMS 4.42263200850e-6 m.
- Q20 metre candidate: 3124 / 3489 XYZ components differ; max physical change 8.03094161184e-7 m, RMS 2.79241311977e-7 m.
- Both: 1163 vertices, no nonposition byte changes, no collapsed/orientation-reversed Float32 triangles, no divergent quantization of repeated old positions across partition seams.

Q20's bridge difference from the OLD F32 baseline is larger than its 4.76837e-7 m quantization error against source, because this comparison includes old/new Float32 rounding after multiplying by 38. Do not mix these two metrics.

`validate_model.c` links the unchanged existing host ayatsuri_model, visibility helper and disk-lighting objects, and calls only `ayatsuri_model_open`. It creates no model instance and executes no renderer/ray/shader. Original, Q16 and Q20 all return status 0 (55 nodes, 54 packets, 47708 bytes each). This is model-admission evidence, not snapshot/coverage/image equivalence. Existing objects are identified in the checkpoint manifest; no target speed claim follows.

Example from workspace root, with a fresh output filename:

```sh
python3 ayatsuri-fixed-pipeline-20261105/bridge/geometry_bridge.py \
 ayatsuri-fixed-pipeline-20261105/source-adapter/private-fixed-source.json \
 fox-v3-floor-direct-reflection-evaluation/actual-002/compiled/model-baseline/model.aynm \
 ayatsuri-fixed-pipeline-20261105/converter/results/private/from-glb-q20.ayfq \
 ayatsuri-fixed-pipeline-20261105/bridge/private/new-q20-geometry.aynm
```

The full existing renderer requires candidate-specific snapshot/AA/floor/background facts, work ledgers and independent acceptance review. Never feed these models through the completed old fixed42 gate or disable its checks. See `quality/ACTUAL_COMPARISON_FEASIBILITY.md` for the legitimate next-stage plan. All model-derived outputs here are private.
