"""Create an editable linked three-beat cloud clip from the frozen 04 asset."""
import bpy,json,os,sys,math,hashlib
from bpy_extras.object_utils import world_to_camera_view
from math import sin,pi
folder=os.path.dirname(os.path.realpath(__file__))
args=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
inputs=[os.path.join(folder,'..',d,'cloud-variable-center.blend') for d in ('motion-study-04','cloud-character-study-04-retimed')]
src=os.path.abspath(args[0]) if args else next(x for x in inputs if os.path.isfile(x))
digest=lambda p:hashlib.sha256(open(p,'rb').read()).hexdigest()
sha=digest(src);bpy.ops.wm.open_mainfile(filepath=src)
s=bpy.context.scene;rig=bpy.data.objects['Cloud_Rig'];body=bpy.data.objects['Cloud body'];sk=body.data.shape_keys
rig.animation_data_clear();sk.animation_data_clear()
lobes=list(sk.key_blocks)[1:10]; modes=list(sk.key_blocks)[10:13]
assert len(modes)==3
# In seconds, positive loads the spring, negative overshoots. The next
# spring starts to squeeze during the previous rebound, without clearing it.
events=[
 [(0,0),(.13,.14),(.31,.86),(.40,.46),(.53,-.79),(.61,-.64),(.74,-.18),(.83,0)],
 [(.47,0),(.57,.16),(.68,.45),(.81,.83),(.90,.47),(1.04,-.74),(1.13,-.60),(1.28,-.18),(1.39,0)],
 [(1.03,0),(1.15,.15),(1.31,.43),(1.49,.94),(1.59,.55),(1.77,-.87),(1.90,-.59),(2.10,.24),(2.25,.13),(2.43,-.10),(2.68,0)],
]
def pulse(t,j):
 tbl=events[j]
 for (a,v),(b,w) in zip(tbl,tbl[1:]):
  if a<=t<=b:
   p=(t-a)/(b-a);return v+(w-v)*p*p*(3-2*p)
 return 0.
def key(n,prop,f,v):
 b=rig.pose.bones[n];setattr(b,prop,v);b.keyframe_insert(prop,frame=f,group=n)
for f in range(1,73):
 t=(f-1)/24.
 vals=[pulse(t,j) for j in range(3)]
 for k,v in zip(modes,vals):k.value=v;k.keyframe_insert('value',frame=f,group='Linked pops')
 for i,k in enumerate(lobes):
  v=0.
  for j in range(3):
   lag=.026+.012*((i if j!=1 else 8-i)%9)
   p=pulse(t-lag,j);q=pulse(t-lag-.11,j)
   polarity=[-.75,-.88,-.30,.3,.65,-.37,-.58,.28,.54][(i+2*j)%9]
   v+=polarity*(p-.68*q)+.16*(p-pulse(t-lag-.22,j))
  k.value=max(-1,min(1,v));k.keyframe_insert('value',frame=f,group='Travel lag')
 v=[pulse(t-.03,j) for j in range(3)]
 dx=-.14*v[0]+.17*v[1]-.13*v[2]
 dz=.076*v[0]-.056*v[1]-.055*v[2]
 key('Body','location',f,(dx,dz,0.));key('Body','rotation_euler',f,(0.,0.,0.));key('Body','scale',f,(1.,1.,1.))
 for i,n in enumerate(('Hand.L','Hand.R')):
  sg=1 if i==0 else -1
  h=sum(pulse(t-.10-.036*i,j) for j in range(3))
  key(n,'location',f,(sg*(.37+.032*i-.045*h)+.39*dx,.26*dz,-.03*h))
  key(n,'scale',f,(1.-.044*h,1.+.048*h,1.+.02*h))
  key(n,'rotation_euler',f,(0.,0.,.036*h))
 h=sum(pulse(t-.14,j) for j in range(3));hx=-.14*pulse(t-.15,0)+.17*pulse(t-.15,1)-.13*pulse(t-.15,2)
 key('Halo','location',f,(.42*hx,.16+.028*h,0.));key('Halo','rotation_euler',f,(.016*h,0.,.026*h))
 tip=rig.pose.bones['Halo.Tip'];tip['lag']=float(.2+.12*sum(pulse(t-.19,j) for j in range(3)))
 tip.keyframe_insert('["lag"]',frame=f,group='Halo.Tip')
for obj,label in [(rig,'Pop chain • secondary lag'),(sk,'Pop chain • three overlapping springs')]:
 obj.animation_data.action.name=label
 for fc in obj.animation_data.action.fcurves:
  for k in fc.keyframe_points:k.interpolation='LINEAR'
s.frame_start=1;s.frame_end=72;s.render.fps=24
s.timeline_markers.clear()
for t,label in [(0,'Ready'),(.31,'Load left-up'),(.53,'Pop I'),(.81,'Load right-down'),(1.04,'Pop II'),(1.49,'Load left-down'),(1.77,'Pop III'),(2.7,'Settled')]:
 s.timeline_markers.new(label,frame=round(t*24)+1)
s['motion_variant']='Three linked elastic pops, settled only after the third'
def points(o,dg):
 e=o.evaluated_get(dg);return [world_to_camera_view(s,s.camera,e.matrix_world@v.co) for v in e.data.vertices]
def bounds(p,i):return min(v[i] for v in p),max(v[i] for v in p)
lh,rh=[bpy.data.objects['Floating hand '+k] for k in 'LR']
eyes=[bpy.data.objects['Eye white '+k] for k in 'LR']
halo=[o for o in s.objects if o.name.startswith('Halo vapor')]
timeline=[]
for f in range(1,73):
 s.frame_set(f);dg=bpy.context.evaluated_depsgraph_get()
 b,l,r=[points(o,dg) for o in (body,lh,rh)];h=[v for o in halo for v in points(o,dg)]
 b0,b1=bounds(b,0);z0,z1=bounds(b,1)
 gap=[(bounds(l,0)[0]-b1)*240,(b0-bounds(r,0)[1])*240,(bounds(h,1)[0]-z1)*135]
 pos=[o.evaluated_get(dg).matrix_world.translation for o in eyes]
 timeline.append(dict(frame=f,seconds=(f-1)/24, width_px=(b1-b0)*240,height_px=(z1-z0)*135,center_px=[(b1+b0)*120,(z1+z0)*67.5], gaps_px=gap,eye_spacing=(pos[0]-pos[1]).length, springs=[k.value for k in modes], body_bounds_px=[b0*240,b1*240,z0*135,z1*135]))
gaps=[min(r['gaps_px'][i] for r in timeline) for i in range(3)]
events_proof=[]
for j,(l,r) in enumerate([(.18,.66),(.67,1.21),(1.29,2.01)]):
 subset=[x for x in timeline if l<=x['seconds']<=r]
 position=next(i for i,x in enumerate(subset) if x['frame']==min(subset,key=lambda x:x['width_px'])['frame'])
 trough=subset[position]; rebound=max(subset[position:],key=lambda x:x['width_px'])
 events_proof.append(dict(beat=j+1,compression_s=trough['seconds'],rebound_s=rebound['seconds'],compression_width_px=trough['width_px'],rebound_width_px=rebound['width_px']))
mincam_spring=min(max(abs(x) for x in r['springs']) for r in timeline if .54<=r['seconds']<=.83 or 1.04<=r['seconds']<=1.50)
overlap=[sum(abs(r['springs'][j])>.07 and abs(r['springs'][j+1])>.07 for r in timeline) for j in (0,1)]
print('QA',gaps,events_proof,mincam_spring,overlap,flush=True)
assert min(gaps)>=2.,gaps
assert max(r['eye_spacing'] for r in timeline)-min(r['eye_spacing'] for r in timeline)<1e-5
assert mincam_spring>.09 and min(overlap)>2,(mincam_spring,overlap)
assert all(q['rebound_width_px']-q['compression_width_px']>9 for q in events_proof),events_proof
assert max(abs(a-b) for a,b in zip(timeline[0]['body_bounds_px'],timeline[-1]['body_bounds_px']))<.01
assert digest(src)==sha
s.frame_set(1);s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100
s.render.image_settings.file_format='PNG'
bpy.context.preferences.filepaths.save_version=0
dst=os.path.join(folder,'cloud-pop-chain.blend');bpy.ops.wm.save_as_mainfile(filepath=dst,compress=True)
with open(os.path.join(folder,'pop-chain-validation.json'),'w') as out:
 json.dump(dict(source_sha256=sha, model_sha256=digest(dst), frames=72,fps=24,gaps_px_min=gaps,minimum_between_beats_max_spring=mincam_spring,adjacent_nontrivial_overlap_frames=overlap,events=events_proof,timeline=timeline),out,indent=1)
if '--no-render' not in args:
 s.cycles.samples=28
 path=os.path.join(folder,'frames');os.makedirs(path,exist_ok=True)
 for k,f in enumerate(range(1,73,2)):
  s.frame_set(f);s.render.filepath=os.path.join(path,'frame-%03d.png'%k);bpy.ops.render.render(write_still=True)
