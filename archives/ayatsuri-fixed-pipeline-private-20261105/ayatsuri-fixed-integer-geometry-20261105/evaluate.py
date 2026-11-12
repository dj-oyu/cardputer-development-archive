"""Offline floating camera preparation/reference, arbitrary precision integer oracle and C tests."""
import ctypes as C, hashlib, importlib.util, itertools, json, math, pathlib, random, struct, sys
import numpy as np
sys.dont_write_bytecode=True
HERE=pathlib.Path(__file__).resolve().parent
ROOT=HERE.parent
class Camera(C.Structure):
 _fields_=[('m',C.c_int32*9),('offset',C.c_int32*3),('frac',C.c_int32),('width',C.c_int32),('height',C.c_int32)]
class Point(C.Structure):
 _fields_=[('x',C.c_int32),('y',C.c_int32),('z',C.c_int32)]
def tup(p):return (p.x,p.y,p.z)
def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def rne(n,d):
 s=-1 if n<0 else 1;q,r=divmod(abs(n),d)
 return s*(q+(2*r>d or (2*r==d and q%2!=0)))
def oracle_project(c,p,q):
 if c.frac not in (16,20) or not 1<=c.width<=2048 or not 1<=c.height<=2048:raise ValueError()
 if any(abs(v)>128*(1<<c.frac) for v in p) or any(abs(v)>1<<28 for v in c.m) or any(abs(v)>4096*(1<<q) for v in c.offset):raise ValueError()
 v=tuple(rne(sum(p[k]*c.m[j*3+k] for k in range(3)),1<<(c.frac+20-q))+c.offset[j] for j in range(3))
 if any(abs(x)>4096*(1<<q) for x in v):raise ValueError()
 return v
def edge(a,b,p):return (b[0]-a[0])*(p[1]-a[1])-(b[1]-a[1])*(p[0]-a[0])
def incl(a,b):return b[1]<a[1] or (b[1]==a[1] and b[0]>a[0])
def oracle_sample(t,p):
 idx=[0,1,2];t=list(t);a=edge(*t)
 if not a:return 0,(0,0,0)
 if a<0:t[1],t[2]=t[2],t[1];idx[1],idx[2]=2,1;a=-a
 e=[edge(t[(k+1)%3],t[(k+2)%3],p) for k in range(3)]
 if any(e[k]<0 or (e[k]==0 and not incl(t[(k+1)%3],t[(k+2)%3])) for k in range(3)):return 0,(0,0,0)
 w=[v*16384//a for v in e];rem=[v*16384%a for v in e]
 for k in sorted(range(3),key=lambda k:(-rem[k],t[k]))[:16384-sum(w)]:w[k]+=1
 out=[0]*3
 for k in range(3):out[idx[k]]=w[k]
 return 1,tuple(out)
def lib(q):
 l=C.CDLL(str(HERE/f'geometry{q}.so'))
 l.project.argtypes=[C.POINTER(Camera),C.POINTER(C.c_int32),C.POINTER(Point)]
 l.project_batch.argtypes=[C.POINTER(Camera),C.POINTER(C.c_int32),C.POINTER(Point),C.c_int,C.c_int]
 l.sample.argtypes=[C.POINTER(Point),C.c_int32,C.c_int32,C.POINTER(C.c_int16)]
 l.sample_batch.argtypes=[C.POINTER(Point),C.POINTER(C.c_int32),C.c_int,C.c_int,C.POINTER(C.c_int8),C.POINTER(C.c_int16)]
 return l
def check_samples(l,t,ps):
 arr=(Point*3)(*(Point(*v) for v in t));n=len(ps);xy=(C.c_int32*(n*2))(*(v for p in ps for v in p[:2]))
 expected=[oracle_sample(t,p) for p in ps]
 for lanes in (1,2,4,8):
  covered=(C.c_int8*n)();weights=(C.c_int16*(n*3))()
  assert l.sample_batch(arr,xy,n,lanes,covered,weights)==0
  assert [(covered[i],tuple(weights[3*i:3*i+3])) for i in range(n)]==expected
 return expected
def synthetic(q):
 l=lib(q);r=random.Random(5523);count=0;M=4096*(1<<q)
 assert [rne(x,2) for x in (-5,-3,-1,1,3,5)]==[-2,-2,0,0,2,2]
 for frac in (16,20):
  for j in range(150):
   c=Camera((C.c_int32*9)(*(r.randint(-(1<<28),1<<28) for _ in range(9))),(C.c_int32*3)(*(r.randint(-M,M) for _ in range(3))),frac,240,135)
   p=[r.randint(-128*(1<<frac),128*(1<<frac)) for _ in range(3)];out=Point(99,99,99)
   try:expect=oracle_project(c,p,q)
   except ValueError:expect=None
   got=l.project(C.byref(c),(C.c_int32*3)(*p),C.byref(out));assert (got==-1)==(expect is None)
   assert tup(out)==((99,99,99) if expect is None else expect);count+=1
  c=Camera((C.c_int32*9)(1<<20,0,0,0,1<<20,0,0,0,1<<20),(C.c_int32*3)(0,0,0),frac,240,135)
  for odd in (-5,-3,-1,1,3,5):
   raw=odd*(1<<(frac-q-1));out=Point();assert l.project(C.byref(c),(C.c_int32*3)(raw,raw,raw),C.byref(out))==0
   assert tup(out)==(rne(odd,2),)*3
  for field,badval in [('frac',19),('width',0),('width',2049),('height',-1)]:
   old=getattr(c,field);setattr(c,field,badval);assert l.project(C.byref(c),(C.c_int32*3)(),C.byref(Point()))==-1;setattr(c,field,old)
  c.m[0]=(1<<28)+1;assert l.project(C.byref(c),(C.c_int32*3)(),C.byref(Point()))==-1;c.m[0]=1<<20
  c.offset[0]=M+1;assert l.project(C.byref(c),(C.c_int32*3)(),C.byref(Point()))==-1;c.offset[0]=0
  points=[[r.randint(-(1<<frac)*128,(1<<frac)*128) for _ in range(3)] for _ in range(31)]
  expected=[oracle_project(c,p,q) for p in points]
  for lanes in (1,2,4,8):
   out=(Point*31)();assert l.project_batch(C.byref(c),(C.c_int32*93)(*(v for p in points for v in p)),out,31,lanes)==0
   assert list(map(tup,out))==expected
  bad=(C.c_int32*3)(128*(1<<frac)+1,0,0);assert l.project(C.byref(c),bad,C.byref(Point()))==-1
 for i in range(800):
  t=[tuple(r.randint(-M,M) for _ in range(3)) for j in range(3)]
  ps=[(r.randint(-M,M),r.randint(-M,M)) for _ in range(17)]
  check_samples(l,t,ps);count+=len(ps)
 # Shared diagonal has exactly one owner, negative/offscreen, near-degenerate and ties.
 for shift in (-5,0,3):
  t=[(shift,shift,0),(shift+8,shift,0),(shift+8,shift+8,0)];u=[t[0],t[2],(shift,shift+8,0)]
  for d in range(1,8):assert sum(check_samples(l,v,[(shift+d,shift+d)])[0][0] for v in (t,u))==1
 fixtures=[([(0,0,0),(8,0,0),(0,8,0)],[(0,0),(4,0),(0,4),(4,4),(1,1),(2,2)]), ([(0,0,0),(1,0,0),(0,1,0)],[(0,0),(1,0),(0,1)]), ([(0,0,0),(1,1,0),(2,2,0)],[(1,1)]), ([(-M,-M,0),(M,-M,0),(-M,M,0)],[(0,0),(-1,-1),(-M,-M)]), ([(0,0,0),(3,0,0),(0,3,0)],[(1,1)])]
 for t,ps in fixtures:
  base=check_samples(l,t,ps)
  for perm in itertools.permutations(range(3)):
   got=check_samples(l,[t[k] for k in perm],ps)
   assert all(a[0]==b[0] and (not a[0] or tuple(a[1][k] for k in perm)==b[1]) for a,b in zip(base,got))
 assert l.sample((Point*3)(Point(M+1,0,0),Point(),Point()),0,0,(C.c_int16*3)())==-1
 # Out-of-range sample is rejected even for a degenerate triangle.
 assert l.sample((Point*3)(),M+1,0,(C.c_int16*3)())==-1
 return {'random_oracle_cases':count,'batch_widths':[1,2,4,8],'fixtures':'shared edges, ties, winding/permutations, negative/offscreen, unit-area, degenerate, maximum bound, rejection','passed':True}
def camera(view,frac,q):
 command=json.loads((ROOT/f'fox-v3-indexed-bvh-bounds/actual-on-001/native-{view}-baseline.command.json').read_text())
 v=[float(np.float32(float(x))) for x in command['command'][4:13]]
 f=np.array(v[:3])-v[3:6];f/=math.hypot(math.hypot(f[0],f[1]),f[2]);rx,rz=f[2],-f[0];length=math.hypot(rx,rz)
 if length<1e-6:rx,rz,length=1,0,1
 rx/=length;rz/=length
 basis=np.array([[rx,0,rz],[f[1]*rz,f[2]*rx-f[0]*rz,-f[1]*rx],f],dtype=np.float32).astype(float)
 # native source metres -> legacy world units. Geometry-only identity static transform.
 rows=basis*np.array([v[6]*38,v[6]*38,1])[:,None]
 # Depth is metres, unlike legacy depth units; camera target converts /38 for depth.
 offsets=np.array([v[7],v[8],0])-np.sum(basis*np.array(v[3:6])[None,:],axis=1)*np.array([v[6],v[6],1/38])
 if not np.isfinite(rows).all() or abs(rows).max()>256 or abs(offsets).max()>4096:raise ValueError('camera range')
 c=Camera((C.c_int32*9)(*(round(x*(1<<20)) for x in rows.flat)),(C.c_int32*3)(*(round(x*(1<<q)) for x in offsets)),frac,240,135)
 return c,rows,offsets,command

def coverage_array(t,pts):
 area=edge(*t)
 if area==0:return np.zeros(len(pts),dtype=bool)
 if area<0:t=t[[0,2,1]]
 result=np.ones(len(pts),dtype=bool)
 for a,b in zip(t,np.roll(t,-1,axis=0)):
  e=(b[0]-a[0])*(pts[:,1]-a[1])-(b[1]-a[1])*(pts[:,0]-a[0])
  result &= (e>0)|((e==0)&incl(a,b))
 return result

def actual():
 source=ROOT/'ayatsuri-fixed-pipeline-20261105/source-adapter/private-fixed-source.json'
 data=json.loads(source.read_text());sourcehash=sha(source)
 assert sourcehash=='81a174a5237d17863d60baff9463c411309f57e3e2cee236254cf6a74c22063b'
 spec=importlib.util.spec_from_file_location('converter',ROOT/'ayatsuri-fixed-pipeline-20261105/converter/compile_fixed.py');conv=importlib.util.module_from_spec(spec);spec.loader.exec_module(conv)
 identities={'source':sourcehash};results=[];allproj={}
 for frac in (16,20):
  path=ROOT/f'ayatsuri-fixed-pipeline-20261105/converter/results/private/from-glb-q{frac}.ayfq';meta=json.loads(path.with_suffix('.ayfq.json').read_text())
  assert sha(path)==meta['output_sha256'] and sourcehash==meta['source_sha256'];identities[path.name]=sha(path)
  decoded=conv.decode(path.read_bytes());assert len(decoded['parts'])==len(data['parts'])==54
  for q in (8,10):
   l=lib(q)
   for view in ('front','oblique'):
    c,rows,offsets,command=camera(view,frac,q)
    model=pathlib.Path(command['command'][1]);binary=pathlib.Path(command['command'][0]);assert sha(model)==command['runtimeInputs'][str(model)];assert sha(binary)==command['binarySHA256']
    identities['legacy_model']=sha(model);identities['legacy_binary']=sha(binary)
    maxerr=0;source_only=0;coefficient_only=0;dot_rounding_only=0;sumerr=0;components=0;compared=diff=degenerate=reference_degenerate=0;covered_ref=covered_int=0;maxweight=0;max_integer_weight_quantization=0;maxpos=0;partproj=[]
    for part,src in zip(decoded['parts'],data['parts']):
     assert part['triangles']==src['triangles']
     assert part['positions']==[[round(x*(1<<frac)) for x in p] for p in src['positions']]
     p=part['positions'];maxpos=max(maxpos,max(abs(x) for row in p for x in row));n=len(p);arr=(C.c_int32*(3*n))(*(v for row in p for v in row));outs=[]
     for lanes in (1,2,4,8):
      out=(Point*n)();assert l.project_batch(C.byref(c),arr,out,n,lanes)==0;outs.append(list(map(tup,out)))
     assert all(x==outs[0] for x in outs)
     assert outs[0]==[oracle_project(c,row,q) for row in p]
     proj=np.array(outs[0],dtype=np.int64);partproj.append(proj.tolist());ref=np.array(src['positions'])@rows.T+offsets
     qm=np.array(p,dtype=float)/(1<<frac);cm=np.array(c.m,dtype=float).reshape(3,3)/(1<<20)
     source_only=max(source_only,float(abs((qm-np.array(src['positions']))@rows[:2].T).max()))
     coefficient_only=max(coefficient_only,float(abs(qm@(cm[:2]-rows[:2]).T).max()))
     dot_rounding_only=max(dot_rounding_only,float(abs(proj[:,:2]/(1<<q)-(qm@cm[:2].T+np.array(c.offset[:2])/(1<<q))).max()))
     error=abs(proj[:,:2]/(1<<q)-ref[:,:2]);maxerr=max(maxerr,float(error.max()));sumerr+=float(error.sum());components+=error.size
     for tri in part['triangles']:
      ti=proj[tri,:2];tf=ref[tri,:2];degenerate+=int(edge(*ti)==0);reference_degenerate+=int(edge(*tf)==0)
      # Complete viewport-clipped union bounding box, pixel centers and four quarter samples.
      lo=np.floor(np.minimum(ti.min(axis=0)/(1<<q),tf.min(axis=0))).astype(int);hi=np.ceil(np.maximum(ti.max(axis=0)/(1<<q),tf.max(axis=0))).astype(int)
      lo=np.maximum(lo,[0,0]);hi=np.minimum(hi,[239,134])
      if any(hi<lo):continue
      xx,yy=np.meshgrid(np.arange(lo[0],hi[0]+1),np.arange(lo[1],hi[1]+1));base=np.column_stack([xx.ravel(),yy.ravel()]);pts=np.concatenate([base+off for off in ((.5,.5),(.25,.25),(.75,.25),(.25,.75),(.75,.75))]);ip=(pts*(1<<q)).astype(np.int64)
      a=coverage_array(tf,pts);b=coverage_array(ti,ip);compared+=len(a);diff+=int(np.count_nonzero(a!=b));covered_ref+=int(a.sum());covered_int+=int(b.sum())
      # First covered sample per triangle checks connected integer barycentric output.
      ix=np.flatnonzero(b)
      if len(ix):
       t=[tuple(row) for row in proj[tri]];point=tuple(ip[ix[0]]);expect=check_samples(l,t,[point])[0];assert expect[0]==1 and sum(expect[1])==16384 and min(expect[1])>=0
       e=np.array([edge(tf[(k+1)%3],tf[(k+2)%3],pts[ix[0]]) for k in range(3)])/edge(*tf)
       maxweight=max(maxweight,float(abs(np.array(expect[1])/16384-e).max()))
       exact_integer=[edge(t[(k+1)%3],t[(k+2)%3],point)/edge(*t) for k in range(3)]
       quant_error=max(abs(expect[1][k]/16384-exact_integer[k]) for k in range(3));assert quant_error<1/16384
       max_integer_weight_quantization=max(max_integer_weight_quantization,quant_error)
    allproj[(frac,q,view)]=partproj
    results.append({'position_fraction_bits':frac,'screen_fraction_bits':q,'view':view,'vertices':components//2,'triangles':1564,'max_screen_component_error_pixels':maxerr,'error_components_pixels':{'source_quantization_only':source_only,'coefficient_quantization_only':coefficient_only,'prepared_offset_quantization_only':float(abs(np.array(c.offset[:2])/(1<<q)-offsets[:2]).max()),'dot_subpixel_rounding_only':dot_rounding_only},'mean_screen_component_error_pixels':sumerr/components,'triangle_sample_comparisons':compared,'coverage_decisions_changed':diff,'reference_covered_decisions':covered_ref,'integer_covered_decisions':covered_int,'projected_degenerate_triangles':degenerate,'reference_degenerate_triangles':reference_degenerate,'max_bary_error_first_covered_sample_per_triangle':maxweight,'max_integer_triangle_weight_quantization_error':max_integer_weight_quantization,'max_source_code':maxpos,'camera_coeff_codes':list(c.m),'camera_offset_codes':list(c.offset)})
 return {'identities':identities,'experiments':results,'reference':'Binary64 geometry-only projection of unquantized native-metre source using binary32 stored camera basis, legacy scale 38 absorbed in pixel rows; NOT legacy renderer coverage or final image comparison.'}
if __name__=='__main__':
 result={'synthetic':{str(q):synthetic(q) for q in (8,10)},'actual':actual()}
 (HERE/'results.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
