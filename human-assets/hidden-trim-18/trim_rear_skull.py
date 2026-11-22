"""Dissolve a rear skull grid under a genuinely closed, co-skinned hair cap."""
from pathlib import Path
import bpy,bmesh,sys,json,hashlib,math
from mathutils import Vector
from mathutils.bvhtree import BVHTree
src,dst=map(Path,sys.argv[-2:]);src,dst=src.resolve(),dst.resolve()
bpy.ops.wm.open_mainfile(filepath=str(src))
s=bpy.context.scene;s.frame_set(1);bpy.context.view_layer.update()
d=bpy.context.evaluated_depsgraph_get()
sk=bpy.data.objects['Sculpted cheeks, jaw and cranium']; cap=bpy.data.objects['Bob back mass']
assert len(sk.data.vertices)==160 and len(sk.data.polygons)==142, 'Unexpected authored skull topology'
for o in (sk,cap):
 assert all(len(v.groups)==1 and o.vertex_groups[v.groups[0].group].name=='head' and v.groups[0].weight==1. for v in o.data.vertices)
 assert len(o.modifiers)==1 and o.modifiers[0].type=='ARMATURE'
 assert o.modifiers[0].object==sk.modifiers[0].object
 assert o.modifiers[0].use_deform_preserve_volume==sk.modifiers[0].use_deform_preserve_volume
 h=bmesh.new();h.from_mesh(o.data);assert all(e.is_manifold for e in h.edges);h.free()
cap.data.calc_loop_triangles();sk.data.calc_loop_triangles()
cap_pts=[cap.matrix_world@v.co for v in cap.data.vertices]
cap_tri=[tuple(f.vertices) for f in cap.data.loop_triangles]
cap_bvh=BVHTree.FromPolygons(cap_pts,cap_tri,all_triangles=True)
sk_pts=[sk.matrix_world@v.co for v in sk.data.vertices]
idx={frozenset(p.vertices):p.index for p in sk.data.polygons}
directions=[Vector(v).normalized() for v in [(1,.219,-.107),(-.125,1,.159),(.103,-.177,1)]]
margin=.012
count=0
def inside(p):
 for v in directions:
  start=p.copy();hits=0
  while hits<28:
   hit,_,_,_=cap_bvh.ray_cast(start,v,15)
   if hit is None:break
   hits+=1;start=hit+.00005*v
  if hits%2!=1:return False
 return True
def certify(a,b,c,depth=0):
 global count
 center=(a+b+c)/3
 radius=max((center-p).length for p in (a,b,c))
 there,_,_,dist=cap_bvh.find_nearest(center)
 count+=1
 if there is None or dist<=margin or not inside(center):return False
 # Once nearest-triangle distance exceeds the subtriangle radius + margin,
 # the entire subtriangle is inside, not just the sample point.
 if dist>=radius+margin:return True
 if depth>=7:return False
 ab=(a+b)/2;bc=(b+c)/2;ca=(c+a)/2
 return all(certify(*vs,depth+1) for vs in [(a,ab,ca),(ab,b,bc),(ca,bc,c),(ab,bc,ca)])
def points(mesh):
 mesh.calc_loop_triangles()
 return [(t.polygon_index,[sk.matrix_world@mesh.vertices[i].co for i in t.vertices]) for t in mesh.loop_triangles]
safe={}
for row in range(1,7):
 for c in range(1,9):
  ids=[row*20+c,row*20+c+1,(row+1)*20+c,(row+1)*20+c+1]
  if any(sk_pts[i].y<.11 or abs(sk_pts[i].x)>.395 or sk_pts[i].z<4.26 for i in ids):continue
  safe[row,c]=idx[frozenset(ids)]
oldtri=points(sk.data)
byidx={}
for fi,ts in oldtri:byidx.setdefault(fi,[]).append(ts)
safe={p:i for p,i in safe.items() if all(certify(*t) for t in byidx[i])}
candidates=[]
for r0 in range(1,6):
 for r1 in range(r0+2,8):
  for c0 in range(1,8):
   for c1 in range(c0+2,10):
    keys=[(r,c) for r in range(r0,r1) for c in range(c0,c1)]
    if all(k in safe for k in keys):
     candidates.append(((r1-r0-1)*(c1-c0-1),r0,r1,c0,c1,[safe[k] for k in keys]))
candidates.sort(reverse=True)
oldmesh=sk.data; original_tri=len(oldtri)
old_coords=set(tuple(sk.matrix_world@v.co) for v in oldmesh.vertices)
for _,r0,r1,c0,c1,ids in candidates:
 b=bmesh.new();b.from_mesh(oldmesh);b.faces.ensure_lookup_table()
 face_id=b.faces.layers.int.new('RearCapEvidence')
 for f in b.faces:f[face_id]=0
 # Dissolve, removing interior edges/verts and retaining the exact ring of
 # boundary vertices and existing UVs on all unmodified surrounding faces.
 merged=bmesh.ops.dissolve_faces(b,faces=[b.faces[i] for i in ids],use_verts=True)['region']
 if len(merged)!=1 or not isinstance(merged[0],bmesh.types.BMFace):
  b.free();continue
 fill=merged[0];fill[face_id]=1
 # All caps are currently at y>=.11, where the projected-face mask is zero.
 # Give it a stable existing skin/material slot and no visual dependency.
 fill.smooth=True
 mm=oldmesh.copy();b.to_mesh(mm);b.free();mm.update()
 reg=mm.attributes['RearCapEvidence']
 replacement=[t for i,t in points(mm) if reg.data[i].value==1]
 if not replacement or not all(certify(*t) for t in replacement):
  bpy.data.meshes.remove(mm);continue
 # Preserve untouched face UV corner coordinates. Polygon order can change.
 def snap(m,name):
  uv=m.uv_layers['FaceGraphic_Ortho_512'];res={}
  for f in m.polygons:
   k=frozenset(tuple(m.vertices[i].co) for i in f.vertices)
   if name is not None and any(name(f)):continue
   res[k]={tuple(m.vertices[m.loops[l].vertex_index].co):tuple(uv.data[l].uv) for l in f.loop_indices}
  return res
 before=snap(oldmesh,lambda f:[f.index in ids])
 after=snap(mm,lambda f:[reg.data[f.index].value==1])
 if before!=after:
  bpy.data.meshes.remove(mm);continue
 assert set(tuple(sk.matrix_world@v.co) for v in mm.vertices)<=old_coords
 sk.data=mm
 mm.attributes.remove(reg);mm.calc_loop_triangles()
 b=bmesh.new();b.from_mesh(mm);assert all(e.is_manifold for e in b.edges);b.free()
 d.update();eo=sk.evaluated_get(d);em=eo.to_mesh();em.calc_loop_triangles()
 after_eval=len(em.loop_triangles);eo.to_mesh_clear()
 assert after_eval<original_tri
 ev={'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'mesh_only':sk.name,
     'original_vertices':len(oldmesh.vertices),'post_vertices':len(mm.vertices),
     'original_triangles':original_tri,'post_evaluated_triangles':after_eval,'saved_evaluated_triangles':original_tri-after_eval,
     'old_removed_faces':ids,'ring_depth':list(range(r0,r1+1)),'rear_sections':list(range(c0,c1+1)),
     'unmodified_face_uv_maps_exact':len(before),'cap_triangles':len(replacement),'minimum_hair_enclosure_margin':margin,
     'certification_queries':count,'enclosing_hair':cap.name,'inherits_identical_head_skinning':True,
     'hair_shape_watertight':True,'note':'Closed Bob bounds certify every point of removed triangles and replacement cap in rest coordinates; both meshes rigidly share the head bone.'}
 dst.parent.mkdir(exist_ok=True,parents=True)
 bpy.ops.wm.save_as_mainfile(filepath=str(dst),compress=True)
 ev['output_sha256']=hashlib.sha256(dst.read_bytes()).hexdigest()
 (dst.parent/'skull-trim-evidence.json').write_text(json.dumps(ev,indent=2)+'\n')
 print(ev);break
else:raise RuntimeError('No fully enclosed capped reduction, refusing to save a candidate')
