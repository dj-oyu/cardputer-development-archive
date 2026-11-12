from pathlib import Path
import os,json,subprocess,statistics,time
R=Path(__file__).resolve().parent;D=R/'timing-001';D.mkdir(exist_ok=False);rows=[];start=time.time();c=json.loads((R/'off-001/inputs/candidate-config.json').read_text())
for v in c['cameras']:
 for case in c['scenarios']:
  for reverse in [0]:
   samples=[[],[],[]]
   for rep in range(3):
    for enabled in ([0,1,2] if rep%2==0 else [2,1,0]):
     a=R/(['off-001','world-001','bounce-001'][enabled]);env=dict(os.environ,HONE_LINEAR_LIGHT='1',HONE_PIXEL_LIGHT='1',HONE_PIXEL_VISIBILITY='1',HONE_TRANSPORT_MODE=str(enabled),HONE_OUTER_SAMPLES='16',HONE_DISK_FILE=str(a/f"physical-{case['name']}.txt"));p=subprocess.run([str(a/'native-render'),str(a/f"model-{case['name']}/model.aynm"),str(D/'scratch'),str(reverse),*map(str,v['nativeCamera']),*map(str,case['nativeDirection']+case['intensity'])],check=True,capture_output=True,text=True,env=env);m=json.loads(p.stdout);assert m['visibilityEnabled'] and m['transportMode']==enabled;samples[enabled].append({k:m[k] for k in ['evaluateNs','appendNs','hostRenderNsFirstFrame','shadeUpdates','diskSamples','visibilityBuildNs','visibilityRays','visibilityNodeVisits','visibilityTriangleTests','transportBuildNs','transportRays','transportNodeVisits','transportTriangleTests']})
   ns=['evaluateNs','appendNs','hostRenderNsFirstFrame','visibilityBuildNs','transportBuildNs'];rows.append({'view':v['name'],'case':case['name'],'reverse':bool(reverse),'samples':samples,'median':[{k:statistics.median(x[k] for x in ss) for k in ns} for ss in samples],'min':[{k:min(x[k] for x in ss) for k in ns} for ss in samples],'max':[{k:max(x[k] for x in ss) for k in ns} for ss in samples]})
(D/'results.json').write_text(json.dumps({'startUnix':start,'endUnix':time.time(),'scope':'O2 unsanitized same host,3 alternating repetitions each arm/all10cases/forward only; reverse cost measured separately in full run; small sample/no speed precision claim;init included in eval;not device timing/F64-FPU cost unknown','rows':rows},indent=2));print('CPU_DONE',time.time())
