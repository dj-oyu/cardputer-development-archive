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
            mesh=o.data
            mfs[o.name]=(tuple(tuple(v.co) for v in mesh.vertices),tuple((tuple(p.vertices),p.material_index) for p in mesh.polygons),tuple(tuple((g.group,g.weight) for g in v.groups) for v in mesh.vertices),tuple(x.name for x in mesh.materials),mat(o.matrix_world),tuple((u.name, tuple(tuple(x.uv) for x in u.data)) for u in mesh.uv_layers))
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
assert x[1:]==y[1:], 'images, bone/actions/motion, hair material slots, or triangle count changed'
assert set(x[0])==set(y[0])
changed=[n for n in x[0] if x[0][n]!=y[0][n]]
assert changed==['Bob back mass'],changed
a0,b0=(i[0]['Bob back mass'] for i in (x,y))
assert a0[1:]==b0[1:], 'topology, weights, material assignment, transform or UV changed'
deltas=[]
for v,w in zip(a0[0],b0[0]):
    assert v[1:]==w[1:]
    if v[2]<=4.43 or v[2]>=5.10 or v[1]<=-.10 or abs(v[0])<=.35:
        assert v==w
    if v!=w:
        assert abs(w[0])<abs(v[0]) and abs(v[0]-w[0])<.05
        deltas.append(abs(v[0]-w[0]))
assert deltas
print('VERIFY',json.dumps({'src_sha256':digest(a),'out_sha256':digest(b),'cap_vertices_changed':len(deltas),'max_shift_BU':max(deltas),'hair_parts':len(y[5]),'hair_triangles':sum(y[5].values()),'unchanged_other_meshes':len(y[0])-1,'bones':len(y[1]),'same_images':len(y[4]),'verified_frames':list(y[2])},ensure_ascii=False))
