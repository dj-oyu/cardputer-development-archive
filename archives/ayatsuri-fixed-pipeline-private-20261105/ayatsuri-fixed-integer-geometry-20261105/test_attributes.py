import ctypes as C, json,math,pathlib,random,sys
H=pathlib.Path(__file__).resolve().parent
class Pixel(C.Structure):_fields_=[('p',C.c_int32*3),('normal',C.c_int16*3),('rho',C.c_uint16*3),('visible',C.c_uint16*3)]
class Vertex(C.Structure):_fields_=[('p',C.c_int32*3),('depth',C.c_int32),('normal',C.c_int16*3),('rho',C.c_int16*3)]
class Hit(C.Structure):_fields_=[('pixel',Pixel),('native',C.c_int32*3),('depth',C.c_int32)]
def rn(n,d):
 s=-1 if n<0 else 1;q,r=divmod(abs(n),d);return s*(q+(2*r>d or (2*r==d and q%2)))
def oracle(v,w,f,back,visible):
 acc=[sum(x.p[k]*a for x,a in zip(v,w)) for k in range(3)]
 if any(abs(x)>8*(1<<f)*16384 for x in acc):return 2,None
 nat=[rn(x,16384) for x in acc];p=[rn(x,1<<(f-2)) for x in acc];p=[p[0],-p[2],-p[1]]
 n=[rn(sum(x.normal[k]*a for x,a in zip(v,w)),16384) for k in range(3)];n=[n[0],-n[2],-n[1]];n=[(-1 if back else 1)*x for x in n]
 sq=sum(x*x for x in n)
 if sq<512**2:return 3,None
 norm=math.isqrt(sq<<16);n=[rn(x*8388352,norm) for x in n]
 rho=[rn(sum(x.rho[k]*a for x,a in zip(v,w)),16384) for k in range(3)]
 depth=rn(sum(x.depth*a for x,a in zip(v,w)),16384)
 return 0,(p,n,rho,list(visible),nat,depth)
def vals(h):return (list(h.pixel.p),list(h.pixel.normal),list(h.pixel.rho),list(h.pixel.visible),list(h.native),h.depth)
def run(path):
 l=C.CDLL(str(path));l.ab_prepare.argtypes=[C.POINTER(Vertex),C.POINTER(C.c_int16),C.c_int,C.c_int,C.POINTER(C.c_uint16),C.POINTER(Hit)]
 l.ab_block.argtypes=[C.POINTER(Vertex*3),C.POINTER(C.c_int16*3),C.c_int,C.POINTER(C.c_int),C.POINTER(C.c_uint16*3),C.c_uint,C.POINTER(Hit),C.POINTER(C.c_int)]
 r=random.Random(6732);cases=[];axis=[(32767,0,0),(-32767,0,0),(0,32767,0),(0,-32767,0),(0,0,32767),(0,0,-32767),(18918,18918,18918)]
 def check(v,w,f,b=0,vis=(65535,2,7)):
  va=(Vertex*3)(*v);wa=(C.c_int16*3)(*w);visible=(C.c_uint16*3)(*vis);o=Hit();C.memset(C.byref(o),0x5a,C.sizeof(o));prior=bytes(o)
  status=l.ab_prepare(va,wa,f,b,visible,C.byref(o));exp,ev=oracle(v,w,f,b,vis)
  assert status==exp,(status,exp)
  if status:assert bytes(o)==prior
  else:
   assert vals(o)==ev
   for k in range(3):assert min(x.p[k] for x in v)<=o.native[k]<=max(x.p[k] for x in v)
   assert min(x.depth for x in v)<=o.depth<=max(x.depth for x in v)
  cases.append((va,wa,f,b,visible,status,ev))
 for f in (16,20):
  for _ in range(2500):
   v=[Vertex((C.c_int32*3)(*(r.randint(-8*(1<<f),8*(1<<f)) for k in range(3))),r.randint(-(4096<<10),4096<<10),(C.c_int16*3)(*r.choice(axis)),(C.c_int16*3)(*(r.randrange(32768) for k in range(3)))) for j in range(3)]
   a=r.randint(0,16384);b=r.randint(0,16384-a);check(v,[a,b,16384-a-b],f,r.randrange(2))
  # Endpoints, signed ties, basis, backface and exact pre-round range rejection.
  for val in (-9,-7,-5,-3,-1,0,1,3,5,7,9,8*(1<<f),8*(1<<f)+1):
   v=[Vertex((C.c_int32*3)(val,2,3),val%1001,(C.c_int16*3)(0,32767,0),(C.c_int16*3)(32767,0,1)) for _ in range(3)]
   for w in ([16384,0,0],[0,16384,0],[0,0,16384],[8192,8192,0]):
    check(v,w,f,0);check(v,w,f,1)
  for odd in (-9,-7,-5,-3,-1,1,3,5,7,9):
   v=[Vertex((C.c_int32*3)(x,0,0),x,(C.c_int16*3)(32767,0,0),(C.c_int16*3)(a,0,0)) for x,a in [(odd,1),(0,0),(0,0)]];check(v,[8192,8192,0],f)
  v=[Vertex((C.c_int32*3)(),0,(C.c_int16*3)(*n),(C.c_int16*3)()) for n in [(32767,0,0),(-32767,0,0),(0,32767,0)]];check(v,[8192,8192,0],f)
 # Q20 raw accumulator rounds directly to lightQ16, avoiding double rounding.
 v=[Vertex((C.c_int32*3)(x,0,0),0,(C.c_int16*3)(32767,0,0),(C.c_int16*3)()) for x in (8,9,0)]
 check(v,[14745,1639,0],20)
 assert cases[-1][-1][0][0]==1 and cases[-1][-1][4][0]==8
 # Compare independent block widths against scalar/oracle, with failures mixed in.
 for f in (16,20):
  selected=[x for x in cases if x[2]==f];selected=selected[-16:]+selected[:144]
  for n in (1,2,4,8):
   for offset in range(0,160,n):
    rows=selected[offset:offset+n];va=(Vertex*3*n)(*(x[0] for x in rows));wa=(C.c_int16*3*n)(*(x[1] for x in rows));ba=(C.c_int*n)(*(x[3] for x in rows));vis=(C.c_uint16*3*n)(*(x[4] for x in rows));out=(Hit*n)();st=(C.c_int*n)()
    assert l.ab_block(va,wa,f,ba,vis,n,out,st)
    for i,x in enumerate(rows):assert st[i]==x[5] and (st[i]!=0 or vals(out[i])==x[6])
 # Invalid source/rho/normal/weights/flags/frac rejection.
 valid=[Vertex((C.c_int32*3)(),0,(C.c_int16*3)(32767,0,0),(C.c_int16*3)()) for _ in range(3)]
 for mode in range(7):
  va=(Vertex*3)(*valid);w=(C.c_int16*3)(16384,0,0);f=20;b=0
  if mode==0:va[0].p[0]=(128<<20)+1
  if mode==1:va[0].normal[0]=-32768
  if mode==2:va[0].rho[0]=-1
  if mode==3:w[0]=16383
  if mode==4:f=19
  if mode==5:b=2
  if mode==6:va[0].depth=(4096<<10)+1
  out=Hit();C.memset(C.byref(out),0x33,C.sizeof(out));prior=bytes(out)
  assert l.ab_prepare(va,w,f,b,(C.c_uint16*3)(),C.byref(out))==1 and bytes(out)==prior
 return {'cases':len(cases),'widths':[1,2,4,8],'oracle':'Python arbitrary integer + math.isqrt','passed':True}
if __name__=='__main__':print(json.dumps(run(H/(sys.argv[1] if len(sys.argv)>1 else 'attribute_bridge.so')),indent=2))
