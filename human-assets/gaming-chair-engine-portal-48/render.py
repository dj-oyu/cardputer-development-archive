import bpy, math,os
from pathlib import Path
from mathutils import Vector
p=Path(__file__).resolve().parent
scene=bpy.context.scene
source=Path(bpy.data.filepath).stem+".blend"
for o in scene.objects:
 if o.type=='LIGHT' or 'floor' in o.name.lower():o.hide_render=True
def light(loc, power, size):
 d=bpy.data.lights.new('Studio fill','AREA');d.energy=power;d.shape='DISK';d.size=size
 ob=bpy.data.objects.new('Studio fill',d);scene.collection.objects.link(ob);ob.location=loc
 ob.rotation_euler=(Vector((0,0,2))-ob.location).to_track_quat('-Z','Y').to_euler()
light((3,5,6),730,5)
light((-4,4,5),410,4)
light((0,-5,6),590,5)
scene.world=bpy.data.worlds.new('Neutral Studio');scene.world.use_nodes=True
scene.world.node_tree.nodes['Background'].inputs[0].default_value=(.18,.18,.18,1)
scene.world.node_tree.nodes['Background'].inputs[1].default_value=.70
scene.render.engine='CYCLES';scene.cycles.samples=40;scene.cycles.seed=177
scene.render.film_transparent=False
scene.render.resolution_x=720;scene.render.resolution_y=405;scene.render.resolution_percentage=100
cam=scene.camera
if cam is None:
 d=bpy.data.cameras.new('Review camera');cam=bpy.data.objects.new('Review camera',d);scene.collection.objects.link(cam);scene.camera=cam
cam.data.type="PERSP";cam.data.lens=50
for nm,a in [('rear',180),('rear35',145),('side',90)]:
 if os.getenv('VIEW') and os.getenv('VIEW')!=nm:continue
 a=math.radians(a);cam.location=(12*math.sin(a),-12*math.cos(a),3.70)
 cam.rotation_euler=(Vector((0,0,2.16))-cam.location).to_track_quat('-Z','Y').to_euler()
 scene.render.filepath=str(p/f'{source[:-6]}-{nm}.png');bpy.ops.render.render(write_still=True)
