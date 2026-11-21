"""Optional fixed-chair export optimization. v66 closed editable master unchanged."""
from pathlib import Path
import bpy,bmesh
P=Path(__file__).resolve().parent;s=bpy.context.scene
chair=next(o for o in s.objects if o.name.startswith('Engine chair • shell'));m=chair.data
assert len(m.polygons)==145 and len(m.vertices)==212
ids=(88,102,116,130)
assert all(m.polygons[i].material_index==5 and len(m.polygons[i].vertices)==4 for i in ids)
bm=bmesh.new();bm.from_mesh(m);bm.faces.ensure_lookup_table()
bmesh.ops.delete(bm,geom=[bm.faces[i] for i in ids],context='FACES_ONLY')
bm.to_mesh(m);bm.free();m.update()
r=[]
for o in bpy.data.collections['Gaming Chair Prop'].all_objects:
 if o.type!='MESH':continue
 o.data.calc_loop_triangles();r.append(len(o.data.loop_triangles))
assert sum(r)==330
print('TOTAL',r,sum(r))
s['chair_internal_export_67']='Four caster shoulder quads fully enclosed in the fixed hull of matching spokes. Wheel parts must stay at same relative transform; use closed 338 master for editing.'
bpy.context.preferences.filepaths.save_version=0;bpy.ops.wm.save_as_mainfile(filepath=str(P/'chair-v67-hidden-caster-export.blend'),compress=True)
