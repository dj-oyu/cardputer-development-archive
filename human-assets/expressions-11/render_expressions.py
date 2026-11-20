"""Render four independent states using one angle/scaling, preserving the saved default."""
from pathlib import Path
import bpy,sys,math
from mathutils import Vector
model,dst=map(Path,sys.argv[-2:]);dst=dst.resolve();dst.mkdir(exist_ok=True,parents=True)
bpy.ops.wm.open_mainfile(filepath=str(model.resolve()));s=bpy.context.scene;s.frame_set(1)
rig=next(o for o in s.objects if o.type=='ARMATURE')
cam=s.camera;cam.data.type='ORTHO'
s.render.engine='CYCLES';s.cycles.samples=40;s.cycles.use_denoising=False;s.cycles.seed=11
s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA'
for mode,z,scale,wh,deg in [('close',4.76,2.24,(360,320),-35),('native',2.79,10.6,(240,135),-35)]:
 a=math.radians(deg);cam.data.ortho_scale=scale
 cam.location=(math.sin(a)*13,-math.cos(a)*13,z+(.66 if mode=='native' else .24))
 cam.rotation_euler=(Vector((0,0,z))-cam.location).to_track_quat('-Z','Y').to_euler()
 s.render.resolution_x,s.render.resolution_y=wh;s.render.resolution_percentage=100
 for n,b,m in [('neutral',0.,0.),('blink',1.,0.),('smile',0.,1.),('both',1.,1.)]:
  assert n=='neutral' or 'Face Blink' in rig
  if 'Face Blink' in rig:
   rig['Face Blink']=b;rig['Face Smile']=m;rig.update_tag()
   bpy.context.view_layer.update()
  s.render.filepath=str(dst/f'{mode}-{n}.png');bpy.ops.render.render(write_still=True)
  if 'Face Blink' not in rig:break
