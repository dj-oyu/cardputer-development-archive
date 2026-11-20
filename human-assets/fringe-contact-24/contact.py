"""Extend back-facing belly sections to the cap while keeping root and tip rings exact."""
import bpy, sys, hashlib, os
from pathlib import Path
from mathutils import Vector
a,b=map(lambda p:Path(p).resolve(),sys.argv[-2:])
assert hashlib.sha256(a.read_bytes()).hexdigest()=='6b9bb4fe2c05bbeb49aca31fc6735aff7256b4999b04a1e7957bebc2433e2021'
bpy.ops.wm.open_mainfile(filepath=str(a),use_scripts=False)
for n,arc in [('Large right side-sweep',[.20,0,0,0,.20,.67,.98,1,.96,.58]),('Left wide brushed fringe',[.35,0,0,0,.10,.65,.96,1,1,.78])]:
 o=bpy.data.objects[n];m=o.data;uv=m.uv_layers.active
 q={m.loops[l].vertex_index:tuple(uv.data[l].uv) for p in m.polygons if len(p.vertices)<8 for l in p.loop_indices}
 normals=[p.vector.copy() for p in m.corner_normals]
 for v in m.vertices:
  u,s=q[v.index];i=round(u*10)%10;k=round(s*6)
  amt=[0,0,.26,.28,.21,0,0][k]*arc[i]*float(os.getenv('AMPLITUDE','1'))
  v.co+=Vector((-.24*v.co.x*amt,amt,-.13*amt))
 m.update();m.normals_split_custom_set(normals)
bpy.ops.wm.save_as_mainfile(filepath=str(b),compress=True)
