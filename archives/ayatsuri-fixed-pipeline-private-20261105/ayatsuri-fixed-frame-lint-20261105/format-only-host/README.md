# PRIVATE formatting-only host regression check

PASS. This isolated mirror splits statements at exactly two reported misleading-indentation boundaries. No C token, operator, predicate, constant, loop scope, API, admission rule or arithmetic order changes. Original frozen folders remain unchanged. No warning suppression, renderer/visibility operation, device action or publication is involved.

## Exact changes

1. normal_bridge.h: split the normal-output loop's final assignment and return onto separate lines.
2. compact.c: split the checked q20 narrowing return, following local assignment and loop closing brace onto separate lines.

minimal.patch is the complete diff. source-proof.json records literal before/after replacements, original/derived SHA256, nonwhitespace SHA256 and lexical-token/preprocessor-directive equality. Every other mirrored source, header, generated table, fixture, build script, native test and Python verifier is byte-identical to its frozen original. Real private profile data is copied only locally for the unchanged tests; no fake profile or ABI/header stub is used.

Formatted-source SHA256:
- compact.c:8c3667bf72435894b718b8dade34dd7fd17faa965fb3c51edb5d58bd74c024fe
- normal_bridge.h:06ab979ded0f86ed49ee14d010b3426f7488c6725155ffdad1a108556d52c768

Nonwhitespace fingerprints, identical to original:
- compact.c:48c4a2e40b2c9f738c698403cff78e59a73da649466ca29f880b4ae42e50d1cb
- normal_bridge.h:40642b4f4d25279e203ebde816671d4852230c137e7571b11b0f968ed48821a5

A target derivative may choose different indentation; compare these exact replacements or token/nonwhitespace identity rather than assuming its byte hashes match.

## Regression results

The original compact build.sh, test_native.c and verify.py run unchanged inside the mirrored relative directory layout with the original host flags. All Q16/Q20/Q24 full source-fixture comparisons and independent wide-integer oracle checks pass. Per Q,4,473 four-slot groups succeed and1,107 nonopaque groups reject unchanged. Existing widths1/2/4/8, final-lane invalid/nonopaque rejection, output atomicity and boundary tests remain intact.

All six O0/O2 ASan+UBSan executions pass. Original results.json, admissions.json and examples.json match their rerun counterparts byte for byte. More strongly, all three standalone host compact-q16/q20/q24.so libraries are byte-identical to the frozen binaries; runtime-comparison.json gives their hashes. The earlier111-file audit and50-file compact inventories also verify unchanged.

A separate host syntax-only diagnostic probe with `-Wall -Werror=misleading-indentation` passes at all three Q values. This adds no warning suppression and does not change the regression/runtime compilation flags. Empty misleading-q*.log files record successful probes; REPORT.json records the exact command and status.

This is host formatting equivalence only. It does not assert ESP32-S3 ABI, stack frame, linker layout, target runtime equivalence, cycle counts or firmware admission. Actual target compile results remain a separate experiment.

## Reproduce

From the workspace root:

    python ayatsuri-fixed-frame-lint-20261105/format-only-host/prepare.py
    sh ayatsuri-fixed-frame-lint-20261105/format-only-host/mirror/ayatsuri-latest-fixed-source-20261105/kernel-chain-compact/build.sh
    python ayatsuri-fixed-frame-lint-20261105/format-only-host/mirror/ayatsuri-latest-fixed-source-20261105/kernel-chain-compact/verify.py > ayatsuri-fixed-frame-lint-20261105/format-only-host/mirror/ayatsuri-latest-fixed-source-20261105/kernel-chain-compact/verify.log
    python ayatsuri-fixed-frame-lint-20261105/format-only-host/finalize.py

All outputs stay under this private format-only-host directory. Its mirror contains private model-derived constants and profile data, and compiled libraries contain the private profile. Do not publish this mirror or its binaries. A user-facing report-only package can retain README, minimal.patch and proof/report JSON without the private mirror.
