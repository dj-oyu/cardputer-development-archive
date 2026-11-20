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
    lighting={o.name:(o.data.type,o.data.energy,tuple(o.data.color),mat(o.matrix_world),bool(o.hide_render)) for o in s.objects if o.type=='LIGHT'}
    world=tuple((n.name, tuple(n.inputs[0].default_value), float(n.inputs[1].default_value)) for n in s.world.node_tree.nodes if n.type=='BACKGROUND')
    return (mfs,rigdat,poses,acts,images,tri,nam,lighting,world)
a,b=(Path(x).resolve() for x in sys.argv[-2:])
x=load(a);y=load(b)
assert x[1:4]==y[1:4] and x[5]==y[5] and x[7:]==y[7:], 'animation, hair triangles or source scene lighting changed'
assert set(x[0])==set(y[0])
for n,ao in x[0].items():
    bo=y[0][n]
    if n not in x[5]:assert ao==bo,n
    else:assert ao[:3]+ao[4:]==bo[:3]+bo[4:] and bo[3]==('Hair · chestnut and real contact only',),n
assert {n:v for n,v in x[4].items() if n.startswith('Packed face')}==y[4] and len(y[4])==4
m=bpy.data.materials['Hair · chestnut and real contact only']
assert not any(n.type=='TEX_IMAGE' for n in m.node_tree.nodes)
node=m.node_tree.nodes['Contact geometry']
mix=m.node_tree.nodes['Chestnut contact mix']
assert node.type=='AMBIENT_OCCLUSION' and not node.only_local
assert abs(node.inputs['Distance'].default_value-.095)<1e-6
assert abs(mix.inputs[0].default_value-.78)<1e-6
print('VERIFY',json.dumps({'src_sha256':digest(a),'out_sha256':digest(b),'all_mesh_geometry_exact':len(y[0]),'hair_unchanged_triangles':sum(y[5].values()),'bones':len(y[1]),'light_setup_exact':True,'face_image_byte_hashes':y[4],'ao_distance_BU':node.inputs['Distance'].default_value,'ao_mix':mix.inputs[0].default_value},ensure_ascii=False))
