"""Closed edge collapse only where old and new surfaces are volume-certified inside the cap."""
import bpy,sys,json,hashlib
from pathlib import Path
from mathutils import Vector
from mathutils.bvhtree import BVHTree
source,out=map(Path,sys.argv[-2:])
bpy.ops.wm.open_mainfile(filepath=str(source.resolve()),use_scripts=False)
cap=bpy.data.objects['Bob back mass'];m=cap.data;m.calc_loop_triangles()
assert all(sum(1 for p in m.polygons if set(e.vertices)<set(p.vertices))>=1 for e in m.edges)
tree=BVHTree.FromPolygons([v.co for v in m.vertices],[tuple(t.vertices) for t in m.loop_triangles],all_triangles=True)
def inside(p):
 for c in ((1,.211,.13),(-.17,1,.087),(.153,-.077,1)):
  v=Vector(c).normalized();q=p.copy();hits=0
  while hits<100:
   x,_,_,_=tree.ray_cast(q,v)
   if x is None:break
   q=x+.00002*v;hits+=1
  if hits%2!=1:return False
 return True
def proof(tris):
 margin=100.
 for A,B,C in tris:
  div=28
  radius=max((A-B).length,(A-C).length,(B-C).length)/div
  for i in range(div+1):
   for j in range(div+1-i):
    p=A+(B-A)*(i/div)+(C-A)*(j/div)
    _,_,_,d=tree.find_nearest(p)
    if d is None or d<=radius+.0005 or not inside(p):return None
    margin=min(margin,d-radius)
 return margin
def closed(m):
 d={}
 for p in m.polygons:
  vs=list(p.vertices)
  for i,j in zip(vs,vs[1:]+vs[:1]):
   k=tuple(sorted((i,j)));d[k]=d.get(k,0)+1
 return set(d.values())=={2}
assert closed(cap.data)
def rigcheck(o):
 assert all(len(v.groups)==1 and o.vertex_groups[v.groups[0].group].name=='head' and v.groups[0].weight==1. for v in o.data.vertices)
 assert o.matrix_world==cap.matrix_world
rigcheck(cap)
result={}
for n, cols in [('Large right side-sweep',{8:9,9:8,7:8}),('Left wide brushed fringe',{7:6,6:7,8:7})]:
 o=bpy.data.objects[n];rigcheck(o);m=o.data;m.calc_loop_triangles()
 q={m.loops[l].vertex_index:tuple(m.uv_layers.active.data[l].uv) for p in m.polygons if len(p.vertices)<8 for l in p.loop_indices}
 qp={(round(s*6),round(u*10)%10):i for i,(u,s) in q.items()}
 report=[]
 for r in (2,3,4):
  for i,j in cols.items():
   drop,keep=qp[r,i],qp[r,j]
   ps={p.index for p in m.polygons if drop in p.vertices}
   old=[[m.vertices[v].co.copy() for v in t.vertices] for t in m.loop_triangles if t.polygon_index in ps]
   first=proof(old)
   if first is None:continue
   verts=[v.index for v in m.vertices if v.index!=drop]; remap={j:i for i,j in enumerate(verts)}
   def route(v):return keep if v==drop else v
   fs=[];rows=[];changed=set()
   for p in m.polygons:
    ids=list(dict.fromkeys(route(v) for v in p.vertices))
    if len(ids)<3:continue
    if p.index in ps:changed.add(len(fs))
    loops={m.loops[l].vertex_index:l for l in p.loop_indices}
    fs.append([remap[j] for j in ids])
    rows.append((p.material_index,p.use_smooth,[(tuple(m.uv_layers.active.data[loops.get(j,loops.get(drop))].uv),m.corner_normals[loops.get(j,loops.get(drop))].vector.copy()) for j in ids]))
   alt=bpy.data.meshes.new(m.name+' | certified hidden collapse')
   alt.from_pydata([m.vertices[v].co for v in verts],[],fs);alt.update();alt.calc_loop_triangles()
   if not closed(alt):bpy.data.meshes.remove(alt);continue
   new=[[alt.vertices[v].co.copy() for v in t.vertices] for t in alt.loop_triangles if t.polygon_index in changed]
   second=proof(new)
   if second is None:bpy.data.meshes.remove(alt);continue
   for mat in m.materials:alt.materials.append(mat)
   uv=alt.uv_layers.new(name=m.uv_layers.active.name);normals=[None]*len(alt.loops)
   for p,(pidx,smooth,attrib) in zip(alt.polygons,rows):
    p.material_index,p.use_smooth=pidx,smooth
    for l,(u,normal) in zip(p.loop_indices,attrib):uv.data[l].uv=u;normals[l]=normal
   alt.normals_split_custom_set(normals)
   report.append({'ring':r,'column':i,'collapse_toward':j,'triangles_before':len(m.loop_triangles),'triangles_after':len(alt.loop_triangles),'original_inside_margin':first,'replacement_inside_margin':second})
   o.data=alt;(o.vertex_groups.get("head") or o.vertex_groups.new(name="head")).add(list(range(len(alt.vertices))),1.,'REPLACE');rigcheck(o)
   break
  if report:break
 result[n]=report
print('CERT',result)
bpy.ops.wm.save_as_mainfile(filepath=str(out.resolve()),compress=True)
out.with_suffix('.json').write_text(json.dumps(result,indent=2)+'\n')
