# Pinned camera-background scene comparison

## Scope and immutable inputs

This is an external read-only analysis of the fixed lid8/A2 quarter-sample scene-composition arm. It does not render, benchmark, change the model, source scene, reference, tone mapper, AA samples, coefficients, or thresholds. Prepared inputs and old scorer code remain untouched. All analysis output is written to a fresh directory beneath `analysis-code`.

`TRUST_INPUTS.json` was frozen before this analysis examined ON quality. Its caller-held SHA256 is `d4392ca85bf91d6c287241549d0d8c5bd43941723bd846db6bd8803554714183`. It binds PREPARED, the entire prepared input-hash inventory, the A2 completion and previously computed formal score, scorer dependencies/reference pins, and original attribution definitions and center winners. PREPARED SHA256 is `0ee50b4df2def6794c3331f3cbb034f12d150b7158fd07c4b6b503ecb2cf1749`; prepared input inventory SHA256 is `c4f5891539ef2efc15517de8b3a5e15d6ee8eba49242a66599bfad71164f5631`.

The separate completed-output inventory must be pinned by its SHA256 supplied by the caller. It covers every selected arm's COMPLETED and every declared frame output, plus the composition audit, its v3 source and encoder. A recomputed candidate-local manifest cannot substitute for that external root of trust. The freeze helper only inventories completed data; it does not assert validity. Full validation occurs in the loader and is repeated after scoring. No provenance hash alone proves renderer fidelity; the separately executed composition fixtures/audit provide that evidence.

## Strict admission

- A complete arm is exactly front/oblique × baseline/direction/intensity/ambient/albedo × forward/reverse. Duplicate, unexpected, missing or wrongly typed keys are rejected. Frame prefixes and extension keysets must match. Every declared output hash must match both COMPLETED and the external output inventory.
- PREPARED's binary, source freeze, plan freeze and input hashes must agree. Every prepared input is checked. JSON duplicate keys, nonfinite values, traversal and symlink aliases are rejected. Python optimized mode is rejected because the unchanged validators use assertions.
- COMPLETED metadata must exactly equal the actual frame JSON. Its keyset and all non-time fields must match the already-pinned A2 frame. For background-only, character-work counters must be zero. Time fields may vary but must be nonnegative integers.
- OFF's RGB, character depth, snapshot, target mask and character raw samples are byte-exact A2. ON retains the same character depth, snapshots, targets, character work and raw samples. Both replay unchanged `aa_contract.validate` with exact preflight hits, snapshot and ledgers.
- ON/background replay unchanged `background_contract.validate`, including independent fixed new resource caps, all work categories, exact fixed slot/query counts, classification and generation bindings. The full v3 composition audit must match all20 output hashes, exact frame identity, key uniqueness, fixed KEEP/FLOOR counts and expected two front overrides. Audit source and encoder hashes are verified, including the audit's own recorded source hash.
- Every arm's forward/reverse RGB and character depth hashes must be identical. Character depth is constant across its five cases. ON and OFF formal shape must remain identical.
- `background` denotes the synthetic camera-hidden/shadow-kept control. Its output directory is `background-control`; the existing prepared `background` directory contains source. Its depth must be all negative infinity and character raw samples empty. It cannot be passed to the formal scorer.

## Formal mathematics stays unchanged

`score_candidate.py::score` and its exact frozen v3 reference evaluator are executed unchanged. The only new behavior is strict admission of scene RGB outside character depth for this explicit pinned arm. Direct RGB565 decode remains R5/31, G6/63, B5/31 as float64. The reference remains eight paired PNG8 seeds with the exact integer luma numerator, threshold 20000/2550000 (2/255), all-seed consensus and fixed Student-t confidence interval.

Formal scoring stays on original source foreground alpha > 0, with unchanged stable, uncertain and full-foreground domains. Finite original character depth, not scene color or background depth, defines geometry. OFF's all10 numerical condition results must equal the saved A2 formal scores exactly, excluding only candidate runtime metadata. The unchanged scorer returns `NOT_ESTABLISHED` global acceptance and its conditional goal60 status; no scene-area score can replace that.

## Predetermined descriptive strata

The original alpha mask, original native center winners and original 4-neighbor target boundary define all masks, never new output errors. The center winner support is checked against A2 depth and the recomputed target is checked against A2's saved target bytes. Original attribution counts are checked for each matching domain. Each resulting boolean row-major mask has a reported SHA256.

The domains are full frame, source background complement, full source foreground, opaque alpha255, partial alpha1..254 (foreground edge), center-covered foreground, center-missing foreground, covered target boundary, covered non-target interior, missing target boundary, missing non-target, opaque covered interior and opaque covered boundary. These overlap intentionally and are never pooled together as disjoint evidence.

For all10 view/case images, report decoded RGB absolute and signed errors against the reference mean, reference-stable and unknown subsets, and each of eight seeds. Baseline has no response contrast and is explicitly N/A. For the other eight view/contrast combinations, reuse the frozen evaluator's full/stable/unknown/per-seed response metrics; all statuses are descriptive. Also report exact bright/dark/inactive/unknown confusion, FP/FN, inactive FP, reversed signs, response-error sums and magnitudes. Unknown rows remain visible and never count as passes. Empty domains are null/N/A, not zero-imputed successes.

All new full-frame/background/control scores are descriptive only. A filled missing character pixel is camera radiance, not shape repair. The background-only synthetic control is never treated as an original source pixel input or a formal shape candidate. There is no aggregate acceptance score or background-area-weighted goal60.

## Run and deliverables

1. After the relevant arms and composition audits complete, run `freeze_completed_outputs.py` with their root, arm list, v3 audit source and encoder. Retain its printed inventory SHA256 independently.
2. Run `strict_scene_score.py` with the fixed trust SHA256, output inventory and its caller-held SHA256, requested arms, and a fresh analysis output directory. `--admit-only` stops before reference scoring. OFF is always also admitted for ON or background.
3. Run the focused synthetic tests with `python -B -m unittest discover -s <analysis-code> -p test_strict_scene_score.py -v`. These do not render or edit prepared inputs. They supplement, not replace, the physical integration tests.

Numerical results are JSON reports, not raw pixels. Generated files exclude source meshes, source renders, PNG images, raw RGB/depth, raw sample JSONL and NPZ masks. The final code/report bundle may include the Python analysis code, this design, trust/output inventories, tests and result summaries. Raw inputs remain private outside the bundle. Timing/resource conclusions belong to the separately pinned host measurements, not this quality scorer.
