import bpy,sys,hashlib,json
from pathlib import Path
mat=lambda m:tuple(tuple(r) for r in m)
def load(path):
 bpy.ops.wm.open_mainfile(filepath=str(path),use_scripts=False)
 s=bpy.context.scene;s.frame_set(1)
 d=bpy.context.evaluated_depsgraph_get();meshes={};coords={};tris={};raw={}
 rig=next(o for o in s.objects if o.type=='ARMATURE')
 for o in s.objects:
  if o.type!='MESH':continue
  m=o.data
  coords[o.name]=[tuple(v.co) for v in m.vertices]
  meshes[o.name]=[mat(o.matrix_world), [tuple(p.vertices) for p in m.polygons], [(p.material_index,p.use_smooth) for p in m.polygons], [tuple((g.group,g.weight) for g in v.groups) for v in m.vertices], [m.name for m in o.data.materials], [(u.name,[tuple(x.uv) for x in u.data]) for u in m.uv_layers]]
  if any(x.type=='ARMATURE' and x.object==rig for x in o.modifiers) or (o.parent==rig and o.parent_type=='BONE'):
   m.calc_loop_triangles();raw[o.name]=len(m.loop_triangles)
   ev=o.evaluated_get(d); em=ev.to_mesh();em.calc_loop_triangles();tris[o.name]=len(em.loop_triangles);ev.to_mesh_clear()
 head=next(o for o in s.objects if o.type=='MESH' and o.name.startswith('Sculpted cheeks'))
 import bmesh
 bm=bmesh.new();bm.from_mesh(head.data)
 assert all(e.is_manifold for e in bm.edges), 'new skin opening'
 bm.free()
 poses={}
 for f in (1,8,15,23,30):
  s.frame_set(f)
  poses[f]={p.name:mat(p.matrix) for p in rig.pose.bones}
 return meshes,coords,tris,poses,{b.name:mat(b.matrix_local) for b in rig.data.bones},{a.name:[(f.data_path,f.array_index,[tuple(k.co) for k in f.keyframe_points]) for f in a.fcurves] for a in bpy.data.actions},{i.name:hashlib.sha256(i.packed_file.data).hexdigest() for i in bpy.data.images if i.packed_file},{k:rig[k] for k in rig.keys() if k.startswith('Face ')},raw,head.name
base,candidate=map(lambda x:Path(x).resolve(),sys.argv[-2:])
a,b=load(base),load(candidate)
assert a[0]==b[0] and a[2:]==b[2:]
assert a[1].keys()==b[1].keys()
assert [k for k in a[1] if a[1][k]!=b[1][k]]==[b[-1]]
pairs=[(x,y) for x,y in zip(a[1][b[-1]],b[1][b[-1]]) if x!=y]
assert all(4.23<x[2]<4.57 and x[1]<.18 for x,y in pairs)
print('RESULT',json.dumps(dict(base=hashlib.sha256(base.read_bytes()).hexdigest(),candidate=hashlib.sha256(candidate.read_bytes()).hexdigest(),raw_triangles=sum(b[-2].values()),evaluated_triangles=sum(b[2].values()),bound_objects=len(b[2]),bones=len(b[4]),packed_images=len(b[6]),changed_vertices=len(pairs),max_xyz_shift=[max(abs(x[i]-y[i]) for x,y in pairs) for i in range(3)],tested_frames=list(b[3]),closed=True)))
