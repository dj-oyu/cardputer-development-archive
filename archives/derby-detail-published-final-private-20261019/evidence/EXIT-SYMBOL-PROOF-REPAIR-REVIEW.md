# EXIT symbol proof repair — independent review

Reviewed UTC: 2026-10-19T22:01:05.936264+00:00

**No unresolved major finding in the two-file repair.** Both Python files are SHA256-identical in all three clean local candidates. Only these files differ from the prior published heads; runtime C, generated JS, wire protocol and fixture sources are unchanged.

| Variant | Exact reviewed candidate | Tree |
|---|---|---|
| baseline | `c90ee61b392de779e1438d2674087e7ccd9e1824` | `7753c5c8919ee36c24080ce08102438a285da6f2` |
| native | `3d861298f12c4aaf01ac520e0a795231e3135c1d` | `24f0575743c7de7d4873c531221db6e1fcf1f14f` |
| batch | `826c74a1676261fa9a086271678e61a90d0b88af` | `63bf0b2ee03168230de588f2a038e3e694b1d4d4` |

The prior published heads `9b9e9ae4...`, `0e3a457f...`, `efb9aa4e...` legitimately failed mandatory target proof and remain **FAIL** for that CI result. A linked ELF alone is not accepted firmware proof. This review is not a passing new CI result.

`DETAIL_FIXED_SYMBOLS` contains only `df_detail_exit_record`. verify_fixed_mode adds it to both required and allowed df_ boundaries only in detail ON. Previous fixed-required/optional helper rules remain intact. Coarse detail OFF rejects the new symbol, fixed-workload OFF rejects all df_ symbols, and unknown df_ symbols remain rejected. Generated-byte, PAN, manifest and mandatory diagnostic proof gates are not weakened.

Independent test_derby_detail_proof.py runs passed in all three variants. They reach actual mandatory prove(build), including the batch-specific proof flow, using synthetic BIN/ELF and mocked symbol extraction. New negatives require the exact boundary error for missing EXIT in ON, unknown df_ in ON, and EXIT present in OFF; the positive includes the new real boundary.

A separate repo-external ten-case matrix passed: minimal required symbols without optional inline helpers, missing/new/unknown boundaries, detail ON aliases YES/TRUE/1, valid coarse OFF, invalid EXIT in coarse OFF, and fixed-OFF presence/absence. Reproduction and structured evidence: EXIT-SYMBOL-PROOF/check_matrix.py, matrix.json and REVIEW.json. These tests establish helper behavior, not the content of a new actual target ELF.

Reviewed file SHA256 values:

- tools/record_verification.py: `c16db1727f571df9b04aee00d6d1bef8f3e341b2a389a8aadf2d1df5e9c43038`
- tools/test_derby_detail_proof.py: `487ef53102f6ba06a14d37250b19358987b8340aa3b9cb926ee839f933a1198b`

Remaining validation is **pending**: publish/bind these exact trees and obtain new-head CI/actual mandatory ELF proof. Runtime tests were not repeated because runtime code is unchanged. Original device capture remains FAIL; no repository edits or source/hardware/MCP/USB/firmware-build/flash actions were performed by this reviewer.
