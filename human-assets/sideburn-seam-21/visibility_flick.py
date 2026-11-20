"""Ray-test each flick root/exit against actual opaque head pieces in close/native cameras."""
import bpy,sys,math,json
from pathlib import Path
from mathutils import Vector
from mathutils.bvhtree import BVHTree
before,after,out=map(lambda p:Path(p).resolve(),sys.argv[-3:])
parts=['Left swept temple curl','Right framing curl']
def measure(path):
 bpy.ops.wm.open_mainfile(filepath=str(path),use_scripts=False)
 s=bpy.context.scene;s.frame_set(1);dg=bpy.context.evaluated_depsgraph_get()
 names={o.name for o in bpy.data.collections['Hair – sculpted locks'].objects}
 names.update(['Sculpted cheeks, jaw and cranium','Ear shell','Ear shell.001','Ear bowl','Ear bowl.001','Neck'])
 data={}
 for n in sorted(names):
  o=bpy.data.objects[n].evaluated_get(dg);m=o.to_mesh();m.calc_loop_triangles();t=[tuple(f.vertices) for f in m.loop_triangles];v=[o.matrix_world@v.co for v in m.vertices]
  data[n]=BVHTree.FromPolygons(v,t,all_triangles=True),[max(f)//10 for f in t]
  o.to_mesh_clear()
 ans={}
 for mode,w,h,z,scale,dz in [('close',360,320,4.72,2.24,0),('native',240,135,2.79,10.6,.66)]:
  for deg in (-90,-35,0,35,90):
   a=math.radians(deg);cam=Vector((math.sin(a)*13,-math.cos(a)*13,z+dz))
   q=(Vector((0,0,z))-cam).to_track_quat('-Z','Y')
   rx,up,dr=[q@Vector(k) for k in [(1,0,0),(0,1,0),(0,0,-1)]]
   res={n:[0]*5 for n in parts}
   for x in range(w):
    wx=cam+rx*(x+.5-w/2)*(scale/w)
    for y in range(h if mode=='close' else 47):
     p=wx+up*(h/2-y-.5)*(scale/w)
     best=(100.,None,0)
     for n,(tree,idx) in data.items():
      _,_,i,d=tree.ray_cast(p,dr)
      if d is not None and d<best[0]:best=(d,n,idx[i])
     if best[1] in res:res[best[1]][best[2]]+=1
   ans[mode+str(deg)]=res
 return ans
a,b=measure(before),measure(after)
assert all(sum(v[:2])==0 for w in b.values() for v in w.values()),'root rings visible from checked cameras'
out.write_text(json.dumps({'mode':'nearest visible evaluated mesh per center pixel, bin = highest source ring index of hit triangle','before':a,'after':b},indent=2)+'\n')
