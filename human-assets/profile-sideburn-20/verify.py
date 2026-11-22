"""Read-only comparison: hair only, textures packed, same rig and motion."""
import bpy,sys,hashlib,json
from pathlib import Path
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def mat(m):return tuple(tuple(row) for row in m)
def load(p):
    bpy.ops.wm.open_mainfile(filepath=str(p),use_scripts=False)
    s=bpy.context.scene;s.frame_set(1)
    dg=bpy.context.evaluated_depsgraph_get()
    hair=bpy.data.collections['Hair – sculpted locks']; objs=set(hair.objects)
    mfs={};tri={};nam={};hgeo={}
    for o in s.objects:
        if o.type!='MESH':continue
        if o not in objs:
            mesh=o.data
            mfs[o.name]=(tuple(tuple(v.co) for v in mesh.vertices),tuple((tuple(p.vertices),p.material_index) for p in mesh.polygons),tuple(tuple((g.group,g.weight) for g in v.groups) for v in mesh.vertices),tuple(x.name for x in mesh.materials),mat(o.matrix_world),tuple((u.name,tuple(tuple(l.uv) for l in u.data)) for u in mesh.uv_layers))
        else:
            hgeo[o.name]=(tuple(tuple(v.co) for v in o.data.vertices),tuple(tuple(p.vertices) for p in o.data.polygons),tuple(tuple((g.group,g.weight) for g in v.groups) for v in o.data.vertices),mat(o.matrix_world),tuple((u.name,tuple(tuple(l.uv) for l in u.data)) for u in o.data.uv_layers))
            oe=o.evaluated_get(dg);m=oe.to_mesh();m.calc_loop_triangles();tri[o.name]=len(m.loop_triangles);oe.to_mesh_clear()
            nam[o.name]=(tuple(m.name for m in o.data.materials),tuple(u.name for u in o.data.uv_layers),sum(any(g.weight>0 for g in v.groups) for v in o.data.vertices)==len(o.data.vertices))
    rig=next(o for o in s.objects if o.type=='ARMATURE')
    poses={}
    for f in (1,8,15,23,30):
        s.frame_set(f);bpy.context.view_layer.update()
        poses[f]={p.name:mat(p.matrix) for p in rig.pose.bones}
    rigdat={b.name:(mat(b.matrix_local),b.parent.name if b.parent else '') for b in rig.data.bones}
    acts={a.name:tuple((f.data_path,f.array_index,tuple(tuple(k.co) for k in f.keyframe_points)) for f in a.fcurves) for a in bpy.data.actions}
    images={i.name:hashlib.sha256(i.packed_file.data).hexdigest() if i.packed_file else None for i in bpy.data.images if i.source not in ('VIEWER',)}
    return (mfs,rigdat,poses,acts,images,tri,nam,{k:rig[k] for k in rig.keys() if k.startswith("Face ")},hgeo)

a,b=(Path(x).resolve() for x in sys.argv[-2:])
x=load(a);y=load(b)
allowed={'Left swept temple curl','Right framing curl'}
assert x[1:8]==y[1:8], 'rig, pose, images, material, flags or hair triangle counts changed'
t='Sculpted cheeks, jaw and cranium'
assert x[0].keys()==y[0].keys()
assert {n for n in x[0] if x[0][n]!=y[0][n]}=={t}
assert x[0][t][1:]==y[0][t][1:]
vx,vy=x[0][t][0],y[0][t][0]
assert sum(a!=b for a,b in zip(vx,vy))==18
assert all(a[0]==b[0] for a,b in zip(vx,vy))
assert x[8].keys()==y[8].keys()
diffs={n for n in x[8] if x[8][n]!=y[8][n]}
assert diffs==allowed,diffs
assert all(x[8][n][1:]==y[8][n][1:] for n in diffs), 'hair topology, weights, transform or UV changed'
print('VERIFY',json.dumps({'base_sha256':digest(a),'candidate_sha256':digest(b),'changed_hair':sorted(diffs),'hair_triangles':sum(y[5].values()),'same_nonhair_meshes':len(y[0]),'bone_count':len(y[1]),'poses':list(y[2])}))
