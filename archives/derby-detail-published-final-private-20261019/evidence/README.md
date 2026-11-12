# Evidence index

Current results are in `FINAL-PUBLISHED-CI.json` (29/29), `PROOF-REPAIR-PUBLISHED.json` (three final heads), `FINAL-CI-TARGET-RECEIPTS.json` (six actual ELF/BIN mode proofs), `FINAL-HOST-CI-LOGS.json` / `final-ci-host/` (ten completed host job logs), `FINAL-LOCAL-CHECKOUTS.json` and `FINAL-PUBLICATION-TARGET-REVIEW.md`.

`FINAL-HOST-STATUS.json` records the earlier twelve local runtime runs at the clean-exit candidate heads. Its CI flags are historical; the separate final CI receipt supersedes them. `FINAL-CI-PROGRESS.json` records an earlier in-progress snapshot, not the final outcome. The latest outer REPORT.md identifies all exact heads and limitations.

`CLEAN-EXIT-PUBLICATION-BLOCKER.json` / `...RETRY-BLOCKER.json` are preserved historical denials. `CLEAN-EXIT-PUBLICATION-RESOLVED.json` and the final published ledger record their resolution after explicit user approval. No current publication permission is pending.

`CI-FAILED-*.log` are the earlier symbol-proof failures. `FINAL-CI-CONTRACT-DOWNLOAD-FAILURE.log` and `FINAL-CI-CONTRACT-RETRY.json` retain the one transient download failure and targeted retry. `final-published-restore-first-failed.log` retains the initial helper error; `final-published-restore.log` and `final-restored-proof.log` show the corrected helper's successful offline reconstruction.

The earlier full source/host/device evidence, old complete raw hardware failure, normal PR19 partial acceptance, restoration dependencies, and Library receipts are nested in `../prior-clean-exit-final.zip`. Those immutable reports describe their own earlier dates. This archive's REPORT.md is the current handoff.

`FINAL-SOURCE-CAPACITY.json` and `FINAL-DEVICE-IDLE.json` record the remaining source preflight hold and read-only API state. They do not authorize source/build/flash or qualify hardware.
