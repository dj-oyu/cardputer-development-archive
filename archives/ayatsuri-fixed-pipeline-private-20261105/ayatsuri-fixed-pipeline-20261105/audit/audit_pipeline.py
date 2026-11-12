"""Read-only audit of existing static compiler outputs. No converter edits."""
import json, math, struct, hashlib
from pathlib import Path
W=Path('/workspace/scratch/6d8dcdbcdc54')
A=W/'fox-v3-floor-direct-reflection-evaluation/actual-002'
O=Path(__file__).parent
C=json.loads((A/'compiled/model-baseline/compile.json').read_text())
b=(A/'compiled/model-baseline/model.aynm').read_bytes()
sec={}
for i in range(struct.unpack_from('<I',b,12)[0]):
 t,f,o,n,c,s=struct.unpack_from('<HHIIII',b,32+i*20);sec[t]=(o,n,c,s)
parts=C['parts']; ps=[v for p in parts for v in p['positions']];ns=[v for p in parts for v in p['normals']]
f32=lambda x:struct.unpack('<f',struct.pack('<f',x))[0]
vo,_,vc,vs=sec[10]
assert vc==len(ps)
assert all(struct.unpack_from('<3f',b,vo+i*vs)==tuple(f32(x*38) for x in p) for i,p in enumerate(ps))
assert all(struct.unpack_from('<3f',b,vo+i*vs+12)==tuple(f32(x) for x in n) for i,n in enumerate(ns))
def cross(a,b,c):
 u=[b[i]-a[i] for i in range(3)];v=[c[i]-a[i] for i in range(3)];return [u[1]*v[2]-u[2]*v[1],u[2]*v[0]-u[0]*v[2],u[0]*v[1]-u[1]*v[0]]
def quant_stats(frac):
 s=2**frac;mx=0;deg=0;flip=0;maxq=0
 for p in parts:
  q=[[round(x*s) for x in v] for v in p['positions']]
  maxq=max(maxq,max(abs(x) for v in q for x in v))
  mx=max(mx,max(abs(a-b/s) for va,vb in zip(p['positions'],q) for a,b in zip(va,vb)))
  for t in p['triangles']:
   a=cross(*(p['positions'][i] for i in t));z=cross(*(q[i] for i in t))
   deg+=not any(z);flip+=sum(x*y for x,y in zip(a,z))<0
 return dict(fractionalBits=frac,stepMetres=1/s,maxComponentErrorMetres=mx,collapsedTriangles=deg,flippedTriangleNormals=flip,maxAbsInteger=maxq)
def dec(x):return x/12.92 if x<=.04045 else ((x+.055)/1.055)**2.4
colors=[]
for m in C['materialTrace']:
 old=[dec(q/(63 if i==1 else 31)) for i,q in enumerate(m['quantized'])]
 colors.append(dict(id=m['id'],linear=m['scaledLinear'],decoded565=old,maxAbsError=max(abs(x-y) for x,y in zip(old,m['scaledLinear']))))
files=['code/compile.cjs','product/tools/ayatsuri/asset/import_glb.cjs','product/tools/ayatsuri/asset/compile_static.cjs','product/tools/ayatsuri/asset/compact_opaque/batch_static.cjs','product/tools/ayatsuri/model/pack_model.cjs','inputs/geometry-source-sided.glb','compiled/model-baseline/model.aynm','compiled/model-baseline/compile.json']
r=dict(sourceRoot=str(A.relative_to(W)),hashes={p:hashlib.sha256((A/p).read_bytes()).hexdigest() for p in files},wireVersion=struct.unpack_from('<H',b,4)[0],sections={str(t):dict(offset=o,bytes=n,count=c,stride=s) for t,(o,n,c,s) in sec.items()},parts=len(parts),vertices=len(ps),triangles=sum(len(p['triangles']) for p in parts),boundsMetres=[[min(v[k] for v in ps),max(v[k] for v in ps)] for k in range(3)],maxNormalLengthError=max(abs(math.sqrt(sum(x*x for x in n))-1) for n in ns),allPartsDoubleSided=all(p['materialSidedness']=='double' for p in parts),wireMatchesPositionsTimes38AndFloat32Normals=True,positionQuantization=[quant_stats(f) for f in [12,16,20]],albedoQuantization=colors)
(O/'audit-results.json').write_text(json.dumps(r,indent=2)+'\n')
print(json.dumps({k:v for k,v in r.items() if k not in ['hashes','sections','albedoQuantization']},indent=2));print('max linear color error from RGB565:',max(c['maxAbsError'] for c in colors))
