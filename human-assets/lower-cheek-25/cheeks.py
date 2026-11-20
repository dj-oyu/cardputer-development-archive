"""Lower-cheek volume redesign, with fixed projected expression marks and neck contact."""
import bpy,sys,hashlib,math
from pathlib import Path
source,out=map(lambda p:Path(p).resolve(),sys.argv[-3:-1]);strength=float(sys.argv[-1]); refined = out.stem == "smooth"
assert hashlib.sha256(source.read_bytes()).hexdigest() =='ee8d68583067d14d3a4656fece33259b9d6a015ff8f77960f08bef988b59a590'
bpy.ops.wm.open_mainfile(filepath=str(source),use_scripts=False)
h=bpy.data.objects['Sculpted cheeks, jaw and cranium']
def s(v,a,b):
 t=max(0,min(1,(v-a)/(b-a)));return t*t*(3-2*t)
for v in h.data.vertices:
 x,y,z=v.co
 i=min(range(3),key=lambda i:abs(z-(4.27,4.38,4.56)[i]))
 if abs(z-(4.27,4.38,4.56)[i])>.06 or z<4.23:continue
 lateral=s(abs(x),.12,.30); rear=1-s(y,.03,.17)
 # Widen cheek sides and round the low jaw, each successively tighter toward the chin.
 v.co.x+=math.copysign(strength*lateral*rear*((.071,.114,.044) if refined else (.105,.128,.036))[i]*(.56+.44*s(y,-.34,-.12) if refined else 1),x)
 v.co.y-=strength*lateral*rear*(.018,.038,.032)[i]*(1-s(abs(x),.32,.53))
 # Do not lift the chin. Pull the widest cheek volume down slightly, only at its sides.
 if i==2:v.co.z-=strength*lateral*rear*(.017 if refined else .034)
 if refined and i==1:v.co.z+=strength*lateral*rear*.012
h.data.update()
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
print(out.name,hashlib.sha256(out.read_bytes()).hexdigest())
