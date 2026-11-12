# Lossless AgX LUT: standalone result

The fixed65³ uint16 lookup table is preserved exactly. A bounded4³ block predictor/Rice/bitpack encoding stores every original value in445,248 B including index/header, versus1,647,750 B:1,202,502 B saved (72.98%). It is not the rejected33³ approximation, a new tone curve or an image-fitted profile. No original image, geometry or reference threshold was used to select the encoding.

## Verified and not verified

Independent C codec tests exhaustively recovered823,875 values; malformed/truncated/index/overflow/alias and public-output failure tests passed underO2 and ASan/UBSan. Private decode scratch may change on failure, while public RGB outputs do not. Standalone profile preserves shaper, sorting, interpolation and clamp arithmetic. O0/O2/sanitizer comparisons passed460,224 synthetic inputs plus1,296,000 pixels from the40 retained HDR buffers. Float bits, return status and final565 match. Independent same-flags replay and a direct C double-to-float replay also matched. This reuses saved frames; no physical ray rendering occurred.

The candidate is NOT wired into the renderer. Its single compressed storage span, propagated decoder failures, admission/alias checks, whole call-chain stack and actual build still require separate integration testing. Host frozen renderer remains unchanged. LSan was unavailable under ptrace; only the documented ASan/UBSan retry with leak detection disabled passed.

## Real cost

Sameflags standalone hostO2: profile+decoder text848→2,582 B (+1,734); main table1,647,750→445,248 B; all measuredRO1,647,866→445,380 B; named profile chain144→488 B (+344), excluding libm/libc/caller. No heap allocation or mutable global cache. Four vertex fetches reconstruct at most768 uint16 values;128-byte private channel scratch is reused. These are x86_64/GCC14.2 results, not Xtensa placement/stack/time.

Performance is substantially worse. Final nine warmed alternating paired trials: synthetic log-HDR24.78× slower;8192 seeded retained-frame samples84.47× slower (118.109→9,976.214 ns/profile). Earlier22.59× referred to a different synthetic benchmark and must not represent actual retained-frame inputs. Checksums agree throughout. No claim that full renderer or device becomes84× slower; neither was measured. This is a flash-versus-CPU tradeoff, not unconditional adoption.

Old successful4a4d firmware, which did not include this renderer, had544,048 B factory remainder. Subtracting blob alone leaves98,800 B before decoder/new renderer/otherRO/alignment; no integrated fit is proven. Existing RAM491,384 B is unchanged until renderer integration and fresh accounting. Fixed original profile precision is maintained relative to the validated65³ implementation, not a newly established guarantee of exact BlenderOCIO over every real input.

## Scope and next decision

Do not merge or deploy automatically. If further authorized, first integrate the exact compressed span into the existing validated profile bridge and audit all failure/alias/stack bounds, then repeat fixed40 physical comparisons. A bounded per-call gather that avoids decoding the same block multiple times is a possible later speed improvement, not tested here; no new cache or codec variants were introduced after the final timing result.

Private preservation includes genericAgX compressed lookup bytes and reconstruction code, never fox geometry/original images/renderedHDR inputs. Blob is not approved for public redistribution. profile/RESTORE.md reconstructs the generated header from saved blob/constants; replaying historical40 requires separately retained excluded fixtures. Research reports retain the finite15-variant study and fixed format. review/REVIEW.json and PROFILE_REVIEW.json are the independent evidence.
