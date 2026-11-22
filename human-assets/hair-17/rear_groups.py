"""Integrated large grouped locks on rear half of the single cap. No layer/paint additions."""
import bpy,sys,hashlib,json,math,os
from pathlib import Path
from mathutils import Vector
src,out=map(lambda p:Path(p).resolve(),sys.argv[-2:])
assert hashlib.sha256(src.read_bytes()).hexdigest()=='c16453f2a18d81b860b1127d223c0021c18e17b063e98e4c69f700cf2095929f'
bpy.ops.wm.open_mainfile(filepath=str(src),use_scripts=False)
o=bpy.data.objects['Bob back mass'];m0=o.data;mat=m0.materials[0]
# Only subdivide the closed rear-half collar, preserving the source front
# vertices and all other objects. Connect actual broad bevels around two
# interlocking valleys; no loosened panels, duplicates or disconnected islands.
grid=[j/2 for j in range(16)]+list(range(8,16));k=len(grid)
verts=[];faces=[tuple(reversed(range(k))),tuple(range(7*k,8*k))]
amp=float(os.getenv('HAIR_GROUP_DEPTH','1'))
def g(u,c,w):return math.exp(-((u-c)/w)**2)
for r in range(8):
 t=r/7
 for j in grid:
  q=math.floor(j)
  a=m0.vertices[16*r+q].co
  b=m0.vertices[16*r+(q+1)%16].co
  v=a.lerp(b,j-q)
  u=j/16
  if 0<u<.5:
   # Curved partings taper near crown and skirt out into the lower silhouette.
   fade=(math.sin(math.pi*t)**.72)*math.sin(2*math.pi*u)**.62
   c0=.139+.060*t+.009*math.sin(math.pi*t)
   c1=.361-.091*t-.012*math.sin(math.pi*t)
   valley=g(u,c0,.034)+.93*g(u,c1,.037)
   rolls=g(u,c0-.068,.053)+g(u,c0+.079,.061)+.72*g(u,c1+.066,.054)
   v.y+=amp*fade*(.146*rolls-.128*valley)
   # A shallow scallop across the lower rear rim, not a cut into the side outline.
   t_low=math.exp(-((t-.085)/.17)**2)
   v.z+=amp*.071*t_low*math.sin(2*math.pi*u)*(g(u,c0,.030)+.82*g(u,c1,.035))
  verts.append(v)
for r in range(7):
 for j in range(k):
  nxt=(j+1)%k;faces.append((r*k+j,r*k+nxt,(r+1)*k+nxt,(r+1)*k+j))
m=bpy.data.meshes.new('Back cap with broad grouped relief');m.from_pydata(verts,[],faces);m.update()
m.materials.append(mat);o.data=m
bpy.data.meshes.remove(m0)
uv=m.uv_layers.new(name='MoldedHair_PaintedFlow')
for p in m.polygons:
 ids=[m.loops[i].vertex_index for i in p.loop_indices]
 js=[i%k for i in ids]
 seam=0 in js and k-1 in js
 for li,j in zip(p.loop_indices,ids):
  u,v=grid[j%k]/16,(j//k)/7
  if len(ids)==k:u=.5
  elif seam and j%k==0:u=1.
  uv.data[li].uv=(u,v)
 p.use_smooth=len(ids)==4
o.vertex_groups.new(name='head').add(list(range(len(m.vertices))),1.,'REPLACE')
m.calc_loop_triangles()
assert len(m.loop_triangles)==380
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
(out.parent/'cap-shape.json').write_text(json.dumps({'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'output_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'cap_triangles':len(m.loop_triangles),'cap_vertices':len(m.vertices),'amplitude':amp},indent=2)+'\n')
