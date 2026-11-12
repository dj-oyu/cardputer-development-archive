#!/usr/bin/env python3
"""Fixed 99-case read-only host regression; no device or artifact proof.

Fixture contents are read only. Mutations use bytes/deepcopy in memory.
The imported prove symbol is an unused, fail-closed import stub.
"""
import sys

sys.dont_write_bytecode = True

import argparse
import base64
import copy
import hashlib
import importlib
import json
from pathlib import Path
import re
import types


FIXED_CASE_COUNT = 99
FIXED_CASESET_SHA256 = '05a7424b811f988135dc190acf047c264fb0401e1a759fd3dee4fd3b303ab36e'
TYPED_FIELDS = (
    'schema_version', 'principal_id', 'device_id', 'device_fingerprint',
    'flash_job_id', 'flash_plan_hash', 'firmware_receipt', 'build_job_id',
    'build_plan_hash', 'source_receipt', 'source_commit', 'manifest_sha256',
    'modeproof_sha256', 'derby_detail_mode', 'expected_elf_sha256',
    'expected_app_bin_sha256',
)


def sha(data):
    return hashlib.sha256(data).hexdigest()


def digest(value):
    return sha(json.dumps(value, sort_keys=True, separators=(',', ':')).encode())


def snapshot(directory):
    return {str(p.relative_to(directory)): sha(p.read_bytes())
            for p in sorted(directory.rglob('*')) if p.is_file()}


def load_json(path):
    return json.loads(path.read_text())


def build_cases(context):
    """Exactly the first independent review's mutations and order."""
    cases = []
    raw = context['raw']

    def add(name, current, expected_accept=False):
        cases.append((name, current, expected_accept))

    def bind_raw(data):
        current = copy.deepcopy(context)
        current['raw'] = data
        current['transport']['bytes'] = len(data)
        current['transport']['sha256'] = sha(data)
        record = current['collection_job']['fixed_trial']
        record['raw_base64'] = base64.b64encode(data).decode()
        record['receipt'] = copy.deepcopy(current['transport'])
        return current

    add('actual_ON_host_metadata', copy.deepcopy(context), True)
    bare = re.sub(rb'I \([0-9]+\) (?:app|js): (?=(?:APP_ID|DERBY READY))', b'', raw)
    add('canonical_bare_identity_ready', bind_raw(bare), True)
    lines = raw.splitlines(keepends=True)
    identity = next(x for x in lines if b'APP_ID' in x)
    ready = next(x for x in lines if b'DERBY READY' in x)
    end = next(x for x in lines if x.startswith(b'DERBY_FIXED_END'))
    owner = next(x for x in lines if x.startswith(b'DERBY_DETAIL_EXIT'))
    stop = next(x for x in lines if b'APP_STOPPED' in x)
    home = next(x for x in lines if b'HOME_READY' in x)
    mutations = {
        'id_wrong_tag': raw.replace(identity, identity.replace(b'app:', b'js:'), 1),
        'ready_wrong_tag': raw.replace(ready, ready.replace(b'js:', b'app:'), 1),
        'id_prefix': raw.replace(identity, b'X' + identity, 1),
        'id_suffix': raw.replace(identity, identity.rstrip(b'\r\n') + b'X\n', 1),
        'ready_prefix': raw.replace(ready, b'X' + ready, 1),
        'ready_suffix': raw.replace(ready, ready.rstrip(b'\r\n') + b'X\n', 1),
        'id_timestamp_negative': raw.replace(identity, re.sub(rb'\([0-9]+\)', b'(-1)', identity), 1),
        'ready_timestamp_decimal': raw.replace(ready, re.sub(rb'\([0-9]+\)', b'(1.0)', ready), 1),
        'duplicate_id': raw + identity,
        'duplicate_ready': raw + ready,
        'missing_id': raw.replace(identity, b'', 1),
        'missing_ready': raw.replace(ready, b'', 1),
        'missing_owner': raw.replace(owner, b'', 1),
        'duplicate_owner': raw + owner,
        'owner_wrong_session': raw.replace(owner, re.sub(rb'session=[0-9]+', b'session=99999999', owner), 1),
        'owner_prefix': raw.replace(owner, b'X' + owner, 1),
        'owner_suffix': raw.replace(owner, owner.rstrip(b'\r\n') + b'X\n', 1),
        'stop_before_owner': raw.replace(owner, b'', 1).replace(stop, stop + owner, 1),
        'home_before_stop': raw.replace(home, b'', 1).replace(stop, home + stop, 1),
        'end_after_owner': raw.replace(end, b'', 1).replace(owner, owner + end, 1),
        'duplicate_end': raw + end,
        'duplicate_stop': raw + stop,
        'duplicate_home': raw + home,
        'stop_wrong_tag': raw.replace(stop, stop.replace(b'app:', b'js:'), 1),
        'home_wrong_tag': raw.replace(home, home.replace(b'shell:', b'app:'), 1),
        'late_fault_after_HOME': raw + b'InternalError: interrupted\n',
        'fault_after_END': raw.replace(end, end + b'Guru Meditation\n', 1),
        'partial_tail': raw[:-1],
        'extra_spoof_stop_prefix': raw + b'XAPP_STOPPED\n',
        'extra_spoof_home_suffix': raw + b'HOME_READYX\n',
        'extra_spoof_end_prefix': raw + b'XDERBY_FIXED_END v=1\n',
    }
    for name, data in mutations.items():
        add(name, bind_raw(data))

    for key in ('gaps', 'overflow', 'truncated', 'partial_tail', 'disconnect', 'reset', 'refused'):
        current = copy.deepcopy(context)
        current['transport'][key] = True
        current['collection_job']['fixed_trial']['receipt'] = copy.deepcopy(current['transport'])
        add('transport_' + key, current)
    for key, value in [('bytes', len(raw) + 1), ('sha256', '0' * 64),
                       ('complete', False), ('duration_ms', 200001)]:
        current = copy.deepcopy(context)
        current['transport'][key] = value
        current['collection_job']['fixed_trial']['receipt'] = copy.deepcopy(current['transport'])
        add('transport_' + key, current)

    changes = [
        ('raw_export_mismatch', ('collection_job', 'fixed_trial', 'raw_base64'), base64.b64encode(raw + b'\n').decode()),
        ('receipt_export_mismatch', ('collection_job', 'fixed_trial', 'receipt', 'sha256'), '0' * 64),
        ('collector_expected_elf', ('collection_job', 'fixed_trial', 'binding', 'expected_firmware_sha256'), '0' * 64),
        ('collector_planhash', ('collection_job', 'fixed_trial', 'binding', 'plan_hash'), '0' * 64),
        ('collector_jobid', ('collection_job', 'fixed_trial', 'binding', 'job_id'), 'other'),
        ('collector_epoch', ('collection_job', 'fixed_trial', 'binding', 'broker_epoch'), 'other'),
        ('collector_device', ('collection_job', 'fixed_trial', 'binding', 'device_fingerprint'), 'other'),
        ('collector_principal', ('collection_job', 'fixed_trial', 'binding', 'principal_id'), 'other'),
        ('flash_job_planhash', ('flash_job', 'plan_hash'), '0' * 64),
        ('collection_job_planhash', ('collection_job', 'plan_hash'), '0' * 64),
        ('flash_unsuccessful', ('flash_job', 'state'), 'failed'),
        ('collector_unsuccessful', ('collection_job', 'state'), 'failed'),
        ('flash_summary_request', ('flash_summary', 'requested_job_id'), 'other'),
        ('flash_receipt_current', ('flash_summary', 'flash_summary', 'last_known_good_receipt'), '0' * 64),
        ('proof_mode', ('proof', 'detail_measurement', 'mode'), 'OFF'),
        ('source_commit', ('manifest', 'source_provenance', 'commit'), '0' * 40),
        ('source_receipt', ('manifest', 'source_provenance', 'source_receipt'), '0' * 64),
    ]
    for name, path, value in changes:
        current = copy.deepcopy(context)
        target = current
        for key in path[:-1]:
            target = target[key]
        target[path[-1]] = value
        add(name, current)

    def rehash_collection_plan(current):
        job = current['collection_job']
        job['plan_hash'] = digest(current['collection_plan'])
        job['fixed_trial']['binding']['plan_hash'] = job['plan_hash']

    for location in ('plan', 'record'):
        for key in TYPED_FIELDS:
            old = context['collection_plan']['collector_binding'][key]
            current = copy.deepcopy(context)
            binding = (current['collection_plan']['collector_binding'] if location == 'plan'
                       else current['collection_job']['fixed_trial']['binding']['flash_receipt'])
            binding[key] = 2 if isinstance(old, int) else ('OFF' if key == 'derby_detail_mode' else '0' * len(old))
            rehash_collection_plan(current)
            add('typed_' + location + '_' + key, current)

    for name, key in [('session', 'session_id'), ('epoch', 'broker_epoch')]:
        current = copy.deepcopy(context)
        current['collection_plan'][key] = 'other'
        rehash_collection_plan(current)
        if key == 'broker_epoch':
            current['collection_job']['fixed_trial']['binding']['broker_epoch'] = 'other'
        add('cross_plan_' + name, current)

    current = copy.deepcopy(context)
    current['collection_plan']['collector_binding']['schema_version'] = True
    current['collection_job']['fixed_trial']['binding']['flash_receipt']['schema_version'] = True
    rehash_collection_plan(current)
    add('typed_schema_bool', current)
    for key in ('protocol_parser_commit', 'device_reported_session', 'installed_boot_source_image'):
        current = copy.deepcopy(context)
        old = current['collection_job']['fixed_trial']['binding'][key]
        current['collection_job']['fixed_trial']['binding'][key] = '0' * len(old)
        add('binding_' + key, current)
    return cases


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--parser-dir', type=Path, required=True)
    parser.add_argument('--fixture-root', type=Path, required=True)
    parser.add_argument('--out', type=Path, required=True)
    parser.add_argument('--reference-review', type=Path,
                        help='Optional prior review JSON; verifies all fixed case names/expectations.')
    args = parser.parse_args()
    parser_dir = args.parser_dir.resolve(strict=True)
    fixture_root = args.fixture_root.resolve(strict=True)
    output = args.out.resolve()
    if output.is_relative_to(fixture_root) or output.is_relative_to(parser_dir):
        raise SystemExit('Output must be outside fixture-root and parser-dir.')
    if not output.parent.is_dir() or output.exists():
        raise SystemExit('Output parent must exist; output must be a new file.')

    fixed = load_json(Path(__file__).with_name('fixed-cases.json'))
    if len(fixed) != FIXED_CASE_COUNT or digest(fixed) != FIXED_CASESET_SHA256:
        raise SystemExit('Fixed case list changed; refusing to run.')
    if args.reference_review:
        reference = [{'case': x['case'], 'expected_accept': x['expected_accept']}
                     for x in load_json(args.reference_review)['cases']]
        if fixed != reference:
            raise SystemExit('Fixed cases differ from prior review; refusing to run.')

    fixture_before = snapshot(fixture_root)
    parser_before = snapshot(parser_dir)
    stub = types.ModuleType('verify_diagnostic_build')
    prove_calls = []

    def forbidden_prove(*args, **kwargs):
        prove_calls.append(True)
        raise RuntimeError('Actual BIN/ELF prove is unavailable and must not be called.')

    stub.prove = forbidden_prove
    sys.modules['verify_diagnostic_build'] = stub
    sys.path.insert(0, str(parser_dir))
    module = importlib.import_module('verify_derby_recorded_trial')
    if Path(module.__file__).resolve() != parser_dir / 'verify_derby_recorded_trial.py':
        raise SystemExit('Wrong parser module imported.')

    def read(name):
        return load_json(fixture_root / name)

    manifest = read('on-build-manifest.json')['manifest']
    context = dict(
        raw=(fixture_root / 'on-trial-raw-private.log').read_bytes(),
        transport=read('on-transport-receipt.json'),
        proof=manifest['diagnostic_modeproof']['proof'], manifest=manifest,
        flash_plan=read('on-flash-plan.json')['plan'],
        flash_job=read('on-flash-result.json'),
        flash_summary=read('on-flash-summary-request-bound.json'),
        collection_plan=read('on-trial-plan.json')['plan'],
        collection_job=read('on-trial-result-private.json'),
    )
    cases = build_cases(context)
    generated = [{'case': name, 'expected_accept': expectation}
                 for name, _, expectation in cases]
    if generated != fixed:
        raise SystemExit('Generated cases differ from the fixed 99; refusing to run.')

    results = []
    for name, current, expected_accept in cases:
        try:
            module.verify_recorded_trial(
                **current, expected_head=manifest['source_provenance']['commit'], expected_detail='ON')
            accepted, exception_type = True, None
        except Exception as error:
            # Never serialize exception text: imported code may include private content.
            accepted, exception_type = False, type(error).__name__
        results.append(dict(case=name, expected_accept=expected_accept, accepted=accepted,
                            matched=accepted == expected_accept, exception_type=exception_type))

    fixture_after = snapshot(fixture_root)
    parser_after = snapshot(parser_dir)
    report = dict(
        scope='Fixed memory-only host metadata function regression; no device/network/API or CLI artifact proof.',
        cases=results, case_count=len(results), positive_cases=sum(x['expected_accept'] for x in results),
        negative_cases=sum(not x['expected_accept'] for x in results),
        fixed_cases_sha256=digest(fixed),
        case_list_matches_reference_review=True if args.reference_review else None,
        unexpected_accepts=[x['case'] for x in results if x['accepted'] and not x['expected_accept']],
        unexpected_rejects=[x['case'] for x in results if not x['accepted'] and x['expected_accept']],
        fixture_hashes_before=fixture_before, fixture_hashes_after=fixture_after,
        parser_hashes_before=parser_before, parser_hashes_after=parser_after,
        fixtures_unchanged=fixture_before == fixture_after, parser_unchanged=parser_before == parser_after,
        prove_stub_unused=not prove_calls, actual_BIN_ELF_prove_recomputed=False,
        production_module_authorship='Harness author did not modify production parser files.',
    )
    report['passed'] = (all(x['matched'] for x in results) and report['fixtures_unchanged']
                        and report['parser_unchanged'] and report['prove_stub_unused'])
    with output.open('x') as stream:
        json.dump(report, stream, indent=2)
        stream.write('\n')
    print(json.dumps({key: report[key] for key in (
        'passed', 'case_count', 'positive_cases', 'negative_cases', 'fixed_cases_sha256',
        'unexpected_accepts', 'unexpected_rejects', 'fixtures_unchanged',
        'parser_unchanged', 'prove_stub_unused', 'actual_BIN_ELF_prove_recomputed')}))
    return 0 if report['passed'] else 1


if __name__ == '__main__':
    sys.exit(main())
