# Ground source extraction and emission-sidedness fixture

Read the unchanged original source blend and fixed v3 configuration. Extract evaluated Studio ground mesh world vertices and Blender calc_loop_triangles order/winding/normals, unlinked Principled Emission Color times Strength, material flags and source hashes into private inputs/ground-source.json. The geometry JSON is never bundled.

Inspect and execute only the frozen reference renderer's exact per-material Base Color scenario assignment on in-memory materials, independently recording all five cases. Verify whether emission changes rather than assuming albedo affects emission.

Independent auxiliary Blender scene: copied source ground material on the same finite evaluated plane, zero world, no lights or other geometry, orthographic 32x32 camera above and below its geometric normal. Render uncompressed float32 multilayer EXR Combined and Emit with Cycles, 64 samples, fixed seed11, no denoising/adaptive sampling, eight threads. Compare fixed central16x16 RGB to source Le using a preregistered 1e-6 absolute tolerance. This measures front/back emission directly; material culling flags alone are not treated as evidence.

Original source and reference/config/code hashes checked before/after. No source saved, native renderer modifications, fitted values, image inputs to native, public output, upload or device use. Extraction is read-only; fixture starts after this plan is sent to reviewer. Eventual bundle permits code/tests/metadata only, excludes private ground mesh and source images.
