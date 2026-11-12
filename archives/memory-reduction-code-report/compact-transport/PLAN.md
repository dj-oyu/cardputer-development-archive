# Lossless compact transport plan

Base: completed fox-v3-depth-bands. Existing API remains legacy allocation/control. New explicit compact ground builder interns complete 20-byte vertex representations by memcmp (including signed zero masks), stores 8-byte triangle index/side records, and owns one exact-sized allocation. The query validates attributes then counts first occurrences without temporary allocations. Build performs same bounded scan and fills exact pool. No borrowed arrays survive; slot publication follows all validation/allocation/geometry-retain steps. Hard cap remains 262144 and caller max_bytes is never widened.

Layout tag uses existing 4-byte tail padding if ABI verifies sizeof header unchanged; no large hot stack locals. Shading arithmetic/order stays unchanged; only material loads use an accessor. All owned spans use allocation bytes. New API validates pointer alignment/range, slot aliases and generation before publish. Old depth snapshot and guards stay unchanged.

Preflight: synthetic same-optimization differential, invalid values/alias/alignment/range, allocation/retain failure atomicity, poisoning/references/generation, pathological all-unique; ASan/UBSan; fresh compiler stack accounting and independent review. Actual fixed40 is forbidden until review PASS and parent gate. Actual count prediction 774 unique and 28592 bytes is not a measured result. Constructor includes old+new coexistence and original caller array. Worst-case unique storage exceeds legacy. No total-memory claim before ledger.

No original/reference/model/profile/threshold/device/public changes; no rejected ownership or unfinished paged sources. Code/report only private artifacts exclude images/geometry.
