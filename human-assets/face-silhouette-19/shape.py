"""V19 alternate jaw shape. Exact v18 input; modify only cheek/jaw vertices."""
import bpy, hashlib, json, sys
from pathlib import Path
source, dest = [Path(p).resolve() for p in sys.argv[-3:-1]]
strength=float(sys.argv[-1])
assert hashlib.sha256(source.read_bytes()).hexdigest() == '91cbf6204f73a30e007c909221a33c3a6e0b0f9a622394ecd4509c50b81417d4'
bpy.ops.wm.open_mainfile(filepath=str(source))
head=bpy.data.objects['Sculpted cheeks, jaw and cranium']
def ramp(x,a,b):
 t=max(0.,min(1.,(x-a)/(b-a)));return t*t*(3-2*t)
moved=[]
for v in head.data.vertices:
 x,y,z=v.co
 lo=abs(z-4.26)<.005; hi=abs(z-4.37)<.005
 if not(lo or hi): continue
 # Rear cranium & under-neck contact stay pinned. Widen the lower turns,
 # prioritize contour over decal center, and tuck/raise the forward chin.
 front=1-ramp(y,-.09,.038)
 shoulder=ramp(abs(x),.048,.234)
 center=1-ramp(abs(x),.065,.210)
 dx=(1 if x>0 else -1)*front*shoulder*(.055 if lo else .030)
 dz=front*(.044 if lo else .018)*(.54+.46*center)
 dy=front*center*(.036 if lo else .025)
 if max(abs(dx),abs(dy),abs(dz))<1e-7: continue
 v.co.x += strength*dx; v.co.y += strength*dy; v.co.z += strength*dz
 moved.append(v.index)
head.data.update()
scene=bpy.context.scene;scene['human_v19_face_silhouette']=f'Cheek/jaw/chin strength {strength:.2f}; eye ring, neck contact and rear pinned.'
bpy.ops.wm.save_as_mainfile(filepath=str(dest),compress=True)
print('moved',moved)
