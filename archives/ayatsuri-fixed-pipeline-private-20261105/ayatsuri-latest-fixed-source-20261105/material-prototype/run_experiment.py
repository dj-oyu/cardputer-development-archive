import sys
sys.dont_write_bytecode=True
import json,hashlib,math,pathlib,collections,statistics
from model import *
SIDE=ROOT.parent.parent/'fox-cardputer-latest-private/2k-v2-neutral-sidecar.json'
raw=SIDE.read_bytes();assert hashlib.sha256(raw).hexdigest()=='00a81fbcd19c79c578bbbbd7ab077ee6f63048a106c5594675ff208670d5e85e'
data=json.loads(raw);assert data['source_sha256']=='d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a'
programs=load_programs()
# These are finite declared states, not animation evaluation.
states=[]
for name,changes in [('saved_neutral',{}),('style1',{'Eye Style':1}),('style2_highlights_off',{'Eye Style':2,'Show Highlights':0}),('gaze_pressure_min',{'Gaze X':-1,'Gaze Up':-1,'Bubble Pressure':-1}),('gaze_pressure_max',{'Gaze X':1,'Gaze Up':1,'Bubble Pressure':1}),('blink_just_below_002',{'Blink Both':.019999999}),('blink_002',{'Blink Both':.02}),('blink_half',{'Blink Both':.5}),('blink_hide_threshold',{'Blink Both':.98}),('blink_closed',{'Blink Both':1}),('style_threshold_05',{'Eye Style':.5}),('style_threshold_15',{'Eye Style':1.5})]:
 c=BASE_CONTROLS.copy();c.update(changes);states.append((name,c))
(ROOT/'control-fixtures.json').write_text(json.dumps(states,indent=2)+'\n')
def coordinates(program,uniform):
 obj=next(o for o in data['objects'] if o['name']=='Expressive eye white '+str(program.side));v=obj['vertices_local'];out=[]
 for i,p in enumerate(v):out.append({'kind':'vertex','id':i,'xz':[p[0],p[2]]})
 # Explicit geometric interpolation of known local data; no screen projection/query.
 for i,t in enumerate(obj['triangles']):
  for weights in ((1/3,1/3,1/3),(.125,.375,.5)):
   p=[sum(weights[j]*v[t['vertices'][j]][k] for j in range(3)) for k in (0,2)];out.append({'kind':'triangle_barycentric','id':i,'weights':weights,'xz':p})
 cx,cz=uniform['Value'],uniform['Value.001']
 # Declared local arithmetic points near feature boundaries, not traced hits.
 for label,center,rad,threshold in [('iris',(cx,cz),(.139,.172),.52),('iris_outer',(cx,cz),(.139,.172),.995),('highlight',(cx+.035,cz+.085),(.025,.031),1.),('tiny_highlight',(cx-.036,cz-.052),(.01,.014),1.)]:
  for axis in (0,1):
   for sign in (-1,1):
    for eps in (-2**-16,-2**-20,0.,2**-20,2**-16):
     p=list(center);p[axis]+=sign*rad[axis]*math.sqrt(threshold)+eps;out.append({'kind':'boundary','id':label,'axis':axis,'epsilon_coordinate':eps,'xz':p})
 # Blink ellipse sqrt tips and Z threshold neighborhood at center.
 for sign in (-1,1):
  for eps in (-2**-16,0.,2**-16):out.append({'kind':'sqrt_tip','id':'blink','xz':[program.side*.285+sign*.255+eps,2.55]})
 return out

def margins(program,trace):
 out={}
 for name in program.order:
  n=program.nodes[name]
  if n['type']=='ShaderNodeMath' and n['properties']['operation'] in ('LESS_THAN','GREATER_THAN'):
   vals=[]
   for i in n['inputs'][:2]:
    link=program.links.get((name,i['identifier']));vals.append(trace[link[0]][link[1]] if link else program.constants[name,i['identifier']])
   out[name]=vals[0]-vals[1]
 return out

def comparison_details(program,name,ref,got,S):
 pairs=[]
 for inp in program.nodes[name]['inputs'][:2]:
  key=(name,inp['identifier']);link=program.links.get(key)
  a=ref['trace'][link[0]][link[1]] if link else program.constants[key]
  b=got['trace'][link[0]][link[1]] if link else (qvalue(program.constants[key],S) if S else program.constants[key])
  value=b/S if S else b
  ulp=2**-149 if a==0 else max(2**-149,2**(math.frexp(abs(a))[1]-24))
  pairs.append({'reference_float32':a,'candidate_raw':b,'candidate_real':value,'candidate_minus_reference':value-a,'reference_ulp':ulp,'difference_in_reference_ulps':(value-a)/ulp})
 return {'operation':program.nodes[name]['properties']['operation'],'operands':pairs,'reference_signed_margin':pairs[0]['reference_float32']-pairs[1]['reference_float32'],'candidate_signed_margin':pairs[0]['candidate_real']-pairs[1]['candidate_real']}

def stats(a):
 if not a:return None
 s=sorted(a);n=len(a);return {'count':n,'max':s[-1],'rms':math.sqrt(sum(x*x for x in a)/n),'p50':s[n//2],'p95':s[min(n-1,n*95//100)],'p99':s[min(n-1,n*99//100)]}
summary=[];allpoints=0;blocks=0
rawlog=(ROOT/'threshold-disagreements.jsonl').open('w');worst=[]
for series in ('coordinate_only_float32','all_math_fixed'):
 for bits in (16,20,24):
  S=1<<bits;reset_stats();errors=[];facerrors=[];paramerrors=[];kinderrors=collections.defaultdict(list);kindfac=collections.defaultdict(list);changed=0;cmpchanged=0;rejected=collections.Counter();bykind=collections.Counter();maxcase=None
  for program in programs:
   for state,c in states:
    ff=program.frame(c);qf=program.frame(c,bits);points=coordinates(program,ff['uniforms']);allpoints+=len(points)
    for index,point in enumerate(points):
     xz=tuple(f32(x) for x in point['xz']);ref=program.evaluate(ff,xz);qxz=tuple(qvalue(x,S) for x in xz)
     try:
      got=program.evaluate(ff,tuple(f32(q/S) for q in qxz)) if series=='coordinate_only_float32' else program.evaluate(qf,qxz)
     except DomainError as e:rejected[str(e)]+=1;continue
     div=S if series=='all_math_fixed' else 1
     color=tuple(x/div for x in got['color']);fac=got['mix_factor']/div
     es=[abs(color[k]-ref['color'][k]) for k in range(3)];errors.extend(es);facerrors.append(abs(fac-ref['mix_factor']));kinderrors[point['kind']].extend(es);kindfac[point['kind']].append(abs(fac-ref['mix_factor']))
     paramerrors.extend(abs(got['parameters'][k]/div-ref['parameters'][k]) for k in ref['parameters'])
     names=[n for n in margins(program,ref['trace']) if got['trace'][n]['Value']/div!=ref['trace'][n]['Value']]
     if names:
      changed+=1;cmpchanged+=len(names);bykind[point['kind']]+=1
      rawlog.write(json.dumps({'series':series,'bits':bits,'material':program.material,'state':state,'point':point,'float32_xz':xz,'quantized_xz_codes':qxz,'changed_nodes':names,'comparison_details':{n:comparison_details(program,n,ref,got,S if series=='all_math_fixed' else None) for n in names},'reference_comparison_margins':{n:margins(program,ref['trace'])[n] for n in names},'color_max_abs':max(es),'mix_abs':abs(fac-ref['mix_factor'])})+'\n')
     e=max(es+[abs(fac-ref['mix_factor'])])
     if maxcase is None or e>maxcase['error']:maxcase={'error':e,'material':program.material,'state':state,'point':point,'ref_color':ref['color'],'candidate_color':color,'ref_mix':ref['mix_factor'],'candidate_mix':fac,'changed_nodes':names}
     if series=='all_math_fixed' and index%97==0:
      for width in (1,2,4,8):
       coords=[tuple(qvalue(f32(x),S) for x in points[(index+j)%len(points)]['xz']) for j in range(width)]
       block=program.block(qf,coords)
       assert block==[program.evaluate(qf,p) for p in coords];blocks+=1
  rec={'series':series,'fraction_bits':bits,'base_color_error':stats(errors),'error_by_point_kind':{k:{'base_color':stats(v),'mix_factor':stats(kindfac[k])} for k,v in kinderrors.items()},'mix_factor_error':stats(facerrors),'parameter_error':stats(paramerrors),'samples_with_comparison_disagreement':changed,'comparison_disagreements':cmpchanged,'disagreement_point_kinds':dict(bykind),'rejected':dict(rejected),'integer_instrumentation':{**CHECK_STATS,'max_product_magnitude_bits':CHECK_STATS['max_product_abs'].bit_length(),'max_code_magnitude_bits':CHECK_STATS['max_code_abs'].bit_length()},'worst':maxcase}
  summary.append(rec);print(json.dumps(rec),flush=True)
rawlog.close();(ROOT/'results.json').write_text(json.dumps(summary,indent=2)+'\n')
# Arithmetic and input negative/endpoint tests.
assert rnd(1,2)==0 and rnd(3,2)==2 and rnd(-5,2)==-2
assert fixed_div(123,0,65536,False)==0
try:fixed_div(123,0,65536,True)
except DomainError:pass
else:raise AssertionError('lost zero provenance')
for bits in (16,20,24):
 S=1<<bits;assert fsqrt(-1,S)==0 and fsqrt(0,S)==0 and fsqrt(S,S)==S
for x in (float('nan'),float('inf'),2.):
 bad=BASE_CONTROLS.copy();bad['Bubble Pressure']=x
 try:uniforms(bad,-1)
 except DomainError:pass
 else:raise AssertionError('invalid pressure accepted')
try:check(I64MAX+1)
except DomainError:pass
else:raise AssertionError('overflow accepted')
print('PASS blocks',blocks,'negative/ties/sqrt/domain tests; no rays, shaders or Blender execution',flush=True)
