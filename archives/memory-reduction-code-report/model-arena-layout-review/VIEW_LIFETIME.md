# Model arena view/lifetime audit (read-only)

## Verdict

Promising only as an explicit opt-in segmented initializer with a fully specified span/lifetime contract. Not safe as a two-accessor patch, and not an implementation-ready API. Keep the old contiguous initializer and its behavior. A strict requirement to preserve the public instance struct ABI makes this substantially more invasive: the current struct exposes `arena` and `arena_bytes` and has no backend descriptor (H:40–50). Do not overload those fields with a pointer table while existing guards treat them as a contiguous span. No implementation, rendering, device, SDK, public-repository or source-model changes performed. Rejected owned-context and unfinished paged-BVH trees were not consulted.

## Evidence scope and pins

R = `fox-v3-indexed-transport-input/`; M = `R/private-build/product/main/ayatsuri/ayatsuri_model.c`; H = sibling `.h`; N = `R/harness/native_render_row.c`; K = `R/private-build/product/main/ui/kasane/ksn_mesh_depth.c`; C = `R/private-build/product/main/ayatsuri/compact_opaque.c`.
Actual product source selected by `R/harness/build_adapter.py:10–12` and `R/build-product/BUILD.json`, not the stale `code/build_core.sh`. All 68 dependency file hashes match that product build manifest. Searched every C/H/INC dependency for instance/accessor/arena uses. Only N calls model instance APIs outside M/H in this build; this is not a claim about unbuilt firmware or tests.

SHA256:
- M: `5d65fc53ff2f1175e8a44829c4acf07a23e3601f773486454f167dcbd0c194f0`
- H: `de593d84b5591804aa5252dc05ba55d6beb14b86f88e499db89f0961524f7b27`
- N: `5768f03a31f366f91fc0d14b2941663a8659860c33aa0cc3af4ee1205fd065ab`
- K: `0e8342500b1a1b3c623dad05dea04147ffeeb05e04449f6c2922835690223567`
- C: `daa6e537d00ce085ca431fd749badc93ff8f91eee9d32aae9e2c5020321124cf`
- product BUILD.json: `4f99745b176ffb9dabd16912fac985627011210177d4e857014d048a061fd42f`
- product ayatsuri_model.su: `1ed4bc5e1b7fff84e8788d5b94e434f9ab721e648382cc2c84aa0bff7fde4507`

## Complete accessor/use inventory in built caller

- N:70 size query/allocation; :93 init, linear-light setter, owned disk-scene setter, evaluate; :95 reads public mutation_epoch.
- N:99 next() gathers IDs/kinds only, does not retain packet.storage or packet.lighting.
- N:107–108 world_mesh_view counts all original-order mesh geometry.
- N:118–127 world_mesh_view plus pixel_mesh_view fill owned xyz, triangle, attribute and indexed material arrays; verifies identical world values. Direct cold-model reads at :107/:118 obtain node kind. All source geometry/materials needed by builders are owned after :137.
- N:139 BVH build; :145 transport build; source arrays poisoned/freed :139/:146.
- N:151–159 snapshot append in requested forward/reverse order: pixel view or sided/plain view. Patch copied to local object; depth remains borrowed, sided back colors remain borrowed, side bits copied. Reversal changes only local patch/bits. Synchronous append consumes the views before next iteration, without intervening model mutation.
- N:180 dispose, poison/free arena and cold data. No later model access exists in built dependencies. Snapshot and builders outlive model by owning their data.

## Ownership and invalidation

- states()/work() at M:211–212 centralize addressing. All internal consumers use these, including init, targets, read_pose, ellipse/blend/mesh generation, parent transform evaluation, next and four mesh views. Parent work accesses are independent by node, not adjacent-slot traversal (M:584–588). Per-node packet and scratch offsets remain contiguous within the node slot (M:28–41,459,627–645,662–664).
- Instance/model/cold span and caller arena stay alive through dispose (H:135–136). Owner pointer identity plus nonzero init generation is checked by enter; busy protects synchronous reentry, not concurrent threads (M:213–218,235–264). Generation is caller-supplied; dispose does not increment it or free memory. Reuse with the same owner/generation is not stale-handle protection. Copying the public instance does not create independent storage or a shared lock.
- Mutation epoch saturates via add_count (M:20), and changes on actual targets, linear-light or disk-scene changes only (M:223,232,294). No-op changes preserve evaluation. Disk scene is copied, not borrowed (M:228–232).
- Failed evaluate invalidates publication; successful changed camera/light reevaluation rewrites slots without incrementing mutation epoch (M:562–594). Same camera/light returns early. Epoch therefore cannot validate an old borrowed view across evaluate. Follow conservative documented copy-before-evaluate/mutation/dispose rule even when a particular no-op preserves bytes.
- next returns borrowed slot storage AND instance lighting (M:610). Plain mesh view borrows patch/depth; sided view additionally borrows back palette and face bits (H:71–95; M:627–645).
- pixel_mesh_view owns vertices/back_faces but borrows patch/depth. It checks current epoch only at extraction, computes local result, then publishes once (H:97–110; M:650–695).
- world_mesh_view is entirely owned, including world coordinates and original cold indices; survives mutation/dispose (H:115–129; M:699–726).

## All contiguous-arena overlap assumptions and atomicity

M overlap helper :21–24 compares address distances, does not separately reject pointer+length overflow. Existing arena guards cover used `need` bytes, not excess supplied capacity.
- init :238–241: used arena against cold bytes, model control, output control; output against model/cold. Full validation precedes any zeroing. :242–259 zeroes arena, initializes all nodes, publishes one local result. No fallible step after zeroing under valid immutable model assumptions.
- targets :270–272: each of dirty, pose, color, opacity full arrays against whole arena. :274–281 validates entire selected batch before :283–294 writes. Does not currently comprehensively guard target descriptor/arrays against instance control; do not claim stronger alias safety than present.
- node_kind :300–302; read_pose :308–310; stats :316–318: output against control, model, arena, cold.
- next :600–605: cursor/output pairwise, each against control, model, arena, cold.
- mesh_view :621–623; sided :637–639; pixel :655–657; world :704–706: output against control, model, arena, cold.
- setters disk_scene/linear_light and evaluate have no full-arena span guard. Disk setter stages copy; evaluate directly reads caller camera/light and partially writes work/control on failure. Evaluation is publication-invalidating, NOT rollback-atomic. Do not accidentally promise failure leaves all arena bytes unchanged.
- Read accessors publish output only after checks. Pixel/world use local fixed-size result then single assignment. enter/leave temporarily toggle busy even on failure, so unchanged-instance means observable final logical state, not no transient write.
- Snapshot: K:68–71 validates/copies scene into owned snapshot header; K:75–82 validates source/control/storage spans, invokes codec then updates work. C:115–142 validates pairwise full source/destination spans and capacity before first destination write :143; :145–152 copies fields, indices/bits, then commits size/count. Snapshot has no model pointer. Legacy plain/sided paths K:31–58 also copy values into records but do not have the same comprehensive alias guards as pixel path. Segmentation must not weaken these existing admission layers.

## Narrow prospective design and costs (not implemented)

1. Keep legacy bytes/init path exactly contiguous. Add opt-in state span plus one full work span per node, preserving all per-node offsets, arithmetic, source order, packet views and caller synchronous-copy contract. No slot recycling: parents and later packet consumers require storage to remain valid.
2. Before any write, validate count, capacities, alignment, range overflow, pairwise segment disjointness, model/cold/control/descriptor separation, and all metadata needed to enumerate spans. Copy validated descriptors to dedicated owned-lifetime storage or require explicitly immutable caller-owned descriptors through dispose. Prefer a copied table to avoid an extra borrowed mutable descriptor hazard. Protect descriptor storage in every input/output alias guard too.
3. Centralize `states`, `work`, and `overlaps_storage` as backend-aware helpers. The last must visit every used span, not min/max envelope or first segment only. Decide and document capacity versus used-byte coverage consistent with old behavior. Stage complete validation, then initialize, then publish; allocation failure must unwind without publishing or mutating old instance. Dispose invalidates references and clears descriptor access without taking ownership of caller allocations.
4. Preserve lifetime semantics rather than introducing an evaluation token opportunistically. Any new token/stronger concurrent ownership model is separate scope. Tests needed before implementation acceptance: all accessor aliases in every segment and metadata; overlapping/misaligned/undersized/wrapping spans; failure-before-write; no-op mutation, changed mutation, camera reevaluate, failed evaluate, dispose/reinit; two instances and copied-control hazards; byte-identical old/new snapshot and owned geometry without actual render until authorized.

Host baseline 81,356 = states 1,320 + work 80,036 (group84 + mesh79,952), separate from cold47,708 and instance-control584. Segmentation saves no payload bytes. A hypothetical 55-entry `(pointer,size_t)` table alone costs 880 host bytes; additional mode/control metadata, allocator headers and alignment slack also count. Each node allocation could be at most 1,648 here; if states+table are coallocated that allocation is at least 2,200 before other metadata, not 1,648. Separate table/state gives payload largest block 1,648, with 57 payload allocations (state, table,55 work), not an overall-process allocation bound. Cold47,708 and other allocations remain. Merely splitting states from all work leaves an 80,036 work allocation and gives little benefit.

Do not move descriptors or node work into a large stack array. Existing host compiler frames from product `.su`: init688, evaluate1152, mesh_packet1520 bounded, pixel_mesh_view2384, world_mesh_view1264. Instance584 is not whole call-stack usage; caller has other large locals (N:96 payload65536). New descriptor scanning can use constant-size temporaries, but stack deltas and target32 ABI require an actual allowed build/measurement. No device-fit claim.

Independent smaller lifetime improvement remains possible: append owned snapshot before builders, extract all world/material inputs, then dispose/poison/free model before BVH/transport/background build. Current order cannot free early at :137 because :154–156 still need model. Reorder would remove model overlap from later construction phases, not reduce its 81,356 maximum allocation or final render peak, and source extraction still overlaps owned arrays. It is an alternative requiring separate validation, not implemented here.

## Follow-up: parent's narrower fixed-pointer-table proposal

This is preferable to the generic pointer+size descriptor sketch above. Keep all 55 stable node slots; make `arena` point to states plus a copied 55-pointer table; append a segmented boolean to control; derive used slot lengths from immutable model through node_slot_bytes. Only new opt-in initialization uses this path; old initialization zero-initializes the flag and retains original layout and guards. No new owned-context or callback is needed, and existing view structs can remain identical.

A host-only sizeof/offsetof probe against these exact headers (not a renderer invocation) reports instance584, alive576, busy577, evaluated578, linear_light579, physical_light580, sizeof(bool)=1. A new boolean immediately following physical_light would fit at581 within existing 584-byte host size. This does NOT establish target32 layout or cross-version binary compatibility: old independently compiled callers may have indeterminate padding at581, and old assumptions about the meaning of arena/arena_bytes do not apply to segmented instances. Recompile consumers or define an explicit version/opt-in boundary.

For this pointer-only layout, aligned states1320 + pointer table440 = metadata1760; all node work remains80036; payload total81796, exactly +440 host bytes before allocator overhead. Largest model allocation becomes1760, not1648. There are56 allocations if every work slot and metadata are separate. Deriving sizes avoids880-byte pointer/size table cost. Earlier generic table numbers above are illustrative alternatives, not this proposal's ledger.

Required safety details: validate descriptor count and every pointer/size before writing; reject descriptor-input overlap with metadata, all work slots and output control; reject all writable spans pairwise and against cold/model/control; validate address arithmetic and metadata size; copy table safely before ending the descriptor-input lifetime; zero states/work without erasing the table; publish only after the infallible commit phase. `storage_overlap` must protect full used metadata1760 plus every derived used node span, including slots belonging to hidden/group nodes. Cannot collapse spans to a min/max range or protect only currently visible nodes. No slot allocation ownership transfers to instance; dispose clears backend access, caller frees its allocations. Targets, queries and all four views must retain the original logical invalidation semantics, including failed-evaluation invalidation and saturation behavior. Helper loops add O(nodes) per guard; initialization pairwise validation O(nodes²), bounded by MAX_NODES256. This is added admission cost, not a memory saving. No model-wide scratch array is necessary.

Assessment: no intrinsic borrow-lifetime defect in this stable-slot design; risk resides in complete alias coverage, init atomicity, metadata lifetime/versioning, and compatibility testing. Worth a narrowly authorized prototype; not safe to implement by changing work() alone. Current report remains review-only.
