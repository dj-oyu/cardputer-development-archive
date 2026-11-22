"""Compare the root and tip ring coordinates (via authored UV ring) and evaluated triangle totals."""
import bpy,sys,json,hashlib
from collections import defaultdict
from pathlib import Path
parts=('Left wide brushed fringe','Large right side-sweep')
def snapshot(path):
 bpy.ops.wm.open_mainfile(filepath=str(path.resolve()),use_scripts=False)
 s=bpy.context.scene;s.frame_set(1);dg=bpy.context.evaluated_depsgraph_get()
 pins={};counts={};flatcounts={}
 hairs={o.name for o in bpy.data.collections['Hair – sculpted locks'].objects};assert len(hairs)==6
 for n in hairs|{o.name for o in s.objects if o.type=='MESH' and any(m.type=='ARMATURE' for m in o.modifiers)}:
  o=s.objects[n];ev=o.evaluated_get(dg);m=ev.to_mesh();m.calc_loop_triangles();counts[n]=len(m.loop_triangles);ev.to_mesh_clear()
  if n not in parts:continue
  m=o.data; q=defaultdict(set); uv=m.uv_layers.active
  for p in m.polygons:
   if len(p.vertices)>=8:continue
   for l in p.loop_indices:
    k=round(uv.data[l].uv.y*6)
    if k in (0,1,5,6):q[k].add(tuple(m.vertices[m.loops[l].vertex_index].co))
  pins[n]=dict(q)
  flatcounts[n]={k:len(c) for k,c in q.items()}
 return pins, {'hair':sum(counts[n] for n in hairs),'rig_bound':sum(counts.values()),'bangs':{n:counts[n] for n in parts},'pinned_vertices_by_original_ring':flatcounts}
a,b,c,out=map(Path,sys.argv[-4:])
base=x=snapshot(a); variant=snapshot(b); red=snapshot(c)
assert base[0]==variant[0]==red[0]
assert red[1]['hair']==base[1]['hair']-4 and red[1]['rig_bound']==base[1]['rig_bound']-4
out.write_text(json.dumps({key:{'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),**stats} for key,p,stats in zip(('before','contact','reduced'),(a,b,c),(base[1],variant[1],red[1]))},indent=2)+'\n')
