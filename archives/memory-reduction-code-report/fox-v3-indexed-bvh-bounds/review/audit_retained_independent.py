"""Read-only verification of completed retained files. Never starts a renderer."""
from pathlib import Path
import json,hashlib,sys,math
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-visibility-lifetime-reduction'
RAW=['.u16le','.f32le','.snapshot','.targets.u8','.hdr.f64le']
REPORTS=['.json','.aa.json','.floor.json','.background.json','.row.json','.floor-world.json','.hdr-observer.json','.cache.json','.depth-stream.json']
TIMES={'.json':{'transportBuildNs','visibilityBuildNs','appendNs','evaluateNs','hostRenderNsFirstFrame'},'.background.json':{'backgroundBuildNs'},'.row.json':{'backgroundBuildNs'}}
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 def pairs(items):
  x={}
  for k,v in items:assert k not in x,('duplicate key',p,k);x[k]=v
  return x
 return json.loads(Path(p).read_text(),object_pairs_hook=pairs,parse_constant=lambda x:(_ for _ in ()).throw(AssertionError(x)))
def equal(a,b,path=()):
 assert type(a)==type(b),('type',path,type(a),type(b))
 if isinstance(a,dict):
  assert a.keys()==b.keys(),('keys',path)
  for k in a:equal(a[k],b[k],(*path,k))
 elif isinstance(a,list):
  assert len(a)==len(b),('len',path)
  for k,(x,y) in enumerate(zip(a,b)):equal(x,y,(*path,k))
 else:assert a==b,('value',path,a,b)
def freeze():
 g=read(R/'PHYSICAL_EXECUTION_GATE.json');assert g['status']=='INDEXED_BOUNDS_FIXED42_APPROVED' and g['actualFrameLimit']==42
 assert g['authorFreezeApproved'] and g['independentReviewApproved'] and g['safetyGO']
 for k,p in {'runnerSHA256':'comparison/run_fixed40.py','comparatorSHA256':'comparison/report_contract.py','contractSHA256':'comparison/REPORT_CONTRACT.json','baselinePinsSHA256':'comparison/BASELINE_PINS.json','planSHA256':'comparison/PLAN.md','sourceFreezeSHA256':'SOURCE_FREEZE.json','reviewSHA256':'review/REVIEW.json','runnerReviewSHA256':'review/RUNNER_REVIEW.json','buildSHA256':'build-adapter/BUILD.json'}.items():assert sha(R/p)==g[k],p
 for p,h in g['additionalRequiredFiles'].items():assert sha(R/p)==h,p
 for root in [R,B]:
  for p,h in read(root/'SOURCE_FREEZE.json')['files'].items():assert sha(root/p)==h,p
 for p,h in read(R/'comparison/BASELINE_PINS.json')['pins'].items():assert sha(p)==h,p
 build=read(R/'build-adapter/BUILD.json');assert sha(R/'build-adapter/native-render')==build['binarySHA256']
 for p,h in build['files'].items():assert sha(R.parent/p)==h,p
 return g,build

def frame(arm,mode,f,g,build):
 folder=('actual-' if mode=='diagnostic' else 'production-')+arm+'-001';n=f['name'];old=B/folder/n;new=R/folder/n
 assert f['status']=='PASS' and f['arm']==arm and f['mode']==mode
 exts=RAW if mode=='diagnostic' else [x for x in RAW if x!='.f32le']
 assert set(f['files'])==set(exts+REPORTS)
 for e in exts:
  a=Path(str(old)+e).read_bytes();b=Path(str(new)+e).read_bytes();assert a==b,('raw',arm,mode,n,e)
 for e,h in f['files'].items():assert sha(str(new)+e)==h,(n,e)
 if mode=='production':
  assert not Path(str(new)+'.f32le').exists()
  for e in exts:assert Path(str(new)+e).read_bytes()==Path(str(R/f'actual-{arm}-001'/n)+e).read_bytes()
 for e in REPORTS:
  a,b=read(str(old)+e),read(str(new)+e)
  for k in TIMES.get(e,set()):
   for d in [a,b]:
    x=d.pop(k);assert type(x) in [int,float] and math.isfinite(x) and x>=0
  if e=='.json':
   assert a['visibilitySceneNodes']==b['visibilitySceneNodes']==1023
   assert a['visibilitySceneBytes']==106104 and b['visibilitySceneBytes']==69276
   assert a['visibilitySceneBytes']-b['visibilitySceneBytes']==36*b['visibilitySceneNodes']
   assert a['visibilityTemporaryBytes']==b['visibilityTemporaryBytes']==46800
   a['visibilitySceneBytes']=b['visibilitySceneBytes']
  equal(a,b,(arm,mode,n,e))
 command=read(str(new)+'.command.json');prior=read(str(old)+'.command.json')
 equal(command['environment'],prior['environment']);equal(command['runtimeInputs'],prior['runtimeInputs'])
 assert command['command']==[str(R/'build-adapter/native-render'),prior['command'][1],str(new),*prior['command'][3:]]
 assert command['binarySHA256']==build['binarySHA256'] and command['gateSHA256']==sha(R/'PHYSICAL_EXECUTION_GATE.json')
 assert Path(str(new)+'.stderr').read_bytes()==b'' and not Path(str(new)+'.stdout-pending').exists()
 v=read(str(new)+'.json');aa=read(str(new)+'.aa.json');row=read(str(new)+'.row.json');depth=read(str(new)+'.depth-stream.json')
 assert v['visibilityComplete'] and v['transportComplete'] and aa['complete'] and row['complete']
 assert aa['observedTotal']<=aa['reservedTotal']<=8000000
 assert depth['producerWorkIncludingDepth']==sum(row['producerUsed'])+depth['pendingCopyFloats']+depth['captureCopyFloats']<=637599
 assert row['hostFinishHashBytes']<=row['hostFinishHashLimit']==73728 and row['adapterGuardUpper']==1024
 for kind in ['visibility','transport']:
  for used,cap in [('Rays','RayLimit'),('NodeVisits','NodeLimit'),('TriangleTests','TriangleLimit')]:assert v[kind+used]<=v[kind+cap]
 return {'arm':arm,'mode':mode,'name':n,'rawComparisons':len(exts),'reportComparisons':9,'sceneBytes':69276,'sceneNodes':1023,'visibilityRays':v['visibilityRays'],'visibilityNodeVisits':v['visibilityNodeVisits'],'visibilityTriangleTests':v['visibilityTriangleTests'],'transportRays':v['transportRays'],'transportNodeVisits':v['transportNodeVisits'],'transportTriangleTests':v['transportTriangleTests'],'producerWorkIncludingDepth':depth['producerWorkIncludingDepth']}
def main():
 g,build=freeze();rows=[];forward=0
 if len(sys.argv)==3 and sys.argv[1]=='--canary':
  arm=sys.argv[2];assert arm in ['off','on'];m=read(R/f'actual-{arm}-001/canary.json');assert m['status']=='PASS' and len(m['frames'])==1
  rows=[frame(arm,'diagnostic',m['frames'][0],g,build)];out=R/f'review/CANARY_{arm.upper()}_RETAINED_REVIEW.json'
 else:
  assert sys.argv[1:]==['--final']
  pins=read(R/'comparison/BASELINE_PINS.json')
  for mode in ['diagnostic','production']:
   for arm in ['off','on']:
    folder=('actual-' if mode=='diagnostic' else 'production-')+arm+'-001';m=read(R/folder/'COMPLETED.json');names=pins['cases'][arm] if mode=='diagnostic' else ['native-front-baseline']
    assert [f['name'] for f in m['frames']]==names
    for f in m['frames']:
     rows.append(frame(arm,mode,f,g,build))
     if mode=='diagnostic' and not f['reverse']:
      for e in ['.u16le','.f32le','.targets.u8','.hdr.f64le']:
       assert Path(str(R/folder/f['name'])+e).read_bytes()==Path(str(R/folder/(f['name']+'-reverse'))+e).read_bytes();forward+=1
  assert len(rows)==42 and sum(x['rawComparisons'] for x in rows)==208 and sum(x['reportComparisons'] for x in rows)==378 and forward==80
  out=R/'review/FINAL_RETAINED_REVIEW.json'
 freeze()
 report={'status':'PASS_INDEPENDENT_RETAINED_REVIEW','verifiedFrames':len(rows),'rawComparisons':sum(x['rawComparisons'] for x in rows),'reportComparisons':sum(x['reportComparisons'] for x in rows),'forwardReverseComparisons':forward,'frames':rows,'sourceFreezeSHA256':sha(R/'SOURCE_FREEZE.json'),'gateSHA256':sha(R/'PHYSICAL_EXECUTION_GATE.json'),'auditSourceSHA256':sha(__file__),'scope':'Read-only retained verification; no renderer launches, rerenders, source changes or additional report exceptions. Actual observations retain HDR diagnostic state; not device/product whole-process fit.'}
 out.write_text(json.dumps(report,indent=2)+'\n');print(str(out),sha(out))
if __name__=='__main__':main()
