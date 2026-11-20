"""Pure profile +/-90°, 35° and exact-scale RGB565 source frames."""
import os,bpy,sys,math
from pathlib import Path
from mathutils import Vector,Euler
p,o=map(Path,sys.argv[-2:]);o=o.resolve();o.mkdir(parents=True,exist_ok=True)
bpy.ops.wm.open_mainfile(filepath=str(p.resolve()))
s=bpy.context.scene;s.frame_set(1)
h=next(x for x in s.objects if x.type=='ARMATURE').pose.bones['head']
cam=s.camera;cam.data.type='ORTHO'
s.render.engine='CYCLES';s.cycles.samples=32;s.cycles.use_denoising=False;s.cycles.seed=19
s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA'
if os.getenv('REMOVE_FLICKS'):
 for n in ('Left swept temple curl','Right framing curl'):bpy.data.objects[n].hide_render=True
for mode in ('close','native'):
 if os.getenv('NATIVE_ONLY') and mode=='close':continue
 for name,deg in [('high-left',-35),('high-right',35),('profile-left',-90),('profile-right',90),('rear',180),('rear35',145)]:
  if os.getenv('VIEW') and os.getenv('VIEW')!=mode+'-'+name:continue
  n=mode=='native';z=2.79 if n else 4.72
  a=math.radians(deg);cam.data.ortho_scale=10.6 if n else 2.24
  cam.location=(math.sin(a)*13,-math.cos(a)*13,z+(.66 if n else (6.5 if 'high' in name else 0.0)))
  cam.rotation_euler=(Vector((0,0,z))-cam.location).to_track_quat('-Z','Y').to_euler()
  s.render.resolution_x,s.render.resolution_y=((240,135) if n else (360,320));s.render.resolution_percentage=100
  s.render.filepath=str(o/f'{mode}-{name}.png');bpy.ops.render.render(write_still=True)
