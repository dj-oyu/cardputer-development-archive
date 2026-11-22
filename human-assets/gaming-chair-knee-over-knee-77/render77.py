import bpy,os,math
from mathutils import Vector
from pathlib import Path
P=Path(__file__).resolve().parent
s=bpy.context.scene; s.frame_set(int(os.getenv('FRAME','13')));bpy.context.view_layer.update()
ctrl=next(o for o in s.objects if o.name.startswith('CAM CONTROLS'))
v=os.getenv('VIEW')
if v!='saved':
 yaw,pitch={'front':(180,9.),'side':(90,7.31),'quarter':(145,10.)}[v]
 ctrl['yaw_deg']=float(yaw);ctrl['pitch_deg']=float(pitch);ctrl.update_tag();bpy.context.view_layer.update()
s.render.engine='CYCLES';s.cycles.samples=26;s.cycles.seed=177;s.cycles.use_adaptive_sampling=False;s.cycles.use_denoising=False
s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
s.render.film_transparent=False;s.render.image_settings.file_format='PNG';s.render.image_settings.color_mode='RGB'
for o in s.objects:
 if o.type=='LIGHT' or 'floor' in o.name.lower():o.hide_render=True
def light(x,p,radius):
 d=bpy.data.lights.new('QA area','AREA');d.energy=p;d.shape='DISK';d.size=radius
 o=bpy.data.objects.new('QA area',d);s.collection.objects.link(o);o.location=x;o.rotation_euler=(Vector((0,0,2))-o.location).to_track_quat('-Z','Y').to_euler()
light((3,5,6),730,5);light((-4,4,5),410,4);light((0,-5,6),590,5)
s.world=bpy.data.worlds.new('Neutral studio');s.world.use_nodes=True
s.world.node_tree.nodes['Background'].inputs[0].default_value=(.18,.18,.18,1)
s.world.node_tree.nodes['Background'].inputs[1].default_value=.70
t=P/'native'/os.getenv('LABEL','v77');t.mkdir(exist_ok=True,parents=True)
for fr in ([int(x) for x in os.environ['RENDER_FRAMES'].split(',')] if os.getenv('RENDER_FRAMES') else [s.frame_current]):
 s.frame_set(fr);bpy.context.view_layer.update()
 s.render.filepath=str(t/(v+'.png' if not os.getenv('RENDER_FRAMES') else f'{v}-{fr:03}.png'))
 bpy.ops.render.render(write_still=True)
