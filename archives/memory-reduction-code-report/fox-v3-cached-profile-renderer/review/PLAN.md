# Independent cached renderer integration review

Scope: new private integration root only. Frozen sources read-only. No physical-heavy duplicate runs, device, SDK, model, reference, public or PR changes. Rejected owned-ray-context sources excluded.

Review gates:
1. Explicit caller-owned, aligned cache, stable compressed static blob, checked init/bind and clear; no process-global mutable bridge.
2. Context-aware callback reaches exact validated cache; raw LUT absent from linked binary and compressed payload is singleton and byte-hash exact.
3. Complete overlap admission covers cache against all live spans plus transport/visibility/background/world owners. Additional span comparisons are charged under unchanged limits.
4. Failure preserves publication rule (return true only); early rejected admission cannot write aliased reports/cache.
5. Product and observer actual compiler stack chains include profile/decode, full background/transport and constructor/lifecycle separation. Unchanged 4096 background cap, 8192 renderer cap; library stacks excluded explicitly.
6. Independent synthetic integration tests and source-diff review, then fixed40 retained output comparison (without duplicating author heavy renderer run).
7. Resource and linkage evidence distinguish object sections, named heap requests, stack chains, observer diagnostics, and actual target/device limits. Same-host performance claims only with comparable measured trials, otherwise explicitly unestablished.
