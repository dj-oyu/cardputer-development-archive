# Actual lid8 rich proxy, four cases, seed11

This is a new 1564-triangle version, not the historic 1166-triangle rich oracle. All results are descriptive single-seed diagnostics, not native implementation, stability evidence, or a global 60% result. Geometry remains relevant: sharing actual geometry with a richer renderer does not make either match the original sculpt exactly.

## Controls and restoration

All four original seed11 controls completed before any proxy render. Decoded RGBA8 and all nonvolatile PNG chunks match fixed v3 reference files exactly; only the predeclared render-time/date metadata is ignored. Source file was never saved. All 236 recorded dependencies remained unchanged. Four proxy cases then completed with the original material graphs/sockets/links/flags, world, ground BSDF/emission, three lights, cameras, full GI/adaptive sampling/clamps, original AgX Medium High Contrast, BH1.5, dither1, and seed11 unchanged.

All 54 actual compiled partitions, 1163 vertices, and 1564 triangles were restored from owned native world/indices and independently written mode4 canonical bytes. Four-case mode5 decode equals those bytes. Every vertex/triangle is accounted for, including camera-independent cold geometry; every front/back SNORM triple is exactly opposite. Inverse B/38, determinant-negative winding reversal, physical side flags, material partition boundaries and source origins were checked. Original unquantized GLB normals were not substituted. Blender storage adds measured rounding: maximum position component error 1.12936e-7, custom-normal vector error 0.000156456. This is not bit-identical Blender normal storage. Ng·Ns has 46 faces/57 corners with a negative corner and 11 negative mean-normal faces.

Proxy materials use exact original source material nodes. Actual C-float RGB565 linear decoding is separately recorded in material audits and differs from source linear rho. This is a rich-source-material proxy, not a material-identical native estimator. No source pixels entered native rendering or geometry selection.

## Fixed-reference display comparison

Native legacy uses the existing decoded RGB565 path; proxy uses ordinary Blender PNG8 through the original AgX/BH path. All fixed reference masks/thresholds remain unchanged. Stable bright IoU front/oblique: proxy 84.87%/72.74%, native legacy 65.41%/39.24%. Stable dark IoU: proxy 89.65%/91.09%, native 81.46%/80.61%. Stable RGB agreement across the four cases is 94.89–95.81% for proxy, compared with 70.80–72.85% native. Full-foreground RGB agreement is 94.54–95.25% proxy versus 72.32–73.25% native. Full-foreground pooled bright IoU is 76.71%/62.91% proxy and 58.77%/34.51% native.

Uncertain response foreground remains 729/698 pixels, never treated as PASS. Native coverage misses 620/719 original-foreground pixels, retained in full-domain scores. Proxy stable-inactive false activity is 104/107 versus native 69/85, so the proxy does not improve every error category. Source seed11 is itself part of the fixed eight-seed source ensemble; its exact stable sign agreement is a control, not an independent generalization claim.

## Reverse-sign correspondence and minimal conclusions

The original foreground stable-sign/native-legacy opposite-sign cohorts are fixed by the prior census: front111 and oblique113. No new point optimization or fit is used. Proxy signs at those filtered pixels become front22 correct/62 still reverse/27 inactive, oblique41 correct/53 still reverse/19 inactive. For the oblique83 whose original center ray hits the same source object as the native winner, proxy becomes32 correct/38 still reverse/13 inactive. The remaining30 different-object points become9/15/6. Same object does not mean the same surface, depth, shading normal, or filtered receiver. Geometry/normal differences remain mixed with rendering differences.

On the oblique same-object83, mean absolute direction-change luminance is native direct .028477 and one-bounce .005167; world and explicit ground-emission terms are exactly unchanged under this light-direction perturbation. Proxy filtered DiffDir×DiffCol is .040402, DiffInd×DiffCol .009191, direct gloss .011199, indirect gloss .002598, emission .000040, and residual about1e-6. These component magnitudes are not causal attributions or additive magnitudes: signs/cancellation and different sampling/contracts matter. Indirect diffuse does not identify ground origin. Raw point joins stay private; aggregate by-object/correspondence results are in reverse-join-001/summary.json.

Existing native point sRGB, point AgX-LUT approximation, integer3×3 BH/sRGB and BH/AgX classes are recorded on the same cohorts. None is conflated with the proxy's original Cycles filtered AgX PNG. The richer-renderer gap motivates targeted rendering hypotheses, but this experiment does not select a feature, prove geometry irrelevant, or justify global high-sampling or a floor-light approximation.

## Pass reconstruction, filtering and alpha

All four EXRs contain43 finite float32 channels. Diffuse/gloss direct and indirect terms are their corresponding illumination×color passes; emission, environment, transmission, volume and R are retained. R is Combined minus the sum of all available reconstructed terms, without forcing zero or assigning it a physical origin. Maximum absolute residual RGB is 2.97e-5–3.07e-5; the historic diagnostic tolerance is exceeded at8–60 pixels per case (120 case-pixels total). This is reported, not suppressed or made a new acceptance threshold. Filtered pass products need not equal filtered products. Combined alpha is1 throughout because the source film/background is opaque; it is not geometry coverage. Native center/nohit-black sampling and source BH filtering are different domains.

## Cost and verification scope

Observed per-proxy host render elapsed time is3.50–3.90 seconds in this run; controls include source setup/render costs and are not a fair native speed comparison. No repeated CPU benchmark, product-memory fit or device timing was requested or inferred. HDR/EXR and restoration storage are private diagnostics, not product resources.

Independent review has checked all4 canonical decodes/source correspondences and geometry/SNORM/side counts, all4 original-control RGBA/nonvolatile chunks, 236 dependency hashes, scene/material guards, and an independent EXR parser on4×43 channels. This is source/artifact verification, not an independent fresh Blender render. Independent recomputation of analysis, reverse-sign join and signed-component diagnostics checks31,675 numeric values. An additional120 fixed-filter numeric values and the exact frozen weight configuration agree with an independent math.fsum nine-neighbor implementation. No review blockers remain.

## Reproduction and preservation

Commands: python extract_actual.py; blender -b --python code/render.py -- --audit FRESH_AUDIT; blender -b --python code/render.py -- --render FRESH_RUN; python analyze.py FRESH_ANALYSIS; python join_reverse.py FRESH_JOIN. Current analyze/join intentionally pin run-001; use an explicit new code version for another run rather than overwrite evidence. Source freeze v2 contains the strict chunk-control and source-audit dependency fixes, before rendering. No product renderer, formal v3 evaluator, reference, threshold or input geometry was edited. Bundle allowlist excludes all geometry/scene files, snapshots, per-pixel winner/join buffers, EXRs/PNGs and images.

## Corrected-sign cohort component test

On the oblique41 legacy-reverse pixels corrected by proxy display (same-object32 separately), native direct versus proxy direct-diffuse linear direction change has matching/opposite raw signs11/30 (same9/23). At the pre-existing numeric scale2/255 these become4 matching,12 opposite,25 with a small operand (same3/7/22). The linear-radiance use of2/255 is only a separate magnitude diagnostic, not the formal display-class threshold in another color space.

Proxy direct diffuse alone versus Combined has11 raw sign reversals (same-object9), or3 when both exceed2/255 (same3). Independent leave-one-component-out, without a sequential-addition attribution, reverses Combined raw sign at7 points when direct diffuse is removed,0 for indirect diffuse,8 for direct gloss,1 for indirect gloss,0 for emission/R. Same-object32 counts are7/0/7/0/0. At2/255 the full Combined-minus-component classes, including newly small values, are retained in sign-mechanism-001/summary.json. Individual component signs and magnitudes are also retained. These are arithmetic counterfactuals, not rerenders through nonlinear display or altered GI/adaptive sampling.

Thus direct-term divergence is already present in many corrected points; glossy composition also changes signs in a smaller subset. Indirect magnitude alone is not sufficient to rank causes, and neither test assigns energy to the floor. Different source/native point surfaces, visibility, filtering, BSDF evaluation and display remain plausible contributors. Geometry and material/normal semantics are not dismissed.

The no-source-hit branch in join_reverse_v2.py is ordered defensively before sameObject lookup; reverse-join-001 is retained and reverse-join-002 is byte-identical in all current aggregate/point values. This corrects future-input robustness only; every current original center ray hits the source.

## Whole-domain regressions and fixed-filter control

The corrected legacy cohort is not the whole domain. Across all original foreground, proxy opposite-source stable signs are138 oblique versus native113, a net increase of25;85 proxy reverse signs arise outside the old113 cohort. Front is109 versus111, with47 new reverse signs outside the old111. Higher bright/dark IoU can coexist with these reversals and increased inactive false activity. The component tests are conditional on the41/32 corrected points and cannot be extrapolated as causes for all113 or the frame.

Using the already-frozen integer BH3×3 weights on native direct fields at all final winners, with nohit/outside black and a fixed denominator, reduces raw native-direct/proxy-DiffDir opposite signs30→23 among corrected oblique41; same-object32 reduces23→19. At2/255 magnitude scale the counts12→9 and7→5 reduce through small-value transitions, not corrected significant signs. This is a partial point-versus-neighborhood effect, not a Cycles subpixel-filter reproduction or proof of a unique cause. The exact existing filter function is imported by AST, per-condition filtering precedes subtraction, and no weights were fitted.

filtered-direct-001 had a local output-label variable shadowing bug that overwrote its raw-sign column. It is retained but not used. check_filtered_direct_v2.py and filtered-direct-002 preserve both numeric columns, but a second local variable shadow overwrote the filter configuration metadata. Final check_filtered_direct_v3.py/filtered-direct-003 fixes the metadata; all numeric views are exactly equal to002 and filter settings exactly equal the prior frozen filter.json. Both superseded outputs remain preserved. Regression checks total327. No rendering or inputs changed. Final report uses render times3.50–3.90 seconds (single observed run only).
