"""World-space Blender orbit camera + independent keyed seated swivel derived from v69."""
import bpy, math,sys,json
from pathlib import Path
from mathutils import Vector
P=Path(__file__).resolve().parent;sys.path.append(str(P))
from swivel70 import prepare
s=bpy.context.scene;s.frame_set(1)
g=bpy.data.collections['Gaming Chair Prop'];pose=prepare(s,g)
arm=next(o for o in s.objects if o.type=='ARMATURE')
assert arm.animation_data and arm.animation_data.action
base=arm.animation_data.action;base.use_fake_user=True
act=base.copy();act.name='v70 • seated upper-frame swivel, fixed soles'
arm.animation_data.action=act
oldcam=s.camera;oldcam.name='Camera • original perspective reference'
# The original static optics use a world incoming ray. Transform it to the
# rotating aperture basis once; camera and seat rigs can then move independently.
portal=next(o for o in g.objects if o.name.startswith('Rear aperture'))
nt=portal.active_material.node_tree
gn=next(n for n in nt.nodes if n.label=='Trace a ray only in shading')
incoming=gn.outputs['Incoming']
links=[q.to_socket for q in incoming.links]
loc=nt.nodes.new('ShaderNodeVectorTransform');loc.label='v70 convert ray to rotating aperture basis'
loc.vector_type='VECTOR';loc.convert_from='WORLD';loc.convert_to='OBJECT'
for link in list(incoming.links):nt.links.remove(link)
nt.links.new(incoming,loc.inputs[0])
for dst in links:nt.links.new(loc.outputs[0],dst)

group=bpy.data.collections.new('Camera controls • independent world orbit')
s.collection.children.link(group)
def new(name,typ,loc=(0,0,0),size=.35):
 o=bpy.data.objects.new(name,typ);group.objects.link(o);o.location=loc
 if typ is None:o.empty_display_size=size
 return o
target=new('CAM TARGET — move to aim',None,(0,0,2.16),.45);target.show_in_front=True
target.empty_display_type='SPHERE'
yaw=new('CAM CONTROLS — yaw, pitch, distance, lens',None,size=.59);yaw.parent=target
yaw.empty_display_type='CIRCLE';yaw.show_in_front=True
pitch=new('CAM PITCH — driven child',None);pitch.parent=yaw
camdat=bpy.data.cameras.new('Independent orbit camera');camdat.type='PERSP';camdat.clip_start=.06;camdat.clip_end=120
cam=new('CAMERA — orbit',camdat);cam.parent=pitch
s.camera=cam
op=yaw
UI={
 'yaw_deg':(0.0,-360.,360.,'Orbit yaw in degrees; 0 looks at chair from behind.'),
 'pitch_deg':(math.degrees(math.atan2(1.54,12)),-60.,65.,'Positive looks down. Negative looks up.'),
 'distance':(math.hypot(12,1.54),3.5,22.0,'Orbital radius in Blender units.'),
 'lens_mm':(50.,25.,100.,'Perspective focal length, in mm.')}
for k,(v,lo,hi,d) in UI.items():
 op[k]=v;op.id_properties_ui(k).update(min=lo,max=hi,soft_min=lo,soft_max=hi,description=d)
def drive(obj,path,index,key,mul):
 fc=obj.driver_add(path,index) if index is not None else obj.driver_add(path)
 d=fc.driver;d.type='SCRIPTED';d.expression=f'v*{mul:.17g}'
 v=d.variables.new();v.name='v';v.type='SINGLE_PROP';v.targets[0].id=op;v.targets[0].data_path=f'["{key}"]'
drive(yaw,'rotation_euler',2,'yaw_deg',math.pi/180)
drive(pitch,'rotation_euler',0,'pitch_deg',math.pi/180)
drive(cam,'location',1,'distance',1)
drive(camdat,'lens',None,'lens_mm',1)
c=cam.constraints.new('TRACK_TO');c.name='Look at independent camera target';c.target=target;c.track_axis='TRACK_NEGATIVE_Z';c.up_axis='UP_Y'
# Preserve prior seated action in this file, key only specific root/leg controls in a derived action.
# Retain the upper transform separately from camera properties. Every rendered sample evaluates at its own frame.
for k in range(49):
 fr=k+1;s.frame_set(fr)
 angle=-35*math.cos(math.tau*k/48)
 pose(angle,keys=fr)
s.frame_start=1;s.frame_end=49;s.render.fps=10
for o in g.objects:
 if o.animation_data and o.animation_data.action:o.animation_data.action.name='v70 • upper swivel / '+o.name
s['camera_howto']='Select CAM CONTROLS and edit Object Custom Properties yaw_deg, pitch_deg, distance, lens_mm. G on CAM TARGET pans the target. Camera independent of chair root and stand.'
s['motion_facts']='Seat rotations are keyed separately, 1..49 (−35 to +35 return). Original seated action retained; derived action keys root and legs, not the orbit rig. Static world stand.'
s.frame_set(13)
bpy.context.view_layer.update()
bpy.ops.object.select_all(action='DESELECT');op.select_set(True);bpy.context.view_layer.objects.active=op
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(P/'chair-camera-orbit-v70-local-rays.blend'),compress=True)
