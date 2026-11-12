# Fixed-HDR display comparison: external metrics contract

This directory is an observation-only extension of the completed camera-floor scene analysis. It changes no renderer, model, scene inputs, source or reference images, lighting, exposure, filter, sample count, threshold or original scoring mask. It does not execute the renderer or either display transform. The only scored new observations are the externally pinned legacy and AgX RGB565 frames.

## Admission order

1. Verify the original scene loader SHA256 `c265987817d6c3508d0b794f0a945b45d60d24f59e2f1f8e38b067565196f2fb` before loading it. Instantiate its unchanged Admission using original TRUST_INPUTS SHA256 `d4392ca85bf91d6c287241549d0d8c5bd43941723bd846db6bd8803554714183` and original ALL_OUTPUT_PINS SHA256 `88c5f4d7d68e111795cc25b53d55e472dfec8da58c27d63985e02823e7b05259`. Load the actual-002 ON arm, including its unchanged OFF dependencies and composition checks.
2. Require caller-supplied SHA256 values for the new input and completed-output inventories. Workspace-relative `{files: ...}` and the parent's flat absolute input map are admitted only after strict workspace containment, path normalization, duplicate-normalized-path rejection, no-symlink verification and file hashing. The profile's separately frozen installed OCIO inventory is verified at its fixed SHA under a bounded installed-path policy.
3. Verify the fixed plan and plan inputs. Require all10 legacy gate and all10 display completion, linked input and legacy-gate hashes, identical HDR, unchanged source inputs and character depth, no clamp exclusions, and the fixed profile input freeze. Require the independently pinned center-HDR source/input equivalence proof. This proof is source-derived, not a nonexistent current center-f64 capture or an inverse RGB565 reconstruction.
4. Independently compare all 32,400 RGB565 pixels of each of the ten reconstructed legacy frames to the already admitted v38 camera-composed files. Complete all ten comparisons before decoding any alternate profile frame. Reject missing, duplicate or unknown view/case rows and failed/rejected runs.
5. Read each new RGB565 frame, borrowing exactly the admitted original character-only f32 depth. Display completion must name that same depth hash. This new explicit observation contract permits scene radiance outside character depth; it never treats that radiance as geometry.
6. Reuse the unchanged formal scorer, frozen reference loader, stable/uncertain masks, numerical evaluator and original fixed attribution domains. Require exact legacy-v38 formal numeric parity, exact pre-existing descriptive parity, all fixed-domain mask hashes/counts unchanged, and exact character-shape metrics between both display arms.
7. Recheck all original and new pinned files before and after writing fresh reports. An output is admitted only under this analysis-code directory after resolved-path containment. No old analysis/report is overwritten.

## Metrics retained

All10 color conditions and all8 response contrasts retain the original formal-v3 mathematics: direct RGB565 R5/31, G6/63, B5/31 float64 decoding; original encoded-luma weights; reference PNG8 integer numerator and strict 2/255 threshold; eight-seed consensus and fixed mean confidence intervals. Stable, uncertain, pooled full-foreground and each-reference-seed results are not pooled into a new acceptance metric. Baseline has no response contrast. Nulls and unknowns are never zero-imputed or passes.

All original 13 attribution domains are retained: full frame, background, full foreground, opaque alpha, partial alpha edge, center-covered, center-missing, covered native boundary/interior, missing native boundary/non-target, opaque covered interior/boundary. Color reports preserve all/stable/unknown/per-seed errors. Response reports preserve all frozen subset/per-seed metrics, full bright/dark/inactive/unknown confusion tables, FP/FN, reversal and active-to-inactive counts. Added single-seed confusion tables use the evaluator's exact per-seed integer response labels and are explicitly not consensus-stability claims.

`SCALAR_AUDIT.json` compares every metric/count scalar leaf, including all seeds and all overlapping domains. It preserves all directional regressions, improvements, neutral changes and undefined transitions. Candidate class populations, significant-pixel counts and reference/unknown counts have no assumed monotone quality direction. Signed error compares absolute bias. Confusion off-diagonals/FP/FN/errors are lower-better; diagonals/IoU/agreement/correlation are higher-better. Counts are diagnostic bookkeeping, not independent experiments or a quality vote. Per-pixel reference coordinates and frequency diagnostics remain in the frozen formal report, not in the scalar metric count.

## Clamp and saturation accounting

The private pinned per-frame NPZ masks are read with `allow_pickle=False`, exact bool dtype/shape/key checks, and independently recomputed from the pinned final averaged float64 HDR and RGB565 frames. Legacy input saturation means any HDR channel > 1. Profile-domain clipping uses the actual float32 input promoted to double and compares it with the frozen upper domain 5898.240000132513. Negative/nonfinite/float-overflow HDR fails admission. AgX and legacy quantized zero/max endpoints are separate diagnostics, not LUT-domain clipping.

`CLAMP_STRATA.json` counts every flag on the same fixed domains and color-stable/color-unknown plus response-stable/response-unknown subsets. These flags are never passed into a scoring mask, never discard a sample and never normalize a metric.

## Scope and saved files

The existing profile is an official-OCIO-derived float65 tetrahedral LUT approximation, not exact OCIO processor equality. Exposure 0, gamma 1, dither 0 and the existing Medium High Contrast look stay fixed. No display-quality result establishes goal60, global acceptance, old1M/8M compliance, product HDR-storage fit or a device result. Reconstruction and host profile timing/cost belong to the separately pinned parent run.

`BUNDLE_ALLOWLIST.json` lists individual code/tests/design and final aggregate-report files only. Raw reconstructed HDR, RGB565 pixels, depth, sample/composition events, reference/source images, models, raw masks/NPZ files, LUT assets and binaries are excluded. This analysis does not copy, publish, upload or commit those assets.

## Invocation after parent publishes all gates

Run strict_display_score.py with --input-pins pointing to run-001/POSTPROCESS_INPUT_PINS.json, its externally supplied --input-pins-sha256, the externally frozen output inventory and --output-pins-sha256, --legacy-gate run-001/LEGACY_CONTROL.json, --completion run-001/COMPLETED.json and a fresh --output under this analysis-code directory. No scoring may run while either gate is incomplete. Unit tests use synthetic values only and may run before completion.
