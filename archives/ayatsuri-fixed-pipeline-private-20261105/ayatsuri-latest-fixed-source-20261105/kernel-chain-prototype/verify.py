import ctypes as C,json,pathlib,math,collections,random,fractions
P=pathlib.Path(__file__).resolve().parent;data=json.loads((P/'fixtures.json').read_text())
i32=C.c_int32;i16=C.c_int16;u16=C.c_uint16;u32=C.c_uint32;u64=C.c_uint64;i64=C.c_int64
class Frame(C.Structure):_fields_=[('values',i64*23),('params',i32*3),('side',C.c_int),('tag',C.c_uint)]
class Mat(C.Structure):_fields_=[('color',i64*3),('mix',i64),('transparent',i64),('params',i64*3)]
class Slot(C.Structure):_fields_=[('local',(i32*2)*3),('world',(i32*3)*3),('normal',(i16*3)*3),('bary',u16*3),('visible',u16*3)]
class Input(C.Structure):_fields_=[('slots',Slot*4)]
class Final(C.Structure):_fields_=[('hdr19',u32*3),('pixel',u16),('high_clamped',C.c_uint8)]
class Output(C.Structure):_fields_=[('material',Mat*4),('local',(i32*2)*4),('world',(i32*3)*4),('normal',(i16*3)*4),('rho',(u16*3)*4),('radiance',(u64*3)*4),('final',Final)]
class Light(C.Structure):_fields_=[('center',i32*3),('sample',(i32*3)*16),('normal',i16*3),('power',u32*3)]
class Scene(C.Structure):_fields_=[('light',Light*3),('world',u32*3)]
class Pixel(C.Structure):_fields_=[('p',i32*3),('normal',i16*3),('rho',u16*3),('visible',u16*3)]
def rne(n,d):
 s=-1 if n<0 else 1;q,r=divmod(abs(n),d);return s*(q+(2*r>d or (2*r==d and q%2)))
def interp(c,b):return [rne(sum(c[n][k]*b[n] for n in range(3)),16384) for k in range(len(c[0]))]
def normal(raw):
 sq=sum(x*x for x in raw)
 if sq<512**2:return None
 leng=math.isqrt(sq<<16);n=[rne(x*8388352,leng) for x in raw]
 assert 32762**2<=sum(x*x for x in n)<=32772**2
 return n
def illumination(s,p,n,visible):
 # Independent Python arbitrary-precision implementation, no C light helpers.
 rgb=list(s.world);nr=math.isqrt(sum(x*x for x in n)<<16)
 for l,a in enumerate(s.light):
  nl=math.isqrt(sum(x*x for x in a.normal)<<16);sm=0
  assert abs(sum((a.center[k]-p[k])*a.normal[k] for k in range(3)))>=272722101
  for j,xyz in enumerate(a.sample):
   d=[xyz[k]-p[k] for k in range(3)];rr=sum(x*x for x in d);assert rr>=1<<26
   leng=math.isqrt(rr<<16);wi=[rne(x*4194304,leng) for x in d]
   dr=sum(n[k]*wi[k] for k in range(3));ds=-sum(a.normal[k]*wi[k] for k in range(3))
   if dr<=0 or ds<=0 or not visible[l]&(1<<j):continue
   cr=rne(dr*256,nr);cs=rne(ds*256,nl);iv=rne(1<<56,rr);sm+=rne(cr*cs*iv,1<<28)
  mean=rne(sm,16)
  for k in range(3):rgb[k]+=rne(a.power[k]*mean,1<<16)
 return rgb
scene=Scene();scene.world[:]=[1<<21,1<<22,1<<23]
for l,x in enumerate([0,2,-2]):
 a=scene.light[l];y=4 if l!=1 else -4;a.center[:]=[x<<16,y<<16,3<<16];a.normal[:]=[0,-32767 if y>0 else 32767,0];a.power[:]=[1<<16,2<<16,3<<16]
 for j in range(16):a.sample[j][:]=a.center[:]
records=[];details=[];admissions=[]
for bits in (16,20,24):
 lib=C.CDLL(str(P/f'chain-q{bits}.so'));S=1<<bits
 lib.ref_cache.restype=C.c_void_p;lib.ref_free.argtypes=[C.c_void_p]
 lib.kc_block.argtypes=[C.POINTER(Frame),C.POINTER(Scene),C.POINTER(Input),C.c_uint,C.c_void_p,C.POINTER(Output)]
 lib.private_integer_profile_encode.argtypes=[C.c_void_p,C.POINTER(u32),C.POINTER(u16)]
 lib.ref_size.restype=C.c_size_t
 assert [lib.ref_size(i) for i in range(4)]==[C.sizeof(Frame),C.sizeof(Slot),C.sizeof(Input),C.sizeof(Output)]
 cache=lib.ref_cache();refcache=lib.ref_cache();assert cache and refcache
 lib.kc_rho.argtypes=[i64,C.POINTER(u16)]
 rng=random.Random(901+bits);codes=list(range(S+1)) if bits==16 else [0,1,S//2-1,S//2,S//2+1,S-1,S]+[rng.randrange(S+1) for _ in range(20000)]
 for code in codes:
  o=u16(999);assert not lib.kc_rho(code,C.byref(o));assert o.value==rne(code*32767,S)
 for code in (-2**63,-1,S+1,2**63-1):
  o=u16(999);assert lib.kc_rho(code,C.byref(o))==4 and o.value==999
 counts=collections.Counter();maxerr=fractions.Fraction(0);maxrad=fractions.Fraction(0);group_checks=0
 accepted=[];reject_by_frame={};accept_by_frame={};direct_slots=0
 for state in data['states']:
  for side in (-1,1):
   f=Frame();assert lib.mc_prepare((i32*9)(*state['q24']),side,1,C.byref(f))==0
   for fix in data['fixtures']:
    if fix['side']!=side:continue
    for vi,vis in enumerate(data['visibility']):
     inp=Input();expected=[];status=0;point_statuses=[]
     for j,b in enumerate(fix['bary_q14']):
      sl=inp.slots[j];sl.bary[:]=b;sl.visible[:]=vis
      for n,v in enumerate(fix['corners']):sl.local[n][:]=[v['local_xyz'][0],v['local_xyz'][2]];sl.world[n][:]=v['world_xyz'];sl.normal[n][:]=v['normal_world_s32767']
      loc20=interp(sl.local,b);loc=[rne(x,16) if bits==16 else x if bits==20 else x*16 for x in loc20];world=[rne(x,16) for x in interp(sl.world,b)];norm=normal(interp(sl.normal,b))
      mat=Mat();ms=lib.mc_eval(C.byref(f),(i32*2)(*loc),C.byref(mat))
      point_status=2 if ms else 3 if mat.mix!=S else 4 if any(x<0 or x>S for x in mat.color) else 5 if norm is None else 0
      counts[f'point_status_{point_status}']+=1;point_statuses.append(point_status)
      if point_status:
       if not status:status=point_status
       expected.append(None);continue
      rho=[rne(x*32767,S) for x in mat.color];illum=illumination(scene,world,norm,vis);rad=[rne(illum[k]*rho[k],32767) for k in range(3)]
      for k in range(3):
       er=abs(fractions.Fraction(rho[k],32767)-fractions.Fraction(mat.color[k],S));maxerr=max(maxerr,er)
       maxrad=max(maxrad,abs(fractions.Fraction(illum[k]*rho[k],32767)-fractions.Fraction(illum[k]*mat.color[k],S)))
      expected.append((mat,loc,world,norm,rho,rad))
     if vi==0:admissions.append(dict(bits=bits,state=state['name'],object_id=fix['object_id'],part_id=fix['part_id'],triangle=fix['triangle'],point_statuses=point_statuses,group_status=status))
     out=Output();C.memset(C.byref(out),0x59,C.sizeof(out));saved=bytes(out);got=lib.kc_block(C.byref(f),C.byref(scene),C.byref(inp),1,cache,C.byref(out));assert got==status,(bits,state['name'],fix['triangle'],got,status)
     counts[f'group_status_{got}']+=1
     if got:
      assert bytes(out)==saved;reject_by_frame[bytes(f)]=(bytes(inp),got);continue
     accept_by_frame[bytes(f)]=(bytes(inp),bytes(out))
     for j,(mat,loc,world,norm,rho,rad) in enumerate(expected):
      direct_slots+=int(any(rad[k]>rne(scene.world[k]*rho[k],32767) for k in range(3)))
      assert bytes(out.material[j])==bytes(mat)
      assert list(out.local[j])==loc and list(out.world[j])==world and list(out.normal[j])==norm and list(out.rho[j])==rho and list(out.radiance[j])==rad
      p=Pixel();p.p[:]=world;p.normal[:]=norm;p.rho[:]=rho;p.visible[:]=vis;cr=(u64*3)();assert not lib.ref_light(C.byref(scene),C.byref(p),cr);assert list(cr)==rad
     hdr=[rne(sum(e[5][k] for e in expected),128) for k in range(3)];pixel=u16();flag=lib.private_integer_profile_encode(refcache,(u32*3)(*hdr),C.byref(pixel));assert list(out.final.hdr19)==hdr and out.final.pixel==pixel.value and out.final.high_clamped==flag
     if vi==1:
      for j,e in enumerate(expected):assert e[5]==[rne(scene.world[k]*e[4][k],32767) for k in range(3)]
     if len(accepted)<128:accepted.append((bytes(f),bytes(inp),bytes(out)))
     if len(details)<20:details.append(dict(bits=bits,state=state['name'],part=fix['part_id'],triangle=fix['triangle'],visibility=vi,hdr19=hdr,rgb565=pixel.value))
 # Group atomicity using accepted fixture replicas with same frame. Last-lane invalid input.
 for frameb,ib,ob in accepted:
  f=Frame.from_buffer_copy(frameb)
  for width in (1,2,4,8):
   ins=(Input*width)(*[Input.from_buffer_copy(ib) for _ in range(width)]);outs=(Output*width)();assert not lib.kc_block(C.byref(f),C.byref(scene),ins,width,cache,outs);assert all(bytes(x)==ob for x in outs)
   ins[-1].slots[3].bary[0]=65535;C.memset(outs,0x53,C.sizeof(outs));saved=bytes(outs);assert lib.kc_block(C.byref(f),C.byref(scene),ins,width,cache,outs)==1;assert bytes(outs)==saved;group_checks+=1
 nonopaque_atomic=0
 for fb,(ib,status) in reject_by_frame.items():
  if fb not in accept_by_frame:continue
  good,_=accept_by_frame[fb];f=Frame.from_buffer_copy(fb)
  for w in (1,2,4,8):
   ins=(Input*w)(*[Input.from_buffer_copy(good) for _ in range(w)]);ins[-1]=Input.from_buffer_copy(ib);outs=(Output*w)();C.memset(outs,0x71,C.sizeof(outs));saved=bytes(outs);assert lib.kc_block(C.byref(f),C.byref(scene),ins,w,cache,outs)==status;assert bytes(outs)==saved;nonopaque_atomic+=1
 records.append(dict(bits=bits,rho_code_checks=len(codes)+4,direct_nonzero_slots=direct_slots,nonopaque_atomic_checks=nonopaque_atomic,counts=dict(counts),width_atomic_checks=group_checks,max_added_rho_error_exact=str(maxerr),max_added_rho_error=float(maxerr),max_added_radiance_before_rounding_q24_exact=str(maxrad),sizes=[lib.ref_size(i) for i in range(7)],oracle='arbitrary precision Python integer interpolation, RNE, normalize, light and sum/128; independent staged C material and profile kernels',material_float_difference='Not recomputed: inherited fixed material behavior. Added conversion error measured against exact fixed material color, NOT float/Cycles.'))
 lib.ref_free(cache);lib.ref_free(refcache)
(P/'admissions.json').write_text(json.dumps(admissions,indent=2)+'\n');(P/'results.json').write_text(json.dumps(records,indent=2)+'\n');(P/'examples.json').write_text(json.dumps(details,indent=2)+'\n');print(json.dumps(records,indent=2))
