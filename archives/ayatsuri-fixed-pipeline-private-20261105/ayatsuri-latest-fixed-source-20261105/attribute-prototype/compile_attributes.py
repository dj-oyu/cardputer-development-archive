"""Private AYFA-IR v1 attribute quantizer. No Blender, scene queries or renderer."""
import collections,hashlib,json,math,os,pathlib,struct,tempfile
from fractions import Fraction
HERE=pathlib.Path(__file__).resolve().parent;ROOT=HERE.parent.parent
SOURCE=ROOT/'fox-cardputer-latest-private/2k-v2-neutral-sidecar.json'
PIN='00a81fbcd19c79c578bbbbd7ab077ee6f63048a106c5594675ff208670d5e85e'
BLEND='d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a'
def require(x,m):
 if not x:raise ValueError(m)
def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def canonical(x):return json.dumps(x,sort_keys=True,separators=(',',':'),ensure_ascii=False,allow_nan=False).encode()
def pairs(x):
 out={}
 for k,v in x:require(k not in out,'duplicate key');out[k]=v
 return out
def loads(blob):
 require(len(blob)<=8*1024*1024,'input size')
 def fail(x):raise ValueError('nonfinite JSON')
 x=json.loads(blob,object_pairs_hook=pairs,parse_constant=fail)
 def visit(v,d=0):
  require(d<48,'nesting')
  if isinstance(v,dict):
   for y in v.values():visit(y,d+1)
  elif isinstance(v,list):
   require(len(v)<=100000,'array count')
   for y in v:visit(y,d+1)
  elif type(v) in (int,float):require(abs(v)<=1e12 and math.isfinite(v),'numeric envelope')
 visit(x);return x
def num(x,lo,hi):require(type(x) in(int,float) and lo<=x<=hi and math.isfinite(x),'numeric range');return x
def vector(v,n,lo,hi):require(isinstance(v,list) and len(v)==n,'vector');return [num(x,lo,hi) for x in v]
def quant(v,f,limit=128):return [round(num(x,-limit,limit)*(1<<f)) for x in v]
def cross(a,b,c):
 u=[b[i]-a[i] for i in range(3)];v=[c[i]-a[i] for i in range(3)];return[u[1]*v[2]-u[2]*v[1],u[2]*v[0]-u[0]*v[2],u[0]*v[1]-u[1]*v[0]]
def normal(v):
 vector(v,3,-1.000001,1.000001);length=sum(x*x for x in v);require(abs(length-1)<1e-5,'normal not unit')
 # Normal input observed inside [-1,1]; require it, do not clip endpoints.
 q=[round(num(x,-1,1)*32767) for x in v];require(32762**2<=sum(x*x for x in q)<=32772**2,'encoded normal range');return q

def validate(s):
 require(s['schema']=='fox-neutral-evaluated-sidecar-v1' and s['source_sha256']==BLEND and s['derived_label']=='2k-v2','source/version binding')
 require(s['frame']==1 and not s['invalid_drivers'],'neutral state/driver validation')
 require(len(s['objects'])==74 and len({o['name'] for o in s['objects']})==74,'object identities')
 mats={m['name'] for m in s['material_source_graphs']};require(len(mats)==12,'material graph count')
 for o in s['objects']:
  p=o['vertices_local'];w=o['vertices_world_metres'];require(len(p)==len(w)>0,'vertex counts');require(not o['attributes'],'unknown attribute domain: reject rather than flatten')
  for rows in (p,w):
   for row in rows:vector(row,3,-128,128)
  require(len(o['matrix_world'])==4 and o['matrix_world'][3]==[0,0,0,1],'affine matrix')
  for row in o['matrix_world']:vector(row,4,-1000,1000)
  require(all(m in mats for m in o['materials']),'material graph missing')
  faces=[]
  for t in o['triangles']:
   ix=t['vertices'];require(len(ix)==3 and len(set(ix))==3 and all(type(i)is int and 0<=i<len(p) for i in ix),'triangle index')
   require(type(t['material_slot'])is int and 0<=t['material_slot']<len(o['materials']),'material slot')
   require(type(t['local_face_id'])is int and t['local_face_id']>=0,'face ID');faces.append(t['local_face_id'])
   for k in ('corner_normals_local','corner_normals_world'):
    require(len(t[k])==3,'corner count')
    for n in t[k]:normal(n)
   require(type(t['nearest_source_evaluated_triangle'])is int and t['nearest_source_evaluated_triangle']>=0,'source hint');num(t['nearest_source_distance_local'],0,128)
  for name,uv in o['uv_layers'].items():
   for v in uv:vector(v,2,-2048,2048)
  for name,shape in o['shape_keys'].items():
   for p0 in shape:vector(p0,3,-128,128)
  require(len(o['vertex_group_weights'])==len(p),'weight count')
 require(sum(len(o['triangles']) for o in s['objects'])==1982,'triangle count')

def compile_ir(s,f):
 require(f in (16,20),'fraction bits');validate(s)
 parts=[];objects=[];stats={'fraction_bits':f,'world_component_max_error_m':0.,'local_component_max_error_m':0.,'normal_component_max_error':0.,'source_matrix_world_max_error_m':0.,'quantized_matrix_world_max_error_m':0.,'source_degenerate':[],'new_quantized_degenerate':[],'orientation_reversals':[],'normal_length_code_squared_min':10**20,'normal_length_code_squared_max':0,'max_nearest_source_hint_distance_local':0.,'shared_vertex_position_mismatches':0,'shared_physical_edge_position_mismatches':0}
 seenpos={};seenedge={};identityparts=collections.defaultdict(set);edgeparts=collections.defaultdict(set);qgroups=collections.defaultdict(set);near=[]
 for oi,o in enumerate(s['objects']):
  local=[quant(p,f) for p in o['vertices_local']];world=[quant(p,f) for p in o['vertices_world_metres']];m=o['matrix_world']
  for vi,(p,w,qp,qw) in enumerate(zip(o['vertices_local'],o['vertices_world_metres'],local,world)):
   stats['local_component_max_error_m']=max(stats['local_component_max_error_m'],max(abs(a-b/(1<<f)) for a,b in zip(p,qp)));stats['world_component_max_error_m']=max(stats['world_component_max_error_m'],max(abs(a-b/(1<<f)) for a,b in zip(w,qw)))
   for k in range(3):
    stats['source_matrix_world_max_error_m']=max(stats['source_matrix_world_max_error_m'],abs(sum(m[k][j]*p[j] for j in range(3))+m[k][3]-w[k]));stats['quantized_matrix_world_max_error_m']=max(stats['quantized_matrix_world_max_error_m'],abs(sum(m[k][j]*qp[j]/(1<<f) for j in range(3))+m[k][3]-qw[k]/(1<<f)))
   src=tuple(w);q=tuple(qw);require(src not in seenpos or seenpos[src]==q,'shared coordinate inconsistency');seenpos[src]=q;qgroups[q].add(src)
  obj={'source_object_id':oi,'name':o['name'],'parent':o['parent'],'source_matrix_world':m,'source_vertex_count':len(local),'parts':[],'uv_status':'unbound evaluated-loop-order, retained high precision only' if o['uv_layers'] else 'absent','animation_status':'deferred: source shapes/weights/rig retained, no runtime evaluator'}
  part=None;keys={}
  for ti,t in enumerate(o['triangles']):
   ix=t['vertices'];material=o['materials'][t['material_slot']];rows=[]
   for ci,vi in enumerate(ix):
    nw=normal(t['corner_normals_world'][ci]);nl=normal(t['corner_normals_local'][ci]);key=(vi,*nw,*nl)
    for original,q in [(t['corner_normals_world'][ci],nw),(t['corner_normals_local'][ci],nl)]:
     stats['normal_component_max_error']=max(stats['normal_component_max_error'],max(abs(a-b/32767) for a,b in zip(original,q)));sq=sum(x*x for x in q);stats['normal_length_code_squared_min']=min(stats['normal_length_code_squared_min'],sq);stats['normal_length_code_squared_max']=max(stats['normal_length_code_squared_max'],sq)
    rows.append((key,{'source_vertex_index':vi,'world_xyz':world[vi],'local_xyz':local[vi],'normal_world_s32767':nw,'normal_local_s32767':nl}))
   if part is None or part['material']!=material or len(part['triangles'])>=64 or len(set(keys)|{k for k,_ in rows})>32:
    part={'part_id':len(parts),'source_object_id':oi,'material':material,'vertices':[],'triangles':[]};parts.append(part);obj['parts'].append(part['part_id']);keys={}
   outix=[]
   for k,row in rows:
    if k not in keys:keys[k]=len(part['vertices']);part['vertices'].append(row)
    outix.append(keys[k]);identityparts[(oi,row['source_vertex_index'])].add(part['part_id'])
   degenerates=[]
   for domain,source,encoded in [('world',o['vertices_world_metres'],world),('local',o['vertices_local'],local)]:
    exact=cross(*[[Fraction(v) for v in source[i]] for i in ix]);qcross=cross(*[encoded[i] for i in ix]);z=not any(exact);qz=not any(qcross)
    if z:degenerates.append(domain)
    elif qz:stats['new_quantized_degenerate'].append([oi,ti,domain])
    elif sum(a*b for a,b in zip(exact,qcross))<=0:stats['orientation_reversals'].append([oi,ti,domain])
   if degenerates:stats['source_degenerate'].append([oi,ti,degenerates])
   stats['max_nearest_source_hint_distance_local']=max(stats['max_nearest_source_hint_distance_local'],t['nearest_source_distance_local']);near.append(t['nearest_source_distance_local'])
   part['triangles'].append({'vertices':outix,'source_lod_triangle_index':ti,'source_evaluated_polygon_id':t['local_face_id'],'static_degenerate_domains':degenerates,'nearest_original_face_hint':{'triangle_id':t['nearest_source_evaluated_triangle'],'distance_local':t['nearest_source_distance_local'],'exact_correspondence':False}})
   for a,b in [(0,1),(1,2),(2,0)]:
    edge=tuple(sorted([tuple(o['vertices_world_metres'][ix[a]]),tuple(o['vertices_world_metres'][ix[b]])]));qe=tuple(sorted([tuple(world[ix[a]]),tuple(world[ix[b]])]));require(edge not in seenedge or seenedge[edge]==qe,'shared edge inconsistency');seenedge[edge]=qe;edgeparts[(oi,*sorted([ix[a],ix[b]]))].add(part['part_id'])
  objects.append(obj)
 require(not stats['new_quantized_degenerate'] and not stats['orientation_reversals'],'quantization changed topology/orientation')
 require(all(len(p['vertices'])<=32 and len(p['triangles'])<=64 for p in parts),'partition limit')
 vp=sum(len(p['vertices']) for p in parts);np=len(parts);nt=1982;nb=sum((len(p['vertices'])+7)//8 for p in parts)
 stats.update({'objects':len(objects),'source_vertices':sum(o['source_vertex_count'] for o in objects),'partition_vertices':vp,'parts':np,'triangles':nt,'source_degenerate_count':len(stats['source_degenerate']),'nondegenerate_triangles':nt-len(stats['source_degenerate']),'max_vertices_per_part':max(len(p['vertices']) for p in parts),'max_triangles_per_part':max(len(p['triangles']) for p in parts),'shared_source_vertices_across_parts':sum(len(v)>1 for v in identityparts.values()),'shared_source_edges_across_parts':sum(len(v)>1 for v in edgeparts.values()),'unique_world_coordinates':len(seenpos),'unique_physical_edges':len(seenedge),'quantized_position_collision_groups':sum(len(v)>1 for v in qgroups.values()),'max_source_positions_per_quantized_code':max(map(len,qgroups.values())),'padded_8lane_blocks':nb,'memory_formula':{'audit_layout_unpadded':'64 header +64*parts +40*partition_vertices +8*triangles','audit_layout_bytes':64+64*np+40*vp+8*nt,'audit_layout_8lane_bytes':64+64*np+40*8*nb+8*nt,'minimal_xyz_localxz_normal_unpadded':'64 header +64*parts +26*partition_vertices +8*triangles (packing only, excludes identity/deferred data)','minimal_unpadded_bytes':64+64*np+26*vp+8*nt,'not_total_runtime_memory':True}})
 deferred={'material_source_graphs':s['material_source_graphs'],'controls':s['controls'],'frame':s['frame'],'rig_rest':s['rig_rest'],'objects':[{'id':i,'name':o['name'],'uv_layers_unbound_loop_order':o['uv_layers'],'shape_keys_base_order':o['shape_keys'],'vertex_group_names':o['vertex_groups'],'vertex_group_weights_base_order':o['vertex_group_weights'],'remaining_modifiers':o['remaining_modifiers']} for i,o in enumerate(s['objects'])],'static_export_limitation':s['static_export_limitation'],'removed_hidden_assets':s['removed_hidden_assets']}
 return {'schema':'ayatsuri-fixed-attribute-ir-v1','source_blend_sha256':BLEND,'input_sidecar_sha256':PIN,'derived_label':s['derived_label'],'geometry_semantics':'evaluated neutral LOD, Blender world XYZ metres + own-object local XYZ; local XZ available to procedural recipe; no scale38','position_fraction_bits':f,'normal_divisor':32767,'rounding':'nearest ties even on binary64-scaled source; reject out of range; no saturation','ready_for_AYFQ_v1':False,'admission_blockers':['36 input neutral zero-area triangles retained, not removed','procedural color/transparent mask/Principled BSDF and animation unsupported','UV loop-to-triangle correspondence not established from input alone'],'objects':objects,'parts':parts,'deferred_high_precision_metadata':deferred,'stats':stats}

def write_new(path,x):
 p=pathlib.Path(path);require(p.parent.resolve()==HERE,'output directory');payload=canonical(x)+b'\n';fd,tmp=tempfile.mkstemp(dir=HERE,prefix='.ir-')
 try:
  with os.fdopen(fd,'wb') as f:f.write(payload);f.flush();os.fsync(f.fileno())
  os.link(tmp,p)
 finally:os.unlink(tmp)

def main():
 require(SOURCE.stat().st_size==1764502 and sha(SOURCE)==PIN,'input sidecar identity');source=loads(SOURCE.read_bytes());results=[]
 deriv=loads((ROOT/'fox-cardputer-latest-private/2k-v2-stats.json').read_bytes())
 for f in (16,20):
  ir=compile_ir(source,f);ir['derived_changes']={'stats_sha256':sha(ROOT/'fox-cardputer-latest-private/2k-v2-stats.json'),'removed_details':deriv['removed_details'],'clearance_offsets':deriv['clearance_offsets']};write_new(HERE/f'attributes-q{f}-v1.json',ir);results.append(ir['stats'])
 write_new(HERE/'results-v1.json',{'input_sha256':PIN,'source_blend_sha256':BLEND,'runs':results});print(json.dumps(results,indent=2))
if __name__=='__main__':main()
