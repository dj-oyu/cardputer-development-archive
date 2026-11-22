"""Rebuild depth candidate from archived joint test (not from review imagery)."""
import bpy,sys,hashlib,json,math
from mathutils import Vector
from pathlib import Path
source,out=map(Path,sys.argv[-2:])
SHA='28193beaadb15bb5bfddb55125a780aeee7d0db4f0eab42703cdfc595587f872'
assert hashlib.sha256(source.read_bytes()).hexdigest()==SHA, "Wrong joint test input"
bpy.ops.wm.open_mainfile(filepath=str(source.resolve()))
s=bpy.context.scene;s.frame_set(1)
rig=next(x for x in s.objects if x.type=='ARMATURE')
def smooth(a,b,x):
 t=min(1.,max(0.,(x-a)/(b-a)))
 return t*t*(3-2*t)
def gauss(z,a,b):return math.exp(-((z-a)/b)**2)
tally={}
for o in s.objects:
 if o.type!='MESH' or not o.modifiers.get('Provisional joint continuity'):continue
 assert not o.data.shape_keys and o.data.users==1,o.name
 m=o.matrix_world.copy(); inv=m.inverted()
 kind=o.users_collection[0].name
 side='L' if sum((m@v.co).x for v in o.data.vertices)>0 else 'R'
 ankle=rig.data.bones['foot.'+side].head_local.y
 moved=0;dymax=0
 for v in o.data.vertices:
  x,y,z=m@v.co;dy=dz=0
  if kind=='Jacket and T-shirt':
   # Coordinate-based shell deformation preserves shirt/bindings/cuffs at overlaps.
   fall=1.-smooth(.42,.73,abs(x))
   chest=gauss(z,3.55,.47)
   dy=(y*(.40 if y<0 else .34)-.015)*fall*chest
  elif kind=='Shorts':
   # Upper-mid volume/seat, weighted out near skin/fabric seam at hem.
   dy=(y*(.30 if y<0 else .53))*gauss(z,2.81,.46)*smooth(2.37,2.61,z)
  elif kind=='Boots':
   # Shorten only the in-front-of-ankle toe and round top of the tip.
   front=ankle-y
   toe=smooth(.25,.72,front)
   lower=1.-smooth(.29,.46,z)
   dy=.16*toe*lower
   dz=.026*toe*smooth(.13,.23,z)*(1.-smooth(.31,.45,z))
  elif o.name.startswith(('Left swept temple curl','Right framing curl','Scalloped separate bob tip')):
   # Push mask area behind the nearer eye; preserve rear mass and frontal outline.
   dy=.18*gauss(z,4.70,.25)*(1.-smooth(-.20,.15,y))
  elif o.name.startswith(('Left wide brushed fringe','Right split long sweep','Large right side-sweep')):
   # A smaller taper on the strands that descend to the same eye-level boundary.
   dy=.10*gauss(z,4.69,.20)*smooth(.20,.62,abs(x))*(1.-smooth(-.21,.07,y))
  elif o.name.startswith(('Bob back mass','Swept layered back nape lock')):
   dy=.078*gauss(z,4.46,.44)*smooth(.23,.66,y)
  elif o.name.startswith('Low nose bridge'):
   # Keep the base coupled to the cheek, without lengthening the projected tip the full amount.
   dy=-.065*gauss(z,4.56,.30)*(1.-smooth(-.22,.03,y))*(.30+.70*smooth(-.53,-.39,y))
  elif kind.startswith('Face') and not o.name.startswith(('Neck','Ear')):
   dy=-(.065*gauss(z,4.56,.30)+.022*gauss(z,4.33,.13))*(1.-smooth(-.22,.03,y))
  if abs(dy)+abs(dz)>1e-5:
   v.co=inv@Vector((x,y+dy,z+dz));moved+=1;dymax=max(dymax,abs(dy))
 if moved:tally[o.name]=[moved,dymax]
s['depth_adjustment']='Depth-only garment/face/hair/boot refinement from joint-test-01, leaves bone anchors, vertex weights, actions and topology unchanged; use original settings illustration for review.'
out=out.resolve();out.parent.mkdir(parents=True,exist_ok=True)
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
(out.parent/'sculpt-report.json').write_text(json.dumps({'source_sha256':SHA,'output_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'moved_parts':tally,'bones':len(rig.data.bones),'frames':[s.frame_start,s.frame_end],'rig_action':rig.animation_data.action.name},indent=2)+'\n')
