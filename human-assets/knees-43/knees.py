"""Raise the knee joint and visible transition, retaining original hip/ankle and footwear."""
import bpy,sys,hashlib,math
from pathlib import Path
from mathutils import Vector
a,b=map(Path,sys.argv[-2:])
assert hashlib.sha256(a.read_bytes()).hexdigest()=='71b6b440e5a7a23fc766b3db921df033e33c2e1fb6f14940bb7186e90560e76d'
bpy.ops.wm.open_mainfile(filepath=str(a.resolve()),use_scripts=False)
r=next(o for o in bpy.context.scene.objects if o.type=='ARMATURE')
z_new=(.566,.724,.998,1.244,1.708,1.878,2.020,2.164,2.409)
shrink=(1.,1.,1.,.95,.965,.97,.991,1.,1.)
offset=(0,0,0,.007,.030,.021,.012,0,0)
for i,name in enumerate(('Thigh to shin continuous leg','Thigh to shin continuous leg.001')):
 o=bpy.data.objects[name];m=o.data
 zs=sorted(set(round(v.co.z,3) for v in m.vertices));assert len(zs)==len(z_new)==9
 for z,z1,sc,shift in zip(zs,z_new,shrink,offset):
  vs=[v for v in m.vertices if round(v.co.z,3)==z];c=sum((v.co for v in vs),Vector())/len(vs)
  for v in vs:
   if abs(z-z1)<.0004 and sc==1 and shift==0:continue
   v.co.x=c.x+(v.co.x-c.x)*sc+shift*(1 if i==0 else -1)
   v.co.y=c.y+(v.co.y-c.y)*sc
   v.co.z=z1
 m.update()
bpy.context.view_layer.objects.active=r;bpy.ops.object.mode_set(mode='EDIT')
for side in ('L','R'):
 t=r.data.edit_bones['thigh.'+side];s=r.data.edit_bones['shin.'+side]
 v=s.head.copy();v.x=math.copysign(.351,v.x);v.z=1.722
 t.tail=v;s.head=v
bpy.ops.object.mode_set(mode='OBJECT')
bpy.ops.wm.save_as_mainfile(filepath=str(b.resolve()),compress=True)
