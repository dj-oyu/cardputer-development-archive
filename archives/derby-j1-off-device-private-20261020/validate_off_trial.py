"""Strict original r2 function gate for the actual OFF export, no device/prove."""
from pathlib import Path
import hashlib
import json
import sys

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parent
EVIDENCE = ROOT.parent
PARSER = EVIDENCE / 'j1-host-parser-r2-20261020/parser'
SUPPORT = EVIDENCE / 'j1-r2-original-cli-20261020/support-reference'
sys.path[:0] = [str(PARSER), str(SUPPORT)]
import verify_derby_recorded_trial as r2

sha = lambda data: hashlib.sha256(data).hexdigest()
assert sha((PARSER/'verify_derby_recorded_trial.py').read_bytes()) == 'a8d93c6656a850f577d7397a71ac5e597feaf22a25ea6ce1774166e589154b12'
assert sha((PARSER/'derby_fixed_completion.py').read_bytes()) == '237c43498778333a939a7481249d1f13a7b97ddd8127723e7af6b3b420ac29ed'
assert r2.prove.__module__ == 'verify_diagnostic_build'
assert sha(Path(sys.modules['verify_diagnostic_build'].__file__).read_bytes()) == '8f37cdb0600e78d31160780048323f0d9268cb0ab1d499ca104d91e5776a902b'
read = r2.read_json
manifest_response = read(ROOT/'off-build-manifest.json')
assert manifest_response['artifact_status'] == 'verified'
manifest = manifest_response['manifest']
proof = manifest['diagnostic_modeproof']['proof']
assert r2.digest(proof) == manifest['diagnostic_modeproof']['proof_sha256']
raw = (ROOT/'off-trial-raw-private.log').read_bytes()
result = r2.verify_recorded_trial(raw, read(ROOT/'off-transport-receipt.json'), proof, manifest,
    read(ROOT/'off-flash-plan.json')['plan'], read(ROOT/'off-flash-result.json'),
    read(ROOT/'off-flash-summary-request-bound.json'), read(ROOT/'off-trial-plan.json')['plan'],
    read(ROOT/'off-trial-result-private.json'),
    expected_head='b561aea1c0798feb28055a00d36681fae81ac58a', expected_detail='OFF')
assert result['recorded_chain_matches'] is True and result['detail'] == []
(ROOT/'OFF-R2-FUNCTION-RESULT.json').write_text(json.dumps(result, indent=2)+'\n')

# Reuse accepted ON raw and owner transport records; no ON acquisition rerun.
onroot = EVIDENCE/'j1-on-off-device-20261020'
onraw = (onroot/'on-trial-raw-private.log').read_bytes()
assert sha(onraw) == 'f436833a2e6b3eb50492691f141ff13fd67607f6ce1df0755c2f457419523670'
ontrial = r2.parse_collected(onraw, read(onroot/'on-transport-receipt.json'))
offtrial = result['trial']
assert ontrial['variant'] == offtrial['variant']
keys = ('fixture','manifest','variant','rep','seq','valid','quality','independent','seed','oval','tier','cam',
        'start','end','contexts','done','capture','faults','refused','tx_fail','finish') + tuple(f'c{i}' for i in range(10))
for on, off in zip(ontrial['repetitions'], offtrial['repetitions'], strict=True):
    assert all(on[k] == off[k] for k in keys)
    assert all(on[f's{i}'].split(':')[1] == off[f's{i}'].split(':')[1] for i in (1,2,3))
onwork = [int(x['work_us']) for x in ontrial['repetitions']]
offwork = [int(x['work_us']) for x in offtrial['repetitions']]
onmean, offmean = sum(onwork)/3, sum(offwork)/3
comparison = dict(status='OFF_STRICT_R2_FUNCTION_AND_FIXED_WORK_PARITY_PASS',
    source_commit=result['source_commit'], detail_mode='OFF', variant=offtrial['variant'],
    ON_work_us=onwork, OFF_work_us=offwork, ON_mean_work_us=onmean, OFF_mean_work_us=offmean,
    ON_minus_OFF_mean_work_us=onmean-offmean,
    observed_ON_over_OFF_percent=(onmean/offmean-1)*100,
    fixed_identity_work_race_counters_and_native_build_calls_identical=True,
    OFF_detailed_records=0, owner_STOP_HOME_verified=True,
    original_r2_function_executed=True, prove_stub_or_monkeypatch_used=False,
    provider_actual_build_modeproof_verified=True, local_actual_BIN_ELF_prove_recomputed=False,
    original_full_build_CLI_executed_here=False,
    scope='Actual OFF raw/owner receipt/typed flash chain; three dependent reps per mode, descriptive elapsed-work comparison only.',
    limits=['Provider real-build proof is used; independent Windows full actual-prove/r2 CLI remains separately reportable.',
            'Work time is elapsed and can include preemption; it is not pure bus transfer time.',
            'Counters describe logical work, not direct wire traffic or physical LCD pixel acceptance.'])
(ROOT/'ON-OFF-COMPARISON.json').write_text(json.dumps(comparison, indent=2)+'\n')
print(json.dumps({k: comparison[k] for k in ('status','ON_work_us','OFF_work_us','observed_ON_over_OFF_percent','original_full_build_CLI_executed_here')}))
