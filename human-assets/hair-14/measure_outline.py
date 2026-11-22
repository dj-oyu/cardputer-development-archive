"""Extract hair-only projected triangles and world-space X section widths."""
import sys,math,json,bpy
from pathlib import Path
from mathutils import Vector
from mathutils.bvhtree import BVHTree
from bpy_extras.object_utils import world_to_camera_view
src,out=map(lambda p:Path(p).resolve(),sys.argv[-2:])
bpy.ops.wm.open_mainfile(filepath=str(src),use_scripts=False);s=bpy.context.scene;s.frame_set(1);bpy.context.view_layer.update()
groups={};hair=bpy.data.collections['Hair – sculpted locks'];dg=bpy.context.evaluated_depsgraph_get()
for o in hair.objects:
 e=o.evaluated_get(dg);m=e.to_mesh();m.calc_loop_triangles()
 groups[o.name]=[tuple(e.matrix_world@m.vertices[i].co for i in p.vertices) for p in m.loop_triangles]
 e.to_mesh_clear()
def section(z,tri):
 pts=[]
 for f in tri:
    for p,q in zip(f,(f[1],f[2],f[0])):
      if (p.z<=z<q.z or q.z<=z<p.z):
       pts.append(p.lerp(q,(z-p.z)/(q.z-p.z)))
 return pts
zs=[4.26,4.32,4.43,4.50,4.57,4.64,4.71,4.78,4.85,4.92,4.99,5.06,5.13]
sections={}
for z in zs:
 ext={}
 for deg in (0,-35,180):
  a=math.radians(deg)
  def measure(f):
   x=[math.cos(a)*p.x+math.sin(a)*p.y for p in section(z,f)]
   return [min(x),max(x),max(x)-min(x)]
  ext[str(deg)]={'cap':measure(groups['Bob back mass']),'all_hair':measure(sum(groups.values(),[]))}
 sections[str(z)]=ext
proj={}
cam=s.camera;cam.data.type='ORTHO'
for mode,z,scale,wh in [('face',4.76,2.24,(360,320)),('native',2.79,10.6,(240,135))]:
 target=Vector((0,0,z));cam.data.ortho_scale=scale
 s.render.resolution_x,s.render.resolution_y=wh;s.render.resolution_percentage=100
 for deg,view in [(0,'front'),(-35,'oblique'),(180,'back')]:
  a=math.radians(deg);cam.location=(math.sin(a)*13,-math.cos(a)*13,z+(.66 if mode=='native' else .24))
  cam.rotation_euler=(target-cam.location).to_track_quat('-Z','Y').to_euler()
  bpy.context.view_layer.update()
  def pixel(p):
   u=world_to_camera_view(s,cam,p)
   return [float(u.x)*wh[0],(1-float(u.y))*wh[1]]
  proj[f'{mode}-{view}']={'resolution':wh,'triangles':[[pixel(p) for p in f] for f in sum(groups.values(),[])]}
bvh={name:BVHTree.FromPolygons(sum([list(t) for t in fs],[]),[(i,i+1,i+2) for i in range(0,len(fs)*3,3)],all_triangles=True) for name,fs in groups.items()}
contacts={a:{b:len(bvh[a].overlap(bvh[b])) for b in ('Bob back mass','Left wide brushed fringe','Large right side-sweep') if a!=b} for a in ('Left swept temple curl','Right framing curl')}
out.write_text(json.dumps({'sections':sections,'projected':proj,'temple_triangle_pair_contacts':contacts}))
