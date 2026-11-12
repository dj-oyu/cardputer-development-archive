import bpy,pathlib,json,ctypes,numpy as np,time,resource,hashlib,sys
from mathutils import Vector
from mathutils.bvhtree import BVHTree
R=pathlib.Path(sys.argv[sys.argv.index('--')+1]).resolve();D=R/'visibility';S=R.parent/'fox-v3-lighting-ab/four-both-002';O=R/'observer';start=time.monotonic();lib=ctypes.CDLL(str(D/'shader_visibility.so'));PTR=ctypes.POINTER(ctypes.c_double);UP=ctypes.POINTER(ctypes.c_ushort)
lib.init.argtypes=[ctypes.c_char_p];lib.shade_visibility.argtypes=[PTR,PTR,ctypes.c_uint,UP,UP,PTR];lib.sample_rays.argtypes=[PTR,PTR,PTR,PTR]
comp=json.loads((S/'model-baseline/compile.json').read_text());rho={m['id']:m['albedo565'] for m in comp['materialTrace']};rawv=np.fromfile(O/'native-front-baseline.vertices.f64',np.float64).reshape(3,256,32,3)[0]
for view in ['front','oblique']:
 for case in ['baseline','direction']:assert np.array_equal(rawv,np.fromfile(O/f'native-{view}-{case}.vertices.f64',np.float64).reshape(3,256,32,3)[0])
verts=[];triangles=[]
for node,p in enumerate(comp['parts'],1):
 offset=len(verts)
 for v in rawv[node,:len(p['positions'])]:verts.append((v[0]/38,-v[2]/38,-v[1]/38))
 for t in p['triangles']:triangles.append(tuple(offset+i for i in t))
assert len(triangles)==1166
# Explicitly verify opaque two-sided nearest-hit semantics on a synthetic triangle.
unit=BVHTree.FromPolygons([(-1,-1,0),(1,-1,0),(0,1,0)],[(0,1,2)],all_triangles=True,epsilon=0.0)
assert unit.ray_cast(Vector((0,0,1)),Vector((0,0,-1)),2)[0] is not None
assert unit.ray_cast(Vector((0,0,-1)),Vector((0,0,1)),2)[0] is not None
assert unit.ray_cast(Vector((0,0,1)),Vector((0,0,-1)),.5)[0] is None
bvh=BVHTree.FromPolygons(verts,triangles,all_triangles=True,epsilon=0.0);buildend=time.monotonic();records=[];EPS=1e-5
allbits=np.full(3,65535,np.uint16)
def shade(p,n,c,bits):
 out=ctypes.c_ushort();raw=np.empty(3,np.float64);assert lib.shade_visibility(p.ctypes.data_as(PTR),n.ctypes.data_as(PTR),c,bits.ctypes.data_as(UP),ctypes.byref(out),raw.ctypes.data_as(PTR))==1;return out.value,raw
# ALL-VISIBLE control completes for all four images before any visibility ablation result.
for view in ['front','oblique']:
 for case in ['baseline','direction']:
  assert lib.init(str(S/f'physical-{case}.txt').encode())==1;q=np.load(R/f'pixel-{view}-{case}.npz');a=np.fromfile(O/f'native-{view}-{case}.observer.f32',np.float32).reshape(135,240,16);old=np.fromfile(R/f'pixel-{view}-{case}.u16le','<u2').reshape(135,240)
  for y,x in np.argwhere(q['coverage']):
   node=int(a[y,x,0]);c=rho[comp['parts'][node-1]['materialId']];value,raw=shade(q['position'][y,x].copy(),q['normal'][y,x].copy(),c,allbits);assert value==old[y,x] and np.array_equal(raw,q['raw'][y,x]),'all-visible control mismatch'
(D/'ALL_VISIBLE_CONTROL_PASS.json').write_text(json.dumps({'cases':4,'rawFloat64Exact':True,'rgb565Exact':True,'beforeAblation':True}))
for view in ['front','oblique']:
 for case in ['baseline','direction']:
  t0=time.monotonic();assert lib.init(str(S/f'physical-{case}.txt').encode())==1;q=np.load(R/f'pixel-{view}-{case}.npz');a=np.fromfile(O/f'native-{view}-{case}.observer.f32',np.float32).reshape(135,240,16);out=np.zeros((135,240),np.uint16);rawout=np.zeros((135,240,3));bitout=np.zeros((135,240,3),np.uint16);rays=hits=nearhits=0
  for y,x in np.argwhere(q['coverage']):
   p=q['position'][y,x].copy();n=q['normal'][y,x].copy();node=int(a[y,x,0]);c=rho[comp['parts'][node-1]['materialId']];end=np.empty((48,3));kernels=np.empty(48);assert lib.sample_rays(p.ctypes.data_as(PTR),n.ctypes.data_as(PTR),end.ctypes.data_as(PTR),kernels.ctypes.data_as(PTR))==1;bits=np.full(3,65535,np.uint16)
   for i in np.flatnonzero(kernels>0):
    delta=end[i]-p;distance=float(np.linalg.norm(delta));assert distance>2*EPS;wi=delta/distance;origin=Vector(p+wi*EPS);hit,normal,face,dist=bvh.ray_cast(origin,Vector(wi),distance-2*EPS);rays+=1
    if hit is not None:
     bits[i//16]&=np.uint16(65535^(1<<int(i%16)));hits+=1;nearhits+=dist<1e-4
   out[y,x],rawout[y,x]=shade(p,n,c,bits);bitout[y,x]=bits
  out.astype('<u2').tofile(D/f'visible-{view}-{case}.u16le');np.savez_compressed(D/f'visible-{view}-{case}.npz',raw=rawout,bits=bitout,coverage=q['coverage'])
  records.append({'view':view,'case':case,'pixels':int(q['coverage'].sum()),'positiveKernelRays':rays,'blockedRays':hits,'blockedDistanceBelow1e-4':int(nearhits),'seconds':time.monotonic()-t0})
(D/'run-report.json').write_text(json.dumps({'planSHA256':hashlib.sha256((D/'PLAN.md').read_bytes()).hexdigest(),'triangles':len(triangles),'vertices':len(verts),'geometryPackedF32U32Bytes':len(verts)*12+len(triangles)*12,'bvhExactAllocationBytes':'not exposed by mathutils; not claimed','buildAndSetupSeconds':buildend-start,'totalSeconds':time.monotonic()-start,'processPeakRSSKiB':resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,'hostOnly':True,'records':records},indent=2));print('VISIBILITY_COMPLETE',records)
