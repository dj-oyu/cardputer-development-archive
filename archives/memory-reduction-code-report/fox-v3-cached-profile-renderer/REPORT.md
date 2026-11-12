# Cached profile renderer: pre-actual result

Explicit caller-owned four-block cache is wired into a separate host-only renderer path. Existing core APIs and other borrowed views remain intact. New profile context is not the rejected owned-ray-context experiment. Static profile bytes, arithmetic, AA72512, depth bands, segmented model, compact transport and indexed BVH are unchanged.

All prerequisites passed; no actual40 yet. See PREREQUISITE_REPORT.md and machine-readable test manifests. Exact cache source remains pinned. Production contains one445248-byte encoded LUT and no1647750-byte raw table. Stateless legacy gather and cached entrypoints share the singleton. Product text+RO728002 versus1914766, reduction1186764; data1704/bss16 unchanged. This includes additional specialized code, so the section reduction is smaller than LUT data saving1202502.

The tradeoff is one3224-byte requested heap allocation. Named render peak494608 (+3224); main83792, renderer5008, background4080/4096 unchanged. Observer main adds16 bytes. Cache profile nested chain520 is not added to background stack because these branches execute sequentially. Device ABI, allocator overhead, library stack and whole-process memory are not established.

Fixed40 comparator is predeclared: same-arm/order five raw formats and seven old reports exact, except allowed descriptive times and .row pair/admission deltas(+28 OFF,+29 ON). Separate cache sidecar validates32400 profiles and129600 selected vertex lookups, no invalidations, fixed storage and cold bind per frame. Source freeze, reviewer PASS and explicit parent gate required before executing.
