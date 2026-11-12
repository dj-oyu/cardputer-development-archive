# Read-only RO / device-fit reconciliation

Scope: existing validated fox-v3-aa-phase-overlay only. No new build, SDK, rendering, network, device, public changes, denied owned-context or unfinished paged-BVH material. Source/profile bytes unchanged. This report does not establish device fit.

## Current candidate, not firmware

FINAL_REPORT.md:7–15 establishes completed exact40 validation, unchanged source freeze and named peak491384 B. MEMORY_LEDGER.json:39–48 itemizes render; :86 says 32-bit target ABI unmeasured; :95–98 records unchanged named RO1662416 B and peak491384 B. These are host named payload/stack accounting, with allocator/library/executable/unrelated costs excluded. Do not add the RO to RAM as though all const data must be copied into RAM; conversely do not assume target flash placement from host `r` symbols.

The current product host executable hash is da765f0dd58922d84bb737a00019078f167277e0cf7132b27bd07d8b408faedb (HOST_BINARY_SIZE.json:5). Its host text1914766/data1704/bss16 is not an ESP32 firmware image size. Source freeze SHA256 f08fea4fb0aa67fba4422c919a35ced61484f62218a764b9d367c953b6ef80b6.

## Exact named RO breakdown

Re-read existing build-product objects with `nm -S --size-sort`, same named-array criterion as harness/memory_manifest.py:8–11. This is not relinking or rendering.

- fox_scene_mask_hash: 16 B.
- aa_preflight_targets: 40 B.
- floor_rho: 120 B.
- aa_preflight_rows: 320 B.
- floor_input_rows: 640 B.
- fox_scene_limits: 640 B.
- fox_bg_inputs: 4960 B.
- boundary_identity_bytes: 7930 B.
- agx_lut: 1647750 B.

Total1662416 B = LUT1647750 B + other named arrays14666 B. LUT is99.12% of named RO. This excludes padding, unnamed constants, and other objects' constants.

harness/profile_bridge.c:1–4 includes the exact validated65 u16 implementation from fox-v3-profile-integration-feasibility/build-private/agx_profile.c, and exposes sizeof agx_lut. agx_profile.c:3 includes agx_lut.inc; LUT inc:1–6 fixes65 grid/domain/log range and uint16 array. agx_profile.c:8–14 fixes domain mapping, tetrahedral ordering, 65535 normalization and arithmetic/output clipping. A lower grid/precision, RGB565 table or alternative curve is not an image-preserving storage change. Earlier profile trials provide no new candidate/device-fit claim.

## Existing successful firmware evidence supersedes historical blocked audit

The existing firmware-evidence-independent/cardputer-4a4d-formal-build-evidence-private.zip contains nine evidence files, not the map/ELF/bin themselves. Relevant members are copied byte-for-byte under firmware-evidence/ for exact line references. BUILD_EVIDENCE.json:3 pins4a4d4cf77f6c336971eb271324b34a32b4c2aa01; :34–38 records successful build/size; :45–57 records ESP32-S3,8MB flash,3MiB factory,noPSRAM,8192 main stack, app2601680 B and544048 B remainder. :131–143 gives static DRAM101413 B, IRAM79799 B, DIRAM181212 B, linker remainder160548 B. This is not runtime heap or contiguous free memory.

Crucially :193–197 says this is the OLD mesh basis+sidedness patch, NOT current high-quality transport/AA/HDR/AgX integration. The older fox-v3-firmware-build-audit/build/REPORT.md BLOCKED_NOT_STARTED status and TARGET_REPORT pending4a4d text are historical, not the latest build outcome. Successful old firmware build does not validate current host candidate.

Effective sdkconfig:935 confirms8MB, :1584 disables SPIRAM, :1717 main8192. partitions.csv:4–7 reserves factory0x300000, dictionary0x200000, font0x80000, storage0x270000. All8MiB is allocated; storage is product storage, not free LUT space. Existing cardputer-firmware-main/tools/check_flash.py:19–31 independently enforces physical8MiB, dictionary/font minima and factory<=3MiB, but that older checkout is not a source-identical current firmware proof.

Recorded artifact hashes (BUILD_EVIDENCE.json:151–165): map b0c417b0447daed71c0f6ae58ac7775578219a60ee9aeea47ac4e2a05e298691; ELF58b9a2fea435d3c857701f0fb169ee7ea073d0088d323773b5e79180b9cb56cb; bin b341780d090ce489db09cb20155e265a2aa6523783a6fa1c974b601f957f2c81. These are recorded producer provenance, not independently rehashed local binaries: archive contains none of those binaries/map.

## Fit arithmetic and next useful option

Exact raw LUT1647750 minus old-app remainder544048 =1103702 B short before new renderer code, constants and alignment. All current named RO minus that remainder =1118368 B short, but some other arrays may overlap old data; do not present this as measured integrated overflow. No unchanged direct-addition LUT fit exists against this old factory budget. Removing RAM microbuffers does not solve this flash gap.

Highest-impact image-preserving RO research option: lossless blocked storage of the SAME uint16 LUT, reconstructing identical queried entries and leaving the profile domain/interpolation/arithmetic unchanged. Investigate compression ratio and bounded random-access decoder/cache cost before any render: LUT alone would need to occupy below544048 B (about33.02% of raw, >3.03:1 compression), and real headroom is smaller once decoder/new code/otherRO are included. No ratio, implementation, fit or performance success is claimed here. A full RAM decompression would be counterproductive. A separate data-storage/mapping plan could also preserve exact LUT values, but would consume reserved product storage and needs explicit design/authorization; partition enlargement or feature removal is not a silent optimization.

Before choosing more microcuts, obtain an explicit intended integration source/config and projected code/RO placement, preserving the current image contract. Required missing evidence: actual integrated target ABI/layout and linked sections/bin; exact source-identical profile decoder proof if storage changes; target simultaneous heap/stack lifetimes including runtime/allocator/cache; UI stack/high-water rather than sdkconfig main8192; fresh allocation/contiguity and runtime-work/latency evidence. Historical free36872/largest23552 is a distinct loaded-state observation (harness/memory_manifest.py:22), not a hard cap or current admission gate. Static160548 remainder likewise is not allocatable/current candidate capacity.

No device/render integration action was taken. The host candidate stays exactly as validated.

## SHA256 evidence manifest

- fox-v3-aa-phase-overlay/MEMORY_LEDGER.json: b4ffe508104c8d405797d1e7deec2b95a964cc60e921b078c41fd0a3a7ed4f67
- fox-v3-aa-phase-overlay/FINAL_REPORT.md: bffc8765b66ad2a7bc7435f7ea35f328407cece9afcc46e2e152530245fc893d
- fox-v3-aa-phase-overlay/harness/profile_bridge.c: f202c2730ccdb9bfb9586165c4c57a99eebff3a8ab83f83afc1d9a21c52db166
- fox-v3-aa-phase-overlay/build-product/native_render_row.o: 0831e084226627266a9b46056ec7e647b053d2708e875935ddd2b5a7e25150fa
- fox-v3-aa-phase-overlay/build-product/profile_bridge.o: 9d16e29b6eefb114bd345327767b671420a5e02ce8216099174b8187e380a11e
- fox-v3-profile-integration-feasibility/build-private/agx_profile.c: 219bfd8f602c20017818757aae64220b27f40a48ca7ce7652fff0cbe9c194483
- fox-v3-profile-integration-feasibility/build-private/agx_profile.h: aac146c66df64ad4241de5d34b2fa72f0109fcd0fc99a2214d2214c42da4f894
- fox-v3-profile-integration-feasibility/build-private/agx_lut.inc: 3b4b28704b39cc64942b0be6d69f7e1c1c05a09b2289b3b7850007868e7c0432
- firmware-evidence-independent/cardputer-4a4d-formal-build-evidence-private.zip: 3ad240a3f2c8ec41dae0a88c2cbdbd155b060b4de6f882a1e39a0eca5d4571cb
- fox-v3-device-fit-reconciliation/firmware-evidence/BUILD_EVIDENCE.json: cda356f4ff8940f9179d322c356450d22610847453d17102d26a0d4438f4a006
- fox-v3-device-fit-reconciliation/firmware-evidence/sdkconfig: 695ea5e8f13b8183a3913e796fbcddeb8407a7f5e509a8f066320f8e8ffceb00
- fox-v3-device-fit-reconciliation/firmware-evidence/partitions.csv: 73ad1c0e3f04eca876c49a990fd43f82d5d0d1a9b645d30c8ab1879bd011aba0
- fox-v3-device-fit-reconciliation/firmware-evidence/size-summary.json: 5d6fcedf1e5bd864fc175541f262955b89f87470b8ad0754d0669237bb03e7cc
- fox-v3-device-fit-reconciliation/firmware-evidence/source-provenance.json: 0b93065627c6de97378d871b89bf90e1ca52c038da3463c1dc7a73fb2ecc5bdc
