import ctypes as C,json,pathlib,hashlib,collections
P=pathlib.Path(__file__).resolve().parent;source=P.parent/'kernel-chain-prototype/fixtures.json';data=json.loads(source.read_text());states=list(data['states'])
for n,d in [(1,1000),(5,1000),(1,100),(15,1000),(19,1000)]:
 q=list(states[0]['q24']);q[0]=round(n*(1<<24)/d);states.append(dict(name=f'blink_both_{n}_over_{d}',q24=q))
def rne(n,d):
 sign=-1 if n<0 else 1;q,r=divmod(abs(n),d);return sign*(q+(2*r>d or (2*r==d and q%2)))
i32=C.c_int32;i64=C.c_int64
class Frame(C.Structure):_fields_=[('values',i64*23),('params',i32*3),('side',C.c_int),('tag',C.c_uint)]
class Mat(C.Structure):_fields_=[('color',i64*3),('mix',i64),('transparent',i64),('params',i64*3)]
def c(v):return '{'+','.join(c(x) if isinstance(x,list) else str(x) for x in v)+'}'
summary=[]
for bits in (16,20,24):
 lib=C.CDLL(str(P.parent/f'material-c-compact/material-q{bits}.so'));groups=[];counts=collections.Counter();stat={}
 for state in states:
  sc=collections.Counter()
  for f in data['fixtures']:
   frame=Frame();assert not lib.mc_prepare((i32*9)(*state['q24']),f['side'],1,C.byref(frame));slots=[]
   for j,b in enumerate(f['bary_q14']):
    q20=[rne(sum(b[i]*f['corners'][i]['local_xyz'][k] for i in range(3)),16384) for k in (0,2)];xz=[rne(x,16) if bits==16 else x if bits==20 else x*16 for x in q20]
    out=Mat();assert not lib.mc_eval(C.byref(frame),(i32*2)(*xz),C.byref(out));assert 0<=out.mix<=1<<bits and out.transparent==(1<<bits)-out.mix
    kind='zero' if out.mix==0 else 'one' if out.mix==1<<bits else 'fractional';counts[kind]+=1;sc[kind]+=1
    # Complete supplied RGB pairs are synthetic test data, not BaseColor/light results.
    opaque=[(1<<24)+j*17, (3<<24)+f['triangle']*13, j*3]
    continued=[(2<<24)+f['part_id']*11, j*5, (4<<24)+j*19]
    slots.append(dict(bary_q14=b,local_xz=xz,weight=out.mix,complement=out.transparent,opaque_q24=opaque,continued_q24=continued))
   groups.append(dict(state=state['name'],object_id=f['object_id'],part_id=f['part_id'],triangle=f['triangle'],side=f['side'],slots=slots))
  stat[state['name']]=dict(sc)
 supplemental=[];suppcounts=collections.Counter()
 for side in (-1,1):
  for n,d in [(0,1),(1,1000),(5,1000),(1,128),(1,100),(15,1000),(19,1000),(1,50),(1,1)]:
   q=list(states[0]['q24']);q[0]=rne(n*(1<<24),d);frame=Frame();assert not lib.mc_prepare((i32*9)(*q),side,1,C.byref(frame))
   q20=[rne(side*285*(1<<20),1000),2<<20];xz=[rne(x,16) if bits==16 else x if bits==20 else x*16 for x in q20];out=Mat();assert not lib.mc_eval(C.byref(frame),(i32*2)(*xz),C.byref(out));assert out.transparent==(1<<bits)-out.mix
   if (n,d)==(1,128):assert out.mix==39*(1<<bits)//64 and out.transparent==25*(1<<bits)//64
   slots=[]
   for j in range(4):
    slots.append(dict(local_xz=xz,weight=out.mix,complement=out.transparent,opaque_q24=[1+(j<<24),3+(2<<24),j*17],continued_q24=[3+(2<<24),j*13,1+(3<<24)]))
    suppcounts['zero' if out.mix==0 else 'one' if out.mix==1<<bits else 'fractional']+=1
   supplemental.append(dict(state=f'supplemental_blink_{n}_over_{d}',controls_q24=q,side=side,coordinate_provenance='Declared synthetic local X=side*0.285,Z=2; NOT source surface geometry or a pixel',slots=slots))
 doc=dict(supplemental_groups=supplemental,supplemental_counts=dict(suppcounts),bits=bits,canonical_fixture_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),states=states,groups=groups,counts=dict(counts),counts_by_state=stat,contract='Caller-supplied complete branch radiances, conditional scalar closure-weight arithmetic only. No branch evaluated by this harness; material supplies weights only.')
 (P/f'fixtures-q{bits}.json').write_text(json.dumps(doc,indent=2)+'\n')
 entries=[[[s['weight'],s['complement'],s['opaque_q24'],s['continued_q24']] for s in g['slots']] for g in groups+supplemental]
 (P/f'fixtures-q{bits}.inc').write_text('static const tc_input source_inputs[]={\n'+',\n'.join(c([x]) for x in entries)+'\n};\n')
 summary.append(dict(bits=bits,groups=len(groups),supplemental_groups=len(supplemental),supplemental_counts=dict(suppcounts),counts=dict(counts),counts_by_state=stat))
(P/'material-weight-results.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(summary,indent=2))
