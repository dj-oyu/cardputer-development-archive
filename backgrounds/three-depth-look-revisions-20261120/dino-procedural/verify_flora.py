import bpy,hashlib,json,sys
from pathlib import Path
base=Path(bpy.data.filepath).resolve()
scene=bpy.context.scene
parents=[o for o in scene.objects if any(m.type=='NODES' for m in o.modifiers)]
assert len(parents)==3
d=bpy.context.evaluated_depsgraph_get()
counts={k.name:0 for k in parents}
for inst in d.object_instances:
    if inst.is_instance and inst.parent and inst.parent.name in counts:
        counts[inst.parent.name]+=1
assert min(counts.values())>0,counts
groups={}
for o in parents:
    nt=next(m.node_group for m in o.modifiers if m.type=='NODES')
    groups[o.name]=[n.bl_idname for n in nt.nodes]
    assert 'GeometryNodeDistributePointsOnFaces' in groups[o.name]
    assert 'GeometryNodeInstanceOnPoints' in groups[o.name]
receipt={'sha256':hashlib.sha256(base.read_bytes()).hexdigest(),'geometry_nodes_groups':groups,'evaluated_instances':counts,'viewport_resolution':[scene.render.resolution_x,scene.render.resolution_y],'no_addons_required':True}
p=Path(sys.argv[-1]);p.write_text(json.dumps(receipt,indent=2)+'\n');print(receipt)
