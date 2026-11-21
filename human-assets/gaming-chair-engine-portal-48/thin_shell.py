"""Apply thin shell dimensions to the existing portal, without modifying its shader.
blender -b ../cardputer-gaming-chair-portal-47/human-chair-portal-47.blend --python thin_shell.py -- thin-shell.blend
"""
import bpy,sys,json
from mathutils import Vector
from mathutils.bvhtree import BVHTree
from pathlib import Path
C=bpy.data.collections['Gaming Chair Prop']
shell=next(o for o in C.objects if o.name.startswith('Engine chair'))
portal=next(o for o in C.objects if o.name.startswith('Rear aperture'))
marks=[o for o in C.objects if o.name.startswith('Dash')]
front=lambda z:.39+.285*(z-1.6)
depths={.365:.22,.135:.115}
counts={k:0 for k in depths}
def bvh(o,dg=None):
    if dg:
        ob=o.evaluated_get(dg);m=ob.to_mesh()
    else:ob=o;m=o.data
    tree=BVHTree.FromPolygons([ob.matrix_world@v.co for v in m.vertices],[tuple(p.vertices) for p in m.polygons])
    if dg:ob.to_mesh_clear()
    return tree
def measure(tree,x=.635,z=2.73):
    f=tree.ray_cast(Vector((x,-3,z)),Vector((0,1,0)))[0]
    r=tree.ray_cast(Vector((x,3,z)),Vector((0,-1,0)))[0]
    assert f is not None and r is not None
    return {'x':x,'z':z,'front_y':f.y,'rear_y':r.y,'depth_y':r.y-f.y}
s=bpy.context.scene;s.frame_set(1);bpy.context.view_layer.update()
dg=bpy.context.evaluated_depsgraph_get()
human={o.name:bvh(o,dg) for o in s.objects if o.type=='MESH' and o.name not in C.all_objects and not o.name.startswith('Preview floor')}
def hits(tree):
    return {n:len(res) for n,h in human.items() if (res:=tree.overlap(h))}
before=bvh(shell)
for v in shell.data.vertices:
    d=v.co.y-front(v.co.z)
    for old,new in depths.items():
        if abs(d-old)<1e-5:
            counts[old]+=1;v.co.y+=new-old;break
assert list(counts.values())==[28,14],counts
shell.data.update()
for o in marks:
    for v in o.data.vertices:v.co.y-=.145
    o.data.update()
for v in portal.data.vertices:v.co.y-=.023
portal.data.update()
C['physical_backrest_thickness_bu']=.22
C['physical_aperture_wall_depth_bu']=.105
bpy.context.view_layer.update()
after=bvh(shell)
stats={'before':measure(before),'after':measure(after),'moved_shell_vertices':counts,'contacts_before':hits(before),'contacts_after':hits(after)}
assert stats['contacts_before']==stats['contacts_after'],stats
assert abs(stats['before']['front_y']-stats['after']['front_y'])<1e-5
print('THINNING',json.dumps(stats))
out=Path(sys.argv[-1]).resolve()
out.with_suffix('.json').write_text(json.dumps(stats,ensure_ascii=False,indent=2)+'\n')
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
