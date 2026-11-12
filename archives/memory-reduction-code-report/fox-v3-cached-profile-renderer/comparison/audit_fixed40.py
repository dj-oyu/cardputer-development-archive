"""Retained artifact audit only: never invokes a renderer."""
from pathlib import Path
import hashlib,json,math
from report_contract import compare_reports,validate_cache
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-aa-phase-overlay'
def read(p):return json.loads(Path(p).read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def verify(p,h):assert sha(p)==h,str(p)
g=read(R/'PHYSICAL_EXECUTION_GATE.json');assert g['status']=='CACHED_PROFILE_RENDERER_FIXED40_APPROVED'
for k,p in [('runnerSHA256','comparison/run_fixed40.py'),('reportComparatorSHA256','comparison/report_contract.py'),('reportContractSHA256','comparison/REPORT_CONTRACT.json'),('runnerReviewSHA256','review/RUNNER_REVIEW.json'),('baselinePinsSHA256','ACTUAL_BASELINE_PINS.json'),('sourceFreezeSHA256','SOURCE_FREEZE.json'),('observerBuildSHA256','build-adapter/BUILD.json'),('independentReviewSHA256','review/REVIEW.json'),('productStackSHA256','PRODUCT_NAMED_STACK.json')]:verify(R/p,g[k])
for p,h in read(R/'SOURCE_FREEZE.json')['files'].items():verify(R/p,h)
build=read(R/'build-adapter/BUILD.json');verify(R/'build-adapter/native-render',build['binarySHA256'])
for p,h in build['files'].items():verify(R.parent/p,h)
for p,h in build['stackFiles'].items():verify(R/'build-adapter'/p,h)
pins=read(R/'ACTUAL_BASELINE_PINS.json')
for p,h in pins['pins'].items():verify(p,h)
raw=['.u16le','.f32le','.snapshot','.targets.u8','.hdr.f64le'];reports=['.json','.aa.json','.floor.json','.background.json','.row.json','.floor-world.json','.hdr-observer.json']
counts={'frames':0,'raw':0,'reports':0,'forwardReverse':0};observations={}
for arm in ['off','on']:
 root=R/f'actual-{arm}-001';base=B/f'actual-{arm}-001';manifest=read(root/'COMPLETED.json');old=read(base/'COMPLETED.json')
 assert manifest['status']=='ALL20_EXACT_COMPLETE' and manifest['allForwardReverseExact'] and len(manifest['frames'])==20
 assert [f['name'] for f in manifest['frames']]==pins['cases'][arm]
 measures=[]
 for f,bf in zip(manifest['frames'],old['frames']):
  assert (f['name'],f['arm'],f['status'],f['reverse'])==(bf['name'],arm,'PASS',bf['reverse'])
  p=root/f['name'];b=base/f['name'];assert set(f['files'])==set(raw+reports+['.cache.json'])
  for e,h in f['files'].items():verify(str(p)+e,h)
  for e,h in bf['files'].items():verify(str(b)+e,h)
  for e in raw:assert Path(str(p)+e).read_bytes()==Path(str(b)+e).read_bytes(),(f['name'],e);counts['raw']+=1
  for e in reports:
   delta=compare_reports(e,read(str(b)+e),read(str(p)+e),R/'comparison/REPORT_CONTRACT.json',arm);assert f['timingExclusions'][e]==delta;counts['reports']+=1
  validate_cache(read(str(p)+'.cache.json'))
  c=read(str(p)+'.command.json');bc=read(str(b)+'.command.json')
  assert c['command']==[str(R/'build-adapter/native-render'),bc['command'][1],str(p),*bc['command'][3:]]
  assert c['environment']==bc['environment'] and c['runtimeInputs']==bc['runtimeInputs']
  assert c['binarySHA256']==build['binarySHA256'] and c['gateSHA256']==sha(R/'PHYSICAL_EXECUTION_GATE.json')
  aa=read(str(p)+'.aa.json');row=read(str(p)+'.row.json');v=read(str(p)+'.json')
  assert aa['complete'] and row['complete'] and v['visibilityComplete'] and v['transportComplete']
  assert aa['observedTotal']<=aa['reservedTotal']<=8000000
  assert sum(row['producerUsed'])<=637599 and row['hostFinishHashBytes']<=row['hostFinishHashLimit']==73728 and row['adapterGuardUpper']==1024
  for kind in ['visibility','transport']:
   for used,limit in [('Rays','RayLimit'),('NodeVisits','NodeLimit'),('TriangleTests','TriangleLimit')]:assert v[kind+used]<=v[kind+limit]
  if not f['reverse']:
   for e in ['.u16le','.f32le','.targets.u8','.hdr.f64le']:assert Path(str(p)+e).read_bytes()==Path(str(root/(f['name']+'-reverse'))+e).read_bytes();counts['forwardReverse']+=1
  keys=['elapsedSecondsDescriptiveOnly','hostUserCPUSeconds','hostSystemCPUSeconds','hostPeakRSSKiB']
  assert all(type(f[k]) in (int,float) and math.isfinite(f[k]) and f[k]>=0 for k in keys)
  measures.append({k:f[k] for k in keys});counts['frames']+=1
 observations[arm]={'wallSeconds':sum(m['elapsedSecondsDescriptiveOnly'] for m in measures),'userCPUSeconds':sum(m['hostUserCPUSeconds'] for m in measures),'systemCPUSeconds':sum(m['hostSystemCPUSeconds'] for m in measures),'maximumProcessPeakRSSKiB':max(m['hostPeakRSSKiB'] for m in measures),'historicalBaselineWallSeconds':sum(f['elapsedSecondsDescriptiveOnly'] for f in old['frames'])}
assert counts=={'frames':40,'raw':200,'reports':280,'forwardReverse':80}
result={'status':'PASS_RETAINED_FIXED40_COMPARISON','comparisons':counts,'observations':observations,'timingClaim':'Historical descriptive observations only; not controlled performance, device speed or fit claims.','gateSHA256':sha(R/'PHYSICAL_EXECUTION_GATE.json'),'auditSHA256':sha(__file__),'rerenders':0}
(R/'comparison/FIXED40_RESULT.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
