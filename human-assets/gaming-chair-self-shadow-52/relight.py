"""Relight the actual v51 swept tube with Cycles without changing source geometry."""
import math,os,bpy
from pathlib import Path
from mathutils import Vector
P=Path(__file__).resolve().parent
s=bpy.context.scene
cam=s.camera
tube=next(o for o in s.objects if o.name.startswith('Intake'))
# Swept closed components in v51 had inward winding. Flip faces without moving a vertex.
for o in s.objects:
 if o.type=='MESH' and (o.name.startswith('Intake') or o.name.endswith('anchored socket')):
    for pol in o.data.polygons:pol.flip()
    o.data.update()
tube.visible_shadow=os.getenv('NO_TUBE_SHADOW')!='1'
def surface(name,color,rough,metal=0,coat=0,aniso=0):
    name=next(m.name for m in bpy.data.materials if m.name.startswith(name))
    m=bpy.data.materials[name];p=m.node_tree.nodes.get('Principled BSDF')
    for a,v in {'Base Color':(*color,1),'Roughness':rough,'Metallic':metal,
                'Coat Weight':coat,'Coat Roughness':.34,'Anisotropic IOR Level':aniso}.items():
        k=p.inputs.get(a)
        if k is not None:k.default_value=v
    return m
surface('Graphite rubber',(.022,.026,.031),.48,coat=.12)
surface('Raised rubber ribs',(.032,.037,.049),.45,coat=.14)
surface('Mount collar brushed metal',(.255,.207,.152),.29,.83,.07,.40)
surface('Deep mount sockets',(.038,.036,.032),.56,.30)
surface('Light retaining band',(.39,.30,.199),.32,.78,.04,.36)
for o in list(s.objects):
 if o.type=='LIGHT':bpy.data.objects.remove(o,do_unlink=True)
def area(name,loc,target,power,color,width,height):
 d=bpy.data.lights.new(name,'AREA');d.energy=power;d.color=color;d.shape='RECTANGLE';d.size=width;d.size_y=height
 o=bpy.data.objects.new(name,d);s.collection.objects.link(o);o.location=loc
 o.rotation_euler=(Vector(target)-o.location).to_track_quat('-Z','Y').to_euler()
area('Wide soft key • long warm reflection',(1.22,1.30,3.56),(0,.56,2.47),95,(1.0,.94,.84),1.50,.47)
area('Chamber bounce • cool underlight',(-1.05,.72,2.08),(0,.55,2.36),10,(.65,.78,1.0),1.15,.61)
area('Shallow chamber lip rim',(.10,-.42,3.14),(0,.45,2.48),20,(.73,.83,1),1.55,.33)
s.world.node_tree.nodes['Background'].inputs[0].default_value=(.20,.205,.215,1)
s.world.node_tree.nodes['Background'].inputs[1].default_value=.14
# Two adjacent fixture surfaces provide reflected tonal contrast and contact shadows;
# camera-invisible, so neither adds a pixel to the tube or receiver silhouette.
plate=bpy.data.materials.new('Proxy • matte cavity baffle and nearby panel');plate.use_nodes=True
nd=plate.node_tree.nodes.get('Principled BSDF');nd.inputs['Base Color'].default_value=(.082,.079,.066,1);nd.inputs['Roughness'].default_value=.76
for name,loc,scale in [('Fixture reflection only • bulkhead',(.48,-.05,2.43),(.50,.040,.70)),('Fixture reflection only • engine saddle',(-.21,.08,2.16),(.55,.27,.11))]:
 bpy.ops.mesh.primitive_cube_add(size=1,location=loc)
 o=bpy.context.object;o.name=name;o.scale=scale;o.data.materials.append(plate);o.visible_camera=False
s.render.engine='CYCLES';s.cycles.samples=int(os.getenv('SAMPLES','128'));s.cycles.use_denoising=False
s.cycles.max_bounces=9;s.cycles.diffuse_bounces=5;s.cycles.glossy_bounces=5
s.cycles.use_adaptive_sampling=False
s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA'
size=int(os.getenv('WIDTH','240'));s.render.resolution_x=size;s.render.resolution_y=size*9//16;s.render.resolution_percentage=100
for yaw in map(int,os.getenv('YAW','-35,0,35').split(',')):
 a=math.radians(180+yaw);cam.location=(12*math.sin(a),-12*math.cos(a),3.70)
 cam.rotation_euler=(Vector((0,0,2.16))-cam.location).to_track_quat('-Z','Y').to_euler()
 dest=P/('assets' if size==240 else 'detail')/f'rear_{yaw:+03d}';dest.mkdir(parents=True,exist_ok=True)
 s.render.filepath=str(dest/('tube-no-self-shadow.png' if os.getenv('NO_TUBE_SHADOW') else 'tube.png'))
 bpy.ops.render.render(write_still=True)
if size==240 and not os.getenv('NO_TUBE_SHADOW'):
 s['purpose']='Actual v51 intake geometry relit for an offline Cycles bake. Two camera-invisible cavity baffles affect reflected/shadow light only.'
 bpy.context.preferences.filepaths.save_version=0
 bpy.ops.wm.save_as_mainfile(filepath=str(P/'virtual-tube-52.blend'),compress=True)
