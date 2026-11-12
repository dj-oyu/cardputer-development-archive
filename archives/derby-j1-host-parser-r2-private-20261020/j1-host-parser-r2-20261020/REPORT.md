# Host parser r2 — fixed99 and independent review passed

Two host-only production files were minimally changed in this isolated directory. The original98files, old candidate, private raw/receipt and old reviews remain unchanged. No firmware source head, ON rerun, OFF, device, API, build or deployment operation occurred.

Changes:
- Retain anchored app-tag APP_ID and js-tag DERBY READY timestamp forms and canonical bare forms.
- Reject an additional malformed END/STOP/HOME token even beside the otherwise valid marker.
- Require integer schema_version types, rejecting bool-as-int in proof/manifest and both typed flash bindings.
- Verify protocol_parser_commit against the strict collector plan and reported session against the parsed raw trial.
- Require the capture's installed_boot_source_image classification to remain unverified. Verified flash receipt identity is checked separately; the capture label does not upgrade itself to installed-image attestation.

Production files:
parser/derby_fixed_completion.py SHA256237c43498778333a939a7481249d1f13a7b97ddd8127723e7af6b3b420ac29ed
parser/verify_derby_recorded_trial.py SHA256a8d93c6656a850f577d7397a71ac5e597feaf22a25ea6ce1774166e589154b12

Reviewable diffs:
- host-parser-r2-from-J1.patch applies the complete host compatibility/hardening change to the exact J1 host helpers.
- host-parser-r2-from-candidate.patch contains only changes after the previous candidate.

Regression evidence:
- CASESET.json and regression/fixed-cases.json retain all99case names, order and expected acceptance. File SHA2561e70b87a1a095aace729d89d6a476f64a312ecccff154366d4d2f14e3d7da70e.
- The unchanged generator regression/run_regression.py SHA256996f19b870a1d9244ec6c18dd1de8a09df3c787c06219ed48b173b7f8b77b3e3 reproduces every previous candidate decision, including the same7unexpected accepts.
- The same99cases on r2:2positive passes,97negative rejections, no unexpected accept or reject.
- No negative case was removed, expectation relaxed or raw/receipt rewritten. Mutations are bytes/deepcopy in memory.
- Regression JSON records parser/fixture before/after hashes. Independent reviewer authored the fixed harness and review but did not edit the two production files; root is the sole production writer.
- regression/independent-r2-review.md/json records patch review PASS, no additional finding and all original98hashes/old review/private archive hashes unchanged.

Reproduction:
Use regression/README.md and pass parser directory, private fixture root and output report path to the fixed harness. Only output reports are written; sys.dont_write_bytecode=True. The private fixture is the existing original folder /workspace/derby-evidence/j1-on-off-device-20261020, not a copy in this package. Authoritative private source archive remains Library libfile_2dd1cf06c1348191985e243fb0a3dcf1 v2 / file_00000000925481f5b6e33130ff57a9ff / ZIP SHA256b3cff8d916aeb87a7bebfef59fb7fda0598d3f6d06cfc00d7855e83e318cc97b.

Scope:
This passes the fixed99host metadata/function gate and independent patch review. The unused prove import remains a fail-closed stub; actual BIN/ELF prove and full CLI were not executed because image bodies are not locally exported. Hardware acceptance and full ON/OFF comparison are not claimed. OFF is not started by this task.

No publication, push, PR or CI trigger was performed. Validation outputs and operational evidence remain private. If later publishing, use general code and synthetic fixtures only; exclude private operational records and hashes.

