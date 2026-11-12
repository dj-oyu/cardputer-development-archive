# Predeclared caller-only lifetime exact replay

Exactly 42 actual frames: diagnostic fixed40, OFF20 then ON20 with baseline front canary first in each arm, followed by two no-full-depth-capture HDR canaries, OFF then ON. This schedule is declared before any candidate outputs. No actual execution until author source/build freeze, independent source and runner review PASS, and explicit safety GO are hash-bound in the execution gate.

The sole implementation change is earlier existing snapshot append followed by model/cold-storage release after the final geometry copy and before BVH construction. Existing kernels, geometry, references, fixtures, original profiles, and acceptance limits remain unchanged. Allocation/failure harness belongs to the author. No owned-context/paged-BVH work, device, public repository, PR or SDK changes.

Compare against completed fox-v3-streamed-center-depth, matching each mode to its own retained baseline. Preserve all command parameters, schedule, reverse flags, runtime inputs, world settings and depth capture environment. Diagnostic outputs: RGB565, float depth, snapshot, target mask and HDR byte-for-byte. Production canaries: RGB565, snapshot, mask and HDR byte-for-byte against both corresponding retained no-depth baseline and current diagnostic canary; no full-depth artifact permitted.

All eight prior semantic/cache reports plus prior depth-stream sidecar compare exactly with typed equality, except the previously named descriptive timing fields. There are ZERO allowed non-timing transitions in old reports. Old streamed-depth memory/counter deltas are not carried forward. The aggregate named lifetime/memory ledger is a separately hash-bound artifact; no new per-frame instrumentation or sidecar is introduced. Its values must be predeclared from source/build evidence before any actual outputs. Expectations are never learned from candidate actual reports. Unknown keys, missing values, mistyped fields, duplicate keys, nonfinite timings and undeclared differences fail closed. Existing depth work accounting and cap 637599 remain enforced.

Record product named phases, caller/child stack, diagnostic full-depth and HDR observer charges independently. Verify ownership after early release, fallback paths, both modes, allocation/build failures, sanitizer checks, no double release, and unchanged successful snapshot/geometry serialization in synthetic author tests. These tests do not make the two no-depth actual cases full40 coverage. Never infer complete leak-clean or process/device fit from named memory totals.

Single fixed42 only, no retries or second40. Preserve unsuccessful attempts. Canary mismatch stops; completion manifests publish only after validation and a second freeze check. Retained audit never renders. Production mode means no full-depth observer, with HDR diagnostics still enabled. Frozen baseline roots remain read-only.

Historical streamed-depth diagnostic40 wall approximately 699.2 seconds is descriptive, not a controlled timing baseline; full42 totals are not comparable to historical40. No speed, target fit, full process RAM, or exhaustive no-depth actual coverage claim.

Owned scope: this comparison directory and PLAN only. Parent owns GO; author owns source/build/ledger/failure tests; reviewer owns independent PASS.
