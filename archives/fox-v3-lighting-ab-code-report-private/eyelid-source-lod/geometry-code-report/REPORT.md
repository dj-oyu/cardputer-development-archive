# Fixed source-ring upper-eyelid candidates: construction complete

Exactly the authorized8/9station candidates were generated from eyeB. No extra geometry variant, image fitting, codec change, partition change, face-order rescue, rendering, publication or device action was performed by this construction task. The frozen PLAN.md remains the pre-generation record; this report updates its status.

| Candidate | Character triangles | Changed lid vertices | Source-ring construction | SHA256 |
|---|---:|---:|---|---|
| lid-8.glb | 1564 | 96 | 8 stations ×6source points ×2lids | 833ac7683872375f9e63f819618e0e25ed40e0ac761a35f7604cd45501207a8e |
| lid-9.glb | 1588 | 108 | 9 stations ×6source points ×2lids | 5e7ab10cf89a5cc79274e50cb83472f6086cd075de2743c81629a95fd051c5d8 |

The source-only greedy ring selection was recomputed from the original evaluated ring centers and exactly matched the frozen plan for both sides. Every output vertex position and its unique original corner normal match the selected source vertex byte-for-byte after the existing glTF axis transform. No normalization, vertex interpolation, phase optimization, reflection or endpoint-center displacement was applied. Source normals are retained, not regenerated.

Each tube remains uncapped with two6-edge boundary loops, connected cylinder topology, consistent interior winding and no zero-area face. Minimum geometric/source-normal dot is approximately0.78142 for8stations and0.83931 for9. Six-sided endpoint boundaries are lower-density approximations of original12-sided rings; their complete boundary shape is not claimed identical.

Both candidate files preserve the entire eyeB binary buffer as a prefix. Only the two Upper eyelid primitive accessor references are replaced by appended streams. Every unrelated mesh/accessor/bufferView/normal stream, node and material/sidedness value remains unchanged, including six eye ellipsoids, sockets, glints, cheeks and Smile. Original blend and eyeB files retain their pinned hashes.

Geometric planning results remain unchanged: maximum finite sampled surface distance≈0.013138/0.006627 for8/9stations, minimum section width≈0.0225166 versus original≈0.0251139. These are finite source-shape diagnostics, not continuous error guarantees or claims of visual improvement.

Actual compile, codec-record eligibility, snapshot/work/visibility/transport caps and full-scene visual/ordering evaluation are delegated to the parent evaluation task. Forecast snapshot64196/64868B is not measured admission. In particular9may exceed capacity if new records fall back. Candidate paths/hashes were delivered directly to the actual evaluator and the independent artifact reviewer. No result is selected here until those tasks establish their outcomes.

Evidence: build-report.json, build.py, frozen PLAN.md/CONTRACT.md, final-plan-summary.json, preflight-topology.json, source-normal-audit.json. Exact source-index maps and raw source coordinate/normal arrays remain private. bundle-allowlist.json excludes GLBs, original/control-point arrays and correspondence maps. Independent construction review PASS: source POSITION/NORMAL float32 bytes, independent greedy selection, uncapped boundaries/winding/Euler/NgNs and unchanged non-lid streams were verified. Evidence: independent-construction-review.json.

Parent-reported actual append update: lid8 uses64208B in54records; lid9 uses64892B in55records. Both append within65536B. Formal rendering is still in progress; these figures do not establish all-condition quality or full runtime admission. Independent geometry review also confirms both candidate hashes and the entire31744-byte eyeB buffer prefix unchanged.
