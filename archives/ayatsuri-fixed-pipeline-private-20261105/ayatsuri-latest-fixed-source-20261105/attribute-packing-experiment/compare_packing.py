"""Topology-only greedy triangle scheduling; no geometric/scene/visibility queries."""
import collections,copy,hashlib,json,pathlib
HERE=pathlib.Path(__file__).resolve().parent;INPUT=HERE.parent/'attribute-prototype'
PINS={16:'cf4bdf24d363454427544bb3596af15d0b1c8b820137e9f062e6c366023289b9',20:'81830dd0d7c363e3f7c6d6b7f4c4147112b0df89d7e28081763a9cfef0c9f536'}
def canon(x):return json.dumps(x,sort_keys=True,separators=(',',':'),ensure_ascii=False).encode()
def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def write_new(name,x):
 with (HERE/name).open('xb') as f:f.write(canon(x)+b'\n')
def collect(ir):
 groups=collections.defaultdict(dict)
 for part in ir['parts']:
  group=(part['source_object_id'],part['material'])
  for t in part['triangles']:
   idx=t['source_lod_triangle_index'];assert idx not in groups[group]
   rows=[part['vertices'][i] for i in t['vertices']];keys=[canon(v) for v in rows]
   groups[group][idx]={'meta':{k:v for k,v in t.items() if k!='vertices'},'rows':rows,'keys':keys,'edges':{tuple(sorted((keys[a],keys[b]))) for a,b in ((0,1),(1,2),(2,0))}}
 return groups

def pack(ir,seed_mode):
 parts=[];groups=collect(ir)
 for (oi,mat),tris in groups.items():
  edges=collections.defaultdict(set)
  for tid,t in tris.items():
   for e in t['edges']:edges[e].add(tid)
  neighbors={i:set().union(*(edges[e] for e in t['edges']))-{i} for i,t in tris.items()}
  remaining=set(tris)
  while remaining:
   seed=min(remaining) if seed_mode=='min_id' else min(remaining,key=lambda i:(-len(neighbors[i]&remaining),i))
   part={'part_id':len(parts),'source_object_id':oi,'material':mat,'vertices':[],'triangles':[]};keys={};used_edges=set();part_ids=set()
   def take(tid):
    t=tris[tid];inds=[]
    for key,row in zip(t['keys'],t['rows']):
     if key not in keys:keys[key]=len(part['vertices']);part['vertices'].append(copy.deepcopy(row))
     inds.append(keys[key])
    part['triangles'].append(dict(copy.deepcopy(t['meta']),vertices=inds));used_edges.update(t['edges']);part_ids.add(tid);remaining.remove(tid)
   take(seed)
   while remaining and len(part['triangles'])<64:
    fits=[i for i in remaining if len(set(keys)|set(tris[i]['keys']))<=32]
    if not fits:break
    # Prefer reused attribute vertices, then sharededges. Stable tie-break remains sourceID.
    best=min(fits,key=lambda i:(-len(set(tris[i]['keys'])&set(keys)),-len(tris[i]['edges']&used_edges),-len(neighbors[i]&remaining),i))
    take(best)
   assert len(part['vertices'])<=32 and len(part['triangles'])<=64;parts.append(part)
 return parts

def signatures(ir_or_parts):
 parts=ir_or_parts['parts'] if isinstance(ir_or_parts,dict) else ir_or_parts
 sig={};allverts=collections.defaultdict(set);edge_values=collections.defaultdict(set)
 for p in parts:
  assert len(p['vertices'])<=32 and len(p['triangles'])<=64
  for t in p['triangles']:
   key=(p['source_object_id'],t['source_lod_triangle_index']);assert key not in sig,'triangle duplicated'
   rows=[p['vertices'][i] for i in t['vertices']];meta={k:v for k,v in t.items() if k!='vertices'}
   sig[key]=canon({'material':p['material'],'metadata':meta,'ordered_corners':rows})
   for v in rows:allverts[(p['source_object_id'],v['source_vertex_index'])].add(canon(v))
   for a,b in((0,1),(1,2),(2,0)):
    # Original sourceidentity edge, even when zero-area coordinates coincide.
    e=(p['source_object_id'],*sorted((rows[a]['source_vertex_index'],rows[b]['source_vertex_index'])))
    edge_values[e].add(tuple(sorted((tuple(rows[a]['world_xyz']),tuple(rows[b]['world_xyz'])))))
 return sig,allverts,edge_values

def metrics(parts,materials=12):
 p=len(parts);v=sum(len(x['vertices']) for x in parts);t=sum(len(x['triangles']) for x in parts);b=sum((len(x['vertices'])+7)//8 for x in parts)
 vertices=collections.defaultdict(set);edges=collections.defaultdict(set)
 for part in parts:
  oi=part['source_object_id'];pid=part['part_id']
  for row in part['vertices']:vertices[(oi,row['source_vertex_index'])].add(pid)
  for tri in part['triangles']:
   ids=[part['vertices'][i]['source_vertex_index'] for i in tri['vertices']]
   for a,b0 in((0,1),(1,2),(2,0)):edges[(oi,*sorted((ids[a],ids[b0])))].add(pid)
 return {'parts':p,'partition_vertices':v,'triangles':t,'unique_source_vertices':len(vertices),'duplicated_records':v-len(vertices),'padded_blocks8':b,'padded_vertex_records':b*8,'max_vertices_per_part':max(len(x['vertices']) for x in parts),'max_triangles_per_part':max(len(x['triangles']) for x in parts),'cross_part_source_vertices':sum(len(x)>1 for x in vertices.values()),'cross_part_source_edges':sum(len(x)>1 for x in edges.values()),'hypothetical_old_AYFQ_geometry_only_bytes':64+32*p+8*materials+144*b+4*t,'audit_layout_unpadded_bytes':64+64*p+40*v+8*t,'audit_layout_padded8_bytes':64+64*p+40*b*8+8*t}

def main():
 results=[];schedules={}
 for bits,pin in PINS.items():
  path=INPUT/f'attributes-q{bits}-v2.json';assert sha(path)==pin;ir=json.loads(path.read_text());base=signatures(ir);baseline=metrics(ir['parts']);row={'fraction_bits':bits,'input_sha256':pin,'baseline':baseline,'candidates':{}}
  for mode in ('min_id','max_remaining_degree'):
   parts=pack(ir,mode);assert parts==pack(ir,mode),'nondeterminism';now=signatures(parts)
   assert base==now,'ordered corner attributes, material, triangle IDs/meta or edge mismatch'
   assert len(now[0])==1982;assert sum(bool(t['static_degenerate_domains']) for p in parts for t in p['triangles'])==36
   m=metrics(parts);m['verification']={'all_1982_triangles_exactly_once':True,'ordered_corner_attributes_identical':True,'source_winding_corner_order_identical':True,'material_identity_identical':True,'all_source_triangle_metadata_identical':True,'shared_world_edge_values_identical':True,'neutral_degenerate_tags_preserved':36,'deterministic':True}
   m['versus_baseline']={k:m[k]-baseline[k] for k in ('parts','partition_vertices','padded_blocks8','hypothetical_old_AYFQ_geometry_only_bytes','audit_layout_unpadded_bytes','audit_layout_padded8_bytes')}
   row['candidates'][mode]=m;schedules[(bits,mode)]=[(p['source_object_id'],p['material'],[t['source_lod_triangle_index'] for t in p['triangles']]) for p in parts]
   write_new(f'packing-q{bits}-{mode}.json',{'schema':'ayatsuri-attribute-packing-experiment-v1','source_IR_sha256':pin,'algorithm':mode,'parts':parts,'metrics':m,'unchanged_metadata_reference':str(path),'not_runtime_asset':True})
  results.append(row)
 for mode in ('min_id','max_remaining_degree'):assert schedules[(16,mode)]==schedules[(20,mode)],'Q16/Q20 schedule differs'
 write_new('results.json',{'runs':results,'Q16_Q20_schedules_identical':True,'scope':'triangle order and part membership only, no runtime/format/gate changes','no_optimality_or_speed_claim':True});print(json.dumps(results,indent=2))
 for bits,pin in PINS.items():assert sha(INPUT/f'attributes-q{bits}-v2.json')==pin
if __name__=='__main__':main()
