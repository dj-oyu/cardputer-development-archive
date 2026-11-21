"""Reopen exact source/result; check intentional changes, seam crossing and poses."""
import bpy,sys,hashlib,json,math
from pathlib import Path
from mathutils import Vector,Euler
from mathutils.bvhtree import BVHTree
a,b,out=map(Path,sys.argv[-3:])
def sha(x):return hashlib.sha256(x).hexdigest()
legs=('Thigh to shin continuous leg','Thigh to shin continuous leg.001')
def scene(p):
 bpy.ops.wm.open_mainfile(filepath=str(p.resolve()),use_scripts=False)
 s=bpy.context.scene;r=next(o for o in s.objects if o.type=='ARMATURE')
 def shape(o):
  return tuple(tuple(v.co) for v in o.data.vertices),tuple(tuple(p.vertices) for p in o.data.polygons),tuple(tuple((g.group,g.weight) for g in v.groups) for v in o.data.vertices),tuple(tuple(x) for x in o.matrix_world),tuple((m.name,m.type) for m in o.modifiers)
 ge={o.name:shape(o) for o in s.objects if o.type=='MESH'}
 acts={u.name:tuple((f.data_path,f.array_index,tuple((tuple(k.co),tuple(k.handle_left),tuple(k.handle_right)) for k in f.keyframe_points)) for f in u.fcurves) for u in bpy.data.actions}
 bones={b.name:(tuple(b.head_local),tuple(b.tail_local),b.parent.name if b.parent else '',b.use_connect) for b in r.data.bones}
 images={i.name:sha(i.packed_file.data) for i in bpy.data.images if i.packed_file and i.users}
 shoes=[o.name for o in s.objects if o.type=='MESH' and ('boot' in o.name.lower() or 'outsole' in o.name.lower())]
 def get_pose():
  bpy.context.view_layer.update();dg=bpy.context.evaluated_depsgraph_get();models={}
  for n in list(legs)+shoes+['Waist and seat']:
   e=s.objects[n].evaluated_get(dg);m=e.to_mesh();m.calc_loop_triangles();v=[e.matrix_world@w.co for w in m.vertices];t=[tuple(tr.vertices) for tr in m.loop_triangles];models[n]=(BVHTree.FromPolygons(v,t,all_triangles=True),v,t);e.to_mesh_clear()
  count={}
  for n in legs:
   t,v,ts=models[n];intersect=t.overlap(t)
   pairs=[(i,j) for i,j in intersect if i<j and not set(ts[i])&set(ts[j])]
   shoe={k:len(t.overlap(models[k][0])) for k in shoes if t.overlap(models[k][0])}
   count[n]={'self_cross':len(pairs),'footwear_contacts':shoe,'shorts_pair_count':len(t.overlap(models['Waist and seat'][0]))}
  upper={n:tuple(tuple(v) for v in models[n][1][-14:]) for n in legs}
  foot={k:tuple(r.matrix_world@r.pose.bones[k].head) for k in ('foot.L','foot.R')}
  return count,upper,foot
 poses={}; upper={}; foot={}
 for f in (1,8,15,23,30):
  s.frame_set(f);poses[f],upper[f],foot[f]=get_pose()
 s.frame_set(1);stress_basis={s:r.pose.bones['shin.'+s].matrix_basis.copy() for s in ('L','R')}
 for k in (30,55):
  s.frame_set(1)
  for side in ('L','R'):
   shin=r.pose.bones['shin.'+side]
   shin.matrix_basis=stress_basis[side]@Euler((math.radians(k),0,0)).to_matrix().to_4x4()
  poses['shin_'+str(k)],_,foot['shin_'+str(k)]=get_pose()
 return ge,acts,bones,images,poses,upper,foot
A,B=scene(a),scene(b)
assert all(A[0][n][1:]==B[0][n][1:] and A[0][n][0]!=B[0][n][0] for n in legs)
assert all(v==B[0][n] for n,v in A[0].items() if n not in legs)
assert A[1]==B[1] and A[3]==B[3]
changes={n for n,v in A[2].items() if v!=B[2][n]};assert changes==set()
assert all(A[2]['thigh.'+s][0]==B[2]['thigh.'+s][0] and A[2]['shin.'+s][1]==B[2]['shin.'+s][1] for s in ('L','R'))
assert all(A[2]['foot.'+s]==B[2]['foot.'+s] for s in ('L','R'))
foot_delta=max((Vector(A[6][1][n])-Vector(B[6][1][n])).length for n in A[6][1])
assert foot_delta<1e-5, foot_delta
assert max((Vector(x)-Vector(y)).length for n in legs for x,y in zip(A[5][1][n],B[5][1][n]))<1e-5
out.write_text(json.dumps({'source':sha(a.read_bytes()),'result':sha(b.read_bytes()),'nonleg_meshes_exact':len(A[0])-2,'original_action_preserved':True,'rig_only_moved':sorted(changes),'knee_z_before':A[2]['shin.L'][0][2],'knee_z_after':B[2]['shin.L'][0][2],'neutral_foot_max_delta':foot_delta,'before':A[4],'after':B[4],'stress_foot_positions':{k:B[6][k] for k in ('shin_30','shin_55')}},indent=2)+'\n')
