# Stack gate correction, before physical execution

The first integrated adapter was prepared but never physically rendered. Its complete live named chain is 4,656 bytes, including the new transport bridge (592 bytes). The prior 4,064-byte claim omitted that bridge and is withdrawn. The 4,096-byte limit is unchanged.

The second adapter preserves all validation and shading arithmetic. Validation temporary arrays are now confined to a noinline function that returns before rendering; diagnostic formatting arrays are confined to a noinline function called after the resolver returns. No shared mutable scene scratch, allocation, or new API was introduced. Local result commit still follows successful resolution and logging. Failed logging may retain consumed counters and private partial output, but does not yield a successful frame.

Fresh O2 stack-usage results:
- Physical callback chain: bridge 192 + core 1664 + dispatch 80 + observer 96 + resolver/physical/visibility 2032 = 4064 bytes.
- Logging branch: bridge 192 + core 1664 + dispatch 80 + observer 96 + logging 224 = 2256 bytes.
- Validation branch: bridge 192 + validation 464 = 656 bytes.

The fixed 4 KiB named-chain contract excludes main's diagnostic caller frame and libc/libm internals, as before; this is not an entire process stack bound or device-fit claim. Owned storage is unchanged. Actual execution remains gated on independent review. Original code is retained in history/stack-fail-001 and actual-001. The replacement is actual-002; source and measurements are fixed by STACK_FIX_FREEZE.json.
