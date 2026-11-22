"""Generate the editable depth-pass Vaporwave Temple Cycles background."""
import bpy, math, random, sys, os
from mathutils import Vector
from math import sin, cos, pi, exp
from pathlib import Path
out=Path(__file__).resolve().parent
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
def temple():
 world((.30,.19,.52),.44)
 sky=s.world.node_tree; ns=sky.nodes; ls=sky.links
 tex=ns.new('ShaderNodeTexCoord'); sep=ns.new('ShaderNodeSeparateXYZ'); ls.new(tex.outputs['Normal'],sep.inputs[0])
 r=ns.new('ShaderNodeMapRange');r.inputs[1].default_value=-.44;r.inputs[2].default_value=.04;ls.new(sep.outputs['Z'],r.inputs[0])
 a=ns.new('ShaderNodeValToRGB');a.color_ramp.elements[0].color=(.031,.017,.12,1);a.color_ramp.elements[1].color=(.38,.061,.24,1);a.color_ramp.elements.new(.58).color=(.135,.033,.23,1)
 ls.new(r.outputs[0],a.inputs[0]);ls.new(a.outputs[0],ns.get('Background').inputs[0])
 def em(name,rgb,power=1):
  mat=bpy.data.materials.new(name);mat.use_nodes=True;ns=mat.node_tree.nodes;ls=mat.node_tree.links;ns.clear()
  sh=ns.new('ShaderNodeEmission');sh.inputs[0].default_value=(*rgb,1);sh.inputs[1].default_value=power
  out=ns.new('ShaderNodeOutputMaterial');ls.new(sh.outputs[0],out.inputs['Surface'])
  return mat
 bands=[em('Solar band %02d'%i,(1,.24-.016*i,.43-.018*i),1.15-.075*i) for i in range(8)]
 for i in range(8):
  rr=4.;z0=rr-1*i-.11*i;z1=z0-.86
  levels=[max(-rr,z0)+(max(-rr,z1)-max(-rr,z0))*j/10 for j in range(11)]
  v=[]
  for v0 in levels:
   w=math.sqrt(max(0,rr*rr-v0*v0));v.extend([(17-w,43,5.2+v0),(17+w,43,5.2+v0)])
  surf('Slatted retro sunset %d'%i,v,[(j,j+1,j+3,j+2) for j in range(0,len(v)-2,2)],bands[i])
 stone=m('Rose-tinted pale travertine',(.47,.31,.43),.56);edge=m('Mauve base moulding',(.21,.12,.30),.58)
 accent=m('High cyan reflection',(.075,.34,.39),.40)
 def column(x,y,h,r):
  box('Temple pedestal',(x,y,.17),(r*3.3,r*3.3,.34),edge,.085)
  for k,(z,rad,th) in enumerate([(.36,1.49,.14),(.47,1.30,.15),(h-.12,1.28,.11),(h,1.52,.13)]):
   tube('Column capital or base ring',(x,y,z-th/2),(x,y,z+th/2),r*rad,stone)
  verts=[]
  for z,sc in ((.48,1),(h-.14,.86)):
   for j in range(120):
    ang=2*pi*j/120;rad=r*sc*(.93+.07*cos(ang*15))
    verts.append((x+rad*cos(ang),y+rad*sin(ang),z))
  surf('Fluted column',verts,[(j,(j+1)%120,120+(j+1)%120,120+j) for j in range(120)],stone)
  box('Square temple abacus',(x,y,h+.13),(r*3.2,r*3.2,.22),stone,.07)
 for y,x,h,r in ((.4,3.65,5.2,.43),(3.9,4.8,5.2,.41),(8.4,6.3,4.7,.38),(14,8.5,4.5,.33)):
  for side in (-1,1):column(side*x,y,h,r)
 for sign in (-1,1):
  a=Vector((sign*3.43,-1,5.48));b=Vector((sign*9.2,17,5.48));d=b-a
  o=box('Side gallery entablature',(a+b)/2,(.75,d.length,.28),stone,.067);o.rotation_euler.z=-math.atan2(d.x,d.y)
  a.z-=.20;b.z-=.20;o=box('Side gallery cyan frieze',(a+b)/2,(.79,d.length,.10),accent,.025);o.rotation_euler.z=-math.atan2(d.x,d.y)
 # Editable perspectival floor; dark violet tile buffed to pick up the lighting.
 grout=m('Deep purple grout',(.055,.034,.12),.34)
 p1=m('Blackberry tiles',(.071,.041,.17),.42);p2=m('Muted lilac tiles',(.126,.066,.25),.41)
 box('Floor substrate',(0,15,-.18),(60,44,.20),grout,0)
 for j in range(23):
  for i in range(19):
   x=(i-9)*1.50;y=-5.2+j*1.50
   # Use single flat mesh planes, leaving a narrow grout gap.
   q=.739
   surf('Alternating floor tile',[(x-q,y-q,-.073),(x+q,y-q,-.073),(x+q,y+q,-.073),(x-q,y+q,-.073)],[(0,1,2,3)],p1 if (i+j)%2==0 else p2)
 for y in (15,23,31):
  box('Far altar stair',(0,y,.04),(12,.6,.17),edge,.06)
 fog('Lavender atmospheric floor haze',(0,24,2),(40,30,4),.013,(.62,.46,.92),.30)
 light('Magenta rim sunset','AREA',(4.3,14,7),(0,0,1),2100,(1,.25,.50),9)
 light('Cool gallery key','AREA',(-5,-1,5),(1,7,.9),1250,(.20,.86,1),7)
 light('Soft indigo frontal fill','AREA',(3,-4,7),(0,8,1.9),670,(.64,.53,1),9)
 # A deliberately broken distant Parthenon-like silhouette on a raised plinth.
 cx=-11.5; cy=31.5
 distant_stone=m('Far mauve limestone',(.337,.23,.47),.79)
 faint_pink=m('Faded rose exposed fracture',(.26,.15,.29),.75)
 farbase=m('Distant steps through lavender',(.105,.066,.18),.72)
 for j in range(3):
  box('Distant ruin stylobate '+str(j),(cx,cy+.45*j,.32+.31*j),(12.0-.55*j,4.5-.42*j,.32),farbase,.025)
 for rear,d in ((False,0.0),(True,2.55)):
  for i,h in enumerate(([4.65,4.36,2.08,4.43,.52,3.4,4.54] if not rear else [4.68,4.58,4.49,4.43,3.24,4.0,4.36])):
   xx=cx-4.23+i*1.39; yy=cy+d
   # Missing bay and differing truncated shafts make the ruin readable.
   if h<1.0:
    box('Collapsed capital',(xx-.03,yy-.22,1.04),(.66,.64,.31),faint_pink,.02).rotation_euler.z=.31
    continue
   tube('Distant truncated column',(xx,yy,.95),(xx+.045,yy,.95+h),.27,distant_stone,.208)
   box('Weathered column base',(xx,yy,1.07),(.62,.63,.19),distant_stone,.04)
   if h>4.2:box('Heavy weathered abacus',(xx+.05,yy,1.0+h),(.65,.59,.23),distant_stone,.04)
   else:box('Chipped exposed column top',(xx+.025,yy,1+h),(.48,.46,.12),faint_pink,.02).rotation_euler.y=.18
 # No clean triangle: part of the gable has fallen, leaving a sawtoothed profile.
 def ruined_face(name,y,outline):
  f=[(cx+x,y,z) for x,z in outline]
  b=[(x,y+.24,z) for x,y,z in f];a=len(f)
  return surf(name,f+b,[tuple(range(a)),tuple(reversed(range(a,2*a)))]+[(i,(i+1)%a,(i+1)%a+a,i+a) for i in range(a)],distant_stone)
 ruined_face('Broken pediment main fragment',cy-.2,[(-4.7,5.56),(-.22,5.56),(.18,5.86),(-.26,6.10),(.34,6.35),(-.3,6.53),(-.12,6.86),(-.46,7.11)])
 ruined_face('Broken pediment surviving right lip',cy-.16,[(2.14,5.57),(4.82,5.57),(3.66,6.06),(3.11,5.96)])
 ruined_face('Thin rear collapsed gable',cy+2.69,[(-4.72,5.54),(3.81,5.54),(1.37,6.36),(.93,6.33),(.46,6.71),(-.22,6.89)])
 for i in range(13):
  x=cx-5.5+i*.86;y=cy-.84+(.23*(i%3))
  o=box('Tumbled masonry',(x,y,.51),(.51,.49,.42),farbase,.09);o.rotation_euler.z=.22*(i%5)
 light('Diffuse light above distant ruin','AREA',(cx-3,cy-7,10),(cx,cy,3.7),1410,(.76,.43,.74),10)
 fog('Extra soft veil along distant avenue',(-12,25.0,2.75),(28,12,6.0),.009,(.62,.45,.82),.26)
 camera((0,-5.7,2.18),(0,21,2.18),32)
 cam=s.camera;d=cam.data; d.dof.use_dof=True;d.dof.focus_distance=8.3;d.dof.aperture_fstop=1.0;d.dof.aperture_blades=7
 bpy.context.view_layer.update()
 def screen(x,y,dist):
  k=dist*d.sensor_width/d.lens/240
  return cam.matrix_world @ Vector(((x-120)*k,(67.5-y)*k,-dist))
 for side in (-1,1):
  px=-2 if side==-1 else 241
  q=tube('Optical foreground fragment',screen(px,136,1.32),screen(px+(side*-.0),53 if side==-1 else 42,1.36),.095,stone,.068)
  q['camera_near_layer']=True
  for k in range(2):
   q=tube('Optical foreground fragment band',screen(px,119-k*11,1.29),screen(px,117-k*11,1.29),.117-.011*k,accent)
   q['camera_near_layer']=True
temple()
s.render.engine='CYCLES';s.cycles.use_denoising=False;s.cycles.samples=384;s.cycles.volume_bounces=2
s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100;s.render.film_transparent=False;s.render.image_settings.file_format='PNG';s.render.image_settings.color_mode='RGB'
s.view_settings.view_transform='AgX';s.view_settings.exposure=.1
s.frame_start=s.frame_end=1;s.render.threads_mode='FIXED';s.render.threads=5
s['scope']='Static Cardputer backdrop. No character, materials are procedural and all geometry editable.'
s.render.filepath='//temple-240x135.png';bpy.context.preferences.filepaths.save_version=0
for sc in bpy.data.screens:
 for a in sc.areas:
  if a.type=='VIEW_3D':a.spaces.active.region_3d.view_perspective='CAMERA'
if '--draft' in sys.argv:
 s.cycles.samples=24;s.render.filepath=str(out/'temple-draft.png')
else:
 filename=str(out/'temple.blend');bpy.ops.wm.save_as_mainfile(filepath=filename,compress=True);bpy.ops.wm.open_mainfile(filepath=filename)
 s=bpy.context.scene
 assert s.render.engine=='CYCLES' and not s.render.film_transparent and s.render.image_settings.color_mode=='RGB' and (s.render.resolution_x,s.render.resolution_y)==(240,135)
bpy.ops.render.render(write_still=True)
