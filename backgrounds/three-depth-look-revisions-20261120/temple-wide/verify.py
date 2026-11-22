import bpy, hashlib, json
from pathlib import Path
from mathutils import Vector
from bpy_extras.object_utils import world_to_camera_view as project
root=Path(__file__).resolve().parent
def metrics():
 s=bpy.context.scene; camera=s.camera
 eye=(1-project(s,camera,camera.location+Vector((0,100,0))).y)*135
 tiles={o.name:tuple(round(float(k),6) for v in o.data.vertices for k in o.matrix_world@v.co) for o in s.objects if o.name.startswith('Alternating floor tile')}
 far={o.name:float(o['far_lens_remap']) for o in s.objects if 'far_lens_remap' in o}
 return eye,tiles,far
bpy.ops.wm.open_mainfile(filepath=str(root.parent/'temple-eye/temple.blend'))
eye0,t0,_=metrics()
bpy.ops.wm.open_mainfile(filepath=str(root/'temple.blend'))
eye,t1,far=metrics()
assert abs(eye-67.5)<.001 and abs(eye-eye0)<.001 and t1==t0 and far and bpy.context.scene.render.engine=='CYCLES'
assert all(abs(q+.073)<.001 for xyz in t1.values() for q in xyz[2::3])
sun=sorted(tuple(o['disk_vertical_span']) for o in bpy.context.scene.objects if 'disk_vertical_span' in o)
gaps=[sun[i+1][0]-sun[i][1] for i in range(len(sun)-1)]
assert abs(sun[0][1]-.4)<1e-8 and all(i<j for i,j in zip(gaps,gaps[1:]))
def sha(p):return hashlib.sha256((root/p).read_bytes()).hexdigest()
d={'eye_line_y_top_origin':eye,'identical_planar_tiles':len(t1),'tagged_far_objects':len(far),'radial_coefficient':next(iter(far.values())),'sun_solid_top_fraction':sun[0][1],'sun_geometric_intervals':sun,'blend_sha256':sha('temple.blend'),'png_sha256':sha('temple-240x135.png')}
(root/'validation.json').write_text(json.dumps(d,indent=2)+'\n');print(d)
