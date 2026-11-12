# Read-only assessment: surface-based brows and mouth

Scope: read-only design assessment. No model/geometry/material/renderer changes, render, bake, visibility query or driver execution. Existing checkpoint4 files are untouched. This is a design option, not a claim of visual equivalence.

## Findings tied to the latest source

Sources: inventory.json objects/materials/custom properties, and fox-cardputer-latest-private/2k-v2-neutral-sidecar.json. Original model SHA256 d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a; sidecar SHA256 00a81fbcd19c79c578bbbbd7ab077ee6f63048a106c5594675ff208670d5e85e.

- Visible `Brow • surface -1/1` are forehead-conforming SHRINKWRAP meshes, parented to `Head Pivot • driven`. Original each has 343 vertices/576 fan triangles; current LOD each has31 vertices/29 triangles. Hidden `Expressive brow` meshes are not the active brow source.
- Brow keys: Raise, Furrow, Worried, Stern. Stored driver formulas are Raise=clamp(Brow Raise+side Raise,0,1); Furrow=clamp(Brow Furrow,0,1)*(1-clamp(Brow Raise+side Raise,0,1)); Worried=(Brow Style==1); Stern=(Brow Style==2). Both side Raise controls and global Raise/Furrow/Style are saved at zero. These strings were read, not evaluated.
- `Smile -1/1` are visible meshes parented to the head pivot, each original876 vertices/1728 fan triangles, current LOD12 vertices/18 triangles. Their Smile key is driven directly by the saved Smile control, currently0. **The same Smile control also drives both Muzzle pad shape keys.** A line-only replacement does not reproduce muzzle geometry deformation.
- `Philtrum` is a visible head-parented CURVE in the original inventory, six triangles in the LOD. Original curve spline/material details are not fully captured in inventory; do not infer an unrecorded mouth-opening rig. No Jaw/Mouth Open control appears in the saved Expression Controls set.
- Brows and Smile use `Deep cocoa • socks and ear rims`: Principled constant linear BaseColor(.028,.009,.003), linked-node Roughness approximately.65, alpha1. Material viewport roughness.4 is NOT the linked shader value. These are not currently alpha sprites.
- Combined current brows+Smile+Philtrum total100 of1,982 triangles (5.05%) before adding replacement support. Original high-resolution triangle counts must not be presented as current savings.

## Distinguish three designs

1. **Procedural surface mask**, closest to current eyes: compute a local-space curve/region mask on the actual forehead/muzzle receiver and mix its material color/parameters. Current eyes are Object-local procedural shading on eye geometry, not a screen overlay. A mask on an opaque receiver needs material selection/blending, not necessarily transparency or an extra geometric layer. It naturally uses the receiver's existing depth, occlusion and lighting. It cannot retain protruding brow/line geometry, separate cast shadows or changed silhouette.
2. **Surface decal**, texture or curve projected in a specified head/receiver coordinate system: needs stable mapping, face/receiver filtering, clipping and deformation attachment. A separate shallow mesh decal additionally needs depth-offset/z-fighting policy, alpha coverage, ordering and a shadow policy. A decal baked into receiver shading avoids the extra layer but still adds sampling/mask work.
3. **Screen-space sprite**, drawn after the scene: cheap-looking geometry does not make it equivalent. It needs head anchoring, projected orientation/scale, depth/occlusion tests, foreshortening and a policy for side/back views. Without those it draws through the nose/other objects, floats on turns, and ignores lighting/shadows. No existing eye behavior supports claiming these issues are solved.

## Converter/runtime compatibility

The existing constant-RGB AYFQ/opaque path does not encode an executable material recipe, texture sampler, alpha-tested decal or screen compositor. The latest attribute sidecar preserves local coordinates/material identity but does not implement these features. Our material interpreter is independent numerical evidence, not renderer support. Thus none of the three is a drop-in exported replacement today.

A future recipe needs: receiver/object ID and exact local/rest-space definition; bounded domain and attachment to head transform/deformation; source curve/shape endpoints for all retained states; side-specific control bindings and clamping/equality rules; color/roughness policy; coverage/edge-filtering convention; and an explicit depth/shadow policy for any separate layer. If the head or muzzle deforms, choose rest coordinates carried with deformation, or an explicitly updated receiver mapping. Merely parenting a planar mark to the head does not reproduce SHRINKWRAP or Smile pad deformation. Existing neutral sidecar alone cannot prove animated fidelity; retaining control names is not enough without shape mapping.

For mouth, preserving Smile means retaining the pad deformation separately or explicitly accepting a redesigned expression. No new full-closure, mouth-opening, brow-travel or animation capability is promised. For brows, source shape-key deltas and the actual shrinkwrap target/settings would be needed to derive a faithful local 2D curve family; their geometry is not reconstructed by this note.

## Integer/PIE and cost trade-off

A bounded curve/ellipse/strip mask can use fixed coordinates, add/multiply and strict comparisons; control coefficients can be prepared once per frame. Mask/color blending in bounded16-bit lanes is a candidate for PIE. Curvature evaluation, squared distances or transformed coordinates may need32x32→64 intermediates; general distance sqrt/divide and texture gathers are not free eight-lane16 MACs. Nearest/bilinear texture sampling trades arithmetic for memory/cache/gather cost. Coverage anti-aliasing and strict-edge quantization require their own numerical contract, as demonstrated by the eye prototype's boundary flips.

Removing100 current triangles exchanges vertex/setup/traversal work for per-covered-fragment material work. A whole-head shader can cost more than the tiny saved mesh unless cheap receiver/region bounds reject most pixels. Small dedicated surfaces limit coverage but retain geometry and possible alpha/depth complexity. Register pressure, LUT/texture footprint, clipping, filtering, lighting response and actual screen coverage are unmeasured; no S3 speedup follows from triangle count.

## Recommendation for discussion

The most compatible design direction is a head/receiver-local material mask, especially for brows, rather than a late screen sprite. Treat mouth lines plus Philtrum separately from the muzzle shape and retain Smile's geometry dependency unless a deliberate redesign is approved. Given the already-small100-triangle total, choose primarily for expression authoring and visual consistency, then measure total cost after explicit implementation approval. No geometry/render/visibility work is proposed as already authorized.
