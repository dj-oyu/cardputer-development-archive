"""42-frame gated replay: diagnostic fixed40 plus two no-depth-capture HDR canaries."""
from pathlib import Path
import os,sys,json,hashlib,subprocess,time,datetime,math
from report_contract import read,exact,compare_reports,compare_sidecar,REPORTS,RAW
assert not sys.flags.optimize,'PYTHONOPTIMIZE must be unset'
R=Path(__file__).resolve().parents[1];W=R.parent;B=W/'fox-v3-visibility-lifetime-reduction';C=R/'comparison';G=R/'PHYSICAL_EXECUTION_GATE.json'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,x):
 t=p.with_suffix(p.suffix+'.tmp');t.write_text(json.dumps(x,indent=2,allow_nan=False)+'\n');t.replace(p)
def base_root(arm,mode):return B/(f'actual-{arm}-001' if mode=='diagnostic' else f'production-{arm}-001')
def prepare():
 p=C/'BASELINE_PINS.json';assert not p.exists();pins={};cases={}
 for arm in ('off','on'):
  root=B/f'actual-{arm}-001';manifest=read(root/'COMPLETED.json')
  assert manifest['status']=='ALL20_EXACT_COMPLETE' and len(manifest['frames'])==20 and manifest['allForwardReverseExact']
  pins[str(root/'COMPLETED.json')]=sha(root/'COMPLETED.json');cases[arm]=[]
  for f in manifest['frames']:
   name=f['name'];assert name not in cases[arm] and f['arm']==arm and f['status']=='PASS';cases[arm].append(name)
   command=root/(name+'.command.json');c=read(command);pins[str(command)]=sha(command)
   assert c['command'][0]==str(B/'build-adapter/native-render') and c['command'][2]==str(root/name) and c['environment']['HONE_FLOOR_WORLD']==arm
   for e,h in f['files'].items():
    fpath=Path(str(root/name)+e);assert sha(fpath)==h;pins[str(fpath)]=h
   for fpath,h in c['runtimeInputs'].items():assert sha(fpath)==h;pins[fpath]=h
  assert cases[arm][0]=='native-front-baseline'
 for arm in ('off','on'):
  root=base_root(arm,'production');manifest=read(root/'COMPLETED.json')
  assert manifest['status']=='PRODUCTION_CANARY_EXACT_COMPLETE' and len(manifest['frames'])==1
  pins[str(root/'COMPLETED.json')]=sha(root/'COMPLETED.json')
  for f in manifest['frames']:
   assert f['name']=='native-front-baseline' and f['status']=='PASS' and f['mode']=='production'
   command=root/(f['name']+'.command.json');bc=read(command);pins[str(command)]=sha(command)
   assert bc['environment']['HONE_DEPTH_CAPTURE']=='off'
   for e,h in f['files'].items():
    fp=Path(str(root/f['name'])+e);assert sha(fp)==h;pins[str(fp)]=h
   for fp,h in bc['runtimeInputs'].items():assert sha(fp)==h;pins[fp]=h
 for p0 in [B/'SOURCE_FREEZE.json',B/'comparison/FIXED42_RESULT.json',B/'PHYSICAL_EXECUTION_GATE.json']:pins[str(p0)]=sha(p0)
 write(p,{'status':'COMPLETED_BASELINE_PINNED_NO_RENDER','cases':cases,'pins':pins,'actualFrames':0});print('PREPARED_NO_RENDER')
def check():
 g=read(G);assert g['status']=='INDEXED_BOUNDS_FIXED42_APPROVED' and g['actualFrameLimit']==42
 required={'runnerSHA256':'comparison/run_fixed40.py','comparatorSHA256':'comparison/report_contract.py','contractSHA256':'comparison/REPORT_CONTRACT.json','baselinePinsSHA256':'comparison/BASELINE_PINS.json','planSHA256':'comparison/PLAN.md','sourceFreezeSHA256':'SOURCE_FREEZE.json','reviewSHA256':'review/REVIEW.json','runnerReviewSHA256':'review/RUNNER_REVIEW.json','buildSHA256':'build-adapter/BUILD.json'}
 for k,p in required.items():assert sha(R/p)==g[k],p
 assert g['authorFreezeApproved'] is True and g['independentReviewApproved'] is True and g['safetyGO'] is True
 for p,h in read(R/'SOURCE_FREEZE.json')['files'].items():assert sha(R/p)==h,p
 assert 'MEMORY_LEDGER.json' in g['additionalRequiredFiles'],'Named indexed-bounds ledger must be gate-bound'
 for p,h in g['additionalRequiredFiles'].items():assert sha(R/p)==h,p
 build=read(R/'build-adapter/BUILD.json');assert sha(R/'build-adapter/native-render')==build['binarySHA256']
 for p,h in build['files'].items():assert sha(W/p)==h,p
 for p,h in build['stackFiles'].items():assert sha(R/'build-adapter'/p)==h,p
 pins=read(C/'BASELINE_PINS.json')
 for p,h in pins['pins'].items():assert sha(p)==h,p
 for p,h in read(B/'SOURCE_FREEZE.json')['files'].items():assert sha(B/p)==h,('baseline freeze',p)
 contract=read(C/'REPORT_CONTRACT.json');assert contract['status']=='FROZEN_REVIEWED_REPORT_CONTRACT'
 for arm in ('off','on'):
  assert set(contract['cases']['diagnostic'][arm])==set(pins['cases'][arm])
  assert set(contract['cases']['production'][arm])=={'native-front-baseline'}
 for key in ('memoryDeclarations','workDeclarations','observerDeclarations'):assert contract[key],('missing declarations',key)
 assert contract['memoryDeclarations']['status']=='COMPILED_REVIEWED_INDEXED_BOUNDS_LEDGER'
 assert contract['memoryDeclarations']['ledgerSHA256']==sha(R/'MEMORY_LEDGER.json')
 assert contract['sidecarExtension'] is None
 assert all(set(case['changes'])=={'.json'} and case['sidecar'] is None for modes in contract['cases'].values() for cases in modes.values() for case in cases.values())
 return pins,build,contract

def validate(prefix,old,arm,name,mode,pending=None):
 extensions=RAW if mode=='diagnostic' else [e for e in RAW if e!='.f32le']
 if mode=='production':assert not Path(str(prefix)+'.f32le').exists(),'production full-frame depth artifact forbidden'
 for e in extensions:
  value=Path(str(prefix)+e).read_bytes();assert value==Path(str(old)+e).read_bytes(),e
  if mode=='production':assert value==Path(str(R/f'actual-{arm}-001'/name)+e).read_bytes(),('diagnostic/production mismatch',e)
 observations={}
 for e in REPORTS:observations[e]=compare_reports(e,read(str(old)+e),read(pending if e=='.json' and pending is not None else str(prefix)+e),C/'REPORT_CONTRACT.json',arm,name,mode)
 depth=read(str(prefix)+'.depth-stream.json')
 row=read(str(prefix)+'.row.json')
 assert depth['producerWorkIncludingDepth']==sum(row['producerUsed'])+depth['pendingCopyFloats']+depth['captureCopyFloats']<=637599
 return extensions+REPORTS,observations

def run(arm,stage):
 pins,build,contract=check();mode='production' if stage=='production' else 'diagnostic'
 out=R/(f'production-{arm}-001' if mode=='production' else f'actual-{arm}-001');base=base_root(arm,mode);frames=read(base/'COMPLETED.json')['frames']
 if mode=='production':
  assert all(read(R/f'actual-{a}-001/COMPLETED.json')['status']=='ALL20_EXACT_COMPLETE' for a in ('off','on'))
  if arm=='on':assert read(R/'production-off-001/COMPLETED.json')['status']=='PRODUCTION_CANARY_EXACT_COMPLETE'
 elif arm=='on':assert read(R/'actual-off-001/COMPLETED.json')['status']=='ALL20_EXACT_COMPLETE'
 if stage in ('canary','production'):out.mkdir(exist_ok=False);selected=frames[:1];completed=[]
 else:
  assert read(out/'canary.json')['status']=='PASS';completed=read(out/'completed-cases.json');assert len(completed)>=1;selected=frames[1:]
 for f in completed:
  for e,h in f['files'].items():assert sha(str(out/f['name'])+e)==h
 for f in selected:
  name=f['name']
  if any(x['name']==name for x in completed):continue
  check();prefix=out/name;old=base/name;assert not any(out.glob(name+'.*')),'Existing attempt must be investigated, not overwritten'
  c=read(str(old)+'.command.json');args=[str(R/'build-adapter/native-render'),c['command'][1],str(prefix),*c['command'][3:]]
  additions=contract['environmentByMode'][mode];assert additions=={},'No environment changes for indexed bounds'
  assert not(set(additions)&set(c['environment'])),'Mode environment may not override baseline environment'
  recorded={**c['environment'],**additions};env={k:v for k,v in os.environ.items() if not k.startswith('HONE_')};env.update(recorded)
  state={'status':'RUNNING','arm':arm,'case':name,'mode':mode,'command':args,'environment':recorded,'runtimeInputs':c['runtimeInputs'],'runnerPID':os.getpid(),'binarySHA256':build['binarySHA256'],'gateSHA256':sha(G),'startedUTC':datetime.datetime.now(datetime.timezone.utc).isoformat()}
  pending=Path(str(prefix)+'.stdout-pending');err=Path(str(prefix)+'.stderr');start=time.monotonic()
  with pending.open('x') as stdout,err.open('x') as stderr:
   proc=subprocess.Popen(args,env=env,stdout=stdout,stderr=stderr);state['renderPID']=proc.pid;write(out/(name+'.command.json'),state);write(out/'progress.json',state);print('START',mode,arm,name,flush=True)
   pid,status,usage=os.wait4(proc.pid,0);assert pid==proc.pid;ret=os.waitstatus_to_exitcode(status);proc.returncode=ret
  state.update(returncode=ret,elapsedSecondsDescriptiveOnly=time.monotonic()-start,hostUserCPUSeconds=usage.ru_utime,hostSystemCPUSeconds=usage.ru_stime,hostPeakRSSKiB=usage.ru_maxrss)
  try:
   assert ret==0 and not err.read_text(),err.read_text()
   # stdout is a private unpublished report until validation succeeds.
   assert not Path(str(prefix)+'.json').exists()
   files,observations=validate(prefix,old,arm,name,mode,pending);check();pending.rename(Path(str(prefix)+'.json'))
   row={'name':name,'view':f['view'],'case':f['case'],'reverse':f['reverse'],'arm':arm,'mode':mode,'status':'PASS','files':{e:sha(str(prefix)+e) for e in files},'reportObservations':observations,**{k:state[k] for k in ('elapsedSecondsDescriptiveOnly','hostUserCPUSeconds','hostSystemCPUSeconds','hostPeakRSSKiB')}}
   completed.append(row);write(out/'completed-cases.json',completed);state.update(status='PASS',completedFrames=len(completed));write(out/'progress.json',state);print('PASS',mode,arm,name,flush=True)
  except Exception as exc:
   state.update(status='FAILED_VALIDATION',error=repr(exc),successManifestPublished=False);write(out/'FAILED.json',state);write(out/'progress.json',state);raise
 if stage=='canary':write(out/'canary.json',{'status':'PASS','frames':completed,'all20Complete':False})
 elif mode=='production':
  assert len(completed)==1;check();write(out/'COMPLETED.json',{'status':'PRODUCTION_CANARY_EXACT_COMPLETE','frames':completed,'actualNoDepthCaptureCases':1,'full40NoDepthCaptureCoverage':False})
 else:
  assert len(completed)==20 and [f['name'] for f in completed]==pins['cases'][arm]
  for f in completed:
   if not f['reverse']:
    for e in ['.u16le','.f32le','.targets.u8','.hdr.f64le']:assert Path(str(out/f['name'])+e).read_bytes()==Path(str(out/(f['name']+'-reverse'))+e).read_bytes()
  check();write(out/'COMPLETED.json',{'status':'ALL20_EXACT_COMPLETE','frames':completed,'allForwardReverseExact':True,'observer':'Full-frame diagnostic depth separately charged; not production memory'})
if __name__=='__main__':
 if sys.argv[1:]==['--prepare']:prepare()
 else:
  assert len(sys.argv)==3 and sys.argv[1] in ('off','on') and sys.argv[2] in ('canary','remaining','production');run(*sys.argv[1:])
