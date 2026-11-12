# Fixed five-band depth prototype

Fixed40 completed: OFF20 and ON20 compared against completed compact-BVH same arm/order. All200 raw buffer comparisons are byte-exact, including full129600-byte float depth, RGB565, HDR observer, snapshot and target mask. All280 reports match except timing and exactly checked admission accounting (396→588 OFF,420→616 ON; adapter276→378/300→406). Forward/reverse checks pass. No retries, overwrites or post-gate source changes. Independent retained audit PASS, with source/binary/gate/baseline/runtime pins rechecked.

The opt-in path splits the depth request into30720,30720,30720,30720,6720 bytes. Total129600 payload is unchanged. The original contiguous API implementation remains unchanged. Both bridge and core independently snapshot the80-byte band descriptor before callbacks; admission retains original descriptor/control spans, validates captured bands, and rendering uses captured addresses. This closes callback rebinding without an ownership context or custom allocator.

O2 and ASan/UBSan passed40 exact synthetic cases,313 core negatives,123 bridge negatives,112 callback-rebinding cases and8 isolated real-wrapper descriptor/final-verifier cases. Original adapter91 negatives plus2 prefix checks passed. Allocation failure at all5 requests cleans previous bands. Runtime failure may modify private scratch; previous committed output is preserved through fresh private-attempt paths and a completion marker, not atomic multiple-file writes. LeakSanitizer excluded because environment ptrace prevents it.

No quota increases. Guard upper927 OFF/985 ON remains below1024; observed producer maximum441972 below637599. Named host background stack4080/4096 has only16 bytes margin; renderer5008/8192, main83744. Same compiler/flags only. Each compiler or integration needs fresh stack measurement.

Named host peak568352 versus568880 is an incidental528-byte stack decrease, not depth payload savings. Core and bridge each add an80-byte descriptor copy per call. Host .text grows8192 bytes and .rodata64 bytes. Largest named requested allocation after splitting depth remains transport100808 bytes. Actual model arena81356 plus cold47708 remain unchanged. Allocator overhead/fragmentation, libc/libm stacks, executable/unnamed constants and unrelated state are excluded. No target-fit, speedup or general RAM-saving claim.

No device, public push, PR, SDK, model, reference or profile changes. Private persistence is parent-controlled using the aggregate/code allowlist; raw inputs and frames are excluded.
