"""Local corrective for v19 lower jaw ledge. Baseline v18 + matching v19 head; hair untouched."""
import bpy,sys,hashlib,struct
from pathlib import Path
b,s,o=map(lambda p:Path(p).resolve(),sys.argv[-3:])
key='Sculpted cheeks, jaw and cranium'
assert hashlib.sha256(b.read_bytes()).hexdigest()=="91cbf6204f73a30e007c909221a33c3a6e0b0f9a622394ecd4509c50b81417d4"
bpy.ops.wm.open_mainfile(filepath=str(b),use_scripts=False)
obj=bpy.data.objects[key]; orig=[p.co.copy() for p in obj.data.vertices]
polys=[tuple(p.vertices) for p in obj.data.polygons]
bpy.ops.wm.open_mainfile(filepath=str(s),use_scripts=False)
obj=bpy.data.objects[key]
assert len(obj.data.vertices)==len(orig) and [tuple(p.vertices) for p in obj.data.polygons]==polys
assert hashlib.sha256(b"".join(struct.pack("<3f", *v.co) for v in obj.data.vertices)).hexdigest()=="c96deda57b49542849568f12d3e8a0c15528787762aec26c1ee4a9695ed66795", "This patch requires the exact v19 head mesh, but permits changed hair."
def smooth(x,a,b):
 t=min(1,max(0,(x-a)/(b-a)));return t*t*(3-2*t)
count=0
for p,q in zip(obj.data.vertices,orig):
 x,y,z=q
 lo=abs(z-4.26)<.005; hi=abs(z-4.37)<.005
 if (not lo and not hi) or y>=-.11: continue
 f=(1-smooth(y,-.25,-.11))*(1-.35*smooth(abs(x),.15,.28))
 dy=(p.co.y-y)*f*(.78 if lo else .33)
 dz=(p.co.z-z)*f*(.72 if lo else .22)
 if abs(dy)+abs(dz)<1e-6:continue
 p.co.y-=dy;p.co.z-=dz;count+=1
assert count
obj.data.update()
bpy.context.scene['human_v19_profile_correction']='Only forward lower jaw Y/Z partly restored toward v18; v19 cheek width and fixed lower contact maintained.'
bpy.ops.wm.save_as_mainfile(filepath=str(o),compress=True)
print('corrected',count,'sha256',hashlib.sha256(o.read_bytes()).hexdigest())
