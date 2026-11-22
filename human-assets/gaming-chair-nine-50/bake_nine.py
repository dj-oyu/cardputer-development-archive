"""Render v49 front-to-back contribution textures, straight alpha RGBA at 240x135."""
import bpy, math, os, sys
from mathutils import Vector
from pathlib import Path
p=Path(__file__).resolve().parent
s=bpy.context.scene
modes=os.getenv('MODE','base,'+','.join(f'layer_{i:02}' for i in range(1,10))+',full').split(',')
angles=map(int,os.getenv('YAW','-35,0,35').split(','))
chair=bpy.data.collections['Gaming Chair Prop']
portal=next(o for o in chair.objects if o.name.startswith('Rear aperture'))
nt=portal.active_material.node_tree;n=nt.nodes
get=lambda k:next(e for e in n if e.label==k)
out=get('Aperture surface')
mix=get('Rear rays only')
sh=get('Baked lighting only')
tr=get('No portal outside rear view')
base=get('00 / dark cavity base')
source=lambda x:x.links[0].from_socket if x.is_linked else x.default_value[:]
def setv(o,d):
 for link in list(d.links):nt.links.remove(link)
 if hasattr(o,'node'):nt.links.new(o,d)
 else:d.default_value=o
full=source(sh.inputs[0])
layers=sorted((node for node in n if node.type=='MIX_RGB' and node.label[:2].isdigit() and node.label[:2]!='00'),key=lambda n:n.label)
assert len(layers)==9
layer={f'layer_{j+1:02}':(source(node.inputs[0]),source(node.inputs[2])) for j,node in enumerate(layers)}
gate=n.new('ShaderNodeMixShader');setv(tr.outputs[0],gate.inputs[1]);setv(sh.outputs[0],gate.inputs[2])
hold=bpy.data.materials.new('Temporarily hold out foreground');hold.use_nodes=True
bn=hold.node_tree.nodes;outm=bn.get('Material Output');hold.node_tree.links.new(bn.new('ShaderNodeHoldout').outputs[0],outm.inputs[0])
others={ob:tuple(ob.data.materials) for ob in s.objects if ob.type=='MESH' and ob!=portal and len(ob.data.materials)}
def mat_hold(enabled):
 seen=set()
 for ob,mats in others.items():
    if ob.data in seen: continue
    seen.add(ob.data)
    for i,m in enumerate(mats):ob.data.materials[i]=hold if enabled else m
for o in s.objects:
 if o.type=='LIGHT' or 'floor' in o.name.lower():o.hide_render=True
def light(loc,power,size):
 d=bpy.data.lights.new('Studio fill','AREA');d.energy=power;d.shape='DISK';d.size=size
 ob=bpy.data.objects.new('Studio fill',d);s.collection.objects.link(ob);ob.location=loc
 ob.rotation_euler=(Vector((0,0,2))-ob.location).to_track_quat('-Z','Y').to_euler()
light((3,5,6),730,5);light((-4,4,5),410,4);light((0,-5,6),590,5)
s.world=bpy.data.worlds.new('Neutral Studio');s.world.use_nodes=True
s.world.node_tree.nodes['Background'].inputs[0].default_value=(.18,.18,.18,1)
s.world.node_tree.nodes['Background'].inputs[1].default_value=.70
s.render.engine='CYCLES';s.cycles.samples=int(os.getenv('SAMPLES','16'));s.cycles.seed=177
s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
s.render.image_settings.file_format='PNG';s.render.image_settings.color_mode='RGBA';s.render.image_settings.color_depth='8'
cam=s.camera;cam.data.type='PERSP';cam.data.lens=50
for yaw in angles:
 d=p/'assets'/f'rear_{yaw:+03d}';d.mkdir(parents=True,exist_ok=True)
 a=math.radians(180+yaw);cam.location=(12*math.sin(a),-12*math.cos(a),3.70)
 cam.rotation_euler=(Vector((0,0,2.16))-cam.location).to_track_quat('-Z','Y').to_euler()
 for mode in modes:
    active=mode in layer
    mat_hold(active);s.render.film_transparent=active
    if active:
        alpha,col=layer[mode];setv(col,sh.inputs[0]);setv(alpha,gate.inputs[0]);setv(gate.outputs[0],mix.inputs[1])
    else:
        setv(base.outputs[0] if mode=='base' else full,sh.inputs[0]);setv(sh.outputs[0],mix.inputs[1])
    s.render.filepath=str(d/f'{mode}.png');bpy.ops.render.render(write_still=True)
