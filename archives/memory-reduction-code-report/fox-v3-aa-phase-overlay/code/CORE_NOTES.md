# Private bounded HDR core

The production entry point is `ksn_mesh_pixel_render_bounded_hdr_experimental`.
It preserves the original center intermediate-winner shader order, and the original sample-major quarter passes. It retains only eight double HDR rows plus one delayed row legally overlaid on quarter-winner storage. No full HDR production buffer or geometry replay is introduced.

Non-target center rows are finalized only when their lower neighbors are final. Target centers never call the display profile. Selected quarter radiance is accumulated in linear space, divided by four, then profiled once. Old RGB encodes remain for legacy work accounting. The real adapter must supply the pinned unchanged 65-cubed u16 profile.

The display encoding capacity guard is one dispatch that checks all four remaining INPUT/PROFILE/OUTPUT/PACK capacities before encoding. Individual category counters increment only as their stages execute. Invalid values abort before packing. Limits remain the preimplementation constants; no category or original physical budget is raised.

Core admission performs one full pairwise span scan, including the display report. Successful pair checks are recorded as 15 + live*(live-1)/2 + 6*live, which is120 for ten live external spans. The adapter has additional declared/retained span checks and must aggregate them under the existing1024 limit. Typed controls are alignment and span-overflow checked before dereference.

All candidate output and depth writes remain private on failure. Return value is authoritative: an admission failure may preserve an old complete report. The core does not publish files or modify any previous visible buffers. Final scene/generation/source validation and publication are adapter responsibilities.

## Validation

`SYNTHETIC_REPORT.json` records exact reproducible commands and hashes. Optimized and address/undefined/float-cast-overflow sanitizer runs pass63 negative cases. LeakSanitizer is unavailable under this ptrace runtime and was explicitly disabled. The test-only full HDR oracle verifies three floor-winning quarter slots, exact final packing and unchanged character depth. Independent reviewer row tests cover291600 pixels and144 delayed seams.

These are synthetic checks, not actual physical frame validation. Full named stack, adapter ownership/generation admission, and final independent execution clearance remain required.

This code remains a private copy of the pinned baseline. Porting onto PR117's new JIT/PIE base requires explicit API/ownership integration, a fresh build, and fresh budget/stack validation. None of the old capacity claims establish capacity on that new base.

The streamed implementation performs135 real per-row neighbor capacity checks instead of the original single whole-frame check. Successful AA_COUNTER_GUARDS and observed total therefore increase by134, with all other AA categories unchanged. This is explicit additional guard work inside the unchanged original category reservations and8M cap, not exact old guard-count equivalence. No quota is relaxed.
