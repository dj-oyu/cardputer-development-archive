# RGB memory design audit, no implementation

Decision: defer RGB-only segmentation. Preserve guard cap1024, depth largest request30720, old APIs and completed base. No source changes, builds, renders, device actions, publication or PR were performed. This audit read only completed fox-v3-depth-bands source and retained reports, not rejected owned-ray-context or unfinished paged-BVH work.

## Verified base

RGB565 is one64800-byte allocation. Depth is4×30720 +6720 =129600 bytes. Combined output payload194400, six allocations. Depth descriptor is80 bytes on64-bit host; bridge and core each freeze one descriptor before callbacks. Background named chain4080/4096, renderer5008/8192. Guard upper927 OFF/985 ON; ordinary bridge spans28, core external spans15, admission210. Current largest named overall request remains transport100808, then model arena81356; RGB splitting alone does not change that maximum.

## Separate RGB alternatives

Keep depth unchanged and add a new opt-in RGB descriptor; preserve contiguous and depth-bands public APIs. RGB boundaries must respect eight-row center strips, unless strip orchestration changes. Concrete splits:

- Two blocks:34560 (72 rows) +30240 (63 rows). Fixed pointer+length descriptor32 bytes; new descriptor bytes retained across bridge and core at least64 if both snapshots use that form, before alignment and other locals. One additional payload span.
- Three blocks:30720 +30720 +3360 (64+64+7 rows). Descriptor48 bytes, two snapshots96 bytes. Two additional payload spans.
- Five blocks matching depth:4×15360 +3360. Descriptor80 bytes, two snapshots160 bytes. Four additional payload spans.

These are payload fragmentation improvements only. Total194400 unchanged; allocator metadata increases with extra allocations. Pointer-only fixed-shape descriptors halve descriptor bytes, but even two extra16-byte snapshots nominally exceed the background16-byte headroom. Exact stack changes cannot be predicted without same-compiler measurements; source byte counts are not compiled stack claims.

Using unchanged live-span accounting A(N)=N+N(N−1)/2+6N and bridge pairs B(M)=M(M−1)/2, adding k RGB payload spans gives:

- k1: core232 (+22), bridge406 (+28), ON world pairs435 (+29). Total admission638 OFF/667 ON. Existing guard bound plus pair/admission increments alone977 OFF/1036 ON.
- k2: core255 (+45), bridge435 (+57), ON world pairs465 (+59). Total admission690 OFF/720 ON. Corresponding guard lower extrapolation1029 OFF/1089 ON.
- k4: core304 (+94), bridge496 (+118), ON world pairs528 (+122). Total admission800 OFF/832 ON. Corresponding guard lower extrapolation1139 OFF/1201 ON.

These guard extrapolations already fail ON before new descriptor/span predicates; they are not a newly verified complete guard bound. A separate RGB descriptor external span could increase them further. Keeping metadata embedded in one original control/combined descriptor avoids that extra descriptor span, but not the extra payload spans. Do not reduce charges or skip overlaps merely to fit the cap. A genuinely cheaper complete validation proof would be a separate non-minimal change.

## Shared storage alternatives

A fixed slab can contain contiguous depth rows followed by contiguous RGB rows. Derived disjoint offsets eliminate the need to register depth/RGB subranges as separate external allocations: validate the full slab against every other live span and prove the fixed internal layout. Each eight-row center strip stays within a slab; rendering addresses rows through depth/RGB helpers, preserving all arithmetic and ordering.

- Five32-row slabs:4×46080 +10080, payload194400. Five allocations instead of six; core spans14, admission189; bridge spans27, pairs351 OFF/378 ON. A five-pointer descriptor is40 bytes (or80 with lengths). However largest depth-containing allocation grows30720→46080. Rejected by parent for this regression.
- Six24-row slabs:5×34560 +21600, payload194400. Six allocations, same15 core/28 bridge span counts as base. Six-pointer fixed-shape descriptor48 bytes (or96 with lengths). Largest depth-containing allocation still grows30720→34560. Also fails the parent's non-regression objective; no implementation proposed.
- Nine16-row slabs:8×23040 +10080. Every block≤30720, but nine allocations increase payload span count by three and restore the guard-cap problem; pointer-only descriptor72 bytes.

Pointer-only descriptors require an explicitly fixed allocation contract and derived lengths, not trust in mutable caller lengths. Actual allocation extent cannot be proven from an arbitrary pointer; retain existing constructor-owned live-object contract. Combined allocation saves no output payload. Potential tiny metadata/control savings do not establish total RAM improvement; require a full new measured ledger.

## Safety and exactness requirements for any future variant

1. Freeze all output addresses before the first opaque overlap callback in both adapter and core. Retain original descriptor/control spans for alias protection while validating and rendering solely from captured addresses. Validate nulls, alignment, lengths/shape, pointer overflow, mutual overlaps and every resolver/scene-owned span before writes or report initialization. Test callback mutation of both RGB and depth descriptors, including real-wrapper entry.
2. Keep AA geometry, center/deferred-row order, shaders, profile, masks and numerical expressions unchanged. New row access must handle deferred row y−1, final short strips and AA target addressing exactly.
3. Adapt diagnostic HDR observer: current harness/hdr_observer.c maps every pixel by integer offset from a single contiguous64800-byte RGB base. Segmented output requires validated band-address-to-global-index mapping; retaining old observer would fail or misidentify pixels. Do not gather into a second full RGB buffer, which cancels the memory objective.
4. Write RGB/depth in canonical row order from private candidate bands; never stream partial render data to the visible committed output. Keep all adapter source/fingerprint/report finish checks, preflight checks, observer completeness, depth validity, successful file writes/closes, fixed40 exact comparison and independent final review before parent-controlled completion marker publication. Multiple output file writes are not atomic.
5. Failure cleanup frees each successful allocation exactly once and preserves the previously committed output. Runtime scratch may be modified on failure, as in base. Test each allocation failure, alias/rebinding negatives, final-verifier failures, short I/O, and exact fixed40 artifacts/reports.
6. Fresh named compiler stack and guard proof are mandatory before render gate. Existing16-byte background margin is a hard constraint, not a promise that a compact descriptor will fit.

## Sources

Completed base REPORT.md, GUARD_ACCOUNTING.json, MEMORY_LEDGER.json, NAMED_STACK.json; code/ksn_depth_bands_impl.inc and code/ksn_bounded_ring.h; harness/row_transport_bridge.c/.h, harness/depth_band_alloc.h, harness/native_render_row.c, harness/hdr_observer.c. Values above are retained-base evidence and explicit design arithmetic, not experimental results.
