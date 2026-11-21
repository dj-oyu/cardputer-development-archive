import bpy, json, hashlib
from pathlib import Path
s=bpy.context.scene;dg=bpy.context.evaluated_depsgraph_get()
c=bpy.data.collections['Gaming Chair Prop']
def tri(o):
    e=o.evaluated_get(dg);m=e.to_mesh();m.calc_loop_triangles();n=len(m.loop_triangles);e.to_mesh_clear();return n
ch={o.name:tri(o) for o in c.all_objects if o.type=='MESH'}
human=sum(tri(o) for o in s.objects if o.type=='MESH' and o.name not in ch and 'floor' not in o.name.lower() and not o.hide_render)
portal=next(o for o in c.objects if o.name.startswith('Rear aperture'))
imgs=[n.image for n in portal.active_material.node_tree.nodes if n.type=='TEX_IMAGE']
assert len(imgs)==3 and all(i.packed_file for i in imgs)
assert sum(ch.values())==370 and human==1913,(ch,human)
print(json.dumps({'chair_triangles':sum(ch.values()),'human_triangles':human,'all':sum(ch.values())+human,'by_chair_object':ch,'bones':sum(len(o.data.bones) for o in s.objects if o.type=='ARMATURE'),'actions':[a.name for a in bpy.data.actions],'packed_portal':{i.name:hashlib.sha256(i.packed_file.data).hexdigest() for i in imgs}},ensure_ascii=False))
