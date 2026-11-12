#!/usr/bin/env python3
"""Verify saved v2 transport with the exact firmware tree's existing strict parser.

Local analysis only: never opens hardware, changes configuration, or strips logs.
"""
import argparse
import base64
import hashlib
import json
from pathlib import Path
import sys

p = argparse.ArgumentParser()
p.add_argument('--variant', choices=('baseline', 'native', 'batch'), required=True)
p.add_argument('--repo', type=Path, required=True)
p.add_argument('--evidence', type=Path, default=Path(__file__).resolve().parent)
a = p.parse_args()
b = a.evidence.resolve()
v = a.variant
def read(name):
    return json.loads((b / f'{v}-{name}.json').read_text())

build = read('source-build-proof')
plan = read('fixed-plan')
job = read('fixed-result')
proof = build['proof']
assert build['verified'] is True
assert proof['detail_measurement']['mode'] == 'ON'
assert 'df_detail_exit_record' in proof['fixed_workload']['native_symbols']
assert plan['plan']['test'] == 'derby_fixed_workload'
assert plan['plan']['protocol'] == 'pocketjs-derby-fixed-v2'
assert plan['plan']['fixed_workload']['terminal_contract'] == 'end_owner_exit_stop_home_v2'
assert job['plan_hash'] == plan['plan_hash']
assert job['id'] == plan['plan']['job_id']
assert job['state'] == 'succeeded'
trial = job['fixed_trial']
assert trial['available'] is True and trial['valid'] is True
assert trial['terminal_success_verified'] is True
# The immutable plan names the full sequence; the current readback envelope uses
# the distinct owner_exit_v2 enum (derby_reports.py at the deployed exact commit).
assert trial['terminal_contract'] == 'owner_exit_v2'
assert not trial.get('validation_error')
raw = base64.b64decode(trial['raw_base64'], validate=True)
receipt = trial['receipt']
assert receipt['complete'] is True
assert receipt['bytes'] == len(raw) <= 65536
assert 0 <= receipt['duration_ms'] <= 200000
assert raw.endswith(b'\n')
assert all(len(line) + 1 <= 1024 for line in raw.split(b'\n')[:-1])
assert all(receipt[k] is False for k in (
    'disconnect', 'gaps', 'overflow', 'partial_tail', 'refused', 'reset', 'truncated'))
assert receipt['sha256'] == hashlib.sha256(raw).hexdigest()
# Preserve every captured byte, including prefix/trailer and unrelated diagnostics.
(b / f'{v}-trial.log').write_bytes(raw)
sys.path.insert(0, str(a.repo.resolve() / 'tools/games'))
from derby_fixed_result import parse_trial
from derby_detail_result import parse_detail, SCHEMA
coarse = parse_trial(raw, transport_complete=True)
detail = parse_detail(raw.decode('ascii'), expected=True)
assert coarse['variant'] == v
assert len(detail) == len(coarse['repetitions']) == 3
result = {
    'strict_pass': True, 'variant': v,
    'source_commit': build['source']['commit'],
    'source_tree': build['source']['tree_sha1'],
    'build_job_id': build['job']['id'], 'job_id': job['id'],
    'plan_hash': plan['plan_hash'], 'protocol': plan['plan']['protocol'],
    'terminal_contract': trial['terminal_contract'],
    'terminal_success_verified': True,
    'receipt': receipt, 'session': coarse['session'],
    'coarse': coarse, 'detail': detail,
    'stages': SCHEMA['stages'], 'events': SCHEMA['events'],
    'device_boots': 1, 'dependent_replays': 3,
    'limits': 'Elapsed includes owner preemption/wait; logical bytes are not bus traffic. '
              'Fixed receipt alone does not authenticate installed image; retain separate '
              'verified flash/readback and exclusive ownership chain. No target OFF control.'
}
(b / f'{v}-strict-result.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps({'strict_pass': True, 'variant': v, 'bytes': len(raw),
                  'sha256': receipt['sha256'], 'work_us': [int(r['work_us'])
                      for r in coarse['repetitions']], 'dependent_replays': 3}))
