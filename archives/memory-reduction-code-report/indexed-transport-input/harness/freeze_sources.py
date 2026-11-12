from pathlib import Path
import hashlib,json
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-compact-transport';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert not (R/'SOURCE_FREEZE.json').exists()
pins=json.load(open(R/'INPUT_FREEZE.json'));assert all(sha(B/k)==v for k,v in pins.items())
for d in ['build-adapter','build-product']:
 m=json.load(open(R/d/'BUILD.json'));assert sha(R/d/'native-render')==m['binarySHA256'];assert all(sha(R.parent/k)==v for k,v in m['files'].items());assert all(sha(R/d/k)==v for k,v in m['stackFiles'].items())
files=[p for d in ['code','harness','private-build','tests','integration-tests','test-depth','measure','test-independent','review-independent','review'] for p in (R/d).rglob('*') if p.is_file() and p.suffix in ['.c','.h','.inc','.py','.sh']];files+=[R/'PLAN.md',R/'INPUT_FREEZE.json',R/'MEMORY_LEDGER.json',R/'NAMED_STACK.json',R/'PRODUCT_NAMED_STACK.json',R/'PREREQUISITE_REPORT.md',R/'HOST_BINARY_SIZE.json',R/'GUARD_ACCOUNTING.json',R/'measure/MEASUREMENT.json',R/'test-independent/RESULTS.json',R/'test-independent/CALLER_RESULTS.json',R/'review/RUNNER_REVIEW.json']
(R/'SOURCE_FREEZE.json').write_text(json.dumps({'status':'FROZEN_BEFORE_ACTUAL_RENDER','actualFrames':0,'files':{str(p.relative_to(R)):sha(p) for p in sorted(files)}},indent=2)+'\n')
print('FROZEN',len(files))
