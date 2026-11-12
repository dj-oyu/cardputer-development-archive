# Private code and aggregate evidence

This bundle is the isolated floor-world reflection experiment only. It does not contain source geometry, compiled user models, snapshots, images, raw HDR/depth/RGB, quarter-sample records, LUT data or executable binaries.

REPORT.md summarizes the completed fixed comparison and remaining limitations. GATE_REPORT.md records the state before full captures. The analysis report and compressed exhaustive aggregates are in analysis-code/analysis-001. RESOURCE_SUMMARY.json and STACK_RESOURCES.json keep runtime cost separate from diagnostic observer memory.

Renderer/source/input hashes and completed capture/composition hashes are retained for traceability. Reproduction needs the unchanged private baseline inputs in their recorded workspace locations, which are deliberately not bundled. Tests and public source changes are retained; private inputs must not be replaced with source/reference data from another experiment.

BUNDLE_MANIFEST.json contains the exact allowlist, byte sizes and SHA-256 digests of each retained file. The ZIP is private/local only; this step does not upload it or change the renderer default.
