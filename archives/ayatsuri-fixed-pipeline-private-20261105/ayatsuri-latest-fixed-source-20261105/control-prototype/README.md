# Private integer control preparation

Independent C integer kernel for the eight source driver bindings (seven Value sockets plus Environment Reflection numeric BSDF input). No renderer, visibility, queries, Blender execution, device or public operations. Frozen material-prototype is unchanged. Inputs/semantics/source hashes are bound in dependency-manifest.json; this new standalone directory has no Git HEAD, so its exact code hashes, compiler and binary hashes bind the implementation rather than an invented repository revision.

## Interface and scales

control.h defines cp_eval and cp_block. Input ordering is both blink, left blink, right blink, gazeX, gazeUp, EyeStyle, highlights, reflection, pressure. All are caller-supplied signed32 Q24. Bounds: gaze/up/pressure[-1,1], style[0,2], others[0,1]. Source-style mode accepts only style0/1/2. Diagnostic mode explicitly permits fractional style; it does not claim the Blender UI emits such states. Out-of-range control, side, precision or width rejects. Both blink and matching side blink are combined by max. Raw pressure polynomial and clamped-pressure output are distinct expressions; clamp is identity ONLY because this domain restricts raw pressure[-1,1]. No wider raw-pressure support is implied by UI metadata.

Outputs: blink,cx,cz,style,highlights,clampedPressure,quartic,reflection in signed32 Q16/Q20/Q24. Output is direct mathematical fixed point, NOT integer emulation of the source float32 socket grid. Around Z=2.54 the float32 grid is2^-22, or four Q24 codes; integer Q24 can be closer to the ideal decimal formula yet differ from that socket. No bit-exact source-socket compatibility claim is made.

Coefficients are decimal-source constants rounded ties-even offline to Q30. Horner evaluates the quartic, reducing each product by Q24 with signed nearest ties-even. This differs in order from the source high-precision preparation and deliberately reports both references separately. No float instruction or float conversion appears in the C kernel. Inputs/constants/LUT/reference generation remain offline.

## Range and overflow proof

Let C=2^24. After validation every signed gaze/pressure magnitude is≤C, other fields≤2C. Every Q30 coefficient magnitude is below3*2^30 (largest is Z base2.540277). Gaze products use coefficients<.027*2^30 times≤C. Their rounded values, and sums with bases, stay below3*2^30. Quartic Horner intermediate absolute real bounds, allowing coefficient and rounding errors, are conservatively .004,.005,.017,.064,1.01. Multiplication by pressure≤1 does not expand these bounds; each product reduction adds at most2^-31. Thus a single conservative bound |internal value|<4*2^30 and |raw multiplication|<2^56 covers all operations. The latter is less than signed64 capacity by seven magnitude bits. Negation and the quotient/remainder tie test are safe; code never negates INT64_MIN. Output magnitude<3*2^24<2^26, safely signed32. This is a domain proof independent of sampled tests. Input/output arrays must point to their documented lengths, as with ordinary C APIs; arbitrary invalid memory pointers cannot be validated.

Coefficient/accumulator storage uses int64 where needed, including Z's Q30 base2727601659, which exceeds signed32. Inputs/outputs are32-bit. We did not achieve all32-bit arithmetic: coefficient×Q24 control needs wide products. No S3/PIE timing or true SIMD implementation is claimed. The block wrapper stages all outputs and copies only after every lane succeeds, including a failure in the last lane. Input/output aliasing is safe for valid allocated arrays because commit follows computation.

## Error decomposition and proof

All Decimal-reference comparisons use exactly the represented Q24 controls, separating formula/coeff error from input error. Each coefficient error is≤0.5*2^-30. The quartic has five coefficients and four multiply reductions; since |p|≤1, accumulated absolute internal error is≤4.5*2^-30, plus final output half-step2^(-bits-1). Gaze centers have at most base coefficient half-step plus one active signed branch's coefficient half-step and product half-step, giving≤1.5*2^-30 plus output half-step (a looser2.5*2^-30 also bounds both-branch treatment). Direct/max fields only incur output rounding. These are bounds versus exact decimal formulas at represented controls, not against float32 socket rounding.

For quantizing an arbitrary in-domain input to Q24, each scalar error≤2^-25. Max blink is1-Lipschitz; direct fields likewise. Gaze X coefficient max.026299, Z max.015285. Pressure derivative is bounded by4*.003268858+3*.000369206+2*.011176145+.04670431=.08323965 on[-1,1], so input-only polynomial error≤.08323965*2^-25. Raw input error, fixed coefficient/Horner error and output quantization can be added for a conservative total mathematical bound. This says nothing about exact strict-threshold branch parity downstream.

## Tests and results

verify.py checks20,056 side-combined control cases per precision against (1) the frozen declared float32 uniforms preparation and (2)70-digit Decimal formulas. Cases contain individual endpoints, zeros, independent side blinks and10,000 deterministic random tuples. Fractional styles are explicitly diagnostic. Source integer styles and rejection atomicity are separately tested.

Maximum absolute error over all eight outputs:

| output fraction bits | versus float32 preparation | versus Decimal at represented inputs |
|---|---:|---:|
|16|7.62939453125e-6|7.62989152876527e-6|
|20|4.76837158203125e-7|4.778035746269821e-7|
|24|1.1920928955078125e-7|3.112532510737484e-8|

results.json gives per-field maxima/RMS and counts of differing output codes relative to float32-then-quantize. input-quantization.json independently tests2,000 raw binary64 tuples with Decimal, comparing ideal formulas before and after Q24 input quantization: maximum direct-field input effect≈2.98e-8; polynomial≈1.706e-9. These are finite observations in addition to the bounds above.

Integer bridge: constants/ramp/roughness and explicit coordinate inputs are prepared offline. C outputs directly replace Value-node codes; remaining uniform and spatial nodes call the existing checked-int64 model without going through its floating frame()/Value quantizer. Each eye/precision tests128 controls at two fixed local positions (1,536 total graph samples). RGB and mix codes match the old fixed graph for these positions; this is a small interior fixture, NOT threshold, full-frame, animation or image parity. The comparison baseline's float preparation is reference-only. The production-side bridge remains Python checked-integer graph interpretation, not a complete C material compiler.

Native test_c passes20,000 varying batches, widths1/2/4/8, both sides, all three output precisions, signed half ties, source zero and endpoint inputs, plus null/width/final-lane rejection with unchanged output. Width equality is scalar grouping independence, not parallel hardware. O0/O2 AddressSanitizer+UndefinedBehaviorSanitizer pass. Initial LeakSanitizer cannot operate under this environment's ptrace; reruns use ASAN_OPTIONS=detect_leaks=0, preserving address/UB checking. Kernel allocates no dynamic memory. Test logs and binary bindings are retained.

## Additional boundary bridge (control change isolated)

bridge_boundaries.py reuses the frozen coordinate-generator function and12 saved control states, including vertices, triangle barycentric samples and strict-boundary/sqrt-tip points. Only that known helper AST is executed; no driver string or Blender code is executed. Each baseline uses the SAME represented Q24 controls and identical fixed graph/coordinate codes, changing only preparation of its input Value sockets and reflection parameter. Across7,176 points per precision, extra predicate-changing samples are Q16:0, Q20:70, Q24:2. All occur in deliberate boundary points; mix-factor codes remain unchanged. Maximum RGB control-only delta is0/.9989967346191406/.9988279938697815 respectively. These counts are NOT the prior all-fixed-versus-float counts and must not be combined as if independent errors. Finer arithmetic does not imply strict-edge compatibility with float32 sockets. Raw changed cases and exact coordinate records are in bridge-boundary-differences.json.

## Reproduce

From this directory:

    cc -std=c11 -Wall -Wextra -Werror -O2 -ffp-contract=off -fexcess-precision=standard -shared -fPIC control.c -o control.so
    python verify.py > verify.log
    python bridge_boundaries.py > bridge-boundaries.log
    cc -std=c11 -Wall -Wextra -Werror -O0 -fsanitize=address,undefined -fno-sanitize-recover=all control.c test_c.c -o test-o0
    ASAN_OPTIONS=detect_leaks=0 ./test-o0 > test-o0.log
    cc -std=c11 -Wall -Wextra -Werror -O2 -fsanitize=address,undefined -fno-sanitize-recover=all control.c test_c.c -o test-o2
    ASAN_OPTIONS=detect_leaks=0 ./test-o2 > test-o2.log
    objdump -d control.so > disassembly.txt

No fast-math or LTO used. Integer symbols can be inspected in disassembly.txt; vector register moves emitted by the compiler are not floating arithmetic. This is control preparation only, with no measured performance claim.
