# Three-frame geometry-only canary: completed

Exactly three full shaded frames ran, once each, in approved order: original, q16, q20. All use front view, baseline lights/materials, forward order and floor-world ON. No retries or extra frames. Existing implementations and runtime caps remained unchanged; only genuine candidate metadata headers changed. Each own-input snapshot, depth, mask, counts and resource gates passed.

Original control reproduces all five raw artifacts bitwise and all nine non-timing reports semantically, except the predeclared new background input JSON fingerprint. All sixteen compiled stack-function maps are unchanged, with no new renderer allocations or observers.

## Measured image result

- q16: 4 of 32,400 final RGB565 pixels changed; five channel values changed, each by at most one code step. Linear HDR maximum absolute error0.0318808470, RMS0.000182816551, mean0.00000343990924. Largest HDR difference is red at(x140,y60),2.1518486342→2.1199677871. Maximum relative error among baseline HDR channels≥0.001 is21.1827%, localized; this is an all-pixel channel statistic, not specifically a finite-depth-only statistic.
- q20: zero final RGB565 pixel changes. Linear HDR maximum absolute error0.000713989856, RMS0.00000242564112, mean0.0000000527542969. Largest HDR difference is red at(x103,y68),0.9336850752→0.9343990651. Maximum relative error among baseline HDR channels≥0.001 is0.0764701%.
- Both have unchanged finite coverage and target masks. Depth values change: maximum native depth delta0.00482893(q16),0.000568390(q20).
- Pure original background geometry classification divides the baseline output into4,525 character-only,27,534 floor-only,0 world-only,341 mixed pixels. Both candidates' floor-only HDR pixels are exactly unchanged; character/mixed values differ. There are no world-only pixels to score.

`actual-image-contact-sheet.png` was generated from verified raw outputs using scientific plotting, and visually inspected. The three images appear alike at this scale. The ×16 RGB difference panels show isolated q16 pixels and a black q20 panel. Shared-scale HDR panels expose localized q16 hotspots. These observations do not supersede numerical differences.

## Important limits and next evidence needed

Q20's final display equality is NOT geometric/transport identity: independent ray metadata finds70,341 primary ground hits versus70,342 in baseline/q16, with one additional q20 primary character hit. Equal aggregate q16 hits also do not establish query-by-query identity. Full reports retain changed query/counter values, but direct-light shadow-query alignment remains a separate validation task.

This is a geometry representation experiment, where AYFQ metre positions are decoded back into legacy F32 geometry and fed through unchanged floating-point shaders. It does not establish all-fixed lighting/normal behavior, source-linear material appearance, PIE/vector hardware speed, other views/poses/orders, or deployment quality acceptance. Timings are descriptive only.

## Evidence

- Review/execution freeze V2 SHA256:85d6f6fe0da507c7fe6a7128fa05ff2a3de03839ae369cfe83c5c8743e80e4a0
- Original PASS SHA256:0552f8845a73011f406f8fd4b3ef1dd8f53efbcb8aa5d6b9a6628fe2341a753d
- Q16 PASS SHA256:5b4eb63d2cc55d000b32220ace34da9c0ab98cc0d49f0aefeba4870bbfd7320f
- Q20 PASS SHA256:57b338801b509e23c39b3c8e2f631bb93a3c3a88a599b87e6955e27fcebf3b02
- Aggregate `RESULT.json` SHA256:2fb83dfb660826cbd955f204a2adfe3326125a8bb117c9d01d2160b9a8fd0fea

All data/images remain private. No old model/source/gate tree was modified, no denied context was accessed, and no device or public action occurred.
