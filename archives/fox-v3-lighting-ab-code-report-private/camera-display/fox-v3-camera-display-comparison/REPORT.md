# Same camera-floor HDR, display-only comparison

All10 reconstructed legacy RGB565 controls passed before the existing AgX float65 profile was enabled. The original renderer was not run or changed. Geometry, character-only depth, samples (±.25 quarter positions), target masks, lights, floor/world approximation, references and thresholds are unchanged. Floor-reflection transport remains OFF. No exposure/weight/filter/LUT fit was performed.

## Evidence and limits

Quarter character HDR and camera replacements are joined by unique (x,y,sample) keys, ordered0,1,2,3, averaged once in linear space, then displayed once. Non-target KEEP centers reuse the earlier actual lid8 finalwinner HDR capture. Reuse is supported by independent source/input equivalence: exact center arithmetic apart from observer/accounting, unchanged physical/visibility code, all10 snapshots/depth and scene bindings, and all model/light/ground inputs. This is not a newly observed current-center f64 comparison; RGB565 equality alone would not establish HDR equality. center-proof/proof.json and its reproducible audit preserve that distinction.

Existing profile is the synthetic-validated official-OCIO-derived65^3 float LUT approximation, not exact processor equality. Original Blender4.3.2 config and all20 installed/copied dependencies match. sRGB display / AgX / Medium High Contrast / exposure0 / gamma1 / dither0 remain fixed. Existing compiled profile buffer is reused, with no LUT generation or compilation. Every output is checked against pinned inputs before/after.

Independent reconstruction review confirms all10 HDR files byte-exact, both displays'648000 pixels byte-exact, all composition keys/averaging/clamp flags, and the220 raw timing statistics. Independent formal and fixed-domain review also completed: 251448 numerical/status leaves agree; 56 output and 68 input pins and all 19 loader regressions passed. No unresolved audit blocker remains before final inventory hash confirmation.

## Quality findings

AgX improves fullframe and background RGB MAE in all10 cases, but those area-dominated values are descriptive, not character geometry success. Formal stable-foreground RGB MAE improves7/10 and worsens3/10. Full-foreground RGB MAE worsens6/10, and stable-foreground RGB RMSE worsens8/10. Full-foreground RGB RMSE worsens all10 cases. MAE is the mean over selected pixel×RGB-channel absolute errors in[0,1], not summed channel L1. Stable, uncertain and full-foreground domains are distinct and retained.

Stable direction brightening IoU improves front.675258→.741875 and oblique.455568→.640224. This crosses.60 for that oblique conditional indicator only; it is not a newly defined whole-character reproduction score. Reversed full-foreground direction classifications still increase125→132 front and117→121 oblique. Inactive false positives also increase; albedo response magnitude agreement declines in both views. Shape and reference unknowns are unchanged. Original foreground geometry missing620/719 pixels remains.

All fixed domains, eight seeds, uncertainties, FP/FN and scalar regressions remain in analysis-code/all-analysis-001. Overlapping diagnostic counts are not independent tests or a quality vote. There is no default-adoption or overall60% claim.

## Conditional milestone, undefined metrics and unknown regions

The frozen scorer declares 42 conditional statuses: 10 stable-color agreements and four response indicators for each of eight contrasts. Legacy has35 MEETS_60, one BELOW_60 and six N/A_NOT_PASS; AgX has36 MEETS_60, zero BELOW_60 and the same six N/A_NOT_PASS. The only status change is oblique direction brightening IoU. Thus every currently defined declared conditional indicator meets60, but this is not a global score or product-fit claim.

The six undefined indicators are intensity brightening IoU, albedo brightening IoU and ambient darkening IoU, in each of the two views. In each, referencePixels=0, candidatePixels=0 and union=0, so IoU=None. These are neither failed measurements nor hidden failures, and are not counted as passes. They differ from the 18 reference-uncertain remainders (10 color cases and eight response contrasts), which remain UNRESOLVED_UNCERTAIN_REMAINDER. The unchanged evaluator keeps sixtyPercentGoal=NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY and globalAcceptance=NOT_ESTABLISHED. No new acceptance definition was introduced.

The per-case stable/full-foreground MAE and RMSE table and all42 statuses are in analysis-code/conditional-summary-001. Main stable metric/count regressions total37; formal scalar regressions including uncertain and per-seed measures total481. These overlap and are not independent conditions. Numerical conditional achievement does not establish full-region fidelity, device resources, or default adoption.

## Clamp and endpoint accounting

LUT-domain clamp flags are zero in all10 cases, with no pixels excluded from scoring. This is distinct from legacy input values above1: baseline11174 pixels front and11791 oblique. Raw-double and float32 input-above1 masks happen to agree on all10 current frames; SATURATION_DIAGNOSTIC.json records both, without claiming a generic equivalence.

AgX quantized zero-endpoint counts mean at least one RGB565 channel equals0. They do not mean the whole RGB pixel is black, and cannot alone establish black-pixel crushing. Endpoint counts are also not the LUT-domain clamp flag. All fixed foreground/background/edge/interior/missing/uncertain breakdowns are retained separately.

## Cost and storage

The220 calls measure11 repetitions per display and frame, in fixed legacy-then-AgX order. All outputs are consumed and byte-checked. Another model task was active, so these are concurrent functional-run host elapsed references, not isolated benchmarks or device timings. No sample was discarded or selected for speed. Median ranges across10 frames are legacy0.887–1.106ms and AgX3.110–3.645ms. Raw nanoseconds/min/median/max are retained. The timed reconstruction segment (background-event JSON join, ordered accumulation and finite checks) totaled4.736435924s. It excludes earlier input admission, center/quarter-file loading and later encoding/writing, so it is not total preparation wall time or renderer/profile kernel time.

LUT payload is3295500B. Existing host profile shared-library sections are text1536B, rodata3295660B, data8B, bss8B. A single fullframe HDR array is777600B and a single RGB565 output64800B; Python reconstruction/analysis also uses additional arrays/dictionaries. Measured process peak RSS is76368KiB for reconstruction and76116KiB for profile processing. These include interpreter/input validation and are not isolated kernel RAM bounds. This diagnostic does not install fullframe HDR or the LUT in the product and makes no device-fit claim. Original v38 old1M/8M incompatibility and separate host budgets remain unchanged.

## Saving

Save code, immutable contracts/provenance hashes, synthetic/independent reviews, aggregate metrics and costs only. Exclude original model/geometry/images, raw HDR/events/pixels, masks, private preview and raw LUT assets. Parent handles private saving. No public upload, PR or device action.
