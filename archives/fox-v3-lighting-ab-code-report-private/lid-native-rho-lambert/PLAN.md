# Native-rho Lambert character diagnostic, current lid8, oblique two cases

Fixed baseline/direction seed11, oblique only. Same actual54 partitions/1163 vertices/1564 triangles, actual quantized front/back SNORM, inverseB winding and physical sides as frozen current-lid8 rich proxy. No source normals or original high-poly character substitution. Original source is opened read-only per case, never saved.

## Single intervention and lighting limitation

Keep original world, floor BSDF and emission, three lamps, all GI/adaptive/clamp/camera/AgX/BH1.5/dither settings. Change only character material copies: replace Principled surface with diffuse Lambert (Roughness0, Normal unconnected), Color set to exact native actual-C-float RGB565 decode. This is a combined BRDF AND rho intervention, not an isolated BRDF experiment. Original material datablocks, settings/flags, floor and world graphs remain unchanged. Original character emission must be zero; otherwise stop. No extra rendering variant, gain/exposure fit, new threshold, or official evaluator change.

Before replacement, audit both compiled raw models and four existing complete actual snapshots. Every partition must have a common A=B RGB565 across every raw/serialized vertex and either physical side. Mask variation alone is harmless if A=B. If any face/partition varies in effective rho, stop rather than substitute a constant. Actual pixel API's physical side selects front/back normal, not a distinct palette; raw descriptors and all used/unused vertices are checked. All54 partitions currently pass (1163 vertices/1564 triangles), with no varying rho.

Because world/floor emission remain, proxy diffuse direct is NOT strictly native3DISK direct. Native direct alone and direct+primary world+primary ground-emission are both recorded. Existing direction perturbation should leave the latter two terms unchanged; verify, do not assume. Secondary floor emission, BSDF/GI/pass classifications, shading-normal corrections, adaptive/filter sampling and receiver differences remain non-equivalent. Indirect diffuse must not be attributed to the floor.

## Control reuse, rendering and auditing

Reuse the prior rich-proxy four original same-seed PNG controls only after rechecking prior code/report freeze, all original render dependencies, source hash and control PNG/chunk results. This is reused evidence, not a newly rendered control. Exact same frozen setup/replace/render helpers restore geometry and source scene; only the post-restoration material-copy ablation is new. Before rendering, run two-case audit without rendering and obtain independent contract approval.

Render exactly two Lambert proxy images and multilayer EXRs; preserve all pass terms, residual and original ordinary PNG display. Verify original datablocks/world/floor/lights/camera/settings before/after the copy intervention and source/input hashes afterward. No partial run scored as complete. Custom-normal storage errors remain measured, not bitexact Blender normals.

## Analysis cohorts fixed before output

Full original foreground and its original stable/uncertain domains, full native-covered domain, original foreground missing native coverage, and the prior oblique113 opposite-sign cohort (same-object83/different30) are fixed. Also retain the previous rich-corrected41/same32 cohort as a separate pre-existing conditional diagnostic, never reselect points from the new Lambert output. Report new Lambert/source/native/rich sign changes and raw component magnitudes in all applicable domains; entire-frame new reversals and inactive errors must accompany old-cohort corrections.

Compare native direct, direct+primary world+ground, and fixed integer3×3 BH versions to proxy DiffDir×DiffCol. Distinguish raw sign versus the existing2/255 numeric magnitude scale (linear diagnostic, not display classification). Use only prior frozen filter weights/nohit black/fixed denominator; not Cycles subpixel equivalence. Source material/rho changes are simultaneous and only two conditions/one seed exist, so no unique causal or global60% claim.

Private isolated diagnostic only. No product source edits, original save, public PR, device/default deployment. Final code/reports/aggregated metrics/hash allowlist excludes geometry/models, snapshots, per-pixel rows, PNG/EXR/raw buffers.
