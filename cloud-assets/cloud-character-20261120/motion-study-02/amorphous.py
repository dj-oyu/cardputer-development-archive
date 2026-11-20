"""Create an editable amorphous-motion branch without modifying the original .blend."""
import bpy, os, math, json, hashlib, sys
from mathutils import Vector
from bpy_extras.object_utils import world_to_camera_view
from math import sin,cos,pi,exp
here=os.path.dirname(os.path.realpath(__file__))
argv=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
archive_default=os.path.join(here,'..','v1','cloud-delivery.blend')
local_default=os.path.join(here,'..','cloud-character-model','delivery','cloud-delivery.blend')
original=os.path.abspath(argv[0]) if argv else (archive_default if os.path.isfile(archive_default) else local_default)
orig_hash=hashlib.sha256(open(original,'rb').read()).hexdigest()
bpy.ops.wm.open_mainfile(filepath=original)
s=bpy.context.scene;rig=bpy.data.objects['Cloud_Rig'];body=bpy.data.objects['Cloud body']
rig.animation_data_clear()
body.shape_key_add(name='Basis')
# Travel follows a rough path across the left flank, lower edge and right flank;
# further lobes are separately excited. Negative weights contract a lobe.
lobes=[
 ('Crown left',(-.71,.10,.78),.19,.175), ('Shoulder L',(-.98,-.03,.20),.22,.245), 
 ('West lower',(-1.02,-.10,-.61),.26,.23), ('South west',(-.56,-.15,-1.12),.19,.25),
 ('South east',(.52,-.19,-1.13),.21,.23), ('East lower',(1.00,-.10,-.62),.23,.22),
 ('Shoulder R',(1.00,.16,.26),.19,.225), ('Crown right',(.68,.18,.91),.16,.18),
 ('Back',(-.05,.78,.02),.17,.28)]
keys=[]
def clamp(x): return max(0,min(1,x))
def smooth(x): x=clamp(x); return x*x*(3-2*x)
for k,(name,center,strength,spread) in enumerate(lobes):
 key=body.shape_key_add(name=name+' • billow')
 key.slider_min=-1; key.slider_max=1
 cv=Vector(center)
 for i,v in enumerate(body.data.vertices):
  pos=v.co
  # Fully pin the front face window, taper influences only past its boundary.
  # Application is in body-local coordinates; the facial objects move with Body.
  facefront=smooth((-pos.y-.43)/.32)
  facerim=smooth((.94-abs(pos.x))/.23)*smooth((pos.z+.24)/.27)*smooth((.95-pos.z)/.27)
  pin=1-facefront*facerim
  e=pos-cv;g=exp(-(e.length_squared)/(2*spread**2))
  direction=Vector((pos.x,.70*pos.y,.80*pos.z)).normalized()
  # Local radial growth plus slight upward advection gives flowing edges.
  direction.z+=.14 if k%2==0 else -.09
  key.data[i].co=pos+direction*(strength*(1.60 if 0<k<7 else 1.20)*g*pin)
 keys.append(key)
def waves(t,k):
 phase=2*pi*t/5-2*pi*k/9
 expansion=exp(3.0*(cos(phase)-1))
 contraction=exp(2.7*(cos(phase+1.29)-1))
 return .92*expansion-.79*contraction+.10*sin(2*pi*t/10+.6*k)
def animate_bone(name, prop, fun):
 pb=rig.pose.bones[name]
 for f in range(1,242,6):
  t=(f-1)/24 if f<241 else 0
  setattr(pb,prop,fun(t));pb.keyframe_insert(prop,frame=f,group=name)
for k,key in enumerate(keys):
 for f in range(1,242,6):
  t=(f-1)/24 if f<241 else 0
  key.value=waves(t,k);key.keyframe_insert('value',frame=f,group='Traveling lobes')
# No old skeletal gestures, no synchronous whole-body squash. The reference
# can drift gently without face separation changing in model space.
def a(t):return 2*pi*t/10
animate_bone('Body','location',lambda t:(.061*sin(a(t)),.042*sin(2*a(t)+.8),.024*sin(a(t)+.4)))
animate_bone('Body','scale',lambda t:(1,1,1))
animate_bone('Body','rotation_euler',lambda t:(0,0,0))
for idx,n in enumerate(('Hand.L','Hand.R')):
 sign=1 if idx==0 else -1
 animate_bone(n,'location',lambda t:(sign*(.084+.042*sin(2*a(t)+.7+idx)),.064*cos(a(t)+.7+idx*1.7),.047*sin(2*a(t)+idx*1.3)))
 animate_bone(n,'scale',lambda t:(1+.045*sin(2*a(t)+idx*1.4),1-.055*sin(2*a(t)+idx*1.4),1+.021*cos(a(t)+idx*1.3)))
 animate_bone(n,'rotation_euler',lambda t:(0,0,.07*sin(a(t)+idx*1.8)))
animate_bone('Halo','location',lambda t:(.105*sin(a(t)+.78),.04*sin(2*a(t)+2.15),.044*cos(a(t)+.7)))
animate_bone('Halo','rotation_euler',lambda t:(.029*sin(a(t)+.6),0,.05*sin(a(t)+1.58)))
leaf=rig.pose.bones['Halo.Tip']
for f in range(1,242,6):
 t=(f-1)/24 if f<241 else 0
 leaf['lag']=float(.11+.25*(1+sin(2*a(t)+1.3))+.15*sin(a(t)+.7))
 leaf.keyframe_insert(data_path='["lag"]',frame=f,group='Halo.Tip')
rig.animation_data.action.name='Cloud drift • face steady, hands and halo independent'
body.data.shape_keys.animation_data.action.name='Cloud advection • nine local volumes, 10s'
s.timeline_markers.clear()
for f,l in [(1,'Drift start'),(61,'Billow travels'),(121,'Volume exchange'),(181,'Billow return'),(241,'Loop')]:s.timeline_markers.new(l,frame=f)
s['motion_variant']='Amorphous traveling lobe billows; visual Blender proof only.'
s.frame_set(1)
bpy.context.preferences.filepaths.save_version=0
target=os.path.join(here,'cloud-amorphous.blend')
bpy.ops.wm.save_as_mainfile(filepath=target,compress=True)
# Validate all 241 poses via actual evaluated mesh vertices.
def verts(o,dg):
 e=o.evaluated_get(dg);return [e.matrix_world @ v.co for v in e.data.vertices]
def proj(v):return [world_to_camera_view(s,s.camera,k) for k in v]
def bb(v,i):return min(k[i] for k in v),max(k[i] for k in v)
halo=[o for o in s.objects if o.name.startswith('Halo vapor')]
l=bpy.data.objects['Floating hand L'];r=bpy.data.objects['Floating hand R']
el=bpy.data.objects['Eye white L'];er=bpy.data.objects['Eye white R']
samples=[];separation=[];weights=[];mesh_ends=[];max_shape=0
for f in range(1,242):
 s.frame_set(f);dg=bpy.context.evaluated_depsgraph_get()
 bw=verts(body,dg);b,p,q,h=map(proj,(bw,verts(l,dg),verts(r,dg),[v for o in halo for v in verts(o,dg)]))
 separation.append(( (bb(p,0)[0]-bb(b,0)[1])*240,(bb(b,0)[0]-bb(q,0)[1])*240,(bb(h,1)[0]-bb(b,1)[1])*135 ))
 separation_here=(el.evaluated_get(dg).matrix_world.translation-er.evaluated_get(dg).matrix_world.translation).length
 weights.append([k.value for k in keys]);max_shape=max(max_shape,max((a.co-b.co).length for a,b in zip(body.evaluated_get(dg).data.vertices,body.data.vertices)))
 if f in {1,241}:mesh_ends.append(bw)
 if f in {1,31,61,91,121,151,181,211,241}:
  samples.append({'frame':f,'body_bbox_px':[(b-a)*j for (a,b),j in zip((bb(b,0),bb(b,1)),(240,135))], 'projected_gaps_px':separation[-1],'max_positive_lobe':lobes[max(range(len(keys)),key=lambda i:weights[-1][i])][0], 'eye_center_distance':separation_here})
minima=[min(j[i] for j in separation) for i in range(3)]
assert all(g>=2 for g in minima), minima
assert max((p-q).length for p,q in zip(*mesh_ends))<1.e-5
assert max_shape>.07
assert max(k['eye_center_distance'] for k in samples)-min(k['eye_center_distance'] for k in samples)<1.e-5
assert hashlib.sha256(open(original,'rb').read()).hexdigest()==orig_hash
with open(os.path.join(here,'amorphous-validation.json'),'w') as f:
 json.dump({'original_sha256':orig_hash,'variant_sha256':hashlib.sha256(open(target,'rb').read()).hexdigest(),'gaps_px_min_left_right_halo':minima,'frames_validated':len(separation),'max_local_vertex_deformation':max_shape,'samples':samples,'phase_weights_stride_6':weights[::6],'regions':[x[0] for x in lobes],'note':'Blender camera-space bounding boxes, not native raster proof or hardware timing.'},f,indent=2)
s.cycles.samples=64
s.render.resolution_x=240;s.render.resolution_y=135
frames=os.path.join(here,'wave-frames');os.makedirs(frames,exist_ok=True)
for i,f in enumerate(range(1,241,6)):
 s.frame_set(f);s.render.filepath=os.path.join(frames,'frame-%03d.png'%i);bpy.ops.render.render(write_still=True)
