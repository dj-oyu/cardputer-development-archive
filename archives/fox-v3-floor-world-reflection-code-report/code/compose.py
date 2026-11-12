from pathlib import Path
import sys,json,hashlib,ctypes,time,statistics,resource
import numpy as np
R=Path(__file__).resolve().parents[1];W=R.parent;D=R/'capture';BG=W/'fox-v3-camera-background-evaluation/actual-002/on/private-partial';V=W/'fox-v3-camera-display-comparison';sys.path.insert(0,str(V/'code'));from common import check_profile,encode,admission
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest();assert len(sys.argv)==4;arm=sys.argv[1];proof=Path(sys.argv[2]).resolve();assert arm in ['off','on'] and sha(proof)==sys.argv[3];a=admission();lib,fun=check_profile();O=R/('composed-'+arm);assert not O.exists();O.mkdir();C=D/arm;complete=json.load(open(C/'COMPLETED.json'));assert complete['status']=='ALL10_FLOOR_WORLD_CAPTURE_COMPLETE'
if arm=='on':assert json.load(open(R/'composed-off/COMPLETED.json'))['all10PriorFloorOnHDRLegacyAgxExact']
rows=[];cost=[];pins={str(proof):sha(proof),str(C/'COMPLETED.json'):sha(C/'COMPLETED.json'),str(Path(__file__)):sha(Path(__file__)),str(V/'PROFILE_INPUT_FREEZE.json'):sha(V/'PROFILE_INPUT_FREEZE.json')};knownkeys={(119,121,0),(141,121,1)}
for f in complete['frames']:
 view,case=f['view'],f['case'];key=view+'-'+case;p=C/f['prefix'];b=BG/('native-'+key)
 for ext,h in f['files'].items():assert sha(str(p)+ext)==h;pins[str(p)+ext]=h
 worldcenter=np.fromfile(str(p)+'.world-center.f64le','<f8').reshape(135,240,3);center=np.fromfile(str(p)+'.center.f64le','<f8').reshape(135,240,3);depth=np.fromfile(str(p)+'.f32le','<f4').reshape(135,240);target=np.fromfile(str(p)+'.targets.u8',np.uint8).reshape(135,240).astype(bool)
 for ext in ['.f32le','.snapshot','.targets.u8']:assert Path(str(p)+ext).read_bytes()==Path(str(b)+ext).read_bytes();pins[str(b)+ext]=sha(str(b)+ext)
 chars={}
 for line in open(str(p)+'.samples.jsonl'):
  z=json.loads(line);k=(z['x'],z['y'],z['sample']);assert k not in chars and target[k[1],k[0]];chars[k]=z
 assert len(chars)==4*int(target.sum());seen=np.zeros((135,240),np.uint8);hdr=np.zeros_like(center);worldhdr=np.zeros_like(center);override=set();counts={'keep':0,'floor':0,'world':0};eventpath=Path(str(b)+'.background.jsonl');pins[str(eventpath)]=sha(eventpath);start=time.perf_counter_ns()
 for line in open(eventpath):
  e=json.loads(line);x,y,j=e['x'],e['y'],e['sample'];assert all(type(v)is int for v in [x,y,j,e['action']]);assert 0<=x<240 and 0<=y<135 and e['action'] in [0,1,2];counts[['keep','floor','world'][e['action']]]+=1
  if target[y,x]:
   assert 0<=j<4 and seen[y,x]==j;seen[y,x]+=1;s=chars[x,y,j];assert e['characterHit'] is s['hit'];assert np.float32(e['characterDepth'])==np.float32(s['depth']) if s['hit'] else e['characterDepth']==0
   if e['action']==0:assert s['hit'];rgb=s['linearRGB'];worldhdr[y,x]+=np.array(s.get('floorWorldRGB',[0,0,0]))
   else:
    rgb=e['returnedRGB']
    if s['hit']:assert e['action']==1;override.add((x,y,j))
   for k in range(3):hdr[y,x,k]+=float(rgb[k])
  else:
   assert j==4294967295 and seen[y,x]==0;seen[y,x]=1;hit=bool(np.isfinite(depth[y,x]));assert e['characterHit'] is hit
   if hit:assert np.float32(e['characterDepth'])==depth[y,x]
   if e['action']==0:assert hit;hdr[y,x]=center[y,x];worldhdr[y,x]=worldcenter[y,x]
   else:assert not hit;hdr[y,x]=e['returnedRGB']
 assert np.array_equal(seen,np.where(target,4,1));assert override==(knownkeys if view=='front' else set());hdr[target]*=.25;worldhdr[target]*=.25;assert np.isfinite(hdr).all() and (hdr>=0).all();join_ns=time.perf_counter_ns()-start
 oldroot=W/'fox-v3-floor-display-combination/composed-on';oldhdr=oldroot/('hdr-'+key+'.f64le');oldlegacy=oldroot/('legacy-'+key+'.u16le');oldagx=oldroot/('agx-'+key+'.u16le');outputs={};clamps={}
 # Three fixed profile repetitions are diagnostics, no extra renderer repeats.
 for enabled in [0,1]:
  times=[];first=None
  for rep in range(3):
   st=time.perf_counter_ns();u,cl=encode(fun,hdr,enabled);times.append(time.perf_counter_ns()-st)
   if first is None:first=u.copy();clamps[str(enabled)]=cl
   assert np.array_equal(u,first) and cl==clamps[str(enabled)]
  label='legacy' if enabled==0 else 'agx';out=O/(label+'-'+key+'.u16le');first.astype('<u2').tofile(out);outputs[label]={'path':out.name,'sha256':sha(out)};cost.append({'view':view,'case':case,'profile':label,'rawNs':times,'minNs':min(times),'medianNs':statistics.median(times),'maxNs':max(times),'repetitions':3,'allOutputsExact':True})
 hp=O/('hdr-'+key+'.f64le');hdr.astype('<f8').tofile(hp);wp=O/('floor-world-'+key+'.f64le');worldhdr.astype('<f8').tofile(wp)
 assert np.isfinite(worldhdr).all() and (worldhdr>=0).all()
 if arm=='off':assert not np.any(worldhdr)
 else:
  baseline=np.fromfile(R/'composed-off'/('hdr-'+key+'.f64le'),'<f8').reshape(135,240,3);assert np.allclose(hdr,baseline+worldhdr,rtol=2e-15,atol=2e-15)
 if arm=='off':
  assert hp.read_bytes()==oldhdr.read_bytes();assert (O/outputs['legacy']['path']).read_bytes()==oldlegacy.read_bytes();assert (O/outputs['agx']['path']).read_bytes()==oldagx.read_bytes()
 for q in [oldhdr,oldlegacy,oldagx]:pins[str(q)]=sha(q)
 rows.append({'view':view,'case':case,'hdr':hp.name,'hdrSHA256':sha(hp),'floorWorld':wp.name,'floorWorldSHA256':sha(wp),'outputs':outputs,'characterDepthPath':str(p)+'.f32le','characterDepthSHA256':sha(str(p)+'.f32le'),'targetSHA256':sha(str(p)+'.targets.u8'),'events':sum(counts.values()),'actionCounts':counts,'floorOverrides':len(override),'clampedPixels':clamps['1'],'compositionNs':join_ns,'minimumHDR':float(hdr.min()),'maximumHDR':float(hdr.max()),'priorFloorOnExactControl':arm=='off'});print(arm,key,'COMPOSE_COMPLETE',flush=True)
assert len(rows)==10;a.recheck();check_profile();assert all(sha(p)==h for p,h in pins.items());(O/'INPUT_PINS.json').write_text(json.dumps(pins,indent=2)+'\n');(O/'COST.json').write_text(json.dumps({'rows':cost,'RSSKiB':resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,'scope':'3 repetitions existing profile incl allocation/ctypes; functional host reference, not isolated/device bench'},indent=2)+'\n');(O/'COMPLETED.json').write_text(json.dumps({'status':'ALL10_FLOOR_WORLD_COMPOSITION_COMPLETE','arm':arm,'frames':rows,'all10PriorFloorOnHDRLegacyAgxExact':arm=='off','backgroundReuseProofSHA256':sha(proof),'captureCompletionSHA256':sha(C/'COMPLETED.json'),'inputPinsSHA256':sha(O/'INPUT_PINS.json'),'sourceInputsUnchanged':True,'fixedAgxAndQuarterMask':True,'noNewLiveBridge':True},indent=2)+'\n')
