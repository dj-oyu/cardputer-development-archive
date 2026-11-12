# Memory scope clarification

Largest named request across the complete initial-build/render lifecycle remains the100224-byte caller transport attribute temporary, alive during visibility and transport construction. The compact persistent transport request is28592 bytes; it is not the largest request across the lifecycle. Model arena81356 and cold model47708 remain live during the construction phases and are included separately in the ledger.

During rendering, caller attribute/geometry temporaries and model arena/cold storage have already been freed. Largest named rendering request is77312-byte AA workspace, followed by64800-byte RGB and65472-byte visibility-node storage (the latter is larger than RGB). Depth payload129600 is split into four30720 and one6720 requests; it is not one129600-byte request.

Persistent transport/render-phase savings are72216 bytes. Whole initial-lifecycle named peak savings are62400 bytes: old568352-byte render peak moves to unchanged505952-byte visibility-build peak. These scoped sums exclude allocator metadata, libc/libm internals, unnamed executable state and unrelated caller state. Retained-old replacement scenes require the additional amounts in MEMORY_LEDGER.json; arbitrary retained bindings are not bounded by this initial-build ledger. No complete-host/device-fit claim.
