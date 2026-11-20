"""Settle two bang roots into the cap; leave the six hair pieces separately editable."""
import bpy,sys,hashlib,json
from pathlib import Path
from mathutils import Vector
from mathutils.bvhtree import BVHTree
src,out=map(lambda p:Path(p).resolve(),sys.argv[-2:])
assert hashlib.sha256(src.read_bytes()).hexdigest()=='6b9bb4fe2c05bbeb49aca31fc6735aff7256b4999b04a1e7957bebc2433e2021'
bpy.ops.wm.open_mainfile(filepath=str(src),use_scripts=False)
o=bpy.data.objects
c=o['Bob back mass'].data
tree=BVHTree.FromPolygons([v.co for v in c.vertices],[list(p.vertices) for p in c.polygons])
report={}
for n,arc in [('Large right side-sweep',[.18,.20,.36,.69,.86,.93,.93,.87,.60,.34]),('Left wide brushed fringe',[.88,.76,.58,.27,.21,.28,.51,.88,.94,.96])]:
 m=o[n].data; uv=m.uv_layers.active
 uvmap={m.loops[l].vertex_index: tuple(uv.data[l].uv) for p in m.polygons if len(p.vertices)<8 for l in p.loop_indices}
 sn=[None]*len(m.vertices); report[n]=[]
 normals=[p.vector.copy() for p in m.corner_normals]
 for v in m.vertices:
  x,y,z=v.co; u,s=uvmap[v.index]; j=round(u*10)%10;k=round(s*6)
  if k>3:continue
  center=Vector((x*.34,.14,4.72)); dr=(v.co-center).normalized(); p,normal,_,_=tree.ray_cast(center+5*dr,-dr)
  assert p is not None
  gap=(v.co-p).dot(dr)
  if k==0:
   # Bury the whole initial rim; the subsequent section feathers onto the surface.
   v.co+=Vector((0.,.028,-.084 if n.startswith('Large') else -.047))
  else:
   amt=[0,.90,.64,.19][k]*arc[j]
   if gap>-.018:v.co-=dr*(gap+.018)*amt
  g1=(v.co-p).dot(dr)
  if k==0: blend=.81
  else: blend=max(0.,min(.72,(.115-max(0.,g1))/.115*.73))*([0.,1.,.70,.30][k])
  sn[v.index]=(normal,blend)
  report[n].append({'vertex':v.index,'ring':k,'radial_cap_gap_before':round(gap,6),'radial_cap_gap_after':round(g1,6),'normal_mix':round(blend,4)})
 for l in m.loops:
  pair=sn[l.vertex_index]
  if pair:normals[l.index]=normals[l.index].lerp(pair[0],pair[1]).normalized()
 m.normals_split_custom_set(normals);m.update()
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
(out.parent/'fringe-parameters.json').write_text(json.dumps({'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'result_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'parts':report},indent=2)+'\n')
