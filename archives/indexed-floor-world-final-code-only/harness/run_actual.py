"""Pinned OFF/ON integration: separate canary and remaining19. Never overwrite."""
from pathlib import Path
import os,sys,json,hashlib,subprocess,time,datetime,copy
R=Path(__file__).resolve().parents[1];W=R.parent;I=W/'fox-v3-indexed-bvh';F=W/'fox-v3-floor-world-reflection';D=W/'fox-v3-floor-direct-reflection-evaluation/actual-002';G=R/'review/PHYSICAL_EXECUTION_GATE.json'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,x):
 t=p.with_suffix(p.suffix+'.tmp');t.write_text(json.dumps(x,indent=2)+'\n');t.replace(p)
def pins():
 b=json.load(open(R/'build-adapter/BUILD.json'));assert sha(R/'build-adapter/native-render')==b['binarySHA256'];assert all(sha(W/k)==v for k,v in b['files'].items());f=json.load(open(R/'SOURCE_FREEZE.json'));assert all(sha(R/k)==v for k,v in f['files'].items());assert all(sha(W/k)==v for k,v in json.load(open(R/'BASELINE_PINS.json'))['pins'].items());return b
assert len(sys.argv)==3 and sys.argv[1] in ['off','on'] and sys.argv[2] in ['canary','remaining'];arm,mode=sys.argv[1:];out=R/('actual-'+arm+'-001')
gate=json.load(open(G));assert gate['status']=='INDEXED_FLOOR_WORLD_ACTUAL40_CLEARED';assert all(sha(W/k)==v for k,v in gate['pins'].items());build=pins();baseline=json.load(open(I/'actual-001/COMPLETED.json'));assert baseline['status']=='ALL20_EXACT_COMPLETE' and len(baseline['frames'])==20
world=json.load(open(F/'capture'/arm/'COMPLETED.json'));assert world['status']=='ALL10_FLOOR_WORLD_CAPTURE_COMPLETE';composite=json.load(open(F/('composed-'+arm)/'COMPLETED.json'));assert composite['status']=='ALL10_FLOOR_WORLD_COMPOSITION_COMPLETE';assert len(world['frames'])==len(composite['frames'])==10
if arm=='on':assert json.load(open(R/'actual-off-001/COMPLETED.json'))['status']=='ALL20_EXACT_COMPLETE'
if mode=='canary':out.mkdir(exist_ok=False)
else:assert json.load(open(out/'canary.json'))['status']=='PASS'
completed=json.load(open(out/'completed-cases.json')) if (out/'completed-cases.json').exists() else [];done={r['name'] for r in completed}
inputs=json.load(open(D/'input-hashes.json'));assert sha(D/'inputs/candidate-config.json')==inputs['inputs/candidate-config.json'];cfg=json.load(open(D/'inputs/candidate-config.json'))
allcases=[(ci,s,c,rev) for ci,s in enumerate(cfg['scenarios']) for c in cfg['cameras'] for rev in [False,True]];allcases.sort(key=lambda z:(not(z[1]['name']=='baseline' and z[2]['name']=='front' and not z[3]),z[0],z[2]['name'],z[3]));cases=allcases[:1] if mode=='canary' else allcases[1:]
artifacts=['.u16le','.f32le','.snapshot','.targets.u8','.hdr.f64le'];reports=['.json','.aa.json','.floor.json','.background.json','.row.json','.floor-world.json','.hdr-observer.json'];timing={'.json':['transportBuildNs','visibilityBuildNs','appendNs','evaluateNs','hostRenderNsFirstFrame'],'.background.json':['backgroundBuildNs'],'.row.json':['backgroundBuildNs']}
for ci,scenario,camera,rev in cases:
 key=camera['name']+'-'+scenario['name'];name='native-'+key+('-reverse' if rev else '')
 if name in done:
  row=next(r for r in completed if r['name']==name);assert all(sha(out/(name+e))==h for e,h in row['files'].items());continue
 prefix=out/name;assert not any(out.glob(name+'.*'));old=I/'actual-001'/name;physical=D/'on'/f'physical-{scenario["name"]}.txt';model=D/'compiled'/f'model-{scenario["name"]}/model.aynm';ground=D/'inputs'/f'ground-{scenario["name"]}.txt';ledger=D/f'ledger-{camera["name"]}.txt'
 assert all(sha(p)==inputs[str(p.relative_to(D))] for p in [model,ground,ledger]);values=[]
 for light in scenario['physical']['lights']:values.extend(light['position']+light['eulerXYZ']+light['color']+[light['power'],light['diameter']])
 values.extend(scenario['physical']['worldRGB']+[scenario['physical']['worldStrength']]);assert physical.read_text()=='FOXDISK1\n'+' '.join(format(v,'.17g') for v in values)+'\n'
 indexedframe=next(f for f in baseline['frames'] if f['name']==name);assert all(sha(Path(str(old)+e))==h for e,h in indexedframe['files'].items())
 wf=next(f for f in world['frames'] if f['view']==camera['name'] and f['case']==scenario['name']);wp=F/'capture'/arm/wf['prefix'];assert all(sha(Path(str(wp)+e))==h for e,h in wf['files'].items())
 cf=next(f for f in composite['frames'] if f['view']==camera['name'] and f['case']==scenario['name']);hdr=F/('composed-'+arm)/cf['hdr'];agx=F/('composed-'+arm)/cf['outputs']['agx']['path'];assert sha(hdr)==cf['hdrSHA256'] and sha(agx)==cf['outputs']['agx']['sha256']
 old_world=json.load(open(str(wp)+'.floor-world.json'));runtime_inputs={str(p):sha(p) for p in [physical,model,ground,ledger,hdr,agx,*[Path(str(old)+e) for e in indexedframe['files']],*[Path(str(wp)+e) for e in wf['files']]]}
 oldcmd=json.load(open(str(old)+'.command.json'));env={**os.environ,**oldcmd['environment'],'HONE_FLOOR_WORLD':arm};args=[str(R/'build-adapter/native-render'),str(model),str(prefix),*oldcmd['command'][3:]];assert args[3]==str(int(rev))
 state={'status':'RUNNING','arm':arm,'case':name,'completedFrames':len(completed),'command':args,'environment':{k:v for k,v in env.items() if k.startswith('HONE_')},'runtimeInputs':runtime_inputs,'runnerPID':os.getpid(),'binarySHA256':build['binarySHA256'],'gateSHA256':sha(G),'startedUTC':datetime.datetime.now(datetime.timezone.utc).isoformat()};start=time.monotonic();pending=Path(str(prefix)+'.stdout-pending');err=Path(str(prefix)+'.stderr')
 with pending.open('x') as stdout,err.open('x') as stderr:
  proc=subprocess.Popen(args,env=env,stdout=stdout,stderr=stderr);state['renderPID']=proc.pid;write(out/'progress.json',state);write(out/(name+'.command.json'),state);write(R/'ACTIVE_JOB.json',state);ret=proc.wait()
 state.update(status='VALIDATING' if ret==0 else 'FAILED',returncode=ret,elapsedSeconds=time.monotonic()-start);write(out/'progress.json',state)
 try:
  assert ret==0,err.read_text();assert not err.read_text(),err.read_text()
  for e in ['.f32le','.snapshot','.targets.u8']:assert Path(str(prefix)+e).read_bytes()==Path(str(old)+e).read_bytes(),e
  assert Path(str(prefix)+'.hdr.f64le').read_bytes()==hdr.read_bytes(),'HDR exact';assert Path(str(prefix)+'.u16le').read_bytes()==agx.read_bytes(),'AgX exact'
  if arm=='off':assert Path(str(prefix)+'.u16le').read_bytes()==Path(str(old)+'.u16le').read_bytes()
  observed_world=json.load(open(str(prefix)+'.floor-world.json'))
  if not rev or arm=='off':assert observed_world==old_world,'completed forward world ledger exact'
  else:
   baseline_report=json.load(open(str(old)+'.json'));of=json.load(open(str(old)+'.floor.json'))
   assert observed_world['enabled'] and observed_world['complete'] and observed_world['sameTransportBudget'] and not observed_world['old8MCombinedAdmission']
   assert observed_world['version']=='floor-world-v1' and observed_world['workBytes']==104 and observed_world['componentBytes']==24 and observed_world['innerSamples']==16
   assert observed_world['shaderCalls']==observed_world['shaderLimit']==baseline_report['shadeUpdates']
   assert observed_world['evaluations']==observed_world['hitLimit']==baseline_report['primary_ground_reflection_hits']==of['evaluations']
   assert observed_world['workUsed']==observed_world['workLimit']==64*observed_world['shaderCalls']+6272*observed_world['evaluations']
   assert observed_world['queries']==observed_world['visibilityRays']==16*observed_world['evaluations']
   assert observed_world['misses']+observed_world['blockedCharacter']+observed_world['blockedFloor']==observed_world['queries'] and not observed_world['blockedFloor']
   assert set(observed_world)==set(old_world)
  exclusions={};new_reports={} 
  for e in reports[:5]:
   new=json.load(open(pending if e=='.json' else str(prefix)+e));expected=json.load(open(str(old)+e));new_reports[e]=new;observed=copy.deepcopy(new);ignored={}
   for k in timing.get(e,[]):ignored[k]={'baseline':expected.pop(k),'candidate':observed.pop(k)}
   if e=='.json':
    assert expected['transportContextBytes']==576;expected['transportContextBytes']=608
    if arm=='on':
     for k,wk in [('transportRays','visibilityRays'),('transportNodeVisits','visibilityNodeVisits'),('transportTriangleTests','visibilityTriangleTests')]:expected[k]+=observed_world[wk]
   if e=='.floor.json':assert expected['contextBytes']==576;expected['contextBytes']=608
   if e=='.row.json':
    expected['clamped']=cf['clampedPixels']
    if arm=='on':expected['adapterSpanPairs']+=24;expected['producerUsed'][-1]+=24
   assert observed==expected,(e,{k:(observed.get(k),expected.get(k)) for k in observed.keys()|expected.keys() if observed.get(k)!=expected.get(k)})
   exclusions[e]=ignored
  ob=json.load(open(str(prefix)+'.hdr-observer.json'));assert ob=={'enabled':True,'complete':True,'diagnosticOnly':True,'bufferBytes':777600,'controlBytes':24,'initializationWriteBytes':259200,'sampleWrites':32400,'captureWriteBytes':777600,'dumpBytes':777600,'shadingFeedback':False}
  aa=new_reports['.aa.json'];r=new_reports['.row.json'];assert aa['complete'] and r['complete'] and new_reports['.floor.json']['complete'] and new_reports['.background.json']['complete'];assert aa['observedTotal']<=aa['reservedTotal']<=8000000 and sum(r['producerUsed'])<=637599;assert r['hostFinishHashBytes']==72138 and r['hostFinishHashLimit']==73728
  assert all(sha(p)==h for p,h in runtime_inputs.items());pins();pending.rename(Path(str(prefix)+'.json'))
  row={'name':name,'view':camera['name'],'case':scenario['name'],'reverse':rev,'arm':arm,'status':'PASS','elapsedSecondsDescriptiveOnly':state['elapsedSeconds'],'files':{e:sha(Path(str(prefix)+e)) for e in artifacts+reports},'exactCompletedFloorWorldHDRAndAgx':True,'exactIndexedDepthMaskSnapshot':True,'oldCountersExactExceptDocumentedAdditiveTraversal':True,'worldLedgerMatchesCompletedForward':not rev or arm=='off','worldLedgerIdentitiesExact':True,'truthfulContextBytesDelta':32,'worldOnExtraSpanPairs':24 if arm=='on' else 0,'timingExclusions':exclusions};completed.append(row);write(out/'completed-cases.json',completed);state.update(status='PASS',completedFrames=len(completed));write(out/'progress.json',state);write(R/'ACTIVE_JOB.json',state);print(arm,name,'PASS',flush=True)
 except Exception as exc:
  state.update(status='FAILED_VALIDATION',error=repr(exc),successManifestPublished=False);write(out/'progress.json',state);write(out/'FAILED.json',state);write(R/'ACTIVE_JOB.json',state);raise
if mode=='canary':write(out/'canary.json',{'status':'PASS','arm':arm,'frames':completed,'all20Complete':False})
else:
 assert len(completed)==20
 for scenario in cfg['scenarios']:
  for camera in cfg['cameras']:
   name='native-'+camera['name']+'-'+scenario['name']
   for e in ['.u16le','.f32le','.targets.u8','.hdr.f64le']:assert (out/(name+e)).read_bytes()==(out/(name+'-reverse'+e)).read_bytes()
 write(out/'COMPLETED.json',{'status':'ALL20_EXACT_COMPLETE','arm':arm,'frames':completed,'allForwardReverseExact':True,'completedIndexedBaseline':'fox-v3-indexed-bvh/actual-001','completedFloorWorldBaseline':'fox-v3-floor-world-reflection/composed-'+arm,'storageContract':3,'timingClaim':'Descriptive only, no speedup or target fit claim'})
