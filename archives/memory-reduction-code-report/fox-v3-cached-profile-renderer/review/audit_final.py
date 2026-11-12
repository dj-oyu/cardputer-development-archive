"""Independent retained-frame verifier. No renderer and no comparator imports."""
from pathlib import Path
import json,hashlib,copy,math
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-aa-phase-overlay';sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest();read=lambda p:json.loads(Path(p).read_text())
def pin(p,h):assert sha(p)==h,str(p)
G=read(R/'PHYSICAL_EXECUTION_GATE.json');assert G['status']=='CACHED_PROFILE_RENDERER_FIXED40_APPROVED'
for key,p in [('runnerSHA256','comparison/run_fixed40.py'),('reportComparatorSHA256','comparison/report_contract.py'),('reportContractSHA256','comparison/REPORT_CONTRACT.json'),('runnerReviewSHA256','review/RUNNER_REVIEW.json'),('baselinePinsSHA256','ACTUAL_BASELINE_PINS.json'),('sourceFreezeSHA256','SOURCE_FREEZE.json'),('observerBuildSHA256','build-adapter/BUILD.json'),('independentReviewSHA256','review/REVIEW.json'),('productStackSHA256','PRODUCT_NAMED_STACK.json')]:pin(R/p,G[key])
for p,h in read(R/'SOURCE_FREEZE.json')['files'].items():pin(R/p,h)
for p,h in read(R/'review/REVIEW.json')['files'].items():pin(R/p,h)
pins=read(R/'ACTUAL_BASELINE_PINS.json');
for p,h in pins['pins'].items():pin(p,h)
for build in ('build-product','build-adapter'):
 m=read(R/build/'BUILD.json');pin(R/build/'native-render',m['binarySHA256'])
 for p,h in m['files'].items():pin(R.parent/p,h)
 for p,h in m['stackFiles'].items():pin(R/build/p,h)
raw=['.u16le','.f32le','.snapshot','.targets.u8','.hdr.f64le'];reports=['.json','.aa.json','.floor.json','.background.json','.row.json','.floor-world.json','.hdr-observer.json'];timing={'.json':['transportBuildNs','visibilityBuildNs','appendNs','evaluateNs','hostRenderNsFirstFrame'],'.background.json':['backgroundBuildNs'],'.row.json':['backgroundBuildNs']}
counts=dict(frames=0,raw=0,reports=0,reverse=0,cache=0);totals={};maxAA=maxProducer=0;allhits=allmisses=0
for arm,delta,pairs in [('off',28,(378,406)),('on',29,(406,435))]:
 root=R/f'actual-{arm}-001';base=B/f'actual-{arm}-001';m=read(root/'COMPLETED.json');bm=read(base/'COMPLETED.json');assert m['status']=='ALL20_EXACT_COMPLETE' and m['allForwardReverseExact'] and len(m['frames'])==20
 assert [f['name'] for f in m['frames']]==pins['cases'][arm]==[f['name'] for f in bm['frames']]
 assert not (root/'FAILED.json').exists()
 observations=[]
 for f,bf in zip(m['frames'],bm['frames']):
  name=f['name'];p=root/name;b=base/name;assert f['status']=='PASS' and f['arm']==arm and f['reverse']==bf['reverse'];assert set(f['files'])==set(raw+reports+['.cache.json'])
  for ext,h in f['files'].items():pin(str(p)+ext,h)
  for ext in raw:assert Path(str(p)+ext).read_bytes()==Path(str(b)+ext).read_bytes(),(name,ext);counts['raw']+=1
  for ext in reports:
   old=read(str(b)+ext);new=read(str(p)+ext);diff={}
   for key in timing.get(ext,[]):
    a=old.pop(key);v=new.pop(key);assert type(a) in (int,float) and type(v) in (int,float) and math.isfinite(a) and math.isfinite(v) and a>=0 and v>=0;diff[key]={'baseline':a,'candidate':v}
   if ext=='.row.json':
    a=old.pop('adapterSpanPairs');v=new.pop('adapterSpanPairs');assert (a,v)==pairs;diff['adapterSpanPairs']={'baseline':a,'candidate':v}
    a=old['producerUsed'][10];v=new['producerUsed'][10];assert v==a+delta and v<=1024;diff['producerUsed[10]']={'baseline':a,'candidate':v};old['producerUsed'][10]=v
   assert old==new,(name,ext);assert diff==f['timingExclusions'][ext];counts['reports']+=1
  c=read(str(p)+'.cache.json');fixed={'complete':True,'cacheBytes':3224,'blobBytes':445248,'profileCalls':32400,'invalidations':0,'bindIndexEntries':4914,'bindValidatedRecords':4913,'coldPerFrame':True,'selectedVertexLookups':129600,'retainedSnapshotBytesUpper':1584}
  assert set(c)==set(fixed)|{'hits','misses'}
  for k,v in fixed.items():assert type(c[k]) is type(v) and c[k]==v
  assert type(c['hits']) is int and type(c['misses']) is int and c['hits']>=0 and c['misses']>0 and c['hits']+c['misses']==129600
  allhits+=c['hits'];allmisses+=c['misses'];counts['cache']+=1
  cmd=read(str(p)+'.command.json');bc=read(str(b)+'.command.json');assert cmd['command']==[str(R/'build-adapter/native-render'),bc['command'][1],str(p),*bc['command'][3:]];assert cmd['environment']==bc['environment'] and cmd['runtimeInputs']==bc['runtimeInputs'];pin(R/'build-adapter/native-render',cmd['binarySHA256']);pin(R/'PHYSICAL_EXECUTION_GATE.json',cmd['gateSHA256'])
  aa=read(str(p)+'.aa.json');row=read(str(p)+'.row.json');assert aa['complete'] and row['complete'];assert aa['observedTotal']<=aa['reservedTotal']<=8000000;assert sum(row['producerUsed'])<=637599;assert row['hostFinishHashBytes']<=row['hostFinishHashLimit']==73728;maxAA=max(maxAA,aa['observedTotal']);maxProducer=max(maxProducer,sum(row['producerUsed']))
  if not f['reverse']:
   for ext in ('.u16le','.f32le','.targets.u8','.hdr.f64le'):assert Path(str(p)+ext).read_bytes()==Path(str(root/(name+'-reverse'))+ext).read_bytes();counts['reverse']+=1
  observations.append({k:f[k] for k in ('elapsedSecondsDescriptiveOnly','hostUserCPUSeconds','hostSystemCPUSeconds','hostPeakRSSKiB')});counts['frames']+=1
 totals[arm]={'wallSeconds':sum(x['elapsedSecondsDescriptiveOnly'] for x in observations),'userCPUSeconds':sum(x['hostUserCPUSeconds'] for x in observations),'systemCPUSeconds':sum(x['hostSystemCPUSeconds'] for x in observations),'maximumProcessPeakRSSKiB':max(x['hostPeakRSSKiB'] for x in observations),'historicalBaselineWallSeconds':sum(f['elapsedSecondsDescriptiveOnly'] for f in bm['frames']),'completionSHA256':sha(root/'COMPLETED.json')}
assert counts==dict(frames=40,raw=200,reports=280,reverse=80,cache=40)
out={'status':'PASS_INDEPENDENT_RETAINED_FIXED40','comparisons':counts,'cacheHits':allhits,'cacheMisses':allmisses,'selectedVertexLookups':allhits+allmisses,'invalidations':0,'maxObservedAA':maxAA,'maxProducerWork':maxProducer,'observations':totals,'allFrozenPinsVerified':True,'gateSHA256':sha(R/'PHYSICAL_EXECUTION_GATE.json'),'sourceFreezeSHA256':sha(R/'SOURCE_FREEZE.json'),'auditSHA256':sha(Path(__file__)),'rerenders':0,'qualification':'Descriptive historical host wall/CPU/RSS only. No controlled same-host speedup, target performance, whole-process or device fit claim. Completion markers certify accepted frames, not atomic multi-file publication.'}
(R/'review/FINAL_REVIEW.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
