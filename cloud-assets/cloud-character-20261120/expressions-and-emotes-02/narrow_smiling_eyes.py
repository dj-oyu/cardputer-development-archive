"""Change only the two happy eyelid curves in the integrated Cloud Blender model."""
import bpy,sys,os,hashlib,json
from bpy_extras.object_utils import world_to_camera_view
p=os.path.dirname(os.path.realpath(__file__))
a=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
values=[x for x in a if x!='--no-preview']
base=os.path.join(p,'..','cloud-expression-loop','stage','cloud-faces-and-emotes.blend')
src=os.path.abspath(values[0]) if values else base
dest=os.path.abspath(values[1]) if len(values)>1 else os.path.join(p,'cloud-faces-and-emotes-caret.blend')
assert os.path.realpath(src)!=os.path.realpath(dest)
def digest(fp):return hashlib.sha256(open(fp,'rb').read()).hexdigest()
prev=digest(src);bpy.ops.wm.open_mainfile(filepath=src)
s=bpy.context.scene
ctl=bpy.data.objects['Cloud face controls']
e_ctl=bpy.data.objects['Cloud emote controls'];rig=bpy.data.objects['Cloud_Rig']
targets={'Expression Happy closed eye L','Expression Happy closed eye R'}
assert all(k in s.objects for k in targets)
control_keys=['cloud_face_preset','cloud_face_eyes','cloud_face_brows','cloud_face_mouth']
ctl_initial={name:ctl[name] for name in control_keys}
emote_keys=['sweat','confusion','anger']; emote_initial={name:e_ctl[name] for name in emote_keys}
saved=s.frame_current
res=(s.render.resolution_x,s.render.resolution_y,s.render.resolution_percentage,s.cycles.samples)
saved_render_filepath=s.render.filepath
def setface(i,em=None,frame=1):
 ctl['cloud_face_preset']=float(i)
 for k in control_keys[1:]:ctl[k]=-1.
 for k in emote_keys:e_ctl[k]=float(k==em)
 ctl.update_tag();e_ctl.update_tag();s.frame_set(frame);bpy.context.view_layer.update()
def vertices(name,dg):
 eo=bpy.data.objects[name].evaluated_get(dg);me=eo.to_mesh()
 try:return [eo.matrix_world@v.co for v in me.vertices]
 finally:eo.to_mesh_clear()
def bounds(name,dg):
 points=[world_to_camera_view(s,s.camera,x) for x in vertices(name,dg)]
 a,b=min(x.x for x in points)*240,max(x.x for x in points)*240
 c,d=min(x.y for x in points)*135,max(x.y for x in points)*135
 return {'width':b-a,'height':d-c,'x_center':(a+b)/2,'y_center':(c+d)/2}
def shot(name):
 s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100;s.cycles.samples=96
 s.render.filepath=os.path.join(os.path.dirname(dest),name+'.png');bpy.ops.render.render(write_still=True)
 s.render.resolution_x,s.render.resolution_y,s.render.resolution_percentage,s.cycles.samples=res
setface(1);dg=bpy.context.evaluated_depsgraph_get()
before={n:bounds(n,dg) for n in sorted(targets)}
if '--no-preview' not in a:shot('smile-before')
def signature(o):
 return (o.type,o.data.name if o.data else None,tuple(o.matrix_basis),o.parent.name if o.parent else None,o.parent_bone)
old_objects={o.name:signature(o) for o in s.objects if o.name not in targets}
channels={}
for n in sorted(targets):
 o=s.objects[n];spl=o.data.splines[0]
 pts=[k.co.copy() for k in spl.points];assert len(pts)%2==1
 xc=(pts[0].x+pts[-1].x)/2
 lo=(pts[0].z+pts[-1].z)/2;hi=max(k.z for k in pts)
 for i,(k,q) in enumerate(zip(spl.points,pts)):
  t=i/(len(pts)-1)
  tri=1-abs(2*t-1)
  # Nearly straight arms and a modestly softened peak. Keep tips and apex
  # heights, keep the same centre, squeezing only between those endpoints.
  tri=(tri*.98+.02*tri*tri)
  k.co=(xc+.67*(q.x-xc),q.y,lo+(hi-lo)*tri,q.w)
 channels[n]={'3d_midpoint_x':xc,'span_factor':.67,'unchanged_curve_bevel':o.data.bevel_depth}
 o.data.update_tag();o.update_tag()
bpy.context.view_layer.update();dg=bpy.context.evaluated_depsgraph_get()
after={n:bounds(n,dg) for n in sorted(targets)}
for n,f in after.items():
 old=before[n]
 assert .55<f['width']/old['width']<.81,(n,old,f)
 assert abs(f['x_center']-old['x_center'])<.20,(n,old,f)
 assert abs(f['y_center']-old['y_center'])<.35,(n,old,f)
assert {o.name:signature(o) for o in s.objects if o.name not in targets}==old_objects
if '--no-preview' not in a:
 shot('smile-after');setface(1,'sweat',74);shot('smile-overlay-after')
for name,k in ctl_initial.items():ctl[name]=k
for name,k in emote_initial.items():e_ctl[name]=k
ctl.update_tag();e_ctl.update_tag();s.frame_set(saved);bpy.context.view_layer.update()
s.render.filepath=saved_render_filepath
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=dest,compress=True)
bpy.ops.wm.open_mainfile(filepath=dest);s=bpy.context.scene
ctl=s.objects['Cloud face controls'];e_ctl=s.objects['Cloud emote controls']
assert {k:ctl[k] for k in control_keys}==ctl_initial
assert {k:e_ctl[k] for k in emote_keys}==emote_initial
assert (s.frame_start,s.frame_end)==(1,169)
setface(1,'confusion',74);dg=bpy.context.evaluated_depsgraph_get()
assert all(s.objects[n].evaluated_get(dg).scale.length>.001 for n in targets)
assert s.objects['Cloud emote • confusion'].evaluated_get(dg).scale.length>.001 if 'Cloud emote • confusion' in s.objects else any(o.name.startswith('Cloud emote • ') and not o.evaluated_get(dg).hide_render and o.evaluated_get(dg).scale.length>.001 for o in s.objects)
setface(2,frame=74);dg=bpy.context.evaluated_depsgraph_get()
assert all(s.objects[n].evaluated_get(dg).scale.length<.001 for n in targets)
assert digest(src)==prev
fn=os.path.join(os.path.dirname(dest),'smile-caret-validation.json')
with open(fn,'w') as f:json.dump({'source_sha256':prev,'output_sha256':digest(dest),'inputs_unchanged':True,'two_edited_curves':channels,'fixed_camera_240x135_before':before,'fixed_camera_240x135_after':after,'saved_initial_face':ctl_initial,'ready_for_preset_and_emote':True,'verified_idle_frames':[1,169]},f,indent=2)
print('PASS',before,after,flush=True)
