"""Four isolated same-instance root pose chains, immutable inputs and fixed pose set."""
from pathlib import Path
import sys,json,os,subprocess,hashlib
R=Path(__file__).resolve().parents[1];W=R.parent;D=R/'deps';B=W/'fox-v3-lid-evaluation/actual-lid8-v2';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert len(sys.argv)==4;O=Path(sys.argv[1]).resolve();mode=sys.argv[2];assert mode in ['admit','render'];assert not O.exists();freeze=R/'SOURCE_FREEZE.json';assert sha(freeze)==sys.argv[3];f=json.load(open(freeze));assert all(sha(R/p)==h for p,h in f['files'].items());dp=json.load(open(R/'DEPENDENCY_FREEZE.json'));assert all(sha(D/p)==h for p,h in dp['dependencyFiles'].items());cfg=json.load(open(D/'inputs/candidate-config.json'));scenario=next(s for s in cfg['scenarios'] if s['name']=='baseline');binary=R/'root-pose';binaryPin=sha(binary)
controls=json.load(open(R/'CONTROL_FREEZE.json'))['files'];assert all(sha(W/p)==h for p,h in controls.items())
O.mkdir();private=O/'private';private.mkdir();rows=[]
for camera in cfg['cameras']:
 for reverse in [False,True]:
  view=camera['name'];prefix=private/(view+('-reverse' if reverse else '-forward'));env={**os.environ,'HONE_NORMAL_PAIR_CODEC':'1','HONE_LINEAR_LIGHT':'1','HONE_PHYSICAL_LIGHT':'1','HONE_PIXEL_LIGHT':'1','HONE_PIXEL_VISIBILITY':'1','HONE_TRANSPORT_MODE':'2','HONE_OUTER_SAMPLES':'16','HONE_GROUND_MODE':'2','HONE_GROUND_FILE':str(D/'inputs/ground-baseline.txt'),'HONE_DISK_FILE':str(D/'inputs/physical-baseline.txt'),'HONE_ROOT_ADMISSION_ONLY':'1' if mode=='admit' else '0','HONE_ROOT_DUMP_GEOMETRY':'1','HONE_BOUNDARY_AA':'0','HONE_ROOT_CONTROL_PREFIX':str(B/(f'native-{view}-baseline'+('-reverse' if reverse else '')))}
  args=[str(binary),str(D/'compiled/model-baseline/model.aynm'),str(prefix),str(int(reverse)),*map(str,camera['nativeCamera']),*map(str,scenario['nativeDirection']+scenario['intensity'])]
  with Path(str(prefix)+'.lifecycle.json').open('w') as out,Path(str(prefix)+'.stderr').open('w') as err:p=subprocess.run(args,env=env,stdout=out,stderr=err)
  if p.returncode:
   (O/'FAILED.json').write_text(json.dumps({'view':view,'reverse':reverse,'mode':mode,'completedChains':len(rows),'returncode':p.returncode,'stderr':Path(str(prefix)+'.stderr').read_text(),'qualityComplete':False},indent=2)+'\n');raise SystemExit('CHAIN_FAILED_NO_QUALITY_COMPLETION')
  lifecycle=json.load(open(str(prefix)+'.lifecycle.json'));files={str(p.relative_to(O)):sha(p) for p in private.glob(prefix.name+'.*') if p.is_file()}
  if mode=='render':
   old=B/(f'native-{view}-baseline'+('-reverse' if reverse else ''))
   for label in ['identity','return-identity','old-replay']:
    for ext in ['.u16le','.f32le','.snapshot']:assert Path(str(prefix)+'.'+label+ext).read_bytes()==Path(str(old)+ext).read_bytes(),(view,reverse,label,ext)
   for label in ['identity','yaw-plus','yaw-minus','return-identity','old-replay']:
    meta=json.load(open(str(prefix)+'.'+label+'.json'))
    for group,caps in [('visibility',(1000000,100000000,50000000)),('transport',(20000000,800000000,300000000))]:
     for (used,limit),cap in zip([('Rays','RayLimit'),('NodeVisits','NodeLimit'),('TriangleTests','TriangleLimit')],caps):assert type(meta[group+used]) is int and type(meta[group+limit]) is int and 0<=meta[group+used]<=meta[group+limit]==cap
    assert meta['snapshotBytes']<=65536 and meta['snapshotCapacity']==65536 and meta['work']<=8000000 and meta['transportComplete'] and meta['visibilityComplete']
  rows.append({'view':view,'reverse':reverse,'prefix':str(prefix.relative_to(O)),'files':files,'lifecycle':lifecycle});(O/'progress.json').write_text(json.dumps({'completedChains':len(rows),'lastView':view,'lastReverse':reverse},indent=2)+'\n');print(mode,view,reverse,'PASS',flush=True)
if mode=='render':
 for view in ['front','oblique']:
  for label in ['identity','yaw-plus','yaw-minus','return-identity','old-replay']:
   for ext in ['.u16le','.f32le']:assert (private/(view+'-forward.'+label+ext)).read_bytes()==(private/(view+'-reverse.'+label+ext)).read_bytes(),('ORDER',view,label,ext)
assert all(sha(W/p)==h for p,h in controls.items()) and all(sha(R/p)==h for p,h in f['files'].items()) and all(sha(D/p)==h for p,h in dp['dependencyFiles'].items()) and sha(binary)==binaryPin
result={'status':'ALL4_CHAINS_COMPLETE','mode':mode,'chainCount':4,'renderedFrameCount':20 if mode=='render' else 0,'oldIdentityReturnReplayExact':mode=='render','forwardReverseRGBDepthExact':mode=='render','sourceFreezeSHA256':sys.argv[3],'dependencyFreezeSHA256':sha(R/'DEPENDENCY_FREEZE.json'),'binarySHA256':binaryPin,'inputsUnchanged':True,'rows':rows,'scope':'Host root-rigid lifecycle only; no rig/skin/AA/pose-reference score/device claim'};(O/'COMPLETED.json').write_text(json.dumps(result,indent=2)+'\n');print('ALL4_CHAINS_COMPLETE',mode)
