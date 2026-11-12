# Character-only Lambert material ablation

Eight private Blender oracle renders, seeds11/29 × front/oblique × baseline/direction. Only45 oracle parts using8 copied materials change: source linear BaseColor feeds Diffuse BSDF roughness0. Floor BSDF/emission, world, all3area lights, GI, geometry/SNORM, camera, AgX, BH1.5 and original reference remain unchanged.

Clone-only ON control passed43EXR channels and RGBA8 pixels exactly before modified renders; nonvolatile PNG chunk equality was also confirmed after the run. Full before/after scene and original-material audits exclude all changes except copied character graph nodes/links.

## Fixed-v3 descriptive results
- front, seed11: direction bright IoU rich 84.0617% → Lambert 81.5671%; response delta RGB RMSE 0.0454547 → 0.0538021.
- front, seed29: direction bright IoU rich 84.3288% → Lambert 82.1865%; response delta RGB RMSE 0.0454438 → 0.0537625.
- oblique, seed11: direction bright IoU rich 71.9027% → Lambert 70.5543%; response delta RGB RMSE 0.0487365 → 0.0583339.
- oblique, seed29: direction bright IoU rich 73.2363% → Lambert 71.1963%; response delta RGB RMSE 0.0486244 → 0.0582650.

Lambert retains around70–71% oblique bright-response IoU under the rich scene while the current native ground-Le arm remains39.41%. This is evidence that material replacement alone does not explain the remaining native gap. It does not identify one missing transport feature, guarantee a native improvement, or establish a strict geometric upper bound.

The BSDF substitution jointly changes diffuse weight, specular, direct and indirect transport. It is not pure specular removal. MIS/path/Monte Carlo/adaptive differences and fixed indirect clamp10 nonlinear bias are not separated by two seeds. Negative signed differences are retained, never clipped or fitted. Original eight-seed stable/uncertain masks and threshold remain fixed; two auxiliary seeds do not redefine stability or count as simulator achievement.

analysis-001 contains signed HDR components and material/light-direction interaction on full original foreground, common native coverage and radius2Chebyshev interior (outsidefalse). display-001 contains oldrich/newLambert scores against unchanged v3 reference. Conditional common/interior diagnostics never replace missing or extra foreground. Source radiance/pixels never enter native illumination.

No original blend save, public upload, PR, device action or new native feature. Full scene audits, images and geometry remain local and are excluded from the private code/report bundle.

Independent verification passed: all eight full scene audits,390 input pins, source linear rho/material graph,43-channel ON control and RGBA pixels. Separate EXR reader and computations reproduced8,166 HDR metrics/144 signed arrays and2,464 PNG8 display metrics. This is independent artifact/numeric/source verification, not a fresh independent Blender rerender of eight cases.
