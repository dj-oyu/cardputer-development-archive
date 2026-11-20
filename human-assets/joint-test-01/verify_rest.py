import bpy,sys,math
from pathlib import Path
paths=sys.argv[-2:]
def check(path):
 bpy.ops.wm.open_mainfile(filepath=str(Path(path).resolve()))
 bpy.context.scene.frame_set(1);dg=bpy.context.evaluated_depsgraph_get();ret={}
 for o in bpy.context.scene.objects:
  if o.type!='MESH' or any(c.name=='Preview only' for c in o.users_collection): continue
  e=o.evaluated_get(dg);m=e.to_mesh();ret[o.name]=[tuple(e.matrix_world@v.co) for v in m.vertices];e.to_mesh_clear()
 return ret
a,b=map(check,paths)
assert set(a)==set(b) and all(len(a[n])==len(b[n]) for n in a)
d=max(math.dist(x,y) for n in a for x,y in zip(a[n],b[n]));assert d<1.e-5
print('REST_CHECK',len(a),sum(map(len,a.values())),d)
