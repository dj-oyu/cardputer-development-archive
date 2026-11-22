"""Compare front and oblique head with fixed optics; native frames are separate."""
import bpy,sys,math,os
from pathlib import Path
from mathutils import Vector
source,out=map(Path,sys.argv[-2:]);out.mkdir(parents=True,exist_ok=True)
bpy.ops.wm.open_mainfile(filepath=str(source.resolve()))
s=bpy.context.scene;s.frame_set(1)
s.render.engine='CYCLES';s.cycles.samples=84;s.cycles.use_denoising=False
s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA'
cam=s.camera;cam.data.type='ORTHO'
for o in s.objects:
 if o.name.startswith('Preview floor'):o.hide_render=True
for mode,z,scale,wh in [('face',4.76,2.24,(360,320)),('native',2.79,10.6,(240,135))]:
 target=Vector((0,0,z));cam.data.ortho_scale=scale
 s.render.resolution_x,s.render.resolution_y=wh;s.render.resolution_percentage=100
 for deg,view in [(0,'front'),(-35,'oblique')]+([(-90,'profile'),(180,'back')] if mode=='face' else [(180,'back')]):
  if os.getenv('HAIR_VIEW') and os.getenv('HAIR_VIEW')!=f'{mode}-{view}':continue
  a=math.radians(deg);cam.location=(math.sin(a)*13,-math.cos(a)*13,z+(.66 if mode=='native' else .24))
  cam.rotation_euler=(target-cam.location).to_track_quat('-Z','Y').to_euler()
  s.render.filepath=str((out/f'{mode}-{view}.png').resolve());bpy.ops.render.render(write_still=True)
