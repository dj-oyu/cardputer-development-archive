"""Core shadow experiment on fixed v12 hair volumes. Usage: BASE OUT core|control."""
import bpy,sys,math,hashlib
from pathlib import Path
from array import array
src,dst=map(lambda x:Path(x).resolve(),sys.argv[-3:-1]); mode=sys.argv[-1]
assert mode in ('core','control')
assert hashlib.sha256(src.read_bytes()).hexdigest()=='3020e94f0be88833992d5a245e884f2992bd0a14138131c9a195d2c9bce498a1'
bpy.ops.wm.open_mainfile(filepath=str(src),use_scripts=False)
names=('Bob back mass','Large right side-sweep','Left wide brushed fringe')
def smooth(a,b,x):
 t=max(0,min(1,(x-a)/(b-a)));return t*t*(3-2*t)
def mix(a,b,k):
 return tuple(x*(1-k)+y*k for x,y in zip(a,b))
def phase(x):return (x+.5)%1-.5
texdir=dst.parent/('core_textures' if mode=='core' else 'control_textures');texdir.mkdir(parents=True,exist_ok=True)
for idx,name in enumerate(names):
 o=bpy.data.objects[name];cap=idx==0
 if not cap:
    k=10;n=len(o.data.vertices)//k
    ring=list(o.data.vertices[k*(n//2):k*(n//2+1)])
    f=min(range(k),key=lambda j:ring[j].co.y)/k
 b,t,h=((45,25,19),(72,44,32),(101,60,42)) if cap else ((49,27,20),(77,43,31),(112,66,46))
 reflected=(66,45,46) if cap else (73,48,46)
 core=(39,21,22) if cap else (46,25,24)
 n=256
 im=bpy.data.images.new(('Core shadow · ' if mode=='core' else 'Reflected shadow control · ')+name,n,n,alpha=False,float_buffer=False)
 px=array('f')
 for y in range(n):
   v=(y+.5)/n
   if cap:
      hc=.340-.142*v+.026*math.sin(2*v*math.pi)
      dc=.034+.096*v+.020*math.sin(2*v*math.pi)
      width=.032+.029*math.sin(v*math.pi)
      vfade=smooth(.075,.22,v)*(1-smooth(.82,.98,v))
      run=smooth(.11,.24,v)*(1-smooth(.70,.87,v))
      edge_sign=1
      band=.016+.011*math.sin(v*math.pi)**2
   else:
      side=-1 if idx==2 else 1
      hc=f+side*(.125-.145*v*v)
      dc=f+.42-.12*v
      width=.076+.057*math.sin(v*math.pi)
      vfade=smooth(.018,.19,v)*(1-smooth(.79,.98,v))
      run=smooth(.13,.25,v)*(1-smooth(.66,.88,v))
      edge_sign=-side
      band=.021+.012*math.sin(v*math.pi)**2
   for x in range(n):
      u=(x+.5)/n
      da=phase(u-hc)
      a=(1-smooth(width-.012,width+.006,abs(da)))*vfade
      d=(1-smooth(.158,.192,abs(phase(u-dc))))*(.78+.20*(1-v))
      val=mix(mix(t,b,d),h,a)
      # q>0 is the selected shadow side only. The trough is narrow, but the
      # higher-value cool reflection remains broad. Fade out away from this turn.
      q=edge_sign*da-(width-.001)
      glow=smooth(-.001,.012,q)*(1-smooth(.120,.185,q))*run
      val=mix(val,reflected,glow*.89)
      trough=smooth(.002,.009,q)*(1-smooth(band-.011,band,q))*run
      if mode=='core':val=mix(val,core,trough*.94)
      px.extend([v/255 for v in val]+[1.])
 im.pixels.foreach_set(px);im.update();im.file_format='PNG'
 fname=f'hair-core-{idx:02d}.png';im.filepath_raw=str(texdir/fname);im.save();im.pack();im.filepath=f'//{texdir.name}/{fname}'
 node=next(n for n in o.data.materials[0].node_tree.nodes if n.type=='TEX_IMAGE')
 old=node.image;node.image=im;node.label='Core shadow ramp on selected turn only'
 if not old.users: bpy.data.images.remove(old)
bpy.ops.wm.save_as_mainfile(filepath=str(dst),compress=True)
