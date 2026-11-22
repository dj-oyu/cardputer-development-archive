"""Generate two editable Cycles backgrounds. blender -b --python build.py -- room|beach."""
import bpy, math, random, sys, os
from mathutils import Vector
from math import sin, cos, pi, exp
from pathlib import Path
out=Path(__file__).resolve().parent
mode='room'
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
 box('Back wall west',(-1.22,4,2.35),(6.56,.18,4.7),wall,0)
 box('Back wall east edge',(4.12,4,2.35),(.78,.18,4.7),wall,0)
 box('Wall over doorway',(2.9,4,3.6),(1.67,.18,2.20),wall,0)
 box('Hallway far wall',(2.9,7.30,2.35),(2,.18,4.7),deep,0)
 box('Hallway floor',(2.9,5.58,-.05),(2.05,3.45,.1),wood,0)
 for x in (2.02,3.75):
  box('Hall inner jamb',(x,5.57,1.56),(.10,3.26,3.13),muted)
  box('Doorframe upright',(x,3.87,1.26),(.10,.14,2.52),wood)
 box('Doorframe lintel',(2.88,3.87,2.51),(1.85,.15,.14),wood)
 box('Hallway floor stripe',(2.91,6.44,.012),(1.62,.05,.024),white,.01)
 light('Warm light from the deeper hallway','AREA',(3.0,6.38,2.32),(2.45,4.65,.3),84,(1,.59,.31),.82)
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
 camera((0,-5.85,1.95),(0,3.4,1.95),39)
 cam=s.camera;cam.data.dof.use_dof=True;cam.data.dof.focus_distance=8.6;cam.data.dof.aperture_fstop=1.90
 # Camera-level support, intentionally no tilted horizon. Books just inside the
 # picture at lower left are 23 cm from lens and visibly softer than the bed.
 bpy.context.view_layer.update()
 def lens(u,v,d):
  f=cam.data.view_frame(scene=s)
  x=min(p.x for p in f)+(max(p.x for p in f)-min(p.x for p in f))*u
  y=min(p.y for p in f)+(max(p.y for p in f)-min(p.y for p in f))*v
  return tuple(cam.matrix_world @ (Vector((x,y,f[0].z))*d/-f[0].z))
 for i,(clr,ang) in enumerate(((deep,-.15),(orange,.23),(wood,-.09))):
  y=.078+i*.039;u=.017+i*.009
  o=box('Soft near corner picture-book %d'%i,lens(u,y,.34),(.068,.012,.010),clr,.001);o.rotation_euler.y=ang
  o=box('Soft near picture-book pages %d'%i,lens(u+.004,y+.008,.341),(.064,.008,.004),white,.001);o.rotation_euler.y=ang
 s['depth_notes']='Horizontal optical axis, screen-space eye line y67.5; optically defocused foreground books, midground toys/bed, recessed lit hallway.'
room()
s.render.engine='CYCLES';s.cycles.use_denoising=False;s.cycles.samples=1024;s.cycles.volume_bounces=2
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
