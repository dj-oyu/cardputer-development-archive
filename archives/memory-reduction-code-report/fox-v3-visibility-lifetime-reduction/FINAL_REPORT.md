# Visibility lifetime reduction: completed exact validation

Authoritative post-validation report. All187 frozen source/evidence files and the pre-actual REPORT.md remain unchanged. Source freeze SHA 6c3e91af1b47fce6503cdd41b725f1cda93f3e3b57846c56e6cd0de0817cdc65; independent final review SHA 5a5b90aec6684cad89f56ba6e0a0a3d608c40f25b02f26baef9154a369ea7bf3.

## Result

Completed40 full-depth diagnostic conditions and2 no-depth-capture HDR canaries against the matching streamed-depth baseline. All208 raw comparisons,378 strict existing reports (including42 depth-stream reports), and80 forward/reverse checks pass. Zero semantic exceptions, retries or rerenders. There are no new lifetime sidecars. Full-depth equality applies to40 diagnostic conditions; both other canaries retain HDR observation, so neither a40-condition no-depth validation nor a pure no-observer product execution is claimed.

Maximum combined producer work478224 remains below unchanged637599. Existing renderer/AA/work caps and all non-timing report fields are unchanged.

## Storage and implementation

The only product-code change is private caller ordering: serialize snapshot first, copy original-order geometry and transport attributes, then dispose and release model storage before visibility construction. Snapshot geometry never substitutes for uncullled original source geometry. Disks and ground retain their original late lifetime. No new storage, kernel, model API or public-export implementation is introduced;84 kernel files are unchanged.

Cold47708 + model payload81796 + owner912 =130416 bytes no longer overlap construction. Whole named peak is442964 →373552, saving69412, with render now dominant. Visibility build312548, transport254788, background220616, conservative preparation237304, geometry extraction299316 and early release296876 remain below render. Product and observer main frames are83760; renderer4944 and background4016/4096 are unchanged. Largest product allocation remains72512.

These are named payload and compiler-stack figures, not process RAM or device fit. Diagnostic full-depth adds129600 and HDR adds777600 plus24 control bytes. Named diagnostic peaks are1280776 with depth and1151176 without; observed process RSS is separate. Allocator overhead, fragmentation, library/runtime stacks and target placement remain excluded.

## Validation and limits

Fresh exact synthetic, admission/prefix and lifecycle tests pass plain and ASan/UBSan. Real mode4/mode5 codec serialization survives poison/free of all synthetic source inputs. Exact extracted lifecycle boundaries test five real builder allocation failures, dispose failure, earlier failure and nonvisibility fallback. Boundary publication uses a surrogate plus source-order checks, not full-native failure integration.

Original process-return failures remain process-return failures, not a general unwind API. New early-dispose failure releases copied input arrays; successful paths dispose once. Builder failure after early release cannot reach accepted output publication. Later failures may leave diagnostic files or partial private scratch; no atomic multi-file publication or general leak-clean claim is made. LeakSanitizer remained disabled under ptrace.

Fixed40 diagnostic wall time702.4118s versus historical699.2s is descriptive only, not a controlled paired comparison or causal speed claim. Full42 wall time738.4169s includes two extra canaries and must not be compared with historical40.

## Evidence and delivery

Intermediate v29 had valid outer checkpoint hashes but stale nested prerequisite SOURCE_DELTA evidence. The evidence-only ordering fix and independently verified v30 supersede it; historical manifests remain labeled superseded. No caller/kernel change or actual execution occurred before that correction. The187-file replacement source freeze remains authoritative.

Final private backup includes differential code/tests, aggregates, completion metadata and378 numeric frame reports. Raw pixels, depth/HDR arrays, snapshots, model/geometry assets, generated LUT arrays, binaries and per-frame command/input records are excluded. Restore from completed fox-v3-streamed-center-depth. No device, firmware, SDK, public repository or PR work occurred.
