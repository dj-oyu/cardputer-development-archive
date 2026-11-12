# Frozen transport quality review

Scope: formal OFF / WORLD / BOUNCE 16×16 runs only. No rendering or rescoring. All deltas are first arm minus second. Positive agreement/IoU is better; negative RMSE/FP is better. Null stays N/A.

**Global acceptance and the 60% goal remain NOT_ESTABLISHED.** Stable-subset values do not establish whole-image success. Uncertain/pooled/per-seed results remain descriptive.

## Findings

- world-minus-off: stable RGB improves 0/10, worsens 10/10; equal-case mean Δ -1.039 pp (descriptive only). Response sign improves 4/8, luma RMSE 2/8, RGB RMSE 2/8, magnitude agreement 3/8.
- bounce-minus-world: stable RGB improves 10/10, worsens 0/10; equal-case mean Δ +0.462 pp (descriptive only). Response sign improves 7/8, luma RMSE 8/8, RGB RMSE 6/8, magnitude agreement 7/8.
- bounce-minus-off: stable RGB improves 0/10, worsens 10/10; equal-case mean Δ -0.577 pp (descriptive only). Response sign improves 5/8, luma RMSE 3/8, RGB RMSE 2/8, magnitude agreement 5/8.

Bounce recovers RGB relative to WORLD in every case but remains below OFF in every case. Response benefits are mixed. No single overall quality win is supported.

## All 10 stable RGB agreement values and deltas (percentage points)

| Case | OFF | WORLD | BOUNCE | W−O | B−W | B−O |
|---|---:|---:|---:|---:|---:|---:|
| front-baseline | 73.738 | 72.907 | 73.297 | -0.831 | 0.390 | -0.441 |
| front-direction | 73.374 | 72.168 | 72.813 | -1.207 | 0.645 | -0.561 |
| front-intensity | 74.880 | 73.794 | 74.420 | -1.087 | 0.627 | -0.460 |
| front-ambient | 73.593 | 72.495 | 72.839 | -1.098 | 0.345 | -0.754 |
| front-albedo | 77.276 | 76.491 | 76.866 | -0.785 | 0.375 | -0.410 |
| oblique-baseline | 72.607 | 71.702 | 72.120 | -0.906 | 0.418 | -0.487 |
| oblique-direction | 72.527 | 71.132 | 71.767 | -1.395 | 0.635 | -0.760 |
| oblique-intensity | 73.811 | 72.701 | 73.209 | -1.109 | 0.507 | -0.602 |
| oblique-ambient | 72.871 | 71.614 | 72.013 | -1.257 | 0.398 | -0.858 |
| oblique-albedo | 76.294 | 75.578 | 75.856 | -0.716 | 0.278 | -0.438 |

## All 8 stable response changes

Sign and magnitude are percentage-point deltas; bright/dark IoU deltas are converted to percentage points below. Inactive FP is an exact pixel-count delta. Full values, uncertain/pooled/per-seed changes, class FP/FN and signed correlations are in comparison.json.

### world minus off

| Case | Sign pp | Luma RMSE | RGB RMSE | Magnitude pp | Bright IoU pp | Dark IoU pp | Inactive bright FP | Inactive dark FP | Inactive total FP |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| front-direction | 0.697 | 0.008890 | 0.008068 | -5.979 | -0.081 | 1.690 | 2 | 1 | 3 |
| front-intensity | 0.401 | 0.002520 | 0.002268 | -4.930 | N/A | 0.588 | 0 | 1 | 1 |
| front-ambient | -0.650 | -0.006896 | -0.006465 | 9.663 | -1.435 | N/A | 0 | 0 | 0 |
| front-albedo | -0.207 | 0.002456 | 0.000581 | -1.112 | N/A | -0.207 | 0 | 0 | 0 |
| oblique-direction | 0.692 | 0.006710 | 0.006890 | -6.511 | -0.545 | 1.705 | 7 | 0 | 7 |
| oblique-intensity | 0.385 | 0.001525 | 0.001718 | 6.303 | N/A | 1.169 | 0 | -2 | -2 |
| oblique-ambient | -0.657 | -0.007154 | -0.006435 | 8.525 | -1.384 | N/A | 0 | 0 | 0 |
| oblique-albedo | -0.034 | 0.002946 | 0.000530 | -1.420 | N/A | -0.256 | 0 | 0 | 0 |

### bounce minus world

| Case | Sign pp | Luma RMSE | RGB RMSE | Magnitude pp | Bright IoU pp | Dark IoU pp | Inactive bright FP | Inactive dark FP | Inactive total FP |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| front-direction | 1.623 | -0.004074 | -0.004086 | 1.817 | 1.550 | 1.161 | -3 | 3 | 0 |
| front-intensity | 3.082 | -0.001906 | -0.002258 | 2.490 | N/A | 1.711 | 0 | 2 | 2 |
| front-ambient | -0.019 | -0.000524 | -0.000830 | 1.258 | -0.115 | N/A | 0 | 0 | 0 |
| front-albedo | 0.170 | -0.000966 | 0.000828 | 3.307 | N/A | 0.151 | 0 | 0 | 0 |
| oblique-direction | 1.742 | -0.003385 | -0.003568 | 1.835 | 0.590 | 0.894 | 0 | 3 | 3 |
| oblique-intensity | 3.027 | -0.001647 | -0.001534 | -2.052 | N/A | 1.533 | 0 | 0 | 0 |
| oblique-ambient | 0.035 | -0.000193 | -0.000388 | 0.451 | 0.069 | N/A | 0 | 0 | 0 |
| oblique-albedo | 0.068 | -0.001204 | 0.000102 | 2.653 | N/A | 0.102 | 0 | 0 | 0 |

### bounce minus off

| Case | Sign pp | Luma RMSE | RGB RMSE | Magnitude pp | Bright IoU pp | Dark IoU pp | Inactive bright FP | Inactive dark FP | Inactive total FP |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| front-direction | 2.320 | 0.004816 | 0.003982 | -4.162 | 1.468 | 2.851 | -1 | 4 | 3 |
| front-intensity | 3.484 | 0.000615 | 0.000010 | -2.440 | N/A | 2.300 | 0 | 3 | 3 |
| front-ambient | -0.670 | -0.007420 | -0.007296 | 10.921 | -1.550 | N/A | 0 | 0 | 0 |
| front-albedo | -0.038 | 0.001490 | 0.001409 | 2.195 | N/A | -0.057 | 0 | 0 | 0 |
| oblique-direction | 2.434 | 0.003325 | 0.003322 | -4.676 | 0.045 | 2.599 | 7 | 3 | 10 |
| oblique-intensity | 3.411 | -0.000122 | 0.000184 | 4.251 | N/A | 2.702 | 0 | -2 | -2 |
| oblique-ambient | -0.623 | -0.007346 | -0.006823 | 8.976 | -1.315 | N/A | 0 | 0 | 0 |
| oblique-albedo | 0.034 | 0.001742 | 0.000632 | 1.232 | N/A | -0.153 | 0 | 0 | 0 |

## Fixed stable/uncertain scope

| Case | Color stable | Color uncertain | Response stable | Response uncertain | Inactive |
|---|---:|---:|---:|---:|---:|
| front-baseline | 4254 | 1053 | N/A | N/A | N/A |
| front-direction | 4045 | 1262 | 4578 | 729 | 394 |
| front-intensity | 3864 | 1443 | 4611 | 696 | 320 |
| front-ambient | 4375 | 932 | 5233 | 74 | 6 |
| front-albedo | 4023 | 1284 | 5305 | 2 | 0 |
| oblique-baseline | 4491 | 1377 | N/A | N/A | N/A |
| oblique-direction | 4124 | 1744 | 5170 | 698 | 388 |
| oblique-intensity | 3977 | 1891 | 5335 | 533 | 249 |
| oblique-ambient | 4611 | 1257 | 5799 | 69 | 18 |
| oblique-albedo | 4128 | 1740 | 5865 | 3 | 0 |

These reference-only masks/counts are identical across arms. Color and response use fixed source foreground, not candidate depth; missing candidate silhouette pixels are not silently excluded. Response stable includes inactive pixels.

## Shape and caveats

- All 10 depth hashes and full shape metrics are identical across arms. Front IoU 88.134637%, missing 620, extra 11; oblique IoU 87.610619%, missing 720, extra 8. Shape is descriptive, not an acceptance gate.
- Frozen evaluation files independently retain globalAcceptance=NOT_ESTABLISHED and sixtyPercentGoal=NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY for all arms.
- Fine direction attempt failed generic rendering. No fine quality or convergence conclusion; budget cause is not confirmed.
- comparison.json contains exact per-arm values and all three pairwise deltas, source SHA256s, scope, and inactive-FP derivation. Supplied summaries were checked against evaluation values. RGB565 and manifest hashes were checked; no claim that hashes prove renderer fidelity.
- Existing scorer, reference, results and masks were not modified.
