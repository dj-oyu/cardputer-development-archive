# Latest eye transparency: sourced closure-weight contract

Read-only audit and independent weight arithmetic only. No Blender/model/renderer edit, driver execution, visibility query, new scene data, device or public operation. Existing arithmetic kernels/manifests remain frozen. Original source SHA256 d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a. Primary code is pinned Blender4.3.2 commit32f5fdce0a0a571a39198edf8d7b5d719bf59f2c. Local evidence hashes and extracted links/defaults are in evidence.json.

## Exact latest graph, both eyes

Materials `Blink mask Expressive eye white -1` and `Blink mask Expressive eye white 1` have the same closure connections:

- Math.019.Value → Mix Shader.Fac.
- Transparent BSDF.BSDF → Mix Shader first Shader input (identifier `Shader`).
- Principled BSDF.BSDF → Mix Shader second Shader input (`Shader_001`).
- Mix Shader.Shader → Material Output.Surface.
- Mix (Legacy).002.Color → Principled Base Color.

Transparent Color is unlinked RGBA(1,1,1,1). Cycles Transparent node's relevant input is RGB Color, used as closure color weight; its fourth inventory component is not a separate transparent-alpha factor. Principled Alpha is unlinked1.0; Transmission Weight0, Metallic0, Emission Strength0, Roughness≈.22, IOR1.5. Specular IOR Level is a distinct control-driven numeric input, not opacity. BaseColor's color/alpha representation must not be mistaken for the Mix Shader factor. Math.019 is MAXIMUM with use_clamp=false, so the final Mix Shader clamp is a separate semantic step.

The saved materials have surface_render_method DITHERED, use_transparent_shadow=true and backface culling=false. These are source settings, not a defined custom-renderer coverage algorithm or proof of equivalent Cycles/Eevee raster behavior. Do not implement a screen dither policy merely because this enum is present.

## Primary-source semantics

1. `intern/cycles/kernel/svm/closure.h`, lines1324–1346: svm_node_mix_closure clamps the factor with saturatef. With incoming closure weight I, it stores I*(1-w) for first closure and I*w for second. If no incoming weight is provided, I defaults to1. The factor is clamped; this function does not clamp a separately supplied incoming weight.
2. `intern/cycles/scene/shader_nodes.cpp`, lines5003–5024: MixClosureNode has ordered Closure1/Closure2 and is handled by the SVM compiler. Inventory socket ordering above is essential: reversing the two closures reverses visible-versus-transparent meaning.
3. `shader_nodes.cpp`, lines2399–2427 and3097–3117: TransparentBsdfNode inherits BsdfNode, has RGB Color and internal SurfaceMixWeight, and selects CLOSURE_BSDF_TRANSPARENT_ID. BsdfNode compile emits closure color from Color; here that is white.
4. `closure.h`, lines476–480: Transparent case computes weight=closure_weight*mix_weight and passes it to bsdf_transparent_setup. The kernel's mix weight defaults to1 if no stack weight is provided (lines47–52); zero mix weight may skip surface BSDF setup (lines57–61).
5. `shader_nodes.cpp`, lines2959–2974: Principled compile sets initial closure color weight to white. `closure.h`, lines162–174 and195–199: Principled Alpha is separately saturated; if alpha<1 it creates transparent weight*(1-alpha), then scales remaining weight by alpha. Here alpha=1, so this branch adds no transparency. It does NOT remove Principled reflection/diffuse layering or reduce the BSDF to BaseColor.

The inventory's unlinked generic `Weight` socket defaults0 on both BSDF nodes must NOT be multiplied into the above weights. The pinned Cycles Transparent node defines Color and its compiler-internal SurfaceMixWeight, not an independently applied public Weight multiplier; Principled explicitly emits white closure weight. Treating the stored generic zero as zero opacity would contradict this compiler path.

Verified primary links (all same pinned revision):
- https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/kernel/svm/closure.h#L1324-L1346
- https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/kernel/svm/closure.h#L162-L199
- https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/kernel/svm/closure.h#L476-L480
- https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/scene/shader_nodes.cpp#L2399-L2427
- https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/scene/shader_nodes.cpp#L2959-L2974
- https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/scene/shader_nodes.cpp#L3097-L3117

## Independent numeric connection that is supported

For this top-level single mix with incoming weight1, finite represented factor f yields w=clamp(f,0,1), white-transparent weight(1-w,1-w,1-w), and Principled closure scalar weightw. At w=0 only the transparent branch remains; at w=1 only Principled remains. For integer Q with S=2^Q, the arithmetic interface is:

    principled_weight_code = min(S,max(0,raw_factor_code))
    transparent_weight_code = S-principled_weight_code

These represented weights sum exactly toS. White Transparent Color introduces no extra RGB tint. Keep raw BaseColor, numeric Principled parameters, weight and complement separate. The existing independent material interface's mix/complement fields can be interpreted this way; this audit does not change or integrate that interface. It does not claim fixed weights reproduce every original float32 predicate or source socket value. A nested/nonunit incoming weight would require separate multiplication/rounding analysis, not reuse of an unconditional complement-to-one rule.

verify_weights.py independently checks10,011 explicit/random factor codes for each Q16/Q20/Q24, including belowzero, zero, positive endpoints, quarter/half values, one and aboveone. Bounds/complement/white-channel equality pass. This is algebraic validation only; it consumes no scene/hit/radiance data and does not evaluate the material graph or renderer.

## Mask range proof: fractional values exist

For both source DAGs, define b=the Blink driver (max of global and corresponding side blink). In the accepted control domain b∈[0,1]:

- Math.013 is LESS_THAN(Z,upper).
- Math.014 is GREATER_THAN(Z,lower).
- Math.015 multiplies those two Boolean results, so I∈{0,1} exactly.
- Math.016=b*50; Math.017=min(1,Math.016); Math.018=1−Math.017.
- Math.019=max(I,Math.018).

Consequently inside the strict strip w=1. Outside it, w=1−min(1,50b), with source float32 operation rounding applied at each node. It is1 at blink0, can be fractional for small positive blink, and reaches0 once rounded50b≥1. The ideal-real transition is b=.02; do not replace the actual rounded predicate/product with an unexamined exact decimal threshold.

Exact witness: b=1/128, X=side*.285 and Z=2 (accepted local domain). The strip lower boundary is about2.55−.31*(127/128), above2.24, so Z=2 is outside for both sides, with ample margin against stored constant/coordinate rounding. Product50b=25/64, hence w=39/64=.609375 and transparent weight25/64=.390625. These dyadic values are exact in float32 and every Q16/Q20/Q24 here. This is a source-backed counterexample to a universally binary mask, not an observation inferred from a sampled image. Weight tests include this fraction and integer neighbors around S/50.

## Conditional supplied-radiance arithmetic

The source establishes closure weights. If, separately, a caller supplies complete, unweighted branch radiances Lprincipled and Lcontinued for the SAME sample/direction/scene conditions, and explicitly assumes their combination is the linear closure-contribution expectation, the corresponding independent numeric reducer is:

    L = w*Lprincipled + (1-w)*Lcontinued

For nonnegative represented integer radiance codes and factor code W, a specified one-round implementation can use RNE((W*Lprincipled+(S-W)*Lcontinued)/S), with its own product/accumulator range checks and declared output scale. At endpoints this reduces to selection; the fractional counterexample means selection alone is not sufficient generally. Neither branch should already include these mix weights, or the reducer would double-weight it.

This is a conditional arithmetic interface, not a derivation of actual Cycles pixel/film output from this audit. The inspected files do not establish the acquisition or completeness of the supplied radiances, stochastic estimator/Russian-roulette behavior, path state, coverage or alpha-film policy. Do not substitute BaseColor for Principled radiance, an arbitrary image color for continuation, or reuse an opaque-only hit as a proved transparent continuation. No such reducer or transport implementation is added here; this report supplies its narrow weight contract only.

## Why this is not ordinary alpha-over

The graph specifies a mixture of surface closures, not a supplied foreground pixel and known background pixel. BaseColor is a BSDF parameter, not the resulting outgoing radiance. Transparent Color is a closure throughput color, not a background selection. No link in this graph identifies the material/radiance behind the eye.

Computing w*BaseColor+(1-w)*background would silently replace Principled shading with flat color and assume a particular background correspondence. Even w*fully_shaded_foreground+(1-w)*behind_radiance requires both quantities for the same directional/transport condition and a stated approximation. Occlusion, multiple transparent layers, other surfaces, shadow transmission, reflection paths, lighting and coverage/antialiasing cannot be recovered from this factor alone. Saved opaque hits or masks do not supply valid continuation behind a newly transparent portion merely by changing its weight.

The locally pinned source set ends this audit at the call to bsdf_transparent_setup; its implementation and full path integrator are not included in the inspected files. Therefore this report does not claim detailed traversal, alpha-film output, transparent-bounce termination, stochastic closure selection, shadow accumulation or compositing equivalence. Nothing here authorizes implementing or querying those paths. The correct stopping boundary is a color/parameter result plus explicit closure weights, with scene transport unresolved.
