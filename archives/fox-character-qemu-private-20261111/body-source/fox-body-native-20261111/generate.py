from pathlib import Path
import json,importlib.util,math,hashlib
D=Path(__file__).resolve().parent;R=D.parent
p=R/'fox-dq-private-20261106/private-body-input.json';d=json.load(open(p))
s=json.load(open(R/'fixed-recovery/extracted/fox-cardputer-latest-private/2k-v2-neutral-sidecar.json'));o=next(x for x in s['objects'] if x['name']==d['mesh'])
spec=importlib.util.spec_from_file_location('importer',R/'fox-dq-private-20261106/import_skin_dq.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
top=[t['vertices'] for t in o['triangles']];assert len(top)*3==len(d['vertices'])
first={}
for t,ids in enumerate(top):
 for c,i in enumerate(ids):
  j=t*3+c;v=d['vertices'][j];assert max(abs(a-b) for a,b in zip(v['position'],o['vertices_local'][i]))<2e-6;first.setdefault(i,j)
assert len(first)==229
parts=[]
# Consecutive material runs preserve original face ordering, bounded 32/64.
for tid,t in enumerate(o['triangles']):
 ids=t['vertices'];mat=t['material_slot']
 if not parts or parts[-1]['mat']!=mat or len(parts[-1]['tris'])>=64 or len(set(parts[-1]['ids'])|set(ids))>32:parts.append(dict(mat=mat,ids=[],tris=[],source_triangles=[]))
 q=parts[-1]
 for i in ids:
  if i not in q['ids']:q['ids'].append(i)
 q['tris'].append([q['ids'].index(i) for i in ids]);q['source_triangles'].append(tid)
def cf(x):
 s=format(x,'.9g');return s+('f' if '.' in s or 'e' in s else '.0f')
def arr(v):return '{'+','.join(arr(x) if isinstance(x,list) else cf(x) for x in v)+'}'
def ints(v):return '{'+','.join(ints(x) if isinstance(x,list) else str(x) for x in v)+'}'
base=['#define UNIQUE_VERTICES 229',f'#define PARTS {len(parts)}',f'#define TOTAL_VERTICES {sum(len(q["ids"]) for q in parts)}','#define POSES 64']
base+=['static const uint32_t topology[454][3]='+ints(top)+';']
rows=[]
for i in range(229):
 v=d['vertices'][first[i]];js,ws=m.weights(v['influences'],2);rows.append('{'+arr(v['position'])+','+arr(v['normal'])+','+ints(js)+','+ints(ws)+'}')
base+=['static const ayatsuri_skin_vertex rest_input[229]={'+','.join(rows)+'};']
base+=['static const ayatsuri_transform inverse_bind[2]={'+','.join('{'+arr(sum(m.inverse(x)[:3],[]))+'}' for x in d['rest'])+'};']
base+=['static const ayatsuri_transform globals[64][2]={'+','.join('{'+','.join('{'+arr(sum(x[:3],[]))+'}' for x in pose['globals'])+'}' for pose in d['poses'])+'};']
base+=['static const uint16_t part_counts[PARTS]='+ints([len(q['ids']) for q in parts])+';','static const uint16_t scatter[TOTAL_VERTICES]='+ints(sum([q['ids'] for q in parts],[]))+';']
(D/'fixture.h').write_text('\n'.join(base)+'\n')
oracle=[]
for pose in d['poses']:oracle.append([pose['blender_positions'][first[i]]+pose['blender_corner_normals'][first[i]] for i in range(229)])
(D/'oracle.h').write_text('static const float oracle[64][229][6]='+arr(oracle)+';\n')
materials={x['name']:x['properties']['diffuse_color'] for x in s['material_source_graphs']}
(D/'source.json').write_text(json.dumps(dict(parts=parts,positions=[d['vertices'][first[i]]['position'] for i in range(229)],normals=[d['vertices'][first[i]]['normal'] for i in range(229)],materials=[materials[n] for n in o['materials']],world=d['mesh_world'])))
(D/'manifest.json').write_text(json.dumps(dict(source_sha256=d['source_sha256'],input_sha256=hashlib.sha256(p.read_bytes()).hexdigest(),parts=len(parts),triangles=454,unique_vertices=229,partition_vertices=sum(len(q['ids']) for q in parts),scope='Private body only; original material-slot and triangle order retained; explicit diagnostic diffuse profile; not full character or Principled fidelity'),indent=2))
print('parts',len(parts),'vertices',sum(len(q['ids']) for q in parts))
