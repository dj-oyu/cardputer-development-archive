"""Integrate the selected .12 BU raised-seat fit into exact v71's editable animation."""
import bpy,math,json
from pathlib import Path
from mathutils import Vector,Matrix,Quaternion
P=Path(__file__).resolve().parent;s=bpy.context.scene
s.frame_set(13);bpy.context.view_layer.update()
stand=next(o for o in s.objects if 'stationary 26' in o.name)
g=bpy.data.collections['Gaming Chair Prop'];upper=[o for o in g.objects if o!=stand]
slave=next(o for o in upper if o.name.startswith('Engine chair'))
rig=next(o for o in s.objects if o.type=='ARMATURE');pose=rig.pose.bones
origin0=slave.matrix_world.copy()
neutral_pose={b.name:b.matrix.copy() for b in pose}
D=.12
vv=[v for v in stand.data.vertices if v.co.z>1.1];assert len(vv)==2
for v in vv:v.co.z+=D
stand.data.update()
for o in upper:
 old=o.animation_data.action;old.use_fake_user=True
 a=old.copy();a.name='v74 +.12 BU • '+o.name;o.animation_data.action=a
 z=[f for f in a.fcurves if f.data_path=='location' and f.array_index==2];assert len(z)==1
 for k in z[0].keyframe_points:k.co.y+=D;k.handle_left.y+=D;k.handle_right.y+=D
 z[0].update()
base=rig.animation_data.action;base.use_fake_user=True
acl=base.copy();acl.name='v74 +.12 BU • synchronized seat, planted feet';rig.animation_data.action=acl
cache={}
def tune(j):
 s.frame_set(j);bpy.context.view_layer.update()
 M=slave.evaluated_get(bpy.context.evaluated_depsgraph_get()).matrix_world.copy()@origin0.inverted()
 pose['root'].matrix=M@neutral_pose['root'];bpy.context.view_layer.update()
 def orient(n,a,b):
  O=M@neutral_pose[n];q=(O.to_3x3()@Vector((0,1,0))).rotation_difference(b-a)
  mm=(q.to_matrix()@O.to_3x3()).to_4x4();mm.translation=a
  pose[n].matrix=mm;bpy.context.view_layer.update()
 for side in ('L','R'):
  nn=[f'{n}.{side}' for n in ('thigh','shin','foot')]
  A,B,C=[neutral_pose[n].translation.copy() for n in nn]
  a=(M@neutral_pose[nn[0]]).translation;c=C
  L1=(B-A).length;L2=(C-B).length;r=c-a;d=r.length
  assert abs(L1-L2)<d<L1+L2,(d,L1,L2)
  u=r.normalized();line=(L1*L1-L2*L2+d*d)/(2*d);h=math.sqrt(L1*L1-line*line)
  prior=(M@neutral_pose[nn[1]]).translation-a
  use=Quaternion(u,math.radians(4*(1 if side=='L' else -1)))@(prior-u.dot(prior)*u).normalized()
  knee=a+u*line+use*h
  orient(nn[0],a,knee);orient(nn[1],knee,c)
  pose[nn[2]].matrix=neutral_pose[nn[2]];bpy.context.view_layer.update()
 for n in ['root',*[f'{n}.{i}' for n in ('thigh','shin','foot') for i in ('L','R')]]:
  b=pose[n];b.keyframe_insert('location',frame=j)
  mode='rotation_quaternion' if b.rotation_mode=='QUATERNION' else 'rotation_euler'
  if mode=='rotation_quaternion':
   q=b.rotation_quaternion.copy()
   if n in cache and cache[n].dot(q)<0:q.negate()
   b.rotation_quaternion=q
   cache[n]=q.copy()
  b.keyframe_insert(mode,frame=j)
for j in range(1,50):tune(j)
s['v74_selected_fit']='+0.12 BU seated neutral, medial knee-plane bias 4 degrees. Gas shaft upper endpoints extended only; upper world motion preserves v71 theta and xy. Feet remain planted. All camera and optics phase tracks unchanged.'
s.frame_set(13);bpy.context.view_layer.update()
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(P/'chair-seated-v74.blend'),compress=True)
