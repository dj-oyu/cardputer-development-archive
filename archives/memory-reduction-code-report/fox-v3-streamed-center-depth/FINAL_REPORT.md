# Streamed center depth: completed exact validation

Authoritative post-validation report. Frozen pre-actual REPORT.md and all 173 source/evidence files remain unchanged. Source freeze SHA 83e01a018e3f3839d26161b861b20c674b954ccd60f8b8b77332e890634604f0; independent final review SHA d021b53a5c8e8f4272e7638865cc8a0f03f154f011c1c2d597ed31fc4cb06a88.

## Validation result

Completed 40 full-depth diagnostic conditions (world OFF 20 then ON 20) against validated fox-v3-cached-profile-renderer, plus two front-baseline OFF/ON canaries with full-depth capture disabled. The latter retain the HDR observer: they are not pure no-observer product-memory runs. There is no claim of 40-condition validation without full-depth capture.

Retained-output audit passes 208 raw comparisons, 336 strict report comparisons, 42 depth-copy sidecars and 80 forward/reverse comparisons, without audit rerender. RGB565, snapshots, masks and HDR are exact across all 42; complete float depth is exact for the 40 diagnostic conditions. Only predeclared memory/retention, admission and new copy-guard accounting deltas, plus descriptive timing fields, differ. Cache reports remain exact.

New depth copies are explicitly charged: 3840 floats / 15360 bytes per frame for 16 pending rows, and 32400 floats / 129600 bytes per diagnostic frame for capture. Maximum observed combined producer work is 478224, including these copies, under unchanged 637599; maximum AA work is 7804336 under unchanged 8000000. Full 40 cache totals are 1296000 profile calls, 5050454 hits, 133546 misses and zero invalidations; the two extra canaries are reported separately in FINAL_RESULT.json.

## Product storage and stack

Center depth is 8640 bytes instead of 129600, a gross render-phase reduction of 120960. Full private RGB 64800, AA 72512 and caller cache 3224 remain. Named product render is 373552; visibility construction dominates at 442964. Thus overall named peak is 494608 → 442964, saving 51644, not 120960. Largest product allocation remains 72512. Descriptor/report are included in measured caller frames and are not double-counted.

Product main is 83760; named renderer chain 4944 and background 4016/4096. Observer main is 83776. Full-depth diagnostics additionally charge 129600 and HDR 777600 plus 24 control bytes, giving named diagnostic peak 1280792. The no-depth-capture HDR canaries have peak 1151192. RSS is distinct from this named payload/stack ledger. Allocator metadata, fragmentation, runtime/library stacks, target placement and device fit remain unmeasured.

## Historical timing and limits

Fixed 40 wall time was 699.1987s versus historical cached baseline 699.5638s, descriptive difference -0.3651s (-0.052%). These are separate historical runs, not a controlled paired benchmark, and establish no causal speedup or slowdown. The extra no-depth-capture canaries took 16.6056s and 18.2655s separately, excluded from that comparison.

Old full-depth APIs and lifetime contracts are retained. New descriptors are frozen and spans admitted; pending center depth is independent of quarter winner depth. Failure may leave private scratch partial. Source verification, background finish, postchecks and completion markers still protect accepted output; diagnostics may exist on failure and multiple files are not atomic. ASan/UBSan passed; LeakSanitizer was unavailable under ptrace, with no general leak-clean claim.

No device drawing, firmware integration, SDK, model/reference/profile modification, public repository or PR action occurred. Final backup contains differential code/tests/reports, completion metadata and numeric frame reports only; it excludes raw pixels, depth/HDR arrays, snapshots, geometry/model assets, generated LUT arrays and binaries. Restore unchanged dependencies from the completed cached-profile baseline.
