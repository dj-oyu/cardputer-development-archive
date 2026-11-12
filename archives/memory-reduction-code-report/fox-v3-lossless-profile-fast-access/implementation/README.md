# Private stateless access experiment

Compile `block_decoder.c` with `-DFAST_BITS=0` or `1`. Compile `candidate_profile.c` with `-DGATHER=0` or `1`, retaining the existing immutable `profile_data.h` and constants from `fox-v3-lossless-profile-lut/profile/private`. No generated LUT header or blob is copied into this implementation directory.

Frozen candidates: fast_bits = (1,0), gather = (0,1), gather_fast_bits = (1,1), ordered as (FAST_BITS,GATHER). The baseline is the original decoder/profile, not a newly optimized fourth candidate.

`lossless_fetch` retains its original ABI and transactional behavior. New `lossless_fetch4(blob, length, vertices[4], rgb[4][3])` returns 1 on complete success, 0 otherwise. Every selected block is decoded fully. No public RGB write occurs until all selected block validations succeed. Input indices are copied before output writes, so indices/output alias is supported. Blob/output overlap is rejected. All pointer-overlap comparisons use differences rather than potentially overflowing pointer-end additions. Null arguments and oversized lengths are rejected before data reads. As with baseline C APIs, buffers must be valid at their advertised sizes and blob contents must be stable during a call.

The gather stores four block IDs, targets and dimensions, four staged RGB values, and one 64-word channel scratch array. It never retains decoded data across calls. It decodes each unique selected block exactly once, scattering each channel's requested values to local staging immediately, rather than storing four complete blocks. This avoids the initially estimated 384-byte three-channel block scratch; actual stack usage is compiler/platform-dependent and benchmark reports should use generated stack reports.

The bit extractor loads only bytes intersecting a bounded requested bit range (up to 16 bits). All byte loads are guarded by the original bit-length check, including partial final bytes. It does not perform unaligned word loads or read ahead. Rice unary remains one-bit-at-a-time, with original maximum quotient bounds and predictor arithmetic.

No cache setup/reset/identity/generation API is needed: there is no mutable global or persistent caller state. A fresh call observes a replaced or mutated blob, including malformed replacements. Mutation during a call is unsupported, matching baseline. Fixed retained caches could improve across-pixel locality but require a separately designed lifetime/immutable identity contract; modeled hit rates do not establish their achieved speed or safety.
