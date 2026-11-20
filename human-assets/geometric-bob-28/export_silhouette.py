"""Read the evaluated bob-only projected triangles under exact matched camera scale."""
import bpy,sys,math,json
from pathlib import Path
from mathutils import Vector
a,b,out=map(Path,sys.argv[-3:])
result={}
for p,tag in ((a,'v27'),(b,'v28')):
 bpy.ops.wm.open_mainfile(filepath=str(p.resolve()),use_scripts=False)
 s=bpy.context.scene;s.frame_set(1)
 o=bpy.data.objects['Bob back mass'].evaluated_get(bpy.context.evaluated_depsgraph_get())
 m=o.to_mesh();m.calc_loop_triangles()
 result[tag]={}
 for th in (180,145,-145):
  rad=math.radians(th);z=4.72;scale=2.24;w=900;h=800
  target=Vector((0,0,z));camera=Vector((math.sin(rad)*13,-math.cos(rad)*13,z))
  q=(target-camera).to_track_quat('-Z','Y')
  rt=q@Vector((1,0,0));up=q@Vector((0,1,0))
  verts=[]
  for v in m.vertices:
   dv=o.matrix_world@v.co-target
   verts.append([round(w/2+dv.dot(rt)*w/scale,5),round(h/2-dv.dot(up)*w/scale,5)])
  result[tag][str(th)]={'size':[w,h],'triangles':[list(x.vertices) for x in m.loop_triangles],'projected':verts}
 o.to_mesh_clear()
out.write_text(json.dumps(result,separators=(',',':'))+'\n')
