# Owned host-only visibility

This module is a private host diagnostic; it is not a product-memory-fit claim.
The caller supplies world-space geometry only. No model or reference image enters
this module. World space and fixed `1e-5` segment endpoint epsilon are Blender-world
units. Offset the origin in the adapter if desired, before calling the segment API.
No source-face exclusion is performed. Occluders are opaque and two-sided.

## Integration contract

Initialize scene pointers and bindings to zero. Build into a scene slot, bind a
render binding, then query with the same geometry/pose/light generation triple.
Bindings retain scenes. Replacing a scene slot releases that slot's old ownership,
not any binding's ownership. Clear bindings before discarding them. Repeated clear
is safe; raw scene release is a normal refcount operation, not double-release safe.
Do not overwrite an initialized binding with zero before clearing it. No concurrent
mutation or refcount access is supported. Coordinate these operations in the host.

Tokens are caller monotonic counters, **not self-verifying hashes**. The adapter
must associate them with the actual submitted snapshot and light description and
increment the corresponding token on changes. A matching stale triple alone cannot
detect a stale caller. Replacement rejects regressed or completely unchanged tokens.
Mismatch does not consume a query budget. On every failure output is untouched.
Budget exhaustion is an error, never a visible/unoccluded result. The frame adapter
must discard or visibly mark an incomplete result rather than using that output.

One `vis_budget` belongs to a complete frame. Never reset between bands or disk
samples. Host limits agreed for this experiment: 1,000,000 rays, 100,000,000 node
visits and 50,000,000 triangle tests. Each operation checks before consuming its
counter, so neither a limit nor uint64 capacity is exceeded. Early occluder hits
terminate traversal. Traversal order is deterministic. Coplanar rays do not hit;
nonparallel edge hits are inclusive. Segments no longer than twice epsilon are
invalid. Degenerate triangles, bad indices, nonfinite coordinates, coordinates
outside +/-1e50, empty scenes and over-capacity inputs fail atomically.

## Separate memory quota

Use host scene `max_bytes=524288`, `max_triangles=2048`, `max_nodes=4095`.
Hard vertices cap is 4096. These are independent ceilings: at 2048 triangles the
512 KiB byte limit fails even though the count limit permits the count. There is
no quota growth. The host permits at most two retained generations and owns that
aggregate policy; this no-global-state module cannot enforce it across all scenes.
The existing render snapshot budget is separate and cannot contain this scene.

`vis_scene_required_bytes(n)` is exact requested persistent heap bytes, including
scene/refcount/generation/control, owned triangle coordinates, bounds, centroids,
stable ordinal/reorder storage and reserved BVH nodes. No indices are borrowed or
separately retained. The builder uses three allocations, no temporary heap, and
in-place sorting. Replacement peak is all still-live old scenes plus the new scene.
On this 64-bit ABI: header=80, triangle=152, node=64 bytes. Therefore:

- 1166 triangles: 326496 bytes (including 2331 reserved nodes).
- Two retained 1166-triangle generations: 652992 bytes.
- 2048 triangles: 573456 bytes (fails the 512 KiB scene budget).

Allocator bookkeeping and call-stack storage are not included in requested heap
bytes. Query has a fixed 128-byte index stack plus automatic scalars. Build median
recursion has at most 10 frames at the hard cap, plus one sorting scratch triangle.
Compiler ABI determines full call-frame storage. `vis_scene_bytes` reports live
bytes for its scene; count each unique retained scene once, not each reference.

## Test

From the workspace root:

```
cc -std=c11 -Wall -Wextra -Werror -pedantic -O2 \
  fox-v3-pixel-visibility/visibility/test_visibility.c -lm -o /tmp/test_visibility
/tmp/test_visibility
cc -std=c11 -Wall -Wextra -Werror -pedantic -O1 -g \
  -fsanitize=address,undefined fox-v3-pixel-visibility/visibility/test_visibility.c \
  -lm -o /tmp/test_visibility_san
ASAN_OPTIONS=detect_leaks=0 /tmp/test_visibility_san
```

The test includes the implementation for white-box retain overflow and injected
allocation failure checks. Production compiles `visibility.c` separately. Tests
cover both ray directions, miss, grazing edge, endpoint exclusion, coplanarity,
invalid input, source poisoning, retained generation replacement, mismatches,
same-scene rebind, unbind/reinitialize, double-clear safety, every allocation
failure, count/byte/node capacity, retain overflow, per-frame counter exhaustion,
full-capacity BVH traversal and explicit zero live heap allocations at exit.
LeakSanitizer is disabled in this runner because its ptrace environment prevents
LSan execution; ASan and UBSan remain enabled. Allocation wrappers independently
assert balance, including each failure rollback.
