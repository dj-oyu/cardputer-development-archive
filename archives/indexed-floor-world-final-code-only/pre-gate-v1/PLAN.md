# Integrate completed indexed storage, row HDR and floor-world term

This is a new isolated integration, not a retry or continuation of rejected ownership-context or unfinished storage work. Sources are the completed fox-v3-indexed-bvh and completed fox-v3-floor-world-reflection only. Baseline folders remain untouched. No source model, geometry, reference, profile/LUT, sample set, threshold, SDK or device changes. No push, PR, upload or merge in this task.

## Frozen implementation scope

Copy indexed private-build, code and harness. Preserve indexed visibility.c/h byte-for-byte, including v3 indexed ownership, original vertices, temporary builder, limits and allocation behavior. Preserve the bounded row producer's arithmetic and profile. Compare the completed floor-world bounce.c/h and pixel_transport.c/h against indexed and transfer only the verified term, work ledger, context pointer and separate component. Explicitly reconcile the adapter's newly exposed world ledger overlap checks. OFF retains the same original 24-span/276-pair admission accounting; ON checks 24 additional pairs and charges them within the unchanged producer limits. Existing 1024 guard upper reservation is retained only if the audited scan fits it. No counter or semantic work is silently reassigned.

At each eligible first floor hit the added term remains rho_receiver * rho_floor * uniform world radiance * terminal miss fraction / outer16. Fixed cosine 16/16, two-sided occlusion, epsilon, nearest-hit ordering, no extra bounce. The completed old floor-direct and world components retain arithmetic order. The separate world ledger is 64/shader +6272/eligible floor hit. All rays share original20M/800M/300M caps; old direct1M/100M/50M, producer, AA, background and display caps are unchanged. Legacy8M combined compatibility is not claimed.

For exact HDR proof only, compile-time guarded host observation copies final double RGB immediately before row encoding into an independent 777600-byte buffer indexed by the destination pixel. It does not change arithmetic, sample generation or shading. A separate report counts bytes/writes and distinguishes diagnostic memory from observer-free product-candidate memory. No duplicate world-component framebuffer. Synthetic row renders with the observer ON/OFF must have exact RGB565/depth/report equality; analytical tests verify the new component independently.

## Tests before actual rendering

Verify baseline completion/review pins, input/profile identity and source isolation. Compile O2 plus ASan/UBSan; run completed physical-term tests adapted only for input root and indexed API, transport/visibility regressions, synthetic OFF numerical/raster parity against completed indexed, and synthetic world ON parity against completed floor-world implementation. Extend row admission tests for world-ledger aliasing and rejection before writes. Run existing row producer tests with/without observer and compare emitted artifacts. Inspect emitted stack usage and count world ledger104B/context+32B and diagnostic buffer separately. Preserve all logs, failure outcomes and hashes.

Freeze final implementation, dependencies, binary and tests; ask parent for independent prerequisite review and written render gate. No actual model frame before that gate.

## Actual gate contract

After explicit clearance, one OFF front baseline forward canary then the remaining OFF19 fixed cases (front/oblique x baseline,direction,intensity,ambient,albedo x forward/reverse). OFF RGB565/depth/mask/snapshot and original report counters equal completed indexed20 exactly except7 named timings and truthful context size+32B. OFF double HDR equals completed floor-world OFF forward composite, in both traversal orders. ON one front baseline forward canary then remaining19, exact HDR and AgX RGB565 against completed floor-world ON10; depth, mask and baseline-matching snapshot unchanged. ON full old reports retain all original semantic fields except additive total traversal and the documented extra row alias admission work; world counters and traversal delta equal completed oldhost world reports for each corresponding forward case, and forward/reverse equality holds. Same fixed inputs/profile. Do not regenerate completed cases or overwrite failed output. Failed validation creates no completion manifest.

## Deliverables

Plan/source/build/test/output pins, explicit conflict/source-isolation report, truthful diagnostic and observer-free memory/stack ledger, exact output/counter validation, completion report and small code/aggregate allowlist. Private raw HDR, RGB, depth, masks, snapshots, geometry/model/generated input headers, LUTs, binaries and objects are excluded from saves intended for code-only sharing. No firmware-fit or runtime-speed claims.
