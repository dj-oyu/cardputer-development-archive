# Private storage-only C material compaction

This is a storage transformation of the frozen material-c-prototype, not an arithmetic redesign. Original45-file SHA256SUMS verifies unchanged. No renderer, visibility/query, Blender, device, public or performance operations. All source operation ordering, constants, integer control preparation, checked arithmetic, nearest rounding, strict predicates, rejection and atomic output semantics are inherited unchanged.

## Transformation and proof obligations

compact.py reads each frozen generated-Q file. It independently checks the two eyes' complete257×3 table literals are identical and every signed-parsed value is in[0,UINT32_MAX]. It emits exactly those values once as uint32, promoted to int64 at checked arithmetic calls. No LUT resampling or numerical narrowing occurs. One selected-Q build contains one3084-byte table; three test precision alternatives are not summed into a shipping footprint.

Uniform-to-spatial interface is derived from actual right-hand-side dependencies and final color/mask roots. Exactly23 int64 uniform outputs survive into the frame. All original uniform statements still execute in the same order, including otherwise dead results, so error-producing operations are not removed. Uniform preparation uses24 scratch slots and copies23 live results into the frame.

The spatial scalar sequence is unchanged. Last-use analysis recycles storage only after a value's final use. Destinations do not alias any live input, even though C assignment could sometimes permit that optimization; the conservative allocation uses29 int64 scratch slots. The generator asserts a single logical assignment, defined and live RHS values, nonaliasing physical output slots, and final root retention. Every rewritten statement must inverse-map byte-for-byte to the original expression using the live physical/logical map. allocation-manifest.json stores each allocation/read set, cache IDs and these checks. No graph reassociation, constant folding, arithmetic specialization or predicate modification is performed by this transformation.

The C helpers are copied from the frozen implementation; the LUT pointer element type changes from int64 to uint32, preserving all stored numeric values and promotion before checked multiplication. Only frame capacity and cache-to-scratch copy size change. Frame tags currently identify precision, NOT ABI version; callers must use the matching compact header and must not pass a frozen full-frame struct to the compact library or vice versa. The tests use distinct ctypes struct definitions. Neither frame struct is a serialized interchange format.

Range/overflow/fallback rules are those documented by the frozen native prototype. Working values remain signed64 at every Q. Q20 sampled31-bit codes from the smaller old fixture were NOT a global range proof; wider domain random/edge observations are separately recorded below. No int32 narrowing of graph values is attempted. There is no all-domain successful-evaluation proof; every arithmetic overflow/zero-divisor path rejects before unsafe arithmetic and leaves caller output unchanged.

## Exactness tests

verify.py compares three implementations on identical inputs: compact C, frozen native C and frozen Python integer model driven by the same integer-control outputs. Per precision it checks7,176 original fixture points plus3,048 random/domain-edge points, including the explicit local domain X[-1,1], Z[2,3.2]. Every output field matches exactly, and all sampled valid inputs succeed.96 grouped width1/2/4/8 equality cases are checked per precision. Cross-native invalid coordinate/control/style/side/mode cases have matching nonzero statuses and unchanged output buffers.

Native tests run2,000 varying batches per precision and all widths, with helper extreme-overflow tests, INT64_MIN, half ties, zero denominator, sqrt/ramp endpoints, invalid frame/domain/width and final-lane/prepare atomic failures. All six Q16/Q20/Q24×O0/O2 AddressSanitizer+UndefinedBehaviorSanitizer builds pass. Leak detection is disabled only because this environment's ptrace is unsupported; the kernel allocates no dynamic memory. Raw logs are retained. Scalar grouping equality is NOT SIMD.

These exact comparisons preserve all existing numeric limitations, including control preparation's difference from float32 sockets and strict-edge flips. They do not establish Blender/image/animation parity or a renderer speedup.

## Storage and host compiler measurements

| item | frozen full storage | compact |
|---|---:|---:|
| frame sizeof |2072B|208B|
| retained uniform values capacity |256×8B|23×8B|
| uniform helper explicit scratch |no separate local DAG array|24×8B=192B|
| per-pixel DAG scratch |165×8B=1320B|29×8B=232B|
| output struct |64B|64B|
| block8 staged output |512B|512B|
| selected-Q RGB LUT data |2×6168B=12336B|3084B shared|
| host Q20 text |15334B|14294B|
| host Q20 rodata |12408B+8B cst|3116B+8B cst|

The cache and scratch are separate. Batch staging remains live while a nested pixel evaluator runs. The frame still includes parameters, side, precision tag and host padding. Table bytes above are the numeric tables; object rodata additionally contains indices/compiler constants. Control code is unchanged and linked separately, not included in material object text figures.

Host GCC14.2 O2 own static stack frames: prepare288B (was2160), eval432B (was1520), block592B (unchanged), uniform helper176B (was80). The compiler may keep part of the192-byte uniform array in registers or optimize storage; explicit array bytes and own stack frames are different measurements. These own frames are NOT summed here as a proven peak: nested helpers and control calls add stack, and actual target codegen may differ. All-Q raw size/stack files are provided. No S3 ABI size, QR allocation, PIE implementation, cache/register spill cost or runtime performance claim follows.

## Wider-domain integer observations

The additional3,048 random/domain-edge samples (including their uniform preparation) reached the following observed maxima. They are not whole-domain bounds:

| Q | maximum absolute code | magnitude bits | maximum raw product | magnitude bits |
|---|---:|---:|---:|---:|
|16|1328996808|31|75557383140625|47|
|20|21199052675|35|19551114520090000|55|
|24|341392526232|39|5000758303997926089|63|

Thus even Q20 exceeds int32 in this wider corpus, and Q24 raw products use63 magnitude bits. Existing checked signed64 operations remain mandatory; previous narrow-fixture31-bit Q20 observations must not be generalized. Sample inputs differ by precision because the deterministic random stream advances; this table is not a same-point cross-precision error comparison.

## Reproduce

From this directory:

    python compact.py
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

No fast-math, LTO, new128-bit requirement or assembly. dependency-manifest.json and SHA256SUMS bind source, generated layouts, original dependencies, exact binaries and reports. This is the final independent compaction stage, not an integration approval.
