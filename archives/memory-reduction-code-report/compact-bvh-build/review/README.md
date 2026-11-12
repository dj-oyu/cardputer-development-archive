# Independent compact BVH build review

Run `./run.sh` from this directory or workspace. It compiles a standalone synthetic generator against completed center-id-ring and candidate visibility.c, compares their serialized owned xyz, ordered triangles, BVH nodes, scalar counts, query results and counters. No model data is required or read. `REVIEW.json` records scope and results. `results.log` records hashes.

Found and repaired during review: scalar coordinate gathering changed signed-zero fmax results at O2. Candidate now retains baseline p[3][3] memcpy gathering expression shape. The baseline itself differs between O0 and O2, so comparisons intentionally pair matching optimization levels, without numerical normalization. This is a host compiler guarantee tested here, not proof for different compilers/flags.

ASan/UBSan passed. LSan cannot run under this environment's ptrace; the reproducible script sets detect_leaks=0. No claim of leak-sanitizer coverage.

Additional construction work is explicit: 15,660 repeated triangle bounds at n1566 (140,940 double-coordinate loads), or 20,480 at n2048 (184,320 loads), beyond the original once-per-triangle initialization. Every median level scans all n triangles and maximum depth is 10 nodes. Sorting comparator/key order is unchanged; moves shrink from80-byte to8-byte records while centroid lookups become indirect. Runtime query functions are unchanged. Compiler stack measurements add336 bytes to conservative depth10 builder call-chain sum; memory savings remain87,696 requested heap bytes and must not be presented as a reduction in the overall largest allocation.

No actual-render gate is issued here. Parent owns that decision after merging worker's inherited-suite/accounting results.
