# Source-contact hard-lock reduction: rejected

**One candidate built, no candidate admitted.** Local source-contact protection removes observed robust containment reversals, but does not preserve source-visible Smile shape in fixed multi-view samples. Strict conditions remain unchanged. No images, selected pixels, renders, public operations, uploads, or devices were used.

## Construction and resource outcome

Candidate: protected-contact.glb; SHA256 7a8c155feba52573600de36ce6bf3632f065b11533fa339804898ef1fa3f880e. Total 2628 triangles versus baseline1166 (+1462).

| Object | Source triangles | Protected faces | Locked vertices | Final triangles / target | Export vertices / unique positions |
|---|---:|---:|---:|---:|---:|
| Muzzle pad -1 | 1840 | 176 | 119 | 256 / 256 | 190 / 130 |
| Muzzle pad 1 | 1840 | 183 | 123 | 256 / 256 | 191 / 130 |
| Smile -1 | 1728 | 397 | 243 | 510 / 160 | 349 / 260 |
| Smile 1 | 1728 | 395 | 241 | 496 / 160 | 339 / 252 |

Pad targets reached; Smile targets were impossible under the locked region and legal-edge conditions, so reduction stopped at actual510/496, without changing the target or protection. There are297 extra exported vertices from normal splits at protected-original/unprotected-recomputed normal boundaries. Old ladder GLBs had no such splits (prior vertex-splits.json).

Source triangle maximum-edge-length distance rule plus one adjacency ring is source-tessellation-dependent, not a universal contact or occlusion guarantee. Endpoint collapses retain source vertex positions, exclude locked endpoints, enforce local manifold link and non-reversed surviving faces. Protected source triangle IDs, corner order, coordinates and original corner normals are exactly preserved. Unprotected normals are recomputed area-weighted; they are not claimed source-exact. Every changed unprotected face incident to a locked vertex is listed in build-report.json.

## Unchanged strict geometric gate

| Side | Robust containment reversals | Unresolved projection ties | Development ray failures | Previously seen validation failures | New validation failures |
|---|---:|---:|---:|---:|---:|
| -1 | 0 | 11 | 6154 | 2933 | 5709 |
| 1 | 0 | 10 | 7622 | 4072 | 7018 |

Both pads pass exact-position-welded closedness, opposite-edge winding and positive volume. These local/topological checks do not prove absence of nonlocal self-intersection. The finite containment gate has zero robust reversals but21 unresolved projection ties; none is waived. Development and both validation sweeps fail independently.

Development mismatch detail (left/right): source Smile→miss4447/5311, Smile→pad1591/1986, pad→Smile92/192. Both nonprotected Smile shape loss and changed occlusion occur; the result cannot be attributed exclusively to pad geometry without a separate ablation. Per-ray-family counts are retained so fixed-source comparisons do not depend on candidate sample growth.

The new validation view file was frozen before execution: azimuth7.5+30k, elevations[-22.5,7.5,37.5], SHA2566f4edc0c9fdde39364f7eef8c4a97fcef60cd26ea3ea471e75ad416e4a8b69e2. These views are now consumed validation and must not be called unused in future work. Prior heldout angles are explicitly already-seen validation. No validation reranking or further candidate was attempted.

## Preservation, implementation and stopping condition

All old baseline binary bytes remain unchanged as the candidate prefix. All non-target mesh/accessor/normal data, material assignments/sidedness and node values remain unchanged. Four primitive streams are appended; source .blend, baseline and previous ladder GLBs remain unchanged. build-report.json records guard assertions, actual costs and all normal-split counts. Per-object collapse logs retain removed source face IDs and protected source→export face mapping.

Source blend SHA2569254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806. Baseline SHA2569c6ea7e1f6ee83101a3249de6c482cb8bca1e3943d9448c7701eafb173f6c78c.

Code: prepare.py (source-only region), reduce.py (hard-lock construction and append-only export), audit.py (unchanged strict oracle plus extra validation views), ray_families.py, summarize.py. CONTRACT.md and protection.json retain predeclared method and initial protected coverage. Existing audited oracle fixtures remain applicable. Independent artifact review confirms protected faces/attributes, endpoint exclusions and all final gate counts (independent-protection.json, independent-final-gates.json).

The authorized one-method/one-candidate experiment is complete and rejected. No actual-C/rendering admission is claimed. A separate proposed check of newly hidden eyes/brows/nose/ears would compare fixed old-baseline part samples against this candidate, as a regression check rather than original-source fidelity; it was not executed because the candidate fails the primary gate and the parent reports a resource-quota failure. No other-face render was performed.

## Read-only original topology findings

Both muzzle pads are MESH objects with no modifiers and no custom normals: 922 vertices, 1880 edges, 960 smooth polygons (880 quads plus80 pole triangles). There are23 local-z rings of40 vertices each plus two poles; valences are920 vertices of degree4 and two of degree40. This is UV-sphere-like regular topology, not proof of an exact analytic ellipsoid.

Both Smiles are 3D CURVE objects with no modifiers: one open Bezier spline, four AUTO-handled control points, resolutionU24, bevelDepth0.009, bevelResolution4, full fill, no end caps. All four control radii are1 and tilts0. Original control points/handles and matrices are retained in source-topology.json. The uncapped source explains why a closedness requirement must apply to pads, not be imposed retrospectively on Smile tubes.

A possible future general method, not implemented here, is topology-aware resampling: adaptively sample the original Bezier centerline and tube cross-section under a geometric error bound, and resample the original pad rings with contact anchors. This would preserve the entire Smile tube rather than only a contact patch; pair containment, full visible-shape ray gates and resource quotas would still need independent admission.
