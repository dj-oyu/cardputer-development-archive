"""Fit short ear flicks with hidden roots, changing only two V20 sideburn meshes."""
import bpy,sys,hashlib,json
from mathutils import Vector
from mathutils.bvhtree import BVHTree
from pathlib import Path
base,out=map(lambda x:Path(x).resolve(),sys.argv[-2:])
assert hashlib.sha256(base.read_bytes()).hexdigest()=='8751786acf69e5b7f5091341c3c2cdc3e8820e87ec974c3fff5e662f22d1e382'
bpy.ops.wm.open_mainfile(filepath=str(base),use_scripts=False)
bpy.context.scene.frame_set(1);bpy.context.view_layer.update()
o=bpy.data.objects
cap=o['Bob back mass']
cap.data.calc_loop_triangles()
cap_bvh=BVHTree.FromPolygons([v.co for v in cap.data.vertices],[tuple(t.vertices) for t in cap.data.loop_triangles],all_triangles=True)
def inside(p):
 for e in ((1,.211,.13),(-.17,1,.087),(.153,-.077,1)):
  v=Vector(e).normalized();q=p.copy();hits=0
  while hits<24:
   x,_,_,_=cap_bvh.ray_cast(q,v)
   if x is None:break
   q=x+.0001*v;hits+=1
  if hits%2!=1:return False
 return True
edits={
 'Left swept temple curl':[(-.49,.15,4.80),(-.552,.12,4.724),(-.554,.003,4.649),(-.609,-.112,4.584),(-.631,-.178,4.494)],
 'Right framing curl':[(.528,.15,4.797),(.538,.165,4.726),(.602,.062,4.649),(.654,-.090,4.579),(.612,-.176,4.486)]
}
data={}
def slices(a):
 return [list(a.data.vertices[i:i+10]) for i in range(0,len(a.data.vertices),10)]
def center(vs):return sum((x.co for x in vs),Vector())/len(vs)
def basis(c,j):
 t=(c[min(j+1,len(c)-1)]-c[max(j-1,0)]).normalized()
 u=t.cross(Vector((1,0,0))).normalized()
 return t,u,u.cross(t).normalized()
for n,centers in edits.items():
 rings=slices(o[n]);assert len(rings)==5
 prev=[center(r) for r in rings];targets=list(map(Vector,centers))
 for j,(ring,scale) in enumerate(zip(rings,[.48,.46,.57,.92,1.])):
  st,su,sv=basis(prev,j);tt,tu,tv=basis(targets,j)
  for v in ring:
   q=v.co-prev[j]
   v.co=targets[j]+scale*(tt*q.dot(st)+tu*q.dot(su)+tv*q.dot(sv))
 info=[sum(inside(v.co) for v in ring) for ring in rings]
 data[n]={'cap_enclosed_vertices_by_ring':info,'source_centers':list(map(list,prev)),'new_centers':list(map(list,targets))}
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
par={'source':hashlib.sha256(base.read_bytes()).hexdigest(),'result':hashlib.sha256(out.read_bytes()).hexdigest(),'parts':data}
print(par)
(out.parent/'flick-parameters.json').write_text(json.dumps(par,indent=2)+'\n')
