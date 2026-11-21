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
s.render.engine='CYCLES';s.cycles.samples=36;s.cycles.seed=177;s.cycles.use_adaptive_sampling=False;s.cycles.use_denoising=False
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

p=P/'native'/os.getenv('LABEL','result')/v;p.mkdir(exist_ok=True,parents=True)
r=next(o for o in s.objects if o.type=='ARMATURE')
states={
'neutral':(0,0,0),'blink':(0,1,0),'smile':(0,0,1),'worried':(1,0,0),'surprised':(2,0,0),
'gag':(3,0,0),'sleepy':(4,0,0),'gag-sweat':(3,0,0),'gag-anger':(3,0,0),'legacy-sweat':(0,0,0),'legacy-confusion':(0,0,0),'legacy-anger':(0,0,0),'worried-blink':(1,1,0),'surprised-smile':(2,0,1)}
for name in os.environ['STATES'].split(','):
 e,b,m=states[name]
 if 'Face Expression' in r:r['Face Expression']=int(e)
 else:assert not e
 r['Comic Emote']={'gag-sweat':1,'gag-anger':3,'legacy-sweat':1,'legacy-confusion':2,'legacy-anger':3}.get(name,0)
 r['Face Blink']=float(b);r['Face Smile']=float(m);r.update_tag()
 bpy.context.view_layer.update()
 s.frame_set(s.frame_current); bpy.context.view_layer.update()
 mt=bpy.data.objects['Sculpted cheeks, jaw and cranium'].active_material
 deps=bpy.context.evaluated_depsgraph_get()
 nt=mt.evaluated_get(deps).node_tree
 if 'Face Expression Selector' in nt.nodes:assert abs(nt.nodes['Face Expression Selector'].outputs[0].default_value-e)<.001
 assert abs(nt.nodes['Value'].outputs[0].default_value-b)<.001
 assert abs(nt.nodes['Value.001'].outputs[0].default_value-m)<.001
 s.render.filepath=str(p/(name+'.png'))
 bpy.ops.render.render(write_still=True)
