# Coverage-only support diagnosis

The same1166-triangle geometry intersects the fixed filter-support grid at101/101front and199/208oblique previously uncovered stable-bright false-negative locations. This supports a sampling/support contribution; it does not show their correct brightness or signed response is recovered. No color/lighting score, mask, threshold, formal reference or renderer default was changed. AA was not adopted.

## Contract and controls

Original BLACKMAN_HARRIS width1.5 nominal support is center±1.5pixels, verified against official Blender v4.3.2 source (SOURCE_SUPPORT.md). All240×135pixels use exactly625uniform midpoint offsets, step.12, extrema±1.44. This is not the weighted Cycles filter, its inverse-CDF table, source alpha, or a convergence proof.

Actual submitted float32 projected triangles were captured from the same evaluated model/camera. Both views submit1166triangles, with baseline/direction arrays byte-identical. Canonical double top-left edge tests and area>1e-5 match the renderer. Center-only coverage matches all32400pixels/view (4698front/5156oblique hits). Original24color/depth/observer/vertex/side/map buffers remain byte-identical. Eight synthetic boundary/union/translation/rejection checks pass.64input hashes remain unchanged.

## Fixed foreground results

|Measure|Front|Oblique|
|---|---:|---:|
|Original foreground pixels|5307|5868|
|Center-covered foreground|4687|5148|
|Grid625/625 covered|3769|4102|
|Grid1..624 partial|1523|1739|
|Grid0 outside, not geometry proof|15|27|
|New hits in foreground without center hit|605|693|
|New hits OUTSIDE formal foreground|313|377|
|Existing Ns+visibility bright FN|466|397|
|Uncovered bright FN with a new grid hit|101/101|199/208|

All101front recovered FN locations and195oblique locations have partial source alpha; four oblique full-alpha locations also hit. Nine oblique uncovered bright FN remain undetected, all partial-alpha. Finite-grid no-hit cannot prove geometry is absent, and newly hit pixels may still have incorrect shading or negligible filter weight. The reference's128-sample alpha support and this uniform625-grid support are not equivalent. The extra313/377outside-mask hits prevent interpreting simple coverage expansion as unqualified improvement.

Uncertain pixels remain729front/698oblique. Grid hits165/201of their previously center-uncovered locations, with7/11still undetected. These remain uncertain, never scored as success. summary.json contains full-image, sourcefull/partialalpha, stablebright/dark/inactive, uncertain, both-sign FP/FN strata and locations. No data-dependent grid refinement or excluded pixels.

## Cost and interpretation

Primary C grid runtime0.274sfront/0.266soblique; adapter execution+grid0.613s, excluding compilation. Parent Python peakRSS26824KiB, not firmware RAM. Grid C scratch is32400Bhit plus64800Bcaller counts; projected input32648B (1166×7float32); total these arrays129848B, excluding runtime/Python/input copies. CPU user/system time was not separately measured. Independent fresh replay grid0.528s, compile-excluded run0.592s, parentPythonRSS26820KiB. No runtime API or microcontroller feasibility claim.

The smallest supported conclusion is that many current center-missed response locations are reachable by unchanged geometry within the original filter's support. A later *separately authorized* weighted-color/response experiment would be needed to test useful AA, including outside-mask/color/dark-response regressions and cost. Coverage-only results neither repair the remaining shading mismatch nor prove geometry correct. No60%achievement is claimed.

## Reproduce

From workspace root, with prior observer/candidate/reference input packs intact:

python3 fox-v3-position-diagnostic/coverage-ab/run.py && python3 fox-v3-position-diagnostic/coverage-ab/summarize.py

pre-execution-hashes.txt pins plan/code/input manifest. This small persistent bundle excludes original .blend, geometry, images and raw outputs. Restore its diagnostic-position tree as fox-v3-position-diagnostic alongside the existing candidate/reference packs. Missing private input bytes must not be approximated while claiming identity. The old lost advanced2400candidate is not reproduced by this1166fixture.

Independent verification PASS: fresh C rebuild/capture reproduces28capturebuffers and all four coverage/center arrays exactly. O0/O2 ASan/UBSan synthetic checks pass. An independent aggregate recomputation matches all228summaryfields/coordinate-lists, including101/101 and199/208new hits,313/377outside-mask new hits, and unchanged729/698uncertain pixels. Pre-execution and source/input pins remain unchanged. No formal response score changed.
