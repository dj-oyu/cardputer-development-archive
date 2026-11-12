#!/usr/bin/env python3
"""Fresh authentic metadata. --prepare pins inputs; --run needs reviewed freeze SHA.
No full renderer/shader invocation. Never overwrite outputs. Ray-only work is explicit.
"""
import pathlib,json,hashlib,sys,ctypes,struct,math,collections
import numpy as np
ROOT=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');HERE=pathlib.Path(__file__).resolve().parent;P=HERE.parent/'preflight';V=ROOT/'fox-v3-indexed-bvh-bounds/private-build';BG=ROOT/'fox-v3-camera-background-evaluation/actual-002/private/BACKGROUND_INPUTS.json'
KINDS=['baseline','q16','q20']
EXT=['.snapshot','.targets.u8','.center-depth.f32le','.center-source.u16le','.winner-records.u16le','.winner-faces.u8','.winner-depths.f32le','.world-vertices.f64le','.world-triangles.u32le','.events.jsonl','.geometry.json','.command.json']
def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def write(p,x):
 with p.open('x') as f:json.dump(x,f,indent=2);f.write('\n')
def fnv(b):
 h=14695981039346656037
 for c in b:h=((h^c)*1099511628211)&((1<<64)-1)
 return f'{h:016x}'
def inputs():
 paths=[HERE/'metadata.c',HERE/'background_metadata.c',HERE/'bounce_pure_extract.h',HERE/'metadata.so',HERE/'build_metadata.sh',HERE/'generate_metadata.py',HERE/'CANARY_PLAN.md',BG,P/'RESULT.json',P/'BUILD.json',P/'identity.bin']
 paths += [V/p for p in ['visibility/visibility.c','visibility/visibility.h','background/background.c','background/background.h','physical/fox_disk_lighting.c','physical/fox_disk_lighting.h','transport/bounce.c']]
 for k in KINDS:paths += [P/(k+'-front'+e) for e in EXT]
 return {str(p.relative_to(ROOT)):sha(p) for p in paths}
if sys.argv[1:]==['--prepare']:
 write(HERE/'METADATA_INPUT_FREEZE.json',{'status':'FROZEN_METADATA_NOT_EXECUTED','variants':KINDS,'view':'front','rayCapPerVariant':275856,'nodeCapPerVariant':100000000,'triangleCapPerVariant':50000000,'fullShadedFrames':0,'files':inputs()});print(sha(HERE/'METADATA_INPUT_FREEZE.json'));sys.exit(0)
if len(sys.argv)!=3 or sys.argv[1]!='--run':raise SystemExit('Use --prepare, then --run <independently reviewed freeze SHA256>.')
freeze=HERE/'METADATA_INPUT_FREEZE.json';assert sha(freeze)==sys.argv[2];pins=json.loads(freeze.read_text());assert pins['files']==inputs(),'Source/input changed since review'
lib=ctypes.CDLL(str(HERE/'metadata.so'));D=ctypes.POINTER(ctypes.c_double);U=ctypes.POINTER(ctypes.c_uint32);Q=ctypes.POINTER(ctypes.c_uint64);F=ctypes.POINTER(ctypes.c_float);Y=ctypes.POINTER(ctypes.c_uint8)
ray=lib.floor_ray_metadata;ray.argtypes=[D,ctypes.c_size_t,U,ctypes.c_size_t,D,ctypes.c_size_t,ctypes.c_uint64,Q];ray.restype=ctypes.c_int
bg=lib.background_metadata;bg.argtypes=[D,U,U,F,ctypes.c_size_t,Y,F];bg.restype=ctypes.c_int
config=next(r for r in json.loads(BG.read_text())['rows'] if r['name']=='native-front-baseline');cfg=np.array(config['nativeCameraF32']+config['sourceOrigin']+config['sourceUnitView']+[config['near'],config['far']]+sum(config['floorWorld'],[]),dtype=np.float64);ix=np.array(sum(config['floorTriangles'],[]),dtype=np.uint32)
rows=[]
for ordinal,kind in enumerate(KINDS,2):
 assert pins['files']==inputs(),'Inputs changed mid-run'
 prefix=P/(kind+'-front');out=HERE/(kind+'-front.metadata.json');reservation=HERE/(kind+'-front.metadata-reservation');reservation.mkdir();assert not out.exists()
 g=json.loads(pathlib.Path(str(prefix)+'.geometry.json').read_text());events=[json.loads(s) for s in pathlib.Path(str(prefix)+'.events.jsonl').read_text().splitlines()];assert len(events)==g['centerUpdates']+sum(g['hits'][1:])<=17241
 expected=collections.Counter({0:g['centerUpdates'],**{i:g['hits'][i] for i in range(1,5)}});assert collections.Counter(e['phase'] for e in events)==expected
 ev=np.array([e['P']+e['Ns'] for e in events],dtype=np.float64);xyz=np.fromfile(str(prefix)+'.world-vertices.f64le',dtype='<f8');tri=np.fromfile(str(prefix)+'.world-triangles.u32le',dtype='<u4');assert xyz.size==1167*3 and tri.size==1566*3;assert np.array_equal(xyz[-12:].reshape(4,3),np.array(config['floorWorld']));assert np.array_equal(tri[-6:]-1163,ix)
 counters=(ctypes.c_uint64*8)();status=ray(xyz.ctypes.data_as(D),1167,tri.ctypes.data_as(U),1566,ev.ctypes.data_as(D),len(events),ordinal,counters)
 if status:
  write(HERE/(kind+'-front.FAILED.json'),{'stage':'floor-nearest-ray-metadata','status':status,'consumed':list(counters),'complete':False});raise SystemExit('Metadata query failure; no retry or complete manifest.')
 assert counters[0]==16*len(events) and counters[6]==len(events);shaders=len(events);hits=counters[3];assert hits<=71667
 targets=np.fromfile(str(prefix)+'.targets.u8',dtype='u1');wr=np.fromfile(str(prefix)+'.winner-records.u16le',dtype='<u2').reshape(5,32400);wd=np.fromfile(str(prefix)+'.winner-depths.f32le',dtype='<f4').reshape(5,32400);assert targets.size==32400 and set(targets)<={0,1} and targets.sum()==g['targets'];packed=np.packbits(targets,bitorder='little');assert packed.size==4050
 slots=[];dep=[]
 for phase in range(5):
  for p in np.flatnonzero((targets==0) if phase==0 else (targets==1)):
   hit=int(wr[phase,p]!=65535);slots.append([int(p%240),int(p//240),0xffffffff if phase==0 else phase-1,hit]);dep.append(float(wd[phase,p]) if hit else 0.)
 slots=np.array(slots,dtype=np.uint32);dep=np.array(dep,dtype=np.float32);actions=np.zeros(len(slots),dtype=np.uint8);fdepth=np.zeros(len(slots),dtype=np.float32);assert len(slots)==32400+3*g['targets']<=39573
 status=bg(cfg.ctypes.data_as(D),ix.ctypes.data_as(U),slots.ctypes.data_as(U),dep.ctypes.data_as(F),len(slots),actions.ctypes.data_as(Y),fdepth.ctypes.data_as(F));assert status==0,status
 quarter=slots[:,2]!=0xffffffff;hit=slots[:,3]==1;replacement=actions!=0;qmiss=int((quarter&~hit).sum());qoverride=int((quarter&hit&replacement).sum());creplace=int((~quarter&replacement).sum());empty=int((~hit).sum());overrides=int((hit&replacement).sum());shades=empty+overrides;assert qmiss==4*g['targets']-sum(g['hits'][1:]);assert shades==int(replacement.sum())
 fw_shader=[64,64,0,0,0,0,0,0,0,0];fw_hit=[0,0,128,0,0,0,0,0,0,64];fw_eval=[0,0,0,768,288,6144,4608,128,64,0];floor=[s*shaders+(h+e)*hits for s,h,e in zip(fw_shader,fw_hit,fw_eval)];assert sum(floor)<=875970912
 # Six sc_resolve charges/slot, binding+mask+17 band guards, two charges/quarter miss,
 # one/quarter override, one/non-target replacement; +1 reserved descriptor guard.
 guards=6*len(slots)+2+17+2*qmiss+qoverride+creplace+1
 scene=[512,0,4050,2*(32400-g['targets']),0,0,0,6*len(slots),5*len(slots),len(slots),3*len(slots),3*len(slots),2*len(slots),3*(qmiss+qoverride),6*qmiss,0,8*creplace,0,guards,16384];assert sum(scene)<=1680000
 bg_total=8192+593920+2048*len(slots)+36736*shades;assert bg_total<=1540298112
 d={'status':'COMPLETE_AUTHENTIC_METADATA','kind':kind,'view':'front','sourceFreezeSHA256':sha(freeze),'snapshotSHA256':sha(str(prefix)+'.snapshot'),'snapshotFNV':g['snapshotFNV'],'targetPackedFNV':fnv(packed.tobytes()),'targetPackedSHA256':hashlib.sha256(packed.tobytes()).hexdigest(),'targets':g['targets'],'quarterHits':g['hits'][1:],'shaders':shaders,'floorHits':hits,'floorRayCounters':dict(zip(['rays','nodes','triangles','groundHits','characterHits','misses','events','sceneBytes'],counters)),'floorCategoryLimits':floor,'floorWorkLimit':sum(floor),'floorWorldWorkLimit':64*shaders+6272*hits,'background':{'slots':len(slots),'emptySlots':empty,'overrides':overrides,'shadeLimit':shades,'floor':int((actions==1).sum()),'world':int((actions==2).sum()),'keep':int((actions==0).sum()),'quarterMisses':qmiss,'quarterOverrides':qoverride,'centerReplacements':creplace,'workLimit':bg_total},'sceneCategoryLimits':scene,'sceneReservedTotal':sum(scene),'fullShadingExecuted':False,'nearestRayQueriesExecuted':True,'sourceCameraFields':{k:config[k] for k in ['nativeCameraF32','sourceOrigin','sourceUnitView','near','far','rho','floorWorld','floorTriangles','le','worldRGB','worldStrength']}}
 if kind=='baseline':
  old=json.loads((ROOT/'fox-v3-indexed-bvh-bounds/actual-on-001/native-front-baseline.floor.json').read_text());oldbg=json.loads((ROOT/'fox-v3-indexed-bvh-bounds/actual-on-001/native-front-baseline.background.json').read_text());assert shaders==old['shaderCalls'] and hits==old['floorHits'];assert floor==[x['limit'] for x in old['categories'].values()];assert scene==[x['reserved'] for x in oldbg['core']['categories'].values()];assert [d['background'][k] for k in ['slots','keep','floor','world']]==[oldbg['classification'][k] for k in ['slots','keep','floor','world']];d['baselineExistingCountsAndLedgersExact']=True
 write(out,d);rows.append(d);print(kind,json.dumps({'shaders':shaders,'floorHits':hits,'background':d['background'],'rayCounters':d['floorRayCounters']}),flush=True)
assert pins['files']==inputs();write(HERE/'METADATA_RESULT.json',{'status':'THREE_FRONT_METADATA_COMPLETE_NO_SHADED_FRAMES','freezeSHA256':sha(freeze),'rows':rows})
