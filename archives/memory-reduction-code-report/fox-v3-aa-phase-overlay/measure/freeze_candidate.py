from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-segmented-model-arena';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();load=lambda p:json.loads(p.read_text())
base=load(R/'BASE_SOURCE_FREEZE.json');changed=[p for p,h in base['files'].items() if sha(R/p)!=h]
allowed={'code/ksn_bounded_ring.h','code/ksn_bounded_ring_impl.inc','code/build_core.sh','harness/test_ring_exact.c','harness/test_ring_negative.c','harness/test_adapter.c','harness/run_ring_tests.sh','harness/run_synthetic.sh','harness/run_segmented_model_actual.py','measure/refresh_accounting.py','measure/freeze_candidate.py'}
assert set(changed)<=allowed,set(changed)-allowed
assert all(sha(B/p)==h for p,h in base['files'].items())
new=[str(p.relative_to(R)) for d in ['private-build','code','harness'] for p in (R/d).rglob('*') if p.is_file() and p.suffix in ['.c','.h','.inc','.py','.sh'] and str(p.relative_to(R)) not in base['files']]
assert set(new)=={'harness/test_ring_exact_depth.c','harness/test_ring_negative_depth.c'},new
for d in ['build-product','build-adapter']:
 m=load(R/d/'BUILD.json');assert sha(R/d/'native-render')==m['binarySHA256'];assert all(sha(R.parent/p)==h for p,h in m['files'].items());assert all(sha(R/d/p)==h for p,h in m['stackFiles'].items())
assert load(R/'review/REVIEW.json')['status']=='PASS'
assert load(R/'review/RUNNER_REVIEW.json')['status']=='PASS'
(R/'SOURCE_DELTA.json').write_text(json.dumps({'status':'NARROW_ALLOWLIST_PASS','base':str(B),'changedExisting':changed,'newSource':new,'allBaseFilesStillMatch':True,'productFilesUnchanged':True,'actualFrames':0},indent=2)+'\n')
files=[p for d in ['private-build','code','harness','tests','integration-tests','test-independent','measure','review'] for p in (R/d).rglob('*') if p.is_file() and p.suffix in ['.c','.h','.inc','.py','.sh','.md','.json']]
files += [R/p for p in ['PLAN.md','RESTORE.md','REPORT.md','BASE_SOURCE_FREEZE.json','SOURCE_DELTA.json','MEMORY_LEDGER.json','GUARD_ACCOUNTING.json','HOST_BINARY_SIZE.json','NAMED_STACK.json','PRODUCT_NAMED_STACK.json','PREREQUISITE_REPORT.md','ACTUAL_BASELINE_PINS.json','INTEGRATION_TESTS.json','SYNTHETIC_RESULTS.json','test-results/RESULTS.json','build-product/BUILD.json','build-adapter/BUILD.json']]
assert not (R/'SOURCE_FREEZE.json').exists()
(R/'SOURCE_FREEZE.json').write_text(json.dumps({'status':'FROZEN_BEFORE_ACTUAL_RENDER','actualFrames':0,'files':{str(p.relative_to(R)):sha(p) for p in sorted(set(files))}},indent=2)+'\n');print('FROZEN',len(set(files)))
