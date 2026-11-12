# Exact indexed BVH bounds: preactual prototype

The accepted prototype builds the original double-node tree with byte-identical original bound construction source. After freeing centroid work, it creates28-byte nodes that point to exact original double coordinates owned by the same scene. It validates every final bound by object-representation comparison before publishing. Original tree and work allocations are freed before publication. All queries read only the compact representation and owned xyz. No external storage or additional query cache is used.

Two initial variants were rejected: per-merge witnesses changed signed-zero results under O2, and construction-local bounds changed signed-zero results under O2 sanitizers. The final original-tree conversion passes the independent same-flags canonical node/query and all-axis signed-zero fixtures. No signed-zero normalization or baseline change was introduced.

Final persistent scene106104→69276 bytes. Product named peak373552→336724, saving36828. Original construction requested heap143688 is unchanged, plus32 bytes in the constructor frame. The complete named construction phase is312580 and conversion301544. Background stack4016/4096 and renderer4944/8192 are unchanged. Generic temporary accounting includes the one-triangle transition peak; the actual1566-triangle extra is74412. All retained old scenes are charged additionally. No target-device or whole-process fit claim.

The allocator suite checks all counts1..2048 at vertex counts3 and4096, exact max-index identity4095, six allocation failure points, guard/alias checks, old-scene preservation, poison/free balances and generic helper agreement with actual requested allocation peak. O0/O2 and ASan/UBSan pass. LeakSanitizer is unavailable under this host's ptrace; explicit allocation accounting reports zero outstanding allocations. Independent review evidence is under review/.

Only actual report visibilitySceneBytes changes. visibilityTemporaryBytes in native reports is caller geometry46800 and remains unchanged; the internal builder peak-extra API and ledger are distinct. All ray/node/triangle counters and rendering outputs remain exact acceptance requirements. BOUND_COST.json records the bounded conversion cost, owned-coordinate lookup overhead and synthetic build timings without claiming a render speedup.

Actual renders remain gated until independent review, final source freeze and separate GO. Existing roots remain immutable. No device, SDK, public repository, PR, model, reference or coefficient changes.
