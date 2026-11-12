# Independent cached renderer integration review

Pre-execution review. Final integration gate is REVIEW.json; fixed40 remains pending until parent-approved execution and retained-output audit.

## Design and correctness

The new RowCachedRenderBands descriptor replaces the existing descriptor span and appends exactly one cache span. It borrows a caller-owned 3224-byte cache only for synchronous rendering. The source must be the single compiled static const profile, checked by pointer and exact length after disjointness admission; an equivalent externally allocated blob is rejected. Init/bind is checked, same-pointer binding resets state, and clear precedes release. Cache fields remain internal state and concurrent mutation or forged pointers are not supported. There is no mutable global or TLS profile binding.

The new private cache-specific core takes the cache in the former callback pointer position. Its contract requires the cached adapter's full prior admission. It is not an independently safe general renderer API. The old generic APIs are retained, with stateless compressed gather for their legacy display callback. The exact cached core does not use that legacy gather path.

Independent mechanical comparison establishes that encode, row finishing and depth-band orchestration preserve baseline arithmetic, schedule, ordering, geometry, shading, budgets and output packing except the explicit cached profile invocation. Existing core files and cache implementation are byte-identical to their reviewed frozen sources. New cache-backed adapter admission includes every prior live span, all five depth bands, transport/visibility/background owner checks, and floor-world overlap. The compressed blob replaces the raw LUT span; no extra blob span or wrapper is hidden.

## Independent tests

Normal and full-dependency ASan+UBSan admission tests pass 91 additional cached alias/lifetime cases and 94 retained adapter cases without physical shader calls. They exercise all 29 candidate alias targets at beginning/end/preceding overlaps, cache NULL/alignment/overflow/unbound rejection, static-only binding, clear-before-free and no cache mutation on warm admission. Rejected render admission leaves cache, report, pixels and depth unchanged. Leak checking is disabled for environment compatibility; no leak-safety claim is inferred.

Author synthetic raster tests separately compare 80 geometry/order/background cases with raw-u16 baseline and inject first/middle/final profile decoder failures using a verified linker wrapper. Reviewer checks source and recorded wrapper link flags. Partial private pixels may change on failure, but a false result never authorizes publication. Cache output itself is transactional. Overall frame acceptance additionally requires final native checks and fixed40 runner completion; a sidecar alone is not completion.

## Work, lifetime and stack

Adapter overlap pairs become 406 OFF and 435 ON, adding 28/29. Core admission remains 210, so actual producer admission becomes 616/645, below unchanged 1024. The separately stated conservative prerequisite bound 1014 is not observed usage. Profile lookup CPU work is separately bounded and not disguised as unchanged ray/shader work. Each successful frame performs 32400 profile calls and 129600 selected vertex lookups; hit/miss counts are measured, not assumed.

Compiled named stack chains include cached encode, profile evaluator, fetch and header/decoder-inlined work. Profile processing is sequential with background resolution, so its chain is not added to the background resolver chain. Background remains 4080/4096 with only 16 bytes margin; renderer peak remains 5008/8192. Center/quarter profile chains become 1736/1544. Main stack is accounted separately. These are host compiler named frames, excluding libc/libm/ABI runtime, not device stack proof.

## Linkage and resource proof

The independent ELF audit verifies one read-only 445248-byte encoded payload with SHA256 ddb92d760c9359008a2c1a8bb179936b196c0e37d1b7f9c2f12d4c71fafcae5e. The raw agx_lut symbol and full 1647750-byte raw payload are absent. It verifies direct main → cached adapter → cached core → cached encode → agx_cache_profile_eval → agx_cache_fetch4 linkage in both native builds. Runtime counters and fixed40 results remain necessary evidence that actual frames use this path.

Payload-only RO reduction is 1202502 bytes; full ELF section deltas also include extra code and constants. Named requested live render cost increases by 3224 cache bytes. One additional allocator header/fragmentation and runtime/library costs are excluded. No target RAM/flash/stack fit is asserted.

## Fixed40 and timing boundaries

Independent runner review and 19 comparator tests pass. Comparator accepts only seven predeclared timing fields and exact arm-specific admission changes in the seven legacy reports. It requires 200 byte-exact raw comparisons, 280 old-report comparisons, 80 forward/reverse comparisons, exact cache sidecar schema/hashes, unchanged runtime input pins, and completion manifests. No duplicate physical-heavy renderer execution is performed by this reviewer.

Native frame timing excludes cache allocation/bind/cleanup. Whole-process wall and CPU include setup, diagnostics and exports. Historical comparison is descriptive and not a controlled same-host speedup result; target performance remains unmeasured. Raw outputs, model/profile fixtures and linked binaries remain private and are not delivery attachments.
