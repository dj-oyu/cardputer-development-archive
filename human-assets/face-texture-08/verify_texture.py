"""Verify the geometry, authored motion, internal texture and lock to the head."""
import bpy,sys,json,hashlib
from pathlib import Path
from mathutils import Vector
p0,p1=map(Path,sys.argv[-2:]); p0,p1=p0.resolve(),p1.resolve()
def check(path):
 bpy.ops.wm.open_mainfile(filepath=str(path))
 s=bpy.context.scene;r=next(o for o in s.objects if o.type=='ARMATURE')
 pose={}
 for f in (1,15,30):
  s.frame_set(f);bpy.context.view_layer.update()
  pose[f]={b.name:tuple(tuple(row) for row in b.matrix) for b in r.pose.bones}
 s.frame_set(1);bpy.context.view_layer.update()
 rig={b.name:(b.parent.name if b.parent else None,tuple(tuple(row) for row in b.matrix_local)) for b in r.data.bones}
 act={str((fc.data_path,fc.array_index)):[(tuple(key.co),tuple(key.handle_left),tuple(key.handle_right),key.interpolation) for key in fc.keyframe_points] for fc in r.animation_data.action.fcurves}
 def geometry(o):
  o.data.calc_loop_triangles()
  return ([tuple(v.co) for v in o.data.vertices],[tuple(poly.vertices) for poly in o.data.polygons],[[[o.vertex_groups[g.group].name,g.weight] for g in v.groups] for v in o.data.vertices],len(o.data.loop_triangles))
 ge={o.name:geometry(o) for o in s.objects if o.type=='MESH' and o.modifiers.get('Provisional joint continuity')}
 return s,r,pose,rig,act,ge
a=check(p0)
b=check(p1)
assert a[2:]==b[2:]
sk=bpy.data.objects['Sculpted cheeks, jaw and cranium']
assert len(sk.data.uv_layers)==1 and sk.data.uv_layers[0].name=='FaceGraphic_Ortho_512'
points=[]
for loop in sk.data.loops:
  p=sk.matrix_world@sk.data.vertices[loop.vertex_index].co
  expected=(.5+p.x/2.24,.5+(p.z-4.78)/2.24)
  real=tuple(sk.data.uv_layers[0].data[loop.index].uv)
  points.append(max(abs(v-w) for v,w in zip(expected,real)))
assert max(points)<1e-6
img=next(i for i in bpy.data.images if i.name.startswith('Packed face graphic'))
assert img.packed_file and img.packed_file.size>0
assert len([i for i in bpy.data.images if i.source in ('FILE','MOVIE','SEQUENCE')])==1
assert {sk.vertex_groups[g.group].name for v in sk.data.vertices for g in v.groups}=={'head'}
assert all(len(v.groups)==1 and v.groups[0].weight==1. for v in sk.data.vertices)
s,r=b[:2]
h=r.pose.bones['head']; initial=h.rotation_mode;h.rotation_mode='XYZ'; old=h.rotation_euler.copy()
r.animation_data_clear()
def evaluated():
 bpy.context.view_layer.update()
 d=bpy.context.evaluated_depsgraph_get()
 o=sk.evaluated_get(d);m=o.to_mesh()
 vs=[tuple(v.co) for v in m.vertices];uvs=[tuple(q.uv) for q in m.uv_layers['FaceGraphic_Ortho_512'].data];o.to_mesh_clear()
 return vs,uvs
before, uv0=evaluated()
h.rotation_euler.z+=.32
after, uv1=evaluated()
assert uv0==uv1 and before!=after
evidence={'blank_sha256':hashlib.sha256(p0.read_bytes()).hexdigest(),'blend_sha256':hashlib.sha256(p1.read_bytes()).hexdigest(),'shared_mesh_count':len(b[5]),'bound_mesh_triangles':sum(t[-1] for t in b[5].values()),'rig_bones':len(b[3]),'authored_curve_count':len(b[4]),'verified_pose_frames':[1,15,30],'max_uv_mapping_error':max(points),'head_rotation_check_degrees':.32*180/3.141592653589793,'packed_image_bytes':img.packed_file.size,'packed_bytes_sha256':hashlib.sha256(img.packed_file.data).hexdigest()}
(p1.parent/'texture-integrity.json').write_text(json.dumps(evidence,indent=2)+'\n')
print(evidence)
