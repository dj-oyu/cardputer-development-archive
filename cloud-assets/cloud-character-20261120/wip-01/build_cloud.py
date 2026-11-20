"""Generate an editable original Blender Cloud character; Blender 4.3.2."""
import bpy, math, os, sys
from mathutils import Vector
from math import sin,cos,pi,sqrt,exp
root=os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
args=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
stage='wip' if '--wip' in args else 'delivery'
out=os.path.join(root,stage);os.makedirs(out,exist_ok=True)
bpy.ops.wm.read_factory_settings(use_empty=True)
s=bpy.context.scene
def mat(n,col,rough=.60,sss=0,metal=0):
 m=bpy.data.materials.new(n);m.diffuse_color=(*col,1);m.use_nodes=True
 v=m.node_tree.nodes.get('Principled BSDF');v.inputs['Base Color'].default_value=(*col,1);v.inputs['Roughness'].default_value=rough
 v.inputs['Subsurface Weight'].default_value=sss;v.inputs['Subsurface Radius'].default_value=(.55,.78,1);v.inputs['Subsurface Scale'].default_value=.30
 v.inputs['Metallic'].default_value=metal
 return m
def gradient(n):
 m=mat(n,(.75,.86,1),.61,.21)
 nodes=m.node_tree.nodes; links=m.node_tree.links
 c=nodes.new('ShaderNodeVertexColor');c.layer_name='CloudTint'
 links.new(c.outputs['Color'],nodes.get('Principled BSDF').inputs['Base Color'])
 return m
bodymat=gradient('Vapor • pale body, cool thickness, soft scatter')
def pm(n,co,rough=.5):return mat(n,co,rough)
ink=pm('Ink • dark mulberry',(.034,.017,.059),.43)
iris=pm('Iris • slate-plum',(.056,.029,.095),.34)
white=pm('Eye whites • pearl',(.99,.97,1),.4)
gleam=pm('Eye catchlight',(1,1,1),.26)
cheek=pm('Cheek • sky blue',(.52,.69,1),.68)
tongue=pm('Tongue • warm coral',(.97,.26,.25),.52)
halomat=mat('Iridescent cloud • pastel ribbons',(.86,.75,1),.34,.16)
c=halomat.node_tree.nodes.new('ShaderNodeVertexColor');c.layer_name='CloudTint'
p=halomat.node_tree.nodes.get('Principled BSDF')
halomat.node_tree.links.new(c.outputs['Color'],p.inputs['Base Color'])
halomat.node_tree.links.new(c.outputs['Color'],p.inputs['Emission Color'])
p.inputs['Emission Strength'].default_value=.12
def mesh(name,vs,fs,m,colors=None):
 me=bpy.data.meshes.new(name);me.from_pydata(vs,[],fs);me.update();o=bpy.data.objects.new(name,me);s.collection.objects.link(o);o.data.materials.append(m)
 for p in me.polygons:p.use_smooth=True
 if colors:
  a=me.color_attributes.new(name='CloudTint',type='FLOAT_COLOR',domain='POINT')
  for j,k in enumerate(colors):a.data[j].color=(*k,1)
 return o
def unit(v):return Vector(v).normalized()
bumps=[((-.68,-.10,.57),.18,.13),((.62,.14,.72),.17,.12),((-.28,.12,.94),.13,.15),((-.62,-.38,-.62),.13,.12),((.41,-.52,-.74),.14,.11),((-.06,-.85,-.68),.09,.115),((.83,-.06,-.36),.15,.13),((-.87,.03,-.38),.14,.14),((-.52,.7,-.61),.13,.15),((.28,.81,-.52),.14,.16),((.18,.75,.57),.13,.13),((-.35,.80,.38),.13,.12),((.57,.70,.22),.10,.12),((-.20,-.43,.89),.09,.09)]
def create_puff(name,scale,m,kind='body'):
 nlat,nlong=((16,26) if stage=='wip' else (31,48)) if kind=='body' else ((10,16) if stage=='wip' else (14,22))
 rng=bumps if kind=='body' else [((-.78,-.5,.56),.17,.18),((.7,-.23,.25),.15,.19),((-.2,-.13,-.95),.1,.16)]
 rng=[(unit(a),b,c) for a,b,c in rng];vs=[];cs=[];fs=[]
 def calc(t,ph):
  u=Vector((sin(t)*cos(ph),sin(t)*sin(ph),cos(t)))
  z=u.z;h=1 if kind!='body' else (.960-.245*z-.065*z*z)
  amplitude=1+sum(v*exp((u.dot(a)-1)/sig**2) for a,v,sig in rng)
  if kind=='body' and stage!='wip':
   face=max(0,min(1,(-u.y-.48)/.42))*max(0,1-abs(z-.26)/.92)
   amplitude+=.016*(1-face)*(sin(17*u.x+12*u.z)*sin(16*u.y-12*u.z))
  x,y,z=u.x*scale[0]*h*amplitude,u.y*scale[1]*h*amplitude,z*scale[2]*amplitude
  b=max(0,min(1,.48-.38*u.z+.14*u.y))
  lo=(.39,.60,1);hi=(.995,.985,1)
  return (x,y,z),tuple((1-b)*a+b*k for a,k in zip(hi,lo))
 def add(t,p):
  v,c=calc(t,p);vs.append(v);cs.append(c)
 add(0,0)
 for i in range(1,nlat):
  for j in range(nlong):add(pi*i/nlat,2*pi*j/nlong)
 add(pi,0)
 for j in range(nlong):fs.append((0,1+j,1+(j+1)%nlong))
 for i in range(nlat-2):
  for j in range(nlong):
   a=1+i*nlong+j;b=1+i*nlong+(j+1)%nlong;fs.append((a,a+nlong,b+nlong,b))
 for j in range(nlong):
  idx=1+(nlat-2)*nlong;fs.append((idx+(j+1)%nlong,idx+j,len(vs)-1))
 return mesh(name,vs,fs,m,cs)
bpy.ops.object.armature_add();rig=bpy.context.object;rig.name='Cloud_Rig';rig.show_in_front=True
bpy.ops.object.mode_set(mode='EDIT')
bones=rig.data.edit_bones; bones.remove(bones[0])
def bone(n,xy,tail=.30,par=None):
 b=bones.new(n);b.head=xy;b.tail=(xy[0],xy[1],xy[2]+tail)
 if par:b.parent=bones[par]
bone('Root',(0,0,1.86),.34)
bone('Body',(0,0,1.86),.62,'Root')
bone('Hand.L',(1.64,-.04,1.40),.38,'Root')
bone('Hand.R',(-1.64,-.04,1.40),.38,'Root')
bone('Halo',(0,.02,3.78),.38,'Root')
bone('Halo.Tip',(.81,.02,3.78),.38,'Halo')
bpy.ops.object.mode_set(mode='OBJECT')
def bind(o,n,xyz=(0,0,0)):
 mat=bpy.data.objects['Cloud_Rig'].matrix_world.copy()
 # Coordinates assigned at bind time; rigid bone parent follows pose and preserves rest-space.
 bpy.context.view_layer.update()
 inv=(mat @ rig.pose.bones[n].matrix).inverted()
 # Blender bone-parent local space is at the bone tail.
 from mathutils import Matrix
 itm=mat @ rig.pose.bones[n].matrix @ Matrix.Translation((0,rig.data.bones[n].length,0))
 o.parent=rig;o.parent_type='BONE';o.parent_bone=n;o.matrix_parent_inverse=itm.inverted();o.location=xyz
 return o
body=bind(create_puff('Cloud body', (1.34,.94,1.41),bodymat),'Body',(0,0,1.86))
for k,x in [('L',1.64),('R',-1.64)]:
 bind(create_puff('Floating hand '+k,(.276,.235,.298),bodymat,'hand'),'Hand.'+k,(x,-.04,1.40))
def ell(n,loc,sc,m,b='Body',tilt=0):
 bpy.ops.mesh.primitive_uv_sphere_add(segments=20 if stage=='wip' else 32,ring_count=12 if stage=='wip' else 16)
 o=bpy.context.object;o.name=n;o.scale=sc;o.rotation_euler[1]=tilt;o.data.materials.append(m)
 for p in o.data.polygons:p.use_smooth=True
 return bind(o,b,loc)
def front(x,z,off=0):
 pos=Vector((x,-4,z));hit,p,n,idx=body.ray_cast(pos-Vector((0,0,1.86)),(0,1,0))
 return (x,(p.y if hit else -.82)-off,z)
def curve(n,points,r,m):
 cu=bpy.data.curves.new(n,'CURVE');cu.dimensions='3D';cu.resolution_u=12;cu.bevel_depth=r;cu.bevel_resolution=3
 sp=cu.splines.new('POLY');sp.points.add(len(points)-1)
 for a,b in zip(sp.points,points):a.co=(*b,1)
 ob=bpy.data.objects.new(n,cu);s.collection.objects.link(ob);cu.materials.append(m)
 return bind(ob,'Body')
for k,q in [('L',1),('R',-1)]:
 x=.355*q; z=2.23
 ell('Eye rim '+k,front(x,z,.020),(.161,.065,.232),ink,tilt=q*.09)
 ell('Eye white '+k,front(x,z,.054),(.145,.049,.214),white,tilt=q*.09)
 p=front(x-q*.020,z-.013,.109)
 ell('Pupil '+k,p,(.119,.035,.178),iris,tilt=q*.09)
 ell('Catchlight '+k,(p[0]-.036,p[1]-.027,p[2]+.080),(.037,.014,.054),gleam)
 ell('Catchlight small '+k,(p[0]+.032,p[1]-.033,p[2]-.055),(.015,.009,.021),gleam)
 ell('Cheek '+k,front(q*.565,1.976,.016),(.134,.027,.070),cheek,tilt=-q*.17)
 curve('Brow '+k,[front(q*(.242+.23*t/14),2.531+.058*sin(pi*t/14)-.040*t/14,.041) for t in range(15)],.030,ink)
curve('Open smile contour',[front(-.150+.300*t/22,1.968-.098*sin(pi*t/22),.049) for t in range(23)],.025,ink)
# Separate tapered pastel cloud strips. Irregular waves and pale sheen rather than a ring.
rainbow=[(.82,.66,.98),(.65,.81,.99),(.61,.91,.96),(.98,.79,.87),(.99,.87,.73)]
for j in range(5):
 nn=48 if stage!='wip' else 26;sec=10;vs=[];fs=[];cols=[]
 for i in range(nn+1):
  t=i/nn; x=-1.27+2.54*t+(.045*(j-2));fade=.015+.985*sin(pi*t)**(.78+.055*j)
  y0=((j-2)*.089)*fade+.062*sin(2*pi*t+j*.48)
  z0=.060*sin(2*pi*(t-.1))+.040*cos(5*pi*t)+.014*(j-2)
  for k in range(sec):
   a=2*pi*k/sec;vs.append((x,y0+(.082+.008*j)*fade*cos(a),z0+.035*fade*sin(a)))
   f=.18+.32*abs(2*t-1)+.15*max(0,sin(a))
   cols.append(tuple(v+(1-v)*f for v in rainbow[j]))
 for i in range(nn):
  for k in range(sec):a=i*sec+k;b=i*sec+(k+1)%sec;fs.append((a,b,b+sec,a+sec))
 fs.extend([tuple(reversed(range(sec))),tuple(range(nn*sec,(nn+1)*sec))])
 o=bind(mesh('Halo vapor ribbon %02d'%j,vs,fs,halomat,cols),'Halo',(0,.02,3.78))
 # Deform right edge independently using a pose-driven shape key; base ribbon shares the Halo bone.
 if stage!='wip':
  o.shape_key_add(name='Basis');key=o.shape_key_add(name='Right edge follow')
  for idx,p in enumerate(key.data):
   x=vs[idx][0]; p.co.z += .16*max(0,(x+.04)/1.34)**2
  d=key.driver_add('value').driver;d.type='SCRIPTED'
  va=d.variables.new();va.name='lag';va.type='SINGLE_PROP';va.targets[0].id=rig;va.targets[0].data_path='pose.bones["Halo.Tip"]["lag"]';d.expression='lag'
for pb in rig.pose.bones:pb.rotation_mode='XYZ'
def keys(b,name,seq,ri=1):
 p=rig.pose.bones[b]
 for frame,value in seq:
  setattr(p,name,value);p.keyframe_insert(name,frame=frame,group=b)
n=24
keys('Body','rotation_euler',[(1,(0,0,0)),(49,(0,0,0)),(71,(.12,0,.12)),(92,(-.15,0,-.12)),(121,(0,0,0)),(146,(0,0,0)),(191,(0,0,0)),(241,(0,0,0))])
keys('Body','scale',[(1,(1,1,1)),(121,(1,1,1)),(147,(1.13,.94,1.12)),(166,(1.13,.96,.85)),(190,(1,1,1)),(241,(1,1,1))])
keys('Body','location',[(1,(0,0,0)),(121,(0,0,0)),(147,(0,.13,0)),(166,(0,-.14,0)),(190,(0,0,0)),(241,(0,0,0))])
for idx,nm in enumerate(('Hand.L','Hand.R')):
 sign=1 if idx==0 else -1
 keys(nm,'location',[(1,(0,0,0)),(49,(0,0,0)),(80+4*idx,(.06*sign,.14,-.03)),(108+3*idx,(-.06*sign,-.11,.08)),(124,(0,0,0)),(153,(.13*sign,.23,-.11)),(175,(.07*sign,-.06,.07)),(192,(0,0,0)),(241,(0,0,0))])
keys('Halo','rotation_euler',[(1,(0,0,0)),(56,(0,0,0)),(79,(.040,0,.050)),(104,(-.045,0,-.065)),(131,(0,0,0)),(167,(-.02,0,.05)),(190,(0,0,0)),(241,(0,0,0))])
keys('Halo','location',[(1,(0,0,0)),(57,(0,0,0)),(79,(.105,.04,0)),(108,(-.12,-.045,0)),(132,(0,0,0)),(159,(0,.22,0)),(187,(0,0,0)),(241,(0,0,0))])
tip=rig.pose.bones['Halo.Tip'];tip['lag']=0.
for f,v in [(1,0),(49,0),(84,.70),(117,.13),(140,0),(162,.92),(187,.12),(193,0),(241,0)]:
 tip['lag']=v;tip.keyframe_insert(data_path='["lag"]',frame=f,group='Halo.Tip')
rig.animation_data.action.name='Cloud 10s • idle, lean, stretch, squash, settle'
for x,y in [(1,'Idle'),(49,'Lean + delayed felt response'),(121,'Stretch and squash'),(193,'Settled'),(241,'Loop')]:s.timeline_markers.new(y,frame=x)
s.frame_start=1;s.frame_end=241;s.render.fps=24
s.world=bpy.data.worlds.new('Blue studio');s.world.use_nodes=True;s.world.node_tree.nodes['Background'].inputs[0].default_value=(.46,.57,.73,1);s.world.node_tree.nodes['Background'].inputs[1].default_value=.42
def aim(o,p):o.rotation_euler=(Vector(p)-o.location).to_track_quat('-Z','Y').to_euler()
for n1,loc,energy,sz,color in [('Key • world fixed',(-3.2,-4.1,6.7),710,4.4,(1,.91,.83)),('Fill',(3.9,-2.2,4.2),360,4,(.65,.81,1)),('Rim',(1.0,3.8,5.8),560,3.5,(.76,.89,1))]:
 ld=bpy.data.lights.new(n1,'AREA');ld.energy=energy;ld.shape='DISK';ld.size=sz;ld.color=color
 ob=bpy.data.objects.new(n1,ld);s.collection.objects.link(ob);ob.location=loc;aim(ob,(0,0,2))
cd=bpy.data.cameras.new('Primary 15 degrees');cam=bpy.data.objects.new(cd.name,cd);s.collection.objects.link(cam)
cam.location=(2.18,-8.35,3.14);aim(cam,(0,0,2.11));s.camera=cam;cd.type='ORTHO';cd.ortho_scale=7.50
# Graphic backdrop and shadow are excluded from exports.
for nm,co in [('Stage',(.295,.36,.48))]:
 bpy.ops.mesh.primitive_plane_add(size=200,location=(0,0,0));o=bpy.context.object;o.name=nm;o.data.materials.append(pm(nm,co))
s.render.engine='CYCLES';s.cycles.samples=10 if stage=='wip' else 18;s.cycles.use_denoising=False
s.view_settings.view_transform='AgX'
s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
s.render.image_settings.file_format='PNG'
s.frame_set(1)
bpy.ops.object.select_all(action='DESELECT');rig.select_set(True);bpy.context.view_layer.objects.active=rig
for screen in bpy.data.screens:
 for a in screen.areas:
  if a.type=='VIEW_3D': a.spaces.active.region_3d.view_perspective='CAMERA'
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=os.path.join(out,'cloud-'+stage+'.blend'),compress=True)
frames=(1,84,166,241) if stage!='wip' else (1,166)
for f in frames:
 s.frame_set(f);s.render.filepath=os.path.join(out,'cloud-240-%03d.png'%f);bpy.ops.render.render(write_still=True)
if stage!='wip':
 s.frame_set(1);s.render.resolution_x=960;s.render.resolution_y=540;s.cycles.samples=32
 s.render.filepath=os.path.join(out,'cloud-main.png');bpy.ops.render.render(write_still=True)
