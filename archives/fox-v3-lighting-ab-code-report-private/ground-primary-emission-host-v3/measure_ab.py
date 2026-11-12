from pathlib import Path
import os,json,subprocess,statistics,time
import hashlib
R=Path(__file__).resolve().parent;sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();pinfiles=[p for a in ['off','control','le'] for p in (R/f'{a}-001').rglob('*') if p.is_file() and (p.name in ['native-render','candidate-manifest.json','candidate-config.json'] or p.suffix in ['.aynm'] or p.name.startswith(('ground-','physical-')))] ; pins={str(p):sha(p) for p in pinfiles};D=R/'timing-001';D.mkdir(exist_ok=False);rows=[];start=time.time();c=json.loads((R/'off-001/inputs/candidate-config.json').read_text())
for v in c['cameras']:
 for case in c['scenarios']:
  for reverse in [0]:
   samples=[[],[],[]]
   for rep in range(3):
    for enabled in ([0,1,2] if rep%2==0 else [2,1,0]):
     a=R/(['off-001','control-001','le-001'][enabled]);env=dict(os.environ,HONE_LINEAR_LIGHT='1',HONE_PIXEL_LIGHT='1',HONE_PIXEL_VISIBILITY='1',HONE_TRANSPORT_MODE='2',HONE_GROUND_MODE=str(enabled),HONE_GROUND_FILE=str(a/case['ground']['inputFile']) if enabled else '',HONE_OUTER_SAMPLES='16',HONE_DISK_FILE=str(a/f"physical-{case['name']}.txt"));p=subprocess.run([str(a/'native-render'),str(a/f"model-{case['name']}/model.aynm"),str(D/'scratch'),str(reverse),*map(str,v['nativeCamera']),*map(str,case['nativeDirection']+case['intensity'])],check=True,capture_output=True,text=True,env=env);m=json.loads(p.stdout);assert m['visibilityEnabled'] and m['transportMode']==2 and m['groundMode']==enabled;assert m['linearLightEnabled'] and m['physicalDiskEnabled'] and m['transportComplete'] and not m['agxProfileEnabled'];assert all((D/('scratch'+e)).read_bytes()==(a/("native-"+v['name']+"-"+case['name']+e)).read_bytes() for e in ['.u16le','.f32le']);samples[enabled].append({k:m[k] for k in ['evaluateNs','appendNs','hostRenderNsFirstFrame','shadeUpdates','diskSamples','visibilityBuildNs','visibilityRays','visibilityNodeVisits','visibilityTriangleTests','transportBuildNs','transportRays','transportNodeVisits','transportTriangleTests']})
   print('DONE',v['name'],case['name'],time.time(),flush=True)
   ns=['evaluateNs','appendNs','hostRenderNsFirstFrame','visibilityBuildNs','transportBuildNs'];rows.append({'view':v['name'],'case':case['name'],'reverse':bool(reverse),'samples':samples,'median':[{k:statistics.median(x[k] for x in ss) for k in ns} for ss in samples],'min':[{k:min(x[k] for x in ss) for k in ns} for ss in samples],'max':[{k:max(x[k] for x in ss) for k in ns} for ss in samples]})
assert all(sha(Path(p))==h for p,h in pins.items());(D/'input-hashes.json').write_text(json.dumps(pins,indent=2))
(D/'results.json').write_text(json.dumps({'startUnix':start,'endUnix':time.time(),'scope':'O2 unsanitized same host,3 alternating repetitions each arm/all10cases/forward only; reverse cost measured separately in full run; small sample/no speed precision claim;init included in eval;not device timing/F64-FPU cost unknown','rows':rows},indent=2));print('CPU_DONE',time.time())
