# Integer four-sample HDR averaging and display boundary

Pure saved-record/arithmetic experiment. No scene queries, renderer/depth
changes, device or public actions.
Existing sources and tests remain unchanged. This directory owns only aa/.

## Exact original composition order

Read-only source: fox-v3-indexed-bvh-bounds/code/ksn_bounded_ring_helpers.inc
ring_sc_shade_final, ksn_cached_profile_impl.inc and ksn_stream_depth_impl.inc.

For each AA target, sample0..3 is selected at quarter offsets (-.25,-.25),
(.25,-.25),(-.25,.25),(.25,.25). Each slot's resolver first chooses either the
character HDR or a replacement HDR (background/floor/world). It REPLACES the
slot, not alpha-blends with character and not averages only hits. The selected
three-channel HDR is added once to the sample sum. After four slots, divide
by4. Original profile conversion and RGB565 packing happen after that mean.
Non-AA center mode selects one resolved slot and directly encodes it.

The legacy code also writes sc_encode(mean) immediately before cached_encode
replaces the same pixel. The final saved pixel is the profile result, not a
second transformation of sc_encode output. The prototype performs one final
profile call, does not feed already packed/tone-mapped values back into it,
and does not reproduce that redundant temporary write.

## Integer interface

code/integer_aa.h:
- aa_init(state,1 or4).
- aa_put(state,slot,AA_KEEP/AA_REPLACE,originalQ24,replacementQ24).
- aa_reduce(state,Q19): exact-sum averaged conversion without profile.
- aa_finish(state,encoder,context,result).
- aa_finish_block(states,1/2/4/8,encoder,context,results).

A slot value is unsigned uint64 Q24, admitted0..(2^40-1), equivalent to HDR
0..65535.9999999404. This covers the current lighting proof's conservative
49936 upper bound (3*256*65+16, allowing quantized cosines slightly above1),
but is an explicit admission bound, not a universal HDR claim. Four slots sum to at most2^42-4 and cannot overflow uint64. No per-slot
Q19/profile clamp occurs: a bright slot above8192 can still average into range.
Only after averaging does checked Q19 conversion reject an unrepresentable
mean; the profile's separate HI clamp is then applied and flagged.

Reduction computes nearest ties-even sum/(sample_count*32), once. For four
samples that is sum/128. Do NOT round the mean intoQ24 and then convert toQ19:
sum65 would become round(65/4)=16 and then round(16/32)=0, whereas the correct
single rounding round(65/128)=1. This counterexample is in the tests.

For independently nearest-rounded real input slots, per-slot Q24 error<=2^-25;
the arithmetic mean inherits the same absolute bound, not four times it.
Q19 rounding adds<=2^-20. Total mean error<=2^-25+2^-20 (about9.8347664e-7),
excluding original floating reduction roundoff. Integer summation itself is
exact. These are HDR bounds, not a guarantee of identical RGB565 thresholds.

Background replacement must already have been resolved by the caller. Pass it
before aa_put. The unused pointer can beNULL and is not inspected. A duplicate
slot is rejected; no late replacement of a previously committed sum is allowed.
This API does not compute the resolver or guess missing background values.

## Partial/error commit contract

- State updates are atomic per aa_put. Invalid slot/action, duplicate, invalid
  selected pointer or value above the admission bound leave state unchanged.
- aa_finish refuses incomplete states. It leaves result unchanged on invalid,
  incomplete, Q19 overflow or profile decode failure.
- A successful profile high clamp is a flag on a valid result, not a failure.
- aa_finish_block commits ALL result lanes only after ALL succeed. Failed lanes
  cannot leave a partially published result array. States remain unchanged.
- Encoder/cache side effects from earlier successful lanes are NOT rolled back.
  An incomplete later lane may be discovered after prior cache work. This is
  explicitly tested, and not claimed transactional for external cache state.
- State/context/results have caller-owned nonoverlapping lifetime; cache thread
  synchronization remains the caller's responsibility.

## Source verification and missing data

Captured quarter source:
fox-v3-floor-world-reflection/capture/on/native-front-baseline.samples.jsonl.
It contains9540 rows:2385 complete four-slot pixels,7678 hits and1862 misses.
The observer runs BEFORE resolver replacement. Thus miss linearRGB=[0,0,0]
is NOT the background HDR; even a hit can later be replaced.

Snapshot and targetmask are byte-identical to the current indexed-bounds front
baseline. The ancestor full RGB565 image is NOT byte-identical, so no global
merge was assumed. Instead each proposed AA pixel had to satisfy EXACT
sequential double sum(sample0..3)/4 == current saved finalHDR. Then the pinned
original float profile/packing had to exactly match the corresponding current
saved RGB565 pixel. This gate completes over the entire admitted corpus
BEFORE any candidate is evaluated.

1746 all-hit pixels /6984 slots pass.639 pixels /2556 slots fail and are
excluded. Those excluded slots include1862 misses and694 hits. Required but
missing data: each slot's resolver action and final chosen HDR. No new rays,
replacement inference or reconstruction from a known final sum is attempted.
This is missing source information, not a measured fixed-point quality error.

Separately, all32400 current saved finalHDR pixels are replayed as already
resolved/averaged inputs. Their original float profile matches the saved565
exactly before candidate work. This tests display conversion only; it does NOT
reconstruct the excluded AA pixels, center selection or entire real pipeline.

## Results

Four-slot parity-admitted corpus:
-1746 pixels, zero changed RGB565 pixels, no clamps/fallbacks.
- Mean error fromQ24 input quantization max2.7296701e-8.
- FinalQ19 HDR error max9.7649867e-7, RMS5.5248585e-7.

Standalone saved-finalHDR replay:
-32400 pixels,1 changed pixel, green channel-code delta1; no clamps/fallbacks.
- Mean/inputQ24 error max2.9801784e-8.
- FinalQ19 error max9.8347258e-7, RMS5.5159916e-7.
- Stage threshold differences:Q24 input0 pixels;Q19 conversion2;integer profile
  at identicalQ19 input1; total1. Counts overlap/cancel and are not additive.

Widths1/2/4/8 agree exactly for both corpora. O0/O2 CSV and logs are identical,
with ASan+UBSan (leak detection disabled). Original source inputs remain float
only in offline preparation and reference checks; runtime aa code uses integers.

Additional tests establish all four slots contribute, one final profile call,
replacement rather than blending, ties-even rounding, sum and output-range
checks, partial/error publication behavior and invalid/duplicate rejection.
A real-profile black/black/black/HDR4 example gives correct56552857 versus
16872 if packing each sample before averaging. SampleHDR20000 averages to5000
without a clamp;30000 averages to7500 with profile clamp;40000 averages to10000
and is rejected as Q19 overflow. Decode error leaves output unchanged.

## Reproduction/privacy

Run tests/run.sh. Outputs and generated saved-record corpora stay in private/.
private/RESULTS.json separates averaging and final-HDR-only experiments.
private/CORPUS.json, EXCLUDED_PIXELS.json, ADMITTED_PIXELS.json and source hashes
record the exact admission evidence and exclusions. Profile data are linked
from the existing PRIVATE output prototype; do not publish tables, images,
source records or generated binary corpora. No performance or S3 speed claim.
