"""Reopen and compare topology, authored actions, UVs and exact packed slots."""
from pathlib import Path
import bpy,sys,hashlib,json
base,out,eyes,mouth=map(Path,sys.argv[-4:])
def snapshot(p):
 bpy.ops.wm.open_mainfile(filepath=str(p.resolve()));s=bpy.context.scene;s.frame_set(1)
 rig=next(o for o in s.objects if o.type=='ARMATURE'); head=bpy.data.objects['Sculpted cheeks, jaw and cranium']
 bones={b.name:(b.parent.name if b.parent else None,tuple(tuple(r) for r in b.matrix_local)) for b in rig.data.bones}
 act={str((c.data_path,c.array_index)):[(tuple(k.co),tuple(k.handle_left),tuple(k.handle_right),k.interpolation) for k in c.keyframe_points] for c in rig.animation_data.action.fcurves}
 poses={}
 for f in (1,15,30):
  s.frame_set(f);bpy.context.view_layer.update()
  poses[f]={b.name:tuple(tuple(row) for row in b.matrix) for b in rig.pose.bones}
 uv=tuple(tuple(p.uv) for p in head.data.uv_layers['FaceGraphic_Ortho_512'].data)
 ge={}
 for o in s.objects:
  if o.type!='MESH' or not o.modifiers.get('Provisional joint continuity'):continue
  o.data.calc_loop_triangles()
  ge[o.name]=(tuple(tuple(v.co) for v in o.data.vertices),tuple(tuple(f.vertices) for f in o.data.polygons),
              tuple(tuple((o.vertex_groups[g.group].name,g.weight) for g in v.groups) for v in o.data.vertices),len(o.data.loop_triangles))
 im={i.name:hashlib.sha256(i.packed_file.data).hexdigest() for i in bpy.data.images if i.packed_file}
 return [bones,act,poses,uv,ge],im,dict((name,rig.get(name)) for name in ('Face Blink','Face Smile'))
old,oldim,_=snapshot(base)
new,newim,props=snapshot(out)
assert old==new
assert all(newim.get(k)==v for k,v in oldim.items())
assert newim['Packed face blink']==hashlib.sha256(eyes.read_bytes()).hexdigest()
assert newim['Packed face smile']==hashlib.sha256(mouth.read_bytes()).hexdigest()
assert props=={'Face Blink':0.,'Face Smile':0.}
r={'source_sha256':hashlib.sha256(base.read_bytes()).hexdigest(),'output_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),
   'bones':len(new[0]),'action_channels':len(new[1]),'unchanged_pose_frames':[1,15,30],'uv_points_exact':len(new[3]),
   'bound_meshes_exact':len(new[4]),'bound_triangles_exact':sum(v[-1] for v in new[4].values()),'packed_assets_sha256':newim,'defaults':props}
(out.parent/'expressions-integrity.json').write_text(json.dumps(r,indent=2)+'\n')
print(r)
