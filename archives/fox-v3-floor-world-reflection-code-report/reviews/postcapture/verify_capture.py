from pathlib import Path
import json,hashlib,numpy as np
R=Path('/workspace/scratch/6d8dcdbcdc54/fox-v3-floor-world-reflection');W=R.parent;D=R/'capture';OLD=W/'fox-v3-floor-display-combination/capture-001';BG=W/'fox-v3-camera-background-evaluation/actual-002/on/private-partial'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
read=lambda p:json.loads(Path(p).read_text())
arr=lambda p:np.fromfile(p,'<f8').reshape(135,240,3)
pins=read(R/'COMPLETION_PINS.json')['files'];assert sha(R/'COMPLETION_PINS.json')=='253d36637f16c2acc674aced651cc8dfd144f2fb71fed19613446e283bc3cbf5';assert all(sha(p)==h for p,h in pins.items())
freeze=read(D/'SOURCE_FREEZE.json');assert sha(D/'SOURCE_FREEZE.json')=='fb98fdcd29ca3a2dcb7a040db2fd08a952a4ffa6eba882ba3cc7cbb369e9a64f';assert all(sha(D/p)==h for p,h in freeze['files'].items());assert sha(D/'native-render')==freeze['binarySHA256'];assert all(sha(p)==h for p,h in read(R/'BASELINE_OUTPUT_PINS.json').items())
expected={(view,case) for view in ['front','oblique'] for case in ['baseline','direction','intensity','ambient','albedo']};rows=[];sample_count=0;hash_count=0;max_center_error=0;max_sample_error=0;max_composition_error=0
ignores={'transportBuildNs','visibilityBuildNs','appendNs','evaluateNs','hostRenderNsFirstFrame','transportContextBytes'}
for arm in ['off','on']:
 C=D/arm;j=read(C/'COMPLETED.json');assert j['status']=='ALL10_FLOOR_WORLD_CAPTURE_COMPLETE' and j['arm']==arm and len(j['frames'])==10;assert not (C/'FAILED.json').exists();assert j['sourceFreezeSHA256']==sha(D/'SOURCE_FREEZE.json');assert j['inputsSHA256']==sha(C/'INPUT_PINS.json');assert all(sha(p)==h for p,h in read(C/'INPUT_PINS.json').items());assert {(f['view'],f['case']) for f in j['frames']}==expected
 for f in j['frames']:
  name=f['prefix'];p=C/name;old=OLD/'on'/name;assert all(sha(str(p)+ext)==h for ext,h in f['files'].items());hash_count+=len(f['files'])
  m=read(str(p)+'.json');o=read(str(old)+'.json');ww=read(str(p)+'.floor-world.json');assert ww==f['floorWorld'] and ww['complete'] and ww['enabled']==(arm=='on');assert m['transportComplete'] and m['visibilityComplete'] and m['floorReflectionEnabled'] and not m['floorZeroControl'];assert not m['reverse'];assert m['outerSamples']==m['innerSamples']==16
  adjusted=dict(m)
  for oldkey,newkey,cap in [('transportRays','visibilityRays',20000000),('transportNodeVisits','visibilityNodeVisits',800000000),('transportTriangleTests','visibilityTriangleTests',300000000)]:assert m[oldkey]<=cap;assert m[oldkey]-o[oldkey]==ww[newkey];adjusted[oldkey]-=ww[newkey]
  assert {k:v for k,v in adjusted.items() if k not in ignores}=={k:v for k,v in o.items() if k not in ignores};assert m['transportContextBytes']==o['transportContextBytes']+32
  for qkey,lkey,cap in [('visibilityRays','visibilityRayLimit',1000000),('visibilityNodeVisits','visibilityNodeLimit',100000000),('visibilityTriangleTests','visibilityTriangleLimit',50000000)]:assert m[qkey]<=cap and m[lkey]==cap
  exts=['.f32le','.snapshot','.targets.u8','.aa.json','.center-capture.json'];exts+=['.u16le','.samples.jsonl','.center.f64le'] if arm=='off' else []
  for ext in exts:assert Path(str(p)+ext).read_bytes()==Path(str(old)+ext).read_bytes()
  fl=read(str(p)+'.floor.json');ofl=read(str(old)+'.floor.json');assert {k:v for k,v in fl.items() if k!='contextBytes'}=={k:v for k,v in ofl.items() if k!='contextBytes'}
  if arm=='on':assert ww['shaderCalls']==m['shadeUpdates'] and ww['evaluations']==m['primary_ground_reflection_hits'];assert ww['queries']==ww['visibilityRays']==16*ww['evaluations']==ww['misses']+ww['blockedFloor']+ww['blockedCharacter'];assert ww['workUsed']==64*ww['shaderCalls']+6272*ww['evaluations']<=ww['workLimit']<=450598848
  else:assert ww['workUsed']==ww['queries']==0
  center=arr(str(p)+'.center.f64le');world=arr(str(p)+'.world-center.f64le');oldcenter=arr(str(old)+'.center.f64le');depth=np.fromfile(str(p)+'.f32le','<f4').reshape(135,240);assert np.isfinite(world).all() and (world>=0).all() and not np.any(world[~np.isfinite(depth)]);err=float(np.abs(center-(oldcenter+world)).max());max_center_error=max(max_center_error,err);assert np.allclose(center,oldcenter+world,atol=2e-15,rtol=2e-15)
  if arm=='off':assert not np.any(world)
  ns=[json.loads(z) for z in open(str(p)+'.samples.jsonl')];os=[json.loads(z) for z in open(str(old)+'.samples.jsonl')];assert len(ns)==len(os);sample_count+=len(ns)
  for a,b in zip(ns,os):
   assert {k:v for k,v in a.items() if k not in ['linearRGB','floorWorldRGB']}=={k:v for k,v in b.items() if k!='linearRGB'}
   c=np.asarray(a.get('floorWorldRGB',[0,0,0]));assert np.isfinite(c).all() and (c>=0).all();assert a['hit'] or not np.any(c);e=float(np.abs(np.asarray(a['linearRGB'])-(np.asarray(b['linearRGB'])+c)).max());max_sample_error=max(max_sample_error,e);assert np.allclose(a['linearRGB'],np.asarray(b['linearRGB'])+c,atol=2e-15,rtol=2e-15)
  rows.append({'arm':arm,'view':f['view'],'case':f['case'],'transportRays':m['transportRays'],'transportNodes':m['transportNodeVisits'],'transportTriangles':m['transportTriangleTests'],'newRays':ww['visibilityRays'],'newNodes':ww['visibilityNodeVisits'],'newTriangles':ww['visibilityTriangleTests'],'workUsed':ww['workUsed'],'maxComponent':float(world.max())})
 # Verify compositions without executing renderer, encoding library, or frozen scripts.
 O=R/('composed-'+arm);co=read(O/'COMPLETED.json');assert co['status']=='ALL10_FLOOR_WORLD_COMPOSITION_COMPLETE' and co['arm']==arm;assert len(co['frames'])==10 and {(f['view'],f['case']) for f in co['frames']}==expected;assert co['captureCompletionSHA256']==sha(C/'COMPLETED.json') and co['inputPinsSHA256']==sha(O/'INPUT_PINS.json');assert all(sha(p)==h for p,h in read(O/'INPUT_PINS.json').items())
 for f in co['frames']:
  view,case=f['view'],f['case'];key=view+'-'+case;p=C/('native-'+key);assert sha(O/f['hdr'])==f['hdrSHA256'] and sha(O/f['floorWorld'])==f['floorWorldSHA256'];assert all(sha(O/v['path'])==v['sha256'] for v in f['outputs'].values());assert sha(f['characterDepthPath'])==f['characterDepthSHA256'];assert sha(str(p)+'.targets.u8')==f['targetSHA256'];hash_count+=6
  oldroot=W/'fox-v3-floor-display-combination/composed-on'
  if arm=='off':
   for file in [f['hdr'],*[v['path'] for v in f['outputs'].values()]]:assert (O/file).read_bytes()==(oldroot/file).read_bytes()
  target=np.fromfile(str(p)+'.targets.u8',np.uint8).reshape(135,240).astype(bool);center=arr(str(p)+'.world-center.f64le');samples={(s['x'],s['y'],s['sample']):s for s in map(json.loads,open(str(p)+'.samples.jsonl'))};rebuilt=np.zeros_like(center);seen=np.zeros((135,240),np.uint8);counts=[0,0,0];overrides=0
  for e in map(json.loads,open(BG/('native-'+key+'.background.jsonl'))):
   x,y,i=e['x'],e['y'],e['sample'];action=e['action'];counts[action]+=1
   if target[y,x]:
    assert i==seen[y,x];seen[y,x]+=1;s=samples[x,y,i]
    if action==0:assert s['hit'];rebuilt[y,x]+=s.get('floorWorldRGB',[0,0,0])
    elif s['hit']:overrides+=1
   else:
    assert seen[y,x]==0 and i==4294967295;seen[y,x]=1
    if action==0:rebuilt[y,x]=center[y,x]
  rebuilt[target]*=.25;assert np.array_equal(rebuilt,arr(O/f['floorWorld']));assert np.array_equal(seen,np.where(target,4,1));assert overrides==f['floorOverrides'];assert counts==[f['actionCounts'][x] for x in ['keep','floor','world']]
  base=arr(R/'composed-off'/f['hdr']);hdr=arr(O/f['hdr']);e=float(np.abs(hdr-(base+rebuilt)).max());max_composition_error=max(max_composition_error,e);assert np.allclose(hdr,base+rebuilt,atol=2e-15,rtol=2e-15)
# Source world data, then component-only scaling, avoiding total radiance confounds.
phys=W/'fox-v3-floor-direct-reflection-evaluation/actual-002/on';pb=[float(x) for x in (phys/'physical-baseline.txt').read_text().split()[1:]];pa=[float(x) for x in (phys/'physical-ambient.txt').read_text().split()[1:]];assert len(pb)==len(pa)==37;assert pb[:-1]==pa[:-1] and pa[-1]==2*pb[-1];assert np.array_equal(np.array(pa[-4:-1])*pa[-1],2*np.array(pb[-4:-1])*pb[-1]);scaling=[]
for view in ['front','oblique']:
 bc=arr(D/'on'/f'native-{view}-baseline.world-center.f64le');ac=arr(D/'on'/f'native-{view}-ambient.world-center.f64le');assert np.array_equal(ac,2*bc)
 bf=arr(R/'composed-on'/f'floor-world-{view}-baseline.f64le');af=arr(R/'composed-on'/f'floor-world-{view}-ambient.f64le');assert np.array_equal(af,2*bf)
 baseline=list(map(json.loads,open(D/'on'/f'native-{view}-baseline.samples.jsonl')));ambient=list(map(json.loads,open(D/'on'/f'native-{view}-ambient.samples.jsonl')));assert len(baseline)==len(ambient);hit=0
 for b,a in zip(baseline,ambient):
  for k in ['x','y','sample','hit','recordOffset','node','face','back','sourceId','depth','P','Ns','rho']:assert a[k]==b[k]
  assert np.array_equal(np.asarray(a.get('floorWorldRGB',[0,0,0])),2*np.asarray(b.get('floorWorldRGB',[0,0,0])));hit+=int(b['hit'])
 for case in ['direction','intensity']:
  assert np.array_equal(arr(D/'on'/f'native-{view}-{case}.world-center.f64le'),bc);assert np.array_equal(arr(R/'composed-on'/f'floor-world-{view}-{case}.f64le'),bf)
 scaling.append({'view':view,'sourceWorldMultiplier':2,'centerComponentExactlyDoubled':True,'composedComponentExactlyDoubled':True,'quarterComponentExactlyDoubled':True,'quarterRows':len(baseline),'quarterHits':hit,'baselineComponentUnchangedByDirectionIntensity':True})
assert all(sha(p)==h for p,h in pins.items());assert all(sha(D/p)==h for p,h in freeze['files'].items())
on=[x for x in rows if x['arm']=='on'];maxima={key:max(x[key] for x in on) for key in ['transportRays','transportNodes','transportTriangles','newRays','newNodes','newTriangles','workUsed']};result={'status':'INDEPENDENT_ALL20_CAPTURE_AND_COMPOSITION_PASS','sourceFreezeSHA256':sha(D/'SOURCE_FREEZE.json'),'completionPinsSHA256':sha(R/'COMPLETION_PINS.json'),'completedManifestPins':pins,'checkedCaptureFrames':20,'checkedComposedFrames':20,'checkedQuarterRowsAcrossBothArms':sample_count,'checkedOutputHashes':hash_count,'all10OffOldCaptureNumericalBuffersExact':True,'all10OffOldCompositionHDRLegacyAgxExact':True,'oldCounterAndComponentSemanticsExact':True,'newTraversalDeltaExact':True,'composedWorldReconstructedFromKeepEventsExact':True,'maximaON':maxima,'maxAbsAccountingResiduals':{'rawCenter':max_center_error,'quarterSample':max_sample_error,'composedHDR':max_composition_error},'worldScaling':scaling,'rows':rows,'noRerender':True,'frozenFilesUnchanged':True,'limitations':['Forward-only fixed two-view/five-condition captures; no fresh reverse render.','Output addition checked at frozen 2e-15 absolute/relative tolerance, while OFF and world scaling are exact byte/numeric equalities.','No independent recomputation of AgX encoding; stored AgX hashes and OFF parity verified.','Source-level physical term review is separate; no broader ownership/security or stopped-review certification.','Semantic work is separate host budget, not legacy 8M admission or device/performance proof.']}
print(json.dumps({k:v for k,v in result.items() if k not in ['rows','completedManifestPins']},indent=2));Path('/tmp/floor-world-postcapture-result.json').write_text(json.dumps(result,indent=2)+'\n')
