# Shared shading stress result

Status: PASS.

Compiler: cc (Debian 14.2.0-19) 14.2.0. Host: x86_64 Linux.
O0 and O2, each plain and separately instrumented, plus ASan+UBSan at both optimization levels.
Strict binary32 arithmetic: FE_TONEAREST, no fast-math, FP contraction off, standard excess precision.

Cases per configuration: 775,078. All 8 result digests identical: True.
Shared-output RGB565 comparisons per configuration: 1,550,156; wrapper RGB565 comparisons: 1,550,156.
Bitwise term comparisons per configuration: 3,100,312. Baseline/candidate normalized basis and half-vector flags also compared.

## Coverage

- Nonzero SNORM16 normals, axes, grazing one-quantum normals, and separately quantized opposite-side half ties.
- Finite light/view directions from FLT_TRUE_MIN through FLT_MAX, signed zero, exact opposing directions, and near-cancelled half vectors.
- Material exponents 1 and 128, near-1 and fractional exponents; other coefficients in the accepted [0,1] range.
- Thickness 0, 1, 127, 128, 254, and 255; randomized byte thicknesses.
- All 65,536 RGB565 albedos in each color slot across eight scenarios; below/at/above float rounding thresholds for 31- and 63-step channels.
- 200,000 deterministic xorshift cases; fixed seed 0x9e3779b9.
- Zero, infinity, and NaN direction rejection checked separately; invalid directions never passed to sample.

## Sharing evidence and limits

Instrumented O2 source-call totals across all tested pairs of colors:
- Baseline: {"sqrtf": 1550156, "powf": 430744, "lroundf": 4650468}.
- Candidate: {"sqrtf": 775078, "powf": 215372, "lroundf": 4650468}.
Each pair requires exactly two baseline normal sqrt calls versus one shared candidate normal sqrt call. Conditional pow calls halve; channel round calls remain six. Direction preparation and oracle calls are excluded from these totals.
Instrumentation proves source-call reuse only. It can inhibit optimization and does not establish emitted instruction savings, register spills, elapsed time, hardware throughput, or device FPS. Plain builds separately verify that uninstrumented optimization preserves results.
The term oracle reproduces the original expression ordering independently of the new term API; the unchanged frozen baseline shader is the primary final-color oracle.

## Sanitizer scope

LeakSanitizer disabled: Sandbox ptrace environment does not support LeakSanitizer; ASan and UBSan remain enabled. No leak-test claim.
ASan and UBSan remain enabled for all four sanitizer configurations. Source and harness hashes checked before and after each run.
This is host binary32 differential testing, not proof for every input, other compilers/architectures, fast-math, or a device integration test.

Reproduce:

python3 tests/run_shade_stress.py --baseline-dir baseline --candidate-dir candidate --output-dir results/shade_stress --disable-leak-sanitizer --leak-sanitizer-disabled-reason "Sandbox ptrace environment does not support LeakSanitizer; ASan and UBSan remain enabled."

Machine-readable counts, status, options, hashes, and logs: stress.json and the per-configuration folders.
