# Quality-preserving memory reduction audit

Completed base: indexed BVH + row HDR + floor-world. Its40 diagnostic frames passed exact-output review; no target deployment or fit is established. The rejected owned-context implementation is excluded and was not consulted.

Named render RAM628192B consists of AA137312, RGB56564800, center depth129600, indexed BVH106104, transport100808, background976, main stack83616 and child stack4976. Named RO1662416B includes1647750B validated u16 AgX LUT; RO must not be added to DRAM without target linker evidence. Conversely flash placement does not make total firmware fit: the historical3MiB app has other code/data. ABI64 host measurements are not target32 sizes.

First prototype: preserve the exact8-row scheduling and uint16 source IDs, but retain center IDs for only10rows (current8 + previous2 required by neighbor tests). Payload64800→4800B predicts60000B render saving. Separate bounded-HDR workspace is mandatory because legacy generic AA APIs still use whole-frame IDs. This avoids quantization, source-ID remapping, arithmetic changes and new traversal. Tests must cover repeated ring wrap, final7-row strip, all borders, nohit65535, sourceobject boundaries, delayed upper/lower neighbor correctness, original targets and failure atomicity.

Predicted render RAM568192B is not overall peak: unchanged BVH build593184B would dominate, so maximum named phase reduction is35008B. Allocator metadata, runtime, unrelated app state and flash/cache costs remain excluded. Historical free36872/largest23552B was a different loaded state, not the current renderer budget; primary provenance is documented below.

Deferred: center depth could theoretically use8+1rows8640B internally, but current API guarantees full129600B exact depth output with atomic success publication. Streaming requires a separately designed commit/staging contract; do not simply remove it. RGB also persists across center/quarter phases and atomic publication. No current quality degradation or relaxed limits is authorized to make these allocations fit.

Initial checkpoint: prototype and independent prerequisite review were underway in fox-v3-center-id-ring; actual drawing had not yet been authorized. The completed update below supersedes that status. No model/reference/profile/threshold/device/SDK change.

## Historical measured heap provenance

Existing saved primary log docs/kasane/logs/v2-review-device-20261102-2b4dbc9.txt at repository pin a85417dd6478032caca1f34743fe18195cabda64, contentSHA25617209803771f6199780e064a4e39b14096365b5b1887322d47c0127160ab30bd. On2026-11-02 firmwaref63ca75 MEGADEMO after Shiki49152B and all JS modules loaded, frames0: free36872/largest23552/js102744. Earlier21760B allocation failure was a different session, not simultaneous. Separate boot largest122880→69632 after WiFi time sync. These demonstrate severe app competition and fragmentation; they are not current firmware heap availability. No newer measurement was confirmed within the existing saved evidence. No device action was taken.

## Completed prototype update

The bounded-only10row ID ring completed40 actual diagnostic frames OFF/ON×two views×five conditions×forward/reverse. RGB565/depth/snapshot/targetmask/doubleHDR exactly match the completed base. Independent retained-output audit checked200raw comparisons,280report comparisons and80forward/reverse comparisons; final source/build/gate pins also passed independent recheck. No threshold/profile/geometry/light change.

Measured compiled child stack grows4976→5664B (+688), so net render saving59312B, render568880B rather than preliminary568192B. Background chain4016/4096; genericAPI unchanged. Overall construction-dominated peak593184B saves35008B. Originalread-only arrays1662416B remain; helper specialization adds executabletext not included in that array-only figure. This still does not establish target-fit, and host ABI/live namedledger excludes allocator/runtime/caller state. The40 actuals use the diagnostic HDRobserver; observer-free productcandidate is separately compiled and synthetically validated, not independently rendered40times.

## Completed compact BVH construction

The second independent prototype keeps published indexed BVH bytes and traversal unchanged while retaining only24 rather than80bytes per triangle during construction. Temporary125280→37584B; builder-local largest125280→65472B. New recursive stack2432B versus2096B yields visibility build505824B; transport build520152B unchanged. Render568880B now dominates all named phases, another24304B overall saving after the ID ring, or59312B versus the integrated628192B starting point. Caller arena129064B/depth129600B and ROarrays1662416B remain, so this is not device fit or a global maximum-allocation solution. Independent actual40 exact and allpins verified. See compact-bvh-build/REPORT.md for limits and public genericcheckpoint.
