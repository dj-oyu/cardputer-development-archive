import bpy,pathlib,json,ctypes,numpy as np,time,hashlib,sys
from mathutils import Vector
from mathutils.bvhtree import BVHTree
R=pathlib.Path(sys.argv[sys.argv.index('--')+1]).resolve();D=R/'native';W=R.parent;S=W/'fox-v3-lighting-ab/four-both-002';O=W/'fox-v3-position-diagnostic/observer';P=W/'fox-v3-position-diagnostic';OUT=D/'run-001';OUT.mkdir(exist_ok=False)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();inputs=[D/'run.py',D/'shader.c',D/'shader.so',R/'blender/ground-geometry.json',S/'model-baseline/compile.json',W/'fox-v3-lighting-ab/physical/fox_disk_lighting.c',W/'fox-v3-lighting-ab/physical/fox_disk_lighting.h',W/'fox-v3-lighting-ab/product/main/ayatsuri/ayatsuri_shade.h']
for case in ['baseline','direction']:
 inputs += [S/f'physical-{case}.txt',P/f'pixel-oblique-{case}.npz']+[O/f'native-oblique-{case}.{ext}' for ext in ['observer.f32','vertices.f64','sides.u8','map.u8']]
hashes={str(p):sha(p) for p in inputs};(OUT/'input-hashes.json').write_text(json.dumps(hashes,indent=2))
lib=ctypes.CDLL(str(D/'shader.so'));DP=ctypes.POINTER(ctypes.c_double);UP=ctypes.POINTER(ctypes.c_ushort);lib.init.argtypes=[ctypes.c_char_p];lib.sample_rays.argtypes=[DP,DP,DP,DP];lib.direct_unit.argtypes=[DP,DP,UP,DP];lib.decode_rho.argtypes=[ctypes.c_uint,DP]
comp=json.loads((S/'model-baseline/compile.json').read_text());materials={m['id']:m for m in comp['materialTrace']};vs0=np.fromfile(O/'native-oblique-baseline.vertices.f64',np.float64).reshape(3,256,32,3);vertices=[];triangles=[]
def transform(a,position=False):
 a=a.copy();return np.ascontiguousarray(a[[0,2,1]]*[1,-1,-1]/(38 if position else 1),np.float64)
for node,p in enumerate(comp['parts'],1):
 offset=len(vertices);vertices += [tuple(transform(v,True)) for v in vs0[0,node,:len(p['positions'])]];triangles += [tuple(offset+i for i in t) for t in p['triangles']]
assert len(triangles)==1166
G=json.loads((R/'blender/ground-geometry.json').read_text());offset=len(vertices);vertices+=G['vertices'];triangles += [tuple(offset+i for i in t) for t in G['triangles']]
bvh=BVHTree.FromPolygons(vertices,triangles,all_triangles=True,epsilon=0);EPS=1e-5;cost=[];start=time.monotonic()
for case in ['baseline','direction']:
 t=time.monotonic();assert lib.init(str(S/f'physical-{case}.txt').encode())==1
 obs=np.fromfile(O/f'native-oblique-{case}.observer.f32',np.float32).reshape(135,240,16);vs=np.fromfile(O/f'native-oblique-{case}.vertices.f64',np.float64).reshape(3,256,32,3);sides=np.fromfile(O/f'native-oblique-{case}.sides.u8',np.uint8).reshape(256,64);remap=np.fromfile(O/f'native-oblique-{case}.map.u8',np.uint8).reshape(256,32);pixel=np.load(P/f'pixel-oblique-{case}.npz');coverage=obs[...,15]>0;assert np.array_equal(coverage,pixel['coverage'])
 arrays={f'{rate}_{rho}_{shadow}':np.zeros((135,240,3)) for rate in ['pixel','vertex'] for rho in ['source','565'] for shadow in ['off','on']};bitsimage=np.zeros((135,240,3),np.uint16);rhoimage=np.zeros((135,240,3));cache={};counts={'rays':0,'blocked':0,'groundBlocked':0,'near':0}
 def integral(p,n):
  endpoints=np.empty((48,3));kernels=np.empty(48);assert lib.sample_rays(p.ctypes.data_as(DP),n.ctypes.data_as(DP),endpoints.ctypes.data_as(DP),kernels.ctypes.data_as(DP))==1
  bits=np.full(3,65535,np.uint16)
  for index in np.flatnonzero(kernels>0):
   delta=endpoints[index]-p;length=float(np.linalg.norm(delta));assert length>2*EPS;wi=delta/length;hit,normal,face,distance=bvh.ray_cast(Vector(p+wi*EPS),Vector(wi),length-2*EPS);counts['rays']+=1
   if hit is not None:bits[index//16]&=np.uint16(65535^(1<<(index%16)));counts['blocked']+=1;counts['groundBlocked']+=face>=1166;counts['near']+=distance<1e-4
  vals={}
  for shadow,b in [('off',np.full(3,65535,np.uint16)),('on',bits)]:
   raw=np.empty(3);assert lib.direct_unit(p.ctypes.data_as(DP),n.ctypes.data_as(DP),b.ctypes.data_as(UP),raw.ctypes.data_as(DP))==1;vals[shadow]=raw
  return vals,bits
 for y,x in np.argwhere(coverage):
  row=obs[y,x];node=int(row[0]);face=int(row[1]);side=int(sides[node,face]);cids=row[3:6].astype(int);ids=remap[node,cids].astype(int);assert np.array_equal(ids,cids);weights=row[6:9].astype(float);m=materials[comp['parts'][node-1]['materialId']];rho={'source':np.array(m['sourceLinear'][:3]),'565':np.empty(3)};assert lib.decode_rho(m['albedo565'],rho['565'].ctypes.data_as(DP))==1;rhoimage[y,x]=rho['source']
  p=np.ascontiguousarray(pixel['position'][y,x]);n=np.ascontiguousarray(pixel['normal'][y,x]);iv,bits=integral(p,n);bitsimage[y,x]=bits
  for shadow in ['off','on']:
   for name in rho:arrays[f'pixel_{name}_{shadow}'][y,x]=iv[shadow]*rho[name]
  for k,vid in enumerate(ids):
   key=(node,int(vid),side)
   if key not in cache:cache[key]=integral(transform(vs[0,node,vid],True),transform(vs[side+1,node,vid]))[0]
   for shadow in ['off','on']:
    for name in rho:arrays[f'vertex_{name}_{shadow}'][y,x]+=weights[k]*cache[key][shadow]*rho[name]
 assert all(np.isfinite(v).all() and (v>=0).all() for v in arrays.values());np.savez_compressed(OUT/(case+'.npz'),**arrays,coverage=coverage,bits=bitsimage,sourceRho=rhoimage)
 cost.append({'case':case,'seconds':time.monotonic()-t,'coveredPixels':int(coverage.sum()),'uniqueVertexQueries':len(cache),**counts});print(json.dumps(cost[-1]),flush=True)
assert all(sha(pathlib.Path(p))==h for p,h in hashes.items());(OUT/'COMPLETED.json').write_text(json.dumps({'cases':cost,'wallSeconds':time.monotonic()-start,'worldTermAbsent':True,'groundEmissionAbsent':True,'occluderTriangles':len(triangles),'allInputsUnchanged':True,'scope':'host direct-only C integration with geometry ray visibility, raw pixel and float vertex interpolation, source/565 rho; not product output'},indent=2))
