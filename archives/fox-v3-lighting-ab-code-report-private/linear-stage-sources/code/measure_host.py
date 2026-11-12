import pathlib,json,subprocess,statistics,sys
r=pathlib.Path(sys.argv[1]).resolve();out=pathlib.Path(sys.argv[2]).resolve();out.mkdir(exist_ok=False,parents=True);c=json.loads((r/'inputs/candidate-config.json').read_text());rows=[]
for view in c['cameras']:
 for s in c['scenarios']:
  samples=[]
  for i in range(11):
   p=subprocess.run([str(r/'native-render'),str(r/('model-'+s['name'])/'model.aynm'),str(out/'scratch'),'0',*map(str,view['nativeCamera']),*map(str,s['nativeDirection']+s['intensity'])],capture_output=True,text=True,check=True);m=json.loads(p.stdout);samples.append({k:m[k] for k in ['evaluateNs','hostRenderNsFirstFrame']})
  rows.append({'view':view['name'],'case':s['name'],'repetitions':11,'samples':samples,'medianNs':{k:statistics.median(x[k] for x in samples) for k in samples[0]},'minNs':{k:min(x[k] for x in samples) for k in samples[0]},'maxNs':{k:max(x[k] for x in samples) for k in samples[0]}})
(out/'results.json').write_text(json.dumps({'scope':'unsanitized O2 host-only process repetitions, includes init in evaluate; no device or firmware timing','rows':rows},indent=2))
