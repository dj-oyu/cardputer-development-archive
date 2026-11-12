# Independent indexed floor-world integration gate review

PASS for parent consideration of the pinned canary/remaining-case render gate. No actual model frames were rendered by this reviewer.

The four transport source files exactly match the completed floor-world term. Visibility C/H exactly match the completed indexed implementation. All 121 baseline pins are intact. The only row-core change is the compile-time diagnostic observer.

Independent isolated O2 and ASan/UBSan runs passed: physical/transport regressions; row OFF parity against completed indexed and row ON parity against completed floor-world transport; observer OFF/ON exact raster/depth/mask/report/counter/budget parity; 91 adapter negatives; 2 prefix-preservation negatives; 63 producer negatives; nearest/brute-force visibility regressions; 41 additional analytical physical cases per mode. Additional observer lifecycle, address, duplicate, invalid-value, incomplete-output and exact dump-size checks passed. Full indexed capacity 24 was not independently rerun.

The new mutable world ledger adds one live span: 24→25 spans and 276→300 pair checks. Source-dispatch accounting is explicitly bounded at 731 under the retained 1024 reservation, with unchanged total producer cap 637599. Predicate kernels remain opaque semantic dispatches, not CPU-free or instruction-count claims.

Named stack sums and their final hashes pass: background 4048/4096, renderer 4976/8192, main 83616 (+160). The 104-byte world ledger and 32-byte context increase are included in the main frame, not added twice. Observer-free named render memory is 628192 bytes excluding named RO; diagnostic is 1405816, including an explicit 777600-byte buffer and 24-byte control. Including named RO, totals are 2290608 and 3068232. The product binary has no observer symbols.

The v2 runner requires exact final HDR and AgX against completed floor-world outputs, matching indexed depth/mask/snapshot, old counters except documented additive work, and fail-closed completion. Forward ledger equals completed old-host forward evidence. Reverse order has different legitimate intermediate shade/hit counts; it uses matching indexed reverse counts and exact local work/query/partition/traversal identities instead of a false forward-ledger equality. Fixed 20 combined-ray prediction peaks 9134101; additional reverse node/triangle totals are unknown until execution and cannot justify raising caps.

Two pre-render findings were resolved: the reverse-ledger validation contract, and a stale test-only stack-file hash after expanding alias tests. Final numerical source and binaries did not change. The explicit guard-bound documentation was also added.

This is a bounded new integration review, not the stopped context/paged review, a general security certification, actual-frame completion, legacy 8M admission, device fit or speedup proof. Diagnostic full-HDR storage must remain separate from product-candidate accounting.
