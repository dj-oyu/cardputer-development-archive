# Compact BVH construction prerequisite
Final source is frozen in SOURCE_FREEZE.json. No actual renders performed; independent review and explicit parent execution gate required.

Only production change is construction in private-build/visibility/visibility.c. Public header unchanged. Runtime suffix beginning vis_binding_set byte-identical to completed center-id-ring. Final scene remains owned xyz, 8-byte index/ordinal records and unchanged64-byte nodes. Cache24n is freed before atomic publication. Allocation order/failure stages remain five, old retained generation behavior unchanged.

## Validation
Fresh24 inherited cases PASS: capacity, visibility, nearest, brute force and v2/v3 semantic traces under O0/O2 with and without ASan/UBSan. Capacity tests retain4096 exhaustive builds across n1..2048, exact requested allocations, five injected allocation failures, unchanged old scene/retains, poisoned frees/borrowed inputs, degeneracy/invalid/generation/alias/capacity guards. Expected values updated explicitly to24n, not removed. Allocation balance ends zero. Leak sanitizer disabled for environment; tracked allocation checks remain.
Adapter91 negative admission cases plus2 prefix cases pass plain and sanitized, zero physical shader calls/actual frames.
Independent reviewer PASS: 544 cases, exact162211176 serialized bytes old/new each at O0, O2 and O2 ASan/UBSan, covering ordinary/ties/signedzero/extremes/invalid cases and query counters. Candidate visibility.c SHA256 begins8eb08314; independent report retained separately.

## Signed-zero correction history
Initial direct scalar xyz loads in build_bounds failed O2 byte differential (baseline hi.z negative zero versus candidate positive zero). No zero canonicalization used. Reinstating original p[3][3] memcpy gather shape and nested fmin/fmax fixed the comparison. Equivalence is for tested same compiler/flags/optimization modes, not a promise of cross-compiler/device bit identity; baseline itself differs across optimization modes.

## Memory and work
Actual-shape n1566 temporary125280 ->37584, saving87696. Persistent106104 unchanged. Builder-local largest125280 ->65472. Global pipeline largest allocations remain unchanged. Maximum n2048 temporary49152; v4096 persistent180256 and builder peak229408. Actual-shape builder peak143688, replacement with retained prior scene249792.
Named host build stack336 +10*192 +176=2432 vs2096, +336. Visibility phase505824; unchanged transport construction520152; unchanged render568880 is overall named peak. Overall named reduction593184 ->568880 =24304. Excludes libc/libm/allocator metadata and unnamed state. No device fit claim.
Additional construction gathers15660 triangles /140940 double loads for n1566;20480 triangles at n2048. No runtime gather/arithmetic/counter changes.
Synthetic O2 build CPU medians: old0.002516560s, candidate0.002241325s per build,7 alternating batches of200, same synthetic n1566/v1167 fixture. Descriptive host-only numbers, not actual-scene/device speedup.

## Execution preparation
harness/run_compact_actual.py pins completed center-id-ring same arm/order and all runtime inputs. Checks raw5 buffers and all7 non-timing reports exactly; only timings excluded. Existing visibilityTemporaryBytes46800 means caller geometry and remains truthful/unchanged; internal construction allocation is separately asserted via API and ledger. --prepare completed without rendering. Execution requires new matching approved gate and runner review. No inherited gate copied.

Observer-free build-product also built successfully without executing. Comparing emitted .su to completed baseline: all runtime entries unchanged; only build_node176 ->192 and new build_bounds176 differ. Independent reviewer artifacts copied into review/. GATE_REQUIRED_HASHES.json is a non-authorizing template for parent gating.
