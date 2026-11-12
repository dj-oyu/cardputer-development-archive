"""Independent preactual source, fresh compiled-stack, pin and memory review. Never render."""
from pathlib import Path
import json,hashlib,datetime
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-compact-transport';W=R.parent
read=lambda p:json.loads(Path(p).read_text())
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def verify(p,h):assert sha(p)==h,str(p)
base=(B/'private-build/transport/bounce.c').read_text();new=(R/'private-build/transport/bounce.c').read_text();i=new.index('_Static_assert(sizeof(bounce_indexed_triangle)');j=new.index('bounce_status bounce_binding_set',i);assert new[:i]+new[j:]==base
sources=[]
for d in ['code','harness','private-build']:
 for p in (B/d).rglob('*'):
  if p.is_file() and p.suffix in ['.c','.h','.inc','.py','.sh']:
   other=R/p.relative_to(B);assert other.exists();
   if sha(other)!=sha(p):sources.append(str(p.relative_to(B)))
allowed={'private-build/transport/bounce.c','private-build/transport/bounce.h','harness/native_render_row.c','harness/freeze_sources.py','harness/stack_manifest.py','harness/run_actual.py','harness/run_ring_actual.py','harness/run_compact_actual.py','harness/run_depth_actual.py','harness/run_transport_actual.py'}
assert set(sources)<=allowed,sources
stacks={}
for d,sn in [('build-adapter','NAMED_STACK.json'),('build-product','PRODUCT_NAMED_STACK.json')]:
 m=read(R/d/'BUILD.json');assert m['status']=='BUILT_NOT_RENDERED';verify(R/d/'native-render',m['binarySHA256'])
 for p,h in m['files'].items():verify(W/p,h)
 frames={}
 for p,h in m['stackFiles'].items():
  verify(R/d/p,h)
  for line in (R/d/p).read_text().splitlines():
   loc,size,kind=line.split('\t');frames[Path(p).stem+':'+loc.rsplit(':',1)[-1]]=int(size)
 s=read(R/sn)
 for p,h in s['stackFiles'].items():verify(R/d/p,h)
 for name,c in s['chains'].items():
  assert sum(f['bytes'] for f in c['frames'])==c['bytes']
  for f in c['frames']:assert frames[f['name']]==f['bytes']
 assert s['backgroundPeak']==4080 and s['backgroundCap']==4096 and s['rendererPeak']==5008
 assert s['mainStack']==frames['native_render_row:main']
 assert s['compactTransportBaselineMainStack']==83744 and s['mainStackIncrease']==s['mainStack']-83744
 stacks[sn]={'sha256':sha(R/sn),'main':s['mainStack'],'background':s['backgroundPeak'],'renderer':s['rendererPeak'],'constructor':frames['bounce:bounce_scene_build_ground_indexed'],'query':frames['bounce:bounce_scene_indexed_required_bytes']}
for path in ['review-independent/RESULTS.json','test-independent/RESULTS.json','test-independent/CALLER_RESULTS.json']:
 t=read(R/path);assert t['status']=='PASS';
 for p,h in t['sha256'].items():verify(R/p,h)
m=read(R/'measure/MEASUREMENT.json');assert m['status']=='ALL40_BUILD_ONLY_EXACT' and m['actualFrames']==0 and len(m['cases'])==40
for field in ['inputPins','sourceHashes']:
 for p,h in m[field].items():verify(W/p,h)
verify(R/'measure/measure_attributes',m['binarySHA256'])
for row in m['cases']:
 old=read(B/('actual-'+row['arm']+'-001')/(row['case']+'.json'))
 assert row['materialFingerprint']==old['materialFingerprint']
 assert (row['vertices'],row['triangles'],row['uniqueVertices'],row['sceneBytes'],row['inputBytes'])==(1167,1566,774,28592,35868)
 assert row['directIndexedOwnedBitExact'] and row['callerPoisonFreePassed'] and row['unusedRawVertices']==0
pins=read(R/'ACTUAL_BASELINE_PINS.json');assert len(pins['pins'])==1019
for p,h in pins['pins'].items():verify(p,h)
for p,h in read(R/'INPUT_FREEZE.json').items():verify(B/p,h)
l=read(R/'MEMORY_LEDGER.json');verify(B/'MEMORY_LEDGER.json',l['baselineLedgerSHA256'])
for name,p in l['phases'].items():assert sum(sum(v.values()) if isinstance(v,dict) else v for k,v in p.items() if k!='sumExcludingRO')==p['sumExcludingRO'],name
assert l['newNamedPeakExcludingRO']==max(p['sumExcludingRO'] for p in l['phases'].values())
assert l['oldNamedPeakExcludingRO']==505952 and l['trueNamedPeakSaved']==505952-l['newNamedPeakExcludingRO']
assert l['phases']['render']['mainStack']==stacks['NAMED_STACK.json']['main']
assert l['phases']['render']['heap']['transportScene']==28592
assert l['depthAllocation']['requests']==[30720,30720,30720,30720,6720]
for sn in stacks:assert stacks[sn]['main']==stacks['NAMED_STACK.json']['main']
x={'status':'PASS_CODE_AND_COMPILED_STACK_REVIEW','observedUTC':datetime.datetime.now(datetime.timezone.utc).isoformat(),'actualRenderRunsByReviewer':0,'sourceChanges':sources,'entireBaseBounceCExactOutsideAddedColdIndexedAPI':True,'stack':stacks,'baselinePinsVerified':1019,'namedPeak':l['newNamedPeakExcludingRO'],'namedPeakSaved':l['trueNamedPeakSaved'],'sourceHashes':{p:sha(R/p) for p in sources},'evidenceHashes':{p:sha(R/p) for p in ['MEMORY_LEDGER.json','measure/MEASUREMENT.json','review-independent/RESULTS.json','test-independent/RESULTS.json','test-independent/CALLER_RESULTS.json','review/RUNNER_REVIEW.json']},'limitations':['Named conservative lifecycle only; no device or whole-host fit claim','LSan disabled; explicit tracked-allocation balance tests used','Synthetic caller allocation test extracts exact statements, not full main failure execution']}
(R/'review/PREREQUISITE_REVIEW.json').write_text(json.dumps(x,indent=2)+'\n');print(json.dumps(x,indent=2))
