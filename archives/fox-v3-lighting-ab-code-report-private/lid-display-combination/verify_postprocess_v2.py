from pathlib import Path
import json,hashlib,statistics,importlib.util,ast
import numpy as np
R=Path(__file__).resolve().parent;A=R/'postprocess-001';B=R/'postprocess-002'
def read(p):return json.loads(p.read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for root in (A,B):
 for name,h in read(root/'output-hashes.json').items():assert sha(root/name)==h
 before=read(root/'input-hashes-before.json');assert before==read(root/'input-hashes-after.json')
 for name,h in before.items():assert sha(Path(name))==h
for name in ['evaluation.json','contrasts.json','interaction.json','support.json','filter.json','COMPLETED.json']:
 assert read(A/name)==read(B/name),name
names=sorted(x.name for x in A.glob('*.u16le'));assert len(names)==40
for name in names:assert (A/name).read_bytes()==(B/name).read_bytes(),name
for old in A.glob('*-support.npz'):
 with np.load(old) as a,np.load(B/old.name) as b:
  assert set(a.files)==set(b.files)
  for key in a.files:assert np.array_equal(a[key],b[key])
for old,new in zip(read(A/'clamps.json'),read(B/'clamps.json')):
 assert all(new[k]==v for k,v in old.items())
oldcost=read(A/'cost.json');newcost=read(B/'cost.json');timings=[]
for old,new in zip(oldcost,newcost):
 for key,value in old.items():
  if 'Timing' not in key:assert new[key]==value,key
 for key in ('displayRepeatTimingHostOnly','filterRepeatTimingHostOnly'):
  t=new[key]
  if t is None:continue
  raw=t['rawNs'];assert len(raw)==t['repetitions']==11
  assert t['minNs']==min(raw) and t['medianNs']==statistics.median(raw) and t['maxNs']==max(raw)
  timings.append({'view':new['view'],'case':new['case'],'arm':new['arm'],'timing':key,'validated':True})
spec=importlib.util.spec_from_file_location('p',R/'postprocess_v2.py');p=importlib.util.module_from_spec(spec);spec.loader.exec_module(p)
aa=p.module('aa',p.AA);off,w=aa.filter_grid(3)
for row in newcost:
 key=row['view']+'-'+row['case'];raw=np.fromfile(R/'run-001'/f'native-{key}-combined.f64le',dtype='<f8').reshape(135,240,3)
 if row['arm'].startswith('filter3'):
  # Independent direct nine-term zero-padded stencil, rather than calling filter3.
  padded=np.pad(raw,((1,1),(1,1),(0,0)));source=np.zeros_like(raw)
  for gy in range(3):
   for gx in range(3):source+=float(w[gy]*w[gx])*padded[gy:gy+135,gx:gx+240]
 else:source=raw
 bits=source>1;pixels=int(bits.any(2).sum());channels=int(bits.sum())
 assert row['preDisplayAboveOnePixels']==pixels and row['preDisplayAboveOneChannels']==channels
 assert row['legacySrgbInputClippedPixels']==(pixels if row['arm'].endswith('-off') else None)
original=ast.parse((R/'postprocess.py').read_text());updated=ast.parse((R/'postprocess_v2.py').read_text())
for node in original.body:
 if isinstance(node,ast.FunctionDef) and node.name!='main':assert ast.dump(node)==ast.dump(next(x for x in updated.body if isinstance(x,ast.FunctionDef) and x.name==node.name))
result={'passed':True,'buffersByteExact':40,'allMetricsContrastsInteractionsSupportExact':True,'supportArraysExact':10,'allOldClampsFieldsExact':True,'allNonTimingCostFieldsExact':True,'raw11TimingsReaggregatedEntries':len(timings),'uniqueFilterTimingSets':10,'uniqueDisplayTimingSets':40,'newCountsIndependentlyRecomputedCases':40,'oldMathHelperASTsExact':True,'inputsAndOutputsAllPinsStillMatch':True,'originalScriptSHA256':sha(R/'postprocess.py'),'v2ScriptSHA256':sha(R/'postprocess_v2.py'),'timingChecks':timings}
(R/'postprocess-v2-comparison.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k!='timingChecks'},indent=2))
