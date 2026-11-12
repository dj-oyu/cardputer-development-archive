# Latest 2k-v2 fixed attribute IR prototype

This is an independent offline attribute/provenance experiment, not an AYFQ file, renderer integration or latest-model image result. No Blender invocation, export/reduction, driver evaluation, ray/BVH/visibility query, frame render or old gate change occurred here. The LOD worker's source artifacts are read-only.

## Final artifacts and binding

Use `attributes-q16-v2.json`, `attributes-q20-v2.json`, `results-v2.json` and `material-semantics-binding.json`. The `*-v1.json` exports are **HISTORICAL / SUPERSEDED, not authoritative** intermediate revisions from before the loop supplement arrived; they explicitly marked UV unbound. V2 resolves that mapping using a separately pinned supplement rather than changing original sidecar bytes.

- Original approved .blend SHA256: `d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a`.
- Evaluated-neutral sidecar:1,764,502 bytes, SHA256 `00a81fbcd19c79c578bbbbd7ab077ee6f63048a106c5594675ff208670d5e85e`.
- Derived2k-v2 .blend SHA256: `384ada0c37da16d625b1e6612a0d2f7ca538c29fe0d8dff43a929841ec63fba8`.
- Exporter SHA256: `ba989a303657f2f3855f93c3a7067c1d3e5b536592669c0d54a8a24c5b5ce466`.
- Separate base/evaluated topology report SHA256: `be6032a009602869a92dcb86075e3aaac81a232a6a9bbf8a495108d08f7b19a4`.
- Loop/eyelid supplement SHA256: `55ea3af87ed72ec0761d79bc4e61a77f31be170394b6ce1076cd248665db2619`.

Both the original source binding and derived geometry binding are explicit. The derivative excludes12 subpixel toe-crease curve objects, adds0.006m world-normal clearance to six ivory ear tufts and0.02m to the broad ivory tail tip plus six tail-tip sweeps. These are LOD-worker changes, not quantization effects; the original remains unchanged. Exact changes and stats hash are embedded in the IR.

## New IR contract, not flattening

Schema `ayatsuri-fixed-attribute-ir-v1`, prototype revision2:
- World XYZ in **Blender world metres**, signed32 Q16 or Q20.
- Own-object local XYZ in the same fractional scale. Local XZ is available to the studied eye recipe. No legacy×38 or native-axis conversion is applied. Existing native-basis projection/attribute APIs need an explicit basis adapter; do not feed these arrays under the old native label.
- Per-corner world and local unit normals encoded signed16/divisor32767, with validated encoded length. Independent world/local values are retained rather than assumed interchangeable.
- Source object, evaluated-LOD triangle/polygon and source-LOD vertex IDs retained. Parts retain material identity and original triangle/corner order. No material graph is replaced with constant white/default RGB.
- Original material DAGs, frame/control state, rig rest matrices, base shape arrays, weights and remaining modifier metadata retained in a **deferred high-precision section**. This section is not an implemented integer animation/material evaluator.
- Optional UVQ20 side-stream bound to evaluated triangle corners by the supplemental loop mapping. It is stored separately and is not consumed by the current eye recipe or renderer.

Every geometry coordinate is admitted only within±128m and rounded nearest ties even. Maximum actual absolute world/local component is3.6352384090423584m. Normal source component/unit-domain violations reject; no clipping or silent normalization. For Q20, coordinate code magnitude≤2^27; Q14 convex interpolation MAC≤2^41, safely signed64. Q16 bounds are smaller. Normal MAC≤32767×16384<2^29. These are attribute bounds, not a proof of procedural shader or animation arithmetic.

## Exact vs approximate correspondence

The sidecar's `nearest_source_evaluated_triangle` is only a nearest face-center hint on the original evaluated source. It contains no original corner/loop mapping or barycentric transfer certificate. Largest reported local distance is0.059870000928640366m. We preserve this hint as **exact_correspondence=false** and never use it to transfer attributes or establish visual/source topology equivalence.

The LOD worker separately verified all74 derived base/evaluated vertex counts and triangle-index sequences agree. We verify its hash/source/sidecar binding and per-object order/count/topology statements. That supports base shape/weight index association, not original high-resolution face correspondence. Our independent checks cover the sidecar arrays and supplement, not a fresh Blender evaluation.

UV evidence was initially insufficient:12 objects have UVMap,792 loop entries total, despite an earlier exporter statement that they were absent. The subsequent supplement supplies triangle_loop_indices and loop_vertex_indices. V2 checks all5,946 triangle-corner mappings against the sidecar triangle vertex sequence and validates792 UV corners. UV remains optional data, not a newly implemented texture/coverage path. Q20 UV max component error is4.76837158203125e-7 UV units; no wrap/clamp/address behavior is invented.

Shape Basis and evaluated local position values are not universally identical despite matching topology. The brows differ by up to0.007449984550476074m and0.00967186689376831m; other supplied Basis arrays match here. Retaining base shape deltas does not implement modifier-aware animation, normal updates or equivalent brow motion.

## Degeneracy is authored neutral behavior, not a quantization failure

There are1,982 triangles including36 exact zero-area triangles,18 in each Moving eyelid edge object, **before quantization**. The independent exact-rational test confirms this using stored source numeric values. The LOD worker separately explains these as intentional Blink=0 zero-width bands; its supplement reports Blink.25/.5/1 opens16 triangles per eye while two closed-end triangles remain degenerate. This experiment did not evaluate blink states itself.

All36 are retained with `static_degenerate_domains` tags and their morph/source metadata. They are not dropped, repaired or called invalid authored topology. No runtime admission decision follows from this IR. Orientation comparison is undefined when the source area vector is zero, so those36 are excluded from the orientation-sign test for that stated reason, not hidden from counts.

Among the remaining1,946 triangles, both world and local quantization introduce **zero collapses and zero orientation reversals** for Q16 and Q20. Source cross products and sign comparisons use Python exact rational values of the stored coordinates; encoded cross products use arbitrary-precision integers. This proves the tested3D quantization sign property, not screen-space coverage, dynamic pose validity or preservation of original high-resolution surface geometry.

## Quantitative result and consistency

| Metric | Q16 | Q20 |
|---|---:|---:|
| World max component error,m |7.62939453125e-6|4.76837158203125e-7|
| Local max component error,m |7.62939453125e-6|4.76837158203125e-7|
| Normal/32767 max component error |1.5255705781314077e-5|same|
| New degenerate / reversed triangles |0 /0|0 /0|
| Parts |120|120|
| Partition records |2302|2302|
| Largest part vertices / triangles |32 /44|32 /44|

Global consistent grids preserve identical input world coordinates across parts.559 source-LOD vertices and972 source-LOD edges span part boundaries; no shared-position mismatch occurs.3,144 distinct physical coordinate-edge pairs were checked. There are1,302 distinct exact world positions versus1,322 source vertices; duplicate positions include the intentional eyelid structure. No additional distinct-input coordinate collisions are created at either precision. These checks do not weld vertices or require normals/materials/local coordinates to agree across a legitimate seam.

World/local are quantized independently. The source affine world-vs-local relation already differs by up to1.1920928955078125e-7m from stored matrix arithmetic; using quantized local values to recompute world gives maximum discrepancies1.4066696166992188e-5m(Q16) and8.940696716308594e-7m(Q20). Consumers must use the declared streams, not silently substitute one reconstruction for another.

## Counts and memory: distinguish all layers

- Derived base vertices:1322.
- Evaluated sidecar vertices:1322, topology correspondence supplied separately and verified as above.
- Fully corner-expanded stream:5946 vertices (=1982×3).
- Unique normal/position attribute records before partitioning:1322. No extra normal splits were needed in this actual data.
- Partitioned records:2302, adding980 copies solely due to object/material/32-vertex/64-triangle partition boundaries.
-8-lane padded records:2552 (=319 blocks),250 pad records.

**Audit-layout estimate, not a shipping format:** `64 header +64*P +40*V +8*T` =115,680 bytes. HereP=120,V=2302,T=1982. Each40-byte audit record accounts for worldXYZ12, localXYZ12, world/local normals12 and source vertex ID4. Descriptor bytes7680, vertex bytes92080, triangle bytes15856, header64. Padding each part to8 lanes yields125,680 bytes. Material programs, UV, shapes, weights, transforms, provenance, scene/working memory and allocator costs are excluded.

A separate theoretical minimal-field unpadded expression `64 +64P +26V +8T` gives83,452 bytes for worldXYZ12 +localXZ8 +world normal6. This omits source identity/local normal/localY and alignment; it is **not** the default layout, implemented binary or total memory claim.

**Old AYFQ geometry-only reference:** `64 +32P +8M +144*sum(ceil(Vpart/8)) +4T` withM=12 gives57,864 bytes. This is only a formula comparison. No old AYFQ file is emitted or admitted: its semantics do not support these material/morph/coordinate requirements, and its current source-degenerate rule is unsuitable for simply labeling this authored blink structure.

Optional UV side-stream adds6,336 raw bytes (=792×2×4), before IDs/headers/indexing; it is not necessary for the current local-XZ eye shader. Eye-mask material parts involve451 partition records or215 unique source vertices. Storing localXZ only for those, sharing global positions/source IDs, factoring constant normals/material data or compressing rigid transforms are **design candidates only**, not implemented savings or compatibility claims. Existing renderer APIs are not asserted to accept such layouts.

Actual JSON files are1,411,595 bytes(Q16) and1,427,551 bytes(Q20), dominated by audit/provenance/deferred metadata. JSON size is not target runtime RAM.

## Material semantics remain blocked explicitly

No RGBA vertex attribute exists on these74 exported visible objects; hidden legacy iris gradient assets remain only in the immutable original as declared by the exporter. Do not draw them or invent varying colors. Six visible Blink mask material recipes require local-coordinate color/mask evaluation; the current IR retains their graphs, not a working material implementation.

`material-semantics-binding.json` additionally pins original ramp metadata and the material worker's primary-source audit: Cycles4.3.2 prepares the six-stop ramp into257 RGBA samples, then interpolates that table; Legacy MixRGB clamps its factor even with use_clamp=false. Neither a direct six-segment replacement nor an unbounded factor is silently substituted. Procedural transparency, Principled specular/coat, dynamic controls and animation remain unsupported by the integer consumer.

## Reproduction and tests

`compile_attributes.py` produces initial no-overwrite revision1 exports. `finalize_ir.py` produces final no-overwrite revision2 exports with supplemental bindings. They only read fixed JSON/files and write this independent directory. Existing output files cause failure rather than replacement. Tests: `PYTHONDONTWRITEBYTECODE=1 python3 test_attributes_ir.py`.

Six test groups pass: exact actual-data reconstruction/determinism;1/2/4/8 scalar batching and independent rational nearest-even oracle; seven malformed schema/domain/index/normal mutations plus unsupported precision; newly introduced nondegenerate→degenerate rejection; duplicate/nonfinite/deep JSON; and no-overwrite output. Scalar batching is not SIMD or target-speed evidence. No new appearance, frame, visibility or performance claim is made.
