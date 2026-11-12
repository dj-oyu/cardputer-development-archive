# Checked reflection radiance to direct-light/AA seam

Independent integer arithmetic only. Supplied radiance terms are combined;
there are no scene queries, hit/material/visibility decisions, frame-renderer
changes, device or public actions. Frozen reflection, AA and profile modules
are read/linked without modification. No historical scene/hit corpus is used.
The synthetic tests do not validate any latest character/model source.

## Interface and scales

code/radiance_bridge.h defines distinct wrappers rb_rgb_q19 and rb_rgb_q24;
each stores three unsigned uint64 channels. Reflection reducer output is Q19,
not uint32 UQ13.19: its proven maximum needs33 bits. Direct-light and AA slot
radiance are Q24. This bridge never narrows a result to32 bits.

- rb_q19_to_q24: checked exact multiply32, then AA slot admission.
- rb_merge: add0..8 already-resolved Q24 contributions and one already-reduced
  Q19 reflection contribution. The reflection term can be zero.
- rb_merge_block:1/2/4/8 independent jobs, all output lanes commit together.

The API does not decide which contributions are present. It must not receive
duplicate world/direct terms, material codes instead of radiance, unweighted
reflection, or values already tone-mapped/packed. Those are caller semantic
responsibilities, not inferred from integer magnitudes. Reflection is already
weighted by the reducer and is NOT multiplied by rho a second time here.
Background replacement remains the separate explicit AA_KEEP/AA_REPLACE choice.

## Bounds and failure contracts

For arbitrary supplied Q19:
1. If a channel exceeds UINT64_MAX>>5, return RB_SCALE_OVERFLOW before shifting.
2. Otherwise shift left5 exactly. No rounding or tie handling is necessary.
3. If the scaled result exceeds AA_SAMPLE_MAX=(2^40-1), return RB_AA_RANGE.

Consequently the largest admitted Q19 code is2^35-1. The output is its exact
Q24 equivalent; no saturation is used to fill the remaining31 Q24 code values.

For addition, test term > AA_SAMPLE_MAX-current BEFORE adding. The current
value is always admitted, so this subtraction cannot underflow and the later
sum cannot overflow uint64. Even UINT64_MAX supplied as a term is rejected
safely. At most8 terms are supported, with zero terms explicitly allowed.

The frozen hr_reduce16 bound is output<=2^33-2 Q19, so exact scaling is
<=2^38-64 Q24, equivalent to16384-2^-18 HDR. This alone fits the AA slot bound.
But conservative direct-light bound49936 HDR plus that reflection can reach
66320-2^-18 HDR, beyond AA's65536-2^-24 limit. The combined case is explicitly
rejected with RB_AA_RANGE. The bridge does not silently clamp, wrap, discard a
term, invent a lower bound, or claim every admitted producer result composes.
The caller must choose an approved fallback or a separately reviewed wider
AA domain when that happens.

Every scalar failure leaves all output channels unchanged. Block failures
leave ALL output lanes unchanged, including lanes preceding a later error.
Inputs must be valid stable arrays for their declared lengths; null/invalid
count/width cases are rejected. There is no heap allocation, floating math,
encoder, cache side effect or external mutation in the bridge itself.

## Required ordering

Already-resolved direct/world/etc Q24 + exact-scaled reflected Q19 -> merged
Q24 slot -> explicit AA slot selection -> exact sum of4 slots -> one ties-even
sum/128 conversion toQ19 -> one integer profile application -> RGB565.

The AA reduction owns rounding. This scale-up/merge does not round the mean,
clamp samples to profile HI, pack before averaging, or tone-map separate terms.
The existing checked AA conversion can still reject an averaged HDR exceeding
its Q19 output range. A profile high clamp is distinct from a merge overflow.

## Validation

-100,000 deterministic arbitrary/edge-biased cases compared with independent
  unsigned128-bit test arithmetic, including input values up to UINT64_MAX.
-25,955 accepted;24,188 scale-overflow rejects;49,857 AA-range rejects.
- All accepted outputs match the oracle exactly; no rejected output changes.
- Width1/2/4/8 zero mismatches, including distinct lanes and a last-lane error
  that must leave earlier output lanes unpublished.
- Boundaries include0, smallest codes, largest admitted Q19, just above it,
  machine-scale boundary and UINT64_MAX; exact-AA-max merges and one-code
  excess; all-channel transactional failure and invalid arguments.
- Frozen reducer with sixteen maximum direct/world samples and unit materials
  produces8589934590 Q19, scaled exactly274877906880 Q24.
- Four synthetic slots containing directHDR1 plus reflectionHDR0/1/2/3 merge
  toHDR1/2/3/4. Existing AA produces meanHDR2.5 (Q19 code1310720), and the
  private integer profile is called exactly once, yielding RGB56559228.
- Conservative49936+reflection-bound merge rejects as documented.
- O0/O2 logs agree under ASan+UBSan, leak detection disabled. Runtime object
  builds with -Wall -Wextra -Werror and has no undefined function dependencies.
  The order test links without libm. No timing or target-speed claim is made.

Run tests/run.sh. Private binaries contain linked private profile data and
must not be published. SOURCE_PINS.json and ARTIFACT_HASHES.json under private/
record dependencies and deliverables. Generic code/tests remain separate.
This closes a numeric interface mismatch, not complete rendering integration.
