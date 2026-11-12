# Explicit GLB-to-fixed source adapter

`glb_to_fixed_input.cjs` is generic offline adapter code. It calls the explicitly selected trusted strict GLB importer and exact static batcher. It does not load the AYNM packer, encode RGB565, quantize coordinates or edit source data. Local module arguments execute trusted JavaScript; do not supply modules named by untrusted assets.

Output contract:

- schema: `ayatsuri-fixed-static-input-v1`
- coordinate_system: `ayatsuri-native-metres`
- source_units: `metres`
- geometry_scale: 1
- source_mode: `baked-static`
- parts: exact ordered bounded static partitions, native-basis metre positions, unit normals, indices, source correspondence, material ID, explicit sidedness and static scope.
- materialTrace: source material ID and unencoded `scaledLinear` RGB.
- provenance: source SHA256/byte size, importer/batcher/adapter/scenario SHA256, explicit albedoScale, and original importer source/count metadata.

The importer provides the coordinate transform and validates unsupported content. The adapter verifies the importer's metre and basis metadata rather than guessing units from coordinates. No Blender unit-setting conversion is added: the strict GLB importer's glTF metre convention remains the contract. All source object transforms are already baked. This is not an animation converter.

The explicit scenario must contain finite nonnegative `albedoScale`; scaled colors must remain in [0,1]. Missing/default-material mappings are rejected like the current model wrapper, rather than inventing a material. Existing implicit v1 single-sided and explicit v2 single/double-sided semantics are preserved. Batch packing preserves original face order and uses `fixed-static-scene` scope, matching the existing compiler wrapper.

The expected source hash is mandatory and verified before importing. Output is created exclusively (`wx`), never overwritten. For different settings, use a new output filename. Failed filesystem writes can leave a partial new file; no existing output is replaced.

## Private reproducibility

From workspace root, for a fresh output filename:

```sh
A=fox-v3-floor-direct-reflection-evaluation/actual-002
D=ayatsuri-fixed-pipeline-20261105/source-adapter
node "$D/glb_to_fixed_input.cjs" \
  --importer "$A/product/tools/ayatsuri/asset/import_glb.cjs" \
  --batcher "$A/product/tools/ayatsuri/asset/compact_opaque/batch_static.cjs" \
  --source "$A/inputs/geometry-source-sided.glb" \
  --source-sha256 833ac7683872375f9e63f819618e0e25ed40e0ac761a35f7604cd45501207a8e \
  --scenario "$D/scenario.json" \
  --output "$D/private-fixed-source-rerun.json"
node "$D/test_adapter.cjs" "$A"
```

`private-fixed-source.json` is the generated private dataset (54 parts, 1163 partition vertices, 1564 triangles); do not publish it with the generic adapter. `scenario.json` explicitly specifies albedoScale=1. Tests compare this private output against old compile.json only as a verification oracle, not as input to the adapter. Tests also generate local synthetic GLBs in fresh `test-private-*` subdirectories so no prior test output is overwritten.

## Verification

11 test groups passed: single and double-sided materials, zero/half scale, invalid scale/missing scale, out-of-range scaled color, animation/skin/morph rejection, unmapped default material rejection, source-unit metadata rejection, negative-scale transform preservation, byte-value-equal parts and pre-RGB565 colors against existing compiler output, source-hash mismatch rejection and output no-overwrite behavior.

The synthetic triangle expected-value test initially had the wrong y sign in the test expectation; corrected to the importer's documented y inversion, then the complete suite passed. No adapter implementation change was necessary. No device or performance claims are made. All original trees remained read-only.
