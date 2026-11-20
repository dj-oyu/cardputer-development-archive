"""Exact hair-only gate and five sampled rigid head pose BVH checks."""
import bpy,sys,hashlib,math,json
from pathlib import Path
from mathutils import Vector,Euler
from mathutils.bvhtree import BVHTree
a,b=map(lambda p:Path(p).resolve(),sys.argv[-2:])
names=('Left swept temple curl','Right framing curl')
def mm(m):return tuple(tuple(r) for r in m)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):
 bpy.ops.wm.open_mainfile(filepath=str(p),use_scripts=False)
 s=bpy.context.scene;s.frame_set(1);bpy.context.view_layer.update()
 obj=bpy.data.objects;rig=next(o for o in s.objects if o.type=='ARMATURE')
 ge={o.name:(tuple(tuple(v.co) for v in o.data.vertices),tuple((tuple(f.vertices),f.material_index,f.use_smooth) for f in o.data.polygons),tuple(tuple((g.group,g.weight) for g in v.groups) for v in o.data.vertices),tuple(u.name for u in o.data.materials),mm(o.matrix_world),tuple((u.name,tuple(tuple(x.uv) for x in u.data)) for u in o.data.uv_layers)) for o in s.objects if o.type=='MESH'}
 bones={k.name:(mm(k.matrix_local),k.parent.name if k.parent else '') for k in rig.data.bones}
 acts={a.name:tuple((fc.data_path,fc.array_index,tuple((tuple(k.co),tuple(k.handle_left),tuple(k.handle_right),k.interpolation) for k in fc.keyframe_points)) for fc in a.fcurves) for a in bpy.data.actions}
 imgs={i.name:hashlib.sha256(i.packed_file.data).hexdigest() for i in bpy.data.images if i.packed_file}
 poses={}
 for f in (1,8,15,23,30):
  s.frame_set(f);bpy.context.view_layer.update();poses[f]={h.name:mm(h.matrix) for h in rig.pose.bones}
 s.frame_set(1)
 h=rig.pose.bones['head'];start=h.matrix_basis.copy()
 contacts={}
 nmesh=('Sculpted cheeks, jaw and cranium','Neck','Upturned jacket lapel','Upturned jacket lapel.001','Bob back mass','Large right side-sweep','Left wide brushed fringe','Ear shell','Ear shell.001')
 def tree(o,dg):
  o=o.evaluated_get(dg);m=o.to_mesh();m.calc_loop_triangles();v=[o.matrix_world@p.co for p in m.vertices];t=[tuple(p.vertices) for p in m.loop_triangles];o.to_mesh_clear();tree=BVHTree.FromPolygons(v,t,all_triangles=True)
  return tree,t
 self_overlaps={}
 for name,r in (('neutral',(0,0,0)),('tilt_left',(0,17,0)),('tilt_right',(0,-17,0)),('look_up',(15,0,0)),('look_down',(-15,0,0))):
  h.matrix_basis=start@Euler(tuple(math.radians(i) for i in r)).to_matrix().to_4x4()
  bpy.context.view_layer.update();dg=bpy.context.evaluated_depsgraph_get()
  d={n:tree(obj[n],dg) for n in names+nmesh}
  contacts[name]={n:{t:len(d[n][0].overlap(d[t][0])) for t in nmesh} for n in names}
  if name=='neutral':
   for n in names:
    k,t=d[n];self_overlaps[n]=sum(1 for i,j in k.overlap(k) if i<j and not (set(t[i])&set(t[j])))
 return ge,bones,acts,imgs,poses,contacts,self_overlaps
A,B=load(a),load(b)
assert A[1:5]==B[1:5],'rig, actions or packed face maps changed'
assert set(A[0])==set(B[0])
assert {n for n in A[0] if A[0][n]!=B[0][n]}==set(names)
for name in names:
 x,y=A[0][name],B[0][name]
 assert x[1:]==y[1:]
 for pose,data in B[5].items():
  for n in ('Neck','Upturned jacket lapel','Upturned jacket lapel.001'):
   assert data[name][n]<=A[5][pose][name][n],(pose,name,n,data[name][n],A[5][pose][name][n])
  assert all(data[name][n]==0 for n in ('Sculpted cheeks, jaw and cranium','Ear shell','Ear shell.001'))
assert not any(B[6].values()),B[6]
print('VERIFY '+json.dumps({'source_sha256':sha(a),'output_sha256':sha(b),'changed_meshes':list(names),'all_other_meshes_exact':len(A[0])-2,'bones':len(B[1]),'packed_face_maps_exact':len(B[3]),'pose_frames':list(B[4]),'head_sample_overlap_before':A[5],'head_sample_overlap_after':B[5],'no_nonadjacent_self_intersections':B[6],'trims_retained_exact':['Sculpted cheeks, jaw and cranium','Bob back mass','Large right side-sweep','Left wide brushed fringe']},indent=None))
