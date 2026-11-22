"""Uneven 12-second cloud performance: varying events and off-axis deformation."""
import bpy,os,sys,math,json,hashlib
from mathutils import Vector
from math import sin,cos,pi,exp
from bpy_extras.object_utils import world_to_camera_view
folder=os.path.dirname(os.path.realpath(__file__))
args=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
possible=[os.path.join(folder,'..',d,'cloud-elastic.blend') for d in ('motion-study-03','cloud-character-study-03')]
src=os.path.abspath(args[0]) if args else next(p for p in possible if os.path.isfile(p))
digest=lambda p:hashlib.sha256(open(p,'rb').read()).hexdigest()
ref=digest(src);bpy.ops.wm.open_mainfile(filepath=src)
s=bpy.context.scene;rig=bpy.data.objects['Cloud_Rig'];body=bpy.data.objects['Cloud body'];sk=body.data.shape_keys
rig.animation_data_clear();sk.animation_data_clear()
basis=sk.key_blocks[0];lobes=list(sk.key_blocks)[1:10]
for k in list(sk.key_blocks)[1:]:k.value=0
for k in list(sk.key_blocks)[10:]:body.shape_key_remove(k)
# (name, start s, action time multiplier, amplitude, direction angle, pivot XZ, body shift XZ)
events=[
 ('Upper left', .47,.85,.85,-.31,(-.36,.47),(-.23,.12)),
 ('Lower right',3.57,1.17,.73,.32,(.44,-.43),(.25,-.05)),
 ('Lower left',8.72,.97,.94,.09,(-.34,-.32),(-.19,-.10)),
]
def sm(t):t=max(0,min(1,t));return t*t*(3-2*t)
def face(v):return sm((-v.y-.43)/.32)*sm((.94-abs(v.x))/.23)*sm((v.z+.24)/.27)*sm((.95-v.z)/.27)
modes=[]
for name,start,m,amp,angle,(px,pz),_ in events:
 axis=Vector((cos(angle),0,sin(angle)));cross=Vector((-sin(angle),0,cos(angle)))
 pivot=Vector((px,0,pz));hit=body.shape_key_add(name='Collective spring • '+name);hit.slider_min=-1;hit.slider_max=1;modes.append(hit)
 for i,v in enumerate(basis.data):
  p=v.co
  rail=(p-pivot);d=-.23*rail.dot(axis)*axis+.12*rail.dot(cross)*cross
  # local response gain near center of force alters which side visibly caves
  sx,sz=p.x-px,p.z-pz
  g=.85+.38*exp(-(sx*sx+sz*sz)/1.13)
  d+=Vector((0,.037*p.y,0));hit.data[i].co=p+(1-face(p))*d*g
def key(b,prop,f,val):
 a=rig.pose.bones[b];setattr(a,prop,val);a.keyframe_insert(prop,frame=f,group=b)
patterns=[
 [(0,0),(.18,.25),(.45,.83),(.62,1.),(.79,.48),(1.07,-.72),(1.24,-.53),(1.48,.29),(1.76,.12),(1.96,-.065),(2.26,0)],
 [(0,0),(.27,.21),(.55,.74),(.74,1.),(.93,.64),(1.14,-.65),(1.40,-.49),(1.58,.22),(1.87,.18),(2.08,-.05),(2.30,0)],
 [(0,0),(.14,.32),(.30,.73),(.55,1.),(.68,.6),(.91,-.78),(1.12,-.64),(1.37,.25),(1.69,.15),(1.93,-.09),(2.12,0)]
]
def pulse(t,j,delay=0):
 _,start,scale,a,*_=events[j];x=(t-start-delay)/scale
 for (t0,v),(t1,w) in zip(patterns[j],patterns[j][1:]):
  if t0<=x<=t1:return a*(v+(w-v)*sm((x-t0)/(t1-t0)))
 return 0.
for f in range(1,290,2):
 t=(f-1)/24.; u=(2*pi*t/12)
 vals=[pulse(t,j) for j in range(3)]
 for j,k in enumerate(modes):k.value=vals[j];k.keyframe_insert('value',frame=f,group='Variable-pivot springs')
 for idx,k in enumerate(lobes):
  v=0.
  for j in range(3):
   order=(idx if j!=1 else 8-idx)
   q=pulse(t,j,.030+.041*order)
   r=pulse(t,j,.16+.051*order)
   polarity=[-.79,-.94,-.38,.26,.85,-.44,-.74,.26,.62][(idx+(j*2))%9]
   v+=polarity*(q-.64*r)+.26*(q-pulse(t,j,.32+.039*order))
  k.value=max(-1,min(v,1));k.keyframe_insert('value',frame=f,group='Lagged local responses')
 # Between events a small slow curve avoids locked centre; main centre movement
 # comes from each pressure impulse and its reversed, delayed release.
 drift=(.042*sin(u)+.023*sin(3*u),.025*sin(2*u),0)
 dx=sum(pulse(t,j,.035)*ev[-1][0] for j,ev in enumerate(events))
 dz=sum(pulse(t,j,.035)*ev[-1][1] for j,ev in enumerate(events))
 key('Body','location',f,(drift[0]+dx,drift[1]+dz,0.))
 key('Body','rotation_euler',f,(0.,0.,0.));key('Body','scale',f,(1.,1.,1.))
 for i,n in enumerate(('Hand.L','Hand.R')):
  sign=1 if i==0 else -1;w=sum(pulse(t,j,.17+i*.062) for j in range(3))
  key(n,'location',f,(sign*(.28+(.035 if i==0 else 0)-.048*w)+.38*dx,.04*sin(u+i*1.2)+.36*dz,-.02*w))
  key(n,'scale',f,(1.-.035*w,1.+.045*w,1.+.02*w))
  key(n,'rotation_euler',f,(0.,0.,.035*w))
 h=sum(pulse(t,j,.25) for j in range(3)); hx=sum(pulse(t,j,.24)*ev[-1][0] for j,ev in enumerate(events))
 key('Halo','location',f,(.47*hx,.15+.027*h+.025*sin(u+.53),0.))
 key('Halo','rotation_euler',f,(.017*h,0.,.034*h))
 tip=rig.pose.bones['Halo.Tip'];tip['lag']=float(.20+.17*sum(pulse(t,j,.33) for j in range(3)))
 tip.keyframe_insert('["lag"]',frame=f,group='Halo.Tip')
for obj,name in ((rig,'04 Drift and collective response'),(sk,'04 Three elastic beats with varying pivots')):
 obj.animation_data.action.name=name
 for fc in obj.animation_data.action.fcurves:
  for k in fc.keyframe_points:k.interpolation='LINEAR'
s.frame_start=1;s.frame_end=289
s.timeline_markers.clear()
for name,t,*_ in events:s.timeline_markers.new('Pressure '+name,frame=round(1+t*24))
s.timeline_markers.new('Seam',frame=289);s['motion_variant']='04 • three off-axis elastic events with unequal phases'
s.frame_set(1);bpy.context.preferences.filepaths.save_version=0
dest=os.path.join(folder,'cloud-variable-center.blend');bpy.ops.wm.save_as_mainfile(filepath=dest,compress=True)
def v_world(o,dg):
 e=o.evaluated_get(dg);return [e.matrix_world@v.co for v in e.data.vertices]
def project(v):return [world_to_camera_view(s,s.camera,x) for x in v]
def bb(v,i):return min(x[i] for x in v),max(x[i] for x in v)
lh,rh=[bpy.data.objects['Floating hand '+ k] for k in 'LR']
eyes=[bpy.data.objects['Eye white '+ k] for k in 'LR']
halo=[o for o in s.objects if o.name.startswith('Halo vapor')]
notes=[];endpoints=[]
for f in range(1,290):
 s.frame_set(f);dg=bpy.context.evaluated_depsgraph_get()
 bw=v_world(body,dg)
 if f in (1,289):
  endpoints.append([p for o in [body,lh,rh,*halo,*eyes] for p in v_world(o,dg)])
 b,l,r,h=map(project,(bw,v_world(lh,dg),v_world(rh,dg),[v for o in halo for v in v_world(o,dg)]))
 b0,b1=bb(b,0);z0,z1=bb(b,1)
 gap=[(bb(l,0)[0]-b1)*240,(b0-bb(r,0)[1])*240,(bb(h,1)[0]-z1)*135]
 pos=[o.evaluated_get(dg).matrix_world.translation for o in eyes]
 notes.append(dict(frame=f,seconds=(f-1)/24,body_width_px=(b1-b0)*240,body_height_px=(z1-z0)*135,bbox_center_px=[120*(b1+b0),67.5*(z1+z0)],face_center_px=[v*k for v,k in zip(project([(pos[0]+pos[1])/2])[0][:2],(240,135))],gaps_px=gap,eye_spacing=(pos[0]-pos[1]).length,springs=[k.value for k in modes]))
minimum=[min(row['gaps_px'][i] for row in notes) for i in range(3)]
assert min(minimum)>=2,minimum
error=max((p-q).length for p,q in zip(*endpoints))
assert error<1e-5,error
assert max(v['eye_spacing'] for v in notes)-min(v['eye_spacing'] for v in notes)<1e-5
summed=[]
for j,(n,ta,d,amp,ang,pivot,drift) in enumerate(events):
 subset=[v for v in notes if ta<=v['seconds']<=ta+2.5*d]
 peak=min(subset,key=lambda v:v['body_width_px']);rebound=max(subset,key=lambda v:v['body_width_px'])
 rest=notes[max(0,round(ta*24)-1)]
 assert peak['body_width_px'] < rest['body_width_px']-5
 assert rebound['body_width_px'] > rest['body_width_px']+4
 assert peak['seconds'] < rebound['seconds']
 summed.append(dict(name=n,onset=ta,time_multiplier=d,amplitude=amp,axis_deg=math.degrees(ang),pivot_model_xz=pivot,pressure_pose=peak,rebound_pose=rebound))
assert digest(src)==ref
with open(os.path.join(folder,'variable-center-validation.json'),'w') as o:json.dump(dict(baseline_sha256=ref,variant_sha256=digest(dest),frames=len(notes),seam_max_world_error=error,min_projected_gaps_px=minimum,events=summed,timeline=notes),o,indent=1)
s.render.resolution_x=240;s.render.resolution_y=135;s.cycles.samples=40
out=os.path.join(folder,'frames');os.makedirs(out,exist_ok=True)
for i,f in enumerate(range(1,289,3)):
 s.frame_set(f);s.render.filepath=os.path.join(out,'frame-%03d.png'%i);bpy.ops.render.render(write_still=True)
