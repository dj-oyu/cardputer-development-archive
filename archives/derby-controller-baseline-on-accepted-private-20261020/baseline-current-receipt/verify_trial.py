#!/usr/bin/env python3
"""Verify saved baseline flash/trial evidence only; never access the device."""
from pathlib import Path
import base64
import hashlib
import json
import re
import subprocess
import sys

root = Path(__file__).resolve().parent
repo = Path('/workspace/derby-controller-baseline')
head = 'dc2c5e044429a4904e91564aa7f9cb30d7d4cbbb'
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=repo, text=True).strip() == head
sys.path.insert(0, str(repo / 'tools/games'))
from derby_fixed_result import parse_collected
from derby_detail_result import parse_detail

inputs = {}
def read(name):
    data = (root / name).read_bytes()
    inputs[name] = hashlib.sha256(data).hexdigest()
    return json.loads(data)

fp = read('flash-plan.json')['result']
fj = read('flash-result.json')
fl = read('flash-final-logs.json')
tp = read('trial-plan.json')['result']
tj = read('trial-result.json')
release = read('release.json')
status = read('status-final.json')
manifest = read('preflight-baseline_manifest.json')['manifest']
assert manifest['source_provenance']['commit'] == head
assert manifest['build_job_id'] == fp['plan']['build_job_id'] == 'derby-controller-baseline-build-dc2c5e04-20261020'
assert hashlib.sha256(json.dumps(manifest, sort_keys=True, separators=(',', ':')).encode()).hexdigest() == fp['plan']['manifest_sha256']
assert fj['state'] == 'succeeded' and fj['result'] == 'firmware_flash_completed'
assert fj['plan_hash'] == fp['plan_hash'] and fj['id'] == fp['plan']['job_id']
summary = fl['flash_summary']
assert all(summary[k] is True for k in ['readback_verified', 'passive_boot_verified', 'boot_observed', 'boot_log_matches_expected_artifact'])
assert summary['verification_basis'] == 'full_segment_sha256_readback_and_boot_elf_prefix'
assert fp['plan']['expected_elf_sha256'].startswith(summary['observed_elf_sha256_prefix'])
assert summary['observed_idf_version'] == '6.0.1'
assert re.fullmatch('[a-f0-9]{64}', summary['last_known_good_receipt'])
assert fp['plan']['lkg_receipt'] == read('preflight-batch_recovery.json')['flash_summary']['last_known_good_receipt']
assert tp['plan']['test'] == 'derby_fixed_workload'
assert tp['plan']['protocol'] == 'pocketjs-derby-fixed-v2'
assert tp['plan']['fixed_workload']['terminal_contract'] == 'end_owner_exit_stop_home_v2'
assert tp['plan']['fixed_workload']['retry'] == 0
assert tp['plan']['fixed_workload']['repetitions'] == 3
assert tp['plan']['fixed_workload']['max_seconds'] == 200
assert tj['state'] == 'succeeded' and tj['result'] == 'derby_fixed_trial_verified' and tj['stage'] == 'serial_close'
assert tj['plan_hash'] == tp['plan_hash'] and tj['id'] == tp['plan']['job_id']
t = tj['fixed_trial']
assert t['available'] and t['valid'] and t['historical_valid'] and t['terminal_success_verified']
assert t['terminal_contract'] == 'owner_exit_v2' and t['validation_error'] is None
binding = t['binding']
assert binding['job_id'] == tj['id'] and binding['plan_hash'] == tj['plan_hash']
assert binding['principal_id'] == fp['plan']['flash_principal'] == 'ephemeral:remote_mcp'
assert fp['plan']['device_fingerprint'] == tp['plan']['device_fingerprint'] == binding['device_fingerprint']
assert fp['plan']['session_id'] == tp['plan']['session_id']
assert fp['plan']['broker_epoch'] == tp['plan']['broker_epoch'] == binding['broker_epoch']
assert fj['finished'] <= tj['created'] < tj['finished']
raw = base64.b64decode(t['raw_base64'], validate=True)
assert raw == (root / 'trial-raw-private.log').read_bytes()
parsed = parse_collected(raw, t['receipt'])
assert parsed == t['parsed'] and parsed['variant'] == 'baseline'
detail = parse_detail(raw.decode('ascii'), expected=True)
assert len(detail) == 3
assert release == {'ok': True, 'released': True}
assert status['active_job'] is None and status['profile_active_job'] is None and status['owner'] is None
assert all(status[k] == 0 for k in ['queue_depth', 'profile_queue_depth', 'wait_queue_depth', 'work_session_count', 'lease_remaining_seconds'])
assert all(status[k] is False for k in ['execution_uncertain', 'ownership_uncertain', 'profile_uncertain'])
old = (root / 'prior-batch-failure-raw-private.log').read_bytes()
assert len(old) == 902 and hashlib.sha256(old).hexdigest() == '92b8e47e55c6aeeccc57e2e622154319b5c243499613418bb14b7020ca8232f6'
lines = raw.decode('ascii').splitlines()
positions = {name: [i+1 for i, line in enumerate(lines) if name in line] for name in ['DERBY_FIXED_END', 'DERBY_DETAIL_EXIT', 'APP_STOPPED', 'HOME_READY']}
assert all(len(pos) == 1 for pos in positions.values())
assert [pos[0] for pos in positions.values()] == sorted(pos[0] for pos in positions.values())
result = {
    'strict_pass': True, 'head': head, 'flash_job': fj['id'], 'measurement_job': tj['id'],
    'raw_sha256': hashlib.sha256(raw).hexdigest(), 'raw_bytes': len(raw),
    'receipt': t['receipt'], 'markers_lines_1based': positions,
    'work_us': [int(r['work_us']) for r in parsed['repetitions']],
    'quality': [r['quality'] for r in parsed['repetitions']],
    'valid': [r['valid'] for r in parsed['repetitions']],
    'detail': detail, 'device_boots': 1, 'dependent_replays': 3,
    'independent_trials': False, 'target_off_overhead_control': False,
    'physical_lcd_attested': False, 'old_batch_failure_preserved': True,
    'quiet_close_basis': 'Provider v2 complete transport and verified owner exit committed after serial close; not inferred from quality fields alone',
    'input_sha256': inputs,
}
(root / 'ACCEPTANCE.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps({k: v for k, v in result.items() if k not in ['detail', 'input_sha256']}))
