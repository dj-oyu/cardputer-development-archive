# Data-only Blender audit: no frame_set, depsgraph, evaluated_get, render, bake, save or embedded code.
import bpy,json,pathlib,sys
OUT=pathlib.Path(sys.argv[sys.argv.index('--')+1])
def val(x):
 if x is None or isinstance(x,(bool,int,float,str)):return x
 if isinstance(x,bpy.types.ID):return {'id':x.name,'type':x.bl_rna.identifier}
 try:return [val(v) for v in x]
 except TypeError:return str(type(x))
def props(x,names):return {n:val(getattr(x,n)) for n in names if hasattr(x,n)}
def anim(x):
 a=getattr(x,'animation_data',None)
 if not a:return None
 ds=[]
 for f in a.drivers:
  d=f.driver;ds.append({'data_path':f.data_path,'array_index':f.array_index,'type':d.type,'expression':d.expression,'use_self':d.use_self,'variables':[{'name':v.name,'type':v.type,'targets':[props(t,['id','data_path','bone_target','transform_type','transform_space','rotation_mode']) for t in v.targets]} for v in d.variables]})
 return {'action':a.action.name if a.action else None,'drivers':ds,'nla_tracks':[t.name for t in a.nla_tracks]}
def sockets(ns):
 return [{'name':s.name,'identifier':s.identifier,'type':s.bl_idname,'linked':s.is_linked,'default':val(s.default_value) if hasattr(s,'default_value') else None} for s in ns]
def tree(t):
 return {'name':t.name,'type':t.bl_idname,'animation':anim(t),'nodes':[{'name':n.name,'type':n.bl_idname,'label':n.label,'mute':n.mute,'properties':props(n,['operation','blend_type','distribution','vector_type','space','attribute_name','uv_map','data_type','use_clamp','clamp','interpolation','projection','extension','node_tree','object','image','invert','use_alpha','normalize']),'inputs':sockets(n.inputs),'outputs':sockets(n.outputs)} for n in t.nodes],'links':[{'from':l.from_node.name,'from_socket':l.from_socket.identifier,'to':l.to_node.name,'to_socket':l.to_socket.identifier,'valid':l.is_valid} for l in t.links]}
objects=[]
for o in bpy.data.objects:
 r={'name':o.name,'type':o.type,'parent':o.parent.name if o.parent else None,'parent_type':o.parent_type,'hide_render':o.hide_render,'transform':props(o,['location','rotation_mode','rotation_euler','rotation_quaternion','scale','matrix_world']),'animation':anim(o),'custom_properties':{k:val(o[k]) for k in o.keys() if k!='_RNA_UI'},'vertex_groups':[g.name for g in o.vertex_groups],'constraints':[dict(type=c.type,name=c.name,**props(c,['target','subtarget','influence','mute'])) for c in o.constraints],'modifiers':[dict(name=m.name,type=m.type,**props(m,['show_viewport','show_render','levels','render_levels','subdivision_type','object','vertex_group','use_deform_preserve_volume','use_vertex_groups','node_group'])) for m in o.modifiers]}
 if o.type=='MESH':
  m=o.data;r['mesh']={'name':m.name,'vertices':len(m.vertices),'edges':len(m.edges),'polygons':len(m.polygons),'fan_triangle_count':sum(max(0,len(p.vertices)-2) for p in m.polygons),'smooth_polygons':sum(p.use_smooth for p in m.polygons),'material_slots':[s.material.name if s.material else None for s in o.material_slots],'polygon_material_indices':sorted(set(p.material_index for p in m.polygons)),'uv_layers':[u.name for u in m.uv_layers],'attributes':[{'name':a.name,'data_type':a.data_type,'domain':a.domain} for a in m.attributes],'shape_keys':None,'animation':anim(m)}
  if m.shape_keys:r['mesh']['shape_keys']={'name':m.shape_keys.name,'use_relative':m.shape_keys.use_relative,'animation':anim(m.shape_keys),'blocks':[dict(name=k.name,value=k.value,slider_min=k.slider_min,slider_max=k.slider_max,mute=k.mute,vertex_group=k.vertex_group,relative_key=k.relative_key.name if k.relative_key else None) for k in m.shape_keys.key_blocks]}
 if o.type=='ARMATURE':r['armature']={'bones':[dict(name=b.name,parent=b.parent.name if b.parent else None,use_deform=b.use_deform) for b in o.data.bones],'pose_bones':[dict(name=b.name,**props(b,['location','rotation_mode','rotation_euler','rotation_quaternion','scale'])) for b in o.pose.bones]}
 if o.type=='CAMERA':r['camera']=props(o.data,['type','lens','ortho_scale','clip_start','clip_end','shift_x','shift_y','sensor_width','sensor_height'])
 if o.type=='LIGHT':r['light']=props(o.data,['type','shape','energy','color','size','size_y','spread','use_shadow','shadow_soft_size'])
 objects.append(r)
materials=[]
for m in bpy.data.materials:materials.append({'name':m.name,'properties':props(m,['use_nodes','diffuse_color','metallic','roughness','use_backface_culling','surface_render_method','use_transparent_shadow']),'animation':anim(m),'node_tree':tree(m.node_tree) if m.node_tree else None})
result={'source_path':bpy.data.filepath,'blender_version':bpy.app.version_string,'autoexec_enabled':bpy.context.preferences.filepaths.use_scripts_auto_execute,'autoexec_fail':bpy.app.autoexec_fail,'autoexec_fail_message':bpy.app.autoexec_fail_message,'current_scene':bpy.context.scene.name,'current_frame':bpy.context.scene.frame_current,'scenes':[{'name':s.name,'frame_current':s.frame_current,'frame_start':s.frame_start,'frame_end':s.frame_end,'camera':s.camera.name if s.camera else None,'world':s.world.name if s.world else None,'render':props(s.render,['engine','resolution_x','resolution_y','resolution_percentage','fps','film_transparent']),'view_settings':props(s.view_settings,['view_transform','look','exposure','gamma']),'animation':anim(s)} for s in bpy.data.scenes],'objects':objects,'materials':materials,'node_groups':[tree(g) for g in bpy.data.node_groups],'worlds':[{'name':w.name,'node_tree':tree(w.node_tree) if w.node_tree else None,'animation':anim(w)} for w in bpy.data.worlds],'images':[{'name':i.name,'source':i.source,'filepath':i.filepath,'packed':bool(i.packed_file)} for i in bpy.data.images],'libraries':[l.filepath for l in bpy.data.libraries],'embedded_texts':[{'name':t.name,'lines':len(t.lines),'use_module':t.use_module} for t in bpy.data.texts],'actions':[{'name':a.name,'frame_range':list(a.frame_range),'fcurves':[{'data_path':f.data_path,'array_index':f.array_index,'keyframes':len(f.keyframe_points),'modifiers':[m.type for m in f.modifiers]} for f in a.fcurves]} for a in bpy.data.actions],'safety':'Data only; autoexec disabled; no frame changes, evaluated graph, render, bake, export or save.'}
with OUT.open('x') as f:json.dump(result,f,indent=2,allow_nan=False)
print('AUDIT_COMPLETE',len(objects),len(materials),bpy.context.scene.frame_current)
