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
    mfs={};tri={};nam={}
    for o in s.objects:
        if o.type!='MESH':continue
        if o not in objs:
            mesh=o.data
            mfs[o.name]=(tuple(tuple(v.co) for v in mesh.vertices),tuple((tuple(p.vertices),p.material_index) for p in mesh.polygons),tuple(tuple((g.group,g.weight) for g in v.groups) for v in mesh.vertices),tuple(x.name for x in mesh.materials),mat(o.matrix_world),tuple(u.name for u in mesh.uv_layers))
        else:
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
    return (mfs,rigdat,poses,acts,images,tri,nam)
a,b=(Path(x).resolve() for x in sys.argv[-2:])
x=load(a);y=load(b)
assert x[:4]==y[:4], 'nonhair mesh, armature, or motion changed'
assert all(y[4].get(n)==h for n,h in x[4].items()),'existing packed images changed'
new_images={n:h for n,h in y[4].items() if n not in x[4]}
assert len(new_images)==len(y[5])==7 and all(new_images.values()),new_images
assert all(v[2] and 'MoldedHair_PaintedFlow' in v[1] for v in y[6].values()),y[6]
print('VERIFY',json.dumps({'src_sha256':digest(a),'out_sha256':digest(b),'nonhair_meshes_unchanged':len(y[0]),'bones_unchanged':len(y[1]),'verified_frames':list(y[2]),'total_hair_tris_before':sum(x[5].values()),'total_hair_tris_after':sum(y[5].values()),'hair_part_count_before':len(x[5]),'hair_part_count_after':len(y[5]),'packed_albedo_images':new_images},ensure_ascii=False))
