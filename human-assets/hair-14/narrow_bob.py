"""Small mid-side trim of v13. Leave everything but rear cap vertex X unchanged."""
import bpy,sys,math,hashlib,json
from pathlib import Path
src,dst=map(lambda p:Path(p).resolve(),sys.argv[-2:])
assert hashlib.sha256(src.read_bytes()).hexdigest()=='7d278195575d2fb73259aaad84b00dc228174d39b2f8c2b556f54613ab85dd6c'
bpy.ops.wm.open_mainfile(filepath=str(src),use_scripts=False)
o=bpy.data.objects['Bob back mass']
def step(a,b,x):
 t=max(0.,min(1.,(x-a)/(b-a)));return t*t*(3-2*t)
rows=[]
for v in o.data.vertices:
 x,y,z=v.co
 # A full-width hem at every point below 4.43; soften into a broad
 # middle narrowing, then release gently before the crown.
 vertical=step(4.43,4.62,z)*(1-step(4.67,5.10,z))
 side=step(.35,.67,abs(x))
 # Leave the front/ear saddle alone; work on the structural side surfaces.
 protect_ear=step(-.10,.20,y)
 ratio=.048*vertical*side*protect_ear
 v.co.x=x*(1-ratio)
 if ratio:rows.append((v.index,x,y,z,float(v.co.x)))
bpy.ops.wm.save_as_mainfile(filepath=str(dst),compress=True)
(dst.parent/'trim-parameters.json').write_text(json.dumps({'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'output_sha256':hashlib.sha256(dst.read_bytes()).hexdigest(),'maximum_scale_reduction':.048,'changed_vertices':len(rows),'maximum_absolute_x_displacement':max(abs(x-newx) for _,x,_,_,newx in rows),'hem_below_z':4.43,'no_y_or_z_change':True},indent=2)+'\n')
