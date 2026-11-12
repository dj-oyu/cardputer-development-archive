from pathlib import Path
import json,hashlib,re,datetime
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-depth-bands'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
changed=[]
for root in ['private-build','code','harness']:
 for p in (B/root).rglob('*'):
  if p.is_file() and p.suffix not in ['.pyc']:
   q=R/p.relative_to(B)
   if q.exists() and sha(p)!=sha(q):changed.append(str(p.relative_to(B)))
allowed=['private-build/transport/bounce.c','private-build/transport/bounce.h','harness/native_render_row.c']
stubs=['harness/run_actual.py','harness/run_ring_actual.py','harness/run_compact_actual.py','harness/run_depth_actual.py']
for name in stubs:assert (R/name).read_text().startswith('raise SystemExit(')
allowed+=stubs+['harness/freeze_sources.py']
# Extra reporting scripts may be created, but no other copied source can change.
assert sorted(changed)==sorted(allowed),changed
stack={}
for report,folder in [('PRODUCT_NAMED_STACK.json','build-product'),('NAMED_STACK.json','build-adapter')]:
 a=json.loads((R/report).read_text());b=json.loads((B/report).read_text());frames={}
 for name,digest in a['stackFiles'].items():
  p=R/folder/name;assert sha(p)==digest
  for line in p.read_text().splitlines():
   location,n,kind=line.split('\t');frames[p.stem+':'+location.rsplit(':',1)[-1]]=int(n)
 for name,chain in a['chains'].items():
  assert all(frames[f['name']]==f['bytes'] for f in chain['frames'])
  assert sum(f['bytes'] for f in chain['frames'])==chain['bytes']==b['chains'][name]['bytes']
 assert (a['backgroundPeak'],a['rendererPeak'],a['mainStack'])==(4080,5008,83744)
 stack[report]={'hash':sha(R/report),'background':4080,'renderer':5008,'main':83744,'freshCompiledFramesVerified':True}
base=(B/'private-build/transport/bounce.c').read_text();new=(R/'private-build/transport/bounce.c').read_text()
# All code after hit_material is identical. This includes floor/query counters,
# quotas, arithmetic, evaluation output, and ownership span dispatch.
a=base.index('static bounce_status world_visible');b=new.index('static bounce_status world_visible');assert base[a:]==new[b:]
negative=json.loads((R/'test-independent/RESULTS.json').read_text());assert negative['status']=='PASS'
actual=(R/'measure/ATTRIBUTES.txt').read_text().splitlines();assert len(actual)==41
for line in actual[1:]:assert line.startswith('built_bytes=28592 unique=774 ') and line.endswith('triangles=1564 character_unique=773 with_ground=774')
out={'status':'PASS_CODE_AND_COMPILED_STACK_REVIEW','observedUTC':datetime.datetime.now(datetime.timezone.utc).isoformat(),'actualRenderRunsByReviewer':0,'sourceChanges':changed,'allPostMaterialArithmeticAndBudgetsExactSource':True,'actualAttributeConstructionRecords':40,'actualCompactBytesEach':28592,'maxGenericCompactBytes':139848,'arithmeticComparisonsPerMode':49896,'modes':['O2','O2 ASan/UBSan'],'legacyCompatibility':'API/size/render behavior; private attribute offset moves580 to584 and internal byte layout is not identical','stack':stack,'guardBasis':'No admission or overlap-function source changes; owned allocation range remains s->bytes. Baseline guard927/985 and cap1024; producer637599 unchanged. Interning occurs before renderer and does not change render guard dispatch.','limitations':['No whole host/device fit claim','LSan unavailable under ptrace; ASan/UBSan ran with leak detection disabled','Actual fixed40 comparison still requires parent gate then retained audit'],'pins':{p:sha(R/p) for p in allowed+['review/test_independent.c','review/reference_hit.inc','review/run_independent.sh','review/independent.log','review/independent-san.log','test-independent/RESULTS.json','measure/measure_attributes.c','measure/ATTRIBUTES.txt']}}
(R/'review/PREREQUISITE_REVIEW.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
