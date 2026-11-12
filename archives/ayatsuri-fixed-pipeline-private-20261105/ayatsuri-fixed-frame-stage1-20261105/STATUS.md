# Independent fixed arithmetic stage

Completed arithmetic tests do not constitute a new rendered frame. Existing renderer, visibility, scene lifetime, resource gates and device state are unchanged.

**Model correction:** real-record data in this stage are from the historical standing/lid-8 fixture, not the latest approved fox-bubble-bold.blend. Read ../ayatsuri-fixed-end-to-end-20261105/MODEL_VERSION_NOTICE.md before interpreting results. Latest source identity is d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a; its source inventory/format assessment is separate.

- aa/: exact integer four-slot Q24 sum→Q19 average→profile. All1746 strictly reconstructed old-fixture AA pixels have unchanged RGB565;639 pixels excluded for missing post-background slot radiance. Separate32400 final-HDR-only test changes one green code, not a complete AA/frame replay. Source errors/statuses preserved; width1/2/4/8 and O0/O2 sanitizer tests pass.
- reflection/: integer16-direction arithmetic from old saved raw normals, all7678 accepted, maximum direction error0.00689223degrees. Control-axis ties can create97.18/77.60degree per-index discontinuities in synthetic examples; flags/proof scope explicit. No old ray hit/mask is reused to validate changed directions. Fixed supplied contribution reduction tested separately; actual per-reflection radiance records are absent.
- prepare/: authored old-fixture scene/light data→explicit prepared doubles→integer tables, preserving all51 scene fields and144 disk samples bit-exact before quantization. prepared-baseline-v2.json is authoritative. Ground±100m remains explicitly unsupported by±8m light domain; arbitrary animation/source validation unsupported.
- plan/: staged proven/safe-independent/deferred integration design and corpus inventory. Real integration/query-dependent behavior remains separate work, not hidden inside arithmetic testing.
- radiance-bridge/: checked exact Q19→Q24 scaling and bounded additive radiance merge. 100,000 independent wide-integer oracle cases, widths 1/2/4/8, and O0/O2 sanitizer tests pass. The conservative direct plus reflection maximum exceeds the current AA domain and is explicitly rejected. The synthetic tests do not provide scene/model parity or prove whole-frame connectivity.

All prepared data, models, images and source-derived tables remain private. No target performance, PIE implementation or complete newest-model conversion is claimed.
