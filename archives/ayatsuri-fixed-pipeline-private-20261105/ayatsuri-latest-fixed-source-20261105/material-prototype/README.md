# Private latest-model material arithmetic prototype

## Scope and provenance

This is a Python checked-integer arithmetic model and a declared float32 source-operation interpreter, not compiled Cycles, a Blender shader execution, an image comparison, a native PIE kernel or a renderer integration. No render, bake, ray, visibility, geometry ownership or shared renderer changes are made. Historical old-model tests are not evidence for this model.

Original fox-bubble-bold.blend SHA256: d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a. Explicit local data comes from ../.. / fox-cardputer-latest-private/2k-v2-neutral-sidecar.json (without spaces in the actual path), SHA256 00a81fbcd19c79c578bbbbd7ab077ee6f63048a106c5594675ff208670d5e85e. Graphs, defaults and driver strings come from ../inventory.json; ramps from ../supplement.json. Immutable primary semantics and their source manifests are in ../material-plan/: Blender v4.3.2 commit 32f5fdce0a0a571a39198edf8d7b5d719bf59f2c. Original and input hashes are recorded in provenance.json.

Only the two live sclera recipes are interpreted. Hidden legacy iris is absent from this LOD and no Iris gradient attribute is consumed. Object-local XZ is not world position, UV or generated coordinates. Outputs are BaseColor, clamped Principled MixClosure factor, complementary transparent weight and numeric Roughness/IOR/Specular IOR Level. No closure BSDF, transparency traversal or lighting is evaluated.

## Contract

Inputs are explicit finite tuples and local XZ within X[-1,1], Z[2,3.2]; this is a rejected-outside specimen domain, not a full safe-range theorem. Fixed pixel evaluation requires integer coordinate codes; all integer arithmetic is checked against signed64 limits and rejects overflow. qvalue/check do NOT restrict to int32. Python wide integers allow detection before accepting an out-of-range intermediate; this does not constitute a portable C implementation or C sanitizer run.

Uniforms validates named controls. Gaze X/Up and Bubble Pressure are in [-1,1], Blink controls, highlights and reflection in [0,1], Eye Style in [0,2]. Source UI limits are not enforced Blender limits: this prototype explicitly rejects wider inputs. Fractional Eye Style boundary cases are diagnostic supplied tuples, not ordinary integer UI states. Raw-pressure quartic and clamped pressure remain separate formulas. Stored driver strings are checked against eight known formulas and bindings but NEVER eval'ed. Declared high-precision control preparation then rounds Value sockets to float32. This is not a full integer control-to-material pipeline: future per-frame control formulas still need fixed implementation and separate validation. The “all_math_fixed” name covers graph Math including uniform Math, not driver/control formula preparation. The 257-entry RGB ramp is prepared offline with declared float32 Blender-source order, then quantized; it is not replaced with direct six-stop interpolation.

Oracle arithmetic explicitly rounds float32 after each declared operation, without FMA. It does not prove compiler folding, backend, driver engine, denormal or actual Cycles behavior. Fixed math uses nearest ties-even for scaled multiply/divide and quantization; integer sqrt rounds to nearest, with no attainable half tie for integer radicands. Source SQRT clamps negative input to zero. Source DIVIDE returns zero for an exact source-zero denominator; a nonzero denominator quantized to zero rejects rather than silently producing zero. Reachable divisions use the nonzero contract. Clamp/min/max behavior is source semantics, not overflow saturation. Ramp lookup clamps factor and interpolates the 257 samples; LegacyMix factor always clamps even though output use_clamp=false.

## Fixtures and results

Each series/precision tests 7,176 explicit points across two eyes and 12 finite control states: 1,392 saved vertices, 3,720 declarative triangle barycentric points, 1,920 analytical boundary neighbors and 144 sqrt-tip points. This is not all-animation coverage. States include saved neutral, gaze/pressure endpoints, blink .02/.5/.98/1 and style thresholds. No screen or hit sampling is generated.

Coordinate-only series quantizes XZ then runs float32 graph; full-fixed quantizes XZ, prepared values/constants and all graph math. Results.json contains max/RMS/p50/p95/p99, numeric parameter error, per-kind errors, rejection counts and worst cases. Threshold-disagreements.jsonl retains every differing comparison, operands, codes, signed margins and source ULP differences.

| series | frac bits | comparison-changing samples | RGB max | RGB p99 |
|---|---:|---:|---:|---:|
| coordinate only |16|275|.998997|.998000|
| coordinate only |20|52|.998997|8.05855e-5|
| coordinate only |24|4|.998828|5.24521e-6|
| all graph math fixed |16|275|.998997|.998001|
| all graph math fixed |20|103|.998997|.996520|
| all graph math fixed |24|39|.998828|6.79493e-6|

All differing predicates in these fixtures occur in deliberate boundary points, not saved vertices, barycentric points or sqrt tips. Ordinary barycentric maximum RGB error falls from .00232857 to .000124037 to 8.40425e-6 for coordinate-only Q16/Q20/Q24; full-fixed gives .00416863, .000213653, 1.32322e-5. These ordinary improvements do not eliminate nearly unit RGB changes at a strict highlight edge. Mix-factor maximum error is zero except full-fixed Q24 (9.53674e-7). No sampled domain/overflow rejection occurred. See THRESHOLD_POLICY.md for a future interval warning design and finite local scans; no smoothing or predicate modification is proposed.

Widths1/2/4/8 pass 1,152 exact block equality checks using the SAME scalar evaluator and varying inputs. This establishes grouping independence only, not eight-lane instructions, true parallel execution or performance. Extra endpoint/negative tests are in test_edges.py.

## Integer widths and possible hardware mapping

Observed full-fixed maximum codes are 71,349,683 / 1,140,396,676 / 18,247,164,471 at Q16/Q20/Q24 (27/31/35 magnitude bits); maximum checked products are 4,546,153,173,241 / 1,162,524,941,472,400 / 297,620,241,719,472,400 (43/51/59 magnitude bits). These cover sampled graph/frame evaluation, not a proof over the whole declared domain. Q24 requires wider-than-int32 intermediate codes; the current model is int64, not a uniform32 implementation. Coordinate-only instrumentation in results includes an unused fixed-frame preparation and is NOT its runtime operation cost.

A future schedule could prepare 39 control-only Math nodes once per frame/eye and batch 77 spatial Math nodes. Nine spatial divisions have fixed denominators, so validated reciprocal constants may replace division only with explicit rounding/error analysis; the sole variable division and one sqrt are uniform. One spatial sqrt remains. Large normalized ellipse coordinates and their squares need at least 32x32→64 in the Q20 model; PIE eight-lane16 multiplication cannot directly replace those operations. Already bounded [0,1] color/mix quantities or /32767 normals elsewhere can be candidates for separate16-bit formats, with new error proof, not silent narrowing of this model. Eight QR registers, SoA gathers, control broadcasts, table gathers, LUT cache traffic, integer sqrt/wide multiply/divide and register spills need an actual schedule and measurements. No timing, S3 speedup or adoption recommendation is inferred from counts or block equality.

## Reproduce

From workspace root:

    python ayatsuri-latest-fixed-source-20261105/material-prototype/run_experiment.py > ayatsuri-latest-fixed-source-20261105/material-prototype/run.log
    python ayatsuri-latest-fixed-source-20261105/material-prototype/scan_boundaries.py > ayatsuri-latest-fixed-source-20261105/material-prototype/boundary-scans.log
    python ayatsuri-latest-fixed-source-20261105/material-prototype/test_edges.py > ayatsuri-latest-fixed-source-20261105/material-prototype/test-edges.log

No downloaded software, Blender scripts or source driver expressions are executed. The output is a bounded arithmetic feasibility experiment; runtime controls, actual evaluated coordinates, renderer material binding, certified fallback intervals, SIMD implementation and image parity remain unimplemented.
