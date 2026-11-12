# Receipt rotation preflight fix

Base: dj-oyu/esp-device-broker-mcp main, dbbad4a05247b71d84552535d54407bc5ea9be2d.
Status: isolated local proposal, no commit/push/PR/deployment or live broker/device access.

## Confirmed defect

Three new synthetic filesystem/SQLite regressions failed on the unmodified base: receipt evidence disappeared after low disk with full payload capacity, low disk at the later fetch check with available payload capacity, and protected-payload admission rejection. Existing baseline lifecycle tests passed (28 tests). The baseline failure log is included.

## Changes

- src/cardputer_mcp/source_payloads.py: select the entire oldest-first receipt rotation without deletion; keep exact bytes bounded by the existing evidence-byte budget; project freed receipt bytes into total capacity checks; recheck liveness, protection and complete references at each deletion; restore exact bytes on caught errors without overwriting unexpected content.
- src/cardputer_mcp/source_snapshot.py: carry the planned rotation through all capacity/disk checks and successful pending reservation creation; rotate only afterward; hold rollback callbacks inside the cache write guard until successful publication and pending cleanup.
- tests/test_source_rotation_transaction.py: 11 regression/fault-injection tests.

No ownership, protection, quota, authentication or reference-completeness checks were relaxed. Current-LKG, unfinished-job and executable-plan protections remain in the existing retention path. No real cache or receipt data was used.

## Guarantee and boundaries

Receipt evidence is not deleted on admission/preflight failures, including initial or later disk rejection, insufficient protected-payload capacity, and failed pending reservation. After rotation starts, exceptions before successful _fetch return trigger exact-byte restoration, including partial sequential deletion, newly protected receipts, cancellation and download failure. Existing data is never overwritten to force restoration. Rotation/deletion or restoration errors conservatively mark the cache uncertain and report source_cleanup_unconfirmed.

This is not a durable filesystem transaction. Process termination, machine/storage failure and a failed restoration can still leave partial receipt state. Restoration failures remain fail-closed. The rollback commit point is successful _fetch publication/cleanup while holding the write guard; later lock-release errors or durable broker job-success rejection are outside this transaction. Existing payload/pending reclamation is not rolled back, so a failed fetch may still have reclaimed an eligible payload while retaining its receipt. The patch does not promise preservation of payloads or atomicity with broker job finalization.

Retained rollback receipt bytes are capped at EVIDENCE_BYTES (128 MiB); ordinary file-read validation also allocates temporary receipt buffers, each individually bounded by 32 MiB. An oversized rollback selection fails closed before deletion rather than raising quotas.

## Verification

Existing preinstalled Python 3.12.14, pytest 9.1.1, Pydantic 2.13.5, filelock 4.0.9, Ruff 0.16.10 and mypy 2.4.0 were used. No packages were installed. This is not a frozen-lockfile validation or native Windows/device validation.

Commands (PYTHONPATH=src; existing environment interpreter):

- python -m pytest -q tests/test_source_lifecycle.py tests/test_source_history_retention.py tests/test_source_snapshot.py tests/test_source_cache_guard.py tests/test_source_resources.py tests/test_source_receipt_model.py tests/test_source_rotation_transaction.py tests/test_source_http.py tests/test_source_preflight.py
  - 116 passed, 68 subtests passed (6.91 seconds).
- ruff check src tests: passed.
- ruff format --check src tests: passed, 385 files already formatted.
- python -m compileall -q src tests: passed.
- git diff --check: passed.
- git apply --check receipt-preflight.patch against a clean archive of the base: passed.
- mypy src: blocked by 3 missing-import errors for joserfc/joserfc.errors/joserfc.jwk in gateway_oauth.py. Clean unchanged base produces exactly the same 3 errors; no additional errors in the modified tree. No dependency substitution or type-check suppression was applied.

Independent read-only review found and reproduced a projected total-cache-byte accounting regression in the initial proposal. Corrected it and added a tight-byte-budget success test preserving a protected payload. Final independent recheck reported no remaining blocking findings; 42 targeted tests and targeted Ruff passed.

## Artifact

receipt-preflight.patch includes both modified source files and the new test file. Apply to the exact base above. Included logs distinguish original failing regressions, final source suites, lint/format and baseline/final type-check limitations. No push, PR, commit or deployment has been performed.

## Authorized publication follow-up

Published the unchanged reviewed tree on dedicated branch `fix/receipt-preflight-20261105`.

- Remote commit: 85ca08ed1d8ab36d4f46a82b094f0b93cb0f0941
- Remote tree: ff69558c5a5304b95f337ed7a10e6cd8614391d9 (identical to locally tested tree).
- Parent/main remained dbbad4a05247b71d84552535d54407bc5ea9be2d.
- Commit: https://github.com/dj-oyu/esp-device-broker-mcp/commit/85ca08ed1d8ab36d4f46a82b094f0b93cb0f0941
- Normal shell push failed before publication because HTTPS Git had no username/credential helper. The connected GitHub plugin published the same tree through Git objects and a new branch, without configuring credentials, force-updating or overwriting an existing branch. The connector-generated commit metadata differs from the local commit; file tree and parent match exactly.
- Exact published commit had zero workflow runs, zero check-runs and no legacy statuses when checked at 2026-11-05 15:58 UTC. This is no CI execution, not CI success. Current workflows run on PRs, main pushes, tags or explicit dispatch, not this feature-branch push. No PR, dispatch or workflow modification was made.
- No merge, deployment, restart, live data cleanup, quota/security change or device action.
