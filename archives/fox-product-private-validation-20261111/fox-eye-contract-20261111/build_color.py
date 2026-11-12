import json,pathlib,ast
R=pathlib.Path(__file__).resolve().parent;data=json.loads((R/'evaluated-contract.json').read_text())
def fl(v):
 s=format(float(v),'.17g');return s+'f'if '.'in s or 'e'in s else s+'.0f'
fields={'Blink Both':'blink_both','Blink -X':'blink_neg','Blink +X':'blink_pos','Gaze X':'gaze_x','Gaze Up':'gaze_up','Eye Style':'eye_style','Show Highlights':'show_highlights','Environment Reflection':'environment_reflection','Bubble Pressure':'bubble_pressure'}
def expr(s,env):
 def cv(a):
  if isinstance(a,ast.Constant):return fl(a.value)
  if isinstance(a,ast.Name):return env[a.id]
  if isinstance(a,ast.UnaryOp):return '('+('-'if isinstance(a.op,ast.USub)else '+')+cv(a.operand)+')'
  if isinstance(a,ast.BinOp):
   if isinstance(a.op,ast.Pow):return 'powf('+cv(a.left)+','+cv(a.right)+')'
   return '('+cv(a.left)+{ast.Add:'+',ast.Sub:'-',ast.Mult:'*',ast.Div:'/'}[type(a.op)]+cv(a.right)+')'
  if isinstance(a,ast.Call):return {'max':'fmaxf','min':'fminf'}[a.func.id]+'('+','.join(cv(t)for t in a.args)+')'
  raise ValueError(ast.dump(a))
 return cv(ast.parse(s,mode='eval').body)
header='''#ifndef FOX_EYE_COLOR_H
#define FOX_EYE_COLOR_H
#include <math.h>
/* Source Principled Base Color only, LINEAR RGB, unlit diagnostic. No BSDF,
 * light transport, roughness, reflection, view transform or alpha baked in.
 * Same material indices and object-local coordinates as eye_alpha.h.
 * finite controls in source UI domain are required (see contract.json).
 */
typedef struct {float blink_both,blink_neg,blink_pos,gaze_x,gaze_up,eye_style,show_highlights,environment_reflection,bubble_pressure;} FoxEyeControls;
static inline FoxEyeControls fox_eye_default_controls(void) {
 FoxEyeControls c={0,0,0,0,0,0,1,0.5f,0};return c;
}
static inline float fec_clamp(float x){return fminf(1.0f,fmaxf(0.0f,x));}
static inline float fec_div(float a,float b){return b!=0.0f?a/b:0.0f;}
'''
meta=[]
for mi,m in enumerate(data['materials']):
 ns={n['name']:n for n in m['nodes']};ls={(l[2],l[3]):(l[0],l[1])for l in m['links']};drivers={}
 for d in m['drivers']:
  if 'outputs[0]'not in d['path']:continue
  name=d['path'].split('nodes["')[1].split('"]')[0]
  env={v['name']:'c->'+fields[json.loads(v['targets'][0]['data_path'][1:-1])]for v in d['variables']};drivers[name]=expr(d['expression'],env)
 lines=[];memo={};used=set()
 def inp(n,i,ch):
  q=ns[n]['inputs'][i];v=q['value'];return emit(*ls[n,q['id']],ch)if(n,q['id'])in ls else fl(v[ch]if isinstance(v,list)else v)
 def emit(n,s,ch):
  typ=ns[n]['type'];key=(n,s,ch if typ in ['ShaderNodeMixRGB','ShaderNodeValToRGB']else 0)
  if key in memo:return memo[key]
  used.add(n);q=ns[n]
  if typ=='ShaderNodeTexCoord':
   assert s=='Object'and q['object']is None
   return ['x','y','z'][ch]
  if typ=='ShaderNodeSeparateXYZ':return inp(n,0,{'X':0,'Y':1,'Z':2}[s])
  if typ=='ShaderNodeValue':ex=drivers.get(n,fl(q['outputs'][0]['value']))
  elif typ=='ShaderNodeMath':
   a=inp(n,0,0);b=inp(n,1,0);op=q['operation']
   ex={'ADD':lambda:f'({a}+{b})','SUBTRACT':lambda:f'({a}-{b})','MULTIPLY':lambda:f'({a}*{b})','DIVIDE':lambda:f'fec_div({a},{b})','MAXIMUM':lambda:f'fmaxf({a},{b})','MINIMUM':lambda:f'fminf({a},{b})','SQRT':lambda:f'sqrtf(fmaxf(0.0f,{a}))','LESS_THAN':lambda:f'({a}<{b}?1.0f:0.0f)','GREATER_THAN':lambda:f'({a}>{b}?1.0f:0.0f)'}[op]()
   if q['use_clamp']:ex=f'fec_clamp({ex})'
  elif typ=='ShaderNodeMixRGB':
   assert q['blend_type']=='MIX';a=inp(n,1,ch);b=inp(n,2,ch);f=inp(n,0,0);ex=f'((1.0f-fec_clamp({f}))*{a}+fec_clamp({f})*{b})'
   if q['use_clamp']:ex=f'fec_clamp({ex})'
  elif typ=='ShaderNodeValToRGB':
   r=q['color_ramp'];assert r['interpolation']=='LINEAR'and r['color_mode']=='RGB';f=inp(n,0,0);el=r['elements'];ex=fl(el[-1]['color'][ch])
   for a,b in reversed(list(zip(el,el[1:]))):
    p=fl(a['position']);p2=fl(b['position']);ca=fl(a['color'][ch]);cb=fl(b['color'][ch]);t=f'(({f}-{p})/({p2}-{p}))';seg=f'((1.0f-{t})*{ca}+{t}*{cb})';ex=f'({f}<{p2}?{seg}:{ex})'
   ex=f'({f}<={fl(el[0]["position"])}?{fl(el[0]["color"][ch])}:{ex})'
  else:raise ValueError((typ,n,s))
  var='v'+str(len(memo));memo[key]=var;lines.append(f' float {var}={ex}; /* {n} {s} channel {ch} */');return var
 colors=[inp('Principled BSDF',0,ch)for ch in range(3)]
 header+=f'static inline void fec_material_{mi}(float x,float y,float z,const FoxEyeControls *c,float out[3]) {{\n'+'\n'.join(lines)+'\n'+''.join(f' out[{ch}]={v};'for ch,v in enumerate(colors))+'\n}\n'
 meta.append({'material':m['name'],'base_color_dependencies':sorted(used),'unsupported_nodes':[],'used_drivers':[d for d in m['drivers']if any('nodes["'+u+'"]'in d['path']for u in used)]})
header+='static inline void fox_eye_base_color(int material,float x,float y,float z,const FoxEyeControls *c,float out[3]) {\n switch(material){\n'+''.join(f' case {i}:fec_material_{i}(x,y,z,c,out);return;\n'for i in range(6))+' default:out[0]=out[1]=out[2]=0.0f;return;\n }\n}\n#endif\n'
(R/'eye_color.h').write_text(header);(R/'color-ir.json').write_text(json.dumps(meta,indent=2,ensure_ascii=False));print('Generated',len(header),'bytes')
