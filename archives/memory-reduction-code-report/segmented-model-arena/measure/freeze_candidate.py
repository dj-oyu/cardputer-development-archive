from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-indexed-transport-input';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text())
assert (R/'review/REVIEW.json').exists(), 'Independent final review required before freeze'
base=load(R/'BASE_SOURCE_FREEZE.json');changed=[p for p,h in base['files'].items() if sha(R/p)!=h]
allowed={'private-build/product/main/ayatsuri/ayatsuri_model.c','private-build/product/main/ayatsuri/ayatsuri_model.h','harness/native_render_row.c','harness/run_actual.py','harness/run_compact_actual.py','harness/run_depth_actual.py','harness/run_indexed_input_actual.py','harness/run_ring_actual.py','harness/run_transport_actual.py'}
assert set(changed)<=allowed,set(changed)-allowed
for build in ['build-product','build-adapter']:
 m=load(R/build/'BUILD.json');assert sha(R/build/'native-render')==m['binarySHA256'];assert all(sha(R.parent/p)==h for p,h in m['files'].items());assert all(sha(R/build/p)==h for p,h in m['stackFiles'].items())
new=[str(p.relative_to(R)) for d in ['private-build','code','harness'] for p in (R/d).rglob('*') if p.is_file() and p.suffix in ['.c','.h','.inc','.py','.sh'] and str(p.relative_to(R)) not in base['files']]
assert set(new)<={'harness/model_arena_owner.h','harness/run_segmented_model_actual.py'},new
(R/'SOURCE_DELTA.json').write_text(json.dumps({'status':'NARROW_ALLOWLIST_PASS','base':str(B),'changedExisting':changed,'newSource':new,'excluded':'No source assets/reference/model geometry/rig/profile/threshold changes. No rejected owned-context/paged-BVH sources.','allBaseFilesStillMatch':all(sha(B/p)==h for p,h in base['files'].items())},indent=2)+'\n')
assert load(R/'SOURCE_DELTA.json')['allBaseFilesStillMatch']
files=[p for d in ['private-build','code','harness','tests','integration-tests','measure','test-independent','review'] for p in (R/d).rglob('*') if p.is_file() and p.suffix in ['.c','.h','.inc','.py','.sh','.md','.json']]
files += [R/p for p in ['PLAN.md','RESTORE.md','BASE_SOURCE_FREEZE.json','SOURCE_DELTA.json','MEMORY_LEDGER.json','GUARD_ACCOUNTING.json','HOST_BINARY_SIZE.json','NAMED_STACK.json','PRODUCT_NAMED_STACK.json','PREREQUISITE_REPORT.md','ACTUAL_BASELINE_PINS.json','INTEGRATION_TESTS.json','test-results/RESULTS.json','build-product/BUILD.json','build-adapter/BUILD.json']]
assert not (R/'SOURCE_FREEZE.json').exists()
(R/'SOURCE_FREEZE.json').write_text(json.dumps({'status':'FROZEN_BEFORE_ACTUAL_RENDER','actualFrames':0,'files':{str(p.relative_to(R)):sha(p) for p in sorted(set(files))}},indent=2)+'\n');print('FROZEN',len(set(files)))
