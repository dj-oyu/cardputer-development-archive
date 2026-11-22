"""Emit geometry and rig fingerprint (portal material intentionally excluded)."""
import bpy,json,hashlib
s=bpy.context.scene;s.frame_set(1)
c=bpy.data.collections['Gaming Chair Prop']
portal=next(o for o in c.objects if o.name.startswith('Rear aperture'))
dg=bpy.context.evaluated_depsgraph_get()
inventory={};ch=hu=0
for o in sorted(s.objects,key=lambda o:o.name):
 if o.type=='MESH' and not o.name.startswith('Preview floor') and not o.hide_render:
    ob=o.evaluated_get(dg);m=ob.to_mesh();m.calc_loop_triangles()
    t=len(m.loop_triangles)
    if o.name in c.all_objects:ch+=t
    else:hu+=t
    inventory[o.name]={'evaluated':[(tuple(v.co),[(g.group,g.weight) for g in v.groups]) for v in m.vertices],'tri':[(tuple(t.vertices),t.material_index) for t in m.loop_triangles],'matrix':[list(r) for r in ob.matrix_world],'uv':{uv.name:[tuple(d.uv) for d in uv.data] for uv in m.uv_layers}}
    ob.to_mesh_clear()
 if o.type=='ARMATURE':inventory[o.name]={'bones':{b.name:[list(r) for r in b.matrix] for b in o.pose.bones},'action':o.animation_data.action.name if o.animation_data and o.animation_data.action else None}
data=json.dumps(inventory,sort_keys=True).encode()
imgs={n.image.name:hashlib.sha256(n.image.packed_file.data).hexdigest() for n in portal.active_material.node_tree.nodes if n.type=='TEX_IMAGE'}
print('INVARIANT',json.dumps({'geometry_pose_uv_weights_sha256':hashlib.sha256(data).hexdigest(),'human_triangles':hu,'chair_triangles':ch,'total_triangles':hu+ch,'actions':sorted(a.name for a in bpy.data.actions),'portal_source_textures':imgs},sort_keys=True))
