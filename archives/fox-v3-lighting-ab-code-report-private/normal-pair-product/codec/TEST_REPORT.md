# Verification report

Product source freeze: SOURCE_FREEZE.json, SHA-256 230140690027b5a775c328c9a50ef9d5c68b44c345539b740eb2d482697b5a4a.

Toolchain: GCC 14.2.0 (Debian 14.2.0-19), x86_64 host. Test command: `./tests/run.sh`. Both optimization configurations use `-std=c11 -g -fsanitize=address,undefined -fno-omit-frame-pointer -ffp-contract=off -Wall -Wextra -Werror -Wno-misleading-indentation`, with `-O0` or `-O2`. Runs set `ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1`.

Passed against the frozen final four product files:

| Suite | O0 | O2 |
|---|---|---|
| Standalone codec/renderer differential and hostile-input suite | 4,588 checks PASS | 4,588 checks PASS |
| Unmodified legacy pixel renderer suite | PASS | PASS |
| Explicit mode5 visibility binding suite | PASS | PASS |
| Independent exhaustive valid SNORM component sweep and boundary suite | 65,535 values PASS | 65,535 values PASS |

The independent reviewer executed their own code on a private copied checkout. Its test source and original logs are included in `independent-review`. The author did not change those files. It covers every signed normal component -32767..32767, unaligned mode5 records, unused invalid vertices, mixed mode5/4 streams, poisoned inputs, all 168 short lengths for a three-vertex record, and atomic late-invalid/capacity/packet-limit failures. The reviewed C hashes match the source freeze.

Independent reproduction command, for O in 0 2:

```
cc -std=c11 -O$O -g -fsanitize=address,undefined -fno-omit-frame-pointer -ffp-contract=off -I product/main independent-review/independent.c product/main/ayatsuri/compact_opaque.c -lm -o independent-O$O
ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1 ./independent-O$O
```

The default/off writer is compared to the original separately compiled codec for complete bytes, not only images. Eligible mode5 and mixed fallback records are decoded and passed through the original-format writer; the complete mode4 record bytes, including padding, match. Forward/reverse mixed renderer tests compare OFF/ON color, depth, and stats within each submission order. No assumption is made that reversing exact depth ties must produce the same frame.

The binding tests establish that mode5 participates correctly in snapshot fingerprints, while mutation/stale-generation rejection, independent scene retention, and budget/alias behavior remain intact. No visibility or transport production code was changed. Source scanning found no additional mode4-only record gates in those paths.

Limits: LeakSanitizer is unsupported under this environment's ptrace sandbox, so leak checking was not run. ASan/UBSan completed without findings. Product adds no allocation. Actual all-v3 frame parity, actual 58,844-byte snapshot confirmation, CPU impact, target ABI, firmware fit, and hardware operation are not established by these standalone tests; integration is a separate task. No quota was raised and no frozen baseline was edited.
