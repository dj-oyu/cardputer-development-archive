import bpy,sys,math
from pathlib import Path
from mathutils import Vector,Quaternion
src,out=map(Path,sys.argv[-2:])
bpy.ops.wm.open_mainfile(filepath=str(src.resolve()),use_scripts=False)
s=bpy.context.scene;s.frame_set(1)
r=next(o for o in s.objects if o.type=='ARMATURE')
head=r.pose.bones['head'];rest=head.matrix_basis.copy()
out.mkdir(parents=True,exist_ok=True)
cam=s.camera
cam.data.type='ORTHO';cam.data.ortho_scale=2.24
s.render.engine='CYCLES';s.cycles.samples=24;s.cycles.use_denoising=False
s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA'
s.render.resolution_x=360;s.render.resolution_y=320;s.render.resolution_percentage=100
for ob in s.objects:
 if ob.name.startswith('Preview floor'):ob.hide_render=True
for yaw,pitch,ang in [(-20,-12,-90),(0,12,-35),(20,0,90)]:
 q=Quaternion((0,1,0),math.radians(yaw))@Quaternion((1,0,0),math.radians(pitch))
 head.matrix_basis=rest@q.to_matrix().to_4x4()
 bpy.context.view_layer.update()
 a=math.radians(ang);z=4.76
 cam.location=(math.sin(a)*13,-math.cos(a)*13,z+.24)
 cam.rotation_euler=(Vector((0,0,z))-cam.location).to_track_quat('-Z','Y').to_euler()
 s.render.filepath=str((out/f'{yaw}_{pitch}_{ang}.png').resolve())
 bpy.ops.render.render(write_still=True)
