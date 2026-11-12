# Shading state transitions and register budget

This is a code-generation investigation, not a new precision contract or an adopted assembly kernel.

## State transitions in the current vertex loop

1. Decode immutable position/normal and load the mesh's world/projection coefficients.
2. Produce world normal x/y/z and length using the existing double arithmetic.
3. Quantize front SNORM16 with the existing asymmetric floor/clamp order.
4. Normalize the decoded SNORM in float, compute front/back/half-vector/specular/thickness terms.
5. Apply the unchanged channel formula to two independent albedos and store the two colors.
6. For sided meshes, return to the world-normal doubles, quantize the opposite side separately, then repeat stages 4–5.

Transforms, projected xy/depth and final packets have lifetimes beyond this vertex and cannot all stay in registers. Numeric representation transitions are observable: world double to SNORM16 to normalized float to RGB565. Removing those boundaries would change the contract even if the real-number formula looks equivalent.

## Observed host live range

Independent review confirmed in bounded GCC14 O2 assembly that x/y occupy rsp+0x380, z rsp+0x390 and length rsp+0x8. These values survive the front terms/color calls and are reloaded for back-side SNORM generation. This is a real long-lived 32-byte state, not merely a variable-count inference.

A future isolated variant could prepare two separate 3-short SNORM arrays before front shading, then let the four doubles die earlier. It must validate the front normal first, compute the back only for sided geometry, retain the original negative-double rounding and add no new rejection. A second short array adds six logical bytes while potentially shortening 32 bytes across calls; this is not a guaranteed stack saving because alignment, allocator choices and other scratch may dominate. FP exception/errno observation order must be considered separately. The subsequent candidate-early-snorm experiment measured this exact change: double lifetimes shorten, but mesh .su grows by 16 bytes and .text by 64. It remains an unadopted counterexample; see results/early-snorm/REPORT.md.

## Actual target register budget

Espressif's official S3 documentation specifies 16 32-bit floating-point registers and a window exposing 16 of 64 physical address registers at a time. ABI-reserved registers, parameters and values crossing calls reduce the usable budget. Therefore counting 64 physical integer registers as simultaneously available to one kernel is wrong. A live double is eight bytes of state and does not fit in one 32-bit FP register; the S3 double arithmetic is software-emulated.

The shared terms are four floats (front/back/spec/thin), followed by two 16-bit colors. That looks small in isolation, but mesh pointers, iteration state, projection/normal coefficients and values surviving libm calls compete for registers. The experiment already demonstrates the effect: default inlining grows mesh stack and code; an explicit function boundary shrinks the caller. That boundary also adds helper frames and call/ABI costs, so caller .su alone is insufficient.

The native test environment has GCC14 x86-64. The existing firmware environment has Xtensa GCC15.2, actual -std=gnu23 -O2 -ffp-contract=off, -mlongcalls and response-file flags including builtin memcpy suppression. Target code generation must use those settings. The host's single 32-bit paired-color store is not evidence that target memcpy will be folded; it may become an external call under the firmware flags.

## Instruction-level plan

For each target variant, identify concrete live ranges at the normal/SNORM/shading/color boundaries. Separate ABI saves, intentional arrays, outgoing arguments, register spills and reloads. Inspect the actual helper call graph and return convention, rather than assume the four-float term struct stays entirely in registers. Compare scalar stores against packed final writes under alignment and alias constraints.

Only after this evidence should a dedicated kernel or assembly spelling be considered. It must preserve ABI, operation order, FP contraction rules, range checks, rounding and error publication. Static instruction-site counts and manually assigned nominal latencies are not elapsed cycles; cache, memory placement, branches, software-double/libm implementations and interrupt scheduling can change the result. Device cycle measurements are outside this task's current no-device scope.

Sources:
- https://documentation.espressif.com/esp32-s3_technical_reference_manual_en.pdf (official register-window and register table)
- https://www.espressif.com/sites/default/files/documentation/esp32-s3_technical_reference_manual_en.pdf (FR table: 16 registers, 32 bits)
- https://github.com/espressif/esp-idf/blob/master/components/xtensa/esp32s3/include/xtensa/config/core-isa.h (windowed core, 64 physical address registers, single-precision FPU)
- https://docs.espressif.com/projects/esp-idf/en/stable/esp32s3/api-guides/performance/speed.html (software-emulated double, target measurement cautions)
