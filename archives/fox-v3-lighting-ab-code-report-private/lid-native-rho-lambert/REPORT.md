# Current lid8 native-rho Lambert diagnostic

Two oblique cases, baseline/direction, seed11. Exactly the same actual geometry/quantized normals/physical sides as the preceding current1564 rich proxy. Only character material copies changed: original Principled surface to Lambert roughness0, and Color to actual native C-float RGB565 linear decode. This is a joint BRDF and rho intervention, not an isolated effect of either. The original world, floor BSDF/emission, three lamps, GI/adaptive sampling/clamps/camera/AgX/BH1.5/dither remain intact. No new product implementation or formal acceptance result.

## Input and control contract

Both raw models and four existing actual snapshots independently verify54partitions/1163vertices/1564triangles. Every raw and serialized vertex in each partition has A=B, equal to its pinned material565 code; every mask is−1 in these data. Thus no varying-rho face was replaced by a constant; even a varying mask would be irrelevant when A=B. The actual pixel API uses physical side to select normals, not a separate raw palette. Original source emission is zero. Eight copied material graphs retain all original flags/output nodes; only their character surface graph and rho change. Color storage exactly matches the promoted actual C-float decode, not a Python power approximation. Original material datablocks, world graph, floor, lights and settings remain unchanged. Actual custom-normal storage errors are inherited and measured, not claimed bitexact Blender normals.

Prior rich-proxy original controls are reused, not rendered again. Four decoded RGBA/nonvolatile chunk controls and236 prior dependencies were rechecked, with the prior final freeze pinned. Current setup/render helpers are AST-identical to the rich version. audit001 preceded a final runtime rho-proof-dependency guard; audit002 reran both cases with the current source freeze and all245 before/after/current dependencies exact. The only intervening code change added those input-pin checks. Two render images/EXRs then completed with unchanged source/dependencies; no original .blend was saved.

## Whole-domain results and fixed old cohorts

The full original foreground contains5868 pixels, of which698 retain the original uncertain response label. Native coverage misses719 foreground pixels; these are not dropped. Native-covered total5157 includes8 outside-original-foreground pixels whose reference classifications remain outside, not silently scored stable.

Lambert/native-rho stable bright IoU is71.31%, versus rich72.74% and native legacy39.24%; stable dark IoU91.65%, versus rich91.09% and native80.61%. Stable color agreement is92.54% baseline/92.60% direction, lower than rich95.81%/95.06%. Full-foreground color agreement also regresses: baseline91.523%/direction91.952%, versus rich95.247%/94.660%. These are conditional one-seed Blender diagnostics through the unchanged reference masks, not native60% achievement.

Across all original foreground, opposite stable-source signs are127, versus rich138 and native113. Thus11 fewer than rich, but14 more than native. Stable-inactive false activity is100, versus rich107/native85. Active source pixels becoming inactive are238, versus rich229. No single headline captures every regression.

The old native-reverse113 cohort is fixed before the new images: Lambert correct33/reverse54/inactive26, compared with rich41/53/19. Same-source-object83 is25/35/23, compared with rich32/38/13. Of the previous rich-corrected41, Lambert retains28 correct, reverses6, and makes7 inactive. For previous rich-corrected same-object32, it retains21, reverses4, and makes7 inactive. No new Lambert-corrected cohort was selected. New Lambert reverse signs outside the old113 are73; cohort-only correction is not whole-frame improvement.

## Direct component comparison and limitations

On the fixed previous rich-corrected41, native direct versus proxy DiffDir×DiffCol raw opposite-sign count remains30 after Lambert/native-rho, and23 for the same-object32 subset. Applying the prior integer3×3 BH to native direct gives23/19, also unchanged from the rich comparison. On the entire old113/same83, raw opposites are40/30 point and32/26 filtered, again unchanged. The joint material intervention did not eliminate this direct discrepancy in the fixed cohorts. It does not prove BRDF/rho irrelevant or identify a unique remaining cause.

On common foreground5149, direction-delta RGB RMSE versus native direct is .069158 for Lambert compared with .071654 rich; with native integer BH it is .052899 versus .055051. Fixed prior corrected41 instead slightly regresses: .144247 versus .143097 point and .124070 versus .123024 filtered. Raw signs and the pre-existing2/255 numeric magnitude scale are reported separately. Applying that number to linear radiance is a diagnostic scale, not a formal display classifier.

Native direct alone AND direct+primary world+primary ground-emission are included as absolute values and direction deltas, both point and fixed-filtered. World and primary ground terms are exactly unchanged between these two conditions at every winner. Their componentwise direction deltas are exactly zero; separately adding the absolute components before subtraction introduces at most6.66e−16 floating cancellation difference versus direct delta, retained explicitly.

Because original world/floor lighting remain, proxy diffuse-direct is not a strictly three-disk-equivalent quantity. Secondary floor emission and GI/pass classifications, source area sampling, shading-normal corrections, receiver/filter differences and floor BSDF still differ. Same object is not the same original surface. Integer-grid BH is not Cycles subpixel BH. Indirect diffuse is not identified as floor-origin energy. Character Lambert does not make every image-pixel gloss pass zero: the original floor and filtered mixtures remain. Full component absolute/delta statistics are retained rather than inventing a per-pixel character-only interpretation.

## Passes, cost and preservation

Both multilayer EXRs preserve43 finite channels with opaque Combined alpha1. Alpha is not a character-coverage proof. All available diffuse/gloss/transmission/volume/emission/environment terms and residual R are retained. Lambert residual max absolute RGB is2.9343e−5 baseline/3.3631e−5 direction;45/10 pixels exceed the old diagnostic bound. No clipping or forced-zero recomposition is used.

Observed single-run rendering took3.479/3.376 host seconds, not repeated performance evidence or device cost. No native product resource fit is inferred from diagnostic Blender/EXR buffers. Images, model/geometry, snapshot/ray/point data are excluded from the final bundle; only code, reports, aggregates, audits and hashes are allowed. Original source/reference/evaluator/thresholds are unchanged.

Reproduction: python audit_rho.py; blender -b --python code/render.py -- --audit FRESH; after contract review, blender -b --python code/render.py -- --render FRESH. analyze.py intentionally pins run-001 and accepts a fresh analysis directory. test_results.py checks frozen dependencies, stored rho, cohort/domain accounting and both sign columns. Existing runs are never overwritten. Independent review is source/artifact and numerical recomputation, not a fresh independent Blender rerender; final review files record its extent.

Independent final audit agrees on17,407 numerical values, all245 render dependencies, and2 EXRs×43 channels. Raw rho/geometry and779 regression checks pass. No unresolved blockers. Independent artifact/math inspection is not an independently rerendered Blender result.
