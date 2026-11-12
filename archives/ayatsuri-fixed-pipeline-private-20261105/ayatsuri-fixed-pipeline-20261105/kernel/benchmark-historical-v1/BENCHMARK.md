# Host-only interpolation performance comparison

This is a short, isolated host measurement of **one linear-rho component**, not a renderer benchmark and not ESP32-S3 performance evidence. No S3 assembly is used. It does not justify adopting the fixed-point format on speed grounds.

## Workloads

1. **double:** frozen current rho expression `a + b1*(b-a)`, then `+ b2*(c-a)`, with existing clamp, using unquantized source doubles.
2. **fixed_prepared:** weights already converted and attributes already arranged in aligned SoA; run checked integer kernel and write integer outputs. No weight preparation, gather or dequantization is timed here.
3. **fixed_mixed:** for every pixel convert its existing double barycentrics into partitioned Q2.14, gather *preencoded* signed16 source attributes into SoA, execute the checked integer kernel, and dequantize output back to double. Vertex quantization is offline and is **not** repeated in this workload.

This is intentionally an optimistic single-component compute-only comparison and a concrete mixed-path overhead comparison. In a multi-component implementation, weight conversion and some staging can be amortized over several attributes; these timings must not simply be multiplied by component count. Conversely, real renderer gathers may be less cache friendly. Current domain-validation checks remain timed; removing them would require a separately established trusted-input contract. Prepared integer writes 16-bit output while other paths write double output, another reason not to treat their ratio as an end-to-end speed prediction.

## Method and binding

Run `bash run_benchmark.sh`. Exact command, compiler/kernel information, source/header/script hashes and compiled executable hash are recorded in `benchmark-binding.txt`.

GCC O2, no LTO, with both tree and SLP vectorization disabled (`-fno-tree-vectorize -fno-tree-slp-vectorize`). This is a portable scalar-algorithm comparison, not a claim that the compiler generated S3 SIMD. GCC `noipa` entry points prevent cross-call folding/hoisting. A volatile nonlinear integer sink consumes a changing output index each repetition; all output arrays are written by independent calls. Sink overhead is once per 4096-pixel pass, not once per pixel.

4096 deterministic varying convex barycentrics and varying source attributes, warmed before measurement; 120 passes per sample; six trials per width; sequence double/prepared/mixed then mixed/prepared/double, repeated three times. Process CPU clock (`CLOCK_PROCESS_CPUTIME_ID`) reduces scheduler-wall-time effects. All 72 raw samples are retained in `benchmark-samples.csv`; no sample rejection. No CPU affinity, frequency isolation or confidence interval is claimed. Single host/run and short sample durations limit conclusions.

Preflight outside timing validates width1/2/4/8 integer outputs are identical, mixed output equals exact dequantization of those integers, and all errors against frozen double reference are below conservative 0.00022 bound. Observed max rho error: 0.0000452303577059. Integer and mixed mismatches: zero. See `benchmark-preflight.txt`.

## Results

Median nanoseconds per pixel (one component), this run:

| Width | Frozen double | Fixed prepared | Fixed mixed | Double / prepared | Double / mixed |
|---|---:|---:|---:|---:|---:|
| 1 | 5.886 | 9.092 | 41.381 | 0.647 | 0.142 |
| 2 | 5.277 | 8.508 | 47.370 | 0.620 | 0.111 |
| 4 | 5.264 | 7.994 | 42.964 | 0.659 | 0.123 |
| 8 | 5.162 | 5.625 | 42.239 | 0.918 | 0.122 |

A ratio over 1 would favor fixed-point. There is **no prepared-kernel win on this host**: width8 prepared integer is about 9% slower than frozen double. The mixed width8 path is about 8.18× slower than double. Even with vertex encoding offline, per-pixel weight preparation and SoA gathering/dequantization dominate this tiny interpolation task. Therefore changing only the kernel while keeping current double preparation does not provide evidence of a useful speedup. Whether a converter-first integer pipeline plus actual S3 PIE backend changes that requires separately verified target implementation and end-to-end measurement.
