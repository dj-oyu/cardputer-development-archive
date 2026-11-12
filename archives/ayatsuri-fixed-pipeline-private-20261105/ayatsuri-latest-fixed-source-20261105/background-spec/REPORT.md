# Read-only background/composition specification audit

## Result

The inspected historical camera/background experiment performs **opaque sample selection**, not alpha-over. It chooses the existing character radiance, a shaded finite-floor radiance, or constant world radiance. It provides no material alpha, transmittance, accumulated opacity, or transparent-layer output. Its two different kinds of `mask` are not opacity. Nothing inspected establishes that this historical camera/floor/scene descriptor is bound to the latest `.blend` assets.

This audit only reads named source files/manifests and computes independent supplied-RGB arithmetic. No existing renderer, importer, resolver, geometry/visibility routine, build script, physical frame, device or public operation was executed. No existing file was edited. No denied directory was read or retried. `SOURCE_EVIDENCE.md` preserves exact numbered excerpts; `source-audit.json` supplies full hashes, selected manifest checks and separate latest asset identities.

## Actual background behavior

Evidence: background/background.c:100–118; background/background.h:21–28,41–55,92–98; product/main/ui/kasane/ksn_scene_composition.h:4–18; ksn_scene_composition_impl.inc:42–55.

- Query carries pixel/sample tag, character-hit boolean, character depth and mode. Result carries action, floor classification/depth and three **linear RGB** doubles. Neither structure has alpha.
- Existing resolver's sample positions are center or four ±.25 offsets (background.c:108). Its computation of floor availability/depth is existing acquisition code, read only, not reimplemented or tested here.
- In composite mode, a character hit is kept when there is no floor hit or floor_native_depth <= character_depth (109–110). Exact equality keeps the character; this native convention selects the **greater** depth as nearer. Core validates the matching strict replacement condition (composition_impl:52–54). No tolerance is introduced by this audit.
- KEEP's returned RGB is canonical zero, a sentinel, **not black background or an attenuation factor**. Core preserves the already computed character RGB (96–100) or leaves encoded non-target center output untouched (134–136).
- Floor selection returns, componentwise, **direct + rho*world + Le**, with Le once (background.c:112). The direct term is supplied by the existing disk-light evaluator. Scene construction copies world separately and zeros world in the direct-light scene (73), preventing that path from independently adding the same world contribution. This is supported composition arithmetic, not a new claim about how direct illumination is acquired.
- True floor miss selected as background returns world radiance directly (111), without rho or Le.
- Background-only mode does not preserve character color. Its core receives an already supplied, geometry-bound target mask and produces floor/world slot colors (scene_composition.h:61–68, impl:142–163). It is not a generic “surface behind the front surface” result. The historical report says character geometry remains in the retained shadow context (background/REPORT.md:13); no shadow behavior was executed or independently validated here.
- Finite, nonnegative radiance is required before acceptance (background.c:112; composition_impl:48). Callback failure is not interpreted as transparent or black. Existing report states partial failed frames must remain unpublished (CORE_REPORT.md:9–11).

## Alpha and the three meanings of mask

### Legacy importer: opacity deliberately unsupported

product/tools/ayatsuri/asset/import_glb.cjs:125–133:
- alphaMode must be missing or OPAQUE; BLEND and MASK are rejected.
- alphaCutoff is rejected, as are material textures.
- baseColorFactor has four components but component 3 must equal **1**. Carrying four values in its IR does not imply alpha rendering support.
- Root images/textures/samplers and other unsupported arrays must be empty (82–83).

compile_static.cjs:24–28 sets generated nodes to opacity=1, edgeSoftness=0 and per-vertex mask=-1, with RGB565 color mapping. This is evidence for this specific static import/compile path, not a claim that every unrelated legacy procedural UI component lacks opacity.

### Signed material-selector mask

composition_impl:83–90 and mesh_depth.c:135–147 interpolate the vertex mask and test its sign, then choose color_b or color_a. Both are RGB565 albedos. It is a two-color/material-region selector, not a blend weight or discard/alpha-test predicate. A zero sign selects B. No continuous opacity follows from the mask's magnitude.

### AA target bitmask

ksn_boundary_aa.h:35–38 defines one bit per screen pixel (4,050 bytes). boundary_aa_impl:76–84 marks pixels whose center identity differs from a direct neighbor. It selects where four subpixel evaluations occur, not their opacity. Background-control mode copies an externally supplied target mask (composition_impl:142–146); that API's existence does not prove arbitrary current-scene mask acquisition.

### Face-texture coverage is another separate concept

The optional latest face-mask arithmetic experiment is not consumed by any audited composition API. A coverage byte would need an explicitly specified material-color use or transparency use. It cannot be wired into either legacy `mask` field and assumed to retain its R8 meaning. The existing face prototype's opaque base-color mix is not evidence of transparent background composition.

## Numeric and AA order actually present

Evidence: composition_impl:83–100,124–136,154–160; ayatsuri_shade.h:45–51.

1. Select RGB565 albedo A/B; decode each vertex's normalized RGB channels with the existing float32 sRGB transfer function.
2. Obtain linear albedo through the existing affine helper, then linear radiance from the character shader. The helper's implementation was not independently audited here; no stronger interpolation claim is required.
3. For each retained subpixel, select **one** radiance operand: character KEEP, floor replacement or world replacement. No multiplication by alpha or transparency accumulation occurs.
4. Add selected values to the double HDR accumulator. At selected AA targets, average four samples in linear space.
5. Clamp the mean to at most 1, cast to float, apply sRGB encoding, multiply by channel maxima 31/63/31, lroundf and pack RGB565. Valid inputs are already nonnegative. There is no new exposure/tone-map curve; HDR is clipped at this output stage.
6. Non-target replacement centers are encoded directly once. Non-target KEEP centers retain the original encoded bytes and are not re-encoded.

Exact transfer source: decode x<=.04045f ? x/12.92f : powf((x+.055f)/1.055f,2.4f); encode x<=.0031308f ? 12.92f*x : 1.055f*powf(x,1/2.4f)-.055f. Compiler/libm float32 behavior is relevant; a high-precision mathematical analogue is not bitwise parity evidence.

The no-background historical boundary-AA path leaves a no-hit sample's zero-initialized HDR contribution untouched (boundary_aa_impl:120–121), with black RGB caller initialization required (boundary_aa.h:61). The composition path instead supplies a selected floor/world RGB for that no-character slot (composition_impl:70–73). Neither mechanism is material alpha-over. Silhouette coverage from choosing different opaque subpixel operands is distinct from per-surface transparency.

## Independent supplied-input checks

`arithmetic_checks.py` does not import or execute production modules. Its exact-rational fixtures verify only the supported scalar formulas:
- direct [.25,2,0] + rho [.5,.25,1] * world [.5,4,.125] + Le [.125,0,.5] gives [.625,3,.625].
- Supplied HDR samples [4,0,0,0] average then clamp to 1; clamping samples first would give .25 and is wrong for the audited order.
- A linear mean .5 encodes mathematically to approximately .735357; averaging encoded black/white gives .5. The mathematical RGB565 channel values are [23,46,23]. This is an ordering counterexample, **not a renderer run or exact powf parity test**.
- Four explicitly supplied RGB slots average componentwise to [.5,.5,.5].

No depth/visibility decision fixtures, ray queries, background extraction, material-alpha importer execution or transparent rendering were tested. Existing source reports' historical tests are cited as reports, not rerun successes.

## Identity and supported boundary

The inspected code belongs to `fox-v3-camera-background-core`, whose CORE_SOURCE_FREEZE explicitly describes a private host opt-in core based on preserved A2 files (CORE_REPORT:3; CORE_SOURCE_FREEZE:2–8,27). Its background BYTE_PROOF identifies `fox-v3-boundary-rho-affine-core-A/SOURCE_FREEZE.json` as the older base. The present audit verifies 14 applicable hash entries across the core/background freezes and source-preservation record; it does not reverify every uninspected dependency or endorse whole-root integration.

Separately rehashed current assets:
- Original latest fox: d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a.
- Latest 2k-v2 derivative: 384ada0c37da16d625b1e6612a0d2f7ca538c29fe0d8dff43a929841ec63fba8.

The inspected historical entrypoints take camera, floor vertices, clipping, rho, Le, lights/world and opaque identity/snapshot fingerprints from a caller. They do not identify a particular original asset SHA, export the latest `.blend`, or establish latest camera/material/geometry correspondence. An exact historical model-asset SHA was **not established** from these inspected files. The generic GLB importer records whatever input SHA it receives (import_glb:176), not a fixed latest-model identity. No binding is invented.

A straight-alpha-over formula would need front opacity and a correctly acquired background radiance behind that front sample. Those operands/contracts are absent from this opaque resolver; replacing KEEP's zero sentinel with “background” is incorrect. This audit therefore supports supplied-radiance addition/averaging/encoding only. Obtaining current-scene background behind a transparent face, handling additional layers, changing depth/visibility, or claiming renderer correctness remains unimplemented and outside this task. No dependent acquisition action was attempted.
