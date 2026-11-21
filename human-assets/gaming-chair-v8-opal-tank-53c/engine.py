"""Build a sculpted fictive opposed eight-cylinder cartridge in its own offline scene."""
import bpy,sys,os,math
from pathlib import Path
from mathutils import Vector
ROOT=Path(__file__).resolve().parent
if bpy.context.window.scene is None: raise RuntimeError()
bpy.ops.wm.read_factory_settings(use_empty=True)
s=bpy.context.scene;s.name='Virtual bay • four-lobe opposed banks and liquid cartridge'
engine=bpy.data.collections.new('04 • Opposed V8 concept (bake only)')
tank=bpy.data.collections.new('05 • Inspection reservoir (bake only)')
for c in (engine,tank):s.collection.children.link(c)
def arrange(o,c):
 for src in list(o.users_collection):src.objects.unlink(o)
 c.objects.link(o)
def mat(n,c,metal=0,rough=.4,emit=0,trans=0,coat=0):
 m=bpy.data.materials.new(n);m.use_nodes=True;p=m.node_tree.nodes.get('Principled BSDF')
 for k,v in [('Base Color',(*c,1)),('Metallic',metal),('Roughness',rough),('Emission Color',(*c,1)),('Emission Strength',emit),('Transmission Weight',trans),('Coat Weight',coat)]:
  p.inputs[k].default_value=v
 return m
steel=mat('Satin ceramic silver',(0.38,0.49,0.53),.65,.33)
bright=mat('Nickel edge',(0.62,0.72,0.74),.56,.25)
fin=mat('Cool gunmetal casting',(0.083,0.102,0.133),.64,.34)
case=mat('Smoky gunmetal crankcase',(.062,.092,.104),.67,.36)
copper=mat('Warm sliding rods',(.49,.21,.072),.70,.30)
gasket=mat('Dark slotted puck',(.020,.022,.027),.22,.59)
amber=mat('Ceramic gold service tags',(.53,.26,.066),.52,.40,emit=.07)
shell=mat('Inspection cell clear shell',(.46,.76,.79),.0,.12,trans=.96,coat=.23)
liquid=mat('Dense blue green unknown fluid',(.020,.52,.58),.0,.20,emit=.22,coat=.43)
fluidEdge=mat('Meniscus • interface',(.13,.81,.76),.12,.22,emit=.19,coat=.26)
def box(n,p,sc,m,c=engine,b=.02,twist=0):
 bpy.ops.mesh.primitive_cube_add(size=1,location=p);o=bpy.context.object;o.name=n;o.scale=sc
 bpy.ops.object.transform_apply(location=False,rotation=False,scale=True)
 o.rotation_euler.y=twist
 if b:
  mod=o.modifiers.new('Rounded machined edges','BEVEL');mod.width=b;mod.segments=3
  o.modifiers.new('Weighted edge normals','WEIGHTED_NORMAL')
 o.data.materials.append(m);arrange(o,c);return o
def cyl(n,p,m,r,d,axis=(0,0,1),c=engine,verts=24):
 bpy.ops.mesh.primitive_cylinder_add(vertices=verts,radius=r,depth=d,location=p)
 o=bpy.context.object;o.name=n;o.rotation_euler=Vector(axis).to_track_quat('Z','Y').to_euler()
 o.data.materials.append(m);arrange(o,c)
 md=o.modifiers.new('Shoulder bevel','BEVEL');md.width=min(.013,r*.18);md.segments=2;o.modifiers.new('Weighted normals','WEIGHTED_NORMAL')
 for f in o.data.polygons:f.use_smooth=len(f.vertices)==4
 return o
def rod(n,a,b,m,r,c=engine):
 a,b=Vector(a),Vector(b);return cyl(n,(a+b)*.5,m,r,(b-a).length,b-a,c)
# Broad left/right opposed banks. Each has four real volumes, at consistent gaps.
box('Central transmission casting',(-.05,.05,2.28),(.39,.31,.34),case,b=.065)
box('Lower cast bridge',(-.06,.057,2.19),(.72,.23,.085),fin,b=.025)
for j,sg in enumerate((-1,1)):
 for k in range(4):
  z=2.22+k*.115
  x=-.05+sg*(.292+.014*k)
  box(f'Bank {j+1} cylinder head {k+1}',(x,.071,z),(.278,.245,.091),fin,b=.024,twist=sg*-.16)
  box(f'Bank {j+1} nickel fin {k+1}',(x+sg*.014,.193,z+.008),(.252,.070,.052),steel,b=.013,twist=sg*-.16)
  box(f'Bank {j+1} cold rib {k+1}',(x+sg*.025,.219,z+.020),(.22,.026,.018),bright,b=.007,twist=sg*-.16)
 # Visible two pistons and rods, represented in stylized cutaway.
 z=2.315;outer=-.05+sg*.328;inner=-.05+sg*.056
 rod(f'Piston {j+1} connecting rod', (inner,.249,z-.035),(outer,.238,z+.026),copper,.027)
 cyl(f'Piston {j+1} bright head',(outer,.232,z+.026),bright,.068,.078,(sg,0,.20))
 cyl(f'Piston {j+1} graphite band',(outer+sg*.029,.232,z+.033),gasket,.071,.018,(sg,0,.2))
 cyl(f'Piston {j+1} back pin',(inner,.269,z-.035),steel,.035,.038,(0,1,0),verts=16)
cyl('Cutaway center crank disc',(-.05,.254,2.275),gasket,.090,.042,(0,1,0))
cyl('Crank disc inner fixture',(-.05,.277,2.275),amber,.046,.025,(0,1,0),verts=16)
# The original intake crosses the old valve cover; mount the repeated head fins high
# rather than letting the original tube bury all eight visual strokes.
rig=bpy.data.objects.new('Engine placement • upper rack',None);engine.objects.link(rig)
for o in tuple(engine.objects):
 if o!=rig:o.parent=rig
rig.location=(-.025,.16,1.073);rig.scale=(.94,1,.681)
# Retain an unbroken load-bearing silhouette in the open rack down below the intake.
box('Lower crankcase drop • same upper casting',(-.07,.195,2.407),(.301,.204,.402),case,b=.048,twist=-.03)
box('Lower cast bead',(-.065,.273,2.275),(.375,.099,.095),fin,b=.024)
for sign in (-1,1):
 rod('Lower bronze connected actuator',(-.069+sign*.016,.314,2.329),(-.073+sign*.241,.308,2.355),copper,.035)
 cyl('Lower exposed actuator head',(-.073+sign*.241,.309,2.355),bright,.056,.071,(sign,0,.08),verts=18)
cyl('Lower silver main bearing',(-.071,.319,2.323),steel,.072,.034,(0,1,0),verts=20)
cyl('Lower dark bearing center',(-.071,.337,2.323),gasket,.039,.018,(0,1,0),verts=14)
def light(n,p,u,w,h,col):
 d=bpy.data.lights.new(n,'AREA');d.energy=u;d.shape='RECTANGLE';d.size=w;d.size_y=h;d.color=col
 o=bpy.data.objects.new(n,d);s.collection.objects.link(o);o.location=p
 o.rotation_euler=(Vector((0,.12,2.30))-o.location).to_track_quat('-Z','Y').to_euler()
light('Warm bounce / fore',(-.75,1.44,3.09),73,1.2,.7,(1,.89,.78))
light('Blue soft key / thin edge',(1.29,1.08,2.92),42,1.12,.36,(.76,.89,1))
light('Low silver reflection',(.11,1.72,1.32),20,.79,.37,(.75,.86,1))
w=bpy.data.worlds.new('Dim cavity');w.use_nodes=True;s.world=w;w.node_tree.nodes.get('Background').inputs[0].default_value=(.22,.23,.25,1);w.node_tree.nodes.get('Background').inputs[1].default_value=.18
bpy.ops.object.camera_add();s.camera=bpy.context.object;s.camera.data.type='PERSP';s.camera.data.lens=50
s.render.engine='CYCLES';s.cycles.samples=48;s.cycles.use_denoising=False;s.cycles.max_bounces=8;s.cycles.transparent_max_bounces=8
s.render.film_transparent=True;s.render.image_settings.file_format='PNG';s.render.image_settings.color_mode='RGBA';s.render.image_settings.color_depth='8'
s['scope']='Fictional cartridge artwork. The bake-only geometry does not join the physical chair or device mesh.'
bpy.context.preferences.filepaths.save_version=0;bpy.ops.wm.save_as_mainfile(filepath=str(ROOT/'virtual-engine-v8-53c.blend'),compress=True)
