"""Same-arm/order completed-baseline comparator. Explicit reviewed gate required."""
from pathlib import Path
import os,sys,json,hashlib,subprocess,time,datetime,copy
R=Path(__file__).resolve().parents[1];W=R.parent;B=W/'fox-v3-indexed-transport-input';G=R/'PHYSICAL_EXECUTION_GATE.json'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,x):
 t=p.with_suffix(p.suffix+'.tmp');t.write_text(json.dumps(x,indent=2)+'\n');t.replace(p)
def prepare():
 assert not (R/'ACTUAL_BASELINE_PINS.json').exists()
 pins={};cases={}
 for arm in ['off','on']:
  root=B/f'actual-{arm}-001';complete=json.load(open(root/'COMPLETED.json'));assert complete['status']=='ALL20_EXACT_COMPLETE' and len(complete['frames'])==20 and complete['allForwardReverseExact']
  pins[str(root/'COMPLETED.json')]=sha(root/'COMPLETED.json');cases[arm]=[]
  for f in complete['frames']:
   name=f['name'];assert f['arm']==arm and f['status']=='PASS';assert name not in cases[arm];cases[arm].append(name)
   cp=root/(name+'.command.json');c=json.load(open(cp));pins[str(cp)]=sha(cp);assert c['environment']['HONE_FLOOR_WORLD']==arm
   assert c['command'][0]==str(B/'build-adapter/native-render') and c['command'][2]==str(root/name) and c['command'][3]==str(int(f['reverse']))
   for e,h in f['files'].items():p=Path(str(root/name)+e);assert sha(p)==h;pins[str(p)]=h
   for p,h in c['runtimeInputs'].items():assert sha(p)==h;pins[p]=h
  assert cases[arm][0]=='native-front-baseline'
 write(R/'ACTUAL_BASELINE_PINS.json',{'status':'COMPLETED_SAME_ARM_ORDER_PINNED','cases':cases,'pins':pins,'actualFrames':0});print('PREPARED_NO_RENDER')
def check():
 g=json.load(open(G));assert g['independentReviewSHA256']==sha(R/'review/REVIEW.json');assert g['status']=='SEGMENTED_MODEL_ARENA_FIXED40_APPROVED';assert g['runnerSHA256']==sha(__file__);assert g['runnerReviewSHA256']==sha(R/'review/RUNNER_REVIEW.json');assert g['baselinePinsSHA256']==sha(R/'ACTUAL_BASELINE_PINS.json')
 assert g['sourceFreezeSHA256']==sha(R/'SOURCE_FREEZE.json');f=json.load(open(R/'SOURCE_FREEZE.json'));assert all(sha(R/k)==v for k,v in f['files'].items())
 build=json.load(open(R/'build-adapter/BUILD.json'));assert sha(R/'build-adapter/native-render')==build['binarySHA256'];assert g['observerBuildSHA256']==sha(R/'build-adapter/BUILD.json');assert all(sha(W/k)==v for k,v in build['files'].items())
 assert all(sha(R/'build-adapter'/k)==v for k,v in build['stackFiles'].items());assert g['productStackSHA256']==sha(R/'PRODUCT_NAMED_STACK.json')
 b=json.load(open(R/'ACTUAL_BASELINE_PINS.json'));assert all(sha(k)==v for k,v in b['pins'].items());return b,build
if sys.argv[1:]==['--prepare']:prepare();sys.exit(0)
assert len(sys.argv)==3 and sys.argv[1] in ['off','on'] and sys.argv[2] in ['canary','remaining'];arm,mode=sys.argv[1:];base,build=check();out=R/f'actual-{arm}-001';oldroot=B/f'actual-{arm}-001';frames=json.load(open(oldroot/'COMPLETED.json'))['frames'];assert [f['name'] for f in frames]==base['cases'][arm]
if arm=='on':assert json.load(open(R/'actual-off-001/COMPLETED.json'))['status']=='ALL20_EXACT_COMPLETE'
if mode=='canary':out.mkdir(exist_ok=False);selected=frames[:1];completed=[]
else:
 assert json.load(open(out/'canary.json'))['status']=='PASS';completed=json.load(open(out/'completed-cases.json'));assert len(completed)>=1;selected=frames[1:]
for f in completed:assert all(sha(Path(str(out/f['name'])+e))==h for e,h in f['files'].items())
raw=['.u16le','.f32le','.snapshot','.targets.u8','.hdr.f64le'];reports=['.json','.aa.json','.floor.json','.background.json','.row.json','.floor-world.json','.hdr-observer.json']
timing={'.json':['transportBuildNs','visibilityBuildNs','appendNs','evaluateNs','hostRenderNsFirstFrame'],'.background.json':['backgroundBuildNs'],'.row.json':['backgroundBuildNs']}
for frame in selected:
 name=frame['name']
 if any(f['name']==name for f in completed):continue
 check();prefix=out/name;old=oldroot/name;assert not any(out.glob(name+'.*')),'Preserve existing attempt; manual investigation required'
 c=json.load(open(str(old)+'.command.json'));args=[str(R/'build-adapter/native-render'),c['command'][1],str(prefix),*c['command'][3:]];env={k:v for k,v in os.environ.items() if not k.startswith('HONE_')};env.update(c['environment']);assert env['HONE_FLOOR_WORLD']==arm
 state={'status':'RUNNING','arm':arm,'case':name,'completedFrames':len(completed),'command':args,'environment':c['environment'],'runtimeInputs':c['runtimeInputs'],'runnerPID':os.getpid(),'binarySHA256':build['binarySHA256'],'gateSHA256':sha(G),'startedUTC':datetime.datetime.now(datetime.timezone.utc).isoformat()};pending=Path(str(prefix)+'.stdout-pending');err=Path(str(prefix)+'.stderr');start=time.monotonic()
 with pending.open('x') as stdout,err.open('x') as stderr:
  proc=subprocess.Popen(args,env=env,stdout=stdout,stderr=stderr);state['renderPID']=proc.pid;write(out/'progress.json',state);write(out/(name+'.command.json'),state);write(R/'ACTIVE_JOB.json',state);print('START',arm,name,'runnerPID',os.getpid(),'renderPID',proc.pid,flush=True);ret=proc.wait()
 state.update(status='VALIDATING' if ret==0 else 'FAILED',returncode=ret,elapsedSeconds=time.monotonic()-start);write(out/'progress.json',state)
 try:
  assert ret==0 and not err.read_text(),err.read_text()
  for e in raw:assert Path(str(prefix)+e).read_bytes()==Path(str(old)+e).read_bytes(),e
  exclusions={}
  for e in reports:
   current=json.load(open(pending if e=='.json' else str(prefix)+e));expected=json.load(open(str(old)+e));ignored={}
   for key in timing.get(e,[]):ignored[key]={'baseline':expected.pop(key),'candidate':current.pop(key)}
   if e=='.json':
    assert expected['arenaBytes64bit']==81356 and current['arenaBytes64bit']==81796
    ignored['arenaBytes64bit']={'baseline':81356,'candidate':81796}
    expected['arenaBytes64bit']=81796
   assert current==expected,(e,{k:(current.get(k),expected.get(k)) for k in current.keys()|expected.keys() if current.get(k)!=expected.get(k)})
   exclusions[e]=ignored
  check();pending.rename(Path(str(prefix)+'.json'))
  row={'name':name,'view':frame['view'],'case':frame['case'],'reverse':frame['reverse'],'arm':arm,'status':'PASS','elapsedSecondsDescriptiveOnly':state['elapsedSeconds'],'files':{e:sha(Path(str(prefix)+e)) for e in raw+reports},'allRawExact':True,'sameArmSameOrderReportsExact':True,'onlyNontimingDifference':{'arenaBytes64bit':[81356,81796]},'timingExclusions':exclusions};completed.append(row);write(out/'completed-cases.json',completed);state.update(status='PASS',completedFrames=len(completed));write(out/'progress.json',state);write(R/'ACTIVE_JOB.json',state);print('PASS',arm,name,len(completed),flush=True)
 except Exception as exc:
  state.update(status='FAILED_VALIDATION',error=repr(exc),successManifestPublished=False);write(out/'FAILED.json',state);write(out/'progress.json',state);write(R/'ACTIVE_JOB.json',state);raise
if mode=='canary':write(out/'canary.json',{'status':'PASS','arm':arm,'frames':completed,'all20Complete':False})
else:
 assert len(completed)==20 and {f['name'] for f in completed}==set(base['cases'][arm])
 for f in completed:
  if not f['reverse']:
   for e in ['.u16le','.f32le','.targets.u8','.hdr.f64le']:assert Path(str(out/f['name'])+e).read_bytes()==Path(str(out/(f['name']+'-reverse'))+e).read_bytes()
 check();write(out/'COMPLETED.json',{'status':'ALL20_EXACT_COMPLETE','arm':arm,'frames':completed,'allForwardReverseExact':True,'baseline':str(oldroot.relative_to(W)),'timingClaim':'Descriptive only, no speedup or device fit claim'})
