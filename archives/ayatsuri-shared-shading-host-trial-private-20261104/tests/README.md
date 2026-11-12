# Shared-shading tests

This experiment compares an already-light-only frozen baseline with exact shared per-normal shading. It does not compare directly with upstream b10976a3: the baseline model has SHA256 bf1ba06d55f9029b5c95981087cc3ee40651523759d6e044538a5d4f6c999864. See ../BASE_SOURCE_FREEZE.json and ../README.md for all identities, limitations and observed tradeoffs.

Sources: evaluate_test.c, make_fixtures.py and run_matrix.py exercise native evaluation plus the production host painter raster. shade_terms_stress.c and run_shade_stress.py independently compare numeric terms and both RGB565 colors against the frozen original shader. Fixtures are generated from small visible literals; no asset file is read.

From the experiment root, run either candidate:

```sh
python3 tests/run_matrix.py --baseline-dir baseline --candidate-dir candidate-bounded --output-dir /tmp/shared-model-results
python3 tests/run_shade_stress.py --baseline-dir baseline --candidate-dir candidate-bounded --output-dir /tmp/shared-shade-results
```

Substitute candidate for candidate-bounded to test default inline decisions. All source roots must remain unchanged during a run. Runners write generated fixtures and outputs only under the requested output root. Do not publish those generated outputs or surrounding private experiment directories.

Both model builds intentionally compile with CANDIDATE=1 because both retain the existing light-only counter behavior. The stress runner compiles frozen baseline and candidate headers together under renamed symbols and uses distinct plain/instrumented configurations. Instrumented libm source-call counts can alter optimization and are not emitted instruction counts or elapsed cycles.

LSan defaults to enabled. This sandbox explicitly used --disable-leak-sanitizer with --leak-sanitizer-disabled-reason describing the ptrace incompatibility; ASan and UBSan remain enabled. The model runner separately probes 32-bit libc support and requires its m32 matrix when available. Missing m32 or disabled LSan must not be reported as passing.

Strict arithmetic flags are contraction off, no fast-math and standard excess precision. No approximate formula is substituted. This tests host behavior, not firmware/device/Blender/QuickJS/production commit-repair integration. Timing, persistent storage, temporary stack, code size and emitted instructions are separate metrics.
