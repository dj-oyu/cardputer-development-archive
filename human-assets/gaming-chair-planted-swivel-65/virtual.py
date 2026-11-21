"""Per-frame continuous optical plate render from geometrically matched camera path."""
import bpy,math,sys,os,json,re
from pathlib import Path
from mathutils import Vector
from bpy_extras.object_utils import world_to_camera_view
P=Path(__file__).resolve().parent
sys.path.append(str(P))
from timeline import N,state
from swivel import local_view
s=bpy.context.scene;c=s.camera
mode=os.getenv('MODE','engine')
s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
s.cycles.samples=int(os.getenv('SAMPLES','16'));s.cycles.use_denoising=False;s.cycles.seed=177
s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA'
removed=[]
if mode=='engine':
 for o in list(s.objects):
  if re.fullmatch(r'Bank [12] / (?:crown|ring|wrist pin|rod) [234]',o.name):
   removed.append(o.name);bpy.data.objects.remove(o,do_unlink=True)
 assert len(removed)==24,removed
 s.name='Virtual bay • working near V8 pair, rear liners retained'
 s['v65_far_piston_parts_removed']=sorted(removed)
 s.frame_set(1)
 bpy.context.preferences.filepaths.save_version=0
 bpy.ops.wm.save_as_mainfile(filepath=str(P/'virtual-cutaway-v8-65.blend'),compress=True)
 (P/'removed.json').write_text(json.dumps(sorted(removed),indent=2)+'\n')
deltas={}
for i in range(N):
 yaw,b,t,phase=state(i);c.location,target=local_view(yaw)
 c.rotation_euler=(target-c.location).to_track_quat('-Z','Y').to_euler()
 if mode=='engine':s.frame_set(1+(phase%6)*20)
 bpy.context.view_layer.update()
 d=P/'frames'/f'{i:03d}';d.mkdir(parents=True,exist_ok=True)
 s.render.filepath=str(d/f'{mode}.png');bpy.ops.render.render(write_still=True)
 if mode=='engine':
    def px(v):
       q=world_to_camera_view(s,c,Vector(v));return [q.x*240,(1-q.y)*135]
    pin=[px(s.objects[f'Bank {b} / wrist pin 1'].matrix_world.translation) for b in (1,2)]
    crank=px(s.objects['Throw 1 · common floating crankpin'].matrix_world.translation)
    # Common optical origin for depths .05 and 1.04 across yaw, aperture basis.
    ray=[px((0,.39+.285*(2.45-1.6)+.115-depth,2.45)) for depth in (.05,1.04,2.85)]
    deltas[i]={'yaw':yaw,'crank':phase,'bottle':b,'tank':t,'pins':pin,'crankpin':crank,'plane_diagnostic':ray}
if mode=='engine':(P/'projection.json').write_text(json.dumps(deltas,indent=2)+'\n')
