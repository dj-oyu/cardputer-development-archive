"""Stationary world camera and base; upper pivots around bearing; soles stay planted."""
import bpy,math
from mathutils import Vector,Matrix
P=Vector((0,-.10,0))
def local_view(yaw):
 r=Matrix.Rotation(math.radians(yaw),3,'Z')
 return P+r@(Vector((0,12,3.70))-P),P+r@(Vector((0,0,2.16))-P)
def prepare(scene, collection):
 scene.frame_set(1);bpy.context.view_layer.update()
 stand=next(o for o in collection.objects if 'stationary 26' in o.name)
 assert stand is not None
 upper={o:o.matrix_world.copy() for o in collection.objects if o!=stand}
 rig=next(o for o in scene.objects if o.type=='ARMATURE')
 orig={b.name:b.matrix.copy() for b in rig.pose.bones}
 bone=rig.pose.bones
 planted={side:orig['foot.'+side].translation.copy() for side in ('L','R')}
 def lengths(side):
  return tuple((orig[j+'.'+side].translation-orig[i+'.'+side].translation).length for i,j in [('thigh','shin'),('shin','foot')])
 def pose(yaw,keys=None):
  Rz=Matrix.Rotation(math.radians(-yaw),4,'Z')
  T=Matrix.Translation(P)@Rz@Matrix.Translation(-P)
  for o,m in upper.items():o.matrix_world=T@m
  bone['root'].matrix=T@orig['root'];bpy.context.view_layer.update()
  def aim(name,start,end):
   Q=T@orig[name]
   y=Q.to_3x3()@Vector((0,1,0))
   diff=y.rotation_difference(end-start).to_matrix()
   out=(diff@Q.to_3x3()).to_4x4()
   out.translation=start;bone[name].matrix=out
   bpy.context.view_layer.update()
  for side in ('L','R'):
   a=(T@orig['thigh.'+side]).translation;goal=planted[side]
   v=goal-a;dist=v.length;axis=v.normalized();L1,L2=lengths(side)
   edge=(L1*L1-L2*L2+dist*dist)/(2*dist)
   h=math.sqrt(max(0,L1*L1-edge*edge))
   p0=(T@orig['shin.'+side]).translation
   preferred=p0-a
   knee=a+axis*edge+(preferred-axis*preferred.dot(axis)).normalized()*h
   aim('thigh.'+side,a,knee);aim('shin.'+side,knee,goal)
   bone['foot.'+side].matrix=orig['foot.'+side]
   bpy.context.view_layer.update()
  err={side:(bone['foot.'+side].head-planted[side]).length for side in ('L','R')}
  if keys is not None:
   for o in upper:
    o.keyframe_insert('location',frame=keys);o.keyframe_insert('rotation_euler',frame=keys)
   for n in ['root',*[f'{p}.{i}' for p in ('thigh','shin','foot') for i in ('L','R')]]:
    b=bone[n]
    b.keyframe_insert('location',frame=keys)
    b.keyframe_insert('rotation_quaternion' if b.rotation_mode=='QUATERNION' else 'rotation_euler',frame=keys)
  return err
 return pose
