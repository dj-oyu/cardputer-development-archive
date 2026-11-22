"""Match both thigh and calf silhouette to user guide; preserve the knee rig and boot/shorts joins."""
import bpy,sys,hashlib,math
from pathlib import Path
a,b=map(Path,sys.argv[-2:])
assert hashlib.sha256(a.read_bytes()).hexdigest()=='b03a057a241318f2458e28209358383efb635041aa7968c0c4500d236c15d830'
bpy.ops.wm.open_mainfile(filepath=str(a.resolve()),use_scripts=False)
# (outer X, inner X, depth proportion, height). Render guide is 138.7 px/BU.
sections={
 .998:(.608,.365,.76,.998),
 1.244:(.655,.252,1.025,1.353),
 1.708:(.552,.234,1.035,1.708),
 1.878:(.549,.190,1.14,1.878),
 2.020:(.549,.142,1.13,2.020),
 2.164:(.543,.099,1.055,2.164),
}
for sign,n in ((-1,'Thigh to shin continuous leg'),(1,'Thigh to shin continuous leg.001')):
 m=bpy.data.objects[n].data
 for z,(outer,inner,depth,z1) in sections.items():
  vs=[v for v in m.vertices if abs(v.co.z-z)<.00045];assert len(vs)==14
  amin=min(abs(v.co.x) for v in vs);amax=max(abs(v.co.x) for v in vs)
  cy=sum(v.co.y for v in vs)/len(vs)
  for v in vs:
   q=(abs(v.co.x)-amin)/(amax-amin)
   v.co.x=sign*(inner+(outer-inner)*q)
   v.co.y=cy+(v.co.y-cy)*depth
   v.co.z=z1
 m.update()
bpy.ops.wm.save_as_mainfile(filepath=str(b.resolve()),compress=True)
