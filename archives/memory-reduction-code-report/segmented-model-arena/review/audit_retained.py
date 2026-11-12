"""Independent retained-output audit. Does not invoke the renderer."""
from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];W=R.parent;B=W/'fox-v3-indexed-transport-input'
def read(p):return json.loads(Path(p).read_text())
def sha(p):
 p=Path(p);assert not any(s in str(p) for s in ['owned-ray-context','paged-bvh']);return hashlib.sha256(p.read_bytes()).hexdigest()
def verify(p,h):assert sha(p)==h,str(p)
G=read(R/'PHYSICAL_EXECUTION_GATE.json');S=read(R/'SOURCE_FREEZE.json');D=read(R/'build-adapter/BUILD.json');P=read(R/'ACTUAL_BASELINE_PINS.json')
assert G['status']=='SEGMENTED_MODEL_ARENA_FIXED40_APPROVED'
for key,path in [('runnerSHA256','harness/run_segmented_model_actual.py'),('runnerReviewSHA256','review/RUNNER_REVIEW.json'),('baselinePinsSHA256','ACTUAL_BASELINE_PINS.json'),('sourceFreezeSHA256','SOURCE_FREEZE.json'),('observerBuildSHA256','build-adapter/BUILD.json'),('independentReviewSHA256','review/REVIEW.json'),('productStackSHA256','PRODUCT_NAMED_STACK.json')]:verify(R/path,G[key])
for p,h in S['files'].items():verify(R/p,h)
for p,h in D['files'].items():verify(W/p,h)
for p,h in D['stackFiles'].items():verify(R/'build-adapter'/p,h)
verify(R/'build-adapter/native-render',D['binarySHA256'])
for p,h in P['pins'].items():verify(p,h)
# Baseline pins include every runtime input; optional separate freeze checked by parent gate.
raw=['.u16le','.f32le','.snapshot','.targets.u8','.hdr.f64le'];reports=['.json','.aa.json','.floor.json','.background.json','.row.json','.floor-world.json','.hdr-observer.json']
timing={'.json':['transportBuildNs','visibilityBuildNs','appendNs','evaluateNs','hostRenderNsFirstFrame'],'.background.json':['backgroundBuildNs'],'.row.json':['backgroundBuildNs']}
counts={'frames':0,'raw':0,'reports':0,'forwardReverse':0};maxAA=maxProducer=0
for arm in ['off','on']:
 root=R/f'actual-{arm}-001';oldroot=B/f'actual-{arm}-001';m=read(root/'COMPLETED.json');bm=read(oldroot/'COMPLETED.json');assert m['status']=='ALL20_EXACT_COMPLETE' and len(m['frames'])==20 and m['allForwardReverseExact'];assert [f['name'] for f in m['frames']]==P['cases'][arm]
 for f,bf in zip(m['frames'],bm['frames']):
  assert f['name']==bf['name'] and f['arm']==arm and f['status']=='PASS';name=f['name'];p=root/name;b=oldroot/name
  for e,h in f['files'].items():verify(str(p)+e,h)
  for e,h in bf['files'].items():verify(str(b)+e,h)
  for e in raw:assert Path(str(p)+e).read_bytes()==Path(str(b)+e).read_bytes(),(name,e);counts['raw']+=1
  for e in reports:
   a=read(str(p)+e);old=read(str(b)+e)
   for k in timing.get(e,[]):assert f['timingExclusions'][e][k]=={'baseline':old.pop(k),'candidate':a.pop(k)}
   if e=='.json':
    assert old['arenaBytes64bit']==81356 and a['arenaBytes64bit']==81796
    assert f['timingExclusions'][e]['arenaBytes64bit']=={'baseline':81356,'candidate':81796}
    old['arenaBytes64bit']=81796
   assert a==old,(name,e);counts['reports']+=1
  c=read(str(p)+'.command.json');bc=read(str(b)+'.command.json');assert c['command']==[str(R/'build-adapter/native-render'),bc['command'][1],str(p),*bc['command'][3:]];assert c['environment']==bc['environment'];assert c['runtimeInputs']==bc['runtimeInputs'];assert c['binarySHA256']==D['binarySHA256'];assert c['gateSHA256']==sha(R/'PHYSICAL_EXECUTION_GATE.json')
  for path,h in c['runtimeInputs'].items():verify(path,h)
  aa=read(str(p)+'.aa.json');row=read(str(p)+'.row.json');v=read(str(p)+'.json');assert aa['complete'] and row['complete'] and v['visibilityComplete'] and v['transportComplete'];assert aa['observedTotal']<=aa['reservedTotal']<=8000000;assert sum(row['producerUsed'])<=637599;assert row['hostFinishHashBytes']<=row['hostFinishHashLimit']==73728;assert row['adapterGuardUpper']==1024
  for kind in ['visibility','transport']:
   for used,limit in [('Rays','RayLimit'),('NodeVisits','NodeLimit'),('TriangleTests','TriangleLimit')]:assert v[kind+used]<=v[kind+limit]
  maxAA=max(maxAA,aa['observedTotal']);maxProducer=max(maxProducer,sum(row['producerUsed']))
  if not f['reverse']:
   for e in ['.u16le','.f32le','.targets.u8','.hdr.f64le']:assert Path(str(p)+e).read_bytes()==Path(str(root/(name+'-reverse'))+e).read_bytes();counts['forwardReverse']+=1
  counts['frames']+=1
assert counts=={'frames':40,'raw':200,'reports':280,'forwardReverse':80}
L=read(R/'MEMORY_LEDGER.json');verify(B/'MEMORY_LEDGER.json',L['baseLedgerSHA256'])
for p in L['phases'].values():assert sum(sum(v.values()) if isinstance(v,dict) else v for k,v in p.items() if k!='sumExcludingRO')==p['sumExcludingRO']
assert max(p['sumExcludingRO'] for p in L['phases'].values())==L['namedPeak']==496184
assert L['baselineNamedPeak']==496152 and L['namedPeakDelta']==32
assert L['model']['payloadBytes']==81796 and L['model']['ownerControlBytes']==912
assert L['model']['heapIncludingOwner']==82708 and L['model']['allocationsIncludingOwner']==57
assert L['largestNamedAllocation']==77312 and L['model']['largestModelAllocation']==1760
A=read(R/'GUARD_ACCOUNTING.json');assert A['rendererBudgetsUnchanged']['guardCapUnchanged']==1024
assert A['rendererBudgetsUnchanged']['producerCapUnchanged']==637599
for file,main in [('NAMED_STACK.json',83776),('PRODUCT_NAMED_STACK.json',83792)]:
 st=read(R/file);assert (st['backgroundPeak'],st['rendererPeak'],st['mainStack'])==(4080,5008,main)
 assert st['chains']==read(B/file)['chains']
 for name,h in st['stackFiles'].items():verify(R/('build-product' if file.startswith('PRODUCT') else 'build-adapter')/name,h)
result={'status':'PASS_RETAINED_OUTPUT_INDEPENDENT_AUDIT','rerenders':0,'memoryLedgerAndGuardVerified':True,'namedPeak':496184,'namedPeakDelta':32,'modelPayload':81796,'modelOwnerControl':912,'modelAllocationCount':57,'largestModelAllocation':1760,'largestNamedGlobalAllocation':77312,'backgroundStack':4080,'backgroundCap':4096,'sourceFreezeSHA256':sha(R/'SOURCE_FREEZE.json'),'gateSHA256':sha(R/'PHYSICAL_EXECUTION_GATE.json'),'completedManifestSHA256':{arm:sha(R/f'actual-{arm}-001/COMPLETED.json') for arm in ['off','on']},'comparisons':counts,'onlyNonTimingDifferences':{'.json':{'arenaBytes64bit':[81356,81796]}},'timingExceptionsOnly':timing,'allPinsVerified':True,'maximumObservedAA':maxAA,'maximumProducerWork':maxProducer,'auditScriptSHA256':sha(__file__),'memoryQualification':'Model maximum requested block shrinks81356 to1760; global maximum77312 remains AA. Model total grows1352 including owner; named product lifecycle peak grows32. Allocator overhead excluded. No device/whole-host fit or speedup claim.'}
(R/'review/FINAL_REVIEW.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
