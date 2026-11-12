import json,pathlib
import compile_attributes as c
P=c.ROOT/'fox-cardputer-latest-private'
PINS={'fox-cardputer-2k-v2.blend':'384ada0c37da16d625b1e6612a0d2f7ca538c29fe0d8dff43a929841ec63fba8','export_sidecar.py':'ba989a303657f2f3855f93c3a7067c1d3e5b536592669c0d54a8a24c5b5ce466','2k-v2-provenance-validation.json':'be6032a009602869a92dcb86075e3aaac81a232a6a9bbf8a495108d08f7b19a4','2k-v2-loop-and-eyelid-supplement.json':'55ea3af87ed72ec0761d79bc4e61a77f31be170394b6ce1076cd248665db2619'}
def finalize(source,f):
 for name,pin in PINS.items():c.require(c.sha(P/name)==pin,'supplement identity')
 binding=c.loads((P/'2k-v2-provenance-validation.json').read_bytes());supp=c.loads((P/'2k-v2-loop-and-eyelid-supplement.json').read_bytes());changes=c.loads((P/'2k-v2-stats.json').read_bytes())
 c.require(binding['source_sha256']==c.BLEND and binding['sidecar_sha256']==c.PIN and supp['pinned_sidecar_sha256']==c.PIN,'provenance binding')
 c.require(binding['all_base_evaluated_vertex_counts_equal'] and binding['all_base_evaluated_triangle_indices_equal'],'base/evaluated topology binding')
 ir=c.compile_ir(source,f);s=ir['stats'];uvstream=[];uvmax=0.;basis_error={};mapped=0
 c.require(len(supp['objects'])==len(source['objects'])==len(binding['objects']),'supplement count')
 for oi,(obj,loop,base) in enumerate(zip(source['objects'],supp['objects'],binding['objects'])):
  c.require(obj['name']==loop['object']==base['object'] and base['vertices_equal'] and base['triangle_indices_equal'],'object topology binding')
  c.require(loop['triangles']==[t['vertices'] for t in obj['triangles']],'triangle topology supplement')
  c.require(len(loop['triangle_loop_indices'])==len(obj['triangles']),'triangle loop count')
  for t,indices in zip(obj['triangles'],loop['triangle_loop_indices']):
   c.require(len(indices)==3 and all(type(i)is int and 0<=i<len(loop['loop_vertex_indices']) for i in indices),'loop indices')
   c.require([loop['loop_vertex_indices'][i] for i in indices]==t['vertices'],'loop vertex correspondence');mapped+=3
  for name,uv in obj['uv_layers'].items():
   c.require(loop['uv_layer_lengths'][name]==len(uv)==len(loop['loop_vertex_indices']),'UV loop binding')
   tris=[]
   for indices in loop['triangle_loop_indices']:
    q=[c.quant(uv[i],20,1024) for i in indices];tris.append(q)
    for i,v in zip(indices,q):uvmax=max(uvmax,max(abs(a-b/(1<<20)) for a,b in zip(uv[i],v)))
   uvstream.append({'source_object_id':oi,'layer':name,'fraction_bits':20,'domain':'triangle corner, source evaluated-loop mapping verified','values_by_triangle':tris})
   ir['objects'][oi]['uv_status']='optional fixed Q20 stream bound by pinned loop supplement; no shader consumer'
  for key,rows in obj['shape_keys'].items():c.require(len(rows)==len(obj['vertices_local']),'shape/base count')
  if 'Basis' in obj['shape_keys']:basis_error[obj['name']]=max(abs(a-b) for p,q in zip(obj['shape_keys']['Basis'],obj['vertices_local']) for a,b in zip(p,q))
  for row in obj['vertex_group_weights']:
   # Retain exporter metadata as-is; no deformation or weight normalization.
   for item in row:
    c.require(type(item[0])is int and 0<=item[0]<len(obj['vertex_groups']),'bone group index');c.num(item[1],0,1)
 keys={(p['source_object_id'],v['source_vertex_index'],*v['normal_world_s32767'],*v['normal_local_s32767']) for p in ir['parts'] for v in p['vertices']}
 eye=[p for p in ir['parts'] if p['material'].startswith('Blink mask')]
 s.update({'basis_vertex_count':1322,'evaluated_vertex_count':1322,'corner_expanded_vertex_count':1982*3,'unique_attribute_vertices_before_partition':len(keys),'additional_vertices_due_to_corner_normal_splits':len(keys)-1322,'additional_vertices_due_to_partition_duplication':s['partition_vertices']-len(keys),'loop_corners_verified':mapped,'optional_uv_corners':sum(len(x['values_by_triangle'])*3 for x in uvstream),'optional_uv_max_component_error':uvmax,'shape_basis_vs_evaluated_local_max_component_by_object':basis_error,'local_xz_live_material_partition_vertices':sum(len(p['vertices']) for p in eye),'local_xz_live_material_unique_vertices':len({(p['source_object_id'],v['source_vertex_index']) for p in eye for v in p['vertices']})})
 s['memory_formula'].update({'optional_uv_raw_stream_bytes':s['optional_uv_corners']*8,'old_AYFQ_geometry_only_reference_formula':'64 +32*P +8*M +144*sum(ceil(Vpart/8)) +4*T','old_AYFQ_geometry_only_reference_bytes':64+32*s['parts']+8*len(source['material_source_graphs'])+144*s['padded_8lane_blocks']+4*s['triangles'],'old_AYFQ_reference_not_admitted_asset':True,'all_metadata_and_program_bytes_excluded':True})
 ir['prototype_revision']=2;ir['optional_uv_stream']=uvstream;ir['external_provenance']={'verified_files_sha256':PINS,'sidecar_base_evaluated_topology':binding,'neutral_eyelid_explanation_from_LOD_exporter':supp['eyelid_neutral_degeneracy_checks'],'runtime_contract_from_LOD_exporter':supp['runtime_contract']};ir['derived_changes']={'stats_sha256':c.sha(P/'2k-v2-stats.json'),'removed_details':changes['removed_details'],'clearance_offsets':changes['clearance_offsets']}
 ir['admission_blockers']=['36 source-neutral eyelid zero-area triangles retained as authored/morph states; runtime degenerate policy separately required, not a quantization failure','procedural color/transparency/Principled BSDF and animation not implemented; material DAG is retained metadata','UV correspondence now verified and optional stream quantized; no UV consumer or texture/coverage semantics implemented']
 return ir
if __name__=='__main__':
 c.require(c.sha(c.SOURCE)==c.PIN,'input pin');s=c.loads(c.SOURCE.read_bytes());results=[]
 for f in(16,20):
  ir=finalize(s,f);c.write_new(c.HERE/f'attributes-q{f}-v2.json',ir);results.append(ir['stats'])
 c.write_new(c.HERE/'results-v2.json',{'source_sha256':c.BLEND,'sidecar_sha256':c.PIN,'runs':results})
 print(json.dumps(results,indent=2))
