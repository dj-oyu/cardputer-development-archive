"""Editable slow shape change from drift and advection, without an expansion pulse."""
import bpy,os,sys,json,math,hashlib
from math import exp,sin,cos,pi
from mathutils import Vector
from mathutils.geometry import convex_hull_2d
from mathutils.bvhtree import BVHTree
from bpy_extras.object_utils import world_to_camera_view
p=os.path.dirname(os.path.realpath(__file__))
args=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
candidates=[os.path.join(p,'..',d,'cloud-idle-drift.blend') for d in ('idle-wind-01','cloud-character-idle-drift-01')]
src=os.path.abspath(args[0]) if args else next(d for d in candidates if os.path.isfile(d))
digest=lambda x:hashlib.sha256(open(x,'rb').read()).hexdigest()
srcsha=digest(src);bpy.ops.wm.open_mainfile(filepath=src)
s=bpy.context.scene; rig=bpy.data.objects['Cloud_Rig']; body=bpy.data.objects['Cloud body']
sk=body.data.shape_keys;sk.animation_data_clear();rig.animation_data_clear()
for q in list(sk.key_blocks)[1:]:body.shape_key_remove(q)
basis=sk.key_blocks[0]
def smooth(v): v=max(0,min(1,v));return v*v*(3-2*v)
def face(o):return smooth((-o.y-.43)/.32)*smooth((.94-abs(o.x))/.23)*smooth((o.z+.24)/.27)*smooth((.95-o.z)/.27)
# Two large contour regions must trade before any third moves; no channel is a
# freely wandering internal mass. The tangential term advects the cloud edge.
fields=[
 ('West edge loosens / east skirt gathers',(-1.,.15),(1.03,-.59),.190,.239),
 ('East shoulder loosens / lower skirt gathers',(1.00,.37),(-.49,-1.15),.204,.204),
 ('Base loosens / left shoulder gathers',(-.40,-1.03),(-.87,.43),.155,.202)]
keys=[]
def gaussian(o,c):return exp(-((o.x-c[0])**2/.53+(o.z-c[1])**2/.61+o.y*o.y/.92))
for label,l,r,a,b in fields:
 skey=body.shape_key_add(name=label);skey.slider_min=0;skey.slider_max=1;keys.append(skey)
 for i,v in enumerate(basis.data):
  o=v.co
  radial=Vector((o.x,.72*o.y,.82*o.z)).normalized()
  g=gaussian(o,l);h=gaussian(o,r)
  move=radial*(b*h-a*g)+Vector((.013,-.009,.024))*(g-h)*1.3
  skey.data[i].co=o+(1-face(o))*move
area=body.shape_key_add(name='Contour area trim • not a motion driver')
area.slider_min=-1;area.slider_max=1
for i,v in enumerate(basis.data):
 o=v.co;area.data[i].co=o+(1-face(o))*Vector((o.x,0,o.z))*.094
# Sequential, unequally spaced, partially overlapping ease poses.
swells=[(0,(0.,0.,0.)),(.65,(0.,0.,0.)),(2.30,(.88,0.,0.)),(3.80,(1.,.18,0.)),(5.10,(.56,.88,.14)),(6.35,(.18,1.,.32)),(7.65,(0.,.49,.87)),(8.80,(0.,.09,.55)),(10,(0.,0.,0.))]
def field_at(t):
 for (a,x),(b,y) in zip(swells,swells[1:]):
  if a<=t<=b:
   v=smooth((t-a)/(b-a));return [r+(q-r)*v for r,q in zip(x,y)]
 return (0.,0.,0.)
def pose(t):
 u=2*pi*t/10
 # Residual drift smaller than the spatial movement of form.
 rig.pose.bones['Body'].location=(.033*sin(u)+.008*sin(2*u),.017*sin(u+.46),0)
 rig.pose.bones['Body'].rotation_euler=(0,0,0);rig.pose.bones['Body'].scale=(1,1,1)
 for i,n in enumerate(('Hand.L','Hand.R')):
  r=rig.pose.bones[n];r.location=((1 if i==0 else -1)*(.284+.011*sin(u+2*i)),.027*sin(u+.60+i*1.0),.009*sin(2*u+.83*i))
  r.rotation_euler=(0,0,0);r.scale=(1,1,1)
 tip=rig.pose.bones['Halo'];tip.location=(.018*sin(u-.81),.132+.026*sin(u-.56),0);tip.rotation_euler=(.011*sin(u-.7),0,0)
 rig.pose.bones['Halo.Tip']['lag']=float(.19+.048*sin(u-1.5))
def world(o,dg):
 q=o.evaluated_get(dg);return [q.matrix_world@x.co for x in q.data.vertices]
def proj(vs):return [world_to_camera_view(s,s.camera,k) for k in vs]
def hull(vs):
 px=[Vector((v.x*240,v.y*135)) for v in vs]; ids=convex_hull_2d(px)
 return abs(sum(px[i].x*px[j].y-px[j].x*px[i].y for i,j in zip(ids,ids[1:]+ids[:1])))/2
def evaluated():
 bpy.context.view_layer.update(); dg=bpy.context.evaluated_depsgraph_get()
 return proj(world(body,dg))
for k in (*keys,area):k.value=0
pose(0)
goal=hull(evaluated())
trims=[]
last=None
# Solve only a small symmetric trim to preserve projected outward silhouette area;
# movement always comes from the hand-authored opposing fields.
for f in range(1,242,3):
 t=(f-1)/24;pose(t)
 for k,val in zip(keys,field_at(t)):k.value=val
 area.value=0
 raw=hull(evaluated())
 if abs(raw-goal)>.01:
  area.value=.10; slope=(hull(evaluated())-raw)/.10; area.value=max(-.38,min(.38,(goal-raw)/slope))
 trims.append(float(area.value))
 for k in (*keys,area):k.keyframe_insert('value',frame=f,group='Contour transport')
 for n in ('Body','Hand.L','Hand.R','Halo'):
  q=rig.pose.bones[n]
  for field in ('location','rotation_euler','scale'):q.keyframe_insert(field,frame=f,group=n)
 rig.pose.bones['Halo.Tip'].keyframe_insert('["lag"]',frame=f,group='Halo.Tip')
rig.animation_data.action.name='Idle drift • independently floating hands and iridescence'
sk.animation_data.action.name='Idle drift • opposite edges exchange visible shape'
for ob in (rig,sk):
 for fc in ob.animation_data.action.fcurves:
  for k in fc.keyframe_points:k.interpolation='LINEAR'
s.frame_start=1;s.frame_end=241;s.timeline_markers.clear()
for f,n in [(1,'Drift'),(93,'West disperses / east gathers'),(153,'East diffuses / base gathers'),(184,'Base loosens / left flank gathers'),(241,'Seam')]:s.timeline_markers.new(n,frame=f)
s['motion_variant']='Idle cloud advection • no breath or spring cycle'
s.frame_set(1);bpy.context.preferences.filepaths.save_version=0
dest=os.path.join(p,'cloud-idle-wind-02.blend');bpy.ops.wm.save_as_mainfile(filepath=dest,compress=True)
hand=[bpy.data.objects['Floating hand '+ k] for k in 'LR']
eye=[bpy.data.objects['Eye white '+ k] for k in 'LR']
halos=[q for q in s.objects if q.name.startswith('Halo vapor')]
def bb(v,d):
 return min(x[d] for x in v),max(x[d] for x in v)
def body_mask(dg):
 # Integer pixel-centres of the same orthographic camera at actual resolution;
 # ray test only the body, omits lighting/shadow and facial overlays.
 z=body.evaluated_get(dg)
 poly=[tuple(m.vertices) for m in z.data.polygons]
 tree=BVHTree.FromPolygons([z.matrix_world@v.co for v in z.data.vertices],poly)
 cam=s.camera; c=cam.matrix_world;scale=cam.data.ortho_scale;fx=scale;fy=scale*135/240
 v=c.to_quaternion() @ Vector((0,0,-1))
 rows=[]
 for y in range(135):
  line=[]
  for x in range(240):
   ray=c@Vector((((x+.5)/240-.5)*fx,((y+.5)/135-.5)*fy,0))
   line.append(tree.ray_cast(ray,v,25)[0] is not None)
  rows.append(line)
 return rows
notes=[];ends=[];masks={};refmask=None
for f in range(1,242):
 s.frame_set(f);dg=bpy.context.evaluated_depsgraph_get()
 bw=world(body,dg)
 if f in (1,241):ends.append([v for ob in (body,*hand,*eye,*halos) for v in world(ob,dg)])
 a,l,r,h=map(proj,(bw,world(hand[0],dg),world(hand[1],dg),[v for q in halos for v in world(q,dg)]))
 g=[(bb(l,0)[0]-bb(a,0)[1])*240,(bb(a,0)[0]-bb(r,0)[1])*240,(bb(h,1)[0]-bb(a,1)[1])*135]
 e=[q.evaluated_get(dg).matrix_world.translation for q in eye]
 notes.append(dict(frame=f,t=(f-1)/24,hull_area_px=hull(a),width_px=(bb(a,0)[1]-bb(a,0)[0])*240,eye=(e[0]-e[1]).length,gaps=g,fields=[float(k.value) for k in keys],trim=float(area.value)))
 if f in (1,57,93,123,153,184,211,241):
  mask=body_mask(dg);refmask=mask if refmask is None else refmask
  count=sum(sum(row) for row in mask);diff=sum(x!=y for u,v in zip(mask,refmask) for x,y in zip(u,v))
  masks[f]={'pixel_area':count,'changed_vs_start':diff}
  with open(os.path.join(p,'mask-%03d.pgm'%f),'wb') as q:
   q.write(b'P5\n240 135\n255\n');q.write(bytes(255 if x else 0 for r in reversed(mask) for x in r))
mins=[min(r['gaps'][i] for r in notes) for i in range(3)]
seam=max((a-b).length for a,b in zip(*ends))
raster=100*(max(m['pixel_area'] for m in masks.values())-min(m['pixel_area'] for m in masks.values()))/masks[1]['pixel_area']
hullvar=100*(max(r['hull_area_px'] for r in notes)-min(r['hull_area_px'] for r in notes))/goal
changed=max(m['changed_vs_start'] for m in masks.values())
assert raster<3.5,(raster,masks)
assert hullvar<2,(hullvar,trims)
assert changed>500,(changed,masks)
assert min(mins)>2,mins
assert seam<1e-6 and max(r['eye'] for r in notes)-min(r['eye'] for r in notes)<1e-5
assert digest(src)==srcsha
with open(os.path.join(p,'idle-wind-02-validation.json'),'w') as q:json.dump(dict(source_sha256=srcsha,variant_sha256=digest(dest),frames=len(notes),seam_world_error=seam,projected_hull_range_percent=hullvar,actual_pixel_silhouette_range_percent=raster,max_changed_pixels=changed,minimum_gaps_px=mins,masks=masks,track=notes),q,indent=1)
s.cycles.samples=44;s.render.resolution_x=240;s.render.resolution_y=135
folder=os.path.join(p,'frames');os.makedirs(folder,exist_ok=True)
for i,f in enumerate(range(1,241,3)):
 s.frame_set(f);s.render.filepath=os.path.join(folder,'frame-%03d.png'%i);bpy.ops.render.render(write_still=True)
