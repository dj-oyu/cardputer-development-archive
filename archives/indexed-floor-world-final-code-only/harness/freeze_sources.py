"""Freeze final integration sources and verify every completed ancestor remains intact."""
from pathlib import Path
import json,hashlib,datetime
R=Path(__file__).resolve().parents[1];W=R.parent;I=W/'fox-v3-indexed-bvh';F=W/'fox-v3-floor-world-reflection'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
assert not (R/'SOURCE_FREEZE.json').exists()
base=json.load(open(R/'BASELINE_PINS.json'))['pins'];assert all(sha(W/k)==h for k,h in base.items())
# Completed ancestors, never an unfinished implementation.
assert json.load(open(I/'actual-001/COMPLETED.json'))['status']=='ALL20_EXACT_COMPLETE'
review=json.load(open(W/'fox-v3-indexed-bvh-review/FINAL_REVIEW.json'));assert review['status']=='PASS_ISOLATED_INDEXED_BVH_V3'
for p,h in json.load(open(F/'COMPLETION_PINS.json'))['files'].items():assert sha(p)==h
transport=['bounce.c','bounce.h','pixel_transport.c','pixel_transport.h']
assert all(sha(R/'private-build/transport'/p)==sha(F/'capture/transport'/p) for p in transport)
diffs=[]
for p in (I/'private-build').rglob('*'):
 if p.is_file() and sha(p)!=sha(R/'private-build'/p.relative_to(I/'private-build')):diffs.append(str(p.relative_to(I)))
assert sorted(diffs)==['private-build/transport/'+p for p in sorted(transport)]
assert all(sha(R/'private-build/visibility'/p)==sha(I/'private-build/visibility'/p) for p in ['visibility.c','visibility.h'])
for name in ['build-adapter','build-product']:
 b=json.load(open(R/name/'BUILD.json'));assert sha(R/name/'native-render')==b['binarySHA256'];assert all(sha(W/k)==v for k,v in b['files'].items())
iso={'status':'PASS','originalIndexedSourceUnchanged':True,'indexedVisibilityExact':True,'floorWorldTransportSourceExact':True,'privateBuildDifferences':diffs,'rowCoreChange':'Only guarded diagnostic observation before existing double-to-float conversion; arithmetic untouched.','adapterConflictResolution':'Same24 original spans. World ON adds external ledger against all24 plus both owned scenes/background ownership;24 pair charges within original producer cap. OFF original pair counts remain.','unchangedSources':'model, reference, LUT, physical light, background, core row arithmetic and original visibility ownership/storage'}
(R/'SOURCE_ISOLATION.json').write_text(json.dumps(iso,indent=2)+'\n')
files=[p for d in ['private-build','code','harness','tests','integration-tests'] for p in (R/d).rglob('*') if p.is_file() and p.suffix in ['.c','.h','.py','.inc','.sh']]
files+=[R/'PLAN.md',R/'BASELINE_PINS.json',R/'SOURCE_ISOLATION.json']
x={'status':'FROZEN_BEFORE_ACTUAL_RENDER','actualFrames':0,'observedAtUTC':datetime.datetime.now(datetime.timezone.utc).isoformat(),'files':{str(p.relative_to(R)):sha(p) for p in sorted(files)},'baselineIndexedCompletion':sha(I/'actual-001/COMPLETED.json'),'baselineWorldCompletionPins':sha(F/'COMPLETION_PINS.json')}
(R/'SOURCE_FREEZE.json').write_text(json.dumps(x,indent=2)+'\n');print('FROZEN',len(files),sha(R/'SOURCE_FREEZE.json'))
