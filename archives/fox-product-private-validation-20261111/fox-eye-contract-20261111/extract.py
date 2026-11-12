import bpy,json,pathlib,hashlib
R=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');O=R/'fox-eye-contract-20261111';S=R/'fixed-recovery/extracted/fox-cardputer-latest-private/fox-cardputer-2k-v2.blend'
bpy.ops.wm.open_mainfile(filepath=str(S));sc=bpy.context.scene;sc.frame_set(1);ctrl=bpy.data.objects['Expression Controls']
def mat(m): return [list(r) for r in m]
def drv(a):
 if not a or not a.animation_data:return []
 return [{'path':f.data_path,'index':f.array_index,'expression':f.driver.expression,'type':f.driver.type,'valid':f.is_valid,'variables':[{'name':v.name,'type':v.type,'targets':[{'id':t.id.name if t.id else None,'data_path':t.data_path}for t in v.targets]}for v in f.driver.variables]}for f in a.animation_data.drivers]
def val(v):
 try:return list(v)
 except:return v
mats=[]
for m in bpy.data.materials:
 if not m.use_nodes or not any(n.type=='BSDF_TRANSPARENT' for n in m.node_tree.nodes):continue
 ns=m.node_tree.nodes
 mats.append({'name':m.name,'drivers':drv(m.node_tree),'nodes':[{'name':n.name,'type':n.bl_idname,'blend_type':getattr(n,'blend_type',None),'color_ramp':{'interpolation':n.color_ramp.interpolation,'color_mode':n.color_ramp.color_mode,'hue_interpolation':n.color_ramp.hue_interpolation,'elements':[{'position':e.position,'color':list(e.color)}for e in n.color_ramp.elements]}if hasattr(n,'color_ramp')else None,'operation':getattr(n,'operation',None),'use_clamp':getattr(n,'use_clamp',None),'object':getattr(n,'object',None).name if getattr(n,'object',None) else None,'inputs':[{'id':s.identifier,'value':val(getattr(s,'default_value',None))}for s in n.inputs],'outputs':[{'id':s.identifier,'value':val(getattr(s,'default_value',None))}for s in n.outputs]}for n in ns],'links':[[l.from_node.name,l.from_socket.identifier,l.to_node.name,l.to_socket.identifier]for l in m.node_tree.links]})
visible=[o for o in sc.objects if o.type=='MESH' and not o.hide_render and o.name!='Studio ground']
objects=[{'name':o.name,'drivers':drv(o),'data_drivers':drv(o.data),'shape_drivers':drv(o.data.shape_keys),'shape_keys':[{'name':k.name,'relative_key':k.relative_key.name,'vertex_group':k.vertex_group,'slider_min':k.slider_min,'slider_max':k.slider_max,'mute':k.mute}for k in o.data.shape_keys.key_blocks] if o.data.shape_keys else []}for o in visible]
base={k:ctrl[k] for k in ctrl.keys() if k!='_RNA_UI'}
samples=[('blink_'+str(v),{'Blink Both':v})for v in [0,.25,.5,1]]+[('left',{'Blink -X':1}),('right',{'Blink +X':1}),('gaze_neg',{'Gaze X':-1,'Gaze Up':-1}),('gaze_pos',{'Gaze X':1,'Gaze Up':1})]+[('style_'+str(v),{'Eye Style':v})for v in [1,2]]
samples += [('blink_'+str(v),{'Blink Both':v})for v in [.01,.02,.98]]
fixtures=[]
for name,change in samples:
 for k,v in base.items():ctrl[k]=v
 for k,v in change.items():ctrl[k]=v
 ctrl.update_tag();sc.frame_set(1);bpy.context.view_layer.update();dg=bpy.context.evaluated_depsgraph_get();rows=[]
 for o in visible:
  e=o.evaluated_get(dg);me=e.to_mesh();me.calc_loop_triangles()
  rows.append({'name':o.name,'hide_render':e.hide_render,'matrix_world':mat(e.matrix_world),'vertices_local':[list(v.co)for v in me.vertices],'triangles':[list(t.vertices)for t in me.loop_triangles],'material_slots':[t.material_index for t in me.loop_triangles],'materials':[m.name if m else None for m in me.materials],'shape_values':{k.name:k.value for k in o.data.shape_keys.key_blocks}if o.data.shape_keys else {},'zero_area_triangles':[i for i,t in enumerate(me.loop_triangles)if t.area<1e-12]})
  e.to_mesh_clear()
 fixtures.append({'name':name,'controls':dict(base,**change),'material_driver_values':{m['name']:{n.name:n.outputs[0].default_value for n in bpy.data.materials[m['name']].node_tree.nodes if n.type=='VALUE'}for m in mats},'material_blink_values':{m['name']:bpy.data.materials[m['name']].node_tree.nodes['Blink driver'].outputs[0].default_value for m in mats if 'Blink driver' in bpy.data.materials[m['name']].node_tree.nodes},'objects':rows})
result={'source_sha256':hashlib.sha256(S.read_bytes()).hexdigest(),'blender_version':bpy.app.version_string,'materials':mats,'objects':objects,'controls':base,'control_ui':{k:ctrl.id_properties_ui(k).as_dict() for k in base},'fixtures':fixtures}
(O/'evaluated-contract.json').write_text(json.dumps(result,ensure_ascii=False,separators=(',',':')))
print('DONE',len(mats),len(visible),len(fixtures),flush=True)
