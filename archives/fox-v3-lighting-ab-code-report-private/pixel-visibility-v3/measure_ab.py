from pathlib import Path
import os,json,subprocess,statistics,time
R=Path(__file__).resolve().parent;D=R/'timing-001';D.mkdir(exist_ok=False);rows=[];start=time.time();c=json.loads((R/'off-004/inputs/candidate-config.json').read_text())
for v in c['cameras']:
 for case in c['scenarios']:
  for reverse in [0,1]:
   samples=[[],[]]
   for rep in range(11):
    for enabled in ([0,1] if rep%2==0 else [1,0]):
     a=R/(['off-004','on-004'][enabled]);env=dict(os.environ,HONE_LINEAR_LIGHT='1',HONE_PIXEL_LIGHT='1',HONE_PIXEL_VISIBILITY=str(enabled),HONE_DISK_FILE=str(a/f"physical-{case['name']}.txt"));p=subprocess.run([str(a/'native-render'),str(a/f"model-{case['name']}/model.aynm"),str(D/'scratch'),str(reverse),*map(str,v['nativeCamera']),*map(str,case['nativeDirection']+case['intensity'])],check=True,capture_output=True,text=True,env=env);m=json.loads(p.stdout);assert m['visibilityEnabled']==bool(enabled);samples[enabled].append({k:m[k] for k in ['evaluateNs','appendNs','hostRenderNsFirstFrame','shadeUpdates','diskSamples','visibilityBuildNs','visibilityRays','visibilityNodeVisits','visibilityTriangleTests']})
   ns=['evaluateNs','appendNs','hostRenderNsFirstFrame','visibilityBuildNs'];rows.append({'view':v['name'],'case':case['name'],'reverse':bool(reverse),'samples':samples,'median':[{k:statistics.median(x[k] for x in ss) for k in ns} for ss in samples],'min':[{k:min(x[k] for x in ss) for k in ns} for ss in samples],'max':[{k:max(x[k] for x in ss) for k in ns} for ss in samples]})
(D/'results.json').write_text(json.dumps({'startUnix':start,'endUnix':time.time(),'scope':'O2 unsanitized same host,11alternatingrepetitions eacharm/case/order;init included in eval;not device timing/F64-FPU cost unknown','rows':rows},indent=2));print('CPU_DONE',time.time())
