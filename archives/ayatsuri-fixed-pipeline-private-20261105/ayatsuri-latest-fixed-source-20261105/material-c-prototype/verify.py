import sys
sys.dont_write_bytecode=True
import ast,ctypes,json,math,pathlib,random
P=pathlib.Path(__file__).resolve().parent;OLD=P.parent/'material-prototype';sys.path.insert(0,str(OLD));import model as m
fn=next(n for n in ast.parse((OLD/'run_experiment.py').read_text()).body if isinstance(n,ast.FunctionDef) and n.name=='coordinates');scope={'data':json.loads((P.parent.parent/'fox-cardputer-latest-private/2k-v2-neutral-sidecar.json').read_text()),'math':math};exec(compile(ast.Module(body=[fn],type_ignores=[]),'frozen_coordinates','exec'),scope);coordinates=scope['coordinates']
A=ctypes.c_int32;I=ctypes.c_int64
class Frame(ctypes.Structure):_fields_=[('values',I*256),('params',A*3),('side',ctypes.c_int),('tag',ctypes.c_uint)]
class Out(ctypes.Structure):_fields_=[('color',I*3),('mix',I),('transparent',I),('params',I*3)]
keys=['Blink Both','Blink -X','Blink +X','Gaze X','Gaze Up','Eye Style','Show Highlights','Environment Reflection','Bubble Pressure'];names=['Blink driver','Value','Value.001','Value.002','Value.003','Value.004','Value.005'];states=json.loads((OLD/'control-fixtures.json').read_text());rng=random.Random(416);results=[]
for bits in (16,20,24):
 S=1<<bits;lib=ctypes.CDLL(str(P/f'material-q{bits}.so'));lib.mc_prepare.argtypes=[ctypes.POINTER(A),ctypes.c_int,ctypes.c_int,ctypes.POINTER(Frame)];lib.mc_eval.argtypes=[ctypes.POINTER(Frame),ctypes.POINTER(A),ctypes.POINTER(Out)];lib.mc_block.argtypes=[ctypes.POINTER(Frame),ctypes.POINTER(A),ctypes.c_uint,ctypes.POINTER(Out)];lib.cp_eval.argtypes=[ctypes.POINTER(A),ctypes.c_int,ctypes.c_uint,ctypes.c_int,ctypes.POINTER(A)];total=0;rejected=0;blocks=0
 for p in m.load_programs():
  const={k:m.qvalue(v,S) for k,v in p.constants.items()};table=tuple(m.qvalue(v,S) for v in p.table);rough=round(m.f32(.2199999988079071)*S)
  def make(q):
   u0=(A*8)();assert not lib.cp_eval((A*9)(*q),p.side,bits,1,u0);u=dict(zip(names,list(u0)));vals={}
   for n in p.order:
    if not p.spatial[n]:vals[n]={'Value':u[n]} if p.nodes[n]['type']=='ShaderNodeValue' else p.node(n,vals,const,table,u,S,None)
   f={'S':S,'values':vals,'constants':const,'table':table,'uniforms':u,'params':{'Roughness':rough,'IOR':3*S//2,'Specular IOR Level':u0[7]}}
   cf=Frame();assert not lib.mc_prepare((A*9)(*q),p.side,1,ctypes.byref(cf));return f,cf
  def compare(f,cf,xz):
   global total,rejected
   out=Out();status=lib.mc_eval(ctypes.byref(cf),(A*2)(*xz),ctypes.byref(out))
   try:ref=p.evaluate(f,xz)
   except m.DomainError:
    assert status;rejected+=1;return
   assert status==0,(bits,p.side,xz,status)
   assert list(out.color)==list(ref['color']) and out.mix==ref['mix_factor'] and out.transparent==ref['transparent_weight'] and list(out.params)==list(ref['parameters'].values()),(bits,p.side,xz,list(out.color),ref['color']);total+=1
  for state,c in states:
   f,cf=make([round(c[k]*(1<<24)) for k in keys]);points=[tuple(m.qvalue(m.f32(x),S) for x in q['xz']) for q in coordinates(p,m.uniforms(c,p.side))]
   for xz in points:compare(f,cf,xz)
   for width in (1,2,4,8):
    pts=points[:width];out=(Out*width)();assert not lib.mc_block(ctypes.byref(cf),(A*(width*2))(*sum((list(x) for x in pts),[])),width,out)
    for i,xz in enumerate(pts):one=Out();assert not lib.mc_eval(ctypes.byref(cf),(A*2)(*xz),ctypes.byref(one));assert bytes(one)==bytes(out[i])
    blocks+=1
  corpus_total=total
  for i in range(1500):
   q=[rng.randint(-(1<<24),1<<24) if j in (3,4,8) else rng.randint(0,2<<24) if j==5 else rng.randint(0,1<<24) for j in range(9)];f,cf=make(q)
   points=[(-S,2*S),(-S,16*S//5),(S,2*S),(S,16*S//5)] if i<8 else [(rng.randint(-S,S),rng.randint(2*S,16*S//5))]
   for xz in points:compare(f,cf,xz)
 results.append({'bits':bits,'accepted_exact_outputs':total,'matched_rejections':rejected,'block_equality_groups':blocks,'frozen_corpus_samples':7176,'random_and_domain_samples':total+rejected-7176})
(P/'results.json').write_text(json.dumps(results,indent=2)+'\n');print(json.dumps(results,indent=2))
