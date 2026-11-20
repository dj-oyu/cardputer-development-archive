"""Check authored rig identity, patch handedness/adhesion and source independence."""
import bpy,sys,json,math,hashlib
from pathlib import Path
from mathutils import Vector,Quaternion
from mathutils.bvhtree import BVHTree
p0,p1=map(Path,sys.argv[-2:])
def M(m):return [[float(x) for x in row] for row in m]
def get(path):
 bpy.ops.wm.open_mainfile(filepath=str(path.resolve()))
 s=bpy.context.scene
 rig=next(o for o in s.objects if o.type=='ARMATURE')
 action=rig.animation_data.action
 bones={b.name:[M(b.matrix_local),b.parent.name if b.parent else None] for b in rig.data.bones}
 curves={str((f.data_path,f.array_index)):[(tuple(k.co),tuple(k.handle_left),tuple(k.handle_right),k.interpolation) for k in f.keyframe_points] for f in action.fcurves}
 poses={}
 for i in (1,15,30):
  s.frame_set(i);bpy.context.view_layer.update()
  poses[i]={b.name:M(b.matrix) for b in rig.pose.bones}
 s.frame_set(1)
 body={}
 for o in s.objects:
  if o.type!='MESH' or not o.modifiers.get('Provisional joint continuity'):continue
  if o.users_collection[0].name not in ('Jacket and T-shirt','Shorts','Boots'):
   body[o.name]=[tuple(o.matrix_world@v.co) for v in o.data.vertices]
 return s,rig,bones,curves,poses,body
_,_,base_rig,base_curves,base_pose,base_mesh=get(p0)
s,r,rig,curves,poses,me=get(p1)
assert rig==base_rig and curves==base_curves and poses==base_pose and me==base_mesh
assert not [a for a in bpy.data.images if a.source in ('FILE','MOVIE','SEQUENCE')]
badges=[o for o in s.objects if o.name.startswith('Right sleeve ')]
assert len(badges)==3 and len([o for o in badges if 'lightning' in o.name])==1
for o in badges:
 assert o.modifiers['Provisional joint continuity'].object==r
 for v in o.data.vertices:
  assert (o.matrix_world@v.co).x<-.50
  assert len(v.groups)==1 and o.vertex_groups[v.groups[0].group].name=='upper-arm.R' and abs(v.groups[0].weight-1)<1e-6
bounds={}
for label,angle in [('neutral',0),('elbow95',-95)]:
 r.animation_data_clear()
 for b in r.pose.bones:
  b.matrix_basis.identity()
 for side in 'LR':
  b=r.pose.bones['forearm.'+side]
  b.rotation_mode='XYZ'
  axis=b.bone.matrix_local.to_3x3().inverted()@Vector((1,0,0))
  b.rotation_euler=Quaternion(axis,math.radians(angle)).to_euler()
 bpy.context.view_layer.update()
 dg=bpy.context.evaluated_depsgraph_get()
 def pts(o):
  eo=o.evaluated_get(dg); mm=eo.to_mesh()
  out=[eo.matrix_world@v.co for v in mm.vertices],[tuple(p.vertices) for p in mm.polygons];eo.to_mesh_clear()
  return out
 z=bpy.data.objects['Long ivory varsity sleeve and forest cuff.R'];v,f=pts(z)
 tr=BVHTree.FromPolygons(v,f)
 bounds[label]={}
 for o in badges:
  v,_=pts(o)
  d=[tr.find_nearest(p)[3] for p in v]
  assert max(d)<.06
  bounds[label][o.name]=[round(min(d),6),round(max(d),6)]
tris=0
for o in s.objects:
 if o.type=='MESH' and o.modifiers.get('Provisional joint continuity'):
  o.data.calc_loop_triangles(); tris+=len(o.data.loop_triangles)
jacket_mats=sorted({m.name for o in s.objects if o.users_collection[0].name=='Jacket and T-shirt' and o.type=='MESH' for m in o.data.materials})
stats=dict(sha256=hashlib.sha256(p1.read_bytes()).hexdigest(),rig_bones=len(rig),unchanged_original_actions=len(curves),verified_frames=[1,15,30],unchanged_non_outfit_meshes=len(me),raw_bound_triangles=tris,patch_objects=[o.name for o in badges],anatomical_side='upper-arm.R / X negative',patch_vertex_distance_to_sleeve=bounds,jacket_materials=jacket_mats)
(p1.parent/'varsity-integrity.json').write_text(json.dumps(stats,indent=2)+'\n')
print(stats)
