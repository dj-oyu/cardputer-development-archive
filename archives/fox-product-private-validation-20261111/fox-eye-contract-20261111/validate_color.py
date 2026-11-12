import json,pathlib,ctypes,subprocess,math,random,struct
R=pathlib.Path(__file__).resolve().parent;data=json.loads((R/'evaluated-contract.json').read_text());f32=lambda a:struct.unpack('f',struct.pack('f',a))[0]
(R/'color_shim.c').write_text('#include "eye_color.h"\nvoid color(int m,float x,float y,float z,const FoxEyeControls*c,float*out){fox_eye_base_color(m,x,y,z,c,out);}\n')
subprocess.run(['cc','-std=c99','-O2','-shared','-fPIC',str(R/'color_shim.c'),'-lm','-o',str(R/'color_shim.so')],check=True)
fields=['Blink Both','Blink -X','Blink +X','Gaze X','Gaze Up','Eye Style','Show Highlights','Environment Reflection','Bubble Pressure'];array=ctypes.c_float*9;rgb=ctypes.c_float*3
c=ctypes.CDLL(str(R/'color_shim.so')).color;c.argtypes=[ctypes.c_int]+[ctypes.c_float]*3+[ctypes.POINTER(ctypes.c_float)]*2

def evaluate(m,point,ctrl):
 ns={n['name']:n for n in m['nodes']};ls={(l[2],l[3]):(l[0],l[1])for l in m['links']};dr={};memo={}
 for d in m['drivers']:
  if 'outputs[0]'not in d['path']:continue
  n=d['path'].split('nodes["')[1].split('"]')[0];env={v['name']:ctrl[json.loads(v['targets'][0]['data_path'][1:-1])]for v in d['variables']}
  dr[n]=f32(eval(d['expression'],{'__builtins__':{},'min':min,'max':max},env))
 def inp(n,i):
  q=ns[n]['inputs'][i];return ev(*ls[n,q['id']])if(n,q['id'])in ls else q['value']
 def ev(n,s):
  if(n,s)in memo:return memo[n,s]
  q=ns[n];ty=q['type']
  if ty=='ShaderNodeTexCoord':v=point
  elif ty=='ShaderNodeSeparateXYZ':v=inp(n,0)[{'X':0,'Y':1,'Z':2}[s]]
  elif ty=='ShaderNodeValue':v=dr.get(n,q['outputs'][0]['value'])
  elif ty=='ShaderNodeMath':
   a=inp(n,0);b=inp(n,1);op=q['operation'];v={'ADD':lambda:a+b,'SUBTRACT':lambda:a-b,'MULTIPLY':lambda:a*b,'DIVIDE':lambda:a/b if b else 0,'MAXIMUM':lambda:max(a,b),'MINIMUM':lambda:min(a,b),'SQRT':lambda:math.sqrt(max(0,a)),'LESS_THAN':lambda:float(a<b),'GREATER_THAN':lambda:float(a>b)}[op]()
   if q['use_clamp']:v=max(0,min(1,v))
  elif ty=='ShaderNodeMixRGB':
   a=inp(n,1);b=inp(n,2);f=max(0,min(1,inp(n,0)));v=[f32(f32(f32(1-f)*aa)+f32(f*bb))for aa,bb in zip(a,b)]
   if q['use_clamp']:v=[max(0,min(1,u))for u in v]
  elif ty=='ShaderNodeValToRGB':
   f=inp(n,0);el=q['color_ramp']['elements'];v=el[-1]['color']
   if f<=el[0]['position']:v=el[0]['color']
   else:
    for a,b in zip(el,el[1:]):
     if f<b['position']:
      t=f32(f32(f-a['position'])/f32(b['position']-a['position']));v=[f32(f32(f32(1-t)*aa)+f32(t*bb))for aa,bb in zip(a['color'],b['color'])];break
  else:raise ValueError(ty)
  if isinstance(v,(float,int)):v=f32(v)
  memo[n,s]=v;return v
 return inp('Principled BSDF',0)[:3]
rng=random.Random(941);worst=0;count=0;samples=[]
for fixture in data['fixtures']:
 controls=fixture['controls'];cc=array(*(controls[k]for k in fields))
 for mi,m in enumerate(data['materials']):
  for j in range(100):
   p=[f32(rng.uniform(-.6,.6)),f32(-.8),f32(rng.uniform(2.2,2.9))];expected=evaluate(m,p,controls);out=rgb();c(mi,*p,cc,out)
   err=max(abs(a-b)for a,b in zip(expected,out));worst=max(err,worst);assert err<2e-5,(fixture['name'],mi,p,expected,list(out),err);count+=1
  p=[-.277144 if mi%2==0 else .277144,-.8,2.540277];out=rgb();c(mi,*p,cc,out);samples.append({'sample':fixture['name'],'material':mi,'point':p,'linear_rgb':list(out)})
(R/'color-validation.json').write_text(json.dumps({'C_vs_independent_graph_checks':count,'max_absolute_error':worst,'scope':'linear Principled Base Color; not lighting/BSDF/render equivalence','samples':samples},indent=2));print(count,worst)
