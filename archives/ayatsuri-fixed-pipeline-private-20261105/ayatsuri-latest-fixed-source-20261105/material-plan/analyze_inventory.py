"""Read exported JSON only; no Blender imports, scripts, eval or driver execution."""
import json,collections,pathlib,hashlib,re
root=pathlib.Path(__file__).resolve().parent
D=json.loads((root.parent/'inventory.json').read_text());S=json.loads((root.parent/'supplement.json').read_text())
summary=[];texts=[]
for mi,m in enumerate(D['materials']):
 t=m.get('node_tree')
 if not t:continue
 ns={n['name']:n for n in t['nodes']}; incoming=collections.defaultdict(list);outgoing=collections.defaultdict(list)
 for l in t['links']:
  assert l['valid'];assert l['from'] in ns and l['to'] in ns
  assert any(i['identifier']==l['to_socket'] for i in ns[l['to']]['inputs'])
  assert any(i['identifier']==l['from_socket'] for i in ns[l['from']]['outputs'])
  incoming[l['to']].append(l);outgoing[l['from']].append(l)
 def closure(name):
  seen=set();stack=[name]
  while stack:
   a=stack.pop()
   if a in seen:continue
   seen.add(a);stack.extend(l['from'] for l in incoming[a])
  return seen
 reachable=closure('Material Output');visited=set();active=set();order=[]
 def visit(name):
  assert name not in active,'cycle';
  if name in visited:return
  active.add(name)
  for l in incoming[name]:visit(l['from'])
  active.remove(name);visited.add(name);order.append(name)
 for n in ns:visit(n)
 drivers=(t.get('animation') or {}).get('drivers',[])
 driven={re.search(r'nodes\["(.*?)"\]',d['data_path']).group(1) for d in drivers}
 spatial={n['name'] for n in t['nodes'] if n['type'] in ('ShaderNodeTexCoord','ShaderNodeNewGeometry','ShaderNodeVertexColor')}
 deps={n:set() for n in ns}
 for name in order:
  if name in driven:deps[name].add('control')
  if name in spatial:deps[name].add('spatial_or_attribute')
  for l in incoming[name]:deps[name]|=deps[l['from']]
 mathnodes=[n for n in t['nodes'] if n['type']=='ShaderNodeMath']
 partitions=collections.Counter('spatial' if 'spatial_or_attribute' in deps[n['name']] else 'control_uniform' if 'control' in deps[n['name']] else 'constant' for n in mathnodes if n['name'] in reachable)
 divisors=[]
 for n in mathnodes:
  if n['properties']['operation']=='DIVIDE':
   socket=n['inputs'][1];link=next((l for l in incoming[n['name']] if l['to_socket']==socket['identifier']),None)
   divisors.append({'node':n['name'],'reachable':n['name'] in reachable,'numerator_dependencies':sorted(deps[n['name']]),'denominator':link or socket['default'],'denominator_dependencies':sorted(deps[link['from']]) if link else []})
 roots={}
 for target,socket in [('Principled BSDF','Base Color'),('Mix Shader','Fac')]:
  l=next((l for l in incoming[target] if l['to_socket']==socket),None)
  if l:
   c=closure(l['from']);roots[target+'.'+socket]={'source':l['from'],'nodes':len(c),'math_nodes':sum(ns[n]['type']=='ShaderNodeMath' for n in c),'coordinate_nodes':sorted(c&spatial),'driven_nodes':sorted(c&driven)}
 partition_ops={kind:dict(collections.Counter(n['properties']['operation'] for n in mathnodes if n['name'] in reachable and ('spatial' if 'spatial_or_attribute' in deps[n['name']] else 'control_uniform' if 'control' in deps[n['name']] else 'constant')==kind)) for kind in ['spatial','control_uniform','constant']}
 rec={'partition_operations':partition_ops,'material':m['name'],'json_pointer':f'/materials/{mi}/node_tree','nodes':len(ns),'links':len(t['links']),'reachable_nodes':len(reachable),'dead_nodes':sorted(set(ns)-reachable),'math_operations':dict(collections.Counter(n['properties']['operation'] for n in mathnodes)),'reachable_math_partition':dict(partitions),'driver_count':len(drivers),'roots':roots,'divisors':divisors}
 summary.append(rec)
 if 'eye white' in m['name']:
  texts.append('\nMATERIAL '+m['name']+' source '+rec['json_pointer'])
  for name in order:
   n=ns[name];args=[]
   for inp in n['inputs']:
    link=next((l for l in incoming[name] if l['to_socket']==inp['identifier']),None)
    args.append(inp['identifier']+'='+ (link['from']+'.'+link['from_socket'] if link else repr(inp.get('default'))))
   texts.append(name+' ['+n['type']+' '+str(n['properties'])+'] deps='+str(sorted(deps[name]))+' reachable='+str(name in reachable)+' ('+', '.join(args)+')')
  texts.append('DRIVERS (data, not executed):\n'+json.dumps(drivers,ensure_ascii=False,indent=2))
(root/'dag-summary.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2)+'\n');(root/'sclera-dag.txt').write_text('\n'.join(texts)+'\n')
print(json.dumps([x for x in summary if 'eye white' in x['material']],ensure_ascii=False,indent=2))
