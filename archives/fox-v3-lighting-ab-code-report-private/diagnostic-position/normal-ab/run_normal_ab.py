import bpy,pathlib,json,ctypes,numpy as np,time,resource,hashlib,sys
from mathutils import Vector
from mathutils.bvhtree import BVHTree
R=pathlib.Path(sys.argv[sys.argv.index('--')+1]).resolve();D=R/'normal-ab';S=R.parent/'fox-v3-lighting-ab/four-both-002';O=R/'observer';start=time.monotonic();lib=ctypes.CDLL(str(R/'visibility/shader_visibility.so'));PTR=ctypes.POINTER(ctypes.c_double);UP=ctypes.POINTER(ctypes.c_ushort)
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

sys.path.insert(0,str(D))
from normal_geometry import geometric_normal,tests
(D/'synthetic.json').write_text(json.dumps(tests(),indent=2))

config=json.loads((R.parent/'fox-reference-uncertainty-v3/input/config.json').read_text());ng_fields={};case_data={};cache_reports=[]
# Build/validate Ng for every winner before tracing or accepting any new image.
for view in ['front','oblique']:
 cam=next(c for c in config['cameras'] if c['name']==view);V=np.array(cam['blenderLocation'])-cam['blenderTarget'];V=V/np.linalg.norm(V)
 for case in ['baseline','direction']:
  q=np.load(R/f'pixel-{view}-{case}.npz');a=np.fromfile(O/f'native-{view}-{case}.observer.f32',np.float32).reshape(135,240,16);remap=np.fromfile(O/f'native-{view}-{case}.map.u8',np.uint8).reshape(256,32);sides=np.fromfile(O/f'native-{view}-{case}.sides.u8',np.uint8).reshape(256,64);ngs=np.full((135,240,3),np.nan)
  for y,x in np.argwhere(q['coverage']):
   row=a[y,x];node=int(row[0]);face=int(row[1]);ids=remap[node,row[3:6].astype(int)].astype(int);part=comp['parts'][node-1];matches=[t for t in part['triangles'] if sorted(t)==sorted(ids.tolist())];assert len(matches)==1,'ambiguous original triangle'
   original=matches[0];cyclic=[original[i:]+original[:i] for i in range(3)];reversed_tri=[original[0],original[2],original[1]];revcyclic=[reversed_tri[i:]+reversed_tri[:i] for i in range(3)];side=int(sides[node,face]);assert (ids.tolist() in revcyclic)==bool(side) and (ids.tolist() in cyclic)==(not side),'selected side/winding mismatch'
   def source_triangle(indices):
    p=rawv[node,indices]/38;return np.ascontiguousarray(p[:,[0,2,1]]*np.array([1,-1,-1]))
   tri=source_triangle(ids);ng=geometric_normal(tri,V);ot=source_triangle(original);physical=np.cross(ot[1]-ot[0],ot[2]-ot[0])*(1 if side else -1)
   assert np.dot(physical,V)>1e-12,'physical side not view-facing'
   assert np.allclose(ng/np.linalg.norm(ng),physical/np.linalg.norm(physical),rtol=0,atol=1e-12),'Ng camera/physical side mismatch'
   ngs[y,x]=ng
  ng_fields[(view,case)]=ngs;case_data[(view,case)]=(q,a)
# ALL48 endpoint geometry visibility, independent of normal. Endpoint API checked Ns/Ng equality.
for view in ['front','oblique']:
 for case in ['baseline','direction']:
  t0=time.monotonic();assert lib.init(str(S/f'physical-{case}.txt').encode())==1;q,a=case_data[(view,case)];bitout=np.zeros((135,240,3),np.uint16);rays=hits=nearhits=0
  for y,x in np.argwhere(q['coverage']):
   p=q['position'][y,x].copy();n=q['normal'][y,x].copy();ng=ng_fields[(view,case)][y,x].copy();end=np.empty((48,3));endg=np.empty_like(end);kernels=np.empty(48);kg=np.empty(48)
   assert lib.sample_rays(p.ctypes.data_as(PTR),n.ctypes.data_as(PTR),end.ctypes.data_as(PTR),kernels.ctypes.data_as(PTR))==1
   assert lib.sample_rays(p.ctypes.data_as(PTR),ng.ctypes.data_as(PTR),endg.ctypes.data_as(PTR),kg.ctypes.data_as(PTR))==1
   assert np.array_equal(end,endg) and np.isfinite(end).all();bits=np.full(3,65535,np.uint16)
   for i in range(48):
    delta=end[i]-p;distance=float(np.linalg.norm(delta));assert np.isfinite(distance) and distance>2*EPS;wi=delta/distance
    hit,normal,face,dist=bvh.ray_cast(Vector(p+wi*EPS),Vector(wi),distance-2*EPS);rays+=1
    if hit is not None:bits[i//16]&=np.uint16(65535^(1<<(i%16)));hits+=1;nearhits+=dist<1e-4
   bitout[y,x]=bits
  np.savez_compressed(D/f'cache-{view}-{case}.npz',bits=bitout,normalGeometric=ng_fields[(view,case)],coverage=q['coverage'])
  cache_reports.append({'view':view,'case':case,'rays':rays,'blocked':hits,'nearHits':int(nearhits),'seconds':time.monotonic()-t0})
# Ns controls for all four images precede Ng acceptance.
for arm in ['Ns','Ng']:
 for view in ['front','oblique']:
  for case in ['baseline','direction']:
   assert lib.init(str(S/f'physical-{case}.txt').encode())==1;q,a=case_data[(view,case)];cache=np.load(D/f'cache-{view}-{case}.npz');out=np.zeros((135,240),np.uint16);rawout=np.zeros((135,240,3))
   for y,x in np.argwhere(q['coverage']):
    node=int(a[y,x,0]);c=rho[comp['parts'][node-1]['materialId']];p=q['position'][y,x].copy();n=(q['normal'][y,x] if arm=='Ns' else ng_fields[(view,case)][y,x]).copy();out[y,x],rawout[y,x]=shade(p,n,c,cache['bits'][y,x].copy())
   if arm=='Ns':
    old=np.fromfile(R/'visibility'/f'visible-{view}-{case}.u16le','<u2').reshape(135,240);oldraw=np.load(R/'visibility'/f'visible-{view}-{case}.npz')['raw'];assert np.array_equal(out,old) and np.array_equal(rawout,oldraw),'Ns full-cache control mismatch'
   out.astype('<u2').tofile(D/f'{arm}-{view}-{case}.u16le');np.savez_compressed(D/f'{arm}-{view}-{case}.npz',raw=rawout,coverage=q['coverage'])
 if arm=='Ns':(D/'NS_CONTROL_PASS.json').write_text(json.dumps({'rawFloat64Exact':True,'rgb565Exact':True,'cases':4,'beforeNg':True}))
usage=resource.getrusage(resource.RUSAGE_SELF)
(D/'run-report.json').write_text(json.dumps({'planSHA256':hashlib.sha256((D/'PLAN.md').read_bytes()).hexdigest(),'triangles':len(triangles),'vertices':len(verts),'records':cache_reports,'totalSeconds':time.monotonic()-start,'processUserSeconds':usage.ru_utime,'processSystemSeconds':usage.ru_stime,'processPeakRSSKiB':usage.ru_maxrss,'normalOnlyAB':True,'normalIndependentCache':True},indent=2));print('NORMAL_AB_COMPLETE',flush=True)
