from pathlib import Path
import os,json,subprocess,statistics,time
R=Path(__file__).resolve().parent;D=R/'timing-001';D.mkdir(exist_ok=False);rows=[];start=time.time()
cs=[json.loads((R/a/'inputs/candidate-config.json').read_text()) for a in ['off-001','on-001']]
for view in cs[0]['cameras']:
 for case in cs[0]['scenarios']:
  samples=[[],[]]
  for rep in range(11):
   for enabled in ([0,1] if rep%2==0 else [1,0]):
    a=R/(['off-001','on-001'][enabled]);env=dict(os.environ,HONE_LINEAR_LIGHT='1',HONE_AGX_PROFILE=str(enabled),HONE_DISK_FILE=str(a/f"physical-{case['name']}.txt"));p=subprocess.run([str(a/'native-render'),str(a/f"model-{case['name']}/model.aynm"),str(D/'scratch'),'0',*map(str,view['nativeCamera']),*map(str,case['nativeDirection']+case['intensity'])],check=True,capture_output=True,text=True,env=env);m=json.loads(p.stdout);assert m['agxProfileEnabled']==bool(enabled);samples[enabled].append({k:m[k] for k in ['evaluateNs','hostRenderNsFirstFrame']})
  row={'view':view['name'],'case':case['name'],'samples':samples,'median':[{k:statistics.median(x[k] for x in ss) for k in ss[0]} for ss in samples],'min':[{k:min(x[k] for x in ss) for k in ss[0]} for ss in samples],'max':[{k:max(x[k] for x in ss) for k in ss[0]} for ss in samples]};rows.append(row)
(D/'results.json').write_text(json.dumps({'startUnix':start,'endUnix':time.time(),'scope':'O2 unsanitized same host, 11 alternating repetitions per arm per case; init included; not device timing','rows':rows},indent=2));print('CPU_DONE',time.time())
