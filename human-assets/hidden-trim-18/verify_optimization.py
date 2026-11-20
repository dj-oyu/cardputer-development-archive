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
a,b=(Path(x).resolve() for x in sys.argv[-3:-1])
mode=sys.argv[-1]
x=load(a);y=load(b)
assert x[1:5]==y[1:5] and x[7]==y[7], 'rig, action, packed image or face switch changed'
assert x[0].keys()==y[0].keys() and x[8].keys()==y[8].keys()
nonhair_changed=sorted(n for n in x[0] if x[0][n]!=y[0][n])
hair_changed=sorted(n for n in x[8] if x[8][n]!=y[8][n])
assert nonhair_changed==(['Sculpted cheeks, jaw and cranium'] if mode=='combined' else []),nonhair_changed
assert hair_changed==['Large right side-sweep','Left wide brushed fringe'],hair_changed
assert len(y[5])==6 and all(v[2] for v in y[6].values())
assert {n:x[5][n]-y[5][n] for n in x[5] if x[5][n]!=y[5][n]} and sum(x[5].values())>sum(y[5].values())
print('VERIFY',json.dumps({'src_sha256':digest(a),'out_sha256':digest(b),'changed_nonhair':nonhair_changed,'changed_hair':hair_changed,'hair_tris_before':x[5],'hair_tris_after':y[5],'bones':len(y[1]),'frames':list(y[2]),'packed_images':len(y[4])},ensure_ascii=False))
