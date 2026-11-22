"""Reopen neck variants and quantify material-free clearance over authored frames."""
import bpy, sys,json,math,hashlib
from pathlib import Path
from mathutils.bvhtree import BVHTree
from mathutils import Quaternion, Vector

def xyz(v):return tuple(round(float(a),7) for a in v)
def rest(b):return (xyz(b.head_local),xyz(b.tail_local),b.parent.name if b.parent else None,b.use_connect)
def pack_mesh(ob,d):
 ev=ob.evaluated_get(d); me=ev.to_mesh();me.calc_loop_triangles()
 vs=[ev.matrix_world@v.co for v in me.vertices]
 fs=[tuple(t.vertices) for t in me.loop_triangles]
 ev.to_mesh_clear()
 return vs,fs

def merge(meshes):
 vs=[]; fs=[]
 for v,f in meshes:
  i=len(vs);vs+=v;fs.extend(tuple(j+i for j in p) for p in f)
 return BVHTree.FromPolygons(vs,fs,all_triangles=True),vs

def inspect(path):
 bpy.ops.wm.open_mainfile(filepath=str(path.resolve()),use_scripts=False)
 s=bpy.context.scene;s.frame_set(1)
 r=next(o for o in s.objects if o.type=='ARMATURE')
 a=r.animation_data.action
 keys=[(f.data_path,f.array_index,[(xyz(k.co),k.interpolation) for k in f.keyframe_points]) for f in a.fcurves]
 body=[o for o in s.objects if o.type=='MESH' and (o.name.startswith(('Upturned jacket lapel','Open jacket front binding','Ivory scoop binding','Soft ivory tee base','Jacket cut front and back','Long ivory varsity sleeve')))]
 h=[o for o in s.objects if o.type=='MESH' and any('Hair' in c.name for c in o.users_collection)]
 face=[bpy.data.objects['Sculpted cheeks, jaw and cranium']]
 neck=[bpy.data.objects['Neck']]
 def measure():
  bpy.context.view_layer.update();d=bpy.context.evaluated_depsgraph_get()
  B,_=merge([pack_mesh(o,d) for o in body]);F,fv=merge([pack_mesh(o,d) for o in face]);H,_=merge([pack_mesh(o,d) for o in h]);N,nv=merge([pack_mesh(o,d) for o in neck])
  # Minimum vertex-to-surface clearance for head and garment; overlap catches triangle crossings.
  gap=min(B.find_nearest(v)[3] for v in fv)
  return {'face_garment_overlap':len(F.overlap(B)), 'face_garment_min_vertex_clearance':round(gap,6),'hair_garment_overlap':len(H.overlap(B)), 'neck_garment_overlap':len(N.overlap(B)),'jaw_min_z':round(min(v.z for v in fv),6)}
 poses={}
 for frame in range(s.frame_start,s.frame_end+1):
  s.frame_set(frame)
  poses[frame]=measure()
 # The authored limb checks do not exercise a head turn; sample separately.
 stress={}
 for yaw,pitch in [(-20,0),(20,0),(0,-12),(0,12),(-20,-12),(20,-12)]:
  s.frame_set(1)
  head=r.pose.bones['head']
  base=head.matrix_basis.copy()
  q=Quaternion((0,1,0),math.radians(yaw))@Quaternion((1,0,0),math.radians(pitch))
  head.matrix_basis=base@q.to_matrix().to_4x4()
  stress[f'{yaw}/{pitch}']=measure()
  head.matrix_basis=base
 images={i.name:hashlib.sha256(i.packed_file.data).hexdigest() for i in bpy.data.images if i.packed_file}
 return {'bones':{b.name:rest(b) for b in r.data.bones},'keys':keys,'poses':poses,'stress':stress,'packed_images':images,'uvs':[[uv.name,[xyz(x.uv) for x in uv.data]] for uv in face[0].data.uv_layers]}

src,out,report=map(Path,sys.argv[-3:]); A=inspect(src);B=inspect(out)
assert A['keys']==B['keys'] and A['uvs']==B['uvs'] and A['packed_images']==B['packed_images']
assert A['bones'].keys()==B['bones'].keys()
assert all(A['bones'][n]==B['bones'][n] for n in A['bones'] if n not in ('head','neck'))
out_info={'independent_frames':len(B['poses']),'bones':len(B['bones']),'action_curves_unchanged':len(B['keys']),'face_uv_unchanged':True,'face_min_garment_clearance_before':min(x['face_garment_min_vertex_clearance'] for x in A['poses'].values()),'face_min_garment_clearance_after':min(x['face_garment_min_vertex_clearance'] for x in B['poses'].values()),'packed_images_unchanged':B['packed_images'],'base':A['poses'],'adjusted':B['poses'],'stress_before':A['stress'],'stress_after':B['stress']}
report.write_text(json.dumps(out_info,indent=2)+'\n')
print('VERIFY '+json.dumps({k:v for k,v in out_info.items() if k not in ('base','adjusted')}))
