"""Test one hidden short white-amber area light on existing hose and a white case proxy.
The light is outside the published optical layer; no emitter is rendered.
"""
import bpy,math,os
from mathutils import Vector
from pathlib import Path
P=Path(__file__).resolve().parent;s=bpy.context.scene;c=s.camera
def proxy(name,loc,scale):
 bpy.ops.mesh.primitive_cube_add(size=1,location=loc)
 o=bpy.context.object;o.name=name;o.scale=scale
 bpy.ops.object.transform_apply(location=False,rotation=False,scale=True)
 m=bpy.data.materials.new('Cream matte case receives shared light');m.use_nodes=True
 bs=m.node_tree.nodes.get('Principled BSDF');bs.inputs['Base Color'].default_value=(.44,.405,.355,1)
 bs.inputs['Roughness'].default_value=.49;o.data.materials.append(m)
 bev=o.modifiers.new('physical-looking top shoulders','BEVEL');bev.width=.025;bev.segments=4
 o.modifiers.new('Break brushed normals','WEIGHTED_NORMAL');return o
case=proxy('Registered light-response proxy, no new asset geometry',(-.025,.255,2.214),(.915,.064,.35))
lights=[]
for i,g in enumerate((-1,1)):
 d=bpy.data.lights.new(f'Hidden area pulse bank {i+1}','AREA')
 d.shape='RECTANGLE';d.size=.24;d.size_y=.12;d.color=(1,.71,.44);d.energy=0
 o=bpy.data.objects.new(d.name,d);s.collection.objects.link(o)
 o.location=(g*.27,.66,2.505)
 o.rotation_euler=(Vector((g*.24,.25,2.25))-o.location).to_track_quat('-Z','Y').to_euler()
 lights.append(o)
w=int(os.getenv('WIDTH','240'));s.cycles.samples=160;s.cycles.use_adaptive_sampling=False;s.render.resolution_percentage=100
s.render.resolution_x=w;s.render.resolution_y=w*9//16
pwr=float(os.getenv('POWER','12'))
for yaw in (-35,0,35):
 a=math.radians(180+yaw);c.location=(12*math.sin(a),-12*math.cos(a),3.70)
 c.rotation_euler=(Vector((0,0,2.16))-c.location).to_track_quat('-Z','Y').to_euler()
 p=P/'probe'/f'rear_{yaw:+03}';p.mkdir(parents=True,exist_ok=True)
 tube=next(o for o in s.objects if o.name.startswith('Intake'))
 for step in ('off','left','right','left-unblocked','right-unblocked','off-unblocked'):
  bank=step.partition('-')[0]
  tube.visible_shadow=not step.endswith('unblocked')
  for i,o in enumerate(lights):o.data.energy=pwr if bank==('left','right')[i] else 0.
  s.render.filepath=str(p/f'{step}.png');bpy.ops.render.render(write_still=True)
if w==240:
 tube.visible_shadow=True
 for o in lights:o.data.energy=0
 bpy.context.preferences.filepaths.save_version=0;bpy.ops.wm.save_as_mainfile(filepath=str(P/'source-test-60.blend'),compress=True)
