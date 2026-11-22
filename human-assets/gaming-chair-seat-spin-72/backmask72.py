"""Authorized rearrest-only override pass. Same virtual phase, camera and saved seat as main."""
import bpy,math,json
from pathlib import Path
from mathutils import Vector
P=Path(__file__).resolve().parent;s=bpy.context.scene
g=bpy.data.collections['Gaming Chair Prop'];o=next(o for o in g.objects if o.name.startswith('Engine chair'))
source=o.data
A=[[] for _ in source.vertices]
for e in source.edges:
 u,v=e.vertices;A[u].append(v);A[v].append(u)
todo=[0];chosen={0}
while todo:
 for j in A[todo.pop()]:
  if j not in chosen:chosen.add(j);todo.append(j)
vertices=sorted(chosen);remap={a:b for b,a in enumerate(vertices)}
polys=[p for p in source.polygons if all(k in chosen for k in p.vertices)]
assert len(vertices)==56 and len(polys)==43,(len(vertices),len(polys))
mesh=bpy.data.meshes.new('Rearrest pass / actual physically modeled rear shell')
mesh.from_pydata([source.vertices[i].co for i in vertices],[],[tuple(remap[i] for i in p.vertices) for p in polys]);mesh.update()
for m in source.materials:mesh.materials.append(m)
for a,b in zip(mesh.polygons,polys):a.material_index=b.material_index;a.use_smooth=b.use_smooth
mesh.calc_loop_triangles();assert len(mesh.loop_triangles)==96
back=bpy.data.objects.new('CAUSAL MASK · rear shell only',mesh);s.collection.objects.link(back)
back.visible_diffuse=False;back.visible_glossy=False;back.visible_transmission=False;back.visible_shadow=False;back.visible_volume_scatter=False
for obj in s.objects:
 if obj.type=='MESH' and obj!=back and not obj.name.startswith(('Rear aperture','Dash •')):
  # Do not change indirect illumination, actual scene pose, or source geometry.
  obj.visible_camera=False
s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA'
s.render.image_settings.file_format='PNG'
(P/'rearlayer').mkdir(exist_ok=True)
info={}
for i in range(1,145):
 s.frame_set(i);bpy.context.view_layer.update()
 deps=bpy.context.evaluated_depsgraph_get();M=o.evaluated_get(deps).matrix_world.copy()
 eye=M.inverted()@s.camera.evaluated_get(deps).matrix_world.translation
 dir=(eye-Vector((0,.6,2.43))).normalized()
 n=Vector((0,1,-.285)).normalized()
 facing=dir.dot(n)
 go=facing>.20
 info[i]={'rear_facing_dot':facing,'overlay':go}
 if not go:continue
 back.matrix_world=M;bpy.context.view_layer.update()
 s.render.filepath=str(P/'rearlayer'/f'back-{i:04d}.png')
 bpy.ops.render.render(write_still=True)
(P/'rear-eligibility.json').write_text(json.dumps(info,indent=2)+'\n')
