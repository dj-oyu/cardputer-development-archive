"""Give the rigid PVC bob a chopped lower edge and sharpen the visible forelock crests."""
import bpy,sys,hashlib,math
from pathlib import Path
from mathutils import Vector
a,b=map(lambda p:Path(p).resolve(),sys.argv[-2:])
assert hashlib.sha256(a.read_bytes()).hexdigest()=="45a1b182dfa99c78c9cebdd94775e739c8075d5f2de64e1bd2d973aa8a649404"
bpy.ops.wm.open_mainfile(filepath=str(a),use_scripts=False)
o=bpy.data.objects
m=o['Bob back mass'].data
assert len(m.vertices)==192
assert o['Bob back mass'].matrix_world.is_identity
original=[v.co.copy() for v in m.vertices]
strength=[0,.25,.54,.80,.97,1,1,1,1,1,1,1,.97,.80,.54,.25,0]
# Shared corner rhythms create four broad-cut ends, not a series of small teeth.
end=[0,0,.020,.020,.020,-.030,-.030,-.030,.008,.008,.008,-.017,-.017,-.017,.012,0,0]
offset=[0,0,.012,.024,.022,-.012,-.029,-.015,.021,.025,.012,-.025,-.019,.013,.008,0,0]
for j,w in enumerate(strength):
 if not w:continue
 rim,lower,skirt=(original[r*24+j] for r in range(3))
 # Extend the end almost vertically down from the skirt. The lower bevel is deliberately small.
 dest=rim.lerp(skirt,.84)
 dest.y+=offset[j]*.55
 dest.z=4.140+end[j]
 m.vertices[j].co=rim.lerp(dest,w)
 dest=lower.lerp(skirt,.88)
 dest.y+=offset[j]
 dest.z=4.191+end[j]*.67
 m.vertices[24+j].co=lower.lerp(dest,w)
 m.vertices[48+j].co.y+=w*offset[j]*.68
m.update()
# Split face normals across the lower bevel to read as broad planes, retaining softness elsewhere.
for p in m.polygons:
 v=list(p.vertices)
 if len(v)==4 and all(i%24 in range(3,14) for i in v) and min(i//24 for i in v)==0:
  p.use_smooth=False
for name,crest in [('Large right side-sweep',3),('Left wide brushed fringe',0)]:
 m=o[name].data;uv=m.uv_layers.active
 uvmap={m.loops[l].vertex_index:tuple(uv.data[l].uv) for p in m.polygons if len(p.vertices)<8 for l in p.loop_indices}
 normals=[q.vector.copy() for q in m.corner_normals]
 for v in m.vertices:
  u,s=uvmap[v.index];j=round(u*10)%10;r=round(s*6);d=min(abs(j-crest),10-abs(j-crest))
  if r not in (2,3,4) or d>1:continue
  amp=[0,0,1,.8,.55][r]*(1 if d==0 else -.21)
  v.co+=Vector((0,-.031*amp,.027*amp))
 m.update();m.normals_split_custom_set(normals)
bpy.ops.wm.save_as_mainfile(filepath=str(b),compress=True)
