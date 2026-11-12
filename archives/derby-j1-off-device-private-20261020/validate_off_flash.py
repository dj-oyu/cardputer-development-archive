"""Require committed OFF flash, full readback and bounded expected boot evidence."""
import hashlib
import json
from pathlib import Path
import re

root = Path(__file__).resolve().parent
read = lambda name: json.loads((root/name).read_text())
digest = lambda value: hashlib.sha256(json.dumps(value,sort_keys=True,separators=(',',':')).encode()).hexdigest()
plan = read('off-flash-plan.json')
job = read('off-flash-result.json')
raw = read('off-flash-final-logs.json')
summary = raw['flash_summary']
assert job['state'] == 'succeeded' and job['result'] == 'firmware_flash_completed'
assert job['id'] == plan['plan']['job_id'] and job['plan_hash'] == plan['plan_hash'] == digest(plan['plan'])
assert all(summary[key] is True for key in ('readback_verified','boot_observed','passive_boot_verified','boot_log_matches_expected_artifact'))
assert summary['verification_basis'] == 'full_segment_sha256_readback_and_boot_elf_prefix'
assert summary['target'] == 'esp32s3' and summary['observed_idf_version'] == '6.0.1'
prefix = summary['observed_elf_sha256_prefix']
assert re.fullmatch(r'[a-f0-9]{8,16}',prefix) and plan['plan']['expected_elf_sha256'].startswith(prefix)
assert re.fullmatch(r'[a-f0-9]{64}',summary['last_known_good_receipt'])
assert summary['last_known_good_receipt'] != plan['plan']['lkg_receipt']
assert plan['plan']['lkg_receipt'] == 'db1e10643f69ab8510dfd43df9d4649ddf26f91a03c081910cfec15f6de46a18'
assert summary['boot_text_is_cryptographic_proof'] is False
report = dict(status='OFF_FLASH_COMMITTED_READBACK_BOOT_PASS',flash_job_id=job['id'],flash_plan_hash=job['plan_hash'],
              recovery_ON_receipt=plan['plan']['lkg_receipt'],current_OFF_receipt=summary['last_known_good_receipt'],
              expected_elf_sha256=plan['plan']['expected_elf_sha256'],expected_app_bin_sha256=plan['plan']['expected_app_bin_sha256'],
              readback_verified=True,passive_boot_verified=True,boot_prefix=prefix,
              scope='Full-segment readback plus bounded expected boot evidence; boot text alone is not cryptographic identity.')
(root/'OFF-FLASH-ACCEPTANCE.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report))
