import bpy,sys,math,json,hashlib
import numpy as np
from mathutils.bvhtree import BVHTree
from mathutils import Vector
from pathlib import Path
b,a,out=map(Path,sys.argv[-3:]); keys=('Large right side-sweep','Left wide brushed fringe')
def load(path):
 bpy.ops.wm.open_mainfile(filepath=str(path.resolve()),use_scripts=False)
 s=bpy.context.scene; s.frame_set(1); bpy.context.view_layer.update(); dg=bpy.context.evaluated_depsgraph_get()
 def tree(o):
  e=o.evaluated_get(dg);m=e.to_mesh();m.calc_loop_triangles()
  vs=[e.matrix_world@v.co for v in m.vertices];fs=[tuple(t.vertices) for t in m.loop_triangles];e.to_mesh_clear()
  return (BVHTree.FromPolygons(vs,fs,all_triangles=True),len(fs))
 name_to_id={
 'Sculpted cheeks, jaw and cranium':1,'Large right side-sweep':2,'Left wide brushed fringe':3,
 'Bob back mass':4,'Left swept temple curl':5,'Right framing curl':6,'Little lifted crown tuft':7,'Outer light airy tuft':8
 }
 T={name_to_id[n]:tree(s.objects[n]) for n in name_to_id if n in s.objects}
 def view(z,scale,w,h,deg,dz):
  a=math.radians(deg);cam=Vector((math.sin(a)*13,-math.cos(a)*13,z+dz))
  q=(Vector((0,0,z))-cam).to_track_quat('-Z','Y')
  rx,up,dr=[q@Vector(k) for k in [(1,0,0),(0,1,0),(0,0,-1)]]
  ps=scale/w
  I=np.zeros((h,w),dtype='uint8')
  for x in range(w):
   wpoint=cam+rx*(x+.5-w/2)*ps
   for y in range(h):
    p=wpoint+up*(h/2-y-.5)*ps
    best=(-1.,0)
    for k,(t,_) in T.items():
     pt,n,ix,d=t.ray_cast(p,dr)
     if d is not None and (d<best[0] or best[1]==0):best=(d,k)
    I[y,x]=best[1]
  return I
 rig=next(o for o in s.objects if o.type=='ARMATURE')
 assert all(all(len(v.groups)==1 and o.vertex_groups[v.groups[0].group].name=='head' and v.groups[0].weight==1. for v in o.data.vertices) for o in (s.objects[k] for k in keys))
 images={i.name:hashlib.sha256(i.packed_file.data).hexdigest() for i in bpy.data.images if i.packed_file}
 frames={}
 for f in [1,8,15,23,30]:
  s.frame_set(f);bpy.context.view_layer.update()
  frames[f]={p.name:[list(row) for row in p.matrix] for p in rig.pose.bones}
 views={}
 for tag,z,scale,w,h,dz in [('close',4.76,2.24,180,160,.24),('native',2.79,10.6,240,135,.66)]:
  for deg in (0,-35,35,-90,90):
   views[tag+str(deg)]=view(z,scale,w,h,deg,dz)
 return views,sum(c for i,(_,c) in T.items() if i!=1),frames,images
A,ta,fa,ia=load(b);B,tb,fb,ib=load(a)
assert fa==fb and ia==ib
report={k:{'visible_object_pixels_changed':int((x!=B[k]).sum()),'new_skull_pixels':int(((x!=1)&(B[k]==1)).sum()),'new_background_pixels':int(((x!=0)&(B[k]==0)).sum()),'new_skull_xy':np.argwhere((x!=1)&(B[k]==1)).tolist()} for k,x in A.items()}
out.write_text(json.dumps({'verified_pose_samples':list(fa),'unchanged_packed_images':len(ia),'hair_triangles':[ta,tb],'pixel_delta':report},indent=2)+'\n')
