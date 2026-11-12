# Independent private product/frame-contract review

No correctness blocker found in reviewed source under its documented caller contracts. Exact reviewed file hashes are in source-sha256.txt. No production checkout edits, hardware operations, public publication, CI changes, AF_UNIX use, or heavy firmware builds performed.

## Scope findings
- Generic JS contains no model geometry, private names, shaders, graph data, source controls or hashes. It is explicitly an injected synchronous control companion, not AYNM automatic skin/control import. Private backend and source metadata remain private.
- Existing AYNM requirements are not changed here. Preserving source-neutral degenerates and source alpha is correctly identified as incompatible with pretending the unchanged static importer handles this model.
- Lease publication is lock-ordered; sole writer ownership ends at publish/abort. Retire denies new pins without freeing readers. Close keeps writers until abort and readers until completion. Read tickets bind pool, slot, generation and globally unique serial; generation/serial exhaustion fails closed.
- Locks protect bookkeeping and counters; renderer and transport callbacks execute outside them. Inline completion, delayed/out-of-order completion and uncertain failed submission remain safe with the documented transport contract. Complete is not cancellation: it requires stopped readers. Drained is not callback-source quiescence.
- Snapshot CPU lifetime covers preparation, preflight and every band. Only independently retained strip pixels pass to transport. Snapshot/scratch may be reclaimed after CPU completion while strips remain pinned. Exclusive scratch, payload disjointness, lock initialization and pool no-move/no-reinitialization until callback quiescence are caller requirements, not dynamically enforced guarantees.
- No actual board ticket/descriptor association or ISR delivery integration is implemented. frame_end is correctly documented as not a drain. Host/QEMU assertions do not prove physical DMA/ISR behavior.
- Binary-alpha fast path preserves source-order/depth tie selection and zero-alpha semantics. Fractional candidates trigger unchanged general replay; immutable pure callbacks are required. Output is published only after successful traversal. No opacity threshold was introduced.

## Independent checks
1. Fresh warning-clean O2 lease test build passes 60,000 pthread pin attempts and 10,000 producer/consumer generations.
2. Extra fresh lease test passes wrong-pool completion, stale duplicate after same-generation reader-record reuse, later slot generation and close with active reader.
3. Generic JS suite passes. Existing real-render O2 binary passes all 34 bands and reports hash c526e444. Existing fastpath invariant binary passes. These two binary reruns are not fresh renderer rebuilds.
4. Fresh reference and fastpath builds match status and all 960 output pixels across 400 synthetic cases varying alpha 0/.25/.5/.75/1, depth/ties, layer limits 1–3 and shader rejection. Digest 1262204937595261853. Reproduce with python fox-product-review-20261111/check.py from workspace root.

## Delivery caveats
- Budget REPORT.md still said no fast path was implemented at review time despite separate optimized source/tests; reconcile before delivering its final report.
- No full firmware RAM-fit, target throughput, hardware DMA/ISR, original fox-bubble-bold delivery, or old 52b119ca mapping conclusion follows from this review.

## Follow-up target/SPI review

Reviewed lease_spi.c/.h, QEMU test_spi.c, UART output and the actual IDF v6.0.1 spi_master.c queue/get-result implementations. No early-reuse defect found under the adapter's dedicated-device, single-owner, return-result contract. The SDK can queue before a later submission error, so retaining every nonzero submission is conservative and necessary without branch evidence. SDK get-result assigns the exact descriptor after dequeuing completion and uninstalling temporary buffers; the subsequent DMA-failure status does not revoke retirement evidence. Unknown/null descriptors do not release tickets. No force-release or automatic unsafe teardown is exposed. A known prequeue rejection may remain pinned forever; this is a documented liveness limitation rather than an early-free bug.

Raw SPI descriptor addresses are reusable and do not themselves carry generations. Safety relies on the SDK return queue returning each accepted transaction exactly once and on no competing reaper. Arbitrary delayed duplicate raw pointers after descriptor reuse are not supported by this adapter; generic lease ticket duplicate protection must not be advertised as proof against that different transport failure model. Callback-source quiescence and any independently proven teardown remain owner obligations; idle alone is not a universal shutdown proof.

Read UART evidence confirms producer core 0, consumer core 1, 2,000 handoffs, c526e444 real-render match and explicitly mock-only SPI marker. No physical DMA/cache/ISR conclusion follows. Budget REPORT.md now describes the implemented private cutout prototype, fixing the previous stale statement.

An initial read of the composed harness confirms explicit mock transport, bounded pending strip copies and synchronous join/drain. This is not production display atomicity: failed submission after earlier bands can leave physical output partially changed even though logical committed state/hash remain old. Final composed artifact review should preserve that distinction.
