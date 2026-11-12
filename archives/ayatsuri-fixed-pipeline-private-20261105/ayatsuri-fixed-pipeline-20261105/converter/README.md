# Private AYFQ v1 converter prototype

This is a new experimental static representation, not an AYNM update or an integrated renderer. The strict GLB importer performs offline transform baking, normal inverse-transpose/normalization, axis conversion, winding and material validation. `source-adapter/glb_to_fixed_input.cjs` preserves its ordered partitions and **linear** colors. This converter then quantizes once, before runtime. It never reads Blender scripts or rewrites source assets.

## Selected numeric contract

- Input schema `ayatsuri-fixed-static-input-v1`, explicit native-basis metres, geometry scale one, baked static. Legacy compile reports without these fields are rejected. A schema marker alone is not independent provenance: use the audited adapter and verify its source/module hashes.
- Positions: signed 32-bit integer divided by `2^fraction_bits`, globally consistent across parts. Candidate fractional bits 16 or 20. They cover approximately +/-32768 m or +/-2048 m respectively. The same represented input quantizes identically in every part, avoiding independent partition-origin grids. Coordinates remain in the imported native basis `(Blender x, -Blender z, -Blender y)`; no legacy multiplication by 38 is performed.
- Normals: signed int16, divisor 32767, permitted codes -32767..32767. Source vector length must be within 1e-4 of one. Encoded vectors are not assumed mathematically unit. The decoder checks squared length in `[32762^2,32772^2]`, a conservative integer enclosure of source tolerance plus rounding. New symmetric rounding permits exact integer back-normal negation. This deliberately differs from the legacy asymmetric front/back rounding contract.
- Linear albedo: signed int16 code 0..32767, divisor 32767. It is **not** signed Q1.15 and not sRGB. Both zero and one are represented exactly, and every input fits signed 16-bit multipliers. Metallic/roughness do not become supported implicitly; the current explicit diffuse-material scenario remains the scope.
- Encode rounding: nearest, ties to even, for the binary64 scaled value in the default floating preparation environment. Range violations are rejected, never clipped. Source triangles are rejected if quantization collapses them or changes the dot-sign of old/new face normals. This is not a visibility or quality proof.
- Positions are 32-bit and must NOT be narrowed into the signed16 interpolation kernel. Normal/color interpolation can use the separate Q2.14 weight kernel; position/coverage/visibility need their own checked wide arithmetic or unchanged floating reference path.
- No HDR encoding is selected here. Reflectance is bounded by one; radiance is not. Observed HDR maxima are not safe overflow bounds for future scenes or individual sample contributions.

## Binary format

Little endian. Magic bytes `41 59 46 51 00 00 00 01`. The 64-byte header is `<8s14I>`:

1. version = 1
2. flags = 1, identifying this exact native-metre/static/color/rounding contract
3. position fractional bits
4. part count
5. material count
6. total vertex count
7. total triangle count
8. total 8-lane block count
9. part section offset
10. material section offset
11. block section offset
12. triangle section offset
13. total byte length
14. CRC32 of the entire file with this field zero

Offsets and total size are canonical and 16-byte aligned. Padding is zero. CRC detects corruption, not authentication. The adjacent metadata records source and output SHA256. A runtime binding must retain/check its expected source/material identity separately; CRC alone cannot establish it.

- Part descriptor: 32 bytes, `<8I>`: first block, block count, vertex count, first triangle, triangle count, material index, double-sided flag, reserved zero. Part order and local triangle order remain original. Limits: 256 parts, 3 effective vertices needed by every valid triangle, at most 32 vertices and 64 triangles per part.
- Material: 8 bytes, three signed16 linear components and zero uint16 padding.
- Vertex block: 144 bytes, `<24i24h>`. Eight x positions, eight y, eight z, then eight nx, eight ny, eight nz. Thus each signed16 normal row is aligned to 16 bytes. Position rows are 32 bytes, not a 16-bit SIMD row. Up to seven unused lanes are initialized zero and validated as padding. Descriptor count is authoritative.
- Triangle: four bytes, local unsigned8 indices a/b/c and zero padding. Indices must be distinct, within the part, and form nonzero integer area. No triangle/source-identity reordering is introduced.

The binary is a focused static geometry/material prototype. It omits old model hierarchy/material coefficients/animation/runtime control; its size is not an apples-to-apples replacement-model memory claim. Source correspondence and provenance remain in the private fixed-input JSON. A production format needs an explicit required identity section or a checked companion binding before integration.

## Validation and use

`python3 test_converter.py` passes eight unittest groups: ties/endpoints, deterministic round trips, widths 3..32 and partial blocks, invalid source/domain/topology, every single-byte bit flip and every truncation of the fixture, structural corruption with recomputed CRC, 500 seeded random round trips, and output conflict cleanup. Writes never replace existing files. Binary/metadata are not crash-atomic as a pair; completed evidence requires both.

From the workspace root, after producing a new source adapter output:

```sh
python3 ayatsuri-fixed-pipeline-20261105/converter/compile_fixed.py \
  ayatsuri-fixed-pipeline-20261105/source-adapter/private-fixed-source.json \
  ayatsuri-fixed-pipeline-20261105/converter/results/private/new-q20.ayfq \
  --fraction-bits 20
```

Use a new output name. Do not publish `results/private`, source datasets, images or actual-model statistics as part of generic code publication without separate review. The preliminary `model-q16.ayfq` predates the explicit-source schema check; its bytes match the final GLB-derived q16 file, but its metadata identifies the older report input. Final evidence uses `from-glb-q16.ayfq` and `from-glb-q20.ayfq` only.

## Actual private source result

Final adapter source SHA256: `81a174a5237d17863d60baff9463c411309f57e3e2cee236254cf6a74c22063b`. Both candidates have 54 parts, 1163 partition vertices, 1564 triangles, 8 materials, 163 padded blocks, 31584 bytes. Zero quantized triangle collapses/orientation reversals.

- 16 fractional position bits: maximum coordinate error 7.62939453125e-6 m.
- 20 fractional position bits: maximum coordinate error 4.76837158203125e-7 m.
- Both: maximum normal component error 1.5243615116566911e-5; maximum linear albedo error 1.4527674777924798e-5 against source linear values.

These are encoding errors, not final-image bounds. Current old RGB565 round-trip error reaches 0.01439597119 against those source colors, so a source-faithful candidate intentionally differs from the old renderer. Separate that improvement from arithmetic approximation in subsequent tests.
