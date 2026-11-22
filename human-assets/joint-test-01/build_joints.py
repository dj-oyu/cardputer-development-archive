import argparse,bpy,sys,math,json,hashlib
from pathlib import Path
from mathutils import Vector
from bpy_extras.object_utils import world_to_camera_view
p=argparse.ArgumentParser();p.add_argument('output',type=Path);p.add_argument('--render',action='store_true');a=p.parse_args(sys.argv[sys.argv.index('--')+1:])
source=Path(bpy.data.filepath); assert source.is_file()
a.output.mkdir(parents=True,exist_ok=False)
s=bpy.context.scene; sc=s.collection
rigdata=bpy.data.armatures.new('Provisional anatomical joints');rig=bpy.data.objects.new('Provisional anatomical joints',rigdata);sc.objects.link(rig)
bpy.context.view_layer.objects.active=rig;rig.select_set(True);rig.show_in_front=True;rigdata.display_type='OCTAHEDRAL'
bpy.ops.object.mode_set(mode='EDIT')
bones={};anchors={}
def bone(n,h,t,p=None):
 b=rigdata.edit_bones.new(n);b.head=h;b.tail=t
 if p: b.parent=bones[p];b.use_connect=(Vector(h)-bones[p].tail).length<1e-5
 bones[n]=b;anchors[n]=[list(h),list(t)]
bone('root',(0,0,0),(0,0,.38))
bone('pelvis',(0,.03,2.80),(0,.012,3.10),'root')
bone('spine',(0,.012,3.10),(0,.018,3.55),'pelvis')
bone('chest',(0,.018,3.55),(0,.005,3.89),'spine')
bone('neck',(0,.005,3.89),(0,-.045,4.43),'chest')
bone('head',(0,-.045,4.43),(0,.02,5.30),'neck')
for side,sg,dy in [('L',1,-.08),('R',-1,.14)]:
 f=lambda x,y,z:(sg*x,y,z)
 sh,el,wr=f(.465,.005,3.84),f(.802,-.018,3.245),f(1.04,-.115,2.60)
 hip,knee,ank=f(.23,.025,2.80),f(.38,-.025+dy*.47,1.45),f(.50,.07+dy,.62)
 tags=lambda n:n+'.'+side
 bone(tags('clavicle'),f(.035,.005,3.84),sh,'chest')
 bone(tags('upper-arm'),sh,el,tags('clavicle'))
 bone(tags('forearm'),el,wr,tags('upper-arm'))
 bone(tags('hand'),wr,f(1.058,-.122,2.40),tags('forearm'))
 bone(tags('thigh'),hip,knee,'pelvis')
 bone(tags('shin'),knee,ank,tags('thigh'))
 bone(tags('foot'),ank,f(.50,-.31+dy,.16),tags('shin'))
bpy.ops.object.mode_set(mode='OBJECT')
def seg(x,edge,spread):
 t=max(0.,min(1.,(x-edge+spread)/(2*spread)));return t*t*(3-2*t)
def pref(o,*p):return o.name.startswith(p)
for o in list(s.objects):
 if o.type!='MESH' or any(c.name=='Preview only' for c in o.users_collection): continue
 group=o.users_collection[0].name
 center=sum((o.matrix_world@v.co).x for v in o.data.vertices)/len(o.data.vertices)
 side='L' if center>0 else 'R'
 def weights(v):
  x,y,z=o.matrix_world@v.co
  def graft(a,b,w): return [(a,w),(b,1-w)]
  f=lambda n:n+'.'+side
  if group.startswith(('Face','Hair')):
   return graft('head','neck',seg(z,4.35,.15)) if pref(o,'Neck') else [('head',1)]
  if pref(o,'Shaped rolled','Rolled fabric sleeve','Elbow and narrowing','Relaxed blockout','Separate resting thumb'):
   # Same regional elbow/wrist blends across overlapping cuff, skin and wrist ring.
   if z>2.88:return graft(f('upper-arm'),f('forearm'),seg(z,3.245,.22))
   return graft(f('forearm'),f('hand'),seg(z,2.60,.10))
  if pref(o,'Thigh to shin'): return graft(f('thigh'),f('shin'),seg(z,1.45,.35))
  if group=='Boots':return graft(f('shin'),f('foot'),seg(z,.62,.14))
  if pref(o,'Tailored high-rise shorts leg','Double-rolled short hem'):
   return graft('pelvis',f('thigh'),seg(z,2.78,.22))
  if group=='Shorts': return [('pelvis',1)]
  return graft('chest','spine',seg(z,3.55,.37))
 for v in o.data.vertices:
  for n,w in weights(v):
   if w>1.e-6:
    g=o.vertex_groups.get(n) or o.vertex_groups.new(name=n);g.add([v.index],w,'REPLACE')
 m=o.modifiers.new('Provisional joint continuity','ARMATURE');m.object=rig;m.use_deform_preserve_volume=True
for b in rig.pose.bones: b.rotation_mode='XYZ'
s.frame_start=1;s.frame_end=30
for f in (1,30):
 s.frame_set(f)
 for b in rig.pose.bones:
  b.rotation_euler=(0,0,0)
  if f==30:
   # Forward elbow and knee hinge axes are set from anatomical world X transformed into bone space.
   angles={'forearm.L':-46,'thigh.R':-20,'shin.R':40,'foot.R':-19}
   if b.name in angles:
    axis=b.bone.matrix_local.to_3x3().inverted()@Vector((1,0,0))
    from mathutils import Quaternion
    b.rotation_euler=Quaternion(axis,math.radians(angles[b.name])).to_euler()
  b.keyframe_insert(data_path='rotation_euler',frame=f)
if rig.animation_data and rig.animation_data.action:rig.animation_data.action.name='Provisional elbow + knee bend, not final'
s['provisional_notes']='Initial anatomical pivot test only. Component meshes retained; do not use weights for production or infer anatomy under all poses.'
def snap():
 bpy.context.view_layer.update(); dg=bpy.context.evaluated_depsgraph_get()
 parts={}
 for o in s.objects:
  if not o.modifiers.get('Provisional joint continuity'): continue
  e=o.evaluated_get(dg); m=e.to_mesh(); edges=[(m.vertices[x.vertices[0]].co-m.vertices[x.vertices[1]].co).length for x in m.edges];assert all(math.isfinite(x) for x in edges)
  parts[o.name]=edges;e.to_mesh_clear()
 def point(c):
  z=world_to_camera_view(s,s.camera,c)
  return [round(z.x*240,3),round((1-z.y)*135,3)]
 return parts,{v.name:[point(v.head),point(v.tail)] for v in rig.pose.bones}
s.frame_set(1); edges0,p0=snap();s.frame_set(30);edges1,p1=snap()
peaks={n:round(max((b/a for a,b in zip(edges0[n],edges1[n]) if a>1.e-4),default=1),3) for n in edges0}
s.frame_set(1)
dst=a.output/'human-joints-provisional.blend'
bpy.ops.wm.save_as_mainfile(filepath=str(dst.resolve()),compress=True)
if a.render:
 s.cycles.samples=40
 for i,n in [(1,'rest'),(30,'bend')]:
  s.frame_set(i);s.render.filepath=str((a.output/f'{n}.png').resolve());bpy.ops.render.render(write_still=True)
report={'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'blend_sha256':hashlib.sha256(dst.read_bytes()).hexdigest(),'bones_world':anchors,'preview_rest_px':p0,'preview_bend_px':p1,'peak_edge_stretch':peaks,'resolution':[s.render.resolution_x,s.render.resolution_y],'weighted_objects':len(peaks),'scope':'Provisional editable Blender regional skin with rest and mild bend; no runtime/native export or hardware result.'}
(a.output/'verification.json').write_text(json.dumps(report,indent=2)+'\n')
