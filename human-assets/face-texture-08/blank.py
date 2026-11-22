import sys,bpy,hashlib
from pathlib import Path
from mathutils import Vector
src,out=map(Path,sys.argv[-2:]);out=out.resolve();out.mkdir(parents=True,exist_ok=True)
assert hashlib.sha256(src.read_bytes()).hexdigest()=='b2801c79d3d0d7215764cdbb5f67040a38f7fb397d7b0b937b4c211f004bf1e9'
bpy.ops.wm.open_mainfile(filepath=str(src.resolve()))
s=bpy.context.scene;s.frame_set(1)
c=bpy.data.collections['Face and features']
keep=('Sculpted cheeks','Neck','Ear shell','Ear bowl')
for ob in list(c.objects):
 if not ob.name.startswith(keep):bpy.data.objects.remove(ob,do_unlink=True)
bpy.ops.wm.save_as_mainfile(filepath=str(out/'human-blank-face-08.blend'),compress=True)
cam=s.camera;cam.data.type='ORTHO';cam.data.ortho_scale=2.24
cam.location=(0,-13,4.78);cam.rotation_euler=(Vector((0,0,4.78))-cam.location).to_track_quat('-Z','Y').to_euler()
s.render.engine='CYCLES';s.cycles.samples=64;s.cycles.use_denoising=False
s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA'
s.render.resolution_x=s.render.resolution_y=512;s.render.resolution_percentage=100
s.render.filepath=str(out/'blank-front-square.png')
bpy.ops.render.render(write_still=True)
