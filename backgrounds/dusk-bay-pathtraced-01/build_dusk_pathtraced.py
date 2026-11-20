"""Editable procedural landscape and actual Cycles scattering. Run in Blender."""
import bpy, math, os, sys
from mathutils import Vector
from math import sin, cos, exp
ROOT=os.path.dirname(os.path.realpath(__file__))
bpy.ops.wm.read_factory_settings(use_empty=True)
s=bpy.context.scene
def mat(name,col,rough=.8):
 m=bpy.data.materials.new(name);m.diffuse_color=(*col,1);m.use_nodes=True
 b=m.node_tree.nodes.get('Principled BSDF');b.inputs['Base Color'].default_value=(*col,1);b.inputs['Roughness'].default_value=rough
 return m,b
def cube(name,loc,dimensions,material):
 bpy.ops.mesh.primitive_cube_add(size=1,location=loc);o=bpy.context.object;o.name=name;o.dimensions=dimensions;bpy.ops.object.transform_apply(location=False,rotation=False,scale=True);o.data.materials.append(material);return o
def geometry(name,p,f,m):
 d=bpy.data.meshes.new(name);d.from_pydata(p,[],f);d.update()
 o=bpy.data.objects.new(name,d);s.collection.objects.link(o);d.materials.append(m);return o
def ridge(name,y0,depth,a,center,w,col,phase):
 m,_=mat(name,col,.99)
 pts=[];faces=[];nx=101;ny=14
 for j in range(ny):
  k=j/(ny-1);y=y0+k*depth
  for i in range(nx):
   x=-100+2*i
   a0=a*exp(-((x-center)/w)**2)*(.80+.10*cos(x*.31+phase)+.12*sin(x*.17+phase)+.04*cos(x*.91))
   z=-1.4+a0*sin(math.pi*k)**1.1
   pts.append((x,y,z))
 for j in range(ny-1):
  for i in range(nx-1):
   t=j*nx+i;faces.append((t,t+1,t+nx+1,t+nx))
 return geometry(name,pts,faces,m)
water,b=mat('Bay • reflective fine surface',(.044,.183,.197),.16)
b.inputs['Metallic'].default_value=.23
n=water.node_tree.nodes;l=water.node_tree.links
coord=n.new('ShaderNodeTexCoord');stretch=n.new('ShaderNodeVectorMath');stretch.operation='MULTIPLY';stretch.inputs[1].default_value=(.45,2.6,1)
noise=n.new('ShaderNodeTexNoise');noise.inputs['Scale'].default_value=1.3;noise.inputs['Detail'].default_value=2.;bump=n.new('ShaderNodeBump');bump.inputs['Strength'].default_value=.23;bump.inputs['Distance'].default_value=.095
l.new(coord.outputs['Object'],stretch.inputs[0]);l.new(stretch.outputs[0],noise.inputs[0]);l.new(noise.outputs['Fac'],bump.inputs['Height']);l.new(bump.outputs[0],b.inputs['Normal'])
geometry('Still dark tidal water',[(-110,-8,0),(110,-8,0),(110,180,0),(-110,180,0)],[(0,1,2,3)],water)
for spec in [
 ('Far peninsula, western shoulder',63,24,12,-27,27,(.045,.123,.146),.2),
 ('Far islands, east',67,25,11,31,20,(.047,.128,.150),2.2),
 ('Middle western pine ridge',36,26,9,-19,18,(.037,.093,.096),1.6),
 ('Middle eastern cliff',38,27,10,24,17,(.028,.078,.089),2.6),
 ('Near shoreline, west edge',4,21,5.3,-31,15,(.025,.072,.067),4.3),
 ('Near shoreline, east edge',6,18,5.5,31,15,(.020,.067,.071),3.2)]:
 ridge(*spec)
# Broad teal atmosphere with a physically sampled scattering shader. Density fades
# vertically and varies in world space; no painted beams, fog cards, or composites.
volume=bpy.data.materials.new('Low marine fog • true scattering');volume.use_nodes=True
n=volume.node_tree.nodes;l=volume.node_tree.links;n.clear()
out=n.new('ShaderNodeOutputMaterial');pv=n.new('ShaderNodeVolumeScatter');pv.inputs['Color'].default_value=(.67,.78,.79,1);pv.inputs['Anisotropy'].default_value=.44;l.new(pv.outputs[0],out.inputs['Volume'])
tex=n.new('ShaderNodeTexCoord');geo=n.new('ShaderNodeNewGeometry');sep=n.new('ShaderNodeSeparateXYZ');l.new(geo.outputs['Position'],sep.inputs[0])
grad=n.new('ShaderNodeMapRange');grad.inputs['From Min'].default_value=-1.0;grad.inputs['From Max'].default_value=26;grad.inputs['To Min'].default_value=.88;grad.inputs['To Max'].default_value=.04;l.new(sep.outputs['Z'],grad.inputs[0])
noise=n.new('ShaderNodeTexNoise');noise.inputs['Scale'].default_value=.16;noise.inputs['Detail'].default_value=2.;l.new(geo.outputs['Position'],noise.inputs['Vector'])
mod=n.new('ShaderNodeMath');mod.operation='MULTIPLY_ADD';mod.inputs[1].default_value=1.;mod.inputs[2].default_value=.28;l.new(noise.outputs['Fac'],mod.inputs[0])
density=n.new('ShaderNodeMath');density.operation='MULTIPLY';l.new(grad.outputs[0],density.inputs[0]);l.new(mod.outputs[0],density.inputs[1])
strength=n.new('ShaderNodeMath');strength.operation='MULTIPLY';strength.inputs[1].default_value=.019;l.new(density.outputs[0],strength.inputs[0]);l.new(strength.outputs[0],pv.inputs['Density'])
fog=cube('Regional marine scattering volume',(0,35,13),(140,106,29),volume)
def sky_nodes():
 w=bpy.data.worlds.new('Blue hour • chromatic environment');w.use_nodes=True;s.world=w;n=w.node_tree.nodes;l=w.node_tree.links
 bg=n.get('Background');bg.inputs['Strength'].default_value=.50
 tx=n.new('ShaderNodeTexCoord');sep=n.new('ShaderNodeSeparateXYZ');l.new(tx.outputs['Normal'],sep.inputs[0])
 sm=n.new('ShaderNodeMapRange');sm.inputs[1].default_value=-.22;sm.inputs[2].default_value=.16;l.new(sep.outputs['Z'],sm.inputs[0])
 ramp=n.new('ShaderNodeValToRGB');ramp.color_ramp.elements[0].color=(.033,.092,.151,1);ramp.color_ramp.elements[1].color=(.085,.185,.224,1)
 l.new(sm.outputs[0],ramp.inputs[0]);l.new(ramp.outputs[0],bg.inputs[0])
sky_nodes()
def light(name,kind,loc,target,power,color,size):
 d=bpy.data.lights.new(name,kind);d.energy=power;d.color=color
 if kind=='SPOT':d.spot_size=math.radians(size);d.spot_blend=.52;d.shadow_soft_size=.9
 if kind=='SUN':d.angle=math.radians(size)
 o=bpy.data.objects.new(name,d);s.collection.objects.link(o);o.location=loc;o.rotation_euler=(Vector(target)-o.location).to_track_quat('-Z','Y').to_euler();return o
light('Warm dusk key / low-angle path-traced sun','SUN',(-46,62,15),(7,15,0),.45,(1,.62,.35),8)
light('West bank raking fog shaft','SPOT',(-43,57,29),(-9,22,5),132000,(1,.62,.32),15)
light('Secondary raking fog light','SPOT',(-53,64,24),(-11,21,2),85000,(1,.58,.29),7)
light('High blue fill','SUN',(10,-30,32),(0,20,0),.26,(.47,.65,1),24)
d=bpy.data.cameras.new('240×135 dusk composition');cam=bpy.data.objects.new(d.name,d);s.collection.objects.link(cam);cam.location=(0,-21,7.1)
cam.rotation_euler=(Vector((0,38,11))-cam.location).to_track_quat('-Z','Y').to_euler();d.lens=40;s.camera=cam
s.render.engine='CYCLES';s.cycles.samples=1536;s.cycles.use_denoising=False;s.cycles.volume_bounces=2
s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
s.render.film_transparent=False;s.render.image_settings.file_format='PNG';s.render.image_settings.color_mode='RGB'
s.view_settings.view_transform='AgX';s.view_settings.exposure=.55
s.frame_start=s.frame_end=1;s.render.threads_mode='FIXED';s.render.threads=8
s['Scope']='Static background only. Real geometry and scattering; no characters, runtime lighting, or parallax.'
s.render.filepath='//cloud-dusk-pathtraced-240x135.png'
bpy.context.preferences.filepaths.save_version=0
for sc in bpy.data.screens:
 for a in sc.areas:
  if a.type=='VIEW_3D':a.spaces.active.region_3d.view_perspective='CAMERA'
fast='--draft' in sys.argv
if fast: s.cycles.samples=96;s.render.filepath=os.path.join(ROOT,'draft.png')
else:
 path=os.path.join(ROOT,'cloud-dusk-pathtraced.blend');bpy.ops.wm.save_as_mainfile(filepath=path,compress=True)
 bpy.ops.wm.open_mainfile(filepath=path);s=bpy.context.scene
 assert s.render.engine=='CYCLES' and s.cycles.volume_bounces>=1 and not s.render.film_transparent
 assert len(bpy.data.images)==0 and any(n.type=='VOLUME_SCATTER' for n in bpy.data.materials['Low marine fog • true scattering'].node_tree.nodes)
bpy.ops.render.render(write_still=True)
