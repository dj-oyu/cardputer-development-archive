"""Strict horizontal orthographic side views. Render both checkpoints identically."""
import bpy, sys
from pathlib import Path
from mathutils import Vector
src,dst=map(Path,sys.argv[-2:]); dst.mkdir(exist_ok=True,parents=True)
bpy.ops.wm.open_mainfile(filepath=str(src.resolve()))
s=bpy.context.scene; s.frame_set(1)
s.render.engine='CYCLES';s.cycles.samples=48;s.cycles.use_denoising=False
s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA'
s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
c=s.camera;c.data.type='ORTHO';c.data.ortho_scale=10.6
c.location=(-13,0,2.79)
c.rotation_euler=(Vector((0,0,2.79))-c.location).to_track_quat('-Z','Y').to_euler()
for o in s.objects:
 if o.name.startswith('Preview floor'):o.hide_render=True
s.render.filepath=str((dst/'strict-profile.png').resolve())
bpy.ops.render.render(write_still=True)
