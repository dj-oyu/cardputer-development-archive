# Restore the standalone compressed profile

The saved generic encoded AgX table is `research/private/agx_cube4_rice.bin` (445248 bytes), SHA-256 `ddb92d760c9359008a2c1a8bb179936b196c0e37d1b7f9c2f12d4c71fafcae5e`. It is not a fox image or geometry asset. `PROFILE_CONSTANTS.json` preserves the exact original decimal literals as strings and original evaluator/LUT source hashes. `control/agx_profile.c` and `control/agx_profile.h` preserve the tiny original evaluator and API, but **not** its raw LUT include.

Run `python profile/restore_header.py --blob research/private/agx_cube4_rice.bin` from the backup root, or pass absolute paths. This validates blob length/hash and regenerates `profile/private/profile_data.h`. The generated 1 MB textual header need not be backed up. `profile/candidate_profile.c`, `profile/agx_profile.h`, this header and `research/block_decoder.c` suffice for the standalone candidate. Example:

```
cc -std=c11 -O2 -fno-fast-math -ffp-contract=off -Iprofile -Iprofile/private -shared -fPIC profile/candidate_profile.c research/block_decoder.c profile/batch_bridge.c -lm -o candidate.so
```

The candidate has the original `agx_profile_eval(const float[3],float[3])` interface. Status 0 succeeds, 1 succeeds with high clamp, 2 rejects original invalid input, and 3 rejects decode failure without output writes. This is a standalone API contract, not an integrated renderer callback contract.

## What this backup does not reproduce by itself

- `prepare.py` and `run_compare.py` are records of the original workspace procedure and refer to its pinned baseline files. The raw original LUT include is excluded. The encoded blob can reconstruct every original uint16 value, but regenerated formatting is not a substitute for the original include's source hash or provenance.
- The 84981 retained holdout inputs, original holdout oracle, all retained40 raw double HDR/final565 buffers, generated synthetic NPZ, combined float replay file and compiled binaries are excluded. Their paths/hashes and per-group/per-frame results remain in the reports. The backup alone cannot rerun the reported retained40 comparison or official accuracy gates.
- The generated synthetic corpus includes baseline holdouts, so `prepare.py` is not self-contained without the original workspace. New standalone codec tests can use the saved blob and generic decoder, but must not be mislabeled as the historical full-profile validation.
- No original source images or geometry are needed or included. No physical rerender occurred. No SDK, target/device test, renderer storage-admission change or target fit claim is included.

`RESULTS-O2.json`, `RESULTS-O0.json`, sanitizer logs, `WORK_COUNTS.json`, `BENCHMARK.json` when present, and the separate independent review are historical measured evidence. Original input hashes were checked before and after comparison. Exact integer losslessness and observed profile parity do not establish cross-compiler/target floating equivalence.

The successful sanitizer replay used `ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1 profile/build-sanitize/compare profile/private/all_inputs.f32le`. The saved `run_sanitizers.sh` now defaults to these options (overridable), while retaining the failed LeakSanitizer log as an environment limitation. Its full historical replay still needs the excluded corpus.
