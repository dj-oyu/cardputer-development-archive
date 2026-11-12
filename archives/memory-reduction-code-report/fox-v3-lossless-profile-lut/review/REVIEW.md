# Independent lossless cube4 codec review

PASS for the pinned host storage decoder. Every original uint16 value was recovered exactly through both full vertex fetch and independently indexed channel recovery, without reducing the 65³ grid. This is not a profile integration, renderer, quality-threshold, target-fit or device claim.

## Verification

`independent_test.c` includes the original uint16 table read-only as its oracle; it does not use the producer's Python decoder. O2 and O2 ASan+UBSan runs both passed:

- 274625 vertex fetches / 823875 values, plus 10000 deterministic shuffled fetches.
- 14739 channels and all 425560 shorter record prefixes rejected; scratch canaries unchanged.
- 24637 public malformed rejections with RGB unchanged, including every undersized header/index length, altered header bytes, all selected start-offset positions, SIZE_MAX, NULLs and vertex bounds.
- 20000 mutations inside selected encoded blocks. Failure preserves RGB; syntactically valid mutations need not preserve original values.
- 448 synthetic shape/mode combinations, independently constructed predictor residuals, every Rice k=0..16 with zero and zigzag extrema, overlong unary, min-plus-residual overflow, invalid dimensions, and encoded-input/output overlap in both directions.

ASan/UBSan passed with leak detection disabled. The initial LeakSanitizer attempt failed because this environment uses ptrace; leak detection is not claimed. Decoder itself has no allocation.

## Static reasoning and API contract

The 32-byte header fixes magic AGXL4R01, edge65, cube4, 4913 blocks, serialized total, offset-table start32, payload start19688 and reserved0. It uses little-endian byte reads, so the blob has no alignment requirement. Index contains 4914 uint32 offsets including the terminal sentinel. A fetch verifies header, both global sentinels and its selected offset pair, requires a nonempty block of at most396 bytes and bounds it within payload. It does not scan all unrelated offsets for monotonicity; the generator supplies the canonical full table.

One channel header is mode/k and, for mode0, a uint16 minimum. Modes0..3 are fixed-bit minimum/d1/d2/Lorenzo, mode4 invalid, modes5..7 are Rice d1/d2/Lorenzo. k is at most16. Byte bits are consumed low first; Rice uses zero quotient bits then one and k remainder bits. Unary quotient is bounded to65535>>k; k16 therefore permits only quotient0. Record length is capped396 before len*8, eliminating size_t multiplication overflow even on a 32-bit host. Three 64-value raw/min records require no more than396 bytes, so this cap does not exclude the generator's minimum-cost choices. Public global size cap is19688+4913*396.

Unsigned-to-uint16 conversion applies the intended modulo65536. Zigzag delta stays[-32768,32767]. d2 lies[-65535,131070]; Lorenzo signed sum stays within[-196605,262140], with partial sums still safely in int32. All dimensional products are at most64 and predecessor accesses are guarded by corresponding coordinates. Header and index arithmetic stays below2MiB on the intended32-bit-or-wider ABI.

`lossless_decode_channel` is explicitly a private scratch helper, allowed to alter its caller-owned64-word scratch before failure. `lossless_fetch` owns128-byte scratch plus6-byte staged RGB, validates all three channels and the exact block end, and commits RGB only after success. It rejects overlap between the complete blob span and6-byte RGB span before writing. No mutable global cache exists. A caller must still provide actual readable input storage of declared length and a valid aligned output object, as with ordinary C pointer APIs. Valid-but-wrong data and unused padding bits are not authenticated.

## Size and boundary

GCC14.2 x86_64 O2 decoder object: text1603, read-only8, data/bss0; O2 own frames fetch224 plus channel56, conservative named chain280 bytes. Os: text1382, read-only8, frames208+56=264. These are compiler/host-specific figures, not target stack/link estimates. Blob445248 bytes preserves all1647750 raw table bytes. Independent harness executables embed the original private LUT and must not be published or bundled; local .gitignore excludes them.

Reproduction from workspace root: compile `review/independent_test.c` with `research/block_decoder.c` under O2, and again under O2 with `-fsanitize=address,undefined -fno-omit-frame-pointer`; pass `research/private/agx_cube4_rice.bin` as sole executable argument. Use ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 and UBSAN_OPTIONS=halt_on_error=1 in this environment. Paths above are relative to fox-v3-lossless-profile-lut. Exact hashes and result lines are in REVIEW.json.
