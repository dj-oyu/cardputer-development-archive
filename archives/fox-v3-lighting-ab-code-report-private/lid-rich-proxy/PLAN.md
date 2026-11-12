# Current lid8 actual-geometry rich proxy, seed11 four-case diagnostic

Separate version from prior1166-triangle rich oracle. Actual current geometry is1564triangles/1163compiled vertices/54material partitions from frozen actual-lid8-v2. Four cases front/oblique ×baseline/direction, fixedseed11. Formalv3 references, masks, thresholds and source file remain immutable. One seed is not stability evidence or a60% acceptance result.

## Exact actual geometry and normals

Use captured camera-independent owned-world mesh positions/raw source triangle indices from capture002 mapping, and independently produced old-mode4 canonical bytes (original old API per-record writer) for explicit front AND back SNORM16. Validate canonical bytes equal full mode5 decode and pin both independently. Verify every raw vertex and all1564raw source triangles are represented bijectively in actual packet indices after the compact used-vertex remap; no reliance on a generic mode5 guarantee for unseen/culled vertices. Abort if any raw vertex/triangle lacks this evidence. Match compiled source part positions after nativefloat32 scaling and raw indices exactly; retain54part boundaries/material identity. Across the four views/cases, positions/normal pairs/raw indices must be identical. No unquantized GLB or original sculpt normals substitute for actual normals.

Native→source positions [x,-z,-y]/38; front normal [nx,-nz,-ny] then normalize. determinant−1 requires triangle winding[0,2,1]. Explicitly check all raw front/back integer triples are exact negatives before using Cycles backface normal reversal; otherwise stop rather than invent a normal. Audit all camera physical sideflags against geometric winding and view direction. Recount per-face/per-corner Ng·Ns sign disagreements; do not inherit old21-face count. Custom-normal storage errors and float32 position errors are measured, not silently called byte-identical source geometry.

## Rich scene/material contract

Open original.blend into memory for each case; never save it. Original visible character is hidden only in proxy copies; original ground, world, three lamps, camera, visibility and material datablocks remain unchanged. Reconstructed material partitions reference exact original source materials by pinned material trace name. Preserve all source node sockets/links/RNA material flags, not merely BaseColor. Source linear rho and native565decode rho are recorded separately; proxy uses source material, not a claimed exact native material match. No Lambert substitution or new shader feature.

Camera/source render settings are exactly fixedv3:240×135, source camera placement, ORTHO, Cycles2048 max samples with original adaptive behavior, full original GI/bounces, source floor BSDF+emission, world and3lights, original source clamps, AgX/Medium High Contrast/exposure0/gamma1, BH1.5, dither1, film/background, seed11. Scene/material invariants audited before/after replacement; original source SHA checked before/after. Blender4.3.2/installed config provenance retained.

## Controls before proxies

Render ORIGINAL source at seed11 for all four view/cases first. Require decodedRGBA8 and every nonvolatile PNG chunk exactly match corresponding fixedv3seed11 files (only known render-time/date metadata ignored), before any proxy render. Reference PNGs are control/analysis only, never native shader inputs or fit targets. Enable required diagnostic passes without changing lighting; original same-seed PNG control verifies this path.

Then render four rich proxies, ordinary Combined PNG through identical source display/output path. Save multilayer32bit EXR from the same Render Result:Combined,DiffDir,DiffInd,DiffCol,GlossDir,GlossInd,GlossCol,Emit,Environment,transmission andvolume when available. Report DiffDir×DiffCol,DiffInd×DiffCol,Gloss terms,Emit and residual R=Combined−sum(all available additive reconstructed terms). Retain negative/residual values; do not silently force recomposition or label residual a specific physical component. Pixel-filter averaging means product of filteredpasses need not equal filtered product. Alpha/coverage and filter mixing are distinct from center-ray geometry correspondence.

## Analysis and scope

One-seed proxy images can be compared descriptively with fixedv3 seed11/source and native current output, with full foreground, unchanged stable/uncertain diagnostics only; do not create stability masks, tune an exposure/gain, or claim60% completion. Rich source GI/BSDF/material rho/clamp/filter/display differs from native; isolate these limitations explicitly. Source/native center-ray correspondence is a separate audit task; no lighting rerender or inference from source RGB is used for geometry selection.

Before rendering, reviewer closes restoration and invariant contract. No original writes/publication/PR/device/default changes. Code/report/aggregate metrics/cost/hash allowlist only; proxy geometry, source scene, raw EXR/arrays/PNGs excluded from bundle.
