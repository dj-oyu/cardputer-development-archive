"""Move only the middle of the single-stroke ε to the right."""
import bpy,sys,os,json,hashlib
from mathutils import Vector
from bpy_extras.object_utils import world_to_camera_view
folder=os.path.dirname(os.path.realpath(__file__))
args=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
pos=[x for x in args if x!='--no-preview']
basename='cloud-faces-and-emotes-epsilon.blend'
options=[os.path.join(folder,'..',p,basename) for p in ('epsilon-mouth-v4','cloud-expression-epsilon-v4')]
src=os.path.abspath(pos[0]) if pos else next(x for x in options if os.path.isfile(x))
dest=os.path.abspath(pos[1]) if len(pos)>1 else os.path.join(folder,'cloud-faces-and-emotes-epsilon-waist.blend')
assert os.path.realpath(src)!=os.path.realpath(dest)
h=lambda p:hashlib.sha256(open(p,'rb').read()).hexdigest()
origsha=h(src);bpy.ops.wm.open_mainfile(filepath=src)
s=bpy.context.scene;c=s.objects['Cloud face controls']; em=s.objects['Cloud emote controls'];rig=s.objects['Cloud_Rig']
body=s.objects['Cloud body'];mouth=s.objects['Expression Dot gag epsilon mouth']
prop_names=['cloud_face_preset','cloud_face_eyes','cloud_face_brows','cloud_face_mouth']
emote_names=['sweat','confusion','anger']
saved={k:c[k] for k in prop_names}; esaved={k:em[k] for k in emote_names}; fr=s.frame_current
renderkeep=(s.render.resolution_x,s.render.resolution_y,s.render.resolution_percentage,s.cycles.samples,s.render.filepath)
outdir=os.path.dirname(dest)
def choose(state,frame=1,emote=None):
 for i,k in enumerate(prop_names):c[k]=float(state if i==0 else -1)
 for k in emote_names:em[k]=float(k==emote)
 c.update_tag();em.update_tag();s.frame_set(frame);bpy.context.view_layer.update()
def render(name):
 s.render.resolution_x,s.render.resolution_y=240,135
 s.render.resolution_percentage=100;s.cycles.samples=96
 s.render.filepath=os.path.join(outdir,name+'.png');bpy.ops.render.render(write_still=True)
def getverts(o,dg):
 e=o.evaluated_get(dg);m=e.to_mesh()
 try:return [e.matrix_world@v.co for v in m.vertices]
 finally:e.to_mesh_clear()
def projected_size(ob):
 v=[world_to_camera_view(s,s.camera,x) for x in getverts(ob,bpy.context.evaluated_depsgraph_get())]
 return [(max(p[i] for p in v)-min(p[i] for p in v))*[240,135][i] for i in (0,1)]
names=sorted(o.name for o in s.objects if o.parent in (rig,s.camera) and o.name!=mouth.name)
times=[(1,k) for k in range(6)]+[(74,5),(169,0)]
def collect():
 d={}
 for frame,state in times:
  choose(state,frame);dg=bpy.context.evaluated_depsgraph_get()
  for n in names:d[(frame,state,n)]=getverts(s.objects[n],dg)
 return d
original=collect()
choose(5);was=projected_size(mouth)
if '--no-preview' not in args:render('epsilon-before')
assert len(mouth.data.splines)==1
sp=mouth.data.splines[0]
pts=[k.co.copy() for k in sp.points]
assert len(pts)==25
# Only the short intermediate waist arc, preserving both lobe bodies and 
# the original lip depth. Compact smooth support (raised cosine).
from math import pi,cos
from bpy_extras.object_utils import world_to_camera_view
old_center=mouth.matrix_world@pts[12].to_3d()
changed=[]
for i,point in enumerate(sp.points):
 dose=.5+.5*cos(pi*(i-12)/4.5) if abs(i-12)<4.5 else 0
 if dose:
  xx=pts[i].x+.060*dose
  point.co=(xx,pts[i].y,pts[i].z,1)
  changed.append(i)
mouth.data.update_tag();mouth.update_tag();bpy.context.view_layer.update()
new_center=mouth.matrix_world@sp.points[12].co.to_3d()
dx=(world_to_camera_view(s,s.camera,new_center).x-world_to_camera_view(s,s.camera,old_center).x)*240
now=projected_size(mouth)
assert 1.5<dx<2.05,dx
assert max(abs(x-y) for x,y in zip(was,now))<.10,(was,now)
assert all(point.co==q for i,(point,q) in enumerate(zip(sp.points,pts)) if i not in changed)
new=collect()
assert all(len(v)==len(new[k]) for k,v in original.items())
err=max((x-y).length for k,v in original.items() for x,y in zip(v,new[k]))
assert err==0,err
if '--no-preview' not in args:
 choose(5);render('epsilon-after')
for k,v in saved.items():c[k]=v
for k,v in esaved.items():em[k]=v
c.update_tag();em.update_tag();s.frame_set(fr);bpy.context.view_layer.update()
s.render.resolution_x,s.render.resolution_y,s.render.resolution_percentage,s.cycles.samples,s.render.filepath=renderkeep
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=dest,compress=True)
bpy.ops.wm.open_mainfile(filepath=dest)
s=bpy.context.scene;c=s.objects['Cloud face controls'];em=s.objects['Cloud emote controls'];mouth=s.objects['Expression Dot gag epsilon mouth']
assert {k:c[k] for k in prop_names}==saved and {k:em[k] for k in emote_names}==esaved
assert (s.frame_start,s.frame_end,s.render.fps)==(1,169,24)
choose(5,74,'confusion');dg=bpy.context.evaluated_depsgraph_get()
assert len(mouth.data.splines)==1 and mouth.evaluated_get(dg).scale.length>.1
assert all(s.objects['Expression Dot gag eye '+k].evaluated_get(dg).scale.length>.1 for k in 'LR')
assert any(o.name.startswith('Cloud emote •') and o.evaluated_get(dg).scale.length>.001 for o in s.objects)
assert h(src)==origsha
report={'source_sha256':origsha,'variant_sha256':h(dest),'only_changed_geometry':'Expression Dot gag epsilon mouth','spline_count_before_after':[1,1],'control_point_count':len(pts),'waist_changed_control_point_indices':changed,'waist_projected_right_shift_px':dx,'mouth_proj_px_before_after':[was,now],'samples_all_other_mesh_vertices_equal':times,'max_unchanged_vertex_error':err,'checked_mid_idle_gag_and_emote':True,'source_unchanged':True}
with open(os.path.join(outdir,'epsilon-waist-validation.json'),'w') as f:json.dump(report,f,indent=2)
print(report,flush=True)
