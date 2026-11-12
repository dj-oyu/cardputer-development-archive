# Private diagnostic sampler

This directory alone contains a diagnostic copy, not a production change. Baseline is `fox-v3-lid-evaluation/actual-lid8-v2`. The entire original `transport/bounce.c` is an exact byte prefix; only private direction/world helpers and the separate evaluator are appended. The header adds only the diagnostic API/comment. Visibility and lighting dependencies are unchanged copies. See `source.diff` and `source-verification.json`.

`bounce_eval_diagnostic(binding, generation, position, normal, rho, mode, outer, inner, outer_phase_turns, inner_phase_turns, direct_budget, transport_budget, out)`

Outer count permits 16/64/256, inner count 16/64. Explicit sampler m is 2/4/8 respectively, with 4m azimuths and unchanged radial midpoints. Both phase inputs must be finite in [0,1). Rotation adds the original 2pi constant times phase to the original phi, only when phase is nonzero. Phase zero avoids even adding zero. Original `bounce_eval`, scene ownership, material, direct light, visibility, normalization, accumulation, output and budget mechanisms are unchanged. Native frame integration must continue to call original `bounce_eval`.

The two budget pointers remain caller-owned cumulative accounts. On failure output, including its result counters, stays unchanged; consumed rays/nodes/triangles remain in budget.used. No allocation, automatic quota growth or budget reset is added. Caller is responsible for separate bounded point-experiment budgets and capture/replay controls.

Run `./run_tests.sh`. Results in `test-results.txt`:
- 36 exact original/diagnostic comparisons: outer/inner each 16 or64, all three modes, three normals. Entire result (all component RGB and counters) and both budgets compare byte-for-byte.
- Fixture has nonzero direct/world/bounce/ground contributions across comparisons; owned binding survives release of source owners and poisoning input geometry/material/light arrays.
- Direction tests on five normals, all16/64/256 patterns and zero/fixed-alternate phases check finite unit vectors, positive hemisphere cosine and unchanged radial cosine. 16/64 zero-phase directions compare byte-for-byte with original.
- All supported sample combinations run with zero and alternate phase. Invalid counts, inner256, NaN/infinite/negative/out-of-range phases reject without output or budget mutation.
- Direct and transport rays/nodes/triangles separately exhaust with failure-atomic result and retained bounded consumed work.
- Optimized strict-warning test and AddressSanitizer/UndefinedBehaviorSanitizer test pass. LeakSanitizer is disabled because this environment's ptrace makes it fail before reporting; leak detection is NOT claimed.
- Copied original bounce and ground regression tests pass.

No actual-scene high-density query, frame render, image/reference input, scene selection, new phase choice or production adoption was performed here. Fixture tests do not establish actual selected-query replay fidelity or estimator convergence.
