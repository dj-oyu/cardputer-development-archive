"""Render the existing virtual V8 and tube into independent aperture-basis atlas frames."""
import bpy,os,json
from mathutils import Vector
from bpy_extras.object_utils import world_to_camera_view
from pathlib import Path
P=Path(__file__).resolve().parent
mode=os.environ['MODE'];s=bpy.context.scene;c=s.camera
c.data.type='ORTHO';c.data.sensor_fit='HORIZONTAL';c.data.ortho_scale=1.24
c.location=(0,10,2.205)
c.rotation_euler=(Vector((0,0,2.205))-c.location).to_track_quat('-Z','Y').to_euler()
s.render.resolution_x=256;s.render.resolution_y=300;s.render.resolution_percentage=100
s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA';s.render.image_settings.color_depth='8'
s.view_settings.view_transform='Standard';s.view_settings.look='None'
s.render.engine='CYCLES';s.cycles.samples=84;s.cycles.use_denoising=False;s.cycles.seed=177
p=P/'bakes';p.mkdir(exist_ok=True)
meta=[]
for i in (range(6) if mode=='engine' else [0]):
    if mode=='engine':s.frame_set(1+20*i)
    bpy.context.view_layer.update()
    if mode=='engine':
      def px(o):
       q=world_to_camera_view(s,c,o.matrix_world.translation);return [q.x*256,(1-q.y)*300]
      meta.append({'pins':[px(s.objects[f'Bank {b} / wrist pin 1']) for b in (1,2)],
       'crank':px(s.objects['Throw 1 · common floating crankpin'])})
    s.render.filepath=str(p/f'{mode}-{i}.png');bpy.ops.render.render(write_still=True)
if meta:(P/'pin-ortho.json').write_text(json.dumps(meta,indent=2)+'\n')
