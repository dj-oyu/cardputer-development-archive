"""Validate the provider-revalidated real OFF build proof before any flash."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
ON = ROOT.parent / 'j1-on-off-device-20261020'

def read(path):
    return json.loads(path.read_text())

def digest(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(',', ':')).encode()).hexdigest()

checks = {}
def check(name, value):
    checks[name] = bool(value)
    if not value:
        raise AssertionError(name)

plan = read(ROOT / 'off-build-plan.json')
job = read(ROOT / 'off-build-final-job.json')
response = read(ROOT / 'off-build-manifest.json')
manifest = response['manifest']
on = read(ON / 'on-build-manifest.json')['manifest']
wrapper = manifest['diagnostic_modeproof']
proof = wrapper['proof']
onproof = on['diagnostic_modeproof']['proof']

check('successful_exact_build', job['state'] == 'succeeded'
      and job['result'] == 'firmware_build_succeeded_no_flash'
      and job['id'] == plan['plan']['job_id'] == manifest['build_job_id']
      and job['plan_hash'] == plan['plan_hash'] == manifest['build_plan_hash'])
check('durable_artifacts_verified', response['ok'] is True and response['artifact_status'] == 'verified')
check('source_receipt_full_provenance_identical_to_ON', manifest['source_provenance'] == on['source_provenance'] == plan['plan']['source_provenance'])
check('same_allowed_J1_head', manifest['source_provenance']['commit'] == 'b561aea1c0798feb28055a00d36681fae81ac58a')
check('explicit_OFF_mode_everywhere', plan['plan']['derby_detail_mode'] == manifest['derby_detail_mode'] == wrapper['requested_mode'] == proof['detail_measurement']['mode'] == 'OFF')
check('OFF_native_detail_symbols_absent', proof['detail_measurement']['native_symbols'] == [])
check('same_IDF_target_tools_environment', manifest['idf_version'] == on['idf_version'] == '6.0.1'
      and manifest['target'] == on['target'] == 'esp32s3'
      and manifest['registered_tool_versions'] == on['registered_tool_versions']
      and manifest['environment_fingerprint'] == on['environment_fingerprint'])
check('OFF_fingerprint_separate', manifest['fingerprint'] == plan['plan']['fingerprint'] != on['fingerprint'])
check('proof_canonical_digest_matches', digest(proof) == wrapper['proof_sha256'])
check('proof_schema_and_scope', type(proof['schema_version']) is int and proof['schema_version'] == 1 and proof['hardware_tested'] is False)
mode = proof['build_mode']
onmode = onproof['build_mode']
measure = proof['build_measure']
onmeasure = onproof['build_measure']
# The cache includes the explicit detail switch/build directory, and the fixed
# play chunk removes detail calls in OFF (verify_mode lines133-153). These
# hashes/bytes must change; telemetry/measure modes and linked symbol sets stay.
mode_variable = {'cmake_cache_sha256', 'embedded_play_bytes', 'embedded_play_sha256'}
check('telemetry_measurement_stay_ON', mode['telemetry_mode'] == measure['measure_mode'] == 'ON'
      and {k: v for k, v in mode.items() if k not in mode_variable}
          == {k: v for k, v in onmode.items() if k not in mode_variable}
      and {k: v for k, v in measure.items() if k != 'cmake_cache_sha256'}
          == {k: v for k, v in onmeasure.items() if k != 'cmake_cache_sha256'})
check('expected_cache_and_detail_call_generated_play_difference',
      mode['cmake_cache_sha256'] == measure['cmake_cache_sha256'] != onmode['cmake_cache_sha256']
      and mode['embedded_play_bytes'] < onmode['embedded_play_bytes']
      and mode['embedded_play_sha256'] != onmode['embedded_play_sha256']
      and mode['elf_embedded_play_verified'] is True)
check('fixed_fixture_and_owner_same_except_detail', proof['fixed_workload']['mode'] == 'ON'
      and proof['fixed_workload']['fixture'] == onproof['fixed_workload']['fixture']
      and proof['fixed_workload']['manifest_sha256'] == onproof['fixed_workload']['manifest_sha256']
      and proof['fixed_workload']['native_symbols'] == onproof['fixed_workload']['native_symbols']
      and proof['fixed_workload']['owner_completion'] == {'contract': 'fixed-owner-v1', 'detail_mode': 'OFF', 'record': 'DERBY_DETAIL_EXIT'})
seed = proof['comparison_seed']
check('actual_linked_ELF_seed_and_generated_view_verified', seed['elf_seed_symbol_verified'] is True
      and seed['elf_embedded_view_verified'] is True and seed['hardware_seed'] == '2545F491'
      and seed['mode'] == 'fixed' and seed['saved_race'] == onproof['comparison_seed']['saved_race'])
check('OFF_generated_view_differs_from_instrumented_ON', seed['embedded_view_sha256'] != onproof['comparison_seed']['embedded_view_sha256'])
index = {item['name']: item for item in manifest['artifacts']}
check('unique_artifact_names', len(index) == len(manifest['artifacts']))
check('actual_BIN_ELF_manifest_and_proof_match', all(
    name in index and index[name]['bytes'] == item['bytes'] and index[name]['sha256'] == item['sha256']
    for name, item in proof['artifacts'].items()))
check('OFF_BIN_ELF_distinct_from_ON', all(
    proof['artifacts'][name]['sha256'] != onproof['artifacts'][name]['sha256']
    for name in ('cardputer_pocketjs.bin', 'cardputer_pocketjs.elf')))
check('same_flash_security', manifest['flash_security'] == on['flash_security']
      and manifest['flash_security_summary'] == on['flash_security_summary'])
report = dict(status='OFF_BUILD_PROVIDER_PROOF_ACCEPTED', checks=checks, passed=len(checks),
              build_job_id=job['id'], build_plan_hash=job['plan_hash'], source_commit=manifest['source_provenance']['commit'],
              manifest_sha256=digest(manifest), modeproof_sha256=digest(proof), artifacts=proof['artifacts'],
              local_actual_BIN_ELF_prove_recomputed=False, physical_flash_or_measurement_started=False,
              scope='Provider durable manifest revalidates actual build proof; independent Windows/full r2 CLI remains separately reportable.')
(ROOT / 'OFF-BUILD-ACCEPTANCE.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps({k: report[k] for k in ('status', 'passed', 'build_job_id', 'manifest_sha256', 'modeproof_sha256', 'artifacts')}))
