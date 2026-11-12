# Review follow-up

2026-11-04. The stale tests/README.md has been replaced with the correct already-light-only baseline identity and both model/stress reproduction workflows. Product sources and test C/Python files did not change.

The static host instruction counter now identifies all explicit %rsp addressing forms, including indexed addressing, and excludes LEA/NOP. Counts agree with the independent reviewer: 210/274/224 mesh instructions referencing stack memory for baseline/candidate/bounded. These remain static sites, not spill totals or dynamic traffic.

Earlier handoff status (now resolved): S3 code-generation comparison was pending. The existing environment and toolchain are confirmed. Two official file-transfer attempts failed before creating any ZIP; no target compile occurred through that path. The same generic input is now being reconstructed in an isolated directory from verified existing public source hashes and explicit source patches sent through the existing work conversation. No public repository or CI is used for transfer.

The separately evaluated early-back-SNORM variant passes all exactness checks but increases host mesh stack by 16 bytes and code by 64. It is retained as a counterexample and does not replace bounded. Its shader header and all earlier source trees/tests are unchanged.

S3 object generation subsequently completed through the verified source-patch handoff. Target source hashes match local inputs and the complete saved bundle manifest was verified. TARGET_RESULTS.md distinguishes static target code generation from unmeasured target numerical execution/cycles.

Independent target review confirms the bounded mesh-to-normal-helper compiler-frame sum is 1504 bytes versus baseline 1488, before libm/window effects. Caller-frame equality is not stack neutrality. All saved text encodings and call-relocation annotations match the actual ELF data.
