# Source floor material for a direct-reflection surrogate

Read-only reuse of existing source material audit, all16albedo metadata rows, and current file hashes. No original scene editing, Blender render, candidate geometry/BSDF implementation or upload.

Original blend SHA9254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806, fixed v3 config SHA4a9d836a4dae2fc570f5f0fb99690ab0f13fbe394589f785b56e891e0573dc40 and renderer script SHA4f7cf88aa043ff49d1138204ae29689640d3582e32ecb709c52c59187e92d99c still match the earlier independent source extraction.

## Confirmed authored floor
Material Warm studio backdrop: Principled BSDF directly connected to Material Output Surface, no texture/input links in the saved graph.
- Base Color scene-linear RGB(.8399999737739563,.7799999713897705,.6499999761581421), alpha1.
- Metallic0; Roughness.6499999761581421; IOR1.5; Specular IOR Level.5; Specular Tint white.
- Diffuse Roughness0; Subsurface Weight0; Transmission Weight0; Coat Weight0; Sheen Weight0; anisotropy0.
- Emission Color has the same baseline RGB, independently stored; Emission Strength.25, so Le=(.20999999344348907,.19499999284744263,.16249999403953552).
- Material backface culling false; ground visible to camera/diffuse/glossy/transmission/shadow. Source geometric normals are+Z. These flags and the prior two-sided emission fixture do not by themselves prove every source reflection-side behavior. Implemented side orientation must remain an explicit approximation contract.

The saved Principled state includes an internal socket named Weight with value0. Preserve it as provenance, but do not treat it as the physical diffuse fraction or conclude the source surface is nonreflective. This audit does not infer behavior from that internal socket.

## albedo.6 scenario
All16saved source albedo render metadata rows include Warm studio backdrop among9target materials and albedoScale.6. The existing extractor also records actual Blender float assignments:
- floor BaseColor→(.5040000081062317,.46799999475479126,.38999998569488525).
- Emission Color/Strength and Le remain unchanged.
Other cases retain the original floor BaseColor. Direction changes key placement, intensity changes key energy, ambient changes world; these must not implicitly change floor material.

Treat these as linear material inputs. Do not sRGB-decode them again, infer them from displayed pixels, or introduce character RGB565 material quantization into the source floor. For exact provenance choose and document Blender's assigned float values versus double scaling; do not silently claim bit identity between them.

## What the new term would and would not represent
At a primary floor hit, the proposed outgoing reflected radiance is a Lambert surrogate: floor rho/pi times irradiance from the three authored DISK lights, including visibility and the declared side-oriented normal. Character transport then applies its existing receiver factor/hemisphere estimator once. The direct-light helper's units/pi convention must be checked to avoid multiplying rho or dividing by pi twice.

This is distinct from existing primary floor Le, uniform-world misses and the character's existing one-bounce term. Preserve Le and world accounting; albedo.6 changes rho but not Le. No additional emission is inferred from BaseColor merely because their original RGB values match.

Principled is a layered dielectric, not exactly Lambert with BaseColor reflectance. The surrogate omits its specular/Fresnel and layer-energy allocation, and does not use roughness. Metallic0 and Diffuse Roughness0 do not make the full Principled BSDF Lambert. It also omits floor response to world illumination, secondary floor emission paths, further interreflections and glossy transport. Source indirect clamp10 remains a renderer-level difference. Thus the addition restores one physically motivated missing path approximately; it is not full source-material equivalence, all floor GI, or proof that floor transport caused the measured direction error.

Persist audit.py, summary.json, REPORT.md and hashes only. The summary contains scalar material/metadata evidence, no floor vertex/index arrays, image pixels or source geometry. Reproduce with python audit.py and the private saved inputs.

## Internal Weight ambiguity closed
A fresh read-only load of the unchanged actual blend confirms the saved Weight0 socket is unavailable and unlinked, while Principled BSDF connects directly to Output Surface. Blender's Python named lookup excludes this socket; iterating inputs finds it. The initial named-lookup attempt raised KeyError before any scene mutation and is retained in /tmp; the corrected check did not save or render.

Independent official Blender4.3.2 source review confirms the node declares this socket unavailable; Cycles export skips unavailable inputs; the internal SurfaceMixWeight is assigned through output-graph weighting rather than that saved UI socket. Thus Weight0 is not evidence of zero floor reflection. Sources: https://github.com/blender/blender/blob/v4.3.2/source/blender/nodes/shader/nodes/node_shader_bsdf_principled.cc ; https://github.com/blender/blender/blob/v4.3.2/intern/cycles/blender/shader.cpp ; https://github.com/blender/blender/blob/v4.3.2/intern/cycles/scene/shader_graph.cpp . Evidence weight-socket-check.json / official-weight-evidence.json. No Lambert-equivalence claim follows.
