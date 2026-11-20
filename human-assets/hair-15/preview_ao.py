"""Same strong key + gentle fill for both renders, not saved into the source .blend."""
import bpy,sys,math,os
from pathlib import Path
from mathutils import Vector
source,out=map(Path,sys.argv[-3:-1]);mode=sys.argv[-1];assert mode in ('on','off')
out.mkdir(parents=True,exist_ok=True)
bpy.ops.wm.open_mainfile(filepath=str(source.resolve()),use_scripts=False)
s=bpy.context.scene;s.frame_set(1);s.render.engine='CYCLES';s.cycles.samples=100;s.cycles.use_denoising=False;s.cycles.seed=19
mat=bpy.data.materials['Hair · chestnut and real contact only']
if mode=='off':mat.node_tree.nodes['Chestnut contact mix'].inputs[0].default_value=0
s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA'
cam=s.camera;cam.data.type='ORTHO'
for o in list(s.objects):
 if o.type=='LIGHT' or o.name.startswith('Preview floor'):o.hide_render=True
w=next(n for n in s.world.node_tree.nodes if n.type=='BACKGROUND')
w.inputs['Color'].default_value=(.68,.74,.88,1);w.inputs['Strength'].default_value=.25
def light(n,typ,loc,target,color,power,radius):
 l=bpy.data.lights.new(n,typ);l.color=color;l.energy=power
 if typ=='SUN':l.angle=radius
 else:l.shape='DISK';l.size=radius
 ob=bpy.data.objects.new(n,l);s.collection.objects.link(ob);ob.location=loc
 ob.rotation_euler=(Vector(target)-ob.location).to_track_quat('-Z','Y').to_euler()
# Fixed world-space key from upper front-side, plus a modest broad unobtrusive rear bounce.
light('Directional demo key','SUN',((-7,3.5,7.8) if os.getenv('REAR_SIDE_KEY') else (-4,-5,9)),(0,0,4.7),(1,.89,.77),2.65,.115)
light('Wide quiet bounce','AREA',(3,4,7.4),(0,0,4.7),(.83,.88,1),110,6)
for mode,z,scale,wh in [('face',4.76,2.24,(360,320)),('native',2.79,10.6,(240,135))]:
 target=Vector((0,0,z));cam.data.ortho_scale=scale
 s.render.resolution_x,s.render.resolution_y=wh;s.render.resolution_percentage=100
 for deg,view in [(0,'front'),(-35,'oblique'),(180,'back')]:
  if os.getenv('HAIR_VIEW') and os.getenv('HAIR_VIEW')!=f'{mode}-{view}':continue
  a=math.radians(deg);cam.location=(math.sin(a)*13,-math.cos(a)*13,z+(.66 if mode=='native' else .24))
  cam.rotation_euler=(target-cam.location).to_track_quat('-Z','Y').to_euler()
  s.render.filepath=str((out/f'{mode}-{view}.png').resolve());bpy.ops.render.render(write_still=True)
