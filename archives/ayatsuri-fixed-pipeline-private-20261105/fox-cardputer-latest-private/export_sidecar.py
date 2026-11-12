import bpy,json,pathlib,hashlib,sys
from mathutils import Vector
from mathutils.bvhtree import BVHTree
R=pathlib.Path(__file__).resolve().parent;S=R.parent/'latest-fox-source-readonly/fox-bubble-bold.blend'
label=sys.argv[-1] if '--' in sys.argv else '2k-v2'
bpy.ops.wm.open_mainfile(filepath=str(S));bpy.context.scene.frame_set(1);dep=bpy.context.evaluated_depsgraph_get();original={}
for o in bpy.context.scene.objects:
 if o.type not in ('MESH','CURVE') or o.hide_render or o.name=='Studio ground':continue
 e=o.evaluated_get(dep);me=e.to_mesh();me.calc_loop_triangles();v=[x.co.copy() for x in me.vertices];t=[tuple(x.vertices) for x in me.loop_triangles]
 original[o.name]=(BVHTree.FromPolygons(v,t,all_triangles=True),len(v),len(t));e.to_mesh_clear()
bpy.ops.wm.open_mainfile(filepath=str(R/f'fox-cardputer-{label}.blend'));sc=bpy.context.scene;sc.frame_set(1);dep=bpy.context.evaluated_depsgraph_get();rows=[];mats=set();driver_invalid=[]
def simple(x):
 if isinstance(x,(int,float,str,bool)):return x
 try:return list(x)
 except:return str(x)
for o in sc.objects:
 if o.type not in ('MESH','CURVE') or o.hide_render or o.name=='Studio ground':continue
 e=o.evaluated_get(dep);me=e.to_mesh(preserve_all_data_layers=True,depsgraph=dep);me.calc_loop_triangles();mat=o.matrix_world;nmat=mat.to_3x3().inverted().transposed();tree=original[o.name][0]
 row={'name':o.name,'parent':o.parent.name if o.parent else None,'matrix_world':[list(r) for r in mat],'vertices_local':[list(v.co) for v in me.vertices],'vertices_world_metres':[list(mat@v.co) for v in me.vertices],'triangles':[],'materials':[m.name if m else None for m in me.materials],'attributes':{}}
 mats.update(x for x in row['materials'] if x)
 for t in me.loop_triangles:
  co=sum((me.vertices[i].co for i in t.vertices),Vector())/3;nearest=tree.find_nearest(co)
  row['triangles'].append({'vertices':list(t.vertices),'local_face_id':t.polygon_index,'material_slot':t.material_index,'corner_normals_world':[list((nmat@me.corner_normals[i].vector).normalized()) for i in t.loops],'corner_normals_local':[list(me.corner_normals[i].vector) for i in t.loops],'nearest_source_evaluated_triangle':nearest[2],'nearest_source_distance_local':nearest[3]})
 for at in me.color_attributes:
  row['attributes'][at.name]={'domain':at.domain,'data_type':at.data_type,'rgba_linear':[list(v.color) for v in at.data]}
 row['uv_layers']={u.name:[list(v.uv) for v in u.data] for u in me.uv_layers}
 row['shape_keys']={b.name:[list(x.co) for x in b.data] for b in o.data.shape_keys.key_blocks} if o.type=='MESH' and o.data.shape_keys else {}
 row['vertex_groups']=[v.name for v in o.vertex_groups]
 row['vertex_group_weights']=[[[g.group,g.weight] for g in v.groups] for v in o.data.vertices] if o.type=='MESH' else []
 row['remaining_modifiers']=[{'name':m.name,'type':m.type,'target':getattr(m,'object',None).name if getattr(m,'object',None) else None} for m in o.modifiers]
 for thing in [o,o.data.shape_keys if o.type=='MESH' else None]:
  if thing and thing.animation_data:
   for d in thing.animation_data.drivers:
    if not d.is_valid:driver_invalid.append({'id':thing.name,'path':d.data_path})
 rows.append(row);e.to_mesh_clear()
inv=json.load(open(R.parent/'ayatsuri-latest-fixed-source-20261105/inventory.json'))
controls=bpy.data.objects['Expression Controls'];bones=[]
for o in sc.objects:
 if o.type=='ARMATURE':bones.append({'object':o.name,'bones':[{'name':b.name,'parent':b.parent.name if b.parent else None,'matrix_local':[list(r) for r in b.matrix_local]} for b in o.data.bones]})
result={'schema':'fox-neutral-evaluated-sidecar-v1','source_sha256':hashlib.sha256(S.read_bytes()).hexdigest(),'source_library_id':'libfile_4dee400f3a7c819184d5fcc2a4953de9','derived_label':label,'frame':1,'controls':{k:simple(controls[k]) for k in controls.keys() if k!='_RNA_UI'},'coordinate_contract':'Blender world metres and original object-local coordinates. No legacy x38, no early RGB565, no claim of AYFQ compatibility. Per-eye shader reads own local X,Z.','objects':rows,'material_source_graphs':[m for m in inv['materials'] if m['name'] in mats],'rig_rest':bones,'invalid_drivers':driver_invalid,'static_export_limitation':'Geometry and normal arrays are evaluated neutral state only. Morph arrays, rig metadata and original shader graphs retained for future implementation, not a working animated Cardputer asset.','removed_hidden_assets':'Hidden legacy meshes/old iris gradient retained in immutable original only, not silently drawn.'}
out=R/f'{label}-neutral-sidecar.json';out.write_text(json.dumps(result,ensure_ascii=False,separators=(',',':')))
print('EXPORTED',out,len(rows),sum(len(x['triangles']) for x in rows),sum(len(x['vertices_local']) for x in rows),'invalid',driver_invalid,flush=True)
