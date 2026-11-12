# New reference-only uncertainty evaluation v3

Status: 80 reference renders plus 2 masks completed and reference-only stability measured. Independent provenance, evaluator replay and independent-formula numerical review PASS. No candidate is available, so 60% quality attainment is NOT EVALUATED.

## Provenance and scope
The previous late-stage pixel/GGX candidate and v2-2048 reference pack were not found in available saved artifacts. Historical scores are not claimed as newly reproduced. The original editable blend is present at SHA256 9254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806. The old cameras.json is present at SHA256 be0ed60c540fe713431eaa7bad46ec65cba3a926894d1303ef1dcf3a3c83b215. Both are explicitly adopted for a new reference version, not asserted byte-identical to the missing late-stage contract.

The recovered code-only runner ZIP SHA256 is 3e41edd011df4bd64cefd9aba6fd19ec31a1dbd1de3e7283577ff20ad211bb7e. Its rich-render section confirms the scenario operation definitions, but the private manifest/config values were excluded from that archive. No substitute native candidate is scored.

## Fixed statistical plan
See PLAN.md, plan.json, plan-freeze.json, NUMERIC_ADDENDUM.md and numeric-freeze.json. Eight independent seeds, paired across cases, at fixed maximum 2048 samples and eight threads. No score-driven additional seeds/samples. The 95% Student-t interval is a pointwise, model-dependent interval for the mean paired response, not simultaneous or future-render coverage. All-eight class consensus and CI class agreement are both required. Stable inactive pixels remain in the comparison domain to retain native false positives. Uncertain components never become success/zero error. Less than 90% stable coverage is a descriptive warning, not a new acceptance requirement.

PNG8 reference luma uses exact integer weights and threshold. Candidate RGB565 is not quantized to PNG. Empty unions are N/A, never PASS. Color CI halfwidth measures precision of the estimated mean, not correctness against the candidate.

## Geometry foreground
New independent source-only mask: both declared cameras, max128 samples, seed0, adaptive OFF, ground hidden, transparent film. Alpha8>0 is the fixed foreground; partial-alpha boundary size is reported separately. Finite mask sampling/alpha8 quantization cannot guarantee recovery of every arbitrarily small subpixel feature. Rich color renders retain original ground/world/material/light/film settings. Camera matrix, clip, scale, resolution and object visibility are compared between mask and color records. Source is never saved or overwritten.

## Tests and reproduction
python fox-reference-uncertainty-v3/code/test_evaluator.py
python fox-reference-uncertainty-v3/code/test_pack_validation.py

Tests cover CI versus consensus, both strict threshold boundaries at all gray origins, false positives on stable inactive areas, unknown/empty domains, color precision versus accuracy, candidate-independent classification, finite/shape/type validation, constant-field Pearson undefinedness, seed identity, missing/duplicate samples, metadata and image hash corruption. Synthetic tests do not validate actual rendering or demonstrate image fidelity.

## Remaining decisions and limitations
New scenario values were explicitly fixed before rendering and the contract passed independent preflight. The 80 PNG reference samples and fixed source masks are complete. Native quality, shape fidelity and complete goal attainment remain unassessed until a new separately versioned candidate is available. Object-level attribution is unavailable unless a source object map is generated; uncertain pixel coordinates and foreground coverage will be retained without guessed labels. Possible causes include Monte Carlo variance, adaptive stopping, 8-bit display/dither quantization and threshold proximity; this plan alone does not prove a unique cause.

## Measured results (new v3 only)
80 fixed seed/case/view images and 2 independent source masks completed. No candidate was evaluated. Overall renderer-quality goal: NOT EVALUATED, not PASS. Every response condition retains an uncertain remainder.

| View / case | Stable response % | Uncertain pixels | Stable bright / dark / inactive | Color mean-precision stable % |
|---|---:|---:|---|---:|
| front-baseline | N/A baseline | N/A | N/A | 80.1583 |
| front-direction | 86.2634 | 729 | 1411/2773/394 | 76.2201 |
| front-intensity | 86.8852 | 696 | 0/4291/320 | 72.8095 |
| front-ambient | 98.6056 | 74 | 5227/0/6 | 82.4383 |
| front-albedo | 99.9623 | 2 | 0/5305/0 | 75.8055 |
| oblique-baseline | N/A baseline | N/A | N/A | 76.5337 |
| oblique-direction | 88.1050 | 698 | 709/4073/388 | 70.2795 |
| oblique-intensity | 90.9168 | 533 | 0/5086/249 | 67.7744 |
| oblique-ambient | 98.8241 | 69 | 5781/0/18 | 78.5787 |
| oblique-albedo | 99.9489 | 3 | 0/5865/0 | 70.3476 |

Source foreground: front 5307 pixels (1148 partial-alpha boundary), oblique 5868 (1285 boundary). This is a new fixed source mask, not a recovered old mask.

Intensity: some seed has a >threshold brightening at 21 front / 17 oblique source pixels, but zero satisfy both all-eight consensus and mean-CI stability. They are uncertain, not silently removed or scored as success. Ambient darkening occurs at 2 front / 0 oblique pixels across seeds; no stable darkening. Albedo has 0 front / 1 oblique ever-bright pixel; no stable brightening. These findings are about this new scene-test contract, not a reanalysis of the missing old residual coordinates.

Uncertainty is not confined to those rare reverse-sign pixels. Direction/intensity response domains retain 9.08–13.74% uncertain foreground. Color mean precision leaves 17.56–32.23% uncertain pixels under the fixed halfwidth criterion. This measures mean precision, not similarity or per-render repeatability.

Every uncertain response pixel, frequency and interval is preserved in uncertain-response-pixels.csv and evaluation.json. Full masks/arrays are in evaluation-masks/*.npz. Coordinates are source image x/y, not guessed anatomy/object labels. Seed class disagreements explain most classification rejections; small additional sets fail the CI criterion despite matching observed classes. Both partial-alpha boundary and fully opaque interior uncertainty occur. Monte Carlo, adaptive stopping, display dithering/quantization and threshold proximity are plausible contributors; causal shares are not isolated.

## Execution preservation and reproducibility
Config hash: 4a9d836a4dae2fc570f5f0fb99690ab0f13fbe394589f785b56e891e0573dc40
Execution freeze hash: 345e096db5211ec3943b052ce243c3dab2cc1a32879a3b3aec799c62db2641f4
Evaluation hash: e7c8fc28e564e39fc5d3ca558e265236821d8917f3410b7fb2cfef7fed234008
Source SHA after run: 9254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806

Run: bash fox-reference-uncertainty-v3/run.sh
Rescore existing references only: python fox-reference-uncertainty-v3/code/evaluate_pack.py fox-reference-uncertainty-v3

Attempt 001 was interrupted by executor-session transport/key recovery after 7 completed images. Blender absence and a nonadvancing manifest were checked before restart. The original code/config resume path preserved all 7 completed PNG/metadata records byte-for-byte and generated only incomplete cases. No statistical plan or seed changed. Attempt log and seven-row manifest are preserved.

Original source requires its verified private blend at the configured path. The small code/report archive excludes source assets and generated images; its hashes identify the complete local evidence. Old late-stage data remain unavailable; no claim that they were restored or retained as current files. Historical NOT_MET status is not converted into PASS by this reference-only study.

## Independent verification
Independent review confirmed all 80 images plus two masks, all frozen code/source hashes, exact preservation of the first interrupted attempt’s seven PNG/metadata records, and byte-identical isolated evaluator output. A separate formula implementation using integer sufficient-statistic variance and an independently obtained t quantile (without importing the evaluator) matched all eight response masks and ten color-precision masks, counts, uncertain coordinates, frequencies, confidence intervals and diagnostics. Evidence: independent-review.json. This verifies the new reference analysis, not native fidelity or global convergence.
