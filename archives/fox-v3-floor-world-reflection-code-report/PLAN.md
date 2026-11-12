# Isolated floor-world reflection

Base: verified completed floor-display capture, floor direct reflection ON. New world OFF must reproduce that exact renderer's RGB/depth/HDR and old counters. Do not use any stopped/unverified context work.

Only new path is receiver -> first floor hit -> uniform world: rho_receiver * rho_floor * Lworld * miss_fraction / outer16. Use existing fixed cosine direction(), floor_normal(), and vis_ray_nearest() epsilon/far bound/two-sided occlusion. Original Le and direct paths stay intact. New component and world visibility counters are separate. No extra bounce on a blocked ray. Existing scene/binding API is unchanged; no new owned ray context or allocation.

Gate order: synthetic isolated OFF parity plus old regression tests; open/blocked/side/scaling/finite/epsilon/far/budget tests with O2 and ASan+UBSan; measured stack/object sizes; independent review arranged by parent. No full render until gates reviewed. Then exactly ten OFF and ten ON frames with the frozen two views and five conditions, original AA/background events and fixed AgX profile. No threshold/model/ref/sample/profile changes. Failed outputs cannot receive completion manifests.

Old 20M rays / 800M nodes / 300M triangles transport and 1M/100M/50M direct caps remain. New rays consume the same original transport budget. Separate new host work ledger is 64 units per shader and 6272 per eligible first-floor hit (16*256 direction kernel + 16*128 query control +128 reduction/accumulation). These are conservative semantic reservations, not machine instructions, wall time, or admission to the legacy 8M work contract. Old floor work ledger remains unchanged. Work limits are frozen from the existing full geometry bound, never auto-grown.

Existing bounce_result and bounce_counters ABI remain unchanged. The host transport context has an explicit new world-work pointer and separate 3-double last-component for observations; its size increase is reported as resource metadata, never hidden as byte parity. OFF equality applies to numerical/raw output and old counter fields, not the truthful changed context-size metadata.

Code, tests, aggregate measurements, pins and reports only may enter the save allowlist. Geometry, compiled models, snapshots, individual sample records, raw HDR/images/depth/profile tables remain private and excluded. No source blend save/public/upload/PR/device/new SDK.
