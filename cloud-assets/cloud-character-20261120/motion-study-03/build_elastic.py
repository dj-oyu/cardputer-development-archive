"""Blender: a coherent elastic body with lagged redistribution along its edge."""
import bpy, os, math, json, hashlib, sys
from mathutils import Vector
from bpy_extras.object_utils import world_to_camera_view
from math import pi,sin,cos,exp
folder=os.path.dirname(os.path.realpath(__file__))
argv=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
local=os.path.join(folder,'..','cloud-character-amorphous','cloud-amorphous.blend')
archive=os.path.join(folder,'..','motion-study-02','cloud-amorphous.blend')
src=os.path.abspath(argv[0]) if argv else (archive if os.path.isfile(archive) else local)
digest=lambda p:hashlib.sha256(open(p,'rb').read()).hexdigest()
src_hash=digest(src)
bpy.ops.wm.open_mainfile(filepath=src)
s=bpy.context.scene; rig=bpy.data.objects['Cloud_Rig']; body=bpy.data.objects['Cloud body']
old=body.data.shape_keys;old.animation_data_clear(); rig.animation_data_clear()
keys=list(old.key_blocks)[1:]
assert len(keys)==9
basis=old.key_blocks[0]
for k in keys:k.value=0
def clamp(x):return min(1,max(0,x))
def sm(v):v=clamp(v);return v*v*(3-2*v)
def face_keep(v):return sm((-v.y-.43)/.32)*sm((.94-abs(v.x))/.23)*sm((v.z+.24)/.27)*sm((.95-v.z)/.27)
collective=body.shape_key_add(name='Collective spring • compress or overshoot')
collective.slider_min=-1;collective.slider_max=1
# Blend 100% protection for face geometry: the face land stays as stiff as its features.
for j,v in enumerate(body.data.vertices):
 p=basis.data[j].co; pin=1-face_keep(p)
 collective.data[j].co=p+Vector((-.21*p.x,.052*p.y,.113*p.z))*pin
curve=[(.00,0),(.53,0),(.78,.18),(1.10,.72),(1.33,1.),(1.52,.54),(1.81,-.72),(1.96,-.59),(2.22,.30),(2.40,.26),(2.72,-.13),(3.02,.045),(3.35,0),(6.,0)]
def E(t):
 for (a,x),(b,y) in zip(curve,curve[1:]):
  if a<=t<=b:return x+(y-x)*sm((t-a)/(b-a))
 return 0.
def lobe(t,i):
 # Same impulse for all: pressure arrives first at lower left and passes
 # across the base to upper right. Residual opposite sign allows a pressed
 # region to persist beside an already released region, before all settle.
 order=[1,0,2,3,4,5,6,7,8][i]
 delay=.037*order
 primary=E(t-.06-delay)
 delayed=E(t-.19-.054*order)
 polarity=[-.80,-.96,-.38,.27,.83,-.44,-.74,.26,.62][i]
 return max(-1,min(1,polarity*(primary-.50*delayed) +.28*(primary-E(t-.31-.054*order))))
def pose(name,prop,f,value):
 p=rig.pose.bones[name];setattr(p,prop,value);p.keyframe_insert(data_path=prop,frame=f,group=name)
for f in range(1,146,2):
 t=(f-1)/24; e=E(t)
 collective.value=e;collective.keyframe_insert('value',frame=f,group='Collective')
 for i,k in enumerate(keys):
  k.value=lobe(t,i);k.keyframe_insert('value',frame=f,group='Lagged regions')
 pose('Body','location',f,(.100*E(t-.08)-.038*E(t-.38),-.035*e,0))
 pose('Body','scale',f,(1.,1.,1.));pose('Body','rotation_euler',f,(0.,0.,0.))
 for j,n in enumerate(('Hand.L','Hand.R')):
  sign=1 if j==0 else -1; q=E(t-.24-j*.05)
  pose(n,'location',f,(sign*(.201-.055*q)+.078*q,-.028*q,.039*q))
  pose(n,'scale',f,(1-.08*q,1+.052*q,1+.024*q))
  pose(n,'rotation_euler',f,(0.,0.,.043*q))
 h=E(t-.32)
 pose('Halo','location',f,(.082*h,.060+.024*h,0.))
 pose('Halo','rotation_euler',f,(.015*h,0.,.036*h))
 tip=rig.pose.bones['Halo.Tip'];tip['lag']=float(.20+.20*E(t-.38));tip.keyframe_insert('["lag"]',frame=f,group='Halo.Tip')
rig.animation_data.action.name='Collective spring • settle with lag'
old.animation_data.action.name='Collective deformation with delayed lobe release'
for datastore in (rig,old):
 for fc in datastore.animation_data.action.fcurves:
  for p in fc.keyframe_points:p.interpolation='LINEAR'
s.frame_start=1;s.frame_end=145
s.timeline_markers.clear()
for f,n in [(1,'Rest'),(33,'Compression peak'),(45,'Rebound overshoot'),(55,'Secondary recovery'),(82,'Settled'),(145,'Loop')]:s.timeline_markers.new(n,frame=f)
s['motion_variant']='03 collective elastic impulse, distinct delayed regional release'
s.frame_set(1);bpy.context.preferences.filepaths.save_version=0
dest=os.path.join(folder,'cloud-elastic.blend');bpy.ops.wm.save_as_mainfile(filepath=dest,compress=True)
lh=bpy.data.objects['Floating hand L'];rh=bpy.data.objects['Floating hand R']
hal=[o for o in s.objects if o.name.startswith('Halo vapor')]
left,right=[bpy.data.objects['Eye white '+k] for k in 'LR']
def vertices(o,dg):
 e=o.evaluated_get(dg);return [e.matrix_world@v.co for v in e.data.vertices]
def im(coords):return [world_to_camera_view(s,s.camera,k) for k in coords]
def b(a,i):return min(x[i] for x in a),max(x[i] for x in a)
notes=[];loops=[]
for f in range(1,146):
 s.frame_set(f);dg=bpy.context.evaluated_depsgraph_get()
 va=vertices(body,dg)
 if f in (1,145):loops.append(va)
 a,l,r,h=map(im,(va,vertices(lh,dg),vertices(rh,dg),[z for x in hal for z in vertices(x,dg)]))
 gaps=[240*(b(l,0)[0]-b(a,0)[1]),240*(b(a,0)[0]-b(r,0)[1]),135*(b(h,1)[0]-b(a,1)[1])]
 er=(left.evaluated_get(dg).matrix_world.translation-right.evaluated_get(dg).matrix_world.translation).length
 notes.append(dict(frame=f,seconds=(f-1)/24,width=(b(a,0)[1]-b(a,0)[0])*240,height=(b(a,1)[1]-b(a,1)[0])*135,gaps=gaps,eyes=er,collective=collective.value,local=[k.value for k in keys]))
width0=notes[0]['width']
mins=[min(x['gaps'][i] for x in notes) for i in range(3)]
assert min(mins)>1.4,mins
assert min(r['width'] for r in notes)<.91*width0 and max(r['width'] for r in notes)>1.06*width0
assert max(x['eyes'] for x in notes)-min(x['eyes'] for x in notes)<1e-5
assert max((a-b).length for a,b in zip(*loops))<1e-5
assert digest(src)==src_hash
with open(os.path.join(folder,'elastic-validation.json'),'w') as f:
 json.dump(dict(base=src_hash,variant=digest(dest),tested_frames=len(notes),rest_width=width0,min_width=min(r['width'] for r in notes),max_width=max(r['width'] for r in notes),clearance_minima_px=mins,track=notes),f,indent=1)
s.cycles.samples=48
s.render.resolution_x=240;s.render.resolution_y=135
frames=os.path.join(folder,'frames');os.makedirs(frames,exist_ok=True)
for i,f in enumerate(range(1,145,3)):
 s.frame_set(f);s.render.filepath=os.path.join(frames,'frame-%03d.png'%i);bpy.ops.render.render(write_still=True)
