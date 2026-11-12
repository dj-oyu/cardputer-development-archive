# Small actual-comparison feasibility (inspection only)

## Outcome

The existing `fox-v3-indexed-bvh-bounds/build-adapter/native-render` is not a generic renderer that can admit an arbitrary quantized model. A new q16/q20 geometry AYNM changes snapshot hashes and usually coverage/work predictions. The unchanged binary will reject it before producing a snapshot/render at `floor-input-binding`, then additional fixed tables would reject it even if that first issue were resolved. Existing approval is a particular completed 42-frame exact-equivalence experiment, not authorization or admission for new lossy inputs. Do not bypass the runner, alter hashes to impersonate old inputs, relax checks, or consume that old gate again.

No render, build, model write or baseline mutation was performed for this feasibility review. No denied context was read. Implementation choice is pending with the parent.

## Earliest recommended experiment

1. Build a fresh private geometry-only diagnostic bridge from AYFQ q16/q20 pre-×38 native-basis metres to copies of legacy AYNM local XYZ (decode, multiply by 38, round once to legacy F32). Preserve normals, RGB565, topology, identity, transforms and all other bytes. Trace source part/vertex mapping explicitly; do not infer it from coordinate matching. Include an unquantized bridge control, which must reproduce original AYNM coordinate bytes, otherwise pipeline mapping/conversion error is confounded with quantization. Record source compile.json, AYFQ, model, bridge and output hashes plus bounds/overflow and bytes changed.
2. Before any shaded render, run a separately scoped private model-evaluate/snapshot and geometry-only coverage diagnostic using unchanged model/codec functions, with its own bounded inputs/output and no transport/shading execution. Compare screen/depth/side/normal fields, triangle topology, center/quarter coverage/winners, target masks, and geometry/snapshot hashes. This is a new diagnostic, not a disabled guard inside the production harness. Such a build is a proposed next step, not performed or approved here.
3. Full one-view baseline/q16/q20 shaded image comparison comes only after new candidate-specific preflight facts and resource contracts are independently derived and reviewed. The renderer implementation can remain unchanged, but generated input headers and harness constants require a separately frozen build. If coverage/target counts change, current hard-coded per-view target constants also need an explicit reviewed candidate contract rather than substitution with old counts.

This bridge isolates geometry representation error with the floating renderer; it does NOT test integer transform/shading performance, AYFQ runtime loading, or all-fixed arithmetic. For static source positions this is much smaller and safer than implementing the complete new material/transport path at once.

## Why unchanged host binary cannot admit it

`harness/native_render_row.c`:
- Requires exact argc=19, a never-used private prefix/reservation, valid AYNM <=1 MiB, mandatory fixed environment (floor reflection on; ground=2, transport=2, outer/inner=16, pixel visibility/physical/linear light enabled).
- Whole geometry must remain 1,163 vertices/1,564 triangles before four ground vertices/two triangles; pixel/world views must agree bytewise.
- Snapshot hash must match `floor_input_lookup`; the row supplies exact shader and primary-ground-hit counts used for work initialization and final equality.
- `bg_select_input` matches exact camera F32, case, reverse flag and snapshot hash. Inputs include empty-slot/override counts and original authored floor/world parameters.
- AA preflight lookup matches snapshot hash and four quarter-sample hit counts. Ledger final-shade reservation must equal 76 × predicted hits, and control reservation must equal 4,160.
- Scene descriptor binds snapshot identity, target-mask fingerprint, per-view scene limits and expected target count (front 2,385 / oblique 2,391).
- Rendering ends with exact predicted/actual sample-hit and floor-work count checks; each output must be complete, and final HDR observer needs exactly 32,400 finite nonnegative RGB writes.
- Cannot simply switch transport/AA off as a lightweight probe: the harness explicitly requires these dependencies. Snapshot output is after the initial fixed snapshot/background admissions, so invoking it merely to obtain a candidate snapshot is not available.

## Required fresh provenance/admission package

Pin source compile.json, source material definitions, AYFQ sidecar, bridge, derived AYNM, camera/light/ground inputs, all source and generated-header hashes, compiler flags including `-ffp-contract=off` / `-fexcess-precision=standard`, binary hash, named stack/memory/work bounds, fresh output prefixes, expected frame count, abort/no-overwrite rules and finite-quality acceptance metrics frozen before execution.

Recompute from candidate geometry rather than copying baseline expected numbers:
- snapshot FNV plus SHA256 and topology/identity certificate;
- center/quarter coverage and winners, target mask and its fingerprint;
- AA category ledger and four sample-hit counts;
- floor shader and ground-hit counts / associated work reservations;
- camera/background runtime slots, empty slots, floor override bounds;
- scene category ledger and existing hard-cap compliance;
- any fingerprints/generations for candidate geometry, attributes and material representation.

Existing generators are source patterns, NOT generic drop-in tools for this candidate:
- `fox-v3-floor-direct-reflection-evaluation/actual-002/code/prepare_floor_v2.py` and `prepare_run.py` copy earlier pinned geometry/preflight identities and ledgers from another fixed study.
- `fox-v3-camera-background-evaluation/actual-002/code/generate_header.py` serializes `private/BACKGROUND_INPUTS.json` but does not independently derive counts.
- `.../generate_core_inputs.py` takes fixed `CORE-WORK-DESIGN.json` and previous target masks, so using it unchanged would retain old geometry assumptions.
- `fox-v3-indexed-bvh-bounds/harness/build_adapter.py` pins source dependencies and stacks, but build is explicitly not execution authorization.
- Current legitimate indexed-bounds runner is `comparison/run_fixed40.py`, not disabled ancestor `harness/run_actual.py`; its `PHYSICAL_EXECUTION_GATE.json` status `INDEXED_BOUNDS_FIXED42_APPROVED` pins original inputs and an exact raw comparator. The gate is explicitly limited to 42 frames and no retries/additional exceptions. A new study needs a separately reviewed plan/gate/comparator and appropriate approval; no existing checks should be weakened.

## Source-linear albedo is a separate, larger experiment

Current AYNM mesh descriptors and snapshot vertices retain RGB565 palette codes; `bounce_vertex` also contains a565/b565. The primary shader decodes these via float sRGB, while secondary transport uses the same legacy attribute representation. Writing linear RGB through RGB565 would destroy the proposed format and is not an integer-linear comparison. Proper source-linear albedo integration needs a new explicit attribute path for both primary interpolation and every bounce, along with immutable ownership/fingerprint/material generation changes and scratch/work accounting. Geometry-only q16/q20 is therefore the earlier full-render candidate. Source-linear albedo can first be assessed in a limited replay below.

## Legitimate saved-input replay available now

Verified these two snapshot files are byte-identical (SHA256 `006cfd92bda231a4ae7922f23aa125176f807967feaf444e2f3f8b19ef72cab0`):
- `fox-v3-floor-world-reflection/capture/on/native-front-baseline.snapshot`
- `fox-v3-indexed-bvh-bounds/actual-on-001/native-front-baseline.snapshot`

The corresponding saved `.samples.jsonl` SHA256 is `6ac953d6f49bb807555838bfc9aa35a49567f893bd4f3c0238f377a81ee629e3`. It is also pinned in the current actual command provenance. Read-only count: 9,540 quarter-sample rows = 2,385 targets × four offsets; 7,678 hits and 1,862 misses. Fields include pixel/sample index, recordOffset, node/face/sourceId/back/depth, interpolated P/Ns/rho, total linearRGB and direct/world/bounce/ground/floor contribution terms. It does NOT save barycentric coordinates or every center sample/ray.

A small read-only replay can reconstruct the exact face indices/vertices from the pinned snapshot, use sample offsets (−.25,−.25), (+.25,−.25), (−.25,+.25), (+.25,+.25), and reproduce the original `gouraud_make_edge`/`aa_edge_value` operation ordering from `ksn_boundary_aa_impl.inc`. Check replay P/Ns/rho against every saved hit before measuring alternatives. Use C's original sRGB decode/rho affine helper for bit-parity, not Python pow approximation. `recordOffset` is relative to snapshot packets after the 416-byte light header.

Then compare vertex-domain qnormal or source-linear UNORM15 rho using those unchanged weights and report component, angle, near-zero-normal, relative/absolute rho errors. Mapping source-linear rho to original part/vertex identities must be proved, not guessed by color. Or simpler, quantify post-interpolation saved rho to UNORM15, clearly labeling it a different stage from vertex quantization.

Limits: fixed winner/coverage/ray paths; does not recompute shadows, bounce frame/direction, secondary-hit materials, floor response, tone mapping or final image. A saved HDR × rho ratio can estimate only fixed-transport primary-albedo dependence if mathematically justified and denominators handled; it cannot validate a global source-material replacement or normal changes. Never present this replay as re-rendered quality equivalence. Source-normal quantization before transforms is also not equivalent to quantizing already interpolated Ns.
