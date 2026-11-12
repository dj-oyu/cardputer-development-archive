import sys
sys.dont_write_bytecode=True
import json,math
from model import *
results=json.loads((ROOT/'results.json').read_text());states=dict(json.loads((ROOT/'control-fixtures.json').read_text()));programs={p.material:p for p in load_programs()};report=[]
for result in results:
 if result['fraction_bits']!=24:continue
 w=result['worst'];program=programs[w['material']];control=states[w['state']];ff=program.frame(control);qf=program.frame(control,24);S=1<<24
 center=tuple(f32(v) for v in w['point']['xz']);target=w['changed_nodes'][0]
 for axis in (0,1):
  unique={};step=2**(-26 if axis==0 else -22)
  for i in range(-512,513):
   p=list(center);p[axis]=f32(center[axis]+i*step);unique[tuple(p)]=i
  rows=[]
  for p in sorted(unique):
   ref=program.evaluate(ff,p);q=tuple(qvalue(x,S) for x in p)
   got=program.evaluate(ff,tuple(f32(x/S) for x in q)) if result['series']=='coordinate_only_float32' else program.evaluate(qf,q)
   scale=S if result['series']=='all_math_fixed' else 1
   changed=ref['trace'][target]['Value']!=got['trace'][target]['Value']/scale
   rows.append({'coordinate':p[axis],'offset':p[axis]-center[axis],'reference_class':ref['trace'][target]['Value'],'candidate_class':got['trace'][target]['Value']/scale,'disagrees':changed,'max_rgb_error':max(abs(got['color'][k]/scale-ref['color'][k]) for k in range(3))})
  # Sort on scanned coordinate (tuple-order same for axis0 and fixed X axis1).
  rows.sort(key=lambda r:r['coordinate']);bad=[r for r in rows if r['disagrees']];segments=[]
  for row in rows:
   if row['disagrees']:
    if not segments or not segments[-1]['open']:segments.append({'start':row['coordinate'],'end':row['coordinate'],'samples':1,'open':True})
    else:segments[-1]['end']=row['coordinate'];segments[-1]['samples']+=1
   elif segments:segments[-1]['open']=False
  for x in segments:
   x.pop('open');x['sampled_span']=x['end']-x['start']
   left=[r['coordinate'] for r in rows if r['coordinate']<x['start'] and not r['disagrees']];right=[r['coordinate'] for r in rows if r['coordinate']>x['end'] and not r['disagrees']]
   x['bracket_width_between_neighbor_agreements']=(min(right)-max(left)) if left and right else None
  item={'series':result['series'],'bits':24,'material':w['material'],'state':w['state'],'target_node':target,'center_float32_xz':center,'axis':'X' if axis==0 else 'Z','requested_step':step,'requested_half_window':512*step,'unique_float32_points':len(rows),'disagreement_points':len(bad),'segments':segments,'rows':rows}
  report.append(item);print({k:v for k,v in item.items() if k!='rows'})
(ROOT/'boundary-scans.json').write_text(json.dumps(report,indent=2)+'\n')
