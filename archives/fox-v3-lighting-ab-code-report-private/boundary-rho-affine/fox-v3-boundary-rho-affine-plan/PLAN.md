# Separate numerical stage: constant-preserving rho interpolation

Preimplementation contract following parent explicit approval. Preserve prior failed BH experiment and its source/partial output. This is not a new position/weight fit. Frozen lid8, source/reference/thresholds, old API/default, geometry/mask, q and every resource cap unchanged. New isolated code root; no original file modification. Prior failure0 B-complete remains recorded independently.

## Exact scope and arithmetic

Change only rho interpolation inside the experimental AA final-sample reconstruction. Leave all center rendering, edge coefficients, barycentric computation/order, depth/visibility/tie handling, worldP, front/back SNORM interpolation, material mask branch, and shader/transport arithmetic untouched. The two palette choices and actual float sRGB565 decode remain identical.

For each RGB channel, let a,b,c be the three existing decoded float values promoted to double; let u=bary[1], v=bary[2]. Compute exactly in this order with FP contraction off:
  rho = a + u*(b-a);
  rho = rho + v*(c-a).
Do not normalize barycentric coordinates and do not change P/Ns/depth. Retain original finite and range guard rho in[-64DBL_EPSILON,1+64DBL_EPSILON], then existing clamp[0,1]. No epsilon growth, no zero-normal fallback, no failure suppression. Constants a=b=c retain their decoded value exactly for finite barycentric values; the expression is not claimed byte-equivalent for every varying attribute or every input ordering.

Use a small local helper for rho only and preserve all existing decoded color semantics. Three float triplets can be decoded into36B instead of old12B temporary, an expected24B stack change; measure actual compiled stack rather than assume. Existing8192B transient reserve remains, workspace137312/RO7930 unchanged. The arithmetic is three old multiplies+three adds versus two subtracts+two multiplies+two adds per channel; retain64-stage final shader/interpolation charge and all21categories, subject to independent code/stack check. No silent stage discount.

## Synthetic and domain gates

Test constant black/white/finite decoded palette extremes under old failing barycentric triple and broad finite near-simplex perturbations: new output exactly constant; old rejection reproduced separately. Verify analytic affine attribute interpolation on simplex fixtures, mixed RGB/convex endpoints, zero/one vertices and edges, tiny weights, shared-edge/permutation mathematics within explicit FP error (do not claim arbitrary order byteidentity). Test negative/outside weights giving values outside existing bounds reject; nonfinite input/output reject without publishing outputs; unchanged allowed tiny-bound clamp behavior. Reject aliased unsafe helper buffers or design local value return so no external alias contract is introduced. Keep actual co packet safety, side, duplicate identity, generation/lifetime and shader failure fixtures.

Old quarter-sample exact zero-normal fixture remains required in unchanged A source. The new rho helper does not change Ns or its failure semantics. Test failed frame leaves no completed quality manifest, failed-category behavior unchanged, budget exhaustion and observer-failure atomicity.

## Controls and actual sequence

1. Freeze helper/formula/source diff and synthetic/safety/stack evidence with independent reviewer.
2. Build repaired-quarter arm A2 and repaired-fixed-BH arm B2 from the same numerical stage, offset-only difference. Run old quarter all10×bothorders against frozen v32 RGB/depth/snapshot bytes; require all20exact before claiming backwards static output compatibility. Compare sample P/Ns/depth and palette branches unchanged; rho differences may exist from finite precision and must be disclosed. If any old-output byte differs, report it rather than fitting or bypassing the gate.
3. B2 OFF center controls remain oldexact. Only after control/review, retry identical fixedq±0.28820947825813636 for all10×bothorders. No phase/point/mask/weight alternative. Original fixed-mask reservations7,951,722/7,729,766 and direct1M/100M/50M, transport20M/800M/300M remain. Every frame must complete all targets, otherwise unscored.
4. Reconstruct real samples and linearHDR/black denominator/sRGB565, non-target bytes and original centerdepth; formal all10/response/uncertainty/inactive/fullFG/FPFN/regressions using unchanged reference/scorer. Independent fresh verification. Numerical-stage changes are named separately from offset AB and unsupported failure evidence never erased.
5. CPU serial only after heavy work: A2/B2 baseline2view×3, raw timing/pins/byteexact and observer overhead. Private code/report allowlist only, models/geometry/raw snapshots/per-pixel/image files excluded. No default/product/device/PR/public changes.

This stage establishes only the specified bounded host numerical behavior if gates pass. It does not establish full Cycles reconstruction, universal convex robustness, arbitrary-pose fit, alias-free AA, or60% goal attainment.
