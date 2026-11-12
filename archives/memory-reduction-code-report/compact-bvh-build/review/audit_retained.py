"""Read-only retained-output verification, never renders or changes frozen sources."""
from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];W=R.parent;B=W/'fox-v3-center-id-ring'
def read(p):return json.loads(Path(p).read_text())
def sha(p):
 p=Path(p);assert not any(x in str(p) for x in ['owned-ray-context','paged-bvh','unfinishedpagedcode']);return hashlib.sha256(p.read_bytes()).hexdigest()
def verify(p,h):assert sha(p)==h,str(p)
G=read(R/'PHYSICAL_EXECUTION_GATE.json');F=read(R/'FINAL_RESULT.json');S=read(R/'SOURCE_FREEZE.json');D=read(R/'build-adapter/BUILD.json');P=read(R/'ACTUAL_BASELINE_PINS.json')
assert G['status']=='COMPACT_BVH_BUILD_FIXED40_APPROVED'
for key,path in [('runnerSHA256','harness/run_compact_actual.py'),('runnerReviewSHA256','review/RUNNER_REVIEW.json'),('baselinePinsSHA256','ACTUAL_BASELINE_PINS.json'),('sourceFreezeSHA256','SOURCE_FREEZE.json'),('observerBuildSHA256','build-adapter/BUILD.json'),('independentReviewSHA256','review/REVIEW.json')]:verify(R/path,G[key])
verify(R/'SOURCE_FREEZE.json',F['sourceFreezeSHA256']);verify(R/'PHYSICAL_EXECUTION_GATE.json',F['gateSHA256']);verify(R/'build-adapter/native-render',D['binarySHA256'])
for name,h in S['files'].items():verify(R/name,h)
for name,h in D['files'].items():verify(W/name,h)
for name,h in D['stackFiles'].items():verify(R/'build-adapter'/name,h)
stack={}
for line in (R/'build-adapter/visibility.su').read_text().splitlines():
 k,size,*_=line.split('\t');stack[k.rsplit(':',1)[1]]=int(size)
assert (stack['vis_scene_build'],stack['build_node'],stack['build_bounds'])==(336,192,176)
for name,h in P['pins'].items():verify(name,h)
for name,h in read(R/'INPUT_FREEZE.json').items():verify(W/name,h)
raw=['.u16le','.f32le','.snapshot','.targets.u8','.hdr.f64le']; reports=['.json','.aa.json','.floor.json','.background.json','.row.json','.floor-world.json','.hdr-observer.json']; timing={'.json':['transportBuildNs','visibilityBuildNs','appendNs','evaluateNs','hostRenderNsFirstFrame'],'.background.json':['backgroundBuildNs'],'.row.json':['backgroundBuildNs']}
counts={'frames':0,'raw':0,'reports':0,'forwardReverse':0}; maximumAA=maximumProducer=0; commandInputs=set()
for arm in ['off','on']:
 root=R/f'actual-{arm}-001';oldroot=B/f'actual-{arm}-001';m=read(root/'COMPLETED.json');bm=read(oldroot/'COMPLETED.json');verify(root/'COMPLETED.json',F['arms'][arm]['manifestSHA256']);assert m['status']=='ALL20_EXACT_COMPLETE' and len(m['frames'])==20 and m['allForwardReverseExact'];assert [f['name'] for f in m['frames']]==P['cases'][arm]
 for f,oldf in zip(m['frames'],bm['frames']):
  assert f['name']==oldf['name'] and f['arm']==arm and f['status']=='PASS';name=f['name'];prefix=root/name;old=oldroot/name
  for ext,h in f['files'].items():verify(str(prefix)+ext,h)
  for ext,h in oldf['files'].items():verify(str(old)+ext,h)
  for ext in raw:assert Path(str(prefix)+ext).read_bytes()==Path(str(old)+ext).read_bytes();counts['raw']+=1
  for ext in reports:
   a=read(str(prefix)+ext);b=read(str(old)+ext)
   for key in timing.get(ext,[]):assert f['timingExclusions'][ext][key]=={'baseline':b.pop(key),'candidate':a.pop(key)}
   assert a==b,(name,ext);counts['reports']+=1
  c=read(str(prefix)+'.command.json');bc=read(str(old)+'.command.json');assert c['command']==[str(R/'build-adapter/native-render'),bc['command'][1],str(prefix),*bc['command'][3:]];assert c['environment']==bc['environment'];assert c['runtimeInputs']==bc['runtimeInputs'];assert c['binarySHA256']==D['binarySHA256'];assert c['gateSHA256']==sha(R/'PHYSICAL_EXECUTION_GATE.json')
  for path,h in c['runtimeInputs'].items():verify(path,h);commandInputs.add(path)
  a=read(str(prefix)+'.aa.json');row=read(str(prefix)+'.row.json');v=read(str(prefix)+'.json');assert a['complete'] and row['complete'] and v['visibilityComplete'] and v['transportComplete'];assert a['observedTotal']<=a['reservedTotal']<=8000000;assert sum(row['producerUsed'])<=637599;assert row['hostFinishHashBytes']<=row['hostFinishHashLimit']==73728
  for kind in ['visibility','transport']:
   for used,limit in [('Rays','RayLimit'),('NodeVisits','NodeLimit'),('TriangleTests','TriangleLimit')]:assert v[kind+used]<=v[kind+limit]
  assert (a['workspaceBytes'],v['visibilitySceneBytes'],v['visibilityTemporaryBytes'])==(77312,106104,46800)
  maximumAA=max(maximumAA,a['observedTotal']);maximumProducer=max(maximumProducer,sum(row['producerUsed']))
  if not f['reverse']:
   for ext in ['.u16le','.f32le','.targets.u8','.hdr.f64le']:assert Path(str(prefix)+ext).read_bytes()==Path(str(root/(name+'-reverse'))+ext).read_bytes();counts['forwardReverse']+=1
  counts['frames']+=1
assert counts=={'frames':40,'raw':200,'reports':280,'forwardReverse':80}
L=read(R/'MEMORY_LEDGER.json');verify(B/'MEMORY_LEDGER.json',L['baselineLedgerSHA256'])
for name,p in L['phases'].items():
 vals=[sum(v.values()) if isinstance(v,dict) else v for k,v in p.items() if k!='sumExcludingRO'];assert sum(vals)==p['sumExcludingRO']
assert max(p['sumExcludingRO'] for p in L['phases'].values())==L['newNamedPeakExcludingRO']==568880
assert L['oldNamedPeakExcludingRO']-L['newNamedPeakExcludingRO']==24304
old=(B/'private-build/visibility/visibility.c').read_text();new=(R/'private-build/visibility/visibility.c').read_text();assert old[old.index('vis_status vis_binding_set'):]==new[new.index('vis_status vis_binding_set'):]
assert sha(B/'private-build/visibility/visibility.h')==sha(R/'private-build/visibility/visibility.h')
result={'status':'PASS_RETAINED_OUTPUT_INDEPENDENT_AUDIT','rerenders':0,'comparisons':counts,'allNonTimingReportsExact':True,'timingExceptionsOnly':timing,'allSourceBinaryGateBaselineAndRuntimePinsVerified':True,'sourceFreezeSHA256':sha(R/'SOURCE_FREEZE.json'),'candidateSourceSHA256':sha(R/'private-build/visibility/visibility.c'),'sourceFiles':len(S['files']),'compiledInputFiles':len(D['files']),'baselinePins':len(P['pins']),'uniqueRuntimeInputPins':len(commandInputs),'maximumObservedAA':maximumAA,'maximumProducerWork':maximumProducer,'limitsAndRuntimeQuerySourceUnchanged':True,'memory':F['memory'],'memoryQualification':'Named conservative host accounting only; excludes allocator/libc/libm/unnamed constants and observer buffers. No device fit or speedup claim.','packagingWarning':'Existing PUBLIC_CODE_REPORT_ALLOWLIST includes INPUT_FREEZE despite exclusion wording. Use narrow review/AGGREGATE_CODE_ALLOWLIST.json instead; public persistence remains parent-controlled.','auditScriptSHA256':sha(__file__)}
(R/'review/FINAL_REVIEW.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
