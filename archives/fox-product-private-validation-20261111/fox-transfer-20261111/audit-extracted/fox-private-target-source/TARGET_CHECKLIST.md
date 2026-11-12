# Target handoff checklist: private diagnostic only

## Scope before any target run
- Parent/device owner must select and verify the exact target checkout, firmware baseline and device permission. This directory performs no target build, flash, transport access or public publication.
- Carry only the private runtime source/immutable arrays and a reviewed callback adapter. Do not copy Blender sources, reference.json/inc, host panel/oracles/witness, sanitizer binaries, preview images or test stack reservation into firmware.
- Use the eight sampled head-control poses × three diagnostic cameras. Facial controls fixed neutral; original source BSDF, eye transparency/depth and face morphs are not implemented. All1982triangles remain original topology/materialIDs; colors are explicitly diagnostic.
- New measurement callbacks are not the actual board adapter. The prior actual Kasane completion/core tests remain separate evidence. This lower-level harness does not include full Kasane UI/core costs unless a real adapter adds them.

## Callback contract to implement and review
- `now_us`: monotonic elapsed microseconds suitable for preparation, CPU work, scheduling and transport wait. Never substitute process CPU time for full-frame elapsed.
- Output halves belong to one serialized owner. A submit that accepts a half must identify whether its storage remains borrowed; cannot recycle a borrowed half until drain positively confirms release. Do not infer release from an error code.
- Final completion must include the final3rowstrip, driver queue and actual panel-transport completion before ready promotion. ACK may establish completion, not frame-atomic display.
- If any prepare/render/submit/completion stage fails, abort the measured run and retain the old ready snapshot. Partial pixels can already be visible. An uncertain borrow must quarantine the owner. Reset/recovery and oldscene repair require the real transport's separately verified protocol.
- Immutable source and both projected snapshots outlive all in-flight callbacks. Never edit live controls/weights/matrices behind a retained snapshot; prepare the other snapshot then commit after completion.

## Workload and statistics
-30warmupframes, excluded from measurement; then120frames =8poses×3cameras×5cycles.
-Full frame starts before prepare and ends only after finalcompletion succeeds. Include rig/projection/indexing, orderedstriprender, transferwait and completion. Report min/mean/p95/max; successful frames only, and abort any failed run rather than hiding droppedframes.
-Separate callback wall-clock durations for prepare, striprender, submit/drain and finalcompletion. Existing `scene_times` rig/project/index uses C `clock()` and is host CPU time, not comparable to elapsed without a target timer conversion. Replace stage timer source deliberately for target instrumentation; do not silently reinterpret it.
-PIE OFF baseline; record CPU frequency, compilerflags, exactsource/buildhash, cache options and targetconfig. Q7depthcache gain not assumed; prior body sample had no exactzeroYeligible triangles.
-20fps means full-frame≤50ms under the agreed workload, not render-only or hostfps. Report tail latency, not average only.

## Target memory evidence still required
-Linkermap/ELF sections for every private immutable array, both old/new projected snapshots, stripindices, rig/raster workspace, actualsharedstripbuffers, callbackowner, core/UI, realtransportdescriptors, all tasks and engineglobals.
-Read-only placement is not automatically flash: count as RAM unless targetsectionplacement proves otherwise. Do not carry hosttestdata or count the same boardhalves twice.
-Record total freeheap/minimumfreeheap/largestfreeblock beforeload, afterload, afterwarmup, atpeak, aftercompletion and afterrelease; trace allocations if owner dynamicallyloads.
-Task stack high-water for the actual target task during same workload and injectedfailure paths; host `.su`/paintedstack is not a targetstackproof. Account interrupt/driver taskstacks separately.
-Do not compare prior152903Bpartialhostledger directly with new minimal harness as a claimed optimization: new harness excludesKasaneUI/core and useslinkerGC; scope differs.
