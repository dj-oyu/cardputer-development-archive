# Pre-run normal representation A/B
Proposal is a causal diagnostic, not an assumption that Ns or Ng is correct.

Inputs remain the actual1166tri native camera winners and positions, fixedDISK16×3 endpoints, same geometry/rho/world/sRGB/clamp/RGB565 and original v3 reference/foreground/uncertainty masks. Ns is the saved captured-float32-weight interpolated SNORM field. Ng is the cross product of the winning triangle's actual world-space edges, oriented toward the camera's orthographic viewing vector, never oriented toward Ns. Raw Ng cross and Ns both pass through the existing C normalize3. No Ns/Ng blending, angle threshold tuning or source image input.

Cross-product length<=1e-12 Blender-unit², absolute cross·unitView<=1e-12, nonfinite input/output or zero viewing vector reject the entire case. No affected pixel is silently excluded. Test synthetic both winding/orientations, zero area, edge-on and nonfinite inputs first.

Visibility is precomputed for ALL48 light endpoints per covered pixel, independent of either normal, using the same reduced1166tri BVH, opaque two-sided triangles, epsilon0BVH, ray-direction start inset1e-5 and endpoint inset1e-5. Reject endpoint distance<=2e-5. This changes work coverage only, not the geometry visibility definition. Current Ns raw float64/RGB565 must match all four previous visibility-ON images exactly with this cache before any Ng result is accepted.

Evaluate baseline/direction×front/oblique. Preserve full image/foreground, uncertain areas and all stable masks. Report stable and full-foreground scores, uncertain descriptive values (never PASS), RGB regressions, signed FP/FN per object and CPU/RAM. A one-view or one-sign improvement is not adoption. Existing product defaults and official references remain unchanged.

Physical-side assertion: recover original triangle using the actual compact-to-source vertex map. Selected triangle orientation must equal original cyclic order for front side and reversed cyclic order for back side (world transform is the existing fixed identity). Compute cross AFTER converting native points to Blender/source coordinates, accounting for determinant−1. Physical Ng is minus original-source cross on front and plus it on back; assert agreement with camera-facing Ng. Any disagreement rejects the case rather than flipping toward Ns.
