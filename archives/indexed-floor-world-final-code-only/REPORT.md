# Completed indexed + row HDR + floor-world integration

All40 actual model cases used the diagnostic build with the HDR observer. The observer-free product candidate was validated by build/symbol checks and synthetic parity only; it did not receive a separate actual40 run.

All40 fixed cases passed: floor-world OFF20 and ON20, each front/oblique × baseline/direction/intensity/ambient/albedo × forward/reverse. No actual case failed, was retried, overwritten or rerendered. The independently reviewed prerequisite gate preceded the OFF canary, and each passing canary preceded its remaining19. This is a completed isolated host integration, not firmware integration, default adoption, a new visual-quality claim or target-fit proof.

## Source and conflict resolution

The base is the completed fox-v3-indexed-bvh, which already contains the completed bounded row-HDR producer. The four transport files bounce.c/h and pixel_transport.c/h are byte-identical to the completed fox-v3-floor-world-reflection implementation. Indexed visibility.c/h are unchanged: all original-order vertex identities and double bits, uint16 indexed triangles, temporary builder, atomic publication and retained ownership semantics stay intact. No rejected or unfinished implementation was read, used or retried.

Only the established physical term is added at an eligible first floor hit: receiver rho × source floor rho × uniform world radiance × the existing16 terminal-ray miss fraction / outer16. Direct lighting and floor emission are unchanged. Blocked terminal rays contribute zero. Original16/16 directions, epsilon/range, two-sided occlusion, hit ordering and cumulative ray/node/triangle caps are retained. The physical term allocates no heap and introduces no new visibility ownership context.

The row adapter admits the new104-byte world ledger against all24 original external spans and owned scenes. OFF retains276 original pair checks. ON performs300, with24 extra charged under the unchanged1024 admission-category limit and637599 total producer cap. A documented bridge-level guard-dispatch upper bound731 fits the existing1024 reservation. This is a semantic dispatch count with existing predicate kernels, not a CPU-instruction bound.

For exact HDR validation only, a compile-time observer copies each final double RGB immediately before the unchanged float/profile/RGB565 conversion. It does not change shading or arithmetic. The observer-free product-candidate build excludes its code and storage. No second full world-component framebuffer is added.

## Exact output and counter evidence

- OFF20 reproduce the completed indexed RGB565, depth, target mask and same-order snapshot byte-for-byte. Original report fields/counters are exact except7 explicit timing fields and truthful context size576→608 bytes.
- OFF20 double HDR and AgX RGB565 match the ten completed floor-world OFF composites in both traversal orders.
- ON20 double HDR and AgX RGB565 match the ten completed floor-world ON composites byte-for-byte in both traversal orders. Original depth, target masks and same-order snapshots remain exact.
- All ten forward ON world-ledger fields match the completed older-host world experiment. Every main transport traversal delta equals the separately observed world traversal. Other old shading/AA/background counters retain their matching indexed values; ON row admission adds only24 pairs.
- Reverse intermediate shade/hit counts legitimately differ from forward because center winners can be overwritten in a different order. Reverse validation uses each corresponding indexed reverse baseline, exact world work/query/miss/blocked identities and additive traversal, rather than falsely requiring forward counters. Final HDR/565/depth/masks remain order-independent. Snapshot equality is against its matching original order, not between orders.
- OUTPUT_FREEZE.json rehashes480 output/report artifacts and pins the unchanged final source/binary. Actual completion records remain in actual-off-001 and actual-on-001. Raw files stay private and are excluded from the code-only package.

Exact outputs preserve the already completed floor-world formal scores, including its documented regressions. No metric, reference, threshold, sample set, geometry or profile was changed; scores were not rerun or selectively improved. This integration establishes the verified new term on the indexed/row implementation, not full renderer equivalence or resolution of remaining geometry/shape/quality gaps.

## Limits and measured fixed-case work

Maximum ON total traversal was9134101 rays /461923659 nodes /144185556 triangle tests, below the unchanged20M/800M/300M caps. Direct1M/100M/50M and background caps also remained unchanged. Maximum new world traversal was1146672 rays /35212432 nodes /7012260 triangle tests; maxima need not occur in the same case.

The unchanged world-work formula is64 per shader and6272 per eligible floor hit. Maximum observed work450583488 is below the original450598848 cap. Maximum shaders17241 and eligible hits71667 retain the original bounds; reverse maximum hits70443 did not require raising them. Maximum producer semantic usage441776 is below637599. Neither the new world work nor prior floor/background work is represented as admission to the legacy8M combined-work contract.

Descriptive20-frame host render-time sums were321.245750513s OFF and346.635653556s ON. These runs include the diagnostic observer and possible other host work. No observer-free product timing, isolated speedup, target-device timing or frame-rate claim is made.

## Memory and compiled stacks on this64-bit host

The shared indexed visibility scene remains106104 requested bytes, with125280 build-only temporary bytes and231384 new-build peak. Two retained indexed generations remain212208 bytes; replacement with one retained generation remains337488. The largest construction allocation remains125280. No geometry/BVH heap growth is introduced by the physical term.

The transport context grows576→608 bytes, comprising a world-ledger pointer and separate24-byte latest component. The world ledger is104 bytes. Both are included in the measured main stack, not added again. Main stack is83616 bytes, +160 from completed indexed. The renderer child chain is4976/8192 bytes, +160; background chain is unchanged4048/4096, leaving48 bytes under that host-build cap. These are named compiled chains, not a complete runtime/ABI stack audit.

Observer-free product-candidate named render total is628192 bytes excluding named read-only arrays, compared with627872 for completed indexed. Including the unchanged1662416 named read-only bytes gives2290608; one additional retained indexed generation gives2396712.

The actual validation renderer additionally allocates777600 bytes for the diagnostic HDR buffer and has24 bytes of global observer control. Its named total is1405816 excluding read-only arrays, or3068232 including them; one additional retained indexed scene gives3174336. The observer separately reports259200 initialization-write bytes,777600 capture-write bytes,32400 copied RGB triples and777600 export bytes per frame. These diagnostics are not hidden inside product memory or legacy work-admission claims.

Allocator metadata/fragmentation, libc/libm internals, executable/unnamed constants, diagnostic file-export stack, unrelated caller state and other named exclusions remain outside these ledgers. Historical target free/largest-block observations are not admission caps or fit proof. The observer-free product binary was built and inspected but not deployed.

## Validation and preserved history

Own tests passed24 indexed configurations (O0/O2, plain/ASan+UBSan), analytical physical-term and transport regressions, exact synthetic row OFF comparison against completed indexed, ON comparison against completed floor-world transport, and observer OFF/ON equality under O2 and ASan+UBSan. Adapter91 negatives cover all24 spans, end crossings, overflow and owned scenes;2 prefix-preservation and63 producer-negative cases also pass. Independent prerequisite review additionally ran41 physical cases and observer lifecycle/index/duplicate/write-size tests. LeakSanitizer is unavailable under ptrace and is not claimed as a whole-renderer pass.

Before any actual rendering, a read-only baseline audit caught the initial runner's invalid forward/reverse ledger assumption. That validation contract was corrected without changing numerical source, and pre-gate-v1 preserves the earlier plan/source freeze/runner. A stale test-only stack-file hash after expanded alias tests was also corrected before the gate; final source and renderer binaries were unchanged. PREREQUISITE_SUMMARY.json records these and the other preparatory corrections.

All implementation and actual work remained local/private. No model/reference save, SDK installation, device operation, public push, PR, merge or upload was performed by this worker. The parent owns any authorized private save or later code-only publication.

## Final independent retained-output review

The final read-only review passed all40 cases and480 retained output hashes, same-order old/new counter arithmetic, original caps, source/binary/gate pins, output freeze, work/time aggregates and separate product/diagnostic memory. It also checked952 unchanged formal-score input pins. No further render was requested or performed. The reproducible verifier and aggregate report are in review/postcapture-independent; REVIEW.json SHA256 is22bfc40bf95c9f25945a1f0d75b009b6bae829b7bfe9fd2951b3a18c54427692.
