import bpy,os,json,math
from pathlib import Path
from mathutils import Matrix,Vector
from mathutils.bvhtree import BVHTree
P=Path(__file__).resolve().parent
s=bpy.context.scene;r=next(o for o in s.objects if o.type=='ARMATURE');h=r.pose.bones['head']
def update(): bpy.context.view_layer.update()
def fset(f):
 s.frame_set(int(f),subframe=f-int(f));update()
def delta(a,b):return max(abs(a[i][j]-b[i][j]) for i in range(4) for j in range(4))
def shape(o):
 q=o.evaluated_get(bpy.context.evaluated_depsgraph_get());m=q.to_mesh();m.calc_loop_triangles()
 vs=[q.matrix_world@v.co for v in m.vertices];fs=[tuple(v.vertices) for v in m.loop_triangles]
 q.to_mesh_clear();return vs,fs
def tree(o):return BVHTree.FromPolygons(*shape(o),all_triangles=True)
face=[o for o in s.objects if o.type=='MESH' and o.vertex_groups.get('head') and o.name!='Neck']; neck=s.objects['Neck']
torso=[o for o in s.objects if o.type=='MESH' and o.name.startswith(('Soft ivory tee base','Jacket cut front and back','Cropped jacket hem','Open jacket front binding'))]
shell=next(o for o in s.objects if o.name.startswith('Engine chair'))
def new_head_overlap():
 ts=[tree(x) for x in torso+[shell]]
 return {o.name:sum(len(tree(o).overlap(t)) for t in ts) for o in face}
def rig_key():
 fwd=h.matrix.to_3x3()@Vector((0,0,1));x=h.matrix.to_3x3()@Vector((1,0,0))
 z=fwd.normalized();x=(x-x.dot(z)*z).normalized();y=z.cross(x).normalized()
 q=Matrix((x,y,z)).transposed().to_4x4();q.translation=h.matrix.translation;return q
def pose_all():return {b.name:b.matrix.copy() for b in r.pose.bones if b!=h}
def mshape(o):
 vs,fs=shape(o);return [min(v[k] for v in vs) for k in range(3)]+[max(v[k] for v in vs) for k in range(3)]
frames=range(1,50); sample=[1+i*.5 for i in range(97)]
A={};oldx={};other={};C0={}
for f in sample:
 fset(f);A[f]=rig_key();oldx[f]=new_head_overlap();other[f]=pose_all();C0[f]=mshape(neck)
act=r.animation_data.action
new=act.copy();new.name='v76 • seated lean, rigid head';new.use_fake_user=True;act.use_fake_user=True
r.animation_data.action=new
r.data.bones[h.name].inherit_scale='NONE'
for c in tuple(new.fcurves):
 if c.data_path.startswith('pose.bones["head"]'):new.fcurves.remove(c)
ext=float(os.getenv('EXTRA_NECK_Y','0'))
# Leave existing tracks byte-for-byte unless constrained collar test actually calls for extension.
if ext:
 neck_y=next(c for c in new.fcurves if c.data_path=='pose.bones["neck"].scale' and c.array_index==1)
 for k in neck_y.keyframe_points:
  k.co.y+= (k.co.y-1)*ext/.22
 neck_y.update()
hr=None
for f in sample:
 fset(f)
 H=A[f].copy()
 H.translation=h.matrix.translation
 h.matrix=H; update()
 e=h.rotation_euler.copy()
 if hr is not None:e.make_compatible(hr)
 h.rotation_euler=e;hr=e
 h.keyframe_insert('rotation_euler',frame=f,group='head')
for c in new.fcurves:
 if c.data_path=='pose.bones["head"].rotation_euler':
  for k in c.keyframe_points:k.interpolation='LINEAR'
receipt=[]
for f in sample:
 fset(f);M=rig_key();T=A[f]
 bs=other[f]
 diffs={b:delta(r.pose.bones[b].matrix,m) for b,m in bs.items()}
 diff={dk:dv for dk,dv in diffs.items() if dv>1e-6}
 rec={'f':f,'origin_move_BU':(M.translation-T.translation).length,'face_direction_error':(M.to_3x3().col[2]-T.to_3x3().col[2]).length,
 'full_rotation_axis_error':max((M.to_3x3().col[i]-T.to_3x3().col[i]).length for i in range(3)),
 'neck_raw_bounds_error':max(abs(a-b) for a,b in zip(C0[f],mshape(neck))),'other_bones_changed':diff,
 'head_overlap':new_head_overlap()}
 receipt.append(rec)
(P/'solve-receipt.json').write_text(json.dumps({'rows':receipt,'extra_neck_y':ext},indent=2))
print('fit result', {key:max(row[key] for row in receipt) for key in ('face_direction_error','origin_move_BU','full_rotation_axis_error','neck_raw_bounds_error')},flush=True)
print('head overlaps',[(x['f'],x['head_overlap']) for x in receipt if any(x['head_overlap'].values())],flush=True)
print('other differences',sum(bool(x['other_bones_changed']) for x in receipt),flush=True)
assert max(x['face_direction_error'] for x in receipt)<5e-4
assert not any(any(row['head_overlap'].values()) for row in receipt)
assert all(not any(v for k,v in row['other_bones_changed'].items() if k not in ('neck',)) for row in receipt)
s['v76_idle']='Rigid head correction for v75: head inherits no neck scale; exact forward orientation and the extended neck skin are kept separate. Prior v75 full affine visual is archived in the original v75 .blend.'
s.frame_set(22);update()
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(P/'chair-idle-lean-rigid-head-v76.blend'),compress=True)
