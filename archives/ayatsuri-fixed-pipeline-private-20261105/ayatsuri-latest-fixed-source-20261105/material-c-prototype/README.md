# Private native integer material-color prototype

Independent C source prototype only. No renderer integration, visibility/query/ray changes, Blender render/bake/driver execution, hardware measurement, publication, BSDF transport or image comparison. Frozen control-prototype and material-prototype are read-only dependencies. Source hashes and binaries are bound in dependency-manifest.json and SHA256SUMS; no renderer Git HEAD is claimed.

## Pipeline and binding

Build MBITS=16,20 or24 separately. mc_prepare accepts nine caller-supplied int32 Q24 controls, side and explicit source-integer-style versus diagnostic-fractional-style mode. It invokes frozen cp_eval, then evaluates graph uniform nodes with checked integer math. mc_eval accepts prepared frame plus int32 Object-local XZ in selected Q and returns BaseColor[3], clamped Principled mix factor, complementary transparent weight and numeric Roughness/IOR/Specular IOR Level. mc_block groups1/2/4/8 calls and atomically commits all outputs. This is scalar grouping, not true SIMD or PIE instructions.

The generator reads the frozen model's validated DAG and input inventory; it never evaluates saved driver expressions. It emits both sides, fixed constants and257-entry RGB ramp tables for each independent precision. Exact source node order and uniform-then-spatial order are retained in node-manifest.json. All118 Math nodes remain:39 control-only,2 invariant,77 spatial. The color/mask slice has132 nodes, compared with136 in the complete reachable Surface graph: Principled, Transparent, Mix Shader and Material Output closure nodes are intentionally excluded, not approximated. Numeric material parameters and the mix factor are returned separately. No material flattening or diffuse transport substitution occurs.

Input/semantic binding: original d15a3316…; derived2k-v2 blend384ada0c…; neutral sidecar00a81f…; official Blender4.3.2 revision32f5fdce0a0a571a39198edf8d7b5d719bf59f2c, frozen primary source manifest, control C code, model.py and generator helper hashes. Full values are in dependency-manifest.json. Source constants and LUT are prepared offline using the frozen declared float32 semantics, then represented as exact integer literals. Live pixel/control computation has no floating arithmetic or conversion.

## Arithmetic, rejection and atomicity

Spatial domain is X[-1,1], Z[2,3.2], using integer bounds (-S,S,2S,floor16S/5); controls inherit cp_eval's validated ranges. Nonzero denominators are a reachable-graph contract. Zero at the integer division input rejects with status5, including an unexpected quantized-zero denominator; it does not silently enact the generic source Math zero-divisor result. The frozen graph's nine spatial divisors are fixed nonzero constants and uniform variable denominator is nonzero in the approved control domain. This prototype is NOT a generic Blender Math interpreter for arbitrary zero-divisor graphs.

Every signed add/subtract and raw multiply is checked before the operation. Magnitudes are formed without negating INT64_MIN; multiplication checks unsigned magnitudes against the signed result limit before multiplying. Quotient/remainder nearest-ties-even handles either sign and rejects INT64_MIN/-1. No __int128 is used. A raw product that overflows rejects even if its final rescaled mathematical value would fit; this conservative limitation is explicit. Errors are sticky nonzero through evaluation, and no output is committed on error. Source SQRT negative-input clamp, source factor clamps and min/max are retained; there is no overflow saturation or softened threshold.

Integer sqrt uses a bounded bitwise unsigned square-root algorithm on the nonnegative checked int64 product max(a,0)*S. The returned floor root is≤floor(sqrt(INT64_MAX)); its square cannot overflow uint64. The nearest-root increment tests remainder>root; an integer radicand cannot produce an exact half tie. Ramp clamps factor, multiplies its bounded code by256, accesses index0..256, and accesses index+1 only for nonzero fractional remainder, hence never past256. It uses the frozen `(1-t)*a+t*b` scaled integer order. LegacyMix uses the frozen `a+t*(b-a)` order and always clamps factor; no result clamp is introduced. Strict comparisons are unchanged.

Control range/overflow proof remains in control-prototype/README.md. For the whole spatial graph, no all-domain success/range proof is asserted: runtime checks guarantee rejection rather than signed overflow. All sampled valid inputs succeeded. Valid caller-owned buffers must have declared sizes. Frames are prepared by mc_prepare; public struct representation is not a serialization format. mc_eval checks precision tag and side, and all arithmetic remains checked. Frame preparation, individual pixel output and batch outputs are staged until success, including failure at the final lane. No shared/global mutable runtime state or dynamic allocation.

## Differential and native tests

Each precision compares10,224 C outputs EXACTLY against the frozen checked-int64 Python graph with identical C-produced control codes:7,176 saved fixture points over12 control tuples/two eyes plus3,048 additional random/domain-corner points. Zero mismatches, zero valid-domain rejections. Output comparisons include color, mix, transparent weight and all numeric parameters.96 additional grouped equality cases per precision cover widths1/2/4/8.

Native C tests exercise2,000 varying control batches per precision, both eyes, widths1/2/4/8 and domain-wide coordinate samples; helper overflow extrema, INT64_MIN, signed half ties, zero denominator, negative/zero/positive sqrt and LUT endpoints; invalid frame/tag/pointer/domain/width and failed prepare/final-lane atomic output. All six O0/O2×Q16/Q20/Q24 AddressSanitizer+UndefinedBehaviorSanitizer runs pass. LeakSanitizer is disabled because this environment uses unsupported ptrace; no dynamic allocation is used. No UB was reported. No test-only128-bit arithmetic is needed.

Exact agreement is with the new integer-control integer graph, NOT float32 source sockets. Prior control-only7176-point tests produced Q16/Q20/Q24 predicate changes0/70/2 relative to float-prepared fixed graphs; those differences remain and are not repaired or hidden here. Earlier all-fixed-versus-float boundary errors also remain. No image, animation or actual Blender execution parity follows.

## Memory/code accounting: host reference only

Current implementation retains every DAG output instead of scheduling registers or recycling slots:
- mc_frame:2072 bytes, including256 reserved int64 values, parameters and tags. It retains more capacity than165 used slots.
- Per sample local DAG values:165×8=1320 bytes.
- mc_output:64 bytes; block8 output staging:512 bytes in addition to the nested evaluator's scratch.
- Each257×RGB int64 table:6168 bytes; both eyes:12336 bytes per **single-Q build**. Precision alternatives are separate builds, not simultaneously required shipping tables. Both tables currently duplicate identical ramp data; sharing/narrowing is a possible later change, not implemented.
- Host GCC14.2 O2 Q20 material object: text15334B, rodata12408B, rodata.cst8 8B. Inline constants are included in code/rodata, not a separate invented table count. Control object is separate and reported by size-control.txt. Object file metadata/unwind sizes are in size-q*.txt, not shipping payload estimates.
- GCC -fstack-usage reports own static host frames: prepare2160B, eval1520B, block592B. These are not total call-chain peaks; nested helper/control calls add stack. Raw .su files retain details. Sanitizer binaries have different overhead and are not these figures.
- Symbolic topological output liveness peaks at29 scalar outputs versus165 retained slots. This excludes helper temporaries, lanes, operand copies, uniform cache and allocator constraints. It is evidence for future scheduling work, not a29-register implementation. Eight128-bit QR registers cannot be assumed to hold this graph/cache, especially at eight pixels and64-bit intermediates. Gather/LUT/multiply/divide/sqrt/spill costs and S3 performance are unmeasured.

All memory values are host C layout/compiler references; no target code size, speedup or deployment recommendation is claimed.

## Reproduce

From this directory, with existing audited dependencies:

    python generate.py
    for B in 16 20 24; do
      cc -std=c11 -Wall -Wextra -Werror -O2 -ffp-contract=off -fexcess-precision=standard -DMBITS=$B -shared -fPIC material.c ../control-prototype/control.c -o material-q$B.so
      for O in 0 2; do
        cc -std=c11 -Wall -Wextra -Werror -O$O -DMBITS=$B -fsanitize=address,undefined -fno-sanitize-recover=all test_native.c ../control-prototype/control.c -o test-q$B-o$O
        ASAN_OPTIONS=detect_leaks=0 ./test-q$B-o$O > test-q$B-o$O.log
      done
      cc -std=c11 -O2 -DMBITS=$B -fstack-usage -c material.c -o material-q$B.o
      size -A material-q$B.o > size-q$B.txt
      objdump -d material-q$B.o > disassembly-q$B.txt
    done
    python verify.py > verify.log

No fast-math, LTO or speculative assembly. Generated C includes only the selected precision table. Future scheduling/PIE, renderer integration, interval fallback and image validation remain separate work requiring their own scope and evidence.
