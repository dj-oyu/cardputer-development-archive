# Fixed-mask analytic BH-quartile AB, current lid8

Final status: B rejected at its first frame, 0 complete and unscored. This experiment changes only the selected AA four sample positions from ±.25 to ±0.28820947825813636. It does not change geometry, rig, source, reference, materials, lighting, shader, thresholds, sample count or weights. One AB only, no result-driven tuning. It is continuous-BH-derived quadrature, not exact Cycles filtering or its finite float inverse-CDF implementation.

Source and preflight independently pass. Author A/B OFF controls and A ON replay complete. B fails before its first complete frame; no B quality outcome exists. Original old49 algorithm remains rejected: with B offsets front8,202,095 exceeds8M. Approved host-stage ledger has front7,951,722 / oblique7,729,766, not an equivalent old work unit. RAM/RO/caps unchanged.

The final-visible-only experimental error contract remains distinct from original renderer. Original A quarter-node exact zero-normal failure remains tested; B's different positions do not hit that zero, and its added final-sample callback-failure test proves failure propagation, not a B zero-normal construction. Memory safety validation remains unconditional.

Four-node quadrature has aliasing limitations even on ideal fixtures: centered0.5px strip integrates to0.441024827611 under continuousBH, while B's nodes miss it completely. Constants/affine exact; B axis-step maxerror.25 and strip supremum.5. A's corresponding bounds against BH are about.27949/.55898. No universal improvement claim follows.

Frozen center-derived mask cannot guarantee all BH-support boundaries, center-missed thin lines or same-object internal overlap. Non-target bytes remain old center output; sample support is not geometry/depth improvement. BH full support±1.5 is distinct from the four selected node positions. No full-frame filter equivalence, default/product/devicefit/60% attainment claim.

CPU comparison NOT_TESTED: the planned12serial A/B×2baselineview×3 measurement was not started after B failure.

## Final observed outcome: B rejected before first complete frame

A fresh binary is byte-identical to v32 (9d62fb7205ec6dd8c3b6e5ac0fbad8a7008e894b0f7cd77f2e003b0172c246c8). Fresh A OFF20 and ON20 complete. A ON120files (20×RGB/depth/snapshot/mask/sampleJSON/ledgerJSON) exactly match v32. B fresh OFF20 also matches old controls. B ON front-baseline-forward fails, zero complete frames. No completed B manifest, formal score, comparison image, all10 claim, or CPU comparison exists. Remaining19 B frames were not attempted after whole-run rejection. No sample/mask/offset reduction or retry to achieve success occurred.

Failure is NOT resource exhaustion: observed stage4,825,637 against reserved7,951,722; direct332,200 rays/19,904,118 nodes/6,239,943 tests; transport3,739,135/260,047,101/92,041,994. All within unchanged caps. Partial observer3619 samples includes2941 successful hits. No partial quality aggregate is reported.

Separate instrument-only copy repeats the exact failure. It prints existing false-branch locations and shader status without changing values. At pixel(123,53), sample0(−q,−q), node30 face4, back=true, original canonical edge arithmetic produces barycentric sum1.0000000000000204. All three red palette values decode to1, hence rhoRed has the same value. Existing pre-shader rho guard permits at most1+64DBL_EPSILON=1.0000000000000142 and rejects. No shader is invoked for this failing sample. Primary normal is finite/nonzero; no evidence supports a zero-normal or transport-quota cause. C standalone reproduction with original O2/ffp-contract=off/fexcess-precision=standard confirms the exact values (RHO_GUARD_REPRODUCTION.json). An algebraically rearranged Python edge calculation yielded a different roundoff sum1.0, so it is not the actual arithmetic control; both private diagnostics are retained, actual C is authoritative.

This is a newly exposed finite-precision interpolation-domain boundary, not evidence that BH sampling quality improved or worsened. No old±.25 observer assumption caused it. Epsilon, clamping, normalization, source, normals, geometry and offsets remain untouched. Any numerical-contract repair is a separate decision and must preserve this failed experiment; it is not silently part of the one-shot AB.

CPU A/B comparison and full metric/uncertainty/FPFN reporting are unavailable because B did not produce a complete candidate. Synthetic and resource results are retained but do not replace actual quality results. Instrument runtime is not a performance benchmark.

Independent source/preflight/core O2+ASan and O0/O2 single-point failure reproduction all agree. No unresolved diagnostic blocker remains for this failed experiment. See reviews aggregate evidence.
