import sys
sys.dont_write_bytecode=True
import ast,ctypes,json,math,pathlib
P=pathlib.Path(__file__).resolve().parent;OLD=P.parent/'material-prototype';sys.path.insert(0,str(OLD))
import model as m
# Reuse only our frozen coordinate-generator function, not module top-level experiments.
source=ast.parse((OLD/'run_experiment.py').read_text());fn=next(n for n in source.body if isinstance(n,ast.FunctionDef) and n.name=='coordinates')
data=json.loads((P.parent.parent/'fox-cardputer-latest-private/2k-v2-neutral-sidecar.json').read_text());scope={'data':data,'math':math};exec(compile(ast.Module(body=[fn],type_ignores=[]),'frozen_coordinates','exec'),scope);coordinates=scope['coordinates']
A=ctypes.c_int32;lib=ctypes.CDLL(str(P/'control.so'));lib.cp_eval.argtypes=[ctypes.POINTER(A),ctypes.c_int,ctypes.c_uint,ctypes.c_int,ctypes.POINTER(A)]
keys=['Blink Both','Blink -X','Blink +X','Gaze X','Gaze Up','Eye Style','Show Highlights','Environment Reflection','Bubble Pressure'];names=['Blink driver','Value','Value.001','Value.002','Value.003','Value.004','Value.005'];states=json.loads((OLD/'control-fixtures.json').read_text());res=[];details=[]
for bits in (16,20,24):
 S=1<<bits;count=0;changed=0;rgb=0.;mix=0.;bykind={}
 for p in m.load_programs():
  const={k:m.qvalue(v,S) for k,v in p.constants.items()};table=tuple(m.qvalue(v,S) for v in p.table);rough=round(m.f32(.2199999988079071)*S)
  for state,controls in states:
   q=[round(controls[k]*(1<<24)) for k in keys];represented=dict(zip(keys,[x/(1<<24) for x in q]));out=(A*8)();assert not lib.cp_eval((A*9)(*q),p.side,bits,1,out);u=dict(zip(names,list(out)));vals={}
   for n in p.order:
    if not p.spatial[n]:vals[n]={'Value':u[n]} if p.nodes[n]['type']=='ShaderNodeValue' else p.node(n,vals,const,table,u,S,None)
   f={'S':S,'values':vals,'constants':const,'table':table,'uniforms':u,'params':{'Roughness':rough,'IOR':3*S//2,'Specular IOR Level':out[7]}}
   baseline=p.frame(represented,bits)
   for point in coordinates(p,m.uniforms(controls,p.side)):
    xz=tuple(m.qvalue(m.f32(x),S) for x in point['xz']);a=p.evaluate(f,xz);b=p.evaluate(baseline,xz);count+=1
    e=max(abs(x-y)/S for x,y in zip(a['color'],b['color']));rgb=max(rgb,e);mix=max(mix,abs(a['mix_factor']-b['mix_factor'])/S)
    diff=[n for n in p.order if p.nodes[n]['type']=='ShaderNodeMath' and p.nodes[n]['properties']['operation'] in ('LESS_THAN','GREATER_THAN') and a['trace'][n]!=b['trace'][n]]
    if diff:changed+=1;bykind[point['kind']]=bykind.get(point['kind'],0)+1;details.append({'bits':bits,'side':p.side,'state':state,'point':point,'changed_nodes':diff,'rgb_error':e})
 res.append({'bits':bits,'samples':count,'max_rgb_control_only_delta':rgb,'max_mix_control_only_delta':mix,'samples_with_predicate_control_only_delta':changed,'by_kind':bykind})
(P/'bridge-boundaries.json').write_text(json.dumps(res,indent=2)+'\n');(P/'bridge-boundary-differences.json').write_text(json.dumps(details,indent=2)+'\n');print(json.dumps(res,indent=2))
