# Execution handoff (not authorization)

Do not run an actual command until the approved gate and all frozen hashes verify. Preparation and unit tests do not grant authorization.

Run once, strictly in this order:

1. python comparison/run_fixed40.py off canary
2. Review successful canary artifacts and acceptance, then python comparison/run_fixed40.py off remaining
3. python comparison/run_fixed40.py on canary
4. Review successful canary artifacts and acceptance, then python comparison/run_fixed40.py on remaining
5. python comparison/run_fixed40.py off production
6. python comparison/run_fixed40.py on production
7. python comparison/audit_fixed42.py

The final two stages mean no full-depth observer, not absence of all observation. The same adapter still retains its HDR observer. Only the separate product build establishes no-observer stack/payload accounting.

A failure preserves artifacts and stops. Never overwrite existing attempts or silently retry render commands. Audit imports the runner's validation functions but launches no process.

The gate must have status INDEXED_BOUNDS_FIXED42_APPROVED, actualFrameLimit 42, authorFreezeApproved true, independentReviewApproved true, safetyGO true, and SHA256 bindings runnerSHA256, comparatorSHA256, contractSHA256, baselinePinsSHA256, planSHA256, sourceFreezeSHA256, reviewSHA256, runnerReviewSHA256, buildSHA256. additionalRequiredFiles must bind MEMORY_LEDGER.json and maps every independent synthetic/failguard/memory/stack proof needed for safety to its root-relative path and digest. The gate is created only by the parent after author/reviewer approval, never by this preparation script.

All frame reports, raw files and sidecars remain private. Execution metadata is separate from output completion manifests. Stdout report stays .stdout-pending until validation and freeze recheck succeed. A failed adapter can leave partial output; there is no multifile atomic-output or general leak-clean claim.
