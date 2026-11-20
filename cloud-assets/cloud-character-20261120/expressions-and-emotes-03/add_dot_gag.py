"""Add preset 5 and independent solid dot eyes and epsilon mouth to Cloud."""
import bpy,os,sys,hashlib,json
from mathutils import Vector
from bpy_extras.object_utils import world_to_camera_view
p=os.path.dirname(os.path.realpath(__file__))
argv=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
a=[x for x in argv if x!='--no-preview']
sources=[os.path.join(p,'..',d,'cloud-faces-and-emotes-caret.blend') for d in ('caret-v2','cloud-expression-caret-v2')]
src=os.path.abspath(a[0]) if a else next(x for x in sources if os.path.isfile(x))
out=os.path.abspath(a[1]) if len(a)>1 else os.path.join(p,'cloud-faces-and-emotes-dot-gag.blend')
assert os.path.realpath(src)!=os.path.realpath(out)
root=os.path.dirname(out)
sha=lambda f:hashlib.sha256(open(f,'rb').read()).hexdigest()
prior=sha(src);bpy.ops.wm.open_mainfile(filepath=src)
s=bpy.context.scene;c=s.objects['Cloud face controls'];ec=s.objects['Cloud emote controls'];rig=s.objects['Cloud_Rig'];body=s.objects['Cloud body']
old=s.objects['Open smile contour']
keys=['cloud_face_preset','cloud_face_eyes','cloud_face_brows','cloud_face_mouth']
emotes=['sweat','confusion','anger']
saved={k:c[k] for k in keys};saved_emotes={k:ec[k] for k in emotes};frame=s.frame_current
render_keep=(s.render.resolution_x,s.render.resolution_y,s.render.resolution_percentage,s.cycles.samples,s.render.filepath)
def choose(idx=0, eyes=-1,brows=-1,mouth=-1,emote=None,fr=1):
 for k,v in zip(keys,(idx,eyes,brows,mouth)):c[k]=float(v)
 for k in emotes:ec[k]=float(k==emote)
 c.update_tag();ec.update_tag();s.frame_set(fr);bpy.context.view_layer.update()
orig=[o.name for o in s.objects if o.parent==rig]
def snapshot(sets):
 out={}
 for fr,idx in sets:
  choose(idx,fr=fr);dg=bpy.context.evaluated_depsgraph_get()
  for name in orig:
   o=s.objects[name].evaluated_get(dg);m=o.to_mesh()
   try:out[(fr,idx,name)]=[o.matrix_world@v.co for v in m.vertices]
   finally:o.to_mesh_clear()
 return out
sets=[(1,0),(1,1),(74,1),(1,2),(1,3),(1,4),(169,0)]
original=snapshot(sets); choose()
# Reinforce pure driver expressions known to evaluate; replace only the
# allowed-state condition, keeping original scale for original states.
def layer_cond(mode):
 return f'(v == {mode} or (v < 0 and p == {mode}))'
def add_to_allow(o):
 drivers=[f for f in o.animation_data.drivers if f.data_path=='scale']
 assert len(drivers)==3,o.name
 for r in drivers:
  d=r.driver
  scale,test=d.expression.split(' if ',1)
  assert test.endswith(' else 0') and [v.name for v in d.variables]==['p','v']
  d.expression=f'{scale} if ({test[:-len(" else 0")]} or {layer_cond(5)}) else 0'
for o in s.objects:
 if o.name.startswith(('Brow ',)):add_to_allow(o)
for i,k in enumerate(keys):
 c.id_properties_ui(k).update(min=-1 if i else 0,max=5,description='0 neutral, 1 happy, 2 concerned, 3 surprised, 4 sleepy, 5 solid dot gag.'+(' -1 follows preset.' if i else ''))
# A round-backed epsilon, distinct from a surprised 'O' or a frown.
# A single spline traces both upper/lower arms; middle arm shares the left
# connection. Same mesh path/curvature maps to the original face.
choose(); mat=bpy.data.materials['Ink • dark mulberry']
def front(x,z,off=.081):
 q=Vector((x,-4,z-1.86));hit,h,n,i=body.ray_cast(q,(0,1,0))
 return (x,(h.y if hit else -.82)-off,z)
def bez(q,n=5):
 return [tuple((1-t)**3*q[0][i]+3*t*(1-t)**2*q[1][i]+3*t*t*(1-t)*q[2][i]+t**3*q[3][i] for i in (0,1)) for t in [i/n for i in range(n+1)]]
middle=(-.133,1.871)
outer=[]
parts=[((.114,1.974),(.032,2.015),(-.132,1.996),middle),(middle,(-.135,1.765),(-.006,1.745),(.115,1.789))]
for q in parts:outer+=bez(q)[1:] if outer else bez(q)
dash=bez((middle,(-.10,1.872),(-.014,1.87),(.067,1.87)),4)
cu=bpy.data.curves.new('Expression Dot gag epsilon mouth','CURVE');cu.dimensions='3D';cu.bevel_depth=.032;cu.bevel_resolution=2
for line in (outer,dash):
 sp=cu.splines.new('POLY');sp.points.add(len(line)-1)
 for a,(x,z) in zip(sp.points,line):a.co=(*front(x,z),1)
cu.materials.append(mat)
mouth=bpy.data.objects.new(cu.name,cu)
s.collection.children['Cloud face variants • controlled by Cloud_Rig'].objects.link(mouth)
mouth.parent=rig;mouth.parent_type='BONE';mouth.parent_bone='Body';mouth.matrix_parent_inverse=old.matrix_parent_inverse.copy()
def switch(o,layer,scale):
 for i in range(3):
  d=o.driver_add('scale',i).driver;d.type='SCRIPTED'
  for n,k in (('p',keys[0]),('v',keys[layer])):
   v=d.variables.new();v.name=n;v.type='SINGLE_PROP';v.targets[0].id=c;v.targets[0].data_path=f'["{k}"]'
  d.expression=f'{scale[i]:.17g} if {layer_cond(5)} else 0'
switch(mouth,3,(1,1,1))
dots=[]
for side,sign in zip('LR',(1,-1)):
 bpy.ops.mesh.primitive_uv_sphere_add(segments=16,ring_count=8)
 dot=bpy.context.object;dot.name='Expression Dot gag eye '+side
 for coll in list(dot.users_collection):coll.objects.unlink(dot)
 s.collection.children['Cloud face variants • controlled by Cloud_Rig'].objects.link(dot)
 dot.parent=rig;dot.parent_type='BONE';dot.parent_bone='Body';dot.matrix_parent_inverse=old.matrix_parent_inverse.copy()
 dot.location=front(.381*sign,2.222,.086)
 dot.data.materials.append(mat)
 for f in dot.data.polygons:f.use_smooth=True
 switch(dot,1,(.155,.036,.155));dots.append(dot)
def vis(name,dg):return s.objects[name].evaluated_get(dg).scale.length>.001
new=snapshot(sets)
assert all(len(oldv)==len(new[k]) for k,oldv in original.items())
diff=max((x-y).length for k in original for x,y in zip(original[k],new[k]))
assert diff<1e-6,diff
def gag():
 dg=bpy.context.evaluated_depsgraph_get()
 visible=[n for n in orig+[mouth.name,*[x.name for x in dots]] if n.startswith(('Eye ','Pupil','Catchlight','Expression','Brow','Open smile')) and vis(n,dg)]
 assert all(vis('Expression Dot gag eye '+side,dg) for side in 'LR')
 assert not any(n.startswith(('Eye ','Pupil','Catchlight')) for n in visible),visible
 assert vis(mouth.name,dg) and not vis(old.name,dg)
 v=mouth.evaluated_get(dg);m=v.to_mesh()
 verts=[world_to_camera_view(s,s.camera,v.matrix_world@q.co) for q in m.vertices]
 size=[(max(q[i] for q in verts)-min(q[i] for q in verts))*[240,135][i] for i in (0,1)]
 m.calc_loop_triangles();tc=len(m.loop_triangles);v.to_mesh_clear()
 assert 7<size[0]<15 and 6<size[1]<14 and tc<480,(size,tc)
 return visible,size,tc
choose(5);visible,size,tc=gag()
choose(0,5,0,5);gag();choose(5,0,0,5)
dg=bpy.context.evaluated_depsgraph_get();assert vis('Pupil L',dg) and vis('Pupil R',dg) and vis(mouth.name,dg)
def shot(name):
 s.render.resolution_x=240;s.render.resolution_y=135;s.render.resolution_percentage=100;s.cycles.samples=96
 s.render.filepath=os.path.join(root,name+'.png');bpy.ops.render.render(write_still=True)
if '--no-preview' not in argv:
 choose(5);shot('dot-gag')
 choose(5,emote='confusion',fr=74);shot('dot-gag-overlay')
 choose(1);shot('caret-preserved')
for k,v in saved.items():c[k]=v
for k,v in saved_emotes.items():ec[k]=v
c.update_tag();ec.update_tag();s.frame_set(frame);bpy.context.view_layer.update()
s.render.resolution_x,s.render.resolution_y,s.render.resolution_percentage,s.cycles.samples,s.render.filepath=render_keep
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=out,compress=True);bpy.ops.wm.open_mainfile(filepath=out)
s=bpy.context.scene;c=s.objects['Cloud face controls'];ec=s.objects['Cloud emote controls'];rig=s.objects['Cloud_Rig'];mouth=s.objects['Expression Dot gag epsilon mouth'];old=s.objects['Open smile contour'];dots=[s.objects['Expression Dot gag eye '+side] for side in 'LR']
assert {k:c[k] for k in keys}==saved and {k:ec[k] for k in emotes}==saved_emotes
assert (s.frame_start,s.frame_end,s.render.fps)==(1,169,24)
choose(5,emote='confusion',fr=74);gag()
dg=bpy.context.evaluated_depsgraph_get()
assert any(o.name.startswith('Cloud emote •') and not o.evaluated_get(dg).hide_render and vis(o.name,dg) for o in s.objects)
assert sha(src)==prior
report={'source_sha256':prior,'variant_sha256':sha(out),'checked_unchanged_presets_frames':sets,'max_previous_pose_vertex_error':diff,'new_preset':5,'visible_face_components':visible,'gag_epsilon_proj_size_px':size,'gag_epsilon_editable_triangles':tc,'whole_eye_dot_mesh_triangles':sum(sum(len(poly.vertices)-2 for poly in x.data.polygons) for x in dots),'preserves_7s':True,'verified_independent_layers':True,'verified_emote_combination_after_reopen':True}
with open(os.path.join(root,'dot-gag-validation.json'),'w') as f:json.dump(report,f,indent=1)
print(report,flush=True)
