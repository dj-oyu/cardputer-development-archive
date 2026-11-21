import bpy,json,math
from pathlib import Path
D=Path(__file__).resolve().parent
p=json.loads((D/'ball-gravity-proof.json').read_text())
s=bpy.context.scene;r=next(o for o in s.objects if o.type=='ARMATURE')
b=s.objects['Ball | analytical vertical free fall']
def samples(f):
 s.frame_set(int(f),subframe=f-int(f));bpy.context.view_layer.update()
 g=bpy.context.evaluated_depsgraph_get();return b.evaluated_get(g).matrix_world.translation.copy(),{a.name:a.matrix.copy() for a in r.evaluated_get(g).pose.bones}
origin,pose=samples(p['release_frame']);err=0;diff=0;horizontal=0
for i in range(81):
 f=p['release_frame']+12*i/80
 x,q=samples(f)
 t=(f-p['release_frame'])/p['physical_blender_fps']
 z=max(p['ball_center_contact_z_BU'],p['ball_center_start_z_BU']-.5*p['g_BU_per_s2']*t*t)
 err=max(err,abs(z-x.z));horizontal=max(horizontal,(x.xy-origin.xy).length)
 diff=max(diff,max(abs(x-y) for n in pose for a,b in zip(pose[n],q[n]) for x,y in zip(a,b)))
assert err<2e-6 and horizontal==0 and diff==0
print('Reopen exact: analytic Z max error',err,'max XY drift',horizontal,'person pose drift',diff,flush=True)
(D/'reopen-ball-result.json').write_text(json.dumps({'samples':81,'z_max_BU_error':err,'xy_max_drift_BU':horizontal,'avatar_pose_max_drift':diff},indent=2))
