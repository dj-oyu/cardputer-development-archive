import json,pathlib,ctypes,subprocess,random,math,struct,hashlib
R=pathlib.Path(__file__).resolve().parent;x=json.loads((R/'evaluated-contract.json').read_text());ir=json.loads((R/'alpha-ir.json').read_text())
(R/'test_shim.c').write_text('#include "eye_alpha.h"\nfloat probe(int m,float x,float z,float b,float s){return fox_eye_alpha(m,x,z,b,s);}\n')
subprocess.run(['cc','-std=c99','-O2','-shared','-fPIC',str(R/'test_shim.c'),'-lm','-o',str(R/'test_shim.so')],check=True)
c=ctypes.CDLL(str(R/'test_shim.so')).probe;c.argtypes=[ctypes.c_int]+[ctypes.c_float]*4;c.restype=ctypes.c_float
f32=lambda a:struct.unpack('f',struct.pack('f',a))[0]
def graph(m,x,z,b):
 ns={n['name']:n for n in m['alpha_nodes']};ls={(l[2],l[3]):(l[0],l[1])for l in m['alpha_links']};memo={}
 def ev(n,s):
  if (n,s)in memo:return memo[n,s]
  node=ns[n];ty=node['type']
  if ty=='ShaderNodeTexCoord':v=(x,0,z)
  elif ty=='ShaderNodeSeparateXYZ':v=inp(node,0)[{'X':0,'Y':1,'Z':2}[s]]
  elif ty=='ShaderNodeValue':v=b
  elif ty=='ShaderNodeMath':
   a=inp(node,0);d=inp(node,1);op=node['operation']
   v={'ADD':lambda:a+d,'SUBTRACT':lambda:a-d,'MULTIPLY':lambda:a*d,'DIVIDE':lambda:a/d if d else 0,'MAXIMUM':lambda:max(a,d),'MINIMUM':lambda:min(a,d),'SQRT':lambda:math.sqrt(max(0,a)),'LESS_THAN':lambda:float(a<d),'GREATER_THAN':lambda:float(a>d)}[op]()
   if node['use_clamp']:v=max(0,min(1,v))
  else:raise ValueError(ty)
  if isinstance(v,(float,int)):v=f32(v)
  memo[n,s]=v;return v
 def inp(n,i):
  s=n['inputs'][i];k=(n['name'],s['id']);return ev(*ls[k])if k in ls else s['value']
 return ev('Math.019','Value')
rng=random.Random(7421);count=0;worst=0
for i,m in enumerate(ir):
 for b in [0,.005,.01,.019,.02,.25,.5,.98,1]:
  for j in range(1000):
   px=f32(rng.uniform(-.8,.8));pz=f32(rng.uniform(2,3.1));bb=f32(b)
   a=graph(m,px,pz,bb);actual=c(i,px,pz,bb,0);worst=max(worst,abs(a-actual));assert abs(a-actual)<1e-6
   count+=1
 for b in [0,.01,.25,1]:
  assert c(i,float('nan'),2.5,b,0)==0
  assert c(i,float('inf'),2.5,b,0)==0
  assert c(i,m['center_x'],m['center_z'],float('nan'),0)==1
sidecar=json.loads((R.parent/'fixed-recovery/extracted/fox-cardputer-latest-private/2k-v2-neutral-sidecar.json').read_text());old={o['name']:o for o in sidecar['objects']}
checks=[];maxerr=0
for fixture in x['fixtures']:
 for o in fixture['objects']:
  if not o['name'].startswith('Moving eyelid'):continue
  keys=old[o['name']]['shape_keys'];b=o['shape_values']['Blink'];vs=[[a+b*(v-a)for a,v in zip(p,q)]for p,q in zip(keys['Basis'],keys['Blink'])]
  err=max(abs(a-b)for p,q in zip(vs,o['vertices_local'])for a,b in zip(p,q));maxerr=max(maxerr,err)
  assert err<1e-6
  checks.append({'sample':fixture['name'],'object':o['name'],'blink':b,'triangles':len(o['triangles']),'zero_area':len(o['zero_area_triangles']),'max_basis_delta_error':err})
# Verify all direct shape-driver evaluations against Blender's resulting values.
shape_checks=0
for fixture in x['fixtures']:
 obs={o['name']:o for o in fixture['objects']};ctrl=fixture['controls']
 for obj in x['objects']:
  for d in obj['shape_drivers']:
   env={v['name']:ctrl[json.loads(v['targets'][0]['data_path'][1:-1])]for v in d['variables']}
   expected=eval(d['expression'],{'__builtins__':{},'max':max,'min':min},env)
   key=d['path'].split('key_blocks["')[1].split('"]')[0];actual=obs[obj['name']]['shape_values'][key]
   assert abs(expected-actual)<1e-6;shape_checks+=1
result={'source_sha256':x['source_sha256'],'alpha_float32_node_vs_C_checks':count,'alpha_max_error':worst,'direct_shape_driver_checks':shape_checks,'eyelid_basis_delta_max_error':maxerr,'eyelid_samples':checks,'nonfinite_policy_checks':'pass','source_unchanged_sha256':hashlib.sha256((R.parent/'fixed-recovery/extracted/fox-cardputer-latest-private/fox-cardputer-2k-v2.blend').read_bytes()).hexdigest()}
(R/'validation.json').write_text(json.dumps(result,indent=2));print(json.dumps({k:v for k,v in result.items()if k!='eyelid_samples'},indent=2))
