"""Proof of grouped detail source: exact noncap state and selected pose overlap checks."""
import bpy,sys,hashlib,json,math
from pathlib import Path
from mathutils import Euler
from mathutils.bvhtree import BVHTree
a,b=(Path(x).resolve() for x in sys.argv[-2:])
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def mat(m):return tuple(tuple(row) for row in m)
def load(p):
 bpy.ops.wm.open_mainfile(filepath=str(p),use_scripts=False)
 s=bpy.context.scene;s.frame_set(1);bpy.context.view_layer.update()
 rig=next(o for o in s.objects if o.type=='ARMATURE')
 cap=bpy.data.objects['Bob back mass'];hair=list(bpy.data.collections['Hair – sculpted locks'].objects)
 exact={}
 for o in s.objects:
  if o.type!='MESH' or o==cap:continue
  m=o.data
  exact[o.name]=(tuple(tuple(v.co) for v in m.vertices),tuple(tuple(p.vertices) for p in m.polygons),tuple(tuple((g.group,g.weight) for g in v.groups) for v in m.vertices),tuple(a.name for a in m.materials),mat(o.matrix_world),tuple((u.name,tuple(tuple(v.uv) for v in u.data)) for u in m.uv_layers))
 rigdata={b.name:(mat(b.matrix_local),b.parent.name if b.parent else '') for b in rig.data.bones}
 keys={a.name:tuple((f.data_path,f.array_index,tuple((tuple(k.co),tuple(k.handle_left),tuple(k.handle_right),k.interpolation) for k in f.keyframe_points)) for f in a.fcurves) for a in bpy.data.actions}
 face_maps={i.name:hashlib.sha256(i.packed_file.data).hexdigest() if i.packed_file else None for i in bpy.data.images}
 poses={}
 for f in (1,8,15,23,30):
   s.frame_set(f);bpy.context.view_layer.update()
   poses[f]={p.name:mat(p.matrix) for p in rig.pose.bones}
 s.frame_set(1)
 # Head pose in a detached evaluation copy only; not written to disk.
 h=rig.pose.bones['head'];start=h.matrix_basis.copy()
 contacts={}
 for name,r in (('neutral',(0,0,0)),('tilt_left',(0,17,0)),('tilt_right',(0,-17,0)),('look_up',(15,0,0)),('look_down',(-15,0,0))):
   h.matrix_basis=start@Euler(tuple(math.radians(i) for i in r)).to_matrix().to_4x4()
   bpy.context.view_layer.update();dg=bpy.context.evaluated_depsgraph_get()
   def tree(o):
      e=o.evaluated_get(dg);m=e.to_mesh();m.calc_loop_triangles()
      ts=[tuple(t.vertices) for t in m.loop_triangles];v=[e.matrix_world@v.co for v in m.vertices];e.to_mesh_clear()
      return BVHTree.FromPolygons(v,ts,all_triangles=True),ts
   ct,_=tree(cap)
   objs=[o for o in s.objects if o.type=='MESH' and (o.name=='Neck' or 'collar' in o.name.lower() or 'lapel' in o.name.lower())]
   contacts[name]={o.name:len(ct.overlap(tree(o)[0])) for o in objs}
   if name=='neutral':
      _,ts=tree(cap)
      selfcross=sum(1 for i,j in ct.overlap(ct) if i<j and not (set(ts[i])&set(ts[j])))
 m=cap.data
 assert m.uv_layers.get('MoldedHair_PaintedFlow') and len(m.uv_layers[0].data)==len(m.loops)
 assert all(tuple((cap.vertex_groups[g.group].name, g.weight) for g in v.groups)==(('head',1.0),) for v in m.vertices)
 m.materials[0].node_tree.nodes['Contact geometry']
 def tris(o):
   o.data.calc_loop_triangles();return len(o.data.loop_triangles)
 return (exact,rigdata,keys,face_maps,poses,contacts,{o.name:tris(o) for o in hair},selfcross)
x,y=load(a),load(b)
assert x[:5]==y[:5], 'noncap data changed'
assert set(x[6])==set(y[6]) and len(y[6])==6
assert all(x[6][n]==k for n,k in y[6].items() if n!='Bob back mass')
assert y[7]<=x[7],(x[7],y[7])
# Avoid any newly introduced cap intersection with a neck/collar surface.
assert not [(p,n) for p,co in y[5].items() for n,c in co.items() if c and not x[5][p][n]]
print('VERIFY '+json.dumps({'base_sha256':digest(a),'output_sha256':digest(b),'untouched_meshes':len(y[0]),'unchanged_face_maps':len(y[3]),'bone_count':len(y[1]),'verified_frames':list(y[4]),'hair_breakdown':y[6],'hair_total_triangles':sum(y[6].values()),'cap_self_intersection_pairs_before_after':[x[7],y[7]],'cap_contacts_before':x[5],'cap_contacts_after':y[5]}))
