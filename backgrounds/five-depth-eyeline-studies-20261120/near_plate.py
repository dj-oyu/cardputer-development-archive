from pathlib import Path
import bpy,sys,json
from mathutils import Vector
from bpy_extras.object_utils import world_to_camera_view
src,png,prefix=sys.argv[-3:]
bpy.ops.wm.open_mainfile(filepath=str(Path(src).resolve()))
s=bpy.context.scene; cams=s.camera
forward=cams.matrix_world.to_quaternion() @ Vector((0,0,-1))
horizontal=Vector((forward.x,forward.y,0)).normalized()
bpy.context.view_layer.update()
eye_line=None
if cams.data.type=='PERSP':
    uv=world_to_camera_view(s,cams,cams.matrix_world.translation+10000*horizontal)
    eye_line=(1-uv.y)*135
want=[x for x in s.objects if x.get('camera_near_layer') or (prefix and x.name.startswith(prefix))]
assert want, prefix
for o in s.objects:
    if o.type in {'MESH','SURFACE','VOLUME','CURVE','FONT','META'}: o.hide_render=(o not in want)
s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
s.render.film_transparent=True
s.render.image_settings.color_mode='RGBA'; s.render.image_settings.file_format='PNG'
s.use_nodes=False
s.cycles.use_denoising=False;s.cycles.samples=128
s.render.filepath=str(Path(png).resolve())
bpy.ops.render.render(write_still=True)
print('DEPTH_PLATE '+json.dumps({'eye_line_perspective_px_from_top':eye_line,'camera_type':cams.data.type,'near_objects':len(want),'dof':cams.data.dof.use_dof,'focus_distance':cams.data.dof.focus_distance,'fstop':cams.data.dof.aperture_fstop},ensure_ascii=False))
