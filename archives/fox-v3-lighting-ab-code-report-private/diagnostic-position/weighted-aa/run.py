import bpy,pathlib,json,ctypes,numpy as np,time,resource,hashlib,sys,os
from mathutils import Vector
from mathutils.bvhtree import BVHTree
R=pathlib.Path(sys.argv[sys.argv.index('--')+1]).resolve();D=R/'weighted-aa';S=R.parent/'fox-v3-lighting-ab/four-both-002';O=R/'observer';start=time.monotonic()
sys.path.insert(0,str(D));from aa_math import filter_grid,tests
lib=ctypes.CDLL(str(D/'shader.so'));ras=ctypes.CDLL(str(D/'raster.so'));PTR=ctypes.POINTER(ctypes.c_double);UP=ctypes.POINTER(ctypes.c_ushort)
lib.init.argtypes=[ctypes.c_char_p];lib.shade_visibility.argtypes=[PTR,PTR,ctypes.c_uint,UP,UP,PTR];lib.sample_rays.argtypes=[PTR,PTR,PTR,PTR];lib.encode_raw.argtypes=[PTR,UP];ras.raster.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_double,ctypes.c_double,ctypes.c_void_p,ctypes.c_void_p]
(D/'synthetic.json').write_text(json.dumps(tests(ras.raster),indent=2))
# Refuse an existing completed run, or duplicate live writer.
assert not list(D.glob('grid*-complete.json')) and not list(D.glob('grid*.npz')) and not list(D.glob('grid*.u16le')), 'prior output exists: explicit new attempt required, never overwrite verified arms'
lock=D/'RUNNING.json'
if lock.exists():
 prior=json.loads(lock.read_text());pid=prior['pid']
 try:os.kill(pid,0)
 except ProcessLookupError:pass
 else:raise RuntimeError('live AA writer exists')
assert not (D/'COMPLETED.json').exists(),'completed output must not be overwritten'
lock.write_text(json.dumps({'pid':os.getpid(),'started':time.time()}))
comp=json.loads((S/'model-baseline/compile.json').read_text());rho={m['id']:m['albedo565'] for m in comp['materialTrace']};rawv=np.fromfile(O/'native-front-baseline.vertices.f64',np.float64).reshape(3,256,32,3)[0];verts=[];triangles=[]
for node,p in enumerate(comp['parts'],1):
 off=len(verts)
 for v in rawv[node,:len(p['positions'])]:verts.append((v[0]/38,-v[2]/38,-v[1]/38))
 for t in p['triangles']:triangles.append(tuple(off+i for i in t))
assert len(triangles)==1166 and np.isfinite(verts).all();bvh=BVHTree.FromPolygons(verts,triangles,all_triangles=True,epsilon=0.0)
unit=BVHTree.FromPolygons([(-1,-1,0),(1,-1,0),(0,1,0)],[(0,1,2)],all_triangles=True,epsilon=0.0)
assert unit.ray_cast(Vector((0,0,1)),Vector((0,0,-1)),2)[0] is not None and unit.ray_cast(Vector((0,0,-1)),Vector((0,0,1)),2)[0] is not None
assert unit.ray_cast(Vector((0,0,1)),Vector((0,0,-1)),.5)[0] is None
records=[];EPS=1e-5;case_data={}
for view in ['front','oblique']:
 for case in ['baseline','direction']:
  t=np.fromfile(D/f'native-{view}-{case}.triangles.f32',np.float32).reshape(-1,15);assert len(t)==1166
  vs=np.fromfile(O/f'native-{view}-{case}.vertices.f64',np.float64).reshape(3,256,32,3);assert np.array_equal(vs[0],rawv)
  ps=[];ns=[];colors=[]
  for row in t:
   node,face,side=map(int,row[:3]);ids=row[3:6].astype(int);assert side in (0,1);p=vs[0,node,ids]/38;n=vs[1+side,node,ids];ps.append(p[:,[0,2,1]]*[1,-1,-1]);ns.append(n[:,[0,2,1]]*[1,-1,-1]);colors.append(rho[comp['parts'][node-1]['materialId']])
  case_data[(view,case)]=(t,np.array(ps),np.array(ns),np.array(colors))
 assert np.array_equal(case_data[(view,'baseline')][0],case_data[(view,'direction')][0])
for grid in [1,3,5]:
 if grid!=1:assert (D/'POINT_CONTROL_PASS.json').exists()
 offsets,weights=filter_grid(grid)
 for view in ['front','oblique']:
  for case in ['baseline','direction']:
   t0=time.monotonic();cpu0=time.process_time();assert lib.init(str(S/f'physical-{case}.txt').encode())==1;t,pp,nn,colors=case_data[(view,case)];acc=np.zeros((135,240,3));weightedcoverage=np.zeros((135,240));anycoverage=np.zeros((135,240),bool);queries=rays=blocked=near=0
   for gy,oy in enumerate(offsets):
    for gx,ox in enumerate(offsets):
     winner=np.full((135,240),-1,np.int32);ws=np.zeros((135,240,3),np.float32);assert ras.raster(t.ctypes.data,len(t),float(ox),float(oy),winner.ctypes.data,ws.ctypes.data)==1;covered=winner>=0;idx=winner[covered];ww=ws[covered].astype(float);pfield=np.sum(pp[idx]*ww[...,None],axis=1);nfield=np.sum(nn[idx]*ww[...,None],axis=1);assert np.isfinite(pfield).all() and np.isfinite(nfield).all()
     if grid==1:
      old=np.load(R/f'pixel-{view}-{case}.npz');assert np.array_equal(covered,old['coverage']);assert np.array_equal(pfield,old['position'][covered]) and np.array_equal(nfield,old['normal'][covered]),'center geometry mismatch'
     sample=np.zeros((135,240,3));samplecovered=np.empty((len(idx),3))
     for q in range(len(idx)):
      p=pfield[q].copy();n=nfield[q].copy();end=np.empty((48,3));kernels=np.empty(48);assert lib.sample_rays(p.ctypes.data_as(PTR),n.ctypes.data_as(PTR),end.ctypes.data_as(PTR),kernels.ctypes.data_as(PTR))==1;assert np.isfinite(end).all() and np.isfinite(kernels).all();bits=np.full(3,65535,np.uint16)
      for i in np.flatnonzero(kernels>0):
       delta=end[i]-p;distance=float(np.linalg.norm(delta));assert distance>2*EPS and np.isfinite(distance);wi=delta/distance;hit,_,_,dist=bvh.ray_cast(Vector(p+wi*EPS),Vector(wi),distance-2*EPS);rays+=1
       if hit is not None:bits[i//16]&=np.uint16(65535^(1<<(i%16)));blocked+=1;near+=dist<1e-4
      value=ctypes.c_ushort();raw=np.empty(3);assert lib.shade_visibility(p.ctypes.data_as(PTR),n.ctypes.data_as(PTR),int(colors[idx[q]]),bits.ctypes.data_as(UP),ctypes.byref(value),raw.ctypes.data_as(PTR))==1;samplecovered[q]=raw;queries+=1
     sample[covered]=samplecovered;weight=float(weights[gy]*weights[gx]);acc+=weight*sample;weightedcoverage+=weight*covered;anycoverage|=covered
     print(json.dumps({'grid':grid,'view':view,'case':case,'sample':gy*grid+gx+1,'total':grid*grid,'elapsedSeconds':time.monotonic()-t0}),flush=True)
   out=np.zeros((135,240),np.uint16)
   for y,x in np.argwhere(anycoverage):
    value=ctypes.c_ushort();raw=acc[y,x].copy();assert lib.encode_raw(raw.ctypes.data_as(PTR),ctypes.byref(value))==1;out[y,x]=value.value
   if grid==1:
    old=np.load(R/'visibility'/f'visible-{view}-{case}.npz');assert np.array_equal(acc,old['raw']),'point raw mismatch';assert np.array_equal(out,np.fromfile(R/'visibility'/f'visible-{view}-{case}.u16le','<u2').reshape(135,240)),'point565 mismatch'
   stem=f'grid{grid}-{view}-{case}';out.astype('<u2').tofile(D/(stem+'.u16le'));np.savez_compressed(D/(stem+'.npz'),raw=acc,coverage=anycoverage,weightedCoverage=weightedcoverage)
   rec={'grid':grid,'view':view,'case':case,'queries':queries,'rays':rays,'blocked':blocked,'nearHits':int(near),'wallSeconds':time.monotonic()-t0,'cpuSeconds':time.process_time()-cpu0};records.append(rec);(D/(stem+'-complete.json')).write_text(json.dumps(rec,indent=2));(D/'progress.json').write_text(json.dumps(records,indent=2))
 if grid==1:(D/'POINT_CONTROL_PASS.json').write_text(json.dumps({'all4Cases':True,'positionNormalRaw565CoverageExact':True}))
u=resource.getrusage(resource.RUSAGE_SELF);report={'records':records,'wallSeconds':time.monotonic()-start,'userSeconds':u.ru_utime,'systemSeconds':u.ru_stime,'peakRSSKiB':u.ru_maxrss,'pid':os.getpid()};(D/'COMPLETED.json').write_text(json.dumps(report,indent=2));lock.unlink();print('WEIGHTED_AA_COMPLETE',flush=True)
