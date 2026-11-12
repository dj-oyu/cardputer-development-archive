"""Freeze pre-actual source and emit a small differential backup allowlist."""
from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-aa-phase-overlay'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();load=lambda p:json.loads(p.read_text())
base=load(B/'SOURCE_FREEZE.json');assert all(sha(B/p)==h for p,h in base['files'].items())
assert not (R/'SOURCE_FREEZE.json').exists()
for d in ['build-product','build-adapter']:
 m=load(R/d/'BUILD.json');assert sha(R/d/'native-render')==m['binarySHA256'];assert all(sha(R.parent/p)==h for p,h in m['files'].items());assert all(sha(R/d/p)==h for p,h in m['stackFiles'].items())
assert load(R/'CACHED_SYNTHETIC_RESULTS.json')['status']=='PASS'
assert load(R/'INTEGRATION_TESTS.json')['status']=='PASS'
assert load(R/'review/REVIEW.json')['status']=='PASS'
assert load(R/'review/RUNNER_REVIEW.json')['status']=='PASS'
roots=['cache','code','harness','private-build','integration-tests','tests','test-independent','measure','comparison']
source=[p for d in roots for p in (R/d).rglob('*') if p.is_file() and p.suffix in ['.c','.h','.inc','.py','.sh']]
changed=[str(p.relative_to(R)) for p in source if (B/p.relative_to(R)).exists() and sha(p)!=sha(B/p.relative_to(R))]
new=[str(p.relative_to(R)) for p in source if not (B/p.relative_to(R)).exists()]
(R/'BASE_SOURCE_FREEZE.json').write_text(json.dumps(base,indent=2)+'\n')
(R/'SOURCE_DELTA.json').write_text(json.dumps({'status':'EXPLICIT_DIFFERENTIAL_SOURCE','baseline':'fox-v3-aa-phase-overlay','allBaseFilesStillMatch':True,'changedExisting':sorted(changed),'newSource':sorted(new),'noRejectedExperimentDependency':True,'actualFrames':0},indent=2)+'\n')
files=source+[p for p in R.glob('*.md')]+[p for p in R.glob('*.json') if p.name not in ['SOURCE_FREEZE.json','CHECKPOINT_ALLOWLIST.json','PHYSICAL_EXECUTION_GATE.json','ACTIVE_JOB.json']]
files += [R/'build-product/BUILD.json',R/'build-adapter/BUILD.json',R/'test-results/RESULTS.json',R/'test-independent/RESULTS.json']
files += [p for p in (R/'comparison').glob('*') if p.suffix in ['.json','.md']]
files += [p for p in (R/'review').glob('*') if p.suffix in ['.c','.py']]
(R/'SOURCE_FREEZE.json').write_text(json.dumps({'status':'FROZEN_BEFORE_ACTUAL_RENDER','actualFrames':0,'files':{str(p.relative_to(R)):sha(p) for p in sorted(set(files))}},indent=2)+'\n')
# Changed/new source only; immutable prior archive restores all untouched dependencies.
backup={R/p for p in changed+new}
backup.update(p for p in R.glob('*') if p.suffix in ['.md','.json','.log'] and p.name not in ['CHECKPOINT_ALLOWLIST.json','ACTIVE_JOB.json'])
backup.update(p for p in (R/'review').glob('*') if p.suffix in ['.c','.py','.json','.md','.log'])
backup.update(p for p in (R/'comparison').glob('*') if p.suffix in ['.py','.json','.md','.log'])
backup.update([R/'build-product/BUILD.json',R/'build-adapter/BUILD.json',R/'test-results/RESULTS.json',R/'test-independent/RESULTS.json'])
assert all(p.suffix not in ['.bin','.o','.a','.so','.png','.jpg','.f64le','.u16le','.f32le'] for p in backup)
assert all('profile_data' not in p.name and not p.name.endswith('.snapshot') for p in backup)
(R/'CHECKPOINT_ALLOWLIST.json').write_text(json.dumps({'status':'PRIVATE_CODE_TESTS_AGGREGATES_ONLY','actualFrames':0,'restoreBase':'Previously archived completed fox-v3-aa-phase-overlay','profileAsset':'Previously archived unchanged generic445248-byte blob; not duplicated','excludes':['images','geometry/model source assets','HDR arrays','binaries','generated LUT arrays','device/SDK files'],'files':{str(p.relative_to(R)):sha(p) for p in sorted(backup)}},indent=2)+'\n')
print('FROZEN',len(set(files)),'BACKUP',len(backup))
