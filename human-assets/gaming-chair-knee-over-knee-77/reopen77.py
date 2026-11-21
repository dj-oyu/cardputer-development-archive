import bpy, math, os, json, hashlib
from pathlib import Path
from mathutils.bvhtree import BVHTree
P=Path(__file__).resolve().parent
src=Path('/workspace/shared/chair-knee-recovery-v74/chair-seated-v74.blend')
cand=Path(bpy.data.filepath)
hash0='156c1493ed9ba575191ce804d45b0208d6f8f53d571850e714a7e05bd2126e9b'
def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()
assert sha(src)==hash0
bpy.ops.wm.open_mainfile(filepath=str(src),use_scripts=False)
def setscene(f):
 sc=bpy.context.scene;sc.frame_set(int(f),subframe=f-int(f));bpy.context.view_layer.update();return sc
def rig(sc):return next(o for o in sc.objects if o.type=='ARMATURE')
def ev(o):
  e=o.evaluated_get(bpy.context.evaluated_depsgraph_get());m=e.to_mesh();m.calc_loop_triangles()
  v=[e.matrix_world@q.co for q in m.vertices];t=[tuple(q.vertices) for q in m.loop_triangles];e.to_mesh_clear();return v,t
def t(o):return BVHTree.FromPolygons(*ev(o),all_triangles=True)
def mesh(sc):
 return {o.name: ([(tuple(v.co),[(g.group,g.weight) for g in v.groups]) for v in o.data.vertices],
                   [(tuple(v.vertices),v.material_index,v.use_smooth) for v in o.data.polygons],
                   [m.name if m else None for m in o.data.materials])
         for o in sc.objects if o.type=='MESH'}
def md(M,N):return max(abs(a-b) for m,n in zip(M,N) for a,b in zip(m,n))
def orbits(sc):
 ctrl=next(o for o in sc.objects if o.name.startswith('CAM CONTROLS'))
 return {k:ctrl[k] for k in ctrl.keys() if k!='_RNA_UI'}
def legs(sc,k,tags):
 return [o for o in sc.objects if o.type=='MESH' and o.name.startswith(tags) and any(g.name in ['thigh.'+k,'shin.'+k,'foot.'+k] for g in o.vertex_groups)]
boot=['Ochre ankle boot','Cream lug outsole','Dark elastic boot inset']
leg=['Thigh to shin']
s=setscene(13); r=rig(s); initial=r.animation_data.action.name
old_actions={x.name for x in bpy.data.actions}
M=mesh(s);cam0=s.camera.matrix_world.copy();controls=orbits(s)
act_objs=[o for o in bpy.data.collections['Gaming Chair Prop'].all_objects if o.type=='MESH']
V={o.name:ev(o)[0] for o in act_objs}
B={b.name:b.matrix.copy() for b in r.pose.bones}
right=leg+boot
Rnames=[o.name for o in legs(s,'R',tuple(right))]
RN={n:ev(s.objects[n])[0] for n in Rnames}
W0=len(t(s.objects['Waist and seat']).overlap(t(next(o for o in act_objs if o.name.startswith('Engine chair')))))
size=len(cand.read_bytes())
bpy.ops.wm.open_mainfile(filepath=str(cand),use_scripts=False)
s=setscene(13);r=rig(s);bs=r.pose.bones
active=r.animation_data.action
assert initial in bpy.data.actions
assert old_actions.issubset({x.name for x in bpy.data.actions})
assert set(c.data_path for c in active.fcurves)=={f'pose.bones["{n}.L"].rotation_euler' for n in ('thigh','shin','foot')}
assert M==mesh(s)
assert controls==orbits(s)
fixed={a:b for a,b in B.items() if a not in ('thigh.L','shin.L','foot.L')}
if 'motion' in cand.name:frames=[1+i*.25 for i in range(193)]
else:frames=[13]
shell=s.objects[next(n for n in V if n.startswith('Engine chair'))]
stand=next(s.objects[n] for n in V if n.startswith('Chair • stationary'))
LP=legs(s,'L',tuple(leg)); LB=legs(s,'L',tuple(boot))
assert len(LP)==1 and len(LB)==4 and len(Rnames)==5
left=LP+LB
const={o.name:t(o) for o in [shell,stand,*[s.objects[n] for n in Rnames],
    *[o for o in s.objects if o.type=='MESH' and o.name.startswith(('Elbow and narrowing','Relaxed blockout','Separate resting','Long ivory varsity sleeve'))]]}
waist=s.objects['Waist and seat'];w0=W0
S_sole=next(n for n in Rnames if n.startswith('Cream lug'))
F_sole=next(o for o in LB if o.name.startswith('Cream lug'))
ankle0=bs['foot.R'].head.copy()
height=min(v.z for v in RN[S_sole])
cols=[]
for f in frames:
 setscene(f)
 errs={n:md(bs[n].matrix,b) for n,b in fixed.items()}
 fixed_err=max(errs.values())
 support=max((a-b).length for n in RN for a,b in zip(RN[n],ev(s.objects[n])[0]))
 chair=max((a-b).length for n in V for a,b in zip(V[n],ev(s.objects[n])[0]))
 cam=md(s.camera.matrix_world,cam0)
 assert fixed_err<1e-6 and support<1e-6 and chair<1e-6 and cam<1e-6,(f,fixed_err,support,chair,cam)
 clash={}
 for o in left:
  a=t(o)
  for k,q in const.items():
   n=len(a.overlap(q))
   if n:clash[o.name+' | '+k]=n
 new_waist=max(0,len(t(waist).overlap(const[shell.name]))-w0)
 assert not clash and not new_waist,(f,clash,new_waist)
 sol=min(v.z for v in ev(F_sole)[0])
 kne=bs['shin.L'].head.copy();an=bs['foot.L'].head.copy();k2=bs['shin.R'].head.copy()
 p,tri=ev(LP[0]);other=const[legs(s,'R',tuple(leg))[0].name]
 low=min((other.find_nearest(v)[3] for v in p if (v-kne).length<.40),default=None)
 assert sol>=height-.008,(f,sol,height)
 cols.append({'f':f,'fixed_bone_error':fixed_err,'support_vertex_error':support,'chair_vertex_error':chair,'camera_error':cam,'top_ankle_world':list(an),'top_knee_world':list(kne),'support_knee_world':list(k2),'top_outsole_over_support':sol-height,'near_contact_gap_BU':low})
row0=cols[0]
hold=min(cols,key=lambda q:abs(q['f']-25))
if 'motion' in cand.name:
 assert abs(hold['f']-25)<1e-9
 assert max(abs(a-b) for a,b in zip(cols[-1]['top_knee_world'],row0['top_knee_world']))<2e-6
 crosses=[q for q in cols if q['top_knee_world'][0]<0]
 ankle_crosses=[q for q in cols if q['top_ankle_world'][0]<0]
 assert crosses[0]['f']<=ankle_crosses[0]['f']
 print('KNEE THEN ANKLE',crosses[0]['f'],ankle_crosses[0]['f'],flush=True)
 print('REOPEN QA',len(cols),hold,flush=True)
assert hold['top_knee_world'][0]<-.20 and abs(hold['top_knee_world'][0]-hold['support_knee_world'][0])<.15
assert hold['top_ankle_world'][2]<hold['support_knee_world'][2]-.12
(P/('reopened-motion.json' if 'motion' in cand.name else 'reopened-endpoint.json')).write_text(json.dumps({'candidate_sha256':sha(cand),'source_sha256':sha(src),'candidate_bytes':size,'raw_mesh_coords_topology_and_weights_identical':True,'saved_camera_values_unchanged':True,'animated_action':active.name,'hold':hold,'rows':cols},indent=2))
