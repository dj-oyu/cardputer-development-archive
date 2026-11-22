"""Form a broad bottom segment and distinct corners in the lower rear bob only."""
import bpy,sys,hashlib
from pathlib import Path
from mathutils import Vector
a,b=map(lambda p:Path(p).resolve(),sys.argv[-2:])
assert hashlib.sha256(a.read_bytes()).hexdigest()=='1f6fa35a6f18cb0962e61819045bb80a88f781fad878e878604c01ff648b92dd'
bpy.ops.wm.open_mainfile(filepath=str(a),use_scripts=False)
m=bpy.data.objects['Bob back mass'].data
assert len(m.vertices)==192
def sample(j, points):
 for k,(l,v) in enumerate(points[:-1]):
  r,n=points[k+1]
  if l<=j<=r:return Vector(v).lerp(Vector(n),(j-l)/(r-l))
# Straight rear face. Ends turn to the side at discrete corners in plan,
# and the low band stays nearly vertical above the hem.
hem=[(1,(.817,.42,4.142)),(4,(.78,.923,4.120)),(12,(-.78,.923,4.120)),(15,(-.817,.42,4.142))]
for j in range(1,16):
 p=sample(j,hem)
 for r in (0,1):
  v=m.vertices[r*24+j]
  if r==0: v.co=p
  else:v.co=p+Vector((.014*(1 if p.x>0 else -1 if p.x<0 else 0),-.006,.103))
 # Carry a shallower broad surface through to the mature form above.
 if 2<=j<=14:
  v=m.vertices[48+j];v.co.y=v.co.y*.18+p.y*.82
 if 3<=j<=13:
  v=m.vertices[72+j];v.co.y=v.co.y*.68+p.y*.32
for j,sign in ((0,1),(16,-1)):
 a0=m.vertices[j];a1=m.vertices[24+j]
 a0.co=Vector((sign*.808,.325,4.149))
 a1.co=Vector((sign*.826,.337,4.237))
# Planar underside eliminates the rolled underside, including unshaded silhouette.
for j in range(24):
 m.vertices[j].co.z=4.130
 m.vertices[24+j].co.z=max(m.vertices[24+j].co.z,4.174)
for p in m.polygons:
 ids=list(p.vertices)
 if len(ids)==4 and min(i//24 for i in ids)==0 and all(1<=i%24<=15 for i in ids):
  p.use_smooth=False
m.update()
bpy.ops.wm.save_as_mainfile(filepath=str(b),compress=True)
