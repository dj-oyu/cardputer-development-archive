"""Prepared integrated host comparison; explicit owner heavy-finished gate required."""
from pathlib import Path
import argparse,importlib.util,json,os,subprocess,statistics,sys
R=Path(__file__).resolve().parent;W=R.parent;sys.path.insert(0,str(R/'code'));from geometry_certificate import verify,runtime,sha
from codec_audit import audit
speca=importlib.util.spec_from_file_location('old_codec_audit',W/'fox-v3-normal-pair-evaluation/code/codec_audit.py');olda=importlib.util.module_from_spec(speca);speca.loader.exec_module(olda)
spec=importlib.util.spec_from_file_location('original_geometry_certificate',W/'fox-v3-normal-pair-evaluation/code/geometry_certificate.py');legacy=importlib.util.module_from_spec(spec);spec.loader.exec_module(legacy)
p=argparse.ArgumentParser();p.add_argument('--independent-heavy-finished',action='store_true',required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args();O=a.output.resolve();O.mkdir(exist_ok=False)
arms={'eyeB':(W/'fox-v3-normal-pair-evaluation/actual-on','a8d001fb56f999c90cc7ca75fe6ef6094a60ea5403979e6171635aa7eca5c10a',1),'lid8':(R/'actual-lid8-v2','a18011982c6e2338368a9e5bafacec6af5a5bad1c1206d05640cb075fcdb62c3',1),'lid9':(R/'actual-lid9-v2','4d5ece2a49f9111f8c881d4f0787db8595e8afaaef178839c9bd7a8f4ee5727b',1)};certs={};configs={};pins={};flags=None;contracts={}
for arm,(B,pin,mode) in arms.items():
 certs[arm]=(legacy.verify if arm=='eyeB' else verify)(B,pin);configs[arm]=json.loads((B/'inputs/candidate-config.json').read_text());m=json.loads((B/'candidate-manifest.json').read_text());f=m['build']['flags'];assert '-O2' in f
 if flags is None:flags=f
 else:assert f==flags
 assert sha(B/'native-render')==m['build']['binarySHA256']
 for path in [B/'native-render',B/'compiled/model-baseline/model.aynm',B/'inputs/candidate-config.json',B/'physical-baseline.txt',B/'inputs/ground-baseline.txt']:pins[str(path)]=sha(path)
 if mode is not None:contracts[arm]=json.loads((B/'inputs/codec-contract.json').read_text())
rows=[];names=list(arms)
for rep in range(3):
 for view in ['front','oblique']:
  for arm in names[rep:]+names[:rep]:
   B,pin,mode=arms[arm];cfg=configs[arm];cam=next(x['nativeCamera'] for x in cfg['cameras'] if x['name']==view);s=next(x for x in cfg['scenarios'] if x['name']=='baseline');prefix=O/f'{rep}-{view}-{arm}';env=dict(os.environ,HONE_LINEAR_LIGHT='1',HONE_PIXEL_LIGHT='1',HONE_PIXEL_VISIBILITY='1',HONE_TRANSPORT_MODE='2',HONE_OUTER_SAMPLES='16',HONE_GROUND_MODE='2',HONE_GROUND_FILE=str(B/s['ground']['inputFile']),HONE_DISK_FILE=str(B/'physical-baseline.txt'),HONE_NORMAL_PAIR_CODEC=str(mode or 0));cmd=[str(B/'native-render'),str(B/'compiled/model-baseline/model.aynm'),str(prefix),'0',*map(str,cam),*map(str,s['nativeDirection']+s['intensity'])];q=subprocess.run(cmd,capture_output=True,text=True,env=env);Path(str(prefix)+'.stdout').write_text(q.stdout);Path(str(prefix)+'.stderr').write_text(q.stderr);assert q.returncode==0,(arm,view,rep,q.stderr);m=json.loads(q.stdout);(legacy.runtime if arm=='eyeB' else runtime)(m,certs[arm]);assert m['transportComplete'] and m['visibilityComplete'] and m['work']<=8000000
   for ext in ['.u16le','.f32le']:assert Path(str(prefix)+ext).read_bytes()==(B/f'native-{view}-baseline{ext}').read_bytes(),(arm,view,rep,ext)
   if mode is not None:(olda.audit if arm=='eyeB' else audit)(Path(str(prefix)+'.snapshot').read_bytes(),contracts[arm],mode,view,'baseline',False,m)
   rows.append({'rep':rep,'view':view,'arm':arm,'evaluateNs':m['evaluateNs'],'appendNs':m['appendNs'],'renderNs':m['hostRenderNsFirstFrame'],'allRGBDepthBytesExact':True,'metadata':m});(O/'progress.json').write_text(json.dumps(rows,indent=2))
assert len(rows)==18 and all(sha(Path(p))==h for p,h in pins.items())
for arm,(B,pin,mode) in arms.items():(legacy.verify if arm=='eyeB' else verify)(B,pin)
summary={arm:{view:{k:{'min':min(v),'median':statistics.median(v),'max':max(v)} for k in ['evaluateNs','appendNs','renderNs'] for v in [[r[k] for r in rows if r['arm']==arm and r['view']==view]]} for view in ['front','oblique']} for arm in arms}
result={'status':'COMPLETE','renders':18,'repeatsPerArmView':3,'flags':flags,'inputPins':pins,'all36RGBDepthBuffersExact':True,'allCodecSnapshotsCanonicalExact':True,'summaryNs':summary,'order':[{k:r[k] for k in ['rep','view','arm']} for r in rows],'scope':'Sequential host timing after owner heavy-finished confirmation; native private dump IO is outside evaluation/append/render timers; not device speed'};(O/'COMPLETED.json').write_text(json.dumps(result,indent=2));print(json.dumps(summary,indent=2))
