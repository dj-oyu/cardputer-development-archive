from pathlib import Path
import ctypes as C,random,json,math,hashlib
from fractions import Fraction
D=Path(__file__).parent;lib=C.CDLL(str((D/'predicates.so').resolve()));I32=C.c_int32;U64=C.c_uint64
lib.qtriangle.argtypes=[C.POINTER(I32),C.c_int,C.POINTER(U64)];lib.qbox.argtypes=[C.POINTER(I32),C.c_int];lib.reference_segment.argtypes=[C.POINTER(I32),C.c_int];lib.qratio_compare.argtypes=[U64]*8
rng=random.Random(20261105)
def triple(a,b,c):return a[0]*(b[1]*c[2]-b[2]*c[1])+a[1]*(b[2]*c[0]-b[0]*c[2])+a[2]*(b[0]*c[1]-b[1]*c[0])
def sub(a,b):return [x-y for x,y in zip(a,b)]
def oracle(x,f):
 a,b,c,o,end=[x[k:k+3] for k in range(0,15,3)];e1=sub(b,a);e2=sub(c,a);d=sub(end,o);t=sub(o,a);l2=sum(v*v for v in d);S=1<<f
 if l2*100000**2<=4*S*S:return 3
 det=triple(e1,d,e2);u=triple(t,d,e2);v=triple(d,t,e1);num=triple(e2,t,e1)
 if det<0:det,u,v,num=-det,-u,-v,-num
 if not det or u<0 or v<0 or u+v>det or num<=0 or num>=det:return 0
 near=min(num,det-num)
 return int(near*near*l2*100000**2>det*det*S*S)
def boxoracle(x):
 lo,hi,o,end=[x[k:k+3] for k in range(0,12,3)];a,b=Fraction(0),Fraction(1)
 for k in range(3):
  d=end[k]-o[k]
  if not d:
   if not lo[k]<=o[k]<=hi[k]:return 0
  else:
   u,v=sorted([Fraction(lo[k]-o[k],d),Fraction(hi[k]-o[k],d)]);a=max(a,u);b=min(b,v)
   if a>b:return 0
 return 1
stats={'triangleRandom':{},'sharedEdges':{},'boxCases':10000,'ratioCases':10000,'crafted':[]};mismatches=[];calls=0
for f in [16,20]:
 B=8*(1<<f);r={'cases':20000,'hit':0,'intervalUnresolved':0,'domainOrShort':0,'floatDisagreements':0,'hitDeterminantsFit64':0}
 for i in range(20000):
  x=[rng.randint(-B,B) for _ in range(15)];out=(U64*5)();arr=(I32*15)(*x);v=lib.qtriangle(arr,f,out);want=oracle(x,f);ref=lib.reference_segment(arr,f);calls+=1
  if v==2:r['intervalUnresolved']+=1
  elif v==3:r['domainOrShort']+=1
  else:assert v==want,(f,x,v,want)
  if v==1:r['hit']+=1;r['hitDeterminantsFit64']+=out[4]
  if v in [0,1] and ref!=v:r['floatDisagreements']+=1;mismatches.append({'f':f,'input':x,'integer':v,'float':ref})
 stats['triangleRandom'][f]=r
 # Integer-grid parallelogram with exact shared diagonal and crossing at t=1/2.
 sh={'pairs':1000,'integerBothHit':0,'floatBothHit':0,'floatNeitherHit':0}
 for i in range(1000):
  S=1<<f;u=[rng.randint(-S,S) for _ in range(3)];v=[rng.randint(-S,S) for _ in range(3)];a=[-u[k]-v[k] for k in range(3)];b=[u[k]-v[k] for k in range(3)];c=[u[k]+v[k] for k in range(3)];e=[-u[k]+v[k] for k in range(3)];o=[rng.randint(-S,S) for _ in range(3)];end=[-z for z in o];ans=[];refs=[]
  for tri in [[a,b,c],[a,c,e]]:
   x=sum(tri,[])+o+end;ar=(I32*15)(*x);out=(U64*5)();ans.append(lib.qtriangle(ar,f,out));refs.append(lib.reference_segment(ar,f));calls+=1
  assert ans==[1,1],(f,ans);sh['integerBothHit']+=1;sh['floatBothHit']+=refs==[1,1];sh['floatNeitherHit']+=refs==[0,0]
 stats['sharedEdges'][f]=sh
for i in range(10000):
 f=16 if i%2 else 20;B=8*(1<<f);p=[rng.randint(-B,B) for _ in range(6)];lo=[min(p[k],p[k+3]) for k in range(3)];hi=[max(p[k],p[k+3]) for k in range(3)];x=lo+hi+[rng.randint(-B,B) for _ in range(6)];assert lib.qbox((I32*12)(*x),f)==boxoracle(x);calls+=1
for i in range(10000):
 a,b,c,d=[rng.randrange(1,1<<76) for _ in range(4)];split=lambda x:[x>>64,x&((1<<64)-1)];v=lib.qratio_compare(*(split(a)+split(b)+split(c)+split(d)));assert v==((a*d>c*b)-(a*d<c*b));calls+=1
# Endpoint interval stress, equal-distance comparison, explicit domain rejection.
for f,dx,dz in [(20,20,2),(20,21,2),(16,2,2)]:
 x=[-100,-100,0,100,-100,0,0,100,0,0,0,-1,dx,0,dz-1];ar=(I32*15)(*x);o=(U64*5)();s=lib.qtriangle(ar,f,o);stats['crafted'].append({'f':f,'dx':dx,'dz':dz,'status':s,'exact':oracle(x,f)});calls+=1
 if s in [0,1]:assert s==oracle(x,f)
assert lib.qratio_compare(0,1,0,3,0,2,0,6)==0;calls+=1
out=(U64*5)();assert lib.qtriangle((I32*15)(*([9*(1<<20)]+[0]*14)),20,out)==3;calls+=1
stats['totalPredicateOracleCases']=calls;assert calls<=100000
stats['disagreementExamples']=mismatches[:5]
# Existing permitted preflight geometry range, without additional ray queries.
import struct
p=Path('/workspace/scratch/6d8dcdbcdc54/ayatsuri-fixed-render-20261105/preflight/baseline-front.world-vertices.f64le');xyz=list(struct.iter_unpack('<ddd',p.read_bytes()));stats['actualGeometryDomain']={'characterMaxAbs':max(abs(c) for v in xyz[:1163] for c in v),'groundMaxAbs':max(abs(c) for v in xyz[1163:] for c in v),'wholeSceneOutside8m':sum(any(abs(c)>8 for c in v) for v in xyz)}
with (D/'RESULT.json').open('x') as o:json.dump(stats,o,indent=2);o.write('\n')
print(json.dumps(stats,indent=2))
