# Synthetic depth-band tests

Run from the workspace root:

    sh fox-v3-depth-bands/test-depth/run_depth_tests.sh
    python3 fox-v3-depth-bands/test-depth/run_depth_adapter.py
    ASAN_OPTIONS=detect_leaks=0 SANITIZE='-fsanitize=address,undefined -fno-omit-frame-pointer' SUFFIX=-san sh fox-v3-depth-bands/test-depth/run_depth_tests.sh
    ASAN_OPTIONS=detect_leaks=0 python3 fox-v3-depth-bands/test-depth/run_depth_adapter.py --sanitize

All tests use synthetic geometry. No actual frames, public push, device, SDK, model or reference changes.

- Exact: 40 cases, full 135-row RGB/depth bit comparisons, mask/AA/scene/HDR reports, callback digests and a combined event-order digest. Includes all five band boundaries, tail, nohit, screen edges, max source IDs and forward/reverse submission. Only the exact core RH_ADMISSION 120→210 change is whitelisted. Other report fields are bitwise equal.
- Core negatives: 313 cases. Exact lengths, alignment, null/overflow, each band pair, all declared old spans and both crossing edges, resolver-owned bands and descriptor; admission failure preserves scratch/output and previously complete reports while returning false. Allocation failure at each of five calls cleans all earlier allocations and does not make a sixth contiguous fallback request. Runtime profile failures at first/middle/final output allow scratch mutation; independent committed copies remain untouched. Late target-mask verification also fails.
- Bridge negatives: derived synthetic adapter checks exercise RowRenderBands admission, floor-world overlap against all 28 spans, each band against visibility/bounce owned scenes, descriptor and identity bytes. Final verification rejects snapshot/identity mutation, generation mismatch and exhausted hash budget without changing RGB or depth bands. No physical shader calls.

Publication scope: these tests exercise false-return gates and independent prior committed buffers, not filesystem publication of an actual native render. They do not claim runtime scratch rollback. Direct bridge finish failure may leave old complete report flags, so the returned false remains authoritative.

LeakSanitizer is explicitly excluded with detect_leaks=0 because this environment's ptrace restriction prevents LSan execution. ASan and UBSan remain enabled; no leak-coverage claim.
