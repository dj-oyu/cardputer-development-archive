# Independent code, ownership and stack review

Source/build/runner review passes; synthetic negatives and final source freeze remain prerequisites to a physical gate. No renderer was invoked by this reviewer.

Model C SHA256: 9818275174ea379ae4cc70ecbf9c43d8f92596edb222aefe3d3aaf6786066b1b
Model H SHA256: 47bf1cd232c72a659e10c1d4efdc8f0f6c3f04906a882a7197cc54a90fee4f75

The old contiguous initializer body, disposal, evaluate, both configuration setters, mesh generation and slot-size function are unchanged. Old init aggregate initialization sets segmented=false. All 13 previous arena-overlap expressions now use storage_overlap, covering used metadata and every model-derived node slot. Legacy guards remain used-byte based. Slot address selection is centralized; all states stay in metadata. No geometry/arithmetic/budget/profile modifications occur.

Segmented init validates descriptor count/range/alignment before reading entries. Model must be an unchanged successful open result, as documented; it does not promise safe forged or arbitrary invalid model pointers. Metadata, output, descriptors, model and cold numeric ranges are checked. Every writable span is disjoint from all other writable spans and model/cold/output/descriptors before any memset/copy. Copying descriptors into metadata does not transfer allocation ownership or make subsequent caller corruption safe. The public contract forbids such mutation. Source descriptors can then expire. No fallible step follows validation. Output publishes one local result after all initialization.

Existing target descriptor alias limits, evaluation non-rollback behavior, owner-identity semantics and mutation-only epochs are not upgraded or falsely strengthened. Old no-op/camera-light/borrow behavior remains. All per-node slots persist, so reading another node is not an implicit invalidation event. Disposal clears access without freeing caller-owned storage.

The host owner helper allocates an independent 912-byte table and preserves allocation handles after instance disposal. Successful path has 57 heap allocations: owner, metadata,55 slots. Partial allocation failures unwind initialized handles. No node-sized stack table was added. Caller still retains all model spans until final extraction and frees them before rendering.

Product and observer final compiled dependency checks:69 and71 entries respectively, no stale hashes. Only changed compiled files are model C/H, native caller and owner helper. Every named renderer call chain equals baseline exactly. Product main83792 (+32), observer main83776 (+16), renderer5008, background4080 with16 spare under4096. New init frame736, guard64 plus node_slot8; mesh1520/pixel2384/world1264 unchanged. Host measurements do not establish target32 ABI or device fit.

Ledger arithmetic independently checked: metadata1760 + slots80036 =81796 payload; +owner912 =82708 named model heap. Construction delta1352 and product main delta32 produce conservative visibility442996, transport385236, background351064. Render peak496184 is32 higher than prior496152. Largest model allocation1760; largest named global allocation77312 remains AA workspace. Allocator headers/fragmentation and libc/libm stacks remain excluded, not savings.

Guard accounting independently checked: initial7 +5N +N(N-1)/2 interval tests gives1767 at55 and33927 at256. Guard at mostN+1 spans; targets4(N+1). General blend-region length calculation adds region scans; documented O(N*R) guard and O(N²*R) initializer avoid a false universal linear/quadratic timing claim. Actual fox group/mesh does not scan blend regions.

Runner review is separately pinned in RUNNER_REVIEW.json. It is not render authorization. Parent must validate final synthetic evidence and freeze before creating the reviewed physical gate.
