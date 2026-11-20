"""Generate two editable Cycles backgrounds. blender -b --python build.py -- room|beach."""
import bpy, math, random, sys, os
from mathutils import Vector
from math import sin, cos, pi, exp
from pathlib import Path
out=Path(__file__).resolve().parent
mode=sys.argv[sys.argv.index('--')+1]
bpy.ops.wm.read_factory_settings(use_empty=True); s=bpy.context.scene
def material(n,c,r=.7,metal=0):
 m=bpy.data.materials.new(n);m.diffuse_color=(*c,1);m.use_nodes=True
 p=m.node_tree.nodes.get('Principled BSDF');p.inputs['Base Color'].default_value=(*c,1);p.inputs['Roughness'].default_value=r;p.inputs['Metallic'].default_value=metal
 return m,p
def m(n,c,r=.7):return material(n,c,r)[0]
def bind(o,n,mat):
 o.name=n;o.data.materials.append(mat);return o
def box(n,p,d,mat,b=.03):
 bpy.ops.mesh.primitive_cube_add(size=1,location=p);o=bpy.context.object;o.dimensions=d;bpy.ops.object.transform_apply(location=False,rotation=False,scale=True)
 if b:
  mod=o.modifiers.new('Soft edges','BEVEL');mod.width=b;mod.segments=2;o.modifiers.new('Weighted normals','WEIGHTED_NORMAL')
 return bind(o,n,mat)
def ball(n,p,d,mat):
 bpy.ops.mesh.primitive_uv_sphere_add(segments=24,ring_count=12,location=p);o=bpy.context.object;o.scale=d
 for f in o.data.polygons:f.use_smooth=True
 return bind(o,n,mat)
def tube(n,a,b,r,mat,r2=None):
 a,b=Vector(a),Vector(b);v=b-a
 bpy.ops.mesh.primitive_cone_add(vertices=24,radius1=r,radius2=r if r2 is None else r2,depth=v.length,location=(a+b)/2)
 o=bpy.context.object;o.rotation_euler=v.to_track_quat('Z','Y').to_euler();return bind(o,n,mat)
def surf(n,verts,faces,mat):
 mesh=bpy.data.meshes.new(n);mesh.from_pydata(verts,[],faces);mesh.update()
 o=bpy.data.objects.new(n,mesh);s.collection.objects.link(o);return bind(o,n,mat)
def aim(o,target):o.rotation_euler=(Vector(target)-o.location).to_track_quat('-Z','Y').to_euler()
def light(n,t,loc,target,p,c,size):
 d=bpy.data.lights.new(n,t);d.energy=p;d.color=c
 if t=='AREA':d.shape='DISK';d.size=size
 if t=='SUN':d.angle=math.radians(size)
 if t=='SPOT':d.spot_size=math.radians(size);d.spot_blend=.7;d.shadow_soft_size=.16
 o=bpy.data.objects.new(n,d);s.collection.objects.link(o);o.location=loc;aim(o,target)
def camera(loc,tar,lens):
 d=bpy.data.cameras.new('Final composition 240×135');o=bpy.data.objects.new(d.name,d);s.collection.objects.link(o);o.location=loc;aim(o,tar);d.lens=lens;s.camera=o
def world(c,p):
 s.world=bpy.data.worlds.new('World lighting');s.world.use_nodes=True;n=s.world.node_tree.nodes.get('Background');n.inputs['Color'].default_value=(*c,1);n.inputs['Strength'].default_value=p
def fog(n,loc,dims,density,c,a):
 mat=bpy.data.materials.new(n);mat.use_nodes=True;nodes=mat.node_tree.nodes;links=mat.node_tree.links;nodes.clear()
 v=nodes.new('ShaderNodeVolumeScatter');v.inputs['Density'].default_value=density;v.inputs['Color'].default_value=(*c,1);v.inputs['Anisotropy'].default_value=a
 o=nodes.new('ShaderNodeOutputMaterial');links.new(v.outputs[0],o.inputs['Volume'])
 box(n,loc,dims,mat,0)
def room():
 world((.30,.33,.39),.24)
 wall=m('Dusty teal wall',(.12,.29,.30)); floor=[m('Honey floor %s'%i,c) for i,c in enumerate(((.33,.17,.082),(.29,.145,.072),(.37,.197,.096)))]; wood=m('Warm birch',(.40,.23,.105)); cream=m('Linen',(.63,.52,.34)); white=m('Warm paper',(.81,.72,.53)); muted=m('Washed dusty sage',(.10,.24,.22)); deep=m('Night teal',(.043,.092,.105)); orange=m('Toy coral',(.67,.17,.072)); yellow=m('Toy mustard',(.71,.43,.09)); mint=m('Muted turquoise',(.075,.47,.41)); pink=m('Fabric salmon',(.64,.238,.168)); brown=m('Teddy fur',(.39,.19,.078)); tan=m('Teddy muzzle',(.67,.40,.20)); dark=m('Toy details',(.038,.023,.017))
 box('Back wall',(0,4,2.35),(9,.18,4.7),wall,0)
 box('Left wall',(-4.5,-.1,1.8),(.18,8.1,3.6),muted,0)
 box('Right wall',(4.5,-.1,1.8),(.18,8.1,3.6),muted,0)
 for i in range(27):
  box('Floor board %02d'%i,(-4.3+i*.33,0,-.05),(.326,8,.10),floor[i%3],.003)
 box('Back skirting',(0,3.87,.067),(8.95,.09,.12),wood)
 # Strong nursery motifs hug the sides, leaving a quiet uninterrupted wall.
 box('Left window recess',(-2.78,3.875,2.42),(1.90,.12,1.61),deep,.05)
 dusk,_=material('Late apricot window',(.9,.48,.20));nd=dusk.node_tree.nodes.get('Principled BSDF');nd.inputs['Emission Color'].default_value=(1,.53,.23,1);nd.inputs['Emission Strength'].default_value=.65
 box('Bright window sky',(-2.78,3.79,2.43),(1.68,.06,1.42),dusk,.01)
 for x in (-3.64,-2.78,-1.92):box('Left window vertical mullion',(x,3.74,2.42),(.075,.10,1.54),white)
 for z in (1.69,2.42,3.16):box('Left window horizontal mullion',(-2.78,3.73,z),(1.8,.11,.065),white)
 box('Sunlit ledge',(-2.78,3.60,1.65),(2.05,.40,.087),cream)
 for x in (-3.76,-1.81):
  for j in range(4):ball('Pleated curtain',(x+.063*j,3.53,2.40),(.066,.06,.80),cream)
 # Right small bed, pillow and quilt folds.
 box('Small bed frame',(2.75,2.27,.31),(2.93,2.12,.39),wood,.1)
 box('Right tall headboard',(3.91,2.28,.78),(.25,2.25,1.07),wood,.12)
 box('Cream mattress',(2.72,2.26,.58),(2.66,1.96,.34),white,.15)
 box('Sea-green quilt',(2.53,2.25,.75),(2.14,2.005,.18),mint,.087)
 box('Pillow',(3.60,2.30,.86),(.62,1.54,.22),cream,.10)
 for i in range(6):box('Quilt stitched stripe',(1.65+i*.32,2.25,.845),(.025,1.87,.011),muted,.005)
 # Toy cabinet and a bear in the lower left.
 box('Low play cabinet',(-2.88,2.79,.45),(1.83,.75,.9),wood,.09)
 box('Cabinet inset',(-2.88,2.399,.46),(1.59,.018,.66),deep,.02)
 for z in (.30,.61):box('Cabinet shelf',(-2.88,2.38,z),(1.65,.078,.047),wood)
 for i in range(7):box('Colourful book',(-3.51+i*.106,2.35,.43),(.078,.10,.205),[mint,yellow,pink,cream][i%4])
 x,y,z=-2.52,2.43,1.02
 ball('Bear body',(x,y,z+.12),(.24,.18,.25),brown);ball('Bear head',(x,y-.03,z+.42),(.23,.18,.218),brown)
 for a in (-1,1):
  ball('Bear ear',(x+a*.155,y-.015,z+.57),(.085,.065,.085),brown);ball('Inner ear',(x+a*.154,y-.065,z+.575),(.039,.021,.045),tan)
  ball('Bear eye',(x+a*.072,y-.193,z+.45),(.024,.016,.025),dark);ball('Bear feet',(x+a*.133,y-.145,z-.01),(.12,.12,.14),tan)
  ball('Bear arm',(x+a*.23,y-.037,z+.135),(.113,.099,.121),brown)
 ball('Bear muzzle',(x,y-.18,z+.36),(.113,.066,.084),tan);ball('Bear nose',(x,y-.234,z+.392),(.037,.026,.025),dark)
 for (x,y,z),c,ang in [((-2,1.12,.125),orange,.31),((-2.40,.83,.12),yellow,.1),((-2.20,.55,.13),mint,-.42),((-2.40,.83,.36),pink,.2)]:
  o=box('Rounded wooden play block',(x,y,z),(.24,.24,.24),c,.029);o.rotation_euler.z=ang
 # Corner lamp, ambient lights plus a warm-looking ray through air.
 lamp,_=material('Lit cloth',(.90,.58,.25));n=lamp.node_tree.nodes.get('Principled BSDF');n.inputs['Emission Color'].default_value=(1,.59,.26,1);n.inputs['Emission Strength'].default_value=.75
 tube('Lamp stem',(3.55,3.42,.1),(3.55,3.42,1.99),.034,wood)
 tube('Bedtime lamp shade',(3.55,3.42,1.88),(3.55,3.42,2.19),.33,lamp,.20)
 light('Bedside warm glow','AREA',(3.55,3.1,2.02),(3,1,1),24,(1,.65,.31),.5)
 light('Broad soft ambient','AREA',(0,-1.45,3.25),(0,3,1.4),160,(.71,.83,1),4.6)
 light('Apricot window, key','AREA',(-2.8,3.48,2.72),(-.65,1,.48),330,(1,.59,.28),1.45)
 light('Window ray through dust','SPOT',(-3.3,3.34,2.93),(-1.2,.61,.25),210,(1,.65,.30),27)
 fog('Subtle indoor dust',(-1.96,2.10,1.5),(4.5,4.75,3.1),.012,(.88,.75,.58),.25)
 camera((0,-5.85,1.94),(0,3.4,1.72),39)
def beach():
 world((.37,.63,1),.51)
 # A sky backdrop seen only by camera when light is cast by the physical world.
 sky=s.world.node_tree; nd=sky.nodes; ln=sky.links
 bg=nd.get('Background')
 # Explicit coloured camera sky with a coastal horizon fade; physical reflections use daylight.
 pos=nd.new('ShaderNodeTexCoord'); sep=nd.new('ShaderNodeSeparateXYZ');ln.new(pos.outputs['Normal'],sep.inputs[0]);rng=nd.new('ShaderNodeMapRange');rng.inputs[1].default_value=-.38;rng.inputs[2].default_value=.07;ln.new(sep.outputs['Z'],rng.inputs[0]);ramp=nd.new('ShaderNodeValToRGB');ramp.color_ramp.elements[0].color=(.095,.35,.58,1);ramp.color_ramp.elements[1].color=(.42,.68,.77,1);ln.new(rng.outputs[0],ramp.inputs[0])
 cam_bg=nd.new('ShaderNodeBackground');cam_bg.inputs[1].default_value=.81;ln.new(ramp.outputs[0],cam_bg.inputs[0])
 lp=nd.new('ShaderNodeLightPath');mix=nd.new('ShaderNodeMixShader');ln.new(lp.outputs['Is Camera Ray'],mix.inputs[0]);ln.new(bg.outputs[0],mix.inputs[1]);ln.new(cam_bg.outputs[0],mix.inputs[2]);ln.new(mix.outputs[0],nd.get('World Output').inputs[0])
 water,p=material('Blue turquoise tidal water',(.013,.23,.33),.24,.28)
 nd=water.node_tree.nodes;ln=water.node_tree.links
 pos=nd.new('ShaderNodeTexCoord'); mul=nd.new('ShaderNodeVectorMath');mul.operation='MULTIPLY';mul.inputs[1].default_value=(.32,2.3,.66);ln.new(pos.outputs['Object'],mul.inputs[0])
 n=nd.new('ShaderNodeTexNoise');n.inputs['Scale'].default_value=1.6;n.inputs['Detail'].default_value=2;ln.new(mul.outputs[0],n.inputs[0])
 b=nd.new('ShaderNodeBump');b.inputs['Strength'].default_value=.22;b.inputs['Distance'].default_value=.082;ln.new(n.outputs['Fac'],b.inputs['Height']);ln.new(b.outputs[0],p.inputs['Normal'])
 n2=nd.new('ShaderNodeTexNoise');n2.inputs['Scale'].default_value=.12;n2.inputs['Detail'].default_value=3.;ln.new(pos.outputs['Object'],n2.inputs[0]);r=nd.new('ShaderNodeValToRGB');r.color_ramp.elements[0].position=.21;r.color_ramp.elements[1].position=.79;r.color_ramp.elements[0].color=(.008,.083,.195,1);r.color_ramp.elements[1].color=(.023,.333,.388,1);ln.new(n2.outputs['Fac'],r.inputs[0]);ln.new(r.outputs[0],p.inputs['Base Color'])
 surf('Ocean extends beyond the visible horizon',[(-900,-3,0),(900,-3,0),(900,1400,0),(-900,1400,0)],[(0,1,2,3)],water)
 sand,p=material('Warm fine beach sand',(.54,.32,.14),.92)
 n=sand.node_tree.nodes.new('ShaderNodeTexNoise');n.inputs['Scale'].default_value=50;b=sand.node_tree.nodes.new('ShaderNodeBump');b.inputs['Distance'].default_value=.03;b.inputs['Strength'].default_value=.23;sand.node_tree.links.new(n.outputs['Fac'],b.inputs['Height']);sand.node_tree.links.new(b.outputs[0],p.inputs['Normal'])
 foam=m('Seafoam',(.55,.78,.77),.72)
 def shore(x):return 6.3-.32*x+.31*sin(x*.32)+.16*sin(x*1.25)
 xs=[-30+i*.5 for i in range(121)]
 pts=[(x,shore(x)-2.5,.45) for x in xs]+[(x,shore(x),.028) for x in xs]
 L=len(xs);surf('Sloping warm beach',pts,[(i,i+1,i+1+L,i+L) for i in range(L-1)],sand)
 surf('Beach continuing toward camera',[(-30,-15,.49),(30,-15,.49)]+[(x,shore(x)-2.5,.45) for x in reversed(xs)],[tuple(range(L+2))],sand)
 for j in range(6):
  f=j*.44
  ps=[(x,shore(x)+f+.1*sin(x*.81+j),.036-j*.004) for x in xs]+[(x,shore(x)+f+.032+.026*j+.1*sin(x*.81+j),.035-j*.004) for x in xs]
  surf('Breaking foam stripe %s'%j,ps,[(i,i+1,i+1+L,i+L) for i in range(L-1) if (i+j*7)% (13+j)>j+1],foam)
 # Peripheral tilt-poled parasol and sparse air-light cloud wisps.
 canvas=[m('Sun-bleached red canvas',(.70,.13,.072)),m('Cream canvas stripe',(.86,.75,.56))]
 pole=m('Driftwood',(.32,.16,.078));tube('Parasol pole',(-3.96,4.15,.22),(-3.78,4.16,2.22),.031,pole)
 P=(-3.78,4.16,2.22);verts=[P]
 verts.extend((P[0]+1.0*cos(pi*i/6),P[1]+1.0*sin(pi*i/6),P[2]-.39) for i in range(12))
 ve=[(0,i+1,(i+1)%12+1) for i in range(12)]
 umbrella=surf('Red and cream parasol',verts,ve,canvas[0]);umbrella.data.materials.append(canvas[1])
 for i,f in enumerate(umbrella.data.polygons):f.material_index=(i//2)%2
 towel=m('Apricot beach towel',(.64,.27,.11)); o=box('Rolled towel',(-2.79,3.75,.466),(.53,.25,.065),towel,.04);o.rotation_euler.z=.3
 cloud,_=material('Bright thin distant cloud',(.74,.81,.88));n=cloud.node_tree.nodes.get('Principled BSDF');n.inputs['Emission Color'].default_value=(.34,.53,.64,1);n.inputs['Emission Strength'].default_value=.18
 for k,(x,y,z,w) in enumerate([(-47,112,19,14),(52,135,15,19)]):
  for i in range(5):ball('High sea cloud off edge',(x+i*w*.19,y+i*.7,z+.42*cos(i)),(w*.24,2.2,1+.37*sin(i*.8)),cloud)
 light('Sunny coastal key','SUN',(-9,5,15),(0,9,0),1.7,(1,.94,.79),10)
 light('Open water fill','AREA',(7,2,12),(0,10,0),440,(.50,.82,1),9)
 fog('Aerial perspective at the horizon',(0,290,10),(1300,400,20),.0008,(.65,.81,.89),.17)
 camera((0,-4.3,2.87),(0,17,2.77),31)
{'room':room,'beach':beach}[mode]()
s.render.engine='CYCLES';s.cycles.use_denoising=False;s.cycles.samples=768;s.cycles.volume_bounces=2
s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100;s.render.film_transparent=False;s.render.image_settings.file_format='PNG';s.render.image_settings.color_mode='RGB'
s.view_settings.view_transform='AgX';s.view_settings.exposure=.15 if mode=='room' else -.15
s.frame_start=s.frame_end=1;s.render.threads_mode='FIXED';s.render.threads=4
s['scope']='Original editable scene for static Cardputer RGB backdrop; character not included.'
s.render.filepath='//'+mode+'-240x135.png'
bpy.context.preferences.filepaths.save_version=0
for sc in bpy.data.screens:
 for a in sc.areas:
  if a.type=='VIEW_3D':a.spaces.active.region_3d.view_perspective='CAMERA'
if '--draft' in sys.argv:
 s.cycles.samples=16;s.render.filepath=str(out/(mode+'-draft.png'))
else:
 filename=str(out/(mode+'.blend'));bpy.ops.wm.save_as_mainfile(filepath=filename,compress=True);bpy.ops.wm.open_mainfile(filepath=filename)
 s=bpy.context.scene
 assert s.render.engine=='CYCLES' and s.render.image_settings.color_mode=='RGB' and not s.render.film_transparent and s.render.resolution_x==240 and s.render.resolution_y==135
bpy.ops.render.render(write_still=True)
