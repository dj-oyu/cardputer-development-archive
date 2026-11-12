# Private four-surface reduction result

**No candidate admitted.** Every fixed-ladder candidate violates the frozen geometric conditions. The source blend and baseline actual asset remain unchanged. No render/image-score selection, additional budget search, uploads, public operations, or device work occurred.

The numerical oracle now passes source→source identity, twelve analytic closed-box fixtures (inside/outside/exact boundary/±2δ/±1.001δ/±0.999δ), and 2400 independent double-precision ray parity comparisons. Initial broken float32 sequential parity diagnostics are retained and explicitly invalid. Winding intermediates use extended precision; the unchanged geometric margin is 9.452928309474042e-06 source units (1e-5 times joint shape diagonal).

Independent review additionally passed 1000 box points, 20 near-margin points, seven analytic face/edge/vertex nearest fixtures and separated-surface tie detection (independent-oracle-review.json). Final clearance/correspondence nearest points are all-triangle float64, not float32 BVH.

## Fixed ladder and results

| Stage | Actual total (delta) | Robust reversals, all samples | Fixed-source reversals | Max source-inside clearance leaked | Fixed-source development ray failures | Fixed-source holdout ray failures |
|---|---:|---:|---:|---:|---:|---:|
| baseline | 1166 (+0) | 1754 | 1740 | 0.04569065 | 58529 | 37768 |
| stage-1 | 1210 (+44) | 1239 | 1223 | 0.02938130 | 40860 | 25248 |
| stage-2 | 1314 (+148) | 391 | 383 | 0.00950410 | 17858 | 10728 |
| stage-3 | 1520 (+354) | 260 | 245 | 0.00735347 | 12440 | 7590 |
| stage-4 | 1938 (+772) | 95 | 84 | 0.00308169 | 6036 | 3856 |

All fixed-source containment comparisons use 5208 samples total. Both original and candidate vertex/centroid families are included in admission gates. Fixed-source-only breakdowns remove candidate sample-count growth from descriptive improvement rates. Candidate-side mapped points and all ambiguity/tie records remain in per-side sample JSON. Every pad is closed, consistently wound, and positive-volume. Both improper inside leakage and source-visible Smile hiding remain, including clearances far above δ; these are not just near-boundary ambiguities.

The heldout view sweep is separately reported validation, never a means of reranking candidates. All candidates already failed development geometry conditions. Finite sampling is not a proof over every surface point. No candidate is promoted for actual-C rendering; parent owns resource and formal fidelity admission.

## Preservation and reproducibility

build.py exports evaluated original clones and collapse-decimates only Muzzle pad ±1 and Smile ±1. Only four primitive accessor references change in the baseline asset; exported streams are appended. All 24616 original buffer bytes remain byte-identical, including unrelated geometry/normals. All unrelated mesh/accessor/bufferView entries and every node/material JSON value remain exact. Original material assignments, sidedness, and coordinate conventions are retained. JSON is reserialized, so JSON text bytes as a whole are not claimed invariant.

Source SHA256: 9254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806
Baseline SHA256: 9c6ea7e1f6ee83101a3249de6c482cb8bca1e3943d9448c7701eafb173f6c78c

Artifacts: build-report.json (candidate paths/hashes/costs), audit-contract.json (numeric fixed views/δ), audit-summary.json, results-summary.json, oracle-validation.json, ray-families.json, per-stage audits and per-side samples. Code: build.py, audit.py, validate_oracle.py, ray_families.py, summarize.py. Run Blender scripts with blender -b -t 2 --python SCRIPT; summarize.py uses Python. No source .blend save is performed.

Next action requires a new explicit geometry method/contract, not tolerance relaxation or pixel-specific changes. The completed fixed-ladder search terminates here.
