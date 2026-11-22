"""Generate two editable Cycles backgrounds. blender -b --python build.py -- room|beach."""
import bpy, math, random, sys, os
from mathutils import Vector
from math import sin, cos, pi, exp
from pathlib import Path
out=Path(__file__).resolve().parent
mode='beach'
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
 light('Sunny coastal key','SUN',(7,6,18),(0,7,0),2.35,(1,.94,.79),10)
 light('Open water fill','AREA',(7,2,12),(0,10,0),440,(.50,.82,1),9)
 fog('Aerial perspective at the horizon',(0,290,10),(1300,400,20),.00032,(.65,.81,.89),.17)
 camera((0,-4.3,2.87),(0,17,2.77),31)
 # Physical lens focus on far water, softly blurring only close corner foliage.
 cam=s.camera;cam.data.dof.use_dof=True;cam.data.dof.focus_distance=19;cam.data.dof.aperture_fstop=1.65
 gold=m('Warm-lit dune grass',(.115,.194,.043));dry=m('Sun-bleached leaf',(.25,.25,.077))
 # Camera-space fronds in bottom corners, outside the padded character envelope.
 def ray(u,v,d):
  f=cam.data.view_frame(scene=s)
  x=min(p.x for p in f)+(max(p.x for p in f)-min(p.x for p in f))*u
  y=min(p.y for p in f)+(max(p.y for p in f)-min(p.y for p in f))*v
  return tuple(cam.matrix_world @ (Vector((x,y,f[0].z))*d/(-f[0].z)))
 bpy.context.view_layer.update()
 random.seed(21)
 for side in (0,1):
  for k in range(11):
   orig=(.006+random.random()*.075) if side==0 else (.988-random.random()*.061)
   lean=random.uniform(-.040,.057)*(1 if side==0 else -1)
   top=random.uniform(.10,.31);depth=random.uniform(.19,.24);w=random.uniform(.007,.012)
   ps=[]
   for i in range(7):
    t=i/6;u=orig+lean*t**1.7;v=-.055+(top+.055)*t
    for g in (-1,1):ps.append(ray(u+g*w*(1-t+.04),v,depth-.021*t))
   surf('Optically defocused corner dune blades',ps,[(i,i+1,i+3,i+2) for i in range(0,12,2)],gold if k%3 else dry)
 # Camera-visible hot sun only. Camera-ray pass-through prevents changing the scene
 # illumination; the coastal SUN provides directional shadows and glitter already.
 sun=bpy.data.materials.new('White-hot visible sun disk');sun.use_nodes=True
 ns=sun.node_tree.nodes;ls=sun.node_tree.links;ns.clear()
 lp=ns.new('ShaderNodeLightPath');mix=ns.new('ShaderNodeMixShader');tr=ns.new('ShaderNodeBsdfTransparent')
 em=ns.new('ShaderNodeEmission');em.inputs[0].default_value=(1.,.70,.35,1);em.inputs[1].default_value=59
 zz=ns.new('ShaderNodeOutputMaterial');ls.new(lp.outputs['Is Camera Ray'],mix.inputs[0]);ls.new(tr.outputs[0],mix.inputs[1]);ls.new(em.outputs[0],mix.inputs[2]);ls.new(mix.outputs[0],zz.inputs[0])
 pos=[ray(.872,.820,110)]
 pos +=[ray(.872+.019*cos(i*pi/32),.820+.0338*sin(i*pi/32),110) for i in range(64)]
 surf('Sun in upper right',pos,[(0,i+1, (i+1)%64+1) for i in range(64)],sun)
 # Prerender optical effects in the compositor; no lens effects at runtime.
 s.use_nodes=True; ns=s.node_tree.nodes; ls=s.node_tree.links
 render=ns.get('Render Layers'); final=ns.get('Composite')
 glow=ns.new('CompositorNodeGlare');glow.glare_type='FOG_GLOW';glow.quality='HIGH';glow.threshold=1.3;glow.size=8;glow.mix=0
 streak=ns.new('CompositorNodeGlare');streak.glare_type='STREAKS';streak.streaks=4;streak.angle_offset=.35;streak.fade=.88;streak.threshold=4;streak.mix=-.81
 ls.new(render.outputs['Image'],glow.inputs[0]);ls.new(glow.outputs['Image'],streak.inputs[0]);ls.new(streak.outputs['Image'],final.inputs[0])
 s['depth_notes']='Optical near-corner foliage DOF, midground surf/umbrella, distant horizon, Blender compositor sun bloom/streak. One flattened RGB image; no occlusion or parallax at runtime.'

beach()
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
