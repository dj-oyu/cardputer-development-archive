# Upper eyelid read-only source feasibility: do not build the three-station shortcut

**No candidate geometry or render was produced.** With only320B remaining in eyeB, the smallest plausible full tube template substantially distorts the original curve. Stop the shortcut rather than call it source-curve preservation. Investigate separately authorized reversible storage improvements before allocating more contour samples.

## Verified source structure

- Only Upper eyelid ±1 exist. There is no Lower eyelid object; lower visible contours must not be attributed to a nonexistent lower curve.
- Each upper lid is one open3D Bezier spline with five AUTO control points, radius0.013, resolution24, round bevel resolution4, no caps/modifiers/taper/extrusion. Twist mode MINIMUM, twist smoothing0, source radii1 and tilts0. Evaluated topology is97 cross-section rings×12 vertices=1164 vertices,2304 triangles.
- The two curves are the same asymmetric curve translated in X, not mirrored. No mirror reconstruction is permitted.
- Eye socket ±1 are orange ellipsoid meshes, radii(.229,.06,.258), centers(±.285,-.802,2.55), no modifiers. They are solid supporting shapes behind the white, not carved holes. EyeB retains9vertices/14triangles each. Socket changes remain unimplemented pending causal evidence.
- EyeB upper lids currently use7vertices/8triangles and8vertices/10triangles. The hypothetical3station triangular tube would use9vertices/12triangles each: +3vertices/+6triangles total, not same-vertex-count replacement. Extra raw vertex/index payload is186B; actual packet/partition cost was not compiled.

## Fixed source-only numerical check

Station rule was fixed before measurement: original endpoints plus equal-arc centerline midpoint. Bezier source was sampled at1025 parameter points. No images, cameras, failing pixels or view-specific curve fitting were used. Directed distances use closest polyline segments; these are dense sampled estimates, not a certified continuous Hausdorff bound.

| Stations | Maximum symmetric sampled centerline distance | Radius multiple | Source→chord arc-weighted mean |
|---|---:|---:|---:|
| 3 | 0.07334205 | 5.642 | 0.04206724 |
| 4 | 0.03104625 | 2.388 | 0.01693411 |
| 5 | 0.01937288 | 1.490 | 0.00944671 |
| 6 | 0.01326541 | 1.020 | 0.00512480 |

Both sides agree within1.1e-8 source units. The3station maximum0.073342 is5.64×radius and2.82×diameter; reverse chord→source sample mean is0.039756. Even6stations have maximum0.013265, approximately one source radius, before cross-section faceting.

## Frame and surface check

A read-only hypothetical triangle calculation sampled source evaluated MINIMUM-twist frame directions0,4,8, with fixed source-frame interpolation at the arc midpoint. No phase search, mesh file, GLB, scene object, ribbon substitution or cap addition was made. Source-surface3468vertex/centroid samples and hypothetical-surface540fixed barycentric samples were compared with float64 point-to-triangle distance.

- Source→hypothetical surface maximum0.077402, sample mean0.035404.
- Hypothetical→source surface maximum0.068782, sample mean0.026383.
- Symmetric sampled surface maximum0.077402, approximately5.95source radii.
- Triangular cross-section circumradius remains0.013 but inradius is0.0065. Minimum full width is0.0195 versus circular diameter0.026:75% width. Radial support halves; full width does not halve. These are distinct quantities.

This is a geometric feasibility rejection, not an image-score verdict. No normal stream, curve, socket, eyeB ellipsoid, cheek, source blend or formal reference was edited. If a future implementation is authorized, inherit the original evaluated frame/tilt and source radial normals, record changed normals, retain uncapped topology, and audit full eye-unit front/back ordering. Do not silently flatten into a ribbon or claim all source shading/geometry is unchanged.

## Evidence and packaging

summary.json and surface-feasibility.json contain only aggregate measurements and rules. Full source control points, station coordinates and source evaluated geometry stay private and are excluded from bundle-allowlist.json. Measurement/inspection scripts are retained for reproducibility with authorized private source data. No codec was changed or tested here.
