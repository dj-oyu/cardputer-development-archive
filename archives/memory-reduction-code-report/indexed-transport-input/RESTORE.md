# Private code and evidence restoration

Base: completed fox-v3-compact-transport, immutable fixed40. Copy its code, harness and private-build locally, then overlay only AGGREGATE_CODE_ALLOWLIST code files. Baseline source/model/profile/reference assets are intentionally excluded; this archive is not standalone. Keep original completed trees untouched. No public publication, device or new-SDK authority is implied.

Build with harness/build_adapter.py (observer) and --no-observer (product), then harness/stack_manifest.py with and without --product. These compile only. Synthetic scripts are test-independent/run.py, test-independent/run_caller.py, review-independent/run.py where present, and harness/run_adapter_tests.py with optional --sanitize. Review scripts are read-only except their result reports. Existing input paths are provenance, not instructions to retrieve unpublished assets.

Actual rendering requires a newly verified explicit gate. The retained gate/results document the original fixed40 only and are not authorization to rerun. Do not reuse, overwrite or retry existing actual output directories. Five ancestor actual runners intentionally fail closed. The dedicated indexed runner checks the source freeze, executable, compiler stack records, completed baseline pins, review and parent gate before and after each case. It allows only declared timing fields and transportTemporaryBytes100224 to35868; every other report/raw byte remains exact.

For restored source edits, create a fresh independent candidate, repeat applicable tests and stack accounting, and obtain a new review/gate before actual runs. Do not alter the frozen completed evidence.
