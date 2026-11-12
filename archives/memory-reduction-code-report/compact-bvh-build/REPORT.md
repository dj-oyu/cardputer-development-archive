# Compact BVH construction result

Fixed40 completed: OFF20 and ON20, each same arm/order against completed center-id-ring. All200 raw buffer comparisons are byte exact; all non-timing reports, query budgets/counters and forward/reverse checks match. No retries or overwritten output. Independent retained-output audit, prerequisite code and runner reviews all passed.

Only the BVH constructor changed. A24-byte center cache indexed by original ordinal replaces80-byte build records, and the final8-byte triangles are sorted directly. Owned xyz, node/triangle bytes, public API and runtime traversal/ownership remain unchanged under the tested same compiler/optimization flags. Initial scalar gather signed-zero mismatch was caught and fixed by restoring original p[3][3] gather shape. No canonicalization or quantization.

Memory, at the tested shape1566triangles/1167vertices:
- Construction-only buffer125280 ->37584 bytes, saving87696.
- Persistent visibility scene106104 bytes, unchanged.
- Builder-local largest allocation125280 ->65472 bytes. No global pipeline maximum-allocation reduction claim.
- Named host recursive builder stack2096 ->2432 bytes.
- Visibility construction phase505824; unchanged transport construction520152.
- Render568880 is now the overall named peak, down from593184 by24304bytes (~4.1%). Render memory itself is unchanged.

These are named host requested-byte/stack measurements, excluding allocator metadata/fragmentation, libc/libm stack and unnamed state. Not a device-fit claim. CPU observations are synthetic host-only; no actual-scene/device speedup is claimed.

Validation:24 inherited O0/O2 plain/sanitized test cases, including4096 exhaustive-count builds per capacity test, allocator fail/poison/ownership tests;93 adapter negative/prefix checks plain and sanitized; independent544 synthetic cases with162211176 exact serialized bytes per O0/O2/O2san comparison. Public builder-only checkpoint is separate from this private whole-pipeline validation; parent tracks publication evidence.

See FINAL_RESULT.json, MEMORY_LEDGER.json, PREREQUISITE_REPORT.md, SOURCE_FREEZE.json and review/. Actual outputs and private inputs are excluded from code/report persistence allowlist.

## Final independent closure and persistence

Retained-output independent audit passed200raw,280report and80forward/reverse comparisons; no duplicate render. Review FINAL_REVIEW.json SHA25641de02c8522b115dacf48f2b3ee919a08e8fae68294a1e374387dd5b8f8681d9. Source, binary, compiled stack, execution gate and fixed reference/runtime input pins were verified. Actual40 used diagnostic HDRobserver; observer-free candidate was built/synthetically checked, not separately rendered40times. Exact output carries forward the old quality results and their limitations, not a new global60% goal or device-fit claim.

Generic builder/test/README only published on work/renderer-host-kernels-20261104 commitaba669858ab8b813b67ce5831f5d86086b3e0ca3. Fullremote10file content hashes verified; main unchanged. No PR/merge/device; CI checks/runs absent, not passed. Public checkpoint excludes original models, images and geometry and does not integrate the private renderer into firmware.
