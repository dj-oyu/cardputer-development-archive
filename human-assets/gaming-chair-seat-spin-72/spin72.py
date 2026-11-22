"""Chair spins continuously; independent editable camera shots & active optical clocks."""
import bpy, math, json
from pathlib import Path
from mathutils import Vector, Matrix, Quaternion
from mathutils.bvhtree import BVHTree
P=Path(__file__).resolve().parent
s=bpy.context.scene;assembly=bpy.data.collections['Gaming Chair Prop'];s.frame_set(13)
bpy.context.view_layer.update()
stand=next(o for o in assembly.objects if 'stationary 26' in o.name)
upper={o:o.matrix_world.copy() for o in assembly.objects if o!=stand}
rif=next(o for o in s.objects if o.type=='ARMATURE')
rig=rif.pose.bones
initial={b.name:b.matrix.copy() for b in rig}
# Leave the original clip/actions in the file; only this isolated scene assigns its new channels.
for o in [*upper,rif]:
 if o.animation_data and o.animation_data.action:
  o.animation_data.action.use_fake_user=True
  o.animation_data.action=None
for b in rig:
 b.matrix=initial[b.name]
bpy.context.view_layer.update()
def aim(a0,a1,o):
    b=initial[o]
    old_direction=b.to_3x3()@Vector((0,1,0))
    q=old_direction.rotation_difference(a1-a0)
    M=(q.to_matrix()@b.to_3x3()).to_4x4();M.translation=a0
    rig[o].matrix=M
    bpy.context.view_layer.update()
for k in ('L','R'):
 a0,A0,B0,C0=(initial[x+'.'+k] for x in ('thigh','thigh','shin','foot'))
 a=a0.translation;c=C0.translation+Vector((0,.15,.27))
 L1=(B0.translation-A0.translation).length;L2=(C0.translation-B0.translation).length
 span=c-a;dist=span.length;u=span.normalized()
 along=(L1*L1-L2*L2+dist*dist)/(2*dist)
 h=math.sqrt(max(0,L1*L1-along*along))
 ref=B0.translation-a
 b=a+u*along+(ref-u*ref.dot(u)).normalized()*h
 aim(a,b,'thigh.'+k);aim(b,c,'shin.'+k)
 f=C0.copy();f.translation=c;rig['foot.'+k].matrix=f;bpy.context.view_layer.update()
# Bake pose at frame one (time-varying root is keyed below, other relative bones remain lifted).
root=rig['root'];root.rotation_mode='QUATERNION'
for b in rig:
 if b==root:continue
 b.keyframe_insert('location',frame=1)
 b.keyframe_insert('rotation_quaternion' if b.rotation_mode=='QUATERNION' else 'rotation_euler',frame=1)
 if b.scale!=Vector((1,1,1)):b.keyframe_insert('scale',frame=1)
s.frame_set(1);bpy.context.view_layer.update()
root0=root.matrix.copy();upper_euler={o:o.rotation_euler.copy() for o in upper}
pivot=Vector((0,-.10,0))
ctl=next(o for o in s.objects if o.name.startswith('CAM CONTROLS'))
FPS=12
N=144
prev=None
# Cameras are not parented to the moving chair. Edits at shot transitions are authored cuts.
CHAPTERS=[
 ('front / eye-level',168,188,5,8,11.0,11.4),
 ('side / three-quarter',119,83,12,9,10.8,11.4),
 ('rear / low',-18,18,-4,3,11.5,11.4),
 ('rear / high',35,-24,21,16,11.7,11.4),
]
def track(t,ms):
 t=(round(t*1000))%sum(ms)
 for i,a in enumerate(ms):
  if t<a:return i
  t-=a
 raise AssertionError
def independent_phases(t):
 return {'Live v71 / independent tank slosh':(1,0,2,0)[track(t,(460,340,460,340))],
 'Live v71 / independent bottle bubbles':track(t,(115,110,130,105,75,120)),
 'Live v71 / engine and local ignition phase':track(t,(120,115,115,120,120,130)*2)}
portal=next(o for o in assembly.objects if o.name.startswith('Rear aperture'))
shader=portal.active_material.node_tree
owner=shader.animation_data
if owner and owner.action:owner.action.use_fake_user=True;owner.action=None
values={x.label:x.outputs[0] for x in shader.nodes if x.label.startswith('Live v71 /')}
assert len(values)==3
timing={}
for i in range(N):
 f=i+1;t=i/FPS
 s.frame_set(f)
 angle=math.tau*2.3*(i/N)
 T=Matrix.Translation(pivot)@Matrix.Rotation(angle,4,'Z')@Matrix.Translation(-pivot)
 for o,m in upper.items():
  o.matrix_world=T@m
  # Keep a single forward Euler winding throughout; no quaternion orientation wrap.
  o.rotation_euler.z=upper_euler[o].z+angle
  o.keyframe_insert('location',frame=f);o.keyframe_insert('rotation_euler',frame=f)
 root.matrix=T@root0
 q=root.rotation_quaternion.copy()
 if prev is not None and q.dot(prev)<0:q.negate()
 root.rotation_quaternion=q;prev=q.copy()
 root.keyframe_insert('location',frame=f);root.keyframe_insert('rotation_quaternion',frame=f)
 j=i//36;name,y0,y1,p0,p1,r0,r1=CHAPTERS[j];u=(i%36)/35
 u=u*u*(3-2*u)
 y=y0+(y1-y0)*u;p=p0+(p1-p0)*u;r=r0+(r1-r0)*u
 for k,val in (('yaw_deg',y),('pitch_deg',p),('distance',r),('lens_mm',50.)):
  ctl[k]=val;ctl.keyframe_insert(f'["{k}"]',frame=f)
 ph=independent_phases(t)
 for a,out in values.items():
  out.default_value=ph[a];out.keyframe_insert('default_value',frame=f)
 timing[str(f)]={'frame':f,'time':t,'shot':j+1,'shot_name':name,'seat_yaw_unwrapped_degrees':math.degrees(angle),
               'camera_yaw_degrees':y,'camera_pitch_degrees':p,'camera_distance':r,'optical_phases':ph}
# Curves contain samples per frame. No wrap interpolation on chair, phase changes are discrete.
for o in [*upper,rif,ctl]:
 if not (o.animation_data and o.animation_data.action):continue
 a=o.animation_data.action
 a.name='v72 offline animation • '+o.name
 for c in a.fcurves:
  for k in c.keyframe_points:k.interpolation='LINEAR'
for c in shader.animation_data.action.fcurves:
 for k in c.keyframe_points:k.interpolation='CONSTANT'
s.frame_start=1;s.frame_end=N;s.render.fps=FPS;s.render.fps_base=1
s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
s.render.image_settings.file_format='PNG';s.render.image_settings.color_mode='RGB'
s.render.engine='CYCLES';s.cycles.samples=22;s.cycles.seed=177;s.cycles.use_denoising=False
# Neutral backdrop and wide lighting keeps the physical action readable.
for o in s.objects:
 if o.type=='LIGHT' or 'floor' in o.name.lower():o.hide_render=True
def light(loc,power,size,col=(1.,1.,1.)):
 d=bpy.data.lights.new('Swivel shot fill','AREA');d.energy=power;d.shape='DISK';d.size=size;d.color=col
 o=bpy.data.objects.new('Swivel shot fill',d);s.collection.objects.link(o);o.location=loc
 o.rotation_euler=(Vector((0,0,2))-o.location).to_track_quat('-Z','Y').to_euler()
light((3,5,6),730,5);light((-4,4,5),410,4,(.94,.97,1.));light((0,-5,6),590,5,(1.,.96,.90))
s.world=bpy.data.worlds.new('Spin preview / neutral');s.world.use_nodes=True
s.world.node_tree.nodes['Background'].inputs[0].default_value=(.18,.18,.18,1)
s.world.node_tree.nodes['Background'].inputs[1].default_value=.7
s['v72']='Offline camera sequence and 2.3 one-way turns. V71 original source unchanged. Sole positions are lifted; fixed world base. Independent optics continue through entire movie.'
s.frame_set(1);bpy.context.view_layer.update()
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(P/'chair-spin-v72.blend'),compress=True)
(P/'timing.json').write_text(json.dumps(timing,indent=2)+'\n')
