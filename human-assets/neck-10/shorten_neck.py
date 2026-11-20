"""Lower a rigged chibi head without changing its scale, face UVs or pose keys."""
import bpy, json, sys
from pathlib import Path

src,dst=map(Path,sys.argv[-3:-1]); dz=float(sys.argv[-1])
assert 0<dz<=0.14 and src.resolve()!=dst.resolve()
bpy.ops.wm.open_mainfile(filepath=str(src.resolve()),use_scripts=False)
s=bpy.context.scene
s.frame_set(1)
rig=next(o for o in s.objects if o.type=='ARMATURE')
assert rig.data.bones['head'].parent.name=='neck' and rig.data.bones['head'].use_connect
neck_b=rig.data.bones['neck']
neck_origin=neck_b.head_local.copy()
axis=neck_b.tail_local-neck_origin
d=-axis*dz/axis.z
assert rig.matrix_world.to_scale().length>0
affected=[]
for ob in s.objects:
 if ob.type!='MESH' or not any(m.type=='ARMATURE' and m.object==rig for m in ob.modifiers):continue
 total=0
 w=ob.matrix_world
 inv=w.inverted()
 for v in ob.data.vertices:
  if ob.name=='Neck':
   # Fixed at chest attachment, continuously transitions to the rigid head shift.
   p=rig.matrix_world.inverted()@(w@v.co)
   t=max(0.,min(1.,(p-neck_origin).dot(axis)/axis.length_squared))
   weight=t*t*(3-2*t)
  else:
   weights={ob.vertex_groups[g.group].name:g.weight for g in v.groups}
   weight=weights.get('head',0)
   if weight>1e-6:assert abs(weight-1)<1e-5,ob.name
  if weight>0:
   v.co+=inv.to_3x3()@rig.matrix_world.to_3x3()@d*weight
   total+=1
 if total:
  ob.data.update()
  affected.append((ob.name,total))
assert len(affected)>6
bpy.context.view_layer.objects.active=rig
bpy.ops.object.mode_set(mode='EDIT')
eb=rig.data.edit_bones
head=eb['head']
old_head,old_tail,old_roll=head.head.copy(),head.tail.copy(),head.roll
eb['neck'].tail=old_head+d
head.head=old_head+d
head.tail=old_tail+d
head.roll=old_roll
bpy.ops.object.mode_set(mode='OBJECT')
bpy.context.view_layer.update()
bpy.ops.wm.save_as_mainfile(filepath=str(dst.resolve()),compress=True)
print('ADJUST '+json.dumps({'affected_objects':affected,'shift':list(d),'neck_length_before':axis.length,'neck_length_after':rig.data.bones['neck'].length}))
