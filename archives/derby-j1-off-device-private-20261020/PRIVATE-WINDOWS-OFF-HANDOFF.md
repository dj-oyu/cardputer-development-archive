# Private Windows OFF full CLI handoff

Independent Windows read-only actual prove(build) and all-argument unmodified r2 CLI using these exact OFF records; no new build, flash, ON run or OFF recapture.

```powershell
python -B "$R2Source/tools/games/verify_derby_recorded_trial.py" `
  --build "$ExistingOFFBuild" `
  --raw "$Inputs/trial.log" `
  --transport "$Inputs/transport.json" `
  --manifest "$Inputs/manifest.json" `
  --flash-plan "$Inputs/flash-plan.json" `
  --flash-job "$Inputs/flash-job.json" `
  --flash-summary "$Inputs/flash-summary.json" `
  --collection-plan "$Inputs/collection-plan.json" `
  --collection-job "$Inputs/collection-job.json" `
  --expect-head b561aea1c0798feb28055a00d36681fae81ac58a `
  --expect-detail OFF `
  --out "$NewOutput/verified-off.json"
```

The expected head is the firmware head above. Use the existing actual OFF build and real verifier modules/app ROOT, no test harness/import stub.

| Argument | Cloud original / selection | Byte SHA256 | Selected JSON canonical SHA256 |
|---|---|---|---|
| --raw | off-trial-raw-private.log (whole) | f2aaa18f6766f0f3a858b31c0a23250afaf8ebbc9248267fe2de63d805df1278 | raw bytes only |
| --transport | off-transport-receipt.json (whole) | 5c484421d7bca8df8c39f03634620fc1a2887122ad7d1895c7365fa14ff69638 | 4f3b92cd6877e6afd2f1c96d329cafd3415b7913922b5ec2a5aedb10b65c80fb |
| --manifest | off-build-manifest.json /manifest | f31b5cd375d1f9872ea9d00c9dcb2375e7730494de86de9c38051d0a54b39a3b | 8d49507f59454e6dc5b57901b47d867231f95a1a673e7d2750905efb0d7bf78e |
| --flash-plan | off-flash-plan.json /plan | 7704ac2f6e3aa9d5b792d38b06354fe9667211feddffdbf87945d319493b32ba | f1ebd715c34990c29248f5d00613557d2da24fdb6b7b6f5147fb670fe7ac61bb |
| --flash-job | off-flash-result.json (whole) | 08b9162b15e85578d0dd944191706a90ef5ab2e8aa96789d5f32b6c2d5767416 | 0e079d4ca78e9aa9995e4b7fa339450d4ae240a2fa837dee4d8208ccb1dd668a |
| --flash-summary | off-flash-summary-request-bound.json (whole) | 6fc0f264903bc98fb3efe899b343f8f5f25c8705b3d6486b25cf0fcf3e23ba43 | 04502e00d03b56b5d98d4eb0509364b097b5c8e15e31bae36f5e23b714437790 |
| --collection-plan | off-trial-plan.json /plan | 00d8430b8b1d5333db071b60e8f5dab3b3031facf9fb97786f4ff3459524f24d | 9dd08ec35da89dec184abdbce438cb9abcfc381f4988122f0c8a4bdb5711546d |
| --collection-job | off-trial-result-private.json (whole) | 38d15facced5f5b317bfff522d9ea1890f881ced2504f975da202091ba603682 | c103d13c22440f1275b1431f37848993a63a0c4936a8658157762b6ee49d2d41 |

Compare exact original bytes first. For JSON select only the declared response envelope, then compare canonical JSON with duplicate keys rejected. Preserve boolean/integer types. Retain originals and create separate derived CLI files with source-hash/pointer/output-hash provenance. Raw bytes must not be normalized.

requested_job_id is the caller query context, not an invented server field; retain it separately from the original server response.
