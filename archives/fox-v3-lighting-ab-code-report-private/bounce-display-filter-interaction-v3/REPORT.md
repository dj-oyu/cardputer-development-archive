# Fixed 2×2 bounce display/filter diagnostic

Four color cases and two direction responses only. No acceptance, selection, convergence, or product-fit conclusion. Profile is applied after the fixed HDR filter. Point/OFF reproduces bounce-001 bytes exactly.

| View/case | Point OFF RGB % | Point ON | Filter3 OFF | Filter3 ON | Interaction pp |
|---|---:|---:|---:|---:|---:|
| front/baseline | 73.296706 | 73.958154 | 75.165260 | 75.402520 | -0.424188 |
| front/direction | 72.813351 | 73.106035 | 74.581050 | 74.490950 | -0.382784 |
| oblique/baseline | 72.120120 | 72.801400 | 73.864791 | 74.109813 | -0.436257 |
| oblique/direction | 71.767121 | 71.873493 | 73.629452 | 73.304672 | -0.431152 |

| View / arm | Sign % | Luma RMSE | RGB RMSE | Magnitude % | Bright IoU | Dark IoU | Inactive FP |
|---|---:|---:|---:|---:|---:|---:|---:|
| front/point-off | 81.651376 | 0.079016 | 0.106438 | 72.342244 | 0.647215 | 0.805313 | 67.000000 |
| front/point-on | 83.621092 | 0.062820 | 0.096401 | 77.862202 | 0.701550 | 0.822440 | 102.000000 |
| front/filter3-off | 86.104678 | 0.076257 | 0.103930 | 72.761008 | 0.663226 | 0.835355 | 134.000000 |
| front/filter3-on | 87.262622 | 0.060209 | 0.093416 | 77.941517 | 0.736404 | 0.849826 | 134.000000 |
| oblique/point-off | 79.098951 | 0.080422 | 0.112998 | 81.311266 | 0.392683 | 0.796924 | 79.000000 |
| oblique/point-on | 79.946906 | 0.064703 | 0.103371 | 86.213239 | 0.438824 | 0.813462 | 115.000000 |
| oblique/filter3-off | 82.392364 | 0.077552 | 0.110595 | 81.854490 | 0.454438 | 0.810115 | 142.000000 |
| oblique/filter3-on | 83.221884 | 0.062002 | 0.100740 | 86.409413 | 0.500000 | 0.827273 | 153.000000 |

All numeric metric contrasts, including signed correlations, uncertain/pooled/per-seed metrics and interaction, are retained in JSON. Reference-only stable masks include inactive pixels; scoring retains full source foreground, including native missing silhouette. No null is treated as zero/pass.

Support expansion is reported separately in support.json. Filter support comes from depth-mask union, not RGB positivity, and is not geometry improvement. Fixed weights retain outside/no-hit black samples with no covered-only renormalization.

Host costs: 3,295,500-byte read-only LUT; each full HDR array 777,600 bytes; RGB565 output 64,800 bytes; native observer HDR allocation separate. Python temporary arrays and library/code overhead are additional, not an established peak-RAM budget. Filter/display timing uses 11 identical-input repetitions, with min/median/max reported as host-only timings, not device benchmarks or a native-render-plus-transform performance estimate. Continuous profile conversion does not implement PNG dither=1.

No LUT regeneration or source-image fit. Local frozen profile manifest, installed 20 dependencies, all raw/reference/foreground/source inputs and fresh library binary are hash-checked. Full five-condition independent evaluation would be needed before considering adoption.


## Observer provenance and scope

Final observer run-001 captures actual current ONE_BOUNCE001 final-winner preclamp RGB, not reconstructed 565 values or rich-pass inputs. Independent fresh four-case replay matched all12 HDR/RGB/depth files, including the original8 control buffers. Source/model/reference hashes are unchanged. Four fresh processes took27.44seconds (not a controlled performance comparison). One static777,600-byte observer is diagnostic-only, one process/one frame, not reentrant or a product-owned HDR lifecycle.

The full prior one-bounce cost and unsupported scene elements remain. No ground geometry/emission/reflection, specular, higher GI, source-normal correction or dynamic product integration was added. Original rich pixels, materials, lamps, display settings and scoring thresholds are unchanged. This experiment only reuses the existing continuous official-profile approximation and integer nine-neighbor filter. Profile precision and dtype/domain limits remain those of the frozen synthetic gate; no new LUT fit. PNG output dither is not reproduced.

Postprocess001 first timings overlapped independent rendering and are not authoritative. Final002 ran after CPU-clear; all16 color files and all metric/support results are byte-identical to001. Eleven-repeat host medians: HDRfilter.755–1.001ms, point/OFF display.508–.606ms, point/AgX1.883–2.099ms, filtered/AgX1.976–2.162ms. These are separate host postprocessing costs, not a device speed or an integrated render performance estimate. Extra Python array/library/allocator memory is not bounded as a product.

The combined profile/filter result is not additive and not globally accepted. Oblique bright-position IoU remains50%, below60%; inactive false positives grow. Four-case interaction testing cannot establish behavior for intensity, ambient or albedo. Any selected combination requires independent full-five-condition evaluation before an adoption decision. No combination is selected here.

## Reproduction

With the separately retained private model/reference inputs in the existing workspace: run observe.py FRESH_OUTPUT --reviewer-contract-closed. The frozen current postprocessor expects run-001 and requires --observer-control-passed; run postprocess.py FRESH_OUTPUT --observer-control-passed. It freshly compiles C, checks local frozen profile manifest and20installed configuration dependencies, verifies all raw/control/reference/foreground files and before/after hashes. test_filter.py separately tests constant/impulse/black-coverage/boundary behavior. Code/report bundle excludes original models, geometry, images and raw buffers. Profile redistribution rights remain unconfirmed: private only. No default change, publication, PR or device operation.

## Full-foreground color regressions (descriptive, uncertain retained)

AgX worsens pooled full-foreground RGB agreement in all four cases for both point and filtered inputs. Stable-subset baseline gains must not hide this.

| Case | Point OFF | Point AgX | Filter OFF | Filter AgX |
|---|---:|---:|---:|---:|
| front/baseline | 73.887419 | 73.790058 | 75.624725 | 75.173466 |
| front/direction | 74.020722 | 73.473225 | 75.637587 | 74.760570 |
| oblique/baseline | 73.110439 | 72.884490 | 74.660525 | 74.065035 |
| oblique/direction | 74.256791 | 73.370194 | 75.764405 | 74.536470 |

Independent validation: all12 observer files,16 postprocessed RGB565 outputs and8 support masks match;2,588 fixed-domain numeric values and121,825 contrast/interaction numeric leaves agree. Profile high-domain clamp count is zero in all16 outputs. No adoption.
