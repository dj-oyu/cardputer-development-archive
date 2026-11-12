# AA workspace split option: design only

## Decision

Do not implement a naive split under the unchanged validation budget. Prefer the same-allocation lifetime overlay described below as the next isolated candidate. This audit changed no baseline code, compiled nothing, and ran no renders. It used the completed `fox-v3-segmented-model-arena` source and retained completed depth-band guard evidence. No device, public repository, PR, rejected owned-context, or paged-BVH work is part of this proposal.

## Verified layout and objective

`code/ksn_bounded_ring.h` and the static assertion in `ksn_bounded_ring_impl.inc` establish a 77,312-byte workspace on the pinned host ABI:

- HDR/identity scratch union: 46,080 bytes, from 1,920 pixels × 3 doubles. Identity keys occupy 9,920 bytes of the same storage only during binding.
- Winner/pending-row union: 13,440 bytes. Quarter winner arrays contain 3,840 record-offset bytes, 1,920 face bytes, and 7,680 float-depth bytes. Center pending row occupies only 5,760 bytes of this union.
- Remaining fields and padding: 17,792 bytes by subtraction, including center IDs, target mask, source/offset tables, record views and report. This is a remainder of the current struct, not a verified future metadata-struct sizeof.

A three-block split could therefore use 46,080 + 13,440 + approximately 17,792 bytes. It reduces the largest AA allocation to 46,080, but keeps essentially all payload and adds descriptor/owner/allocator overhead. The full render's next largest named allocation becomes RGB565 at 64,800 bytes, not 46,080. No overall RAM, speed, target ABI or device-fit improvement follows from this fragmentation improvement alone.

A simpler two-block split separates the 46,080-byte HDR/identity union from the 31,232-byte remainder. It achieves the same largest-AA-block result with one fewer allocation, span and pointer. Prefer this over three blocks if fragmentation is ever revisited after the validation blocker is resolved.

## New opt-in API contract if a split is later pursued

Keep the existing workspace type, bounded-ring API, depth-band API and generic AA ABI unchanged. Introduce distinct fixed-shape storage and render entrypoints; do not reinterpret the old type. Internal helper views can refer to the separated storage without copying any pixel arrays. Report, target-mask and source consumers such as `harness/aa_adapter.h` need an explicit report accessor/new wrapper; its existing `sizeof *w` output must not silently claim only the metadata block as total workspace usage.

Use exact block lengths and alignment requirements, or fixed lengths derived from typed block definitions. Snapshot the descriptor pointers and lengths at bridge entry before any overlap callback, and again at standalone core entry before its callbacks. Admit the original descriptor span as well as every backing allocation. Rendering and cleanup must not follow descriptor rebinding. All originally admitted backing spans remain owned and live until return; callbacks must not free, reallocate or concurrently mutate them. Allocation ownership for unwind must be retained independently from mutable public descriptors.

Validate complete ranges and overflow, all pairwise aliases, report/control/source/input/output aliases, transport and visibility owned storage, background resolver-owned storage, and the optional world-work span before writes or opaque callbacks where the existing contract requires it. A descriptor embedded in an already admitted control can avoid one *extra* descriptor span, but cannot eliminate its backing spans. A standalone descriptor needs its own admission coverage. No pointer-bearing helper view may escape the call.

Keep eight-row center strips, ten-row center-ID lifetime, delayed boundary-row completion, four quarter sample order, triangle/record order, float depth comparisons, HDR addition/division order, profile/query/shader/observer callback order, target classification and output publication unchanged. In particular, do not turn double HDR into float or reorder accumulation. Preserve the harness's existing fail-before-publishing behavior: scratch RGB/depth can be partly written on a render failure, but final raw outputs are only written after complete/verification checks in `native_render_row.c`. The core/bridge alone is not a transactional rollback API.

## Validation accounting blocker

The completed depth-band bridge has 28 ordinary spans, optional world-work comparisons against all 28, and the core has 15 live external spans plus six scene-owned spans. Current source computes:

- Core pair admission A(N) = 15 + N(N−1)/2 + 6N. The leading 15 is the six owned spans' pair count, not N.
- Bridge OFF pairs B(M) = M(M−1)/2; ON adds M world-work comparisons.
- Baseline: core210, bridge378 OFF/406 ON, combined588 OFF/616 ON.
- One extra backing span, with no additional independent descriptor: core231 (+21), bridge406 OFF/435 ON (+28/+29), combined637 OFF/666 ON (+49/+50).
- Two extra backing spans: core253 (+43), bridge435 OFF/465 ON (+57/+59), combined688 OFF/718 ON (+100/+102).
- A separately admitted new descriptor can increase these counts further.

The pair totals themselves remain below the 1,024 RH_ADMISSION cap. They are not the decisive cap problem: the retained bridge guard-dispatch upper is 927 OFF / 985 ON against a fixed 1,024 guard reservation. Only 39 ON dispatches remain. A naive added bridge span creates 29 new ON overlap comparisons *and* associated loop-condition dispatches, in addition to new range/descriptor/length checks and owned-scene callbacks. The old bound therefore cannot simply be reused.

A commonly suggested optimistic extrapolation adding only pair-accounting deltas to old guard numbers gives 976/1035 for one extra span and 1027/1087 for two; these already miss ON, but are **not a verified fresh source-dispatch bound**. Guard dispatches and RH_ADMISSION are different metrics and core admission deltas must not be presented as an exact bridge-dispatch calculation. A future implementation needs a fresh source-level bound, not these heuristic sums. In particular the earlier RGB audit's A(N)=N+C(N,2)+6N is not the literal current core formula beyond N=15.

Bridge validation and standalone core validation intentionally repeat substantial pair/owned-span checks. Removing only their charges hides real work and is prohibited. Removing actual duplicated checks would require a reviewed private validated-entry design, complete immutable/snapshotted control proof across callbacks, and an independently safe public standalone entry; it is a separate, materially broader change. No such proof is claimed here. Keep guard1,024, producer637,599, AA8,000,000 and other existing quotas unchanged. Extra descriptor copies and pointer dereferences are real CPU/stack work, even if shading counts stay exact. The background call-chain has only 16 bytes margin (4,080/4,096); source sizeof is not a stack measurement.

## Preferred same-allocation lifetime alternative

The 4,800-byte `center_id[10*240]` is only used by center rasterization and center-row finish. It is not used by quarter geometry, quarter shading or the final target scan; quarter work reads the completed target bitmask. The pending center HDR row is 5,760 bytes. Thus a named center-phase struct containing pending HDR plus center IDs fits in 10,560 bytes, below the existing 13,440-byte winner-phase union.

Overlay those two center-only fields together against the existing winner arrays. Their mutual simultaneous center-phase lifetime is retained, and no winner write starts until all center rows, including the final pending row, are finished. This eliminates the separate 4,800-byte center-ID allocation region without adding spans, changing eight-row scheduling, moving HDR arithmetic or altering callback order. Expected pinned-host workspace: 72,512 bytes, to be confirmed with sizeof/offsetof/alignment assertions and independent tests. It remains one allocation, so the largest named request falls by 4,800 bytes rather than to 64,800. This is a modest but cleaner first candidate than splitting.

Further isolated options, not needed for that first candidate:

- Source IDs are admitted in 0..91 and held in a 55×64 uint16 table. A uint8 table with 255 internal sentinel saves 3,520 raw bytes. Translate sentinel to the existing 65,535 public no-hit representation where needed, preserve all validity checks and report semantics, and never treat unchecked narrowing as validation. Alignment and combined struct size require measurement.
- Winner record offsets can be represented internally by an index0..53 with 255 no-hit, saving 1,920 raw bytes. Resolve that index to the original offset before current final-shade validation/observer events. Retain packet/node/offset validation and exact traversal/tie order. This is more invasive than the lifetime overlay and changes representation/access work, so give it separate accounting and tests.

Neither proposal authorizes implementation. Storage accesses and memset byte counts must be reported honestly rather than forcing all counters to appear unchanged.

## Why not reduce band height

Four-row bands would shrink HDR to23,040 and raw winners to6,720 (pending row still5,760). But 135 rows then require34 center bands instead of17 and136 quarter geometry passes instead of68. Record/face setup and guard work increase; shader/query callback interleaving across rows/samples changes even if individual mathematical pixel results happen to agree. Pending-row copies become33 instead of16: RH_COPY becomes23,760 rather than11,520. Scheduling calls become204 rather than102, exceeding current RH_SCHEDULE136. It therefore is not an arithmetic/order/budget-preserving substitute for a storage split. No cap increases or band reduction are proposed.

## Required gate for any later implementation

Independent layout and full lifetime review; exact baseline source pins; legacy API builds/tests; new all-span alias, short-length, null, misalignment, wrapping-range and allocation-unwind tests; callback descriptor rebinding tests; phase-boundary poison/canary tests proving center IDs are dead before winner use; negative failure/publication tests; report and sentinel compatibility; same-compiler optimized and sanitizer synthetic equality of outputs, callback traces and physical counters; fresh named stack and guard accounting. Any actual render requires a separately authorized physical gate after these prerequisites. This design is not that gate.
