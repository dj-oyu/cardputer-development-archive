"""Compare topological identity, rig and authored poses, plus rest-space edit bounds."""
import bpy,sys,json,hashlib
from pathlib import Path
p0,p1=map(Path,sys.argv[-2:])
def M(a): return [[float(x) for x in row] for row in a]
def read(p):
 bpy.ops.wm.open_mainfile(filepath=str(p.resolve()))
 s=bpy.context.scene
 r=next(o for o in s.objects if o.type=='ARMATURE')
 s.frame_set(1)
 rig={b.name:[M(b.matrix_local),b.parent.name if b.parent else None] for b in r.data.bones}
 curves={}
 for f in (1,15,30):
  s.frame_set(f);bpy.context.view_layer.update()
  curves[str(f)]={b.name:M(b.matrix) for b in r.pose.bones}
 s.frame_set(1)
 mesh={};pts={};extra={}; external=[]
 for im in bpy.data.images:
  if im.source in {'FILE','SEQUENCE','MOVIE'}:external.append(im.name)
 assert not external, external
 for o in s.objects:
  if o.type!='MESH' or not o.modifiers.get('Provisional joint continuity'):continue
  o.data.calc_loop_triangles()
  mesh[o.name]={
   'triangles':len(o.data.loop_triangles),
   'topology':[tuple(x.vertices) for x in o.data.polygons],
   'groups':[[[o.vertex_groups[g.group].name,float(g.weight)] for g in v.groups] for v in o.data.vertices],
   'mats':[m.name for m in o.data.materials],
   'coordspace':M(o.matrix_world)}
  if o.name.startswith('Dark amber iris rim'):
   extra[o.name]=len(o.data.loop_triangles)
   assert o.modifiers['Provisional joint continuity'].object==r
   assert all(len(v.groups)==1 and o.vertex_groups[v.groups[0].group].name=='head' and abs(v.groups[0].weight-1)<1e-6 for v in o.data.vertices)
   del mesh[o.name]
   continue
  pts[o.name]=[tuple(o.matrix_world@v.co) for v in o.data.vertices]
 return [s.frame_start,s.frame_end],rig,curves,mesh,pts,extra
a=read(p0);b=read(p1)
assert a[:4]==b[:4], "Object topology/material assignment, weight or motion changed"
dx=dy=dz=0.
for key in a[4]:
 for v,w in zip(a[4][key],b[4][key]):
  dx=max(dx,abs(v[0]-w[0]));dy=max(dy,abs(v[1]-w[1]));dz=max(dz,abs(v[2]-w[2]))
assert dx<.35 and dz<.06
assert set(b[5])=={'Dark amber iris rim','Dark amber iris rim.001'} and not a[5]
for n in a[4]:
 if not n.startswith(('Upper charcoal eye','Ivory sclera','Amber iris','Dark oval pupil','Large eye glint','Arched expressive eyebrow','Small asymmetric warm smile','Left swept temple curl','Right framing curl','Swept layered back nape lock','Bob back mass','Ear shell','Ear bowl','Upturned jacket lapel')):
  assert a[4][n]==b[4][n], n
result=dict(sources=[hashlib.sha256(p.read_bytes()).hexdigest() for p in (p0,p1)],verified_poses=[1,15,30],rig_bones=len(a[1]),objects=len(a[3]),vertices=sum(len(t) for t in a[4].values()),raw_bound_mesh_triangles=sum(v['triangles'] for v in a[3].values()),extra_rigged_mesh_triangles=b[5],maximum_rest_world_delta=[dx,dy,dz])
(p1.parent/'integrity.json').write_text(json.dumps(result,indent=2)+'\n')
print(result)
