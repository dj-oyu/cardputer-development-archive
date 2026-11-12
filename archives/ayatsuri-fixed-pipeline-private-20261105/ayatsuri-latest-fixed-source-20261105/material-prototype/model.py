"""Bounded pure-data material arithmetic. No Blender, eval, shader or query API."""
import json, math, pathlib, re, struct
ROOT=pathlib.Path(__file__).resolve().parent
I64MIN=-(1<<63); I64MAX=(1<<63)-1
CHECK_STATS={"max_checked_abs":0,"max_product_abs":0,"max_code_abs":0}
def reset_stats():
 for k in CHECK_STATS:CHECK_STATS[k]=0
def mul(a,b):
 v=a*b;CHECK_STATS["max_product_abs"]=max(CHECK_STATS["max_product_abs"],abs(v));return check(v)
class DomainError(ValueError):pass
def check(x):
 CHECK_STATS['max_checked_abs']=max(CHECK_STATS['max_checked_abs'],abs(x))
 if not I64MIN<=x<=I64MAX:raise DomainError('int64_overflow')
 return x
def f32(x):
 try:y=struct.unpack('<f',struct.pack('<f',x))[0]
 except OverflowError:raise DomainError('float32_overflow')
 if not math.isfinite(y):raise DomainError('nonfinite_float32')
 return y
def rnd(n,d):
 if d<=0:raise DomainError('nonpositive_divisor')
 sign=-1 if n<0 else 1;q,r=divmod(abs(n),d);return sign*(q+(r>d-r or (r==d-r and q%2!=0)))
def fixed_div(a,b,S,source_nonzero=True):
 if not b:
  if source_nonzero:raise DomainError('nonzero_quantized_zero_denominator')
  return 0
 return check(rnd(check(mul(a,S)*(1 if b>0 else -1)),abs(b)))
def fsqrt(a,S):
 v=mul(max(a,0),S);q=math.isqrt(v)
 # Exact nearest integer sqrt; a square-root half tie cannot occur for integer v.
 if v-q*q>q:q+=1
 return check(q)
def qvalue(x,S):
 if isinstance(x,(list,tuple)):return tuple(qvalue(v,S) for v in x[:3])
 return check(round(float(x)*S))
def ffvalue(x):
 if isinstance(x,(list,tuple)):return tuple(f32(v) for v in x[:3])
 return f32(x)
BASE_CONTROLS={'Blink Both':0.,'Blink -X':0.,'Blink +X':0.,'Gaze X':0.,'Gaze Up':0.,'Eye Style':0.,'Show Highlights':1.,'Environment Reflection':.5,'Bubble Pressure':0.}
def uniforms(controls,side):
 """Explicit declarative formulas, NOT evaluation of stored driver strings.
    Control preparation is high precision; final Value socket is binary32.
 """
 if set(controls)!=set(BASE_CONTROLS):raise DomainError('control_keys')
 for k,x in controls.items():
  if type(x) not in (int,float) or not math.isfinite(x):raise DomainError('invalid_control')
  lo=-1 if k in ('Gaze X','Gaze Up','Bubble Pressure') else 0
  hi=2 if k=='Eye Style' else 1
  if not lo<=x<=hi:raise DomainError('control_range:'+k)
 a,b,p=controls['Gaze X'],controls['Gaze Up'],controls['Bubble Pressure']
 # Intentionally separate raw p polynomial from clamped p input.
 pc=max(-1.,min(1.,p))
 if side<0:cx=-.277144+.026299*max(0.,a)-.024018*max(0.,-a)
 else:cx=.277144+.024018*max(0.,a)-.026299*max(0.,-a)
 cz=2.540277+.015008*max(0.,b)-.015285*max(0.,-b)
 poly=-.003268858*p**4+.000369206*p**3+.011176145*p**2-.04670431*p+.944728911
 return {k:f32(v) for k,v in {'Blink driver':max(controls['Blink Both'],controls['Blink -X' if side<0 else 'Blink +X']),'Value':cx,'Value.001':cz,'Value.002':controls['Eye Style'],'Value.003':controls['Show Highlights'],'Value.004':pc,'Value.005':poly}.items()}
def prepare_ramp(elements):
 """Pinned Blender4.3.2 LINEAR/RGB preparation:257 samples i/256.
    Reverse-oriented fac and operation order copied declaratively from source.
 """
 table=[]
 for i in range(257):
  x=f32(f32(i)/f32(256));right=next((j for j,e in enumerate(elements) if f32(e['position'])>x),len(elements))
  if x<=f32(elements[0]['position']):color=elements[0]['color'][:3]
  elif right==len(elements):color=elements[-1]['color'][:3]
  else:
   a,b=elements[right],elements[right-1];fac=f32(f32(x-f32(a['position']))/f32(f32(b['position'])-f32(a['position'])));mf=f32(1-fac)
   color=[f32(f32(mf*f32(a['color'][k]))+f32(fac*f32(b['color'][k]))) for k in range(3)]
  table.append(tuple(f32(v) for v in color))
 return tuple(table)
class Program:
 def __init__(self,material,supplement):
  self.material=material['name'];self.side=-1 if self.material.endswith('-1') else 1
  t=material['node_tree'];self.nodes={n['name']:n for n in t['nodes']};self.links={(l['to'],l['to_socket']):(l['from'],l['from_socket']) for l in t['links']}
  self.roots=('Mix (Legacy).002','Math.019');self.order=[];seen=set();active=set()
  def visit(name):
   if name in active:raise DomainError('cycle')
   if name in seen:return
   active.add(name)
   for inp in self.nodes[name]['inputs']:
    if (name,inp['identifier']) in self.links:visit(self.links[name,inp['identifier']][0])
   active.remove(name);seen.add(name);self.order.append(name)
  for name in self.roots:visit(name)
  self.spatial={}
  for name in self.order:self.spatial[name]=self.nodes[name]['type']=='ShaderNodeTexCoord' or any(self.spatial[self.links[name,i['identifier']][0]] for i in self.nodes[name]['inputs'] if (name,i['identifier']) in self.links)
  self.table=prepare_ramp(supplement['elements'])
  self.constants={(name,i['identifier']):ffvalue(i['default']) for name in self.order for i in self.nodes[name]['inputs'] if (name,i['identifier']) not in self.links and i['default'] is not None}
  self.driver_data=t['animation']['drivers'] # source/provenance only; never eval.
  expected={
   'nodes["Blink driver"].outputs[0].default_value':('max(a,b)',{'a':'Blink Both','b':'Blink -X' if self.side<0 else 'Blink +X'}),
   'nodes["Value"].outputs[0].default_value':('-0.277144+(0.026299)*max(0,a)+(-0.024018)*max(0,-a)' if self.side<0 else '0.277144+(0.024018)*max(0,a)+(-0.026299)*max(0,-a)',{'a':'Gaze X'}),
   'nodes["Value.001"].outputs[0].default_value':('2.540277+0.015008*max(0,b)-0.015285*max(0,-b)',{'b':'Gaze Up'}),
   'nodes["Value.002"].outputs[0].default_value':('a',{'a':'Eye Style'}),
   'nodes["Value.003"].outputs[0].default_value':('a',{'a':'Show Highlights'}),
   'nodes["Principled BSDF"].inputs[13].default_value':('a',{'a':'Environment Reflection'}),
   'nodes["Value.004"].outputs[0].default_value':('max(-1,min(1,p))',{'p':'Bubble Pressure'}),
   'nodes["Value.005"].outputs[0].default_value':('-0.003268858*p**4+0.000369206*p**3+0.011176145*p**2-0.04670431*p+0.944728911',{'p':'Bubble Pressure'})}
  assert len(self.driver_data)==len(expected)
  for d in self.driver_data:
   expression,bindings=expected[d['data_path']];assert d['expression']==expression
   found={}
   for v in d['variables']:
    assert v['type']=='SINGLE_PROP' and len(v['targets'])==1
    target=v['targets'][0];assert target['id']['id']=='Expression Controls'
    found[v['name']]=json.loads(target['data_path'])[0]
   assert found==bindings

  assert sum(self.nodes[n]['type']=='ShaderNodeMath' and self.spatial[n] for n in self.order)==77
 def frame(self,controls,bits=None):
  u=uniforms(controls,self.side);S=(1<<bits) if bits else None
  constants={k:qvalue(v,S) for k,v in self.constants.items()} if S else self.constants
  table=tuple(qvalue(v,S) for v in self.table) if S else self.table
  values={}
  for name in self.order:
   if not self.spatial[name]:values[name]=self.node(name,values,constants,table,u,S,None)
  params={'Roughness':f32(.2199999988079071),'IOR':f32(1.5),'Specular IOR Level':f32(controls['Environment Reflection'])}
  if S:params={k:qvalue(v,S) for k,v in params.items()}
  return {'S':S,'values':values,'constants':constants,'table':table,'uniforms':u,'params':params}
 def node(self,name,values,constants,table,u,S,xz):
  n=self.nodes[name];kind=n['type'];inp=[]
  for i in n['inputs']:
   key=(name,i['identifier']);link=self.links.get(key)
   inp.append(values[link[0]][link[1]] if link else constants.get(key))
  if kind=='ShaderNodeValue':return {'Value':qvalue(u[name],S) if S else u[name]}
  if kind=='ShaderNodeTexCoord':return {'Object':(xz[0],0,xz[1])}
  if kind=='ShaderNodeSeparateXYZ':return dict(zip(('X','Y','Z'),inp[0]))
  if kind=='ShaderNodeMath':
   a,b=inp[:2];op=n['properties']['operation']
   if S:
    if op=='ADD':v=check(a+b)
    elif op=='SUBTRACT':v=check(a-b)
    elif op=='MULTIPLY':v=check(rnd(mul(a,b),S))
    elif op=='DIVIDE':v=fixed_div(a,b,S,True) # all reachable denominator domains proven nonzero.
    elif op=='SQRT':v=fsqrt(a,S)
    elif op=='MINIMUM':v=min(a,b)
    elif op=='MAXIMUM':v=max(a,b)
    elif op=='LESS_THAN':v=S if a<b else 0
    elif op=='GREATER_THAN':v=S if a>b else 0
    else:raise DomainError('unsupported_math:'+op)
   else:
    if op=='ADD':v=f32(a+b)
    elif op=='SUBTRACT':v=f32(a-b)
    elif op=='MULTIPLY':v=f32(a*b)
    elif op=='DIVIDE':v=f32(a/b) if b!=0 else 0.
    elif op=='SQRT':v=f32(math.sqrt(max(a,0.)))
    elif op=='MINIMUM':v=min(a,b)
    elif op=='MAXIMUM':v=max(a,b)
    elif op=='LESS_THAN':v=float(a<b)
    elif op=='GREATER_THAN':v=float(a>b)
    else:raise DomainError('unsupported_math:'+op)
   return {'Value':v}
  if kind=='ShaderNodeValToRGB':
   fac=inp[0]
   if S:
    f=min(S,max(0,fac))*256;i=min(256,f//S);t=f-i*S;a=table[i]
    out=tuple(check(rnd(check(mul(S-t,a[k])+mul(t,table[i+1][k])),S)) for k in range(3)) if t>0 else a
   else:
    f=f32(min(1.,max(0.,fac))*256);i=min(256,int(f));t=f32(f-f32(i));a=table[i]
    out=tuple(f32(f32(f32(1-t)*a[k])+f32(t*table[i+1][k])) for k in range(3)) if t>0 else a
   return {'Color':out,'Alpha':S if S else 1.}
  if kind=='ShaderNodeMixRGB':
   assert n['properties']=={'blend_type':'MIX','use_clamp':False,'use_alpha':False}
   t,a,b=inp
   if S:
    t=max(0,min(S,t));out=tuple(check(a[k]+rnd(mul(t,b[k]-a[k]),S)) for k in range(3))
   else:
    t=min(1.,max(0.,t));out=tuple(f32(a[k]+f32(t*f32(b[k]-a[k]))) for k in range(3))
   return {'Color':out}
  raise DomainError('unsupported_node:'+kind)
 def evaluate(self,frame,xz):
  S=frame['S']
  if S:
   if any(type(v)!=int for v in xz):raise DomainError('integer_coordinates_required')
  elif any(not math.isfinite(v) for v in xz):raise DomainError('finite_coordinates_required')
  # Explicit specimen domain, not a universal geometric/image guarantee.
  unit=S or 1
  upper=(16*unit)//5 if S else 3.2
  if not -unit<=xz[0]<=unit or not 2*unit<=xz[1]<=upper:raise DomainError('coordinate_domain')
  values=frame['values'].copy()
  for name in self.order:
   if self.spatial[name]:values[name]=self.node(name,values,frame['constants'],frame['table'],frame['uniforms'],S,xz)
  if S:
   codes=[abs(z) for outputs in values.values() for val in outputs.values() for z in (val if isinstance(val,tuple) else (val,))]
   CHECK_STATS['max_code_abs']=max(CHECK_STATS['max_code_abs'],max(codes))
  raw=values['Math.019']['Value'];fac=max(0,min(S or 1.,raw))
  return {'color':values['Mix (Legacy).002']['Color'],'mix_factor':fac,'transparent_weight':(S-fac) if S else f32(1-fac),'parameters':frame['params'],'trace':values}
 def block(self,frame,coordinates):
  if len(coordinates) not in (1,2,4,8):raise DomainError('block_width')
  return [self.evaluate(frame,xz) for xz in coordinates]
def load_programs():
 d=json.loads((ROOT.parent/'inventory.json').read_text());s=json.loads((ROOT.parent/'supplement.json').read_text())
 return [Program(m,next(x for x in s['node_specific'] if x.get('material')==m['name'] and x.get('node')=='Color Ramp')) for m in d['materials'] if 'eye white' in m['name']]
