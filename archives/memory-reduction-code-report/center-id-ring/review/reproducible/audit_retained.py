from pathlib import Path
import json,hashlib
R=Path('/workspace/scratch/6d8dcdbcdc54/fox-v3-center-id-ring');B=R.parent/'fox-v3-indexed-floor-world';D=Path('/tmp/center-id-ring-independent')
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
raw=['.u16le','.f32le','.snapshot','.targets.u8','.hdr.f64le'];reports=['.json','.aa.json','.floor.json','.background.json','.row.json','.floor-world.json','.hdr-observer.json']
timings={'.json':['transportBuildNs','visibilityBuildNs','appendNs','evaluateNs','hostRenderNsFirstFrame'],'.background.json':['backgroundBuildNs'],'.row.json':['backgroundBuildNs']}
rows=[]
for arm in ['off','on']:
 new=R/f'actual-{arm}-001';old=B/f'actual-{arm}-001';C=json.loads((new/'COMPLETED.json').read_text());O=json.loads((old/'COMPLETED.json').read_text());assert C['status']=='ALL20_EXACT_COMPLETE' and C['allForwardReverseExact']
 assert len(C['frames'])==20 and {f['name'] for f in C['frames']}=={f['name'] for f in O['frames']}
 for f in C['frames']:
  name=f['name'];assert f['arm']==arm and f['status']=='PASS';assert not (new/'FAILED.json').exists()
  assert set(f['files'])==set(raw+reports)
  for e,h in f['files'].items():assert sha(new/(name+e))==h,(arm,name,e,'candidate manifest')
  for e in raw:assert sha(new/(name+e))==sha(old/(name+e)),(arm,name,e,'raw parity')
  for e in reports:
   x=json.loads((new/(name+e)).read_text());y=json.loads((old/(name+e)).read_text())
   for k in timings.get(e,[]):x.pop(k);y.pop(k)
   if e=='.aa.json':assert x['workspaceBytes']==77312 and y['workspaceBytes']==137312;y['workspaceBytes']=77312
   assert x==y,(arm,name,e,'report parity')
  cmd=json.loads((new/(name+'.command.json')).read_text());ocmd=json.loads((old/(name+'.command.json')).read_text());assert cmd['environment']==ocmd['environment'] and cmd['runtimeInputs']==ocmd['runtimeInputs'];assert cmd['command'][1]==ocmd['command'][1] and cmd['command'][3:]==ocmd['command'][3:]
  assert (new/(name+'.stderr')).read_bytes()==b''
  if not f['reverse']:
   for e in ['.u16le','.f32le','.targets.u8','.hdr.f64le']:assert sha(new/(name+e))==sha(new/(name+'-reverse'+e))
  rows.append({'arm':arm,'name':name,'status':'PASS'})
result={'status':'INDEPENDENT_ALL40_RETAINED_EXACT_PASS','actualFramesRunByReviewer':0,'cases':rows,'rawComparisons':200,'reportComparisons':280,'forwardReverseRawComparisons':80,'allowedReportDelta':'workspace137312->77312 only, excluding seven named timings','completionManifestHashes':{arm:sha(R/f'actual-{arm}-001/COMPLETED.json') for arm in ['off','on']}}
(D/'RETAINED_ALL40_REVIEW.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k!='cases'},indent=2))
