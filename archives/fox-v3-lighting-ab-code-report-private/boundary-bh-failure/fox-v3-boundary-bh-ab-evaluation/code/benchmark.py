"""Isolated host 12-frame alternating benchmark; diagnostic ON observer I/O INCLUDED."""
from pathlib import Path
import os,sys,json,hashlib,subprocess,time,statistics
D=Path(sys.argv[1]).resolve();O=Path(sys.argv[2]).resolve();assert not O.exists();O.mkdir();sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
pins=json.load(open(D/'input-hashes.json'));before={p:sha(D/p) for p in pins};assert before==pins
binary=sha(D/'native-render');assert binary==json.load(open(D/'PREPARED.json'))['binarySHA256']
for arm in ['off','on']:assert json.load(open(D/arm/'COMPLETED.json'))['status']=='ALL20_ACTUAL_COMPLETE'
cfg=json.load(open(D/'inputs/candidate-config.json'));scenario=next(s for s in cfg['scenarios'] if s['name']=='baseline');rows=[]
for repeat in range(3):
 for camera in cfg['cameras']:
  view=camera['name']
  for arm in ['off','on']:
   prefix=O/f'{repeat}-{view}-{arm}';env={**os.environ,'HONE_NORMAL_PAIR_CODEC':'1','HONE_LINEAR_LIGHT':'1','HONE_PHYSICAL_LIGHT':'1','HONE_PIXEL_LIGHT':'1','HONE_PIXEL_VISIBILITY':'1','HONE_TRANSPORT_MODE':'2','HONE_OUTER_SAMPLES':'16','HONE_GROUND_MODE':'2','HONE_GROUND_FILE':str(D/'inputs/ground-baseline.txt'),'HONE_DISK_FILE':str(D/arm/'physical-baseline.txt'),'HONE_BOUNDARY_AA':'1' if arm=='on' else '0','HONE_AA_LEDGER':str(D/f'ledger-{view}.txt')}
   args=[str(D/'native-render'),str(D/'compiled/model-baseline/model.aynm'),str(prefix),'0',*map(str,camera['nativeCamera']),*map(str,scenario['nativeDirection']+scenario['intensity'])]
   start=time.perf_counter_ns()
   with Path(str(prefix)+'.json').open('w') as out,Path(str(prefix)+'.stderr').open('w') as err:r=subprocess.run(args,env=env,stdout=out,stderr=err)
   wall=time.perf_counter_ns()-start;assert r.returncode==0
   m=json.load(open(str(prefix)+'.json'));expected=D/arm/'private-partial'/f'native-{view}-baseline';bp={}
   for ext in ['.u16le','.f32le','.snapshot']:
    assert Path(str(prefix)+ext).read_bytes()==Path(str(expected)+ext).read_bytes();bp[ext]=sha(Path(str(prefix)+ext))
   rows.append({'repeat':repeat,'view':view,'arm':arm,'wallNs':wall,'evaluateNs':m['evaluateNs'],'renderNs':m['hostRenderNsFirstFrame'],'outputsSHA256':bp});print(repeat,view,arm,'PASS',flush=True)
assert before=={p:sha(D/p) for p in pins} and binary==sha(D/'native-render')
summary={}
for arm in ['off','on']:
 for view in ['front','oblique']:
  summary[arm+'-'+view]={}
  for k in ['wallNs','evaluateNs','renderNs']:
   values=[r[k] for r in rows if r['arm']==arm and r['view']==view];summary[arm+'-'+view][k]={'rawNs':values,'min':min(values),'median':statistics.median(values),'max':max(values)}
result={'status':'ALL12_BYTEEXACT_AND_PINS_PASS','observerIO':'ON per-sample unbuffered JSON fprintf included in native render and wall time; OFF has no such I/O. Not a pure rendering/kernel or device comparison.','schedule':'repeat then front/oblique then off/on, 3 repeats, serial','rows':rows,'summary':summary,'binarySHA256':binary,'inputHashesSHA256':sha(D/'input-hashes.json'),'allInputPinsBeforeAfterExact':True,'compilerFlags':json.load(open(D/'PREPARED.json'))['flags']};(O/'RESULT.json').write_text(json.dumps(result,indent=2)+'\n');print('BENCHMARK_ALL12_COMPLETE')
