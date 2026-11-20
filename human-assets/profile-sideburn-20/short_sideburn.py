"""Adjust only the ear-adjacent end of both V19 sideburns, leaving roots and all other meshes intact."""
import bpy,sys,hashlib,json
from mathutils import Vector
from pathlib import Path
base,out=map(lambda x:Path(x).resolve(),sys.argv[-2:])
assert hashlib.sha256(base.read_bytes()).hexdigest()=='5f8d8c4249294a96385c1f921514175a7307cc36c5ed4055b5cdf67880620e3e'
bpy.ops.wm.open_mainfile(filepath=str(base),use_scripts=False)
o=bpy.data.objects
edits={
 'Left swept temple curl':[(-.606,-.186,4.676),(-.637,-.177,4.598),(-.612,-.172,4.553)],
 'Right framing curl':[(.648,-.170,4.664),(.655,-.172,4.599),(.626,-.169,4.552)]
}
data={}
def slices(o):
 return [list(o.data.vertices[i:i+10]) for i in range(0,len(o.data.vertices),10)]
def center(vs):return sum((x.co for x in vs),Vector())/len(vs)
for n,centers in edits.items():
 a=o[n]; rings=slices(a);assert len(rings)==5
 before=[center(r) for r in rings]
 for ring,ctr,new,scale in zip(rings[2:],before[2:],centers,[.88,.85,1.]):
  t=Vector(new)
  for v in ring:
    v.co=t+scale*(v.co-ctr)
 data[n]={'tip_before':list(before[-1]),'tip_after':list(center(rings[-1])),'top_20_vertices_unchanged':True}
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
(out.parent/'sideburn-parameters.json').write_text(json.dumps({'source_sha256':hashlib.sha256(base.read_bytes()).hexdigest(),'output_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'parts':data},indent=2)+'\n')
