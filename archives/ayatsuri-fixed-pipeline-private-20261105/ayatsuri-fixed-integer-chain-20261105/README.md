# Private integrated integer-pipeline correctness experiment

This is a bounded host prototype, not the production renderer or an ESP32-S3
benchmark. All new writes are inside this experiment; linked sibling sources
were not edited. No device, public Git or image/LUT redistribution operation.

## Runtime chain established

Two executable boundaries are provided in code/:

1. `chain_block`: prepared unit-SNORM normals + Q16 world position + linear
   albedo/32767 + explicit disk visibility masks -> integer direct lighting Q24
   -> checked ties-even UQ13.19 -> integer profile -> packed RGB565.
2. `chain_block_raw_normals`: raw interpolated normal codes -> shared integer
   normalization -> the same chain. No floating normalization is inserted.

The actual-hit input conversion is offline/test-only. Tests initially used
float-normalized source Ns as the baseline fixture, then separately tested RAW
source Ns quantized without float normalization. Keep those results distinct.
Scene conversion also happens offline: light sample positions/power/world are
prepared integers. The integer runtime itself contains no floating operations.

A separate synthetic chain links the geometry worker's frozen integer project,
Q14 covered barycentrics and native attribute bridge: native metre Q16 vertices
-> integer orthographic screen Q10 -> exact-sum Q14 weights -> integer native
position/depth/normal/rho interpolation -> world axis map x,-z,-y -> optional
backface flip -> integer normalizer -> light -> Q19 -> profile -> RGB565.
All normals/colors/positions remain integers between these stages.

## Actual saved-hit results

7,678 source hit records from a saved front baseline frame, original frozen
all-visible disk16 lighting plus world ambient as reference, original float
profile and lroundf packing. This deliberately does NOT use captured real
shadow, bounce or floor/world-reflection results as its oracle.

RAW NORMAL RUNTIME CHAIN (preferred evidence):
- 7,678 accepted; zero normal/light fallback, HDR19 overflow or profile clamp.
- 14/7,678 RGB565 pixels changed; maximum channel-code delta [1,1,0].
- HDR maximum absolute error 0.0002294300602, RMS 0.00002272504857.
- Width1/2/4/8 produce identical statuses, HDR24, HDR19 and RGB565 results.
- O0/O2 outputs identical under ASan+UBSan (leak detection disabled).

Diagnostic source separation, using double arithmetic on the quantized prepared
scene/pixel inputs as an intermediate reference:
- Prepared-input quantization: 14 changed RGB565; max HDR error0.0001464914871.
- Integer normal/lighting arithmetic: 2 changes; max HDR error0.0001793588696.
- Q24->Q19: 0 RGB565 changes; max HDR error2^-20.
- Integer profile vs original float profile at identical Q19 HDR: 0 changes.
These stage counts overlap/cancel and are not additive. They are measurements,
not independent worst-case bounds. The quantized-input double diagnostic
renormalizes the raw quantized normal; the runtime normalizer is integer.

OFFLINE FLOAT-NORMALIZED FIXTURE (earlier, distinct experiment):
- 15 RGB565 changes; max channel-code delta [1,1,0].
- Same maximum HDR absolute error, RMS0.00002113801136.
- Preparation14 changes, integer lighting1, Q19 conversion0, integer output0.
This fixture is not evidence that runtime floating normalization was removed;
the raw-normal test above supplies that evidence.

private/RAW_RESULTS.json and private/RESULTS.json contain all per-source-ID and
bright/grazing/material-subset metrics. Surface grouping is by the actual
saved sourceId, without guessing anatomical labels. Bright means any original
HDR channel>=1. Grazing means any positive receiver cosine among prepared disk
samples is<0.05; it does not mean the entire hit's illumination is grazing.
Material groups use max linear rho<0.05 or>=0.5. Subsets overlap.

## Synthetic complete-stage connectivity

Both a simple world-coordinate bridge and the full native-axis bridge run a
32-sample synthetic triangle fixture.20 samples covered, all completed to
RGB565; projection, coverage and final output agree for widths1/2/4/8. O0/O2
ASan+UBSan results identical. The native bridge checks backface normal reversal,
invalid weight rejection and near-cancelled-normal rejection. There are no
float constants, floating math calls or libm linkage in these synthetic tests.
The source light tables here are synthetic prepared samples, not an accuracy
comparison against a Blender asset or a physical disk integration oracle.

Explicit synthetic status checks also demonstrate:
- Near-plane integer-light admission fallback: status12.
- Bright valid-light result outside UQ13.19: status20, no silent saturation.
- Representable HDR above profile HI: status1 (intentional high clamp).

The runtime-only linked object includes geometry, native attributes, integer
normal/lighting wrappers, integer shaper/interpolation, decoder and private
adapter. Its undefined-symbol list and host floating-arithmetic instruction
scan are retained in private/. This is source/object correctness evidence,
not proof of target instruction mapping or speed.

## Missing production integration and limits

This does NOT establish the complete real rendering pipeline:
- Saved hits still come from the old renderer. Real model decode/projection,
  coverage/depth winner, material ownership and per-hit attribute integration
  have not been replaced in a real scene. Synthetic connectivity is not that.
- Real visibility/ray traversal, transport/bounce, floor/world reflection,
  background handling, AA sample aggregation and frame orchestration remain
  outside this combined test. All-visible masks are explicit, not fabricated
  evidence of correct shadows.
- Native geometry admits source positions up to128m but light-hit positions
  must be within±8m. Normal near-zero rejection, plane/sample distance guards
  and lighting/output numeric-range fallbacks remain required.
- UQ13.19 represents at most8191.999998; admitted lighting can exceed this.
  The output profile clamps at its own lower HI and reports it explicitly.
- Width1/2/4/8 are scalar-equivalent blocking contracts, not implemented PIE.
  Scalar cache decoding, integer sqrt/division and64-bit intermediates can
  dominate. No timing, S3 speedup, memory fit or performance estimate is made.

## Reproduce and privacy

Run tests/run.sh; tests/run_raw.sh; tests/run_synthetic.sh; tests/run_native.sh;
then tests/summarize.py and tests/summarize.py --raw. These read existing private
inputs and write only this experiment's private/ directory. Existing sibling
profile preparation must already exist. SOURCE_PINS.json records linked
sources and input hashes; ARTIFACT_HASHES.json records new artifacts.

Never publish private/, any profile table/blob, original model/hit capture or
rendered images. There is no approval to redistribute the source profile.
Generic wrappers/tests are separate but reference private fixtures and depend
on sibling code; this report does not grant redistribution clearance.
