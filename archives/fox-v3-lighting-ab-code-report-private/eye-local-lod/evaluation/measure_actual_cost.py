"""Prepared only: owner must explicitly start after independent heavy work ends."""
import pathlib,json,os,sys,subprocess,statistics,argparse
R=pathlib.Path(__file__).resolve().parent;sys.path.insert(0,str(R/'code'));from geometry_certificate import sha,verify,runtime
ap=argparse.ArgumentParser();ap.add_argument('--independent-heavy-finished',action='store_true',required=True);ap.add_argument('--output',type=pathlib.Path,required=True);args=ap.parse_args();O=args.output.resolve();O.mkdir(exist_ok=False)
arms={'stage2':(str(R.parent/'fox-v3-occlusion-evaluation/actual-stage2'),'810bab6469f8973efefdb6d490aca5619fcecf9e126fd11d85aa14555bbde1e2'),'eyeA':('actual-eyeA','2492c3ccef7916a72a151c07d220d37c2bc76f9a58c30751d6668dda9315c1ce'),'eyeB':('actual-eyeB','a8b9778f4915b6bab4a9c2312397f361280c4ef787353a466082fe87e803b116')};configs={};certs={};pins={};flags=None
for arm,(directory,pin) in arms.items():
 B=R/directory;certs[arm]=verify(B,pin);configs[arm]=json.loads((B/'inputs/candidate-config.json').read_text());m=json.loads((B/'candidate-manifest.json').read_text());f=m['build']['flags'];assert '-O2' in f
 if flags is None:flags=f
 else:assert f==flags
 for p in [B/'native-render',B/'compiled/model-baseline/model.aynm',B/'inputs/candidate-config.json',B/'inputs/ground-baseline.txt',B/'physical-baseline.txt']:pins[str(p)]=sha(p)
 assert sha(B/'native-render')==m['build']['binarySHA256']
rows=[];names=list(arms)
for rep in range(3):
 # Rotate which arm leads, keep the requested view pair and three runs per cell.
 order=names[rep:]+names[:rep]
 for view in ['front','oblique']:
  for arm in order:
   directory,pin=arms[arm];B=R/directory;cfg=configs[arm];cam=next(c['nativeCamera'] for c in cfg['cameras'] if c['name']==view);s=next(s for s in cfg['scenarios'] if s['name']=='baseline');prefix=O/f'{rep}-{view}-{arm}';env=dict(os.environ,HONE_LINEAR_LIGHT='1',HONE_PIXEL_LIGHT='1',HONE_PIXEL_VISIBILITY='1',HONE_TRANSPORT_MODE='2',HONE_OUTER_SAMPLES='16',HONE_GROUND_MODE='2',HONE_GROUND_FILE=str(B/s['ground']['inputFile']),HONE_DISK_FILE=str(B/'physical-baseline.txt'))
   command=[str(B/'native-render'),str(B/'compiled/model-baseline/model.aynm'),str(prefix),'0',*map(str,cam),*map(str,s['nativeDirection']+s['intensity'])];p=subprocess.run(command,capture_output=True,text=True,env=env);pathlib.Path(str(prefix)+'.stdout').write_text(p.stdout);pathlib.Path(str(prefix)+'.stderr').write_text(p.stderr);assert p.returncode==0,(arm,view,rep,p.stderr)
   a=json.loads(p.stdout);runtime(a,certs[arm]);assert a['transportComplete'] and a['visibilityComplete'];assert a['work']<=8000000
   for ext in ['.u16le','.f32le']:assert pathlib.Path(str(prefix)+ext).read_bytes()==(B/f'native-{view}-baseline{ext}').read_bytes(),'byte parity failed'
   rows.append({'rep':rep,'view':view,'arm':arm,'evaluateNs':a['evaluateNs'],'hostRenderNsFirstFrame':a['hostRenderNsFirstFrame'],'appendNs':a['appendNs'],'allBytesExact':True,'metadata':a});(O/'progress.json').write_text(json.dumps(rows,indent=2))
assert len(rows)==18;assert all(sha(pathlib.Path(p))==h for p,h in pins.items())
for arm,(directory,pin) in arms.items():verify(R/directory,pin)
summary={}
for arm in arms:
 summary[arm]={}
 for view in ['front','oblique']:
  group=[r for r in rows if r['arm']==arm and r['view']==view];assert len(group)==3
  summary[arm][view]={k:{'min':min(v),'median':statistics.median(v),'max':max(v)} for k in ['evaluateNs','hostRenderNsFirstFrame','appendNs'] for v in [[x[k] for x in group]]}
result={'status':'COMPLETE','renders':18,'repeatsPerArmView':3,'flags':flags,'allRGBDepthBytesExact':True,'summaryNs':summary,'inputHashes':pins,'order':[{k:r[k] for k in ['rep','view','arm']} for r in rows],'scope':'Sequential host monotonic timing after owner confirmed heavy work finished; not target-device timing'};(O/'COMPLETED.json').write_text(json.dumps(result,indent=2));print(json.dumps(result['summaryNs'],indent=2))
