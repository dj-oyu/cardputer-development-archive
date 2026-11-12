# Standalone profile comparison plan

Only this new profile directory is writable by this worker. Original evaluator, LUT, retained buffers, renderer, SDK and baseline remain untouched. Encoded LUT and any copied private LUT are local private inputs, excluded from any generic bundle.

1. Pin original profile source, header and retained 40 raw HDR/final565 artifacts by SHA-256. Build unchanged old evaluator separately.
2. Generate candidate from exact original evaluator source, changing only data access to stateless four-vertex uint16 copies from the bounded codec. Preserve domain checks, constants, sort, floating operation order and output atomicity. Await decoder API and independent review before finalizing codec.
3. Compare statuses and float bits for synthetic endpoints, nextafter neighbors, grid/tetrahedron ties/permutations, seeded random floats, invalids and in-place alias. Replay every retained double HDR pixel via the original cast to float, and compare identical nearest565 pack to stored frames, without physical rerenders.
4. Run compiler variants and sanitizer checks. Measure separate old/new text, read-only data and named stack. Benchmark identical deterministic resident inputs with warm-up and alternating, repeated nonconcurrent runs. Report observed and conservative four-vertex decoder work bounds separately.
5. Report standalone evidence and limitations. No target admission, SDK/device changes, public delivery, new approximation, threshold change or renderer integration claim.
