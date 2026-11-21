import bpy,os,math,json
from mathutils import Vector
from pathlib import Path
from bpy_extras.object_utils import world_to_camera_view
D=Path(__file__).resolve().parent
s=bpy.context.scene
tag=os.getenv('LABEL','full')
s.render.engine='CYCLES';s.cycles.samples=20;s.cycles.seed=47;s.cycles.use_adaptive_sampling=False;s.cycles.use_denoising=False
s.render.resolution_x=480;s.render.resolution_y=270;s.render.resolution_percentage=100
s.render.film_transparent=False;s.render.image_settings.file_format='PNG';s.render.image_settings.color_mode='RGB'
for o in s.objects:
 if o.type=='LIGHT':o.hide_render=True
floor=s.objects.get('Preview floor only')
if floor:
 floor.location.z=.038;floor.hide_render=False
def light(x,power,siz):
 d=bpy.data.lights.new('Gravity QA area','AREA');d.energy=power;d.shape='DISK';d.size=siz
 o=bpy.data.objects.new('Gravity QA area',d);s.collection.objects.link(o);o.location=x
 o.rotation_euler=(Vector((0,-.3,2))-o.location).to_track_quat('-Z','Y').to_euler()
light((3,5,6),730,5);light((-4,4,5),410,4);light((0,-5,6),590,5)
s.world=bpy.data.worlds.new('Gravity diagnostic studio');s.world.use_nodes=True
s.world.node_tree.nodes['Background'].inputs[0].default_value=(.18,.18,.18,1)
s.world.node_tree.nodes['Background'].inputs[1].default_value=.70
ctrl=next(o for o in s.objects if o.name.startswith('CAM CONTROLS'))
aim=next(o for o in s.objects if o.name.startswith('CAM TARGET'))
if tag=='close':
 s.camera.data.ortho_scale=3.6;aim.location=(-.58,-.83,1.86);ctrl['yaw_deg']=137.
elif tag=='full':
 s.camera.data.ortho_scale=7.80;aim.location=(-.35,-.63,2.07);ctrl['yaw_deg']=133.
ctrl.update_tag()
t=D/'native'/tag;t.mkdir(exist_ok=True,parents=True)
q=json.loads((D/'ball-gravity-proof.json').read_text())
f0=q['release_frame'];hit=q['contact_frame']
frames=[f0,hit] if os.getenv('PREVIEW') else [f0+i*(hit-f0)/24 for i in range(25)]
def pix(v):
 t=world_to_camera_view(s,s.camera,Vector(v));return [t.x*480,(1-t.y)*270]
s.frame_set(f0);bpy.context.view_layer.update()
x,y,z=q['release_surface_vector']
xm=q['ball_lane_x']; seat=q['cushion_z_BU']
markers={'contact':pix((xm,y,seat)),'ball_origin_bottom':pix((xm,y,z)),'real_marker':pix((x,y,z)),'real_seat':pix((x,y,seat))}
(D/f'projection-{tag}.json').write_text(json.dumps(markers,indent=2))
for i,f in enumerate(frames):
 s.frame_set(int(f),subframe=f-int(f));bpy.context.view_layer.update()
 s.render.filepath=str(t/f'{i:03}.png');bpy.ops.render.render(write_still=True)
