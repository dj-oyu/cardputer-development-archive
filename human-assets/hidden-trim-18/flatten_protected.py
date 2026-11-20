"""Remove rear rim vertices only in selected rings; front arc untouched."""
import bpy,sys,json,os,hashlib
from pathlib import Path
src,dst=map(Path,sys.argv[-2:])
bpy.ops.wm.open_mainfile(filepath=str(src.resolve()),use_scripts=False)
s=bpy.context.scene;s.frame_set(1)
names=('Large right side-sweep','Left wide brushed fringe')
out={}
for name in names:
 o=s.objects[name];old=o.data;old.calc_loop_triangles();n0=len(old.loop_triangles)
 removed={int(c) for c in os.environ.get('FLAT_COLS','78')}; assert removed and removed<={7,8}
 rings={int(c) for c in os.environ.get('FLAT_RINGS','123')}; assert rings and rings<=set(range(7))
 keep=[v.index for v in old.vertices if not (v.index//10 in rings and v.index%10 in removed)]
 def route(j):
  if j//10 in rings and j%10 in removed:return j+(max(removed)+1-j%10)
  return j
 remap={j:i for i,j in enumerate(keep)}
 faces=[];rows=[]
 uv0=old.uv_layers.active
 N=[l.vector.copy() for l in old.corner_normals]
 for ref in old.polygons:
  ids=list(ref.vertices)
  src_loop={old.loops[i].vertex_index:i for i in ref.loop_indices}
  if len(ids)==10:
   js=[j for j in ids if j in remap]
  else:
   js=list(dict.fromkeys(route(j) for j in ids))
  if len(js)<3:continue
  cut=(js!=ids and len(ids)!=10)
  faces.append([remap[j] for j in js])
  if cut:
   uvs=[((j%10)/10,(j//10)/6) for j in js]
   ns=[None]*len(js)
  else:
   uvs=[tuple(uv0.data[src_loop[j]].uv) for j in js]
   ns=[N[src_loop[j]] for j in js]
  rows.append((ref.use_smooth and not cut,ref.material_index,uvs,ns))
 m=bpy.data.meshes.new(old.name+' | flat protected back')
 m.from_pydata([old.vertices[j].co for j in keep],[],faces)
 for mat in old.materials:m.materials.append(mat)
 m.update(); uv=m.uv_layers.new(name=uv0.name)
 for p,row in zip(m.polygons,rows):
  p.use_smooth,p.material_index=row[:2]
  for k,i in enumerate(p.loop_indices):uv.data[i].uv=row[2][k]
 m.update()
 normals=[None]*len(m.loops)
 for p,row in zip(m.polygons,rows):
  for i,n in zip(p.loop_indices,row[3]):normals[i]=n or p.normal
 m.normals_split_custom_set(normals);m.calc_loop_triangles()
 o.data=m
 (o.vertex_groups.get('head') or o.vertex_groups.new(name='head')).add(list(range(len(keep))),1.,'REPLACE')
 edges={}
 for poly in m.polygons:
  v=list(poly.vertices)
  for x,y in zip(v,v[1:]+v[:1]):
   k=tuple(sorted([x,y]));edges[k]=edges.get(k,0)+1
 assert set(edges.values())=={2}
 assert all(len(v.groups)==1 and v.groups[0].weight==1. for v in m.vertices)
 assert all((m.vertices[i].co-old.vertices[j].co).length==0 for i,j in enumerate(keep))
 out[name]={'before':n0,'after':len(m.loop_triangles),'old_vertices':70,'new_vertices':len(keep),'closed':True,'flat_rings':sorted(rings),'flat_cols':sorted(removed)}
bpy.context.view_layer.update();bpy.ops.wm.save_as_mainfile(filepath=str(dst.resolve()),compress=True)
out['sha256']=hashlib.sha256(dst.read_bytes()).hexdigest()
(dst.parent/(dst.stem+'-topology.json')).write_text(json.dumps(out,indent=2)+'\n')
