import bpy, math, sys, json
from mathutils import Vector, Matrix
from pathlib import Path
r=next(o for o in bpy.context.scene.objects if o.type=='ARMATURE');s=bpy.context.scene
bpy.context.view_layer.update()
if r.animation_data.action:
 r.animation_data.action.use_fake_user=True
 r.animation_data.action=None
for p in r.pose.bones:
 p.matrix_basis=Matrix.Identity(4);p.rotation_mode='XYZ'
bpy.context.view_layer.update()
def pose(b, target):
 p=r.pose.bones[b];axis=(p.tail-p.head).normalized();q=axis.rotation_difference((Vector(target)-p.head).normalized());M=q.to_matrix().to_4x4()@p.matrix;M.translation=p.head;p.matrix=M;bpy.context.view_layer.update()
def preserve_alignment(b):
 p=r.pose.bones[b];M=p.bone.matrix_local.copy();M.translation=p.head;p.matrix=M;bpy.context.view_layer.update()
p=r.pose.bones['root'];M=p.matrix.copy();M.translation+=Vector((0,0,-1.07));p.matrix=M;bpy.context.view_layer.update()
for side,sg in (('L',1),('R',-1)):
 p=r.pose.bones['thigh.'+side]
 pose(p.name,p.head+Vector((sg*.15,-1.08,-.04)))
 sh=r.pose.bones['shin.'+side];lz=sh.head.z-.621
 y=-math.sqrt(max(.003,sh.bone.length**2-lz**2-.04**2))
 pose(sh.name,sh.head+Vector((sg*.04,y,lz*-1)))
 preserve_alignment('foot.'+side)
 p=r.pose.bones['upper-arm.'+side];pose(p.name,p.head+Vector((sg*.36,.04,-.57)))
 p=r.pose.bones['forearm.'+side];pose(p.name,p.head+Vector((sg*.01,-.68,-.03)))
 p=r.pose.bones['hand.'+side];pose(p.name,p.head+Vector((sg*.01,-.19,-.02)))
act=bpy.data.actions.new('Cardputer | 椅子に座る・待機'); act.use_fake_user=True;r.animation_data.action=act
for p in r.pose.bones:
 for attr in ('location','rotation_euler','scale'):
  p.keyframe_insert(data_path=attr,frame=1,group=p.name);p.keyframe_insert(data_path=attr,frame=32,group=p.name)
s.frame_set(1);bpy.context.view_layer.update()
dg=bpy.context.evaluated_depsgraph_get()
items={}
for o in s.objects:
 if o.type!='MESH':continue
 m=o.evaluated_get(dg).data; vv=[o.matrix_world@v.co for v in m.vertices];items[o.name]=[[round(f(v[i] for v in vv),4) for i in range(3)] for f in (min,max)]
print('POSE',json.dumps({'bones':{p.name:[list(p.head),list(p.tail)] for p in r.pose.bones},'bounds':items}))
p=Path(sys.argv[-1]).resolve(); bpy.context.preferences.filepaths.save_version=0;bpy.ops.wm.save_as_mainfile(filepath=str(p))
