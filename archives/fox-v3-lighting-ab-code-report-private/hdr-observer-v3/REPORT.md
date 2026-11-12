# Actual004 HDR observer: no feature change

Four native cases (front/oblique baseline/direction) preserve all original004 RGB565/depth bytes exactly. Actual pre-clamp shader values are captured, never reconstructed from565. Independent fresh C replay reproduces all20 color/depth/HDR buffers. No bounce implementation or scoring change occurred.

## Finding and next candidate
On the fixed common two-pixel-eroded interior, native radiance already slightly exceeds rich direct diffuse (about1.10–1.14×), while only covering about0.69–0.77× total diffuse and0.60–0.70× Combined. Thus a global direct-light gain is unsupported. The radiance gap spatially correlates with rich indirect diffuse around0.64–0.72 on this conditional interior. One-bounce indirect diffuse is the next plausible missing element, not a proven60% solution.
Correlation caution: Combined−native already contains indirectDiffuse algebraically, so its correlation with indirectDiffuse includes a part-whole effect. This does not quantify causal explanation or predicted repair. Native direct diffuse is already overbright on the conditional interior; adding indirect without revisiting world transport may overcount. The proposal is an isolated transport experiment, not a demonstrated correction.
Original foreground has620/720 native missing pixels and boundary/filter/material differences. Whole-foreground correlations are much weaker (about0.09–0.20); do not promote the interior result to an unconditional causal share. Adding indirect transport cannot repair missing geometry by itself.

|view/seed/case|native/direct diffuse meanY|native/total diffuse|native/Combined|gap/indirect correlation|
|---|---:|---:|---:|---:|
|front/11/baseline|1.1043|0.7647|0.6970|0.6982|
|front/11/direction|1.1195|0.7528|0.6821|0.6443|
|front/29/baseline|1.1045|0.7652|0.6974|0.6962|
|front/29/direction|1.1204|0.7534|0.6826|0.6428|
|oblique/11/baseline|1.0953|0.7391|0.6583|0.7179|
|oblique/11/direction|1.1414|0.6923|0.6007|0.6601|
|oblique/29/baseline|1.0956|0.7396|0.6587|0.7182|
|oblique/29/direction|1.1424|0.6928|0.6011|0.6599|

## Response positions remain a different limitation
Interior linear-HDR direction response correlation against direct diffuse is about0.95; its bright-region IoU is about82% front/74% oblique. Full original foreground gives about68%/43%. These use fixed2/255 in linear HDR, not the displayed formalv3 threshold. They are diagnostics, not acceptance scores. Relative to Combined, the conditional interior is lower and full-domain difference remains. Do not call1bounce likely to eliminate the oblique displayed-position failure.

## Meaning and comparisons
Native combined is actual DISK16 with character-only direct visibility plus unoccluded world. Native world is interpolated decoded565rho×world radiance; native area is combined−world, a floating residual rather than an independent rerender. All are linear HDR before clamp/profile. Static zero arrays assume one process/one frame: not parallel or reusable multi-frame product storage.
Rich EXRs are the existing same1166geometry rich-material oracle, seeds11/29, original source3lights/world/ground/PBR/GI/BH1.5 filter. DiffDir×DiffCol includes world and ground-emitter illumination as well as area lights. It is not a pure3light identical shader target. DiffInd×DiffCol includes rich indirect transport, not necessarily a single bounce. Original indirect clamp10 and prior recomposition residual remain; no residual is erased or gate relaxed. Gloss direct/indirect are separately counted. No rich radiance is fed into native rendering.
Whole originalforeground is retained with native missing pixels black. Common and Chebyshev-radius2 eroded-common domains are additional conditional diagnostics; outside-image false. Pixel-center native and stochastic filtered rich are not sampling-equivalent. All regions and full per-seed static/response results are retained in analysis-003. No imagewise exposure/minmax/registration, fitted colors or coefficients. Zero norms/empty unions yieldN/A rather thanPASS.

## Costs and validation
Global observer storage2332800B (3×32400×3 doubles), plus ordinary host render/BVH memory. Four process elapsed1.322s, not controlled performance evidence or device timing. It is a diagnostic memory cost, not product deployment.
Input/source/model/reference hashes are checked before and after. All4case outputs match old0048RGB/depth buffers; independent actualC20buffers exact and allHDR finite. area+world reconstruction error below1e-12; the area difference is not an additional renderer. No new Blender renders were required. analysis001 is retained failed input-key attempt; analysis002→003 changes only a misleading correlation label fromPositive toSigned. Finalanalysis003 is authoritative.

## Next plan, not implementation
Recommend first testing one-bounce diffuse transport with explicitly separated world-visibility-only control and world-visibility+one-bounce arm. Existing unoccluded rho×Lworld must not remain alongside an added miss-world term. Cosine-weighted outer average yields rho(x)×mean[L(y)]; at a surface hit reflected L(y)=rho(y)×E_direct(y)/pi, with rho(x) applied exactly once. Miss returns world radiance. Ground is omitted in this first plan and remains unsupported; ground emitted Le and reflected illumination must never be conflated. Secondary visibility, source material side/normal and sample error require separate synthetic validation before any implementation acceptance. Current ray/node limits cannot simply be reused as if the nested workload were free. No bounce code was started; parent decision required.

Final independent audit: 2244 numeric values agree using a separate EXR reader across all8 richEXRs and three fixed domains; fresh4case observer20buffers agree exactly. Part-whole correlation limitation retained. Diagnosis complete, not native goal acceptance.
