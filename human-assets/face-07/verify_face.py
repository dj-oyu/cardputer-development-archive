"""Verify face-only differences, rig action retention, head weighting and projections."""
import bpy,sys,json,hashlib
from pathlib import Path
source,target=map(Path,sys.argv[-2:])
def data(p):
 bpy.ops.wm.open_mainfile(filepath=str(p.resolve()))
 s=bpy.context.scene;r=next(o for o in s.objects if o.type=='ARMATURE')
 def mat(m):return tuple(tuple(row) for row in m)
 rig=[(b.name,mat(b.matrix_local),b.parent.name if b.parent else None) for b in r.data.bones]
 pose=[]
 for f in (1,15,30):
  s.frame_set(f);bpy.context.view_layer.update()
  pose.append([mat(b.matrix) for b in r.pose.bones])
 action=r.animation_data.action
 keyframes=[(fc.data_path,fc.array_index,[tuple(k.co) for k in fc.keyframe_points]) for fc in action.fcurves]
 body={}; count=0; head={}
 for o in s.objects:
  if o.type!='MESH' or not o.modifiers.get('Provisional joint continuity'):continue
  o.data.calc_loop_triangles();count+=len(o.data.loop_triangles)
  if o.users_collection[0].name=='Face and features':
   head[o.name]=len(o.data.loop_triangles)
   if o.name.startswith(('Soft ','Tapered','Amber border','Honey iris','Pupil','Clear round','Friendly closed','Short lower')):
    assert o.modifiers['Provisional joint continuity'].object==r
    assert all(len(v.groups)==1 and o.vertex_groups[v.groups[0].group].name=='head' and v.groups[0].weight==1. for v in o.data.vertices)
   continue
  body[o.name]=(mat(o.matrix_world),[tuple(v.co) for v in o.data.vertices],[tuple(f.vertices) for f in o.data.polygons],
                [tuple((o.vertex_groups[g.group].name,g.weight) for g in v.groups) for v in o.data.vertices],
                [m.name for m in o.data.materials],[f.material_index for f in o.data.polygons])
 assert not [i.name for i in bpy.data.images if i.source in ('FILE','MOVIE','SEQUENCE')]
 return rig,pose,keyframes,body,count,head
a,b=map(data,(source,target))
assert a[:4]==b[:4], 'The authoring rig, pose, motion, or a non-face mesh changed'
info={'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'output_sha256':hashlib.sha256(target.read_bytes()).hexdigest(),'verified_frames':[1,15,30],'rig_bones':len(b[0]),'action_channels':len(b[2]),'non_face_meshes_unchanged':len(b[3]),'triangles_before':a[4],'triangles_after':b[4],'face_mesh_triangles':b[5]}
(target.parent/'face-integrity.json').write_text(json.dumps(info,indent=2)+'\n')
print(info)
