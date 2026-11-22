import bpy,hashlib,sys,json
from pathlib import Path
from mathutils import Vector
src,dst=map(lambda p:Path(p).resolve(),sys.argv[-2:])
def inspect(p):
 bpy.ops.wm.open_mainfile(filepath=str(p),use_scripts=False)
 s=bpy.context.scene;s.frame_set(1);dg=bpy.context.evaluated_depsgraph_get();rig=next(o for o in s.objects if o.type=='ARMATURE')
 data={};total=[0,0]
 for o in s.objects:
  if o.type!='MESH':continue
  m=o.data; m.calc_loop_triangles()
  if any(x.type=='ARMATURE' and x.object==rig for x in o.modifiers) or (o.parent==rig and o.parent_type=='BONE'):
   om=o.evaluated_get(dg);em=om.to_mesh();em.calc_loop_triangles();total[0]+=len(m.loop_triangles);total[1]+=len(em.loop_triangles);om.to_mesh_clear()
  data[o.name]=([o.matrix_world@v.co for v in m.vertices], [tuple(t.vertices) for t in m.polygons], [tuple((g.group,g.weight) for g in v.groups) for v in m.vertices], [(u.name,tuple(tuple(e.uv) for e in u.data)) for u in m.uv_layers],[] if not o.data.materials else [n.name for n in o.data.materials])
 return data,total,{b.name:(b.head_local.copy(),b.tail_local.copy()) for b in rig.data.bones}
a,b=inspect(src),inspect(dst)
assert a[0].keys()==b[0].keys() and a[1]==b[1]
assert all(a[0][n][1:]==b[0][n][1:] for n in a[0])
d=b[2]['head'][0]-a[2]['head'][0]
assert d.z<0 and (b[2]['head'][1]-a[2]['head'][1]-d).length<1e-6
assert (b[2]['neck'][1]-a[2]['neck'][1]-d).length<1e-6 and b[2]['neck'][0]==a[2]['neck'][0]
assert all(a[2][n]==b[2][n] for n in a[2] if n not in ('head','neck'))
changes=[]
for n,m in a[0].items():
 delta=[y-x for x,y in zip(m[0],b[0][n][0])]
 if all(v.length==0 for v in delta):continue
 if n!='Neck':assert all((v-d).length<1e-6 for v in delta),n
 changes.append(n)
assert len(changes)==12
print('RESULT',json.dumps(dict(base=hashlib.sha256(src.read_bytes()).hexdigest(),candidate=hashlib.sha256(dst.read_bytes()).hexdigest(),head_xyz_shift=list(d),neck_bone_before=(a[2]['neck'][1]-a[2]['neck'][0]).length,neck_bone_after=(b[2]['neck'][1]-b[2]['neck'][0]).length,rig_bound_raw_tris=b[1][0],rig_bound_evaluated_tris=b[1][1],unchanged_meshes=len(a[0])-len(changes),changed_meshes=changes,packed_face_uv_and_skin_weights_preserved=True)))
