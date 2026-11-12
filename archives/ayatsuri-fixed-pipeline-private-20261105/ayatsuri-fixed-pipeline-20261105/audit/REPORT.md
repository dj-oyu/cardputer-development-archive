# Blender-to-integer pipeline audit

## Finding and recommended boundary

Fixed-point should start **after evaluated static geometry, world transforms, axis conversion, inverse-transpose normals and material extraction, but before the existing RGB565 mapping and AYNM packing**. Blender and the importer's offline numerical work should remain floating point. The useful optimization is an integer runtime contract, not forcing Blender itself to compute with integers. Keep existing AYNM bytes and the renderer baseline unchanged while developing an independently versioned fixed sidecar and scalar integer oracle.

The current path is not already integer-first: mesh positions and normals are F32 on disk, normals become SNORM16 after runtime transforms, then are converted back to floating point and renormalized for lighting. Albedo is prematurely reduced from source linear RGB to encoded RGB565, then decoded back to linear for lighting. Pixel batching alone leaves these conversions and their accuracy limits intact.

## Verified provenance and source locations

Paths below are workspace-relative. Abbreviations:

- `A` = `fox-v3-floor-direct-reflection-evaluation/actual-002`
- `P` = `fox-v3-indexed-bvh-bounds/private-build/product`
- `T` = `fox-v3-indexed-bvh-bounds/private-build/transport`

The actual model is `A/compiled/model-baseline/model.aynm`, not a historical recovered-runner model. Its current source GLB is `A/inputs/geometry-source-sided.glb`. Importer: `A/product/tools/ayatsuri/asset/import_glb.cjs`; static adapter: adjacent `compile_static.cjs`; packer: `A/product/tools/ayatsuri/model/pack_model.cjs`; wrapper: `A/code/compile.cjs`.

An in-memory replay of that importer, static adapter and packer reproduced **every byte** of this model and every JSON part. GLB SHA256 is `833ac7683872375f9e63f819618e0e25ed40e0ac761a35f7604cd45501207a8e`, size 104156, Blender glTF generator v4.3.47. Import yields 92 surfaces, 994 vertices and 1564 triangles; ordered bounded partitioning produces 54 parts, 1163 vertices, 1564 triangles. All parts are double-sided. Existing model is 47708 bytes. Script and machine-readable audit results are adjacent to this report; results include input hashes.

`A/compiled/model-baseline/compile.json` retains pre-quantization data: `parts[].positions/normals/triangles/origins/materialId/scope/materialSidedness` and `materialTrace[].sourceLinear/scaledLinear/encoded/quantized/albedo565/sidedness`. **Part positions are metres in native axis convention, BEFORE multiplication by 38**. `sourceLinear` includes alpha; `scaledLinear` is the RGB used by the wrapper. `A/inputs/source-materials.json` independently retains Blender material baseColor and doubleSided by name. The GLB is the authoritative reusable importer input; compile.json is convenient private sidecar prototype input.

The historical scripts `review-proof/unpacked/export_source.py` and `fox-native-private/depth-input/unpacked/export_source.py` are byte-identical (SHA256 `cade8f18314c2213a1fb7075432c49977bbd89badc02bfdec632f375880777fa`). They evaluate six static shape-key samples, explicitly not runtime morph. Lines 8–12 disable animation export; 17–35 evaluate geometry, apply object world matrix, convert coordinates and record linear material colors. `fox-native-private/export_candidate.py:7–30` is another older evaluated-clone, optional export-only decimation path, not proof of current geometry. Its line 15 forces single-sided materials, whereas the actual input is double-sided. Do not reuse that override.

`fox-recovered-runner/unpacked/code/compile.cjs:9–21` is a historical v1 per-surface partition wrapper. Its dependencies are supplied by environment variables; `code/run.py:20,37` pins importer `76796a5c...` and `product-provenance.json` identifies product head `a426f7a...`. The current static batching/sidedness adapter is materially different. `fox-v3-floor-direct-reflection-evaluation/code/prepare_floor.py:4–14` shows actual input/product provenance through actual-lid8-v2 plus a frozen core overlay. The indexed-BVH private product has runtime sources but only sidedness test tools, not the complete source converter; do not assume a missing converter there means the older recovered one is current.

## Coordinate, transformation and animation contract today

- Importer lines 21–50, 150–176: glTF affine TRS/world composition in JS Number (binary64), followed by basis diag(1,-1,1), inverse-transpose normal transformation and normalization; negative determinant reverses triangle winding. Declared IR units are metres. glTF's usual Blender conversion plus this basis gives native `(x,-z,-y)` from Blender world `(x,y,z)`; the historical source export explicitly matches this (`export_source.py:29–34`).
- `A/code/compile.cjs:9` adds hardcoded geometry scale 38. `compile_static.cjs:21–31` bakes all surface coordinates into identity-pose root/child mesh nodes. Keep physical metres separate from this display/native scale.
- `P/main/ayatsuri/ayatsuri_transform.h:9–18,23–24,41–80`: runtime x right/y down/z toward viewer; radians; column vectors, T·Rz·Ry·Rx·S then parent·local. Storage F32, arithmetic F64, strict IEEE with no fast-math. This supports mutable node poses, not imported Blender animation.
- Importer lines 82–83,136–142 rejects animations, skin, weights and morph targets. Therefore a fixed static sidecar must say static-only. Do not claim rig/blink/jaw animation support from the pose-diagnostic exporter. Future animation needs local quantized rest geometry, scoped transform/deformation bindings, pose extrema and quantization after deformation/normal transform where required.
- Runtime model lines 645–658 constructs F32 camera basis from F64 normalization and evaluates transforms; lines 582–588 project orthographically, x/y multiplied by zoom and shifted by screen center, depth unzoomed.

## Existing quantization, sidedness and runtime transport

- `A/.../model/pack_model.cjs:9–12,41–51`: vertices are 28 bytes each: F32 xyz, F32 normals, F32 mask. Indices are U16. No fixed-point position quantization. Mesh bounds ±4096 native units; 3–32 vertices and 1–64 triangles per part; holes 0–2 with 3–8 points each. Coordinates and normals are rounded through F32 before writing. Triangles are checked again after F32 position rounding (14–19).
- Packer lines 72–83: poses/material coefficients F32, exponent 1–128, unit coefficients [0,1], color U24 in U32, thickness/opacity/edge softness F64. Descriptor albedo is RGB565, thickness U8 (45–46).
- `A/code/compile.cjs:6–9`: source linear RGB × explicit albedoScale, range-checked, sRGB encoded then rounded to 5/6/5. Source metallic/roughness are retained by importer (125–133) but wrapper explicitly maps to ambient/diffuse material, not a faithful arbitrary Blender BSDF.
- `P/main/ayatsuri/ayatsuri_model.c:574–610,740–758`: transforms normals by inverse transpose, normalizes in F64, rounds each component with `floor(x*32767 + .5)` and clamps [-32767,32767]. **Back normals are generated by negating the unrounded component before rounding**, not always by negating the integer front normal. Double-sided lighting and physical side flags must survive conversion. Geometric face normals are distinct from interpolated shading normals.
- Same file 747–758: pixel view uses unshaded descriptor albedo, projected F32 screen/depth, F64 world coordinates, and front/back SNORM16. Avoid confusing the legacy vertex-shaded RGB565 packet with pixel-lighting inputs.
- `P/main/ayatsuri/compact_opaque.c:106–151`: compact pixel records store F32 x/y/mask/depth, two RGB565 albedos, F64 world xyz and SNORM16 normal pair. Mode 5 saves the back normal only when all exact integer components are negatives; otherwise falls back to mode 4. This optimization is valid and reusable as a checked contract, not an assumption.
- `P/main/ui/kasane/ksn_mesh_depth.c:113–147`: F64 barycentrics, F32 depth comparison, interpolated world/normal/linear-decoded rho. Physical position becomes `(world.x,-world.z,-world.y)/38`. Physical shading is followed by sRGB encode and RGB565 output. `T/bounce.c:183–194` also decodes RGB565 and interpolates normals/rho for secondary hits. Updating only primary pixels would leave reflection albedo on a different contract.
- `P/main/ayatsuri/ayatsuri_shade.h:33–63`: legacy/linear vertex shading converts SNORM16 back to float, renormalizes, uses powf and RGB565. It is not the full current physical pixel path.

## Wire compatibility

JSON design v2 is **not AYNM wire version 2**. `pack_model.cjs:96–111` always writes AYNM v1; mandatory section 13 adds material sidedness, and all-single input remains legacy byte-identical. `P/main/ayatsuri/ayatsuri_model.c:97–118` only accepts wire version 1 and exact known strides; rejects unknown required sections. Never reinterpret F32 vertex bytes as fixed integers or hide changed color semantics in an optional section. Use a separate versioned magic/sidecar first. A new native fixed model can later have its own required version/sections and explicit capability rejection. Preserve immutable input hashes, mesh/material IDs, triangle origins and side rules.

## Measured numerical boundaries

See `audit-results.json` generated by `audit_pipeline.py`:

- Metre bounds: x [-2.16715455,0.82546753], y [-3.64947844,0.01107925], z [-2.12970710,1.18904889]. All stored positions exactly equal F32(source ×38); all normals equal F32(source normal).
- Q16 metres: 1/65536 m step, max component error 7.6293945e-6 m; no collapsed or flipped triangles among 1564. Q12 and Q20 also passed those two geometry-only checks. These are **not** visibility, shadow, coverage, grazing-normal or image-equivalence results.
- Worst existing source-linear versus decoded-RGB565 component error is 0.01439597119. A higher precision linear material sidecar removes this error but intentionally changes output versus the current RGB565 baseline. Separate “legacy equivalent” mode from “source faithful” quality mode.
- Legacy bounds ±4096 native units are only ~±107.789 m physically. Generic float runtime transforms allow much wider ranges, so static observed bounds cannot justify global integer overflow claims.

## Proposed coherent integer-first contract

1. Keep Blender evaluation and GLB transform baking floating point/offline. Normalize topology/winding, preserve source and material IDs, alpha/sidedness, static/animation scope, source units and frame. Reject unsupported materials explicitly. Quantize once at the final source-to-runtime boundary, not independently at every partition seam.
2. Sidecar schema: explicit encoding version, basis and metre unit, source hashes, position origin and fractional bits, rounding mode, signedness, admitted bounds, topology, original order, material table and side policy. Use integer SoA or aligned blocks at runtime for contiguous pixel lanes; retain logical identity independent of layout.
3. Candidate positions: signed int32 with 16 fractional bits in physical metres, optionally origin-relative. This has representation range about ±32768 m but arithmetic admission must be much tighter and independently proved. Do not convert through ×38 then /38 for physical shading. Screen projection gets its own subpixel encoding and declared zoom/viewport limits.
4. Candidate normals for integer dot-product lanes: signed int16 with 14 fractional bits, range [-16384,16384] for [-1,1]. Three worst-case component products sum to at most 805306368, fitting signed int32. This is deliberately not legacy SNORM16. Alternatively preserve SNORM16 with wider accumulators: arbitrary component-wise SNORM vectors can make 3×32767² exceed int32. Renormalization error and grazing decisions require tests. Specify nearest/ties-even and then symmetric back=-front if adopting the new normal contract; retain separate front/back in legacy compatibility mode.
5. Candidate reflectance: uint16 with 15 fractional bits, code 0..32768 for [0,1], retaining exact 1 and power-of-two shifts. Max single rho product 2^30 fits int32. UNORM16 is a higher precision alternative but is divide-by-65535, not Q0.16; never silently interchange them. Preserve source-linear material RGB, and separately offer predecoded legacy RGB565 lookup for numerical baseline comparison. RGB565 belongs only at final display encoding.
6. HDR illumination/radiance is NOT reflectance: it can exceed 1. Use a separate bounded U32 fixed format and U64 accumulation, deriving integer/fractional allocation from actual light power, distance/radius and integration bounds. Do not saturate individual contributions to white. Averaging/AA occurs in linear HDR, then one clamped sRGB/LUT encode at output.
7. Dynamic camera/node setup may initially stay F32/F64 once per pose/frame while the hot color loop consumes fixed arrays. Mark this as mixed setup + integer shading, not wholly fixed-point rendering. Ray intersections, inverse-square/normalization and geometric edge tests need their own scales and 64-bit/checked intermediates; no blanket promise that all geometry can use 16-bit arithmetic.
8. Keep overflow behavior explicit: reject out-of-range source/input, checked wide multiply/accumulate, no signed overflow, defined negative shift/division rounding, no unchecked narrowing, deterministic tie/zero/grazing policy. Fixed position cross products over the whole int32 range can exceed int64, so certify tighter per-scene bounds or use wider offline/reference arithmetic.

## Reuse and acceptance plan

Reuse strict GLB parsing, inverse-transpose and determinant logic, importer diagnostics, material IDs, exact ordered static partitions (batch_static.cjs:11–57), failure-atomic bounded loaders and source correspondence. Do not merge across material/sidedness or animated transform scopes. Current partitioner already preserves hard normals by keying position+normal, and exact original ordering.

Build a scalar integer oracle before batching. Verify encode/decode endpoints, half ties and signed zeros; extreme transforms and negative/nonuniform scale; normal antipodes and grazing; color 0/1 and sRGB threshold; degenerate-after-quantization triangles; bounds/overflow and unsupported version rejection. Compare legacy-input numerical mode and source-linear quality mode separately. Then compare identical scalar-versus-N-lane integer results including tail/masked lanes, edge coverage/depth ties, shadows/reflections and AA. Triangle noncollapse alone cannot prove visual correctness. Measure target cycles/memory only after those contracts pass; this audit performed no device execution or speed measurement.

All existing trees remained read-only. Deliverables were written only under `ayatsuri-fixed-pipeline-20261105/audit/`. No assets were published, no device was used, and the denied tree was not accessed.
