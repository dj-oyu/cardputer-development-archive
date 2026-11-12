# New geometry-isolated three-frame canary

Status: DRAFT FOR PARENT REVIEW. No full render executed or admitted by this draft.

## Frozen scope

Three sequential full-shaded frames only: front view, authored baseline light/material case, forward order, floor-world ON, current 16/16 transport quadrature, 240×135. Variants in order: original legacy AYNM control, q16-metre AYFQ geometry bridged to legacy F32, q20-metre AYFQ geometry bridged to legacy F32. No new albedo/normal representation, integer shader, FMA, alternate quadrature, background, or tone map changes. Old source trees and gates remain immutable. No public/device actions.

Each variant uses a fresh exact-input metadata row and private output prefix. Source positions are quantized in native-basis metres BEFORE ×38; bridge applies ×38 and legacy F32 rounding. Unquantized bridge control must reproduce legacy coordinate bytes. Geometry topology, material codes, normals, pose and source IDs must remain unchanged. This tests geometry representation through unchanged shaders, not all-fixed rendering or PIE speed.

## Schedule and review stops

1. Finish independent geometry-only snapshot/coverage preflight, including original control parity with saved current snapshot/depth/target mask/quarter-sample identities.
2. Build and run bounded metadata-only helpers under the separately frozen metadata contract. Original nearest-query engine plus verbatim normal normalization/direction helpers compute exact primary ground-hit counts for all shader invocations, including intermediate center overdraw. Pure original camera/floor intersection helpers compute background composition classification. No disk/lighting/transport shader is invoked. This pass DOES run up to 16 nearest rays per shader event; it is not merely a static header calculation.
3. Freeze model/AYFQ/source/bridge/preflight outputs, exact shader event stream, geometry arrays, authored camera/ground/light inputs, generated headers, category ledgers, metadata outputs, build dependencies, stack/memory bounds, canary runner, comparator and report contract. Parent independently reviews exact hashes and grants GO for three specific fresh prefixes. This draft is not that GO.
4. Run original control once. Validate all original raw output against current actual-on-001 front-baseline; non-timing semantic fields exact apart from explicitly predeclared provenance/metadata-binding differences. Stop for independent parent review on any difference. No candidate run if original control fails.
5. Run q16 once, validate completeness/caps/provenance and compute candidate differences. Stop on operational failure, unexpected source change, incomplete output, or a predeclared correctness invariant failure. Preserve partial outputs, do not retry.
6. Run q20 once under same conditions. Report each result promptly and summarize all three. Parent may choose a review checkpoint between candidate frames. Never silently launch more views/orders/arms/retries.

## Metadata-only hard bounds (not full frame quotas)

One original-order 1,167-vertex/1,566-triangle world scene per variant, ground last; indices and coordinate bytes must be exported by unchanged current model world-view evaluation. At most 17,241 exact shader events. 16 primary nearest queries/event gives at most 275,856 rays/variant. Explicit cumulative diagnostic ceilings: 275,856 rays, 100,000,000 node visits, 50,000,000 triangle tests; failure returns consumed counters and no complete count. Original vis_scene limits: 2,048 triangles, 4,095 nodes, 524,288 persistent bytes. At most 39,573 pure background slots, each two floor-triangle tests; no visibility or lighting within background classification.

These bounds are below existing transport runtime caps and never authorize expanding them. Runtime quotas remain direct (1M/100M/50M), transport (20M/800M/300M), background (2M/200M/100M), original floor maximum 17,241 shaders/71,667 hits, floor work 875,970,912, background 39,573 slots/1,540,298,112 work, AA 8M, scene core 1,680,000, producer plus depth 637,599, and original memory capacities. Any changed candidate exceeding these bounds is inadmissible in this experiment. Do not fabricate exact counts or reuse baseline counts to pass.

## Comparison contract

Original control raw snapshot, depth, mask, HDR and RGB565 must be byte-exact against the saved original front-baseline. Timing fields are descriptive only. Generated metadata/provenance additions must have names and expected values declared before execution; they cannot conceal semantic mismatches.

Candidates are not compared to an exact-baseline-output requirement. They require valid geometry/identity, finite nonnegative HDR, full frame completion, fixed counts from independent preflight, no guard/budget failure, and exact own-input provenance. Report changes in coverage/target masks/primitive winners/depth, P, normals, every available shadow/nearest-hit classification, HDR absolute and relative error/max/RMS/quantiles, changed RGB565 pixels/channel steps and boundary/character/floor/background subsets. Shadow differences need query-aligned tracing or equivalent independent replay; aggregate ray totals alone must not be advertised as shadow parity. Initial canary measures differences rather than silently choosing an acceptable visual threshold after seeing outputs. No performance claim from three frames.

## Failure/no-retry rules

Abort before launch on hash mismatch, stale/unreviewed metadata, unknown variant, malformed/fallback input, cap violation, pre-existing output/reservation, incomplete previous stage, unexpected environment, or unlisted changed source. On nonzero exit, stderr failure, partial report, runtime cap failure, unanticipated report-field difference, or source mutation preserve all files and report exact blocker. No overwritten result, enlarged budget, omitted guard, direct binary invocation around the runner, automatic retry, or old gate reuse. A new reviewed amendment is needed for a materially different attempt.

## Remaining executable blockers

Pending geometry preflight outputs/schema; ray/background metadata helpers built but no ray run yet; authentic per-variant ledgers and generated header rows; explicit harness adaptation replacing fixed20 lookup cardinality / expected target constants with candidate-pinned metadata without weakening validation; complete dependency freeze; named stack/memory delta; comparator and bounded fresh-prefix runner; parent independent review/GO. Existing shader/visibility/AA/tonemap implementations remain unchanged.
