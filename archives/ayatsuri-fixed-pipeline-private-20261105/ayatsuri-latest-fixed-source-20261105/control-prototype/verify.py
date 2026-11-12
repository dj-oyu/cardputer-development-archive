import sys
sys.dont_write_bytecode=True
import ctypes,json,pathlib,random,math,decimal
P=pathlib.Path(__file__).resolve().parent
sys.path.insert(0,str(P.parent/'material-prototype'))
import model as m
D=decimal.Decimal;decimal.getcontext().prec=70
lib=ctypes.CDLL(str(P/'control.so'));A=ctypes.c_int32
lib.cp_eval.argtypes=[ctypes.POINTER(A),ctypes.c_int,ctypes.c_uint,ctypes.c_int,ctypes.POINTER(A)]
keys=['Blink Both','Blink -X','Blink +X','Gaze X','Gaze Up','Eye Style','Show Highlights','Environment Reflection','Bubble Pressure'];names=['Blink driver','Value','Value.001','Value.002','Value.003','Value.004','Value.005'];C=1<<24
rng=random.Random(113)
cases=[[0,0,0,0,0,0,C,C//2,0]]
for i in range(9):
 for v in ([-C,0,C] if i in (3,4,8) else [0,C//2,C]):
  q=cases[0].copy();q[i]=v;cases.append(q)
for i in range(10000):cases.append([rng.randint(-C,C) if j in (3,4,8) else rng.randint(0,2*C) if j==5 else rng.randint(0,C) for j in range(9)])
def call(q,side,bits,diag=1):
 out=(A*8)(*([-12345]*8));status=lib.cp_eval((A*9)(*q),side,bits,diag,out);return status,list(out)
def exact(q,side):
 v=[D(x)/C for x in q];both,left,right,x,z,style,highlight,refl,p=v
 xp=max(D(0),x);xn=max(D(0),-x)
 cx=(-D('.277144')+D('.026299')*xp-D('.024018')*xn) if side<0 else (D('.277144')+D('.024018')*xp-D('.026299')*xn)
 cz=D('2.540277')+D('.015008')*max(D(0),z)-D('.015285')*max(D(0),-z)
 h=-D('.003268858')*p**4+D('.000369206')*p**3+D('.011176145')*p**2-D('.04670431')*p+D('.944728911')
 return [max(both,left if side<0 else right),cx,cz,style,highlight,p,h,refl]
results=[]
for bits in (16,20,24):
 errors=[[] for _ in range(8)];de=[[] for _ in range(8)];dif=[0]*8
 for q in cases:
  controls=dict(zip(keys,[x/C for x in q]))
  for side in (-1,1):
   status,v=call(q,side,bits);assert status==0
   oracle=m.uniforms(controls,side);ref=[oracle[n] for n in names]+[m.f32(controls['Environment Reflection'])];dr=exact(q,side)
   for k in range(8):
    errors[k].append(abs(v[k]/(1<<bits)-ref[k]));de[k].append(float(abs(D(v[k])/D(1<<bits)-dr[k])));dif[k]+=v[k]!=round(ref[k]*(1<<bits))
 results.append({'bits':bits,'cases':len(cases)*2,'fields':names+['reflection'],'max_error_float32':list(map(max,errors)),'rms_error_float32':[math.sqrt(sum(x*x for x in e)/len(e)) for e in errors],'max_error_decimal':list(map(max,de)),'codes_differ_from_float32_then_quantize':dif})
# Source-style mode only accepts0/1/2; diagnostic fractional mode explicit.
for style in (0,C,2*C):q=cases[0].copy();q[5]=style;assert call(q,-1,24,0)[0]==0
q=cases[0].copy();q[5]=C//2;assert call(q,-1,24,0)==(3,[-12345]*8);assert call(q,-1,24,1)[0]==0
for j in range(9):
 q=cases[0].copy();q[j]=(2*C if j==5 else C)+1;assert call(q,1,24)[1]==[-12345]*8
# Integer-only bridge: source constants/LUT prepared offline; skip Value node quantizer.
bridge=[]
for p in m.load_programs():
 for bits in (16,20,24):
  S=1<<bits;constants={k:m.qvalue(v,S) for k,v in p.constants.items()};table=tuple(m.qvalue(v,S) for v in p.table)
  maxerr=0.;comp=0
  prepared_roughness=round(m.f32(.2199999988079071)*S)
  prepared_points=[(-S//4 if p.side<0 else S//4,5*S//2),(p.side*round(.277144*S),round(2.540277*S))]
  for q in cases[:128]:
   status,v=call(q,p.side,bits);assert not status;u=dict(zip(names,v));values={}
   for n in p.order:
    if not p.spatial[n]:values[n]={'Value':u[n]} if p.nodes[n]['type']=='ShaderNodeValue' else p.node(n,values,constants,table,u,S,None)
   frame={'S':S,'values':values,'constants':constants,'table':table,'uniforms':u,'params':{'Roughness':prepared_roughness,'IOR':3*S//2,'Specular IOR Level':v[7]}}
   # Compare same represented controls/coordinates, changing control preparation only.
   baseline=p.frame(dict(zip(keys,[x/C for x in q])),bits)
   for point in prepared_points:
    got=p.evaluate(frame,point);ref=p.evaluate(baseline,point)
    maxerr=max(maxerr,max(abs(a-b)/S for a,b in zip(got['color'],ref['color'])));comp+=got['mix_factor']!=ref['mix_factor']
  bridge.append({'side':p.side,'bits':bits,'samples':256,'max_rgb_difference_control_preparation_only':maxerr,'mix_disagreement_count':comp})
# Isolate raw-input quantization from formula/coeff rounding using Decimal.
input_errors=[D(0)]*8
for _ in range(2000):
 raw=[rng.uniform(-1,1) if j in (3,4,8) else rng.uniform(0,2) if j==5 else rng.random() for j in range(9)]
 q=[round(x*C) for x in raw]
 # exact() accepts Decimal scaled inputs without binary64 conversion.
 raw_scaled=[D.from_float(x)*C for x in raw]
 for side in (-1,1):
  a,b=exact(q,side),exact(raw_scaled,side)
  input_errors=[max(e,abs(x-y)) for e,x,y in zip(input_errors,a,b)]
(P/'input-quantization.json').write_text(json.dumps({'raw_binary64_tuples':2000,'max_decimal_formula_change_input_only':[float(e) for e in input_errors]},indent=2)+'\n')
(P/'results.json').write_text(json.dumps({'controls':results,'bridge':bridge,'negative_tests':'PASS'},indent=2)+'\n');print(json.dumps({'controls':results,'bridge':bridge,'negative_tests':'PASS'},indent=2))
