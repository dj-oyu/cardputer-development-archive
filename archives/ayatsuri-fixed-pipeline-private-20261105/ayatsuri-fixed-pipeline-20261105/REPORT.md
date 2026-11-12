# Converter-first fixed-point investigation

Private checkpoint, 2026-11-05. The audit, new source/format prototypes, scalar integer reference, frozen-path numerical replay and geometry bridge are implemented. No existing source tree or original asset was changed. No device, publication or denied owned-ray-context operation was used.

## Decision

Start fixed-point at the offline-to-runtime boundary, **after Blender evaluation/transform baking but before RGB565 and AYNM packing**. Keep Blender/offline import arithmetic precise. Export linear albedo directly, and make runtime numeric formats explicit. A global `double -> int16` change would mix coordinate units, overflow positions/HDR and alter shadows/visibility unpredictably.

The proposed first architecture is deliberately mixed: source material and shading-normal attributes are prepared for signed16 SIMD; static physical positions use signed32 metre coordinates; frame setup, geometric visibility and difficult radiometric operations remain separately specified. It is not an all-fixed renderer yet.

## What changed in the private prototype

1. `source-adapter/`: uses the existing strict GLB importer and exact ordered batcher; emits a new schema declaring basis/metres/static mode. It retains source/module hashes and linear colors, without invoking RGB565 or AYNM packing.
2. `converter/`: emits independent AYFQ v1, with signed32 positions, /32767 signed16 normals and linear reflectance, 8-vertex SoA blocks, explicit counts/sidedness, canonical little-endian layout, padding and CRC. Invalid ranges and collapsed/reversed triangles reject; no silent saturation. Original AYNM is untouched.
3. `kernel/`: Q2.14 barycentric integers sum exactly to 16384. Lane-wise signed16 attributes accumulate in wide integers with proved bounds and nearest/ties-even output. Portable 1/2/4/8-pixel models match the scalar integer oracle. The intended S3 mapping is separate 40-bit QACC lanes, not ACCX reduction. Hardware instructions are not implemented or timed.
4. `quality/replay/`: reconstructs actual saved hit attributes using unchanged geometry/helper semantics, then compares integer alternatives on exactly those frozen paths.
5. `bridge/`: prepares geometry-only diagnostic AYNM copies from AYFQ while proving every nonposition byte unchanged. Existing model-open admission accepts both candidates. No rendering is invoked.

## Important source findings

- Existing current GLB→AYNM path was reproduced byte-for-byte; historical recovered exporters are not interchangeable with this current sidedness/static path.
- Current compiler stores float32 positions/normals, and first converts Blender linear color to sRGB RGB565. Runtime decodes that low-precision color back to linear. This round trip causes up to 0.01439597 absolute linear-color error on current source colors.
- Source-native metre positions must not be confused with legacy coordinates multiplied by 38. Physical shading later divides by 38 and permutes axes. New physical source data should not incur that repeated scale conversion.
- Current source adapter is static-only; animation, skins and morph targets remain unsupported. General runtime pose transforms still require their own bounds/format plan.
- New symmetric normal rounding is a version change. The old floor(x*32767+0.5) front/back rule is not universally equivalent to integer negation, although this particular static scene's old/new normal codes happen to match.
- Source linear color must be carried through both primary pixels and secondary bounce material attributes. Updating only primary colors would make reflections use different materials.

## Verified numeric results

The actual source has 54 bounded parts, 1163 partition vertices, 1564 triangles and eight used material-table entries.

- Q16 metre position encoding: max component error 7.62939453125e-6 m.
- Q20 metre encoding: max component error 4.76837158203125e-7 m, same 32-bit storage width.
- Normal encoding: max component error 1.5243615116566911e-5 versus source.
- Linear /32767 material encoding: max component error 1.4527674777924798e-5 versus source.
- Both AYFQ candidates have no collapsed or orientation-reversed triangles in this dataset. This is not a coverage/shadow guarantee.

Actual frozen-path replay:

- 7678 saved hit samples, 69102 original P/Ns/rho doubles reconstructed **bitwise identically** before alternatives are evaluated.
- Q2.14 weight + integer normal interpolation: maximum component error 7.00014e-5; normalized angular maximum 0.0102799 degrees, RMS 0.00193789 degrees.
- Old decoded-palette to integer rho: maximum component error 1.46822e-5.
- New source-linear integer rho: maximum quantization error 1.45277e-5 versus source. Up to 0.014388 difference versus old palette is an intentional source-color change, not just integer arithmetic error.
- No weight fallback or near-zero normal in this replay. P/geometry/visibility stayed frozen; no shadow, bounce direction or final-image claim follows.

## Tests

- Adapter: 11 synthetic/integration groups, including unsupported animation/morph/skin, source hashes, sidedness and no-overwrite behavior. All actual parts and pre-RGB565 color values match current conversion.
- Codec: 8 groups, including 500 seeded round trips, all byte-flip/truncation cases for fixture, recomputed-CRC structural corruption, unit normals, source schema/units, bounds and output failures. Final source regenerates both actual candidate files exactly.
- Integer kernel: 100000 synthetic inputs per attribute, 4.5 million scalar/lane comparisons, no mismatches; exhaustive RGB565 reference inputs; GCC O0/O2 ASan/UBSan pass. LeakSanitizer cannot run under the environment's ptrace and is not claimed.
- Python/C encoder bridge: 1290 exact matches per build, O0/O2 ASan/UBSan. Float preparation explicitly uses FE_TONEAREST; integer MAC rounding is independent of fenv.
- Geometry bridge: unquantized source matches every original position/normal byte; candidate changes only position bytes, retains topology/other fields, and passes unchanged `ayatsuri_model_open` for Q16/Q20. No runtime instance/render was created.

## Remaining implementation gates

1. Select the final error contract and position fractional bits after geometry-only snapshot/coverage and camera/pose stress tests. Q20's smaller observed error does not alone prove arithmetic overflow bounds.
2. Implement a source-linear attribute path for both primary and bounce shading, preserving ownership, identity, work accounting and failure contracts. A binary CRC is not a substitute for scene/source identity binding.
3. Keep signed32 positions out of the signed16 interpolation kernel. Checked 64-bit/int32 position arithmetic or a separately validated rebased representation needs its own proof. Broad int32 cross products can exceed int64.
4. Normal normalization, distance attenuation, inverse-square, endpoint/grazing tests and HDR need explicit ranges and approximation/fallback policies. Observed final HDR max 5.86785 is not an upper bound for per-ray kernels, future lights or accumulators. Do not clamp contributions to one.
5. Full candidate render requires freshly derived snapshot/AA/floor/background preflight facts and work ledgers, plus a reviewed acceptance plan. The completed original fixed42 gate is not reusable for new lossy inputs; no checks were weakened.
6. S3 compile/assembly validation must match the scalar integer rounding and bounds, including packing/tails/register clobbers. Only then can target cycle/memory and whole-render measurements decide adoption. No S3 speedup is established here.

## Limited host performance check

The final strict-flag run benchmarks only one rho component on this x86-64 host, with automatic vectorization/LTO disabled and `-ffp-contract=off -fexcess-precision=standard -fno-fast-math`. At width8, CPU-clock medians were 5.219 ns/pixel for the frozen double expression, 6.883 for prepared integer data, and 44.748 for integer interpolation including double-to-integer weight preparation, gathering and output dequantization. Thus this run found no prepared-kernel speedup; the mixed path was about 8.57 times slower for this one component.

All 72 final raw samples are retained, as is the earlier v1 run. This is a short shared-host observation, not a precise universal ratio or S3 prediction. Preparing weights once across multiple normal/RGB components can amortize costs; do not multiply these timings by component count. Source vertex encoding was already offline in the mixed test. The finding is that converting only the final operation to fixed arithmetic is insufficient evidence of a useful optimization. Integer weight generation, reusable prepared weights, layout and the actual target SIMD backend must be evaluated together. See `kernel/BENCHMARK.md` for binding, preflight and all widths.

Detailed provenance and reproducible commands are in the subdirectory reports. All numerical/asset-derived artifacts remain private; generic source publication must use a reviewed allowlist excluding private datasets, model copies, actual-source reports and binaries.
