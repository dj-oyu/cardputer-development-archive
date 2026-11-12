# Full camera scene composition: design v2, implementation not started

This supersedes the nohit-only design, preserved in `CORE-DESIGN-nohit-only-rejected.md` and its ledger JSON. Parent now explicitly permits a separate host scene-composition experiment with floor depth occlusion. Numeric work/direct limits still need review; this design assigns no new work/ray cap and imports no floor-reflection allowance. The three floor-in-front observations are retained as evidence that nohit-only was not equivalent, not silently erased.

## Frozen A2 and the one minimum arm

Use the frozen rho-affine A2 quarter-offset renderer. All original geometry, material, floor geometry, epsilon, profile, character shader and quarter positions remain unchanged. Keep its entire original accounting, workspace137312, stack reserve8192, owned snapshot/scenes and identity+preflight tables7930+360 unchanged. No full-frame HDR array is added.

The enabled arm computes the original character camera center and selected samples as before, including every original shader call, transport query and counter. It then decides whether floor/world is the visible camera radiance. Floor may override RGB/HDR when strictly in front; it never modifies retained character depth, hit/source identity, mask or geometric-error evidence. Every altered composed sample is reported separately. Floor covering an under-floor paw is scene occlusion, not a geometry improvement.

## Explicit new API and callback result

Add a separately named `ksn_mesh_pixel_render_scene_composition_experimental` entry taking the existing A2 arguments plus a size-aware, owned composition binding. A NULL binding immediately calls the untouched A2 entry, so no new checks/loops/guards execute and the legacy bytes/counters remain exact. No existing function body or default is changed.

The conceptual callback is:

`bool compose(context, owned_lights, query, result)`

Query is read-only: exact screen x/y, sample_tag0..3 or4(center), original character_hit and original float character_depth. Result is failure-atomic: action KEEP_CHARACTER or REPLACE_FLOOR or REPLACE_WORLD, local linearRGB[3], floor-hit/depth/classification diagnostics. The callback first solves/classifies the camera floor, compares in the audited common native-depth convention, and evaluates floor lighting only if visible. World replacement is allowed only when there is no character and no visible floor. KEEP is invalid for a character miss. Unknown actions, nonfinite/negative output, or an inconsistent replacement precedence are failures. No epsilon or camera transform is invented here.

For a depth tie, KEEP_CHARACTER is the proposed explicit deterministic tie rule: replace only for strictly nearer floor in the audited precision. This rule must be frozen with the camera-depth audit before implementation. Floor geometry and shadow epsilon remain unchanged.

### All selected quarter samples

For every one of the4T selected samples, retain the original final character winner/shading or original black miss. A local background RGB starts at zero; callback writes a validated atomic candidate, never the accumulator. If action KEEP_CHARACTER, use the original character HDR values exactly; do not add zero background, re-encode, decode or adjust them. If action REPLACE_FLOOR/WORLD, copy the candidate to the selected sample's HDR value. Then make exactly one contribution to the existing equal-four band sum and use the original final mean/encode path.

Character shader counters are committed immediately after successful character shading, even if the later composition callback fails. Do not suppress character lighting work at the two overridden samples. Original character hit/depth/source/normal/rho/RGB observer data remain separate; a new output-only composition observer streams action, composed RGB, floor depth and physical components. Never overwrite the old observer's character RGB and then call it unchanged evidence. Old character-success semantics do not imply composition-success semantics; a later resolver failure invalidates the complete frame.

Covered samples already have their single accumulation in original A2's shaded-hit stages; the enabled path moves that single accumulation after composition selection rather than accumulating character and subtracting/replacing it. Original nohit samples need newly charged accumulation. There is never a full-frame HDR buffer or double accumulation.

### Every non-target center

In the existing final-output scan, query composition for every non-target center, including character hits. KEEP_CHARACTER performs no RGB write and no encode, preserving the original encoded center bytes exactly. A replacement is validated and encoded once. Original center depth is read-only and remains in the output. Target centers keep their original character lighting work, but receive no extra floor shade/output; their four quarter samples determine output.

### Separate background-only control

A small independent control entry uses the same geometry-bound mask and shadow BVH but performs no character camera shading. It has no character-depth output, avoiding the false implication that retained A2 depths describe its camera-visible geometry. Its fixed mask is prepared/bound directly in the existing workspace target buffer; no mask is derived from background or image color. It processes all non-target centers and4T quarters, not only the combined arm's empty slots. Report synthetic control coverage/radiance separately from original character geometry metrics. A NULL composition binding means the original A2 arm only, not this control.

## Exact domains and the three-versus-two distinction

P=32400; targetsT=2385(front)/2391(oblique); non-target centersN=P-T=30015/30009. The composition callback domain is Q=N+4T=39555/39573 in each complete frame. This is also the background-only control's camera domain.

Full floor-ordering preflight includes all centers, including selected centers, plus selected quarters: P+4T=41940/41964. It found3 front floor-in-front positions. The center at145,115 is selected, so it is ordering evidence only and adds no rendered floor shade. Actual enabled composition has2 quarter replacements of otherwise-covered character,0 non-target-center character replacements. Preserve all three counts distinctly.

Original empty domains: center replacementsC=27236/26703; selected original missesS=1862/2199. Thus actual selected replacement slotsR_s=S+K=1864/2199, with covered-quarter overridesK=2/0; center replacement slotsR_c=C. Total floor/world radiance resolutions areR_c+R_s=29100/28902. Remaining queries only determine KEEP and do not evaluate hidden floor radiance. These exact counts must be independently re-bound to snapshot/camera/mask/floor/preflight generations before admission; they are not hardcoded permission to ignore any other winner.

## Proposed explicit core-stage ledger

The original A2 ledger remains separate and unchanged: front7923890, oblique7673634. The following additions are proposed bounded stages, not instruction counts, a renamed old49, or an assigned new cap. Floor resolver/preparation costs are not included in one callback-dispatch unit.

| Added category | Count |
|---|---:|
| Fixed binding/alias/generation validation |512|
| Frozen target mask fingerprint bytes |4050|
| Non-target character hit/depth state reads |2N|
| Query preparation x/y/tag/hit/depth/destination |6Q|
| Local background RGB zero |3Q|
| Composition callback dispatch |Q|
| Returned RGB finite/nonnegative validation |3Q|
| Action/precedence/output classification validation |3Q|
| Core callback attempt/success accounting |2Q|
| Selected replacement RGB copy |3R_s|
| Original selected-miss HDR addition+finite checks |6S|
| Non-target replacement encode/write |8R_c|
| Explicit core guard dispatches |6Q+R_s+S+R_c+19|

Six per-query charges are query preparation, zero, dispatch, RGB validation, action validation and core event accounting. Separate guard calls cover replacement copy, added miss accumulation, center encode,17 band state-read guards and2 frame checks. Observed scans increment on actual visits; failures do not publish partial outputs. Internal physical classification counters are in the resolver ledger, not silently included in the two core attempt/success counters.

Core-only additions are front1279545 and oblique1278867, yielding old+core-only9203435/8952501 before descriptor bytes, camera intersection, floor lighting/shadows or preflight. The candidate descriptor below has848 canonical non-pointer bytes to hash additionally. Old8M failure remains explicit. Numeric new work limits must be chosen only after the complete reviewed call-site ledger is fixed.

The control must count its own full work, without claiming old character stages were executed: fixed binding, mask hash/copy if needed, 3P band HDR clear,4P sample enumeration, P final scan, allQ resolver dispatch/validation,6*(4T) sample accumulations,8P output encodes and every guard. It may reuse the same callback/result contract with character_hit=false, but has a separate ledger and completion status. Existing nohit-only control core estimate is a historical lower decomposition; do not silently admit control under it after the new action validation contract changes.

## Physical/preflight and direct budgets remain explicit

Every composition query performs the camera/floor classification; only visible floor replacements evaluate floor radiance. Report camera affine mapping, solve/nonfinite checks, clip/parameter tests, finite two-triangle tests, receiver normal/tangent rules, existing physical evaluator input checks,48 kernels per floor evaluation, positive-kernel endpoint setup, actual shadow queries, world/Le composition, atomic result copy and resolver counter guards separately. KEEP never launches floor direct shadow rays. Character lighting and its existing transport remain unchanged.

Parent has separately authorized the principle of a new host diagnostic budget, but its numeric limits are not assigned here. Use one explicitly approved cumulative primary direct budget for character+visible-floor queries in the new arm; never reset between bands or move these rays into transport. Keep the original1M failure certificate: prior nohit-only added direct1118832/1203920, maximum combined1642832; original background-only1486704/1656192. Recount the2 newly visible floor quarters before fixing new composition totals; do not call the former counts complete for this arm. Old floor-reflection allowances are not inherited. Node/triangle caps and any changed limit also require explicit review.

Preflight still costs work and memory of its own. It binds camera origin/clip constants, exact rounded inverse basis, snapshot, source mask, floor geometry/material/lights and scene generations. It reports all41940/41964 ordering positions,2/0 actual rendered overrides and all positive kernels. The nohit-only equivalence FAIL remains preserved; full scene composition permits and records the floor occlusion. No source geometry, reference, mask threshold or epsilon is changed to hide it.

## Separate owned memory, not squeezing into old spare bytes

Keep original A2 allocation/accounting unchanged. Parent proposes for review a clearly separate host bound of16384B new owned background state plus4096B new stack allowance. These are review inputs, not a measured acceptance or device-fit claim. They give a conservative combined workspace/stack bound145504+16384+4096=165984B, plus unchanged retained RGB/depth194400B and existing immutable tables8290B. Existing snapshot/BVH/transport allocations remain separate and unraised. No extra full-frame HDR is permitted.

A concrete draft64-bit layout estimates:
- immutable camera/floor/generation descriptor448B: camera9float+version40; inverse72; target/origin/direction72; clip/axial24; floor vertices96+indices/padding8; rho/Le48;7tokens56; retained vis_binding32;
- prepared owned zero-world FoxDiskScene408B, pinned to full light identity, so unchanged physical evaluation gives direct-only floor RGB for separate direct/world/Le reporting without per-pixel408B copies or cancellation subtraction;
- context264B: five8-byte pointers, sixteen64-bit counters, four RGB-component sum triples;
- separate40-category ledger/report664B: two40xuint64 arrays, totals and status.

Estimated new owned total1784B is not final `sizeof`. New query/result locals and call-chain stack must be measured against the separate4096B allowance after implementation authorization. Any extra mask copy, canonical descriptor serialization scratch, snapshot/scene retention peak or diagnostic observer buffer must be included visibly. Prefer preparing the bound mask directly in existing workspace.targets; an external4050-byte construction copy, if used, fits only when explicitly charged to the new host peak. Generic output observer state/I/O is a separate diagnostic cost.

## Fixtures required before actual arm execution

1. NULL binding: frozen A2 all20 output and counter exactness, with no new path executed.
2. KEEP at centers: no decode/encode/write, byte-identical RGB and untouched depth. KEEP at quarters: original HDR operand used exactly once, no zero addition or replacement arithmetic.
3. Physical floor behind/front/tie; original character shader calls retained even on floor override; front3 ordering observations but only2 quarter replacements and0 center overrides. Selected center receives no extra floor evaluation.
4. Miss floor/world results, fixed denominator4, high HDR before mean/clamp, no new +.5, separate character and composed support/observer records. World/floor never masquerades as character source/coverage.
5. Callback false after partial candidate writes, illegal KEEP-for-miss, world-over-character, unknown action, invalid depth precedence, NaN/Inf/negative, sum overflow, every new quota failure and observer failure. Complete frame/quality publication only after all work succeeds.
6. Owned descriptor inputs poisoned/freed; retained-old-scene replay after new binding; exact generation/fingerprint mismatch and stale preflight rejection. No borrow of freed camera/model/material data.
7. Full-span context/descriptor/ledger/output/scene alias rejection before writes, including interior pointer aliases. Do not reuse one-byte-only opaque-context checks for the new binding.
8. Negative/clipped/outside/parallel/tangent classification and nonfinite near-parallel failure; deterministic shared floor diagonal; no invented epsilon.
9. Separate control: fixed source-bound mask, all39555/39573 queries, zero character camera shaders, retained character shadow occluders and independent complete/incomplete result.

No core, model, original source, frozen artifact, or rendered output was edited by this design task.
