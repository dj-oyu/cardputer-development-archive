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

for o in s.objects:
 if o.name.startswith('Preview floor'):o.hide_render=True
for side,sign in [('right',-1),('left',1)]:
 c.location=(sign*13,0,2.79)
 c.rotation_euler=(Vector((0,0,2.79))-c.location).to_track_quat('-Z','Y').to_euler()
 s.render.filepath=str((dst/f'level-{side}.png').resolve())
 bpy.ops.render.render(write_still=True)
# Native side is intentionally unchanged. A separate zoom render documents the glyph.
c.location=(-13,-3,3.75);c.data.ortho_scale=1.73
c.rotation_euler=(Vector((-.74,-.045,3.70))-c.location).to_track_quat('-Z','Y').to_euler()
s.render.resolution_x=400;s.render.resolution_y=320;s.render.filepath=str((dst/'badge-detail.png').resolve())
bpy.ops.render.render(write_still=True)
