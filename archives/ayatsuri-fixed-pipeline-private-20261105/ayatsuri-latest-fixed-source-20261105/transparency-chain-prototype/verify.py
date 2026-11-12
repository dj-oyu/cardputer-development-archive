import ctypes as C,pathlib,json,random,fractions,collections
P=pathlib.Path(__file__).resolve().parent;u32=C.c_uint32;u64=C.c_uint64
class Slot(C.Structure):_fields_=[('w',u32),('tw',u32),('opaque',u64*3),('continued',u64*3)]
class Input(C.Structure):_fields_=[('slot',Slot*4)]
class Final(C.Structure):_fields_=[('hdr19',u32*3),('pixel',C.c_uint16),('high_clamped',C.c_uint8)]
def rne(n,d):
 q,r=divmod(n,d);return q+(2*r>d or (2*r==d and q%2))
M=(1<<40)-1;records=[]
for bits in (16,20,24):
 S=1<<bits;lib=C.CDLL(str(P/f'test-q{bits}.so'));lib.ref_cache.restype=C.c_void_p;lib.ref_free.argtypes=[C.c_void_p];lib.ref_size.restype=C.c_size_t
 lib.tc_mix.argtypes=[C.POINTER(Slot),C.POINTER(u64)];lib.tc_block.argtypes=[C.POINTER(Input),C.c_uint,C.c_void_p,C.POINTER(Final)];lib.private_integer_profile_encode.argtypes=[C.c_void_p,C.POINTER(u32),C.POINTER(C.c_uint16)]
 cache=lib.ref_cache();ref=lib.ref_cache();assert cache and ref;data=json.loads((P/f'fixtures-q{bits}.json').read_text());checks=0;max_mix=fractions.Fraction(0);max_final=fractions.Fraction(0);groups=0
 def mixture(slot):return [rne(slot.w*slot.opaque[k]+slot.tw*slot.continued[k],S) for k in range(3)]
 for group in data['groups']+data['supplemental_groups']:
  inp=Input();rgb=[];exact=[]
  for j,v in enumerate(group['slots']):
   t=inp.slot[j];t.w=v['weight'];t.tw=v['complement'];t.opaque[:]=v['opaque_q24'];t.continued[:]=v['continued_q24'];expected=mixture(t);out=(u64*3)();assert not lib.tc_mix(C.byref(t),out);assert list(out)==expected;rgb.append(expected)
   ex=[fractions.Fraction(t.w*t.opaque[k]+t.tw*t.continued[k],S) for k in range(3)];exact.append(ex)
   max_mix=max(max_mix,*[abs(ex[k]-expected[k]) for k in range(3)])
  hdr=[rne(sum(r[k] for r in rgb),128) for k in range(3)];pixel=C.c_uint16();flag=lib.private_integer_profile_encode(ref,(u32*3)(*hdr),C.byref(pixel))
  max_final=max(max_final,*[abs(fractions.Fraction(hdr[k])-sum(ex[k] for ex in exact)/128) for k in range(3)])
  for width in (1,2,4,8):
   ins=(Input*width)(*[inp for _ in range(width)]);outs=(Final*width)();assert not lib.tc_block(ins,width,cache,outs)
   for o in outs:assert list(o.hdr19)==hdr and o.pixel==pixel.value and o.high_clamped==flag
   ins[-1].slot[3].tw^=1;C.memset(outs,0x73,C.sizeof(outs));saved=bytes(outs);assert lib.tc_block(ins,width,cache,outs)==2 and bytes(outs)==saved;checks+=1
  groups+=1
 for bad in range(4):
  t=Slot(S//2,S//2,(u64*3)(1,2,3),(u64*3)(4,5,6));o=(u64*3)(7,8,9)
  if bad==0:t.w=S+1
  if bad==1:t.tw=S//2+1
  if bad==2:t.opaque[2]=M+1
  if bad==3:t.continued[2]=(1<<64)-1
  assert lib.tc_mix(C.byref(t),o) in (2,3) and list(o)==[7,8,9]
 rng=random.Random(192+bits);wide=0
 for _ in range(20000):
  w=rng.randrange(S+1);a=[rng.randrange(M+1) for _ in range(3)];b=[rng.randrange(M+1) for _ in range(3)];t=Slot(w,S-w,(u64*3)(*a),(u64*3)(*b));out=(u64*3)();assert not lib.tc_mix(C.byref(t),out);assert list(out)==mixture(t);wide+=1
 for w in [0,1,S//4,S//2,S-1,S]:
  t=Slot(w,S-w,(u64*3)(M,M,M),(u64*3)(M,M,M));out=(u64*3)();assert not lib.tc_mix(C.byref(t),out) and list(out)==[M]*3
 # Terms round only once: 0.5*1+0.5*1=1; separately rounding terms would be0.
 t=Slot(S//2,S//2,(u64*3)(1,3,5),(u64*3)(1,0,0));out=(u64*3)();assert not lib.tc_mix(C.byref(t),out) and list(out)==[1,2,2]
 # Weights and supplied branch radiances must stay associated with each slot.
 inp=Input()
 for j in range(4):
  t=inp.slot[j];t.w=0 if j%2==0 else S;t.tw=S-t.w;t.opaque[:]=[3200 if j%2==0 else 0]*3;t.continued[:]=[0 if j%2==0 else 3200]*3
 final=Final();assert not lib.tc_block(C.byref(inp),1,cache,C.byref(final)) and list(final.hdr19)==[0]*3
 assert rne((1600+1600),2*32)==50 # averaging branches and weights first gives wrong Q19=50
 assert max_mix<=fractions.Fraction(1,2) and max_final<=fractions.Fraction(33,64)
 records.append(dict(bits=bits,source_geometry_groups=len(data['groups']),supplemental_synthetic_local_groups=len(data['supplemental_groups']),complete_group_final_matches=groups,width_success_and_last_lane_atomic_checks=checks,random_wide_mix_matches=wide,direct_mix_error_atomic_checks=4,material_weight_counts=data['counts'],supplemental_weight_counts=data['supplemental_counts'],max_fixture_added_mix_error_q24_exact=str(max_mix),max_fixture_added_final_error_q19_exact=str(max_final),theoretical_final_bound_q19='33/64 = 1/2 final RNE + (1/2 Q24)/32',runtime_sizes=[lib.ref_size(i) for i in range(5)],per_slot_order_counterexample='correct HDR19=0; mixing averaged branches with averaged weight yields50',inherited_error='Material/control/source fixed-vs-float differences excluded; no RGB565 or float-source error bound.'))
 lib.ref_free(cache);lib.ref_free(ref)
(P/'results.json').write_text(json.dumps(records,indent=2)+'\n');print(json.dumps(records,indent=2))
