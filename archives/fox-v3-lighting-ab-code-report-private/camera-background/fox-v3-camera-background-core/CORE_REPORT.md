# Host scene-composition core: source freeze

This is a private opt-in host experiment. No actual character frame or physical frame has been rendered by these core tests. The original A2 public APIs remain unchanged. The new API with a NULL composition binding directly calls A2. All70 inherited files are byte-identical except ksn_mesh_depth.c, whose entire original byte prefix is retained and followed by one include. The inherited physical, visibility and transport files are byte-identical. Parent integration supplies its separately reviewed transport bridge.

## Semantics

The new composition API retains original center character shading, target selection, four quarter positions, geometry, final character shading, old character observer, counters and center-depth output. The resolver receives all selected quarters and only non-target centers. A valid KEEP preserves the original HDR operand or encoded center without re-encoding. A strictly closer floor may replace only visible radiance. Character work/depth/support remain separate. Background-only uses a separately geometry-bound mask, copied into the existing workspace, and does no character shading.

Query24B and result40B are statically asserted. No-hit depth and scene-miss depth are canonical+0. Successful KEEP RGB must be canonical+0, although the original character RGB remains the selected operand. All compact result bytes start zero before every callback. Unknown action/classification, invalid precedence, nonfinite/negative RGB, inexact promoted floor float, and invalid canonical fields reject. A false callback can modify only its local result; it cannot commit that result into HDR/output. A frame can already contain partial earlier outputs and must remain unpublished on false.

Invalid admission intentionally preserves caller outputs, including a reused report whose prior complete flag is true. The boolean return is authoritative. After admitted work starts, the report records partial work and is not complete on failure. Hidden/intermediate character shader errors retain A2's explicit final-visible-only error contract: the old-equivalence fixture remains FAIL, not a successful legacy-equivalence claim.

Full declared spans are checked before invoking the opaque resolver overlap hook. The hook additionally checks retained resolver/BVH/work allocations. The parent bridge must check hidden shader-owned direct/transport budget spans and scene allocations. Initialized live objects and truthful declared ownership sizes are API preconditions, not arbitrary forged-pointer support.

## Work

The unchanged A2 ledger remains separate. New core hard cap1,680,000 and the exact20-category table were pinned before implementation. Synthetic fixed target masks2385/2391 exercise39,555/39,573 callbacks, last band7 rows, and every active category's exhaustion. Background-only observed totals are1,654,727/1,655,363; reservations are1,671,112/1,671,748. Optional descriptor hash16,384 plus guard1 remains reserved and unused: observed bytes0 and descriptor_fingerprint_executed=false. Core never hashes opaque padding.

All RGB arithmetic uses the existing four-sample mean and encoder. No new full-frame HDR buffer exists. Background-only records no legacy geometry work. Original character budgets and transport budgets remain unchanged; background shadow limits are separately bounded2M/200M/100M. The core checks limit/used fields, while the resolver and parent bridge own full cumulative routing/no-borrowing validation.

## Memory and stack

Measured ABI: binding104, ledger160, report400, query24, compact result40, original workspace137312 bytes. Resolver steady owned state1696 + core controls664 =2360 bytes. A simultaneous old+new descriptor replacement adds976 and a live source input752, giving4088. With the separate4050-byte mask-construction buffer, this bounded one-arm construction peak is8138, below16,384. The control API includes its supplied mask in its runtime new-owned bound. Original retained RGB/depth194400, original8192 stack allowance, identity7930+preflight360, snapshot and retained BVH remain separately accounted and unchanged.

O2 -fstack-usage: composition frame1664 + sc_resolve80 + resolver chain2032 =3776 bytes, below4096. Background-only256 +80+2032 =2368. Admission helper480 and binding validation224 return before the resolver callback. The helper is deliberately noinline to keep admission arrays off the rendering call chain. Parent transport and optional diagnostic wrapper frames must be reported separately with their actual compile flags. No device-fit claim follows from these host bounds.

## Evidence and limitations

Run `sh tests/run.sh`. O2 and O1 AddressSanitizer+UndefinedBehaviorSanitizer pass83 negative cases, exact NULL/KEEP bytes/depth/old report/observer tests, floor override work preservation, poisoned/freed source array ownership, full-span overlap cases, invalid result and cumulative budget cases, all active category exhaustion, exact control totals, and HDR averaging. Original A2 geometry/error-contract fixtures also pass their expected outcomes.

LeakSanitizer cannot run in this ptrace execution environment and is explicitly disabled; this is not an LSan pass. O1 sanitizer tests exercise safety, while O2 provides the stack-size admission evidence. No timing/benchmark/actual-image quality conclusion is made. Further actual runs require the independent parent review and combined source freeze.
