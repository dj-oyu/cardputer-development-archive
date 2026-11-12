# Private fixed-point pipeline investigation

2026-11-05. Read-only baseline audit and independent prototypes. Existing renderer, converter, model formats and assets remain unchanged. No device, public upload or denied owned-ray-context action.

- audit/: source-pipeline audit and provenance.
- converter/: new AYFQ experimental source compiler and codec; private actual outputs kept in results/private/.
- kernel/: portable scalar and block8 fixed-point interpolation reference; no hardware SIMD claim.
- quality/: private input range/error survey; quantize/dequantize is not rendering equivalence.

The immediate milestone is a tested, versioned numeric and layout contract, compiled from preserved pre-RGB565 source data. It does not constitute an integrated integer renderer or S3 speed measurement.

Milestone completed: direct GLB adapter, AYFQ q16/q20 codec, scalar/1/2/4/8 interpolation oracle, strict cross-language rounding tests, actual saved-hit bitwise baseline replay and approximate attribute comparison, geometry-only AYNM bridge/model-open validation, and limited host-only benchmark. Final report: REPORT.md. Legitimate full render preparation and S3 backend remain distinct next stages; no old validation gate was weakened.
