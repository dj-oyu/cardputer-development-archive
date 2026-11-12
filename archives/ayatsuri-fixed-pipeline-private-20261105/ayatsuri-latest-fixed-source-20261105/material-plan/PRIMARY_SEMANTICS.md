# Read-only Blender4.3.2/Cycles source semantics

Verified official repository tag `v4.3.2` points to commit `32f5fdce0a0a571a39198edf8d7b5d719bf59f2c` through https://api.github.com/repos/blender/blender/git/ref/tags/v4.3.2 . All substantive file reads below use that immutable commit, not current main. Initial code-search results were used only to locate filenames; their newer revisions were not used as semantic authority.

Read-only source bodies are saved as `.txt`, with original URLs and Git blob SHAs in `primary-source-manifest.json`. Local SHA256 manifest separately binds copied text. Downloaded source was not compiled/executed/installed. The unavailable guessed path `svm/mix_util.h` was corrected by following actual source to `svm/color_util.h`; no unavailable contents were invented.

## Relevant finite-input rules

- [svm/math_util.h](https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/kernel/svm/math_util.h): `svm_math` uses float a,b,c, ordinary add/subtract/multiply, `safe_divide`, `safe_sqrtf`, fminf/fmaxf, strict `a<b` and `a>b`. `svm/math.h` loads/stores float stack values around this operation. Every Math node in the audited actual graph has use_clamp=false, so no generic post-Math saturation should be added.
- [util/math.h#L706](https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/util/math.h#L706): safe_sqrtf is `sqrtf(max(f,0.0f))`.
- [util/math.h#L758](https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/util/math.h#L758): safe_divide is `(b != 0.0f) ? a/b : 0.0f`. Nearzero nonzero is **not** replaced by zero. A fixed-point port must distinguish a genuinely zero source denominator from a nonzero denominator quantized to zero; use visible rejection/higher precision rather than claim source equivalence.
- [svm/mix.h](https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/kernel/svm/mix.h) legacy `svm_node_mix` calls `svm_mix_clamped_factor`.
- [svm/color_util.h#L304](https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/kernel/svm/color_util.h#L304): factor is saturatef(t), then MIX dispatches to `svm_mix_blend` / `interp`. [util/math_float3.h#L445](https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/util/math_float3.h#L445): interp returns `a+t*(b-a)`.
- [scene/shader_nodes.cpp](https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/scene/shader_nodes.cpp), MixNode::compile around5182: use_clamp adds separate result-clamp nodes. Therefore saved `use_clamp=false` means no result clamp, **not** an unclamped legacy MIX factor.
- [svm/closure.h#L1324](https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/kernel/svm/closure.h#L1324): MixClosure saturates input weight, then produces in_weight×(1−weight) and in_weight×weight. In this graph those feed Transparent and Principled respectively. This establishes weight arithmetic, not full transmission/shadow coverage semantics.

Nonfinite behavior is outside the proposed finite validated fixture. Do not generalize the safe helpers into arbitrary NaN-handling parity; platform min/max semantics and compiled fast math require separate treatment.

## ColorRamp: two-stage preparation and lookup

1. [blender/shader.cpp#L333](https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/blender/shader.cpp#L333) creates RGBRampNode, invokes colorramp_to_array with RAMP_TABLE_SIZE, and sets interpolate when mode is not CONSTANT. Saved graph is LINEAR.
2. [kernel/types.h#L38](https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/kernel/types.h#L38) sets RAMP_TABLE_SIZE256.
3. [blender/util.h#L149](https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/blender/util.h#L149) allocates size+1 entries and calls ramp.evaluate(float(i)/float(size)) for i=0..256. Thus257RGBA values, not256.
4. [rna_color.cc#L358](https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/source/blender/makesrna/intern/rna_color.cc#L358) routes ColorRamp evaluation to BKE_colorband_evaluate.
5. [colorband.cc#L396](https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/source/blender/blenkernel/intern/colorband.cc#L396): LINEAR RGB clamps before/after endpoints to endpoint color; searches first stop with pos>in; computes reverse-oriented `fac=(in-right.pos)/(left.pos-right.pos)`, `mfac=1-fac`, then `mfac*right+fac*left`. Retain operation order if defining a strict float32 preparation model. Same-position fallback has explicit branch; this actual ramp has distinct stops.
6. [scene/shader_nodes.cpp#L7319](https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/scene/shader_nodes.cpp#L7319) emits the prepared table and its length to SVM.
7. [svm/ramp.h](https://github.com/blender/blender/blob/32f5fdce0a0a571a39198edf8d7b5d719bf59f2c/intern/cycles/kernel/svm/ramp.h): rgb_ramp_lookup clamps factor to[0,1], multiplies by(table_size−1)=256, converts/clamps integer index, sets t=f−i, and if t>0 interpolates `(1−t)*entry[i]+t*entry[i+1]`. Runtime uses extrapolate=false. RGB and alpha are stored separately; actual downstream links use Color.

Because the two-stage LUT interpolates across any stop kink that falls inside a cell, direct six-stop piecewise-linear evaluation is not universally equivalent. The exact saved stop values remain source recipe/provenance, while a Cycles-oriented numerical oracle must include the257-entry preparation. A future independent pure-data implementation can reproduce this without rendering, but none was run here.

## Remaining oracle limits and next allowed numerical boundary

These sources settle the previously uncertain operation-level rules for the active finite scalar subset. They do not prove a bit-identical actual compiled shader: Cycles graph constant folding, kernel CPU/GPU backend, FMA contraction, denormals and evaluated parameter/coordinate sources can differ. No source inspection of BSDF/render transport was used as authorization to implement or query it.

A bounded numerical prototype may explicitly compare fixed arithmetic to a declared float32 source-operation interpreter that rounds after each operation and uses the documented ramp preparation. Its outputs should be BaseColor, MixShader factor and BSDF parameter values. It should reject/label nonfinite/invalid control tuples, nearzero denominator quantization, sqrt/threshold ambiguity and integer range violations. It must not be called Blender image parity, compiled-Cycles parity, complete PBR support or a renderer integration test.
