"""Armrest-only surface simplification. Scope: known fixed seated/swivel pose."""
import bpy,sys,os,json
from pathlib import Path
from mathutils import Vector
from mathutils.bvhtree import BVHTree
P=Path(__file__).resolve().parent
mode=os.getenv('ARMS_MODE','cross')
coll=bpy.data.collections['Gaming Chair Prop'];o=next(o for o in coll.objects if o.name.startswith('Engine chair • shell'));m=o.data
def arm_cap(v):
    x,y,z=v;return abs(x)>.74 and -.65<y<-.16 and 1.88<z<1.96
def arm_support(v):
    x,y,z=v;return .76<abs(x)<.90 and -.44<y<-.27 and 1.31<z<1.90
cap=[p for p in m.polygons if p.material_index==3 and all(arm_cap(m.vertices[i].co) for i in p.vertices)]
support=[p for p in m.polygons if p.material_index==2 and all(arm_support(m.vertices[i].co) for i in p.vertices)]
assert sum(len(p.vertices)-2 for p in cap) in (24,56) and sum(len(p.vertices)-2 for p in support)==16
skip={p.index for p in cap+support}
used=set(i for p in m.polygons if p.index not in skip for i in p.vertices)
spans=lambda ps,s:[[min(k) for k in zip(*vs)],[max(k) for k in zip(*vs)]] if (vs:=[list(m.vertices[i].co) for p in ps for i in p.vertices if s*m.vertices[i].co.x>0]) else None
V=[];F=[];M=[];S=[];renumber={}
for vi in sorted(used):renumber[vi]=len(V);V.append(m.vertices[vi].co[:])
for p in m.polygons:
    if p.index in skip:continue
    F.append(tuple(renumber[i] for i in p.vertices));M.append(p.material_index);S.append(p.use_smooth)
old_count=len(F)
new_parts={'yellow_top':[],'yellow_outer':[],'yellow_front':[],'yellow_rear':[],'metal_panels':[]}
new_face_pts={}
def quad(role,v,mat):
    new_face_pts[len(F)]=v
    lookup={tuple(z):i for i,z in enumerate(V)}
    xs=[]
    for pt in v:
        pt=tuple(pt)
        if pt not in lookup:lookup[pt]=len(V);V.append(pt)
        xs.append(lookup[pt])
    F.append(tuple(xs));M.append(mat);S.append(False);new_parts[role].append(len(F)-1)
for side in (-1,1):
    l,h=spans(cap,side); a,d=spans(support,side)
    x0,y0,z0=l; x1,y1,z1=h
    sideX=x1 if side>0 else x0
    quad('yellow_top',[(x0,y0,z1),(x1,y0,z1),(x1,y1,z1),(x0,y1,z1)],3)
    if mode!='bare':
        if side>0:
            quad('yellow_outer',[(sideX,y0,z0),(sideX,y1,z0),(sideX,y1,z1),(sideX,y0,z1)],3)
        else:
            quad('yellow_outer',[(sideX,y1,z0),(sideX,y0,z0),(sideX,y0,z1),(sideX,y1,z1)],3)
    if mode=='end':
        quad('yellow_front',[(x0,y0,z0),(x1,y0,z0),(x1,y0,z1),(x0,y0,z1)],3)
    if mode in ('diag','rails'):
        outer=sideX; inner=x0 if side>0 else x1
        pts=[(outer,y1,z0),(outer,y1,z1),(inner,y1,z1)]
        quad('yellow_rear',pts if side>0 else pts[::-1],3)
        if mode=='rails':
            pts=[(outer,y0,z0),(inner,y0,z1),(outer,y0,z1)]
            quad('yellow_front',pts if side>0 else pts[::-1],3)
    x,y,z=a; X,Y,Z=d
    xy=[((x,y),(X,Y))] if side==-1 else [((x,Y),(X,y))]
    if mode=='cross':xy += [((x,Y),(X,y))] if side==-1 else [((x,y),(X,Y))]
    if mode=='rails':
        # Midpoint planar z support projects at both +/- 35° with no edge-on collapse.
        ym=(y+Y)/2
        xy=[((x,ym),(X,ym))]
    for (xx,yy),(XX,YY) in xy:
        # Planar supports tucked within original open four-side envelope; painted metal.
        quad('metal_panels',[(xx,yy,z),(XX,YY,z),(XX,YY,Z),(xx,yy,Z)],2)
    if mode=='diag':
        (u,v),(U,V1)=((x,Y),(X,y)) if side==-1 else ((x,y),(X,Y))
        mid=((U+u)/2,(V1+v)/2,Z)
        quad('metal_panels',[(u,v,z),(U,V1,z),mid],2)
new=bpy.data.meshes.new(m.name+' • minimal arm panels '+mode)
new.from_pydata(V,[],F);new.update()
for q in m.materials:new.materials.append(q)
for p,i,sm in zip(new.polygons,M,S):p.material_index=i;p.use_smooth=sm
assert tuple((p.material_index,p.use_smooth,tuple(tuple(m.vertices[i].co) for i in p.vertices)) for p in m.polygons if p.index not in skip)==tuple((p.material_index,p.use_smooth,tuple(tuple(new.vertices[i].co) for i in p.vertices)) for p in new.polygons if p.index<old_count)
o.data=new
arm_count=sum(len(new.polygons[j].vertices)-2 for j in new_face_pts)
assert arm_count=={'cross':16,'diag':16,'rails':16,'end':16,'lean':12,'bare':8}[mode]
def mesh_tree(e,arm=False,indices=None):
    dg=bpy.context.evaluated_depsgraph_get();ex=e.evaluated_get(dg);mesh=ex.to_mesh();mesh.calc_loop_triangles()
    v=[ex.matrix_world@g.co for g in mesh.vertices]
    t=[tuple(l.vertices) for l in mesh.loop_triangles if indices is None or l.polygon_index in indices]
    ex.to_mesh_clear()
    return BVHTree.FromPolygons(v,t,all_triangles=True) if t else None
thr=mesh_tree(o,indices=set(new_face_pts)); hand={}
for z in bpy.context.scene.objects:
    if z.type=='MESH' and z!=o and any(w in z.name.lower() for w in ('sleeve','forearm','thumb','fist','hand','cuff')) and 'handle' not in z.name.lower():
        other=mesh_tree(z)
        if other:hand[z.name]=len(thr.overlap(other))
assert not any(hand.values()),hand
def tris(x):
    x.data.calc_loop_triangles();return len(x.data.loop_triangles)
total=sum(tris(z) for z in coll.all_objects if z.type=='MESH')
s=bpy.context.scene;s['v68_arm_panels']='Raise no other changes. Two-sided amber top/lip and black support panels; open surfaces, fixed-light/view intended; keep original v66 closed master.'
summary={'mode':mode,'arm_triangles':arm_count,'chair_triangles':total,'source':bpy.data.filepath,'only_replaced_material_indexes':[2,3],
    'new_components':{k:sum(len(new.polygons[j].vertices)-2 for j in q) for k,q in new_parts.items()},'hand_bvh_overlap_pair_count':hand,'non_arm_faces_exact':old_count,
    'part_roles_bound_sides':{'left':spans(cap,-1),'right':spans(cap,1)}}
(P/f'{mode}-receipt.json').write_text(json.dumps(summary,indent=2)+'\n')
bpy.context.preferences.filepaths.save_version=0;bpy.ops.wm.save_as_mainfile(filepath=str(P/'chair-opaque-combined-200.blend'),compress=True)
print(summary)
