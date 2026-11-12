"""Freeze exact reviewed pre-actual sources and differential private checkpoint."""
from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-streamed-center-depth'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();load=lambda p:json.loads(p.read_text())
assert not (R/'SOURCE_FREEZE.json').exists()
base=load(B/'SOURCE_FREEZE.json');assert all(sha(B/p)==h for p,h in base['files'].items())
for d in ['build-product','build-adapter']:
 m=load(R/d/'BUILD.json');assert sha(R/d/'native-render')==m['binarySHA256'];assert all(sha(R.parent/p)==h for p,h in m['files'].items());assert all(sha(R/d/p)==h for p,h in m['stackFiles'].items())
assert load(R/'PREREQUISITE_REPORT.json')['status']=='PASS_SYNTHETIC_ONLY'
assert load(R/'review/INDEPENDENT_SYNTHETIC.json')['status']=='PASS'
assert load(R/'review/INDEPENDENT_SOURCE_STACK_LEDGER.json')['status']=='PASS_INDEPENDENT_SOURCE_STACK_LEDGER'
assert (R/'comparison/COMPARISON_FREEZE.json').exists()
roots=['cache','code','harness','private-build','tests','measure','comparison','review']
source=[p for d in roots for p in (R/d).rglob('*') if p.is_file() and p.suffix in ['.c','.h','.inc','.py','.sh']]
changed=[str(p.relative_to(R)) for p in source if (B/p.relative_to(R)).exists() and sha(p)!=sha(B/p.relative_to(R))]
new=[str(p.relative_to(R)) for p in source if not (B/p.relative_to(R)).exists()]
# Source delta is finalized before prerequisite evidence pins; freeze never mutates it.
exclude={'SOURCE_FREEZE.json','CHECKPOINT_ALLOWLIST.json','PROGRESS_ALLOWLIST.json','PHYSICAL_EXECUTION_GATE.json','ACTIVE_JOB.json'}
files=source+[p for p in R.glob('*') if p.suffix in ['.md','.json','.log'] and p.name not in exclude]
files += [R/'build-product/BUILD.json',R/'build-adapter/BUILD.json']
files += [p for d in ['comparison','review'] for p in (R/d).glob('*') if p.suffix in ['.json','.md','.log']]
files += [p for p in (R/'tests').rglob('*') if p.is_file() and p.suffix in ['.json','.log']]
files += [R/'PLAN.sha256']
files=sorted(set(files));(R/'SOURCE_FREEZE.json').write_text(json.dumps({'status':'FROZEN_BEFORE_ACTUAL_RENDER','actualFrames':0,'files':{str(p.relative_to(R)):sha(p) for p in files}},indent=2)+'\n')
backup={R/p for p in changed+new}
backup.update(p for p in files if p.suffix in ['.md','.json','.log'])
backup.add(R/'SOURCE_FREEZE.json')
assert all(p.suffix not in ['.bin','.o','.a','.so','.png','.jpg','.f64le','.u16le','.f32le'] for p in backup)
assert all('profile_data' not in p.name and not p.name.endswith('.snapshot') for p in backup)
(R/'CHECKPOINT_ALLOWLIST.json').write_text(json.dumps({'status':'PRIVATE_CODE_TESTS_AGGREGATES_ONLY','actualFrames':0,'restoreBase':'Previously archived completed fox-v3-streamed-center-depth','profileAsset':'Previously archived unchanged generic445248-byte blob; not duplicated','excludes':['images','geometry/model source assets','HDR arrays','binaries','generated LUT arrays','device/SDK files'],'files':{str(p.relative_to(R)):sha(p) for p in sorted(backup)}},indent=2)+'\n')
print('FROZEN',len(files),'BACKUP',len(backup),'SHA',sha(R/'SOURCE_FREEZE.json'))
