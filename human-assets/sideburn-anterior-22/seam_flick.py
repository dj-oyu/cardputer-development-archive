"""Fit short anterior ear flicks under the existing front fringe, editing only two V21 meshes."""
import bpy,sys,hashlib,json
from mathutils import Vector
from pathlib import Path
base,out=map(lambda x:Path(x).resolve(),sys.argv[-2:])
assert hashlib.sha256(base.read_bytes()).hexdigest()=='19691a0c795a78a350d853a8285dabc5eb512a5f2aa076f1298510ea3f025229'
bpy.ops.wm.open_mainfile(filepath=str(base),use_scripts=False)
bpy.context.scene.frame_set(1);bpy.context.view_layer.update()
o=bpy.data.objects
edits={
 'Left swept temple curl':[(-.65,-.246,4.804),(-.625,-.229,4.751),(-.577,-.218,4.697),(-.557,-.215,4.631),(-.517,-.253,4.559)],
 'Right framing curl':[(.65,-.205,4.838),(.622,-.200,4.782),(.589,-.186,4.724),(.554,-.205,4.650),(.517,-.248,4.564)]
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
 for j,(ring,scale) in enumerate(zip(rings,[.62,.60,.58,.90,1.])):
  st,su,sv=basis(prev,j);tt,tu,tv=basis(targets,j)
  for v in ring:
   q=v.co-prev[j]
   v.co=targets[j]+scale*(tt*q.dot(st)+tu*q.dot(su)+tv*q.dot(sv))
 data[n]={'source_centers':list(map(list,prev)),'new_centers':list(map(list,targets))}
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
par={'source':hashlib.sha256(base.read_bytes()).hexdigest(),'result':hashlib.sha256(out.read_bytes()).hexdigest(),'parts':data}
print(par)
(out.parent/'flick-parameters.json').write_text(json.dumps(par,indent=2)+'\n')
