"""Generate a softer face for varsity-06, preserving the established character."""
import bpy,sys,hashlib,math,json
from pathlib import Path
from mathutils import Vector
from mathutils.bvhtree import BVHTree
argv=sys.argv[sys.argv.index('--')+1:]
src,dst=map(Path,argv[:2]); style=argv[2] if len(argv)>2 else 'gentle'
assert style in ('gentle','smile')
assert hashlib.sha256(src.read_bytes()).hexdigest()=='b2801c79d3d0d7215764cdbb5f67040a38f7fb397d7b0b937b4c211f004bf1e9'
bpy.ops.wm.open_mainfile(filepath=str(src.resolve()))
s=bpy.context.scene;s.frame_set(1)
r=next(o for o in s.objects if o.type=='ARMATURE')
face=bpy.data.collections['Face and features']
def g(z,m,w):return math.exp(-((z-m)/w)**2)
for n in ('Sculpted cheeks, jaw and cranium','Low nose bridge and tapered tip'):
 o=bpy.data.objects[n];mat=o.matrix_world;inv=mat.inverted()
 for v in o.data.vertices:
  x,y,z=mat@v.co
  if n.startswith('Sculpted'):
   # Round the low-cheek to chin transition, not the skull or hair envelope.
   x*=1+.112*g(z,4.405,.135)
   z+=.018*g(z,4.295,.125)*g(x,0,.22)
   y-=.018*g(z,4.49,.17)*g(abs(x),.26,.18)*max(0.,min(1.,(-.07-y)/.21))
  else:
   x=.85*(x-.008)+.008
   y+=.014*g(z,4.55,.072)
  v.co=inv@Vector((x,y,z))
mesh=bpy.data.objects['Sculpted cheeks, jaw and cranium']
tree=BVHTree.FromPolygons([mesh.matrix_world@v.co for v in mesh.data.vertices],[tuple(f.vertices) for f in mesh.data.polygons])
def p(x,z,bias):
 hit,*_=tree.ray_cast(Vector((x,-2,z)),Vector((0,1,0)))
 assert hit is not None,(x,z)
 return (x,hit.y-bias,z)
def color(name,c,r=.56):
 m=bpy.data.materials.new(name);m.use_nodes=True
 lin=lambda v:v/12.92 if v<.04045 else ((v+.055)/1.055)**2.4
 bc=tuple(lin(x/255) for x in c)+(1.,)
 m.diffuse_color=bc
 node=m.node_tree.nodes.get('Principled BSDF')
 node.inputs['Base Color'].default_value=bc;node.inputs['Roughness'].default_value=r;node.inputs['Specular IOR Level'].default_value=.24
 return m
cream=color('Warm off-white eye surface',(237,222,196))
rim=color('Thin warm espresso upper lid',(58,34,25))
rim2=color('Warm amber iris rim',(93,48,24))
iris=color('Honey-brown iris',(186,111,42),.62)
dark=color('Soft deep brown pupil',(29,17,12),.68)
spark=color('Warm light eye glint',(253,245,220),.42)
brow=color('Soft chestnut eyebrow',(94,51,35))
mouth=color('Muted rose smile line',(132,66,52))
lip=color('Muted warm bottom lip',(217,140,114))
remove=('Upper charcoal eye shape','Ivory sclera','Dark amber iris rim','Amber iris','Dark oval pupil','Large eye glint','Arched expressive eyebrow','Small asymmetric warm smile')
for o in list(face.objects):
 if o.name.startswith(remove):bpy.data.objects.remove(o,do_unlink=True)
def make(name,coords,fs,m):
 me=bpy.data.meshes.new(name);me.from_pydata(coords,[],fs);me.update()
 ob=bpy.data.objects.new(name,me);face.objects.link(ob);me.materials.append(m)
 for f in me.polygons:f.use_smooth=True
 g=ob.vertex_groups.new(name='head');g.add(list(range(len(me.vertices))),1.,'REPLACE')
 d=ob.modifiers.new('Provisional joint continuity','ARMATURE');d.object=r;d.use_deform_preserve_volume=True
def patch(name,cx,cz,outline,m,depth,curvature=.006,num=48):
 # Intermediate ring follows the skin curvature instead of flying linearly from center.
 vs=[p(cx,cz,depth+curvature)]
 for factor in (.50,1.):
  for i in range(num):
   x,z=outline(i*2*math.pi/num)
   vs.append(p(cx+factor*(x-cx),cz+factor*(z-cz),depth+curvature*(1-factor*factor)))
 fs=[(0,i+1,(i+1)%num+1) for i in range(num)]
 fs.extend((i+1,i+num+1,(i+1)%num+num+1,(i+1)%num+1) for i in range(num))
 make(name,vs,fs,m)
def ribbon(name,func,m,thick,depth,n):
 vs=[]
 for i in range(n+1):
  t=i/n;x,z=func(t)
  taper=.11+.89*math.sin(math.pi*t)**.75
  wh=thick*taper
  vs.extend([p(x,z-wh*.5,depth),p(x,z+wh*.5,depth)])
 fs=[(2*i,2*i+2,2*i+3,2*i+1) for i in range(n)]
 make(name,vs,fs,m)
for sign,tag in [(-1,'R'),(1,'L')]:
 cx=sign*.212;cz=4.697
 w=.126
 up=.084 if style=='gentle' else .079
 down=.059 if style=='gentle' else .055
 def outline(t):
  f=math.cos(t);k=math.sin(t)
  return cx+w*f,cz+(.017*sign*f)+(up if k>0 else down)*k*(.78+.22*abs(k))
 patch('Soft sculpted sclera.'+tag,cx,cz,outline,cream,.021,.007)
 def upper(t):
  f=-1+2*t
  return cx+sign*(w+.005)*f,cz+.017*f+up*math.sqrt(max(0,1-f*f))*(.78+.22*math.sqrt(max(0,1-f*f)))+.006
 ribbon('Tapered upper eyelid.'+tag,upper,rim,.026 if style=='gentle' else .031,.038,36)
 ix=cx+.005;iz=4.696
 for name,rx,rz,m,d in [('Amber border',.076,.061,rim2,.040),('Honey iris',.068,.055,iris,.042),('Pupil',.043,.045,dark,.048)]:
  patch(name+'.'+tag,ix,iz,lambda a:(ix+rx*math.cos(a),iz+rz*math.sin(a)),m,d,.007,num=40)
 xx=ix-.020;zz=iz+.023
 patch('Clear round catchlight.'+tag,xx,zz,lambda a:(xx+.012*math.cos(a),zz+.011*math.sin(a)),spark,.064,.004,num=20)
 def brow_curve(t):
  arch=math.sin(math.pi*(.10+.87*t))
  return sign*(.108+.208*t),4.835+.035*arch-.016*t
 ribbon('Soft raised eyebrow.'+tag,brow_curve,brow,.032,.021,24)
# Restrained, slightly asymmetrical smile and short warm lip plane.
def smile(t):
 return -.114+.225*t,4.429+.025*(2*t-1)**2+.004*t if style=='gentle' else 4.424+.033*(2*t-1)**2+.006*t
ribbon('Friendly closed smile',smile,mouth,.019,.030,32)
ribbon('Short lower lip plane',lambda t:(-.057+.129*t,4.417+.005*(2*t-1)**2),lip,.019,.018,16)
s['face_revision']='Softer face for varsity-06; hair, wardrobe, rig and authored actions unchanged.'
dst=dst.resolve();dst.parent.mkdir(parents=True,exist_ok=True)
bpy.ops.wm.save_as_mainfile(filepath=str(dst),compress=True)
