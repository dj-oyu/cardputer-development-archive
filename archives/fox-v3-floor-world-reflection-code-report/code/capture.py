from pathlib import Path
import sys,json,hashlib,subprocess,os,time
import numpy as np
R=Path(__file__).resolve().parents[1];W=R.parent;D=R/'capture';OLD=W/'fox-v3-floor-display-combination/capture-001';PHYSICAL=W/'fox-v3-floor-direct-reflection-evaluation/actual-002/on';sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
assert len(sys.argv)==4,'arm source_freeze_sha reviewer_gate_sha';arm=sys.argv[1];assert arm in ['off','on'];assert sha(D/'SOURCE_FREEZE.json')==sys.argv[2];fr=json.load(open(D/'SOURCE_FREEZE.json'));assert all(sha(D/p)==h for p,h in fr['files'].items()) and sha(D/'native-render')==fr['binarySHA256'];gate=R/'reviews/GATE.json';assert sha(gate)==sys.argv[3];g=json.load(open(gate));assert g['fullRenderAllowed'] is True and g['sourceFreezeSHA256']==sys.argv[2]
baseline_pins=json.load(open(R/'BASELINE_OUTPUT_PINS.json'));assert all(sha(p)==h for p,h in baseline_pins.items())
O=D/arm;assert not O.exists();O.mkdir();rows=[]
if arm=='on':assert json.load(open(D/'off/COMPLETED.json'))['all10OldExact'] is True
cfg=json.load(open(D/'inputs/candidate-config.json'));timekeys=['transportBuildNs','visibilityBuildNs','appendNs','evaluateNs','hostRenderNsFirstFrame'];extensions=['.u16le','.f32le','.snapshot','.targets.u8','.samples.jsonl','.aa.json','.floor.json','.json','.center.f64le','.center-capture.json','.floor-world.json','.world-center.f64le','.world-observer.json'];inputpins={str(R/'BASELINE_OUTPUT_PINS.json'):sha(R/'BASELINE_OUTPUT_PINS.json'),str(D/'SOURCE_FREEZE.json'):sha(D/'SOURCE_FREEZE.json'),str(gate):sha(gate),str(Path(__file__)):sha(Path(__file__))}
try:
 for ci,s in enumerate(cfg['scenarios']):
  case=s['name'];physical=PHYSICAL/f'physical-{case}.txt';inputpins[str(physical)]=sha(physical)
  for camera in cfg['cameras']:
   view=camera['name'];name=f'native-{view}-{case}';prefix=O/name;oldp=OLD/'on'/name
   env={**os.environ,'HONE_NORMAL_PAIR_CODEC':'1','HONE_LINEAR_LIGHT':'1','HONE_PHYSICAL_LIGHT':'1','HONE_PIXEL_LIGHT':'1','HONE_PIXEL_VISIBILITY':'1','HONE_TRANSPORT_MODE':'2','HONE_OUTER_SAMPLES':'16','HONE_GROUND_MODE':'2','HONE_GROUND_FILE':str(D/'inputs'/f'ground-{case}.txt'),'HONE_DISK_FILE':str(physical),'HONE_BOUNDARY_AA':'1','HONE_AA_LEDGER':str(D/f'ledger-{view}.txt'),'HONE_FLOOR_REFLECTION':'on','HONE_FLOOR_WORLD':arm,'HONE_FLOOR_CASE':str(ci)}
   args=[str(D/'native-render'),str(D/'compiled'/f'model-{case}/model.aynm'),str(prefix),'0',*map(str,camera['nativeCamera']),*map(str,s['nativeDirection']+s['intensity'])];start=time.perf_counter_ns()
   with open(str(prefix)+'.json','w') as out,open(str(prefix)+'.stderr','w') as err:p=subprocess.run(args,env=env,stdout=out,stderr=err)
   elapsed=time.perf_counter_ns()-start
   assert p.returncode==0,(name,p.returncode)
   m=json.load(open(str(prefix)+'.json'));old=json.load(open(str(oldp)+'.json'));wr=json.load(open(str(prefix)+'.floor-world.json'));assert wr['complete'] and wr['enabled']==(arm=='on')
   ignores=set(timekeys+['transportContextBytes']);adjusted=dict(m)
   for newkey,oldkey,cap in [('visibilityRays','transportRays',20000000),('visibilityNodeVisits','transportNodeVisits',800000000),('visibilityTriangleTests','transportTriangleTests',300000000)]:
    assert 0<=m[oldkey]<=cap;adjusted[oldkey]-=wr[newkey]
   assert set(m)==set(old);assert {k:v for k,v in adjusted.items() if k not in ignores}=={k:v for k,v in old.items() if k not in ignores},name
   # Only truthful host-context size metadata differs. Every old counter is exact.
   for ext in ['.f32le','.snapshot','.targets.u8','.aa.json','.center-capture.json']:
    assert Path(str(prefix)+ext).read_bytes()==Path(str(oldp)+ext).read_bytes(),(name,ext)
   floor=json.load(open(str(prefix)+'.floor.json'));oldfloor=json.load(open(str(oldp)+'.floor.json'));assert {k:v for k,v in floor.items() if k!='contextBytes'}=={k:v for k,v in oldfloor.items() if k!='contextBytes'}
   if arm=='off':
    for ext in ['.u16le','.samples.jsonl','.center.f64le']:assert Path(str(prefix)+ext).read_bytes()==Path(str(oldp)+ext).read_bytes(),(name,ext)
    assert wr['workUsed']==wr['queries']==0
   else:
    assert wr['shaderCalls']==m['shadeUpdates'] and wr['evaluations']==m['primary_ground_reflection_hits'];assert wr['queries']==16*wr['evaluations']==wr['visibilityRays'];assert wr['queries']==wr['misses']+wr['blockedFloor']+wr['blockedCharacter'];assert wr['workUsed']==64*wr['shaderCalls']+6272*wr['evaluations']<=wr['workLimit']
    samples=[json.loads(z) for z in open(str(prefix)+'.samples.jsonl')];oldsamples=[json.loads(z) for z in open(str(oldp)+'.samples.jsonl')];assert len(samples)==len(oldsamples)
    for ns,os_ in zip(samples,oldsamples):
     assert {k:v for k,v in ns.items() if k not in ['linearRGB','floorWorldRGB']}=={k:v for k,v in os_.items() if k!='linearRGB'}
     nw=np.array(ns.get('floorWorldRGB',[0,0,0]));assert np.isfinite(nw).all() and (nw>=0).all();assert np.allclose(ns['linearRGB'],np.array(os_['linearRGB'])+nw,rtol=2e-15,atol=2e-15)
   aa=json.load(open(str(prefix)+'.aa.json'));obs=json.load(open(str(prefix)+'.center-capture.json'));wobs=json.load(open(str(prefix)+'.world-observer.json'));assert obs['updates']==aa['centerShades'];assert wobs['centerUpdates']==(aa['centerShades'] if arm=='on' else 0)
   hdr=np.fromfile(str(prefix)+'.center.f64le','<f8').reshape(135,240,3);new=np.fromfile(str(prefix)+'.world-center.f64le','<f8').reshape(135,240,3);base=np.fromfile(str(oldp)+'.center.f64le','<f8').reshape(135,240,3);depth=np.fromfile(str(prefix)+'.f32le','<f4').reshape(135,240);assert np.isfinite(hdr).all() and (hdr>=0).all() and (hdr[~np.isfinite(depth)]==0).all();assert np.isfinite(new).all() and (new>=0).all() and (new[~np.isfinite(depth)]==0).all();assert np.allclose(hdr,base+new,rtol=2e-15,atol=2e-15)
   if arm=='off':assert not np.any(new)
   files={ext:sha(str(prefix)+ext) for ext in extensions};rows.append({'view':view,'case':case,'reverse':False,'prefix':name,'files':files,'oldNumericalBuffersExact':arm=='off','oldCounterSemanticsExact':True,'transportDeltaExactlyNewWorld':True,'elapsedNs':elapsed,'rendererTimings':{k:m[k] for k in timekeys},'observer':obs,'worldObserver':wobs,'floorWorld':wr});(O/'progress.json').write_text(json.dumps({'completedFrames':len(rows),'last':name})+'\n');print(arm,name,'VERIFIED',flush=True)
 assert all(sha(p)==h for p,h in baseline_pins.items());assert len(rows)==10 and all(sha(D/p)==h for p,h in fr['files'].items());assert all(sha(p)==h for p,h in inputpins.items());(O/'INPUT_PINS.json').write_text(json.dumps(inputpins,indent=2)+'\n');(O/'COMPLETED.json').write_text(json.dumps({'status':'ALL10_FLOOR_WORLD_CAPTURE_COMPLETE','arm':arm,'frames':rows,'sourceFreezeSHA256':sha(D/'SOURCE_FREEZE.json'),'inputsSHA256':sha(O/'INPUT_PINS.json'),'all10OldExact':arm=='off','allOldCounterSemanticsExact':True,'allInputsUnchanged':True,'forwardOnly':True,'oldReverseEvidenceNotFresh':True,'timingScope':'single host diagnostic incl observers; no isolated/device speed claim'},indent=2)+'\n');print(arm,'ALL10_COMPLETE')
except BaseException as e:
 (O/'FAILED.json').write_text(json.dumps({'status':'FAILED_NO_FORMAL_COMPLETION','reason':str(e),'completedFrames':len(rows),'formalManifest':False},indent=2)+'\n');raise
