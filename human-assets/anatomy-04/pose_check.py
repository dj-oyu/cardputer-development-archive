import bpy,sys,math,hashlib,json
from pathlib import Path
from mathutils import Vector, Quaternion
source,out=map(Path,sys.argv[-2:])
assert source.suffix=='.blend'
bpy.ops.wm.open_mainfile(filepath=str(source.resolve()))
s=bpy.context.scene
rig=next(o for o in s.objects if o.type=='ARMATURE')
s.frame_set(1)
rig.animation_data_clear()
bpy.context.view_layer.update()
bones=rig.pose.bones
rest={b.name:b.matrix.copy() for b in bones}
def reset():
 for b in bones: b.matrix_basis.identity()
 bpy.context.view_layer.update()
def geometry():
 bpy.context.view_layer.update()
 dg=bpy.context.evaluated_depsgraph_get(); result={}
 for o in s.objects:
  if o.type!='MESH' or not o.modifiers.get('Provisional joint continuity'):continue
  e=o.evaluated_get(dg); m=e.to_mesh()
  v=[e.matrix_world@v.co for v in m.vertices]
  result[o.name]=(v,[(v[i]-v[j]).length for i,j in (x.vertices for x in m.edges)])
  e.to_mesh_clear()
 return result
base=geometry()
def bend():
 for n,angle in [('forearm.L',-95),('forearm.R',-95)]:
  b=bones[n]; axis=b.bone.matrix_local.to_3x3().inverted()@Vector((1,0,0))
  b.rotation_euler=Quaternion(axis,math.radians(angle)).to_euler()
 bpy.context.view_layer.update()
def plant(dx=.16,dz=-.16):
 b=bones['pelvis']; mat=b.matrix.copy();mat.translation+=Vector((dx,0,dz));b.matrix=mat
 bpy.context.view_layer.update()
 for side in 'LR':
  t,k,f=[bones[n+'.'+side] for n in ('thigh','shin','foot')]
  h=t.head.copy(); a=rest[f.name].translation
  v=(a-h).normalized(); dist=(a-h).length
  l,m=t.length,k.length
  along=(l*l-m*m+dist*dist)/(2*dist)
  # Natural forward knee pole (front = -Y); maintain original foot roll.
  fw=Vector((0,-1,0)); pole=(fw-fw.dot(v)*v).normalized()
  knee=h+along*v+math.sqrt(max(0,l*l-along*along))*pole
  def steer(b,end):
   shift=(b.tail-b.head).rotation_difference(end-b.head)
   mat=shift.to_matrix().to_4x4()@b.matrix;mat.translation=b.head.copy()
   b.matrix=mat;bpy.context.view_layer.update()
  steer(t,knee);steer(k,a); f.matrix=rest[f.name]
  bpy.context.view_layer.update()
s.render.engine='CYCLES';s.cycles.samples=48
s.cycles.use_denoising=False
s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA'
s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
cam=s.camera;cam.data.type='ORTHO';cam.data.ortho_scale=10.6
for o in s.objects:
 if o.name.startswith('Preview floor'):o.hide_render=True
report={}
for label,action in [('rest',lambda:None),('deep',bend),('plant',plant)]:
 reset();action()
 now=geometry()
 report[label]={'stretch':{n:round(max(b/a for a,b in zip(base[n][1],now[n][1]) if a>1e-4),3) for n in base},'feet':{}}
 for side in 'LR':
  ft=bones['foot.'+side]
  report[label]['feet'][side]=float((ft.head-rest[ft.name].translation).length)
 report[label]['sole']={}
 for n in base:
  if 'sole' not in n.lower():continue
  orig,new=base[n][0],now[n][0]
  report[label]['sole'][n]={'max_vertex_drift':max((a-b).length for a,b in zip(orig,new)),'lowest_z_delta':min(v.z for v in new)-min(v.z for v in orig)}
 for ang,view in ([] if '--metrics-only' in sys.argv else [(0,'front'),(-32,'oblique'),(-90,'profile')]):
  t=math.radians(ang)
  cam.location=(math.sin(t)*13,-math.cos(t)*13,3.45)
  cam.rotation_euler=(Vector((0,0,2.79))-cam.location).to_track_quat('-Z','Y').to_euler()
  s.render.filepath=str((out/f'{label}-{view}.png').resolve())
  bpy.ops.render.render(write_still=True)
(out/'report.json').write_text(json.dumps(report,indent=2)+'\n')
