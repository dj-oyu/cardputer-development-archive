"""Add independent cloud eyes, brows and mouth controls. Blender 4.3."""
import bpy, math, os, sys, json, hashlib
from mathutils import Vector
from math import sin,cos,pi
base=os.path.dirname(os.path.realpath(__file__))
argv=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
fallback=[os.path.join(base,'..',d,'cloud-idle-wind-7s.blend') for d in ('idle-wind-7s','cloud-character-idle-wind-7s')]
a=[x for x in argv if x!='--no-preview']
src=os.path.abspath(a[0]) if a else next(x for x in fallback if os.path.isfile(x))
out=os.path.abspath(a[1]) if len(a)>1 else os.path.join(base,'cloud-expressions-v1.blend')
assert os.path.realpath(src)!=os.path.realpath(out)
output=os.path.dirname(out)
digest=lambda f:hashlib.sha256(open(f,'rb').read()).hexdigest()
oldsha=digest(src)
bpy.ops.wm.open_mainfile(filepath=src)
s=bpy.context.scene; rig=bpy.data.objects['Cloud_Rig']; body=bpy.data.objects['Cloud body']
s.frame_set(1)
old_curve=bpy.data.objects['Open smile contour']
props=['cloud_face_preset','cloud_face_eyes','cloud_face_brows','cloud_face_mouth']
ctl=bpy.data.objects.new('Cloud face controls',None);s.collection.objects.link(ctl)
for i,name in enumerate(props):
 if name in ctl:raise RuntimeError('Face controls already exist')
 ctl[name]=0. if i==0 else -1.
 ctl.id_properties_ui(name).update(min=0 if not i else -1,max=4,description='0 neutral, 1 happy, 2 concerned, 3 surprised, 4 sleepy.'+(' -1 follows preset.' if i else ''))
K=bpy.data.materials
ink=K['Ink • dark mulberry']
blush=K.get('Tongue • warm coral') or K.new('Tongue • warm coral')
blush.use_nodes=True;blush.diffuse_color=(.97,.23,.22,1)
bl=blush.node_tree.nodes.get('Principled BSDF');bl.inputs['Base Color'].default_value=blush.diffuse_color;bl.inputs['Roughness'].default_value=.54
mouthmat=ink.copy();mouthmat.name='Expression mouth • plum'
m=mouthmat.node_tree.nodes.get('Principled BSDF');m.inputs['Base Color'].default_value=(.108,.027,.054,1);m.inputs['Roughness'].default_value=.61
mouthmat.diffuse_color=(.108,.027,.054,1)
collection=bpy.data.collections.new('Cloud face variants • controlled by Cloud_Rig');s.collection.children.link(collection)
oldobjs=[o for o in s.objects if o.parent==rig]
def visible_if(o,layer,allowed):
 for i,scale in enumerate(o.scale):
  d=o.driver_add('scale',i).driver;d.type='SCRIPTED'
  for name,prop in [('p',props[0]),('v',props[layer])]:
   var=d.variables.new();var.name=name;var.type='SINGLE_PROP';var.targets[0].id=ctl;var.targets[0].data_path='["'+prop+'"]'
  cond=' or '.join(f'(v == {k} or (v < 0 and p == {k}))' for k in allowed)
  d.expression=f'{scale:.17g} if ({cond}) else 0'
def place(o):
 collection.objects.link(o)
 o.parent=rig;o.parent_type='BONE';o.parent_bone='Body';o.matrix_parent_inverse=old_curve.matrix_parent_inverse.copy()
 return o
def front(x,z,off=0):
 v=Vector((x,-4,z-1.86));r,h,n,i=body.ray_cast(v,(0,1,0))
 return (x,(h.y if r else -.82)-off,z)
added=[]
def curve(name,l,st,pts,r=.027,off=.052,material=ink):
 cu=bpy.data.curves.new(name,'CURVE');cu.dimensions='3D';cu.resolution_u=12;cu.bevel_depth=r;cu.bevel_resolution=3
 sp=cu.splines.new('POLY');sp.points.add(len(pts)-1)
 for p,(x,z) in zip(sp.points,pts):p.co=(*front(x,z,off),1)
 cu.materials.append(material);o=place(bpy.data.objects.new(name,cu));visible_if(o,l,(st,));added.append((o,l,st));return o
def patch(name,l,st,bound,off,m):
 me=bpy.data.meshes.new(name)
 cx=sum(x for x,z in bound)/len(bound);cz=sum(z for x,z in bound)/len(bound)
 vs=[front(cx,cz,off),*[front(x,z,off) for x,z in bound]]
 faces=[(0,1+i,1+(i+1)%len(bound)) for i in range(len(bound))]
 me.from_pydata(vs,[],faces);me.update();me.materials.append(m)
 o=place(bpy.data.objects.new(name,me));visible_if(o,l,(st,));added.append((o,l,st));return o
def line(n,fn):return [fn(i/n) for i in range(n+1)]
def oval(x,z,w,h,n=40):return [(x+w*cos(2*pi*i/n),z+h*sin(2*pi*i/n)) for i in range(n)]
def rectangle_oval(x,z,w,h):
 return oval(x,z,w,h)
for o in oldobjs:
 if o.name.startswith(('Eye rim','Eye white','Pupil','Catchlight')):visible_if(o,1,(0,2,3))
 if o.name.startswith('Brow'):visible_if(o,2,(0,))
visible_if(old_curve,3,(0,))
for k,q in [('L',1),('R',-1)]:
 x=q*.381
 happy=line(20,lambda t:(x+(t-.5)*.37,2.190+.134*sin(pi*t)))
 curve('Expression Happy closed eye '+k,1,1,happy,.038,.116)
 sleepy=line(18,lambda t:(x+(t-.5)*.37,2.236-.062*sin(pi*t)-.030*q*(t-.5)))
 # Eyelids are separate from independent brow and mouth controls.
 curve('Expression Sleepy lid '+k,1,4,sleepy,.035,.102)
 z=2.52
 curve('Expression Happy eyebrow '+k,2,1,line(16,lambda t:(q*(.247+.247*t),z+.05+.087*sin(pi*t)-.020*t)),.025,.051)
 curve('Expression Concerned eyebrow '+k,2,2,line(16,lambda t:(q*(.236+.256*t),z+.13-.131*t+.037*sin(pi*t))),.032,.052)
 curve('Expression Surprised eyebrow '+k,2,3,line(16,lambda t:(q*(.238+.263*t),z+.145+.056*sin(pi*t)-.027*t)),.033,.055)
 curve('Expression Sleepy eyebrow '+k,2,4,line(16,lambda t:(q*(.25+.26*t),z-.054+.028*sin(pi*t)-.015*t)),.024,.042)
# Happy, open smile; a bright lower accent reads reliably at 240×135.
up=line(20,lambda t:(-.219+.438*t,1.966-.056*sin(pi*t)))
down=line(24,lambda t:(.219-.438*t,1.966-.257*sin(pi*t)**.76))
outline=up+down[1:-1]
patch('Expression Happy mouth interior',3,1,outline,.075,mouthmat)
curve('Expression Happy mouth rim',3,1,outline+[outline[0]],.023,.081)
tongue=oval(-.015,1.773,.124,.049)
patch('Expression Happy tongue',3,1,tongue,.090,blush)
curve('Expression Concerned mouth',3,2,line(20,lambda t:(-.148+.296*t,1.858+.074*sin(pi*t))),.028,.064)
for st, label, coords in [(3,'Surprised',(0.,1.842,.102,.132)),(4,'Sleepy',(0.,1.874,.072,.045))]:
 poly=oval(*coords)
 patch(f'Expression {label} mouth interior',3,st,poly,.064,mouthmat)
 curve(f'Expression {label} mouth rim',3,st,poly+[poly[0]],.023,.072)
 if st==3:patch('Expression Surprised tongue',3,st,oval(0,1.771,.062,.025),.078,blush)
def setface(preset=0,eyes=-1,brows=-1,mouth=-1):
 for k,v in zip(props,(preset,eyes,brows,mouth)):ctl[k]=float(v)
 ctl.update_tag(); s.frame_set(s.frame_current);bpy.context.view_layer.update()
s.render.resolution_x=240;s.render.resolution_y=135;s.cycles.samples=96
def render(name):
 s.render.filepath=os.path.join(output,'expression-'+name+'.png');bpy.ops.render.render(write_still=True)
setface()
if '--no-preview' not in argv:render('neutral-before-brow')
from bpy_extras.object_utils import world_to_camera_view
brow_sizes={}
def thicken_brow(o):
 # Mesh conversion leaves the original source curve in the file as editable
 # fake-user data. Preserve world X/Y and local centreline; only widen Z.
 d=o.data; d.use_fake_user=True
 points=sorted((q.co.x,q.co.z) for q in d.splines[0].points)
 for z in range(3):o.driver_remove('scale',z)
 o.scale=(1.,1.,1.)
 o.hide_set(False);bpy.context.view_layer.update()
 def cz(x):
  if x<=points[0][0]:return points[0][1]
  if x>=points[-1][0]:return points[-1][1]
  for (xa,z),(xb,w) in zip(points,points[1:]):
   if xa<=x<=xb:return z+(w-z)*(x-xa)/(xb-xa)
 deps=bpy.context.evaluated_depsgraph_get();ob=o.evaluated_get(deps)
 # Visible solely for evaluating the original 3D curve; use normal drivers again after replacing data.
 m=bpy.data.meshes.new_from_object(ob,depsgraph=deps,preserve_all_data_layers=True)
 # Curve objects cannot accept Mesh data, so replace object while restoring binding.
 old_name=o.name;o.name=old_name+' • source';new=bpy.data.objects.new(old_name,m)
 for c in list(o.users_collection):c.objects.link(new)
 new.parent=o.parent;new.parent_type=o.parent_type;new.parent_bone=o.parent_bone;new.matrix_parent_inverse=o.matrix_parent_inverse.copy();new.matrix_basis=o.matrix_basis.copy()
 bpy.context.view_layer.update()
 def screen():
  xz=[world_to_camera_view(s,s.camera,new.matrix_world@v.co) for v in m.vertices]
  return [240*(max(k.x for k in xz)-min(k.x for k in xz)),135*(max(k.y for k in xz)-min(k.y for k in xz))]
 pre=screen()
 for v in m.vertices:
  z=cz(v.co.x);v.co.z=z+1.31*(v.co.z-z)
 m.update();post=screen()
 assert abs(post[0]-pre[0])<1e-4,(old_name,pre,post)
 assert post[1]>pre[1],(old_name,pre,post)
 brow_sizes[old_name]=[pre,post]
 bpy.data.objects.remove(o,do_unlink=True)
 return new
for o in list(oldobjs):
 if o.name.startswith('Brow') and o.type=='CURVE':
  new=thicken_brow(o);visible_if(new,2,(0,));oldobjs.remove(o);oldobjs.append(new)
for idx,(o,l,st) in enumerate(list(added)):
 if l==2:
  setface(st);new=thicken_brow(o);visible_if(new,l,(st,));added[idx]=(new,l,st)
setface()
def checked(preset,eyes=-1,brows=-1,mouth=-1):
 setface(preset,eyes,brows,mouth);states=[preset if k<0 else k for k in (eyes,brows,mouth)]
 states=[-100,*states]
 deps=bpy.context.evaluated_depsgraph_get()
 for o,l,st in added:assert (o.evaluated_get(deps).scale.length>.001)==(states[l]==st),(o.name,states,l,st,list(o.evaluated_get(deps).scale))
 return [o.name for o,l,st in added if o.evaluated_get(deps).scale.length>.001]
samples={}
for i,name in enumerate(('neutral','happy','concerned','surprised','sleepy')):samples[name]=checked(i)
mixed=checked(0,1,2,3);assert len(mixed)==7
setface()
assert all(not ob.hide_render for ob in oldobjs)
assert (s.frame_start,s.frame_end,s.render.fps)==(1,169,24)
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=out,compress=True)
assert digest(src)==oldsha
print('Cloud face controls verified',samples,mixed,flush=True)
with open(os.path.join(output,'expression-validation.json'),'w') as fil:
 json.dump({'source_sha256':oldsha,'variant_sha256':digest(out),'controls':props,'preset_active_objects':samples,'mixed_happy_eyes_concerned_brows_surprised_mouth':mixed,'new_objects':len(added),'preserved_idle_seconds':7,'neutral_additions_visible':len(samples['neutral']),'brows_width_height_before_after_px':brow_sizes},fil,indent=1)
if '--no-preview' not in argv:
 s.render.resolution_x=240;s.render.resolution_y=135;s.cycles.samples=96
 for i, nm in enumerate(samples):
  setface(i)
  s.render.filepath=os.path.join(output,'expression-'+nm+'.png');bpy.ops.render.render(write_still=True)
 # Deformed idle pose, not only the neutral raster.
 s.frame_set(74);setface(1);s.render.filepath=os.path.join(output,'expression-happy-during-idle.png');bpy.ops.render.render(write_still=True)
