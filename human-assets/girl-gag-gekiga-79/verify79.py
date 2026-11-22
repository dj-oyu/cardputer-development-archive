import bpy,hashlib,json
from pathlib import Path
P=Path(__file__).resolve().parent
source=P.parent/'chair-character-expressions-v78'/'girl-expressions-and-emotes-v78.blend'
candidate=Path(bpy.data.filepath)
sha=lambda b:hashlib.sha256(b).hexdigest()
assert sha(source.read_bytes())=='61f1f78cd004c922e0f0ad2833bb1a5d08da6dd38156d51dc548863b0283ecb8'
def curves(a):
 return [(f.data_path,f.array_index,tuple((tuple(k.co),tuple(k.handle_left),tuple(k.handle_right),k.interpolation) for k in f.keyframe_points)) for f in a.fcurves]
def dsign(o):
 a=o.animation_data
 if a is None:return []
 return [(f.data_path,f.array_index,f.driver.type,f.driver.expression,[(v.name,v.type,[(t.id.name if t.id else None,t.data_path) for t in v.targets]) for v in f.driver.variables]) for f in a.drivers]
slots=[]
def inspect():
 s=bpy.context.scene;r=next(o for o in s.objects if o.type=='ARMATURE');m=s.objects['Sculpted cheeks, jaw and cranium'].active_material
 nt=m.node_tree
 er=[o for o in s.objects if o.name.startswith('Comic emote • ')]
 assert len(er)==3
 objs={o.name:(o.type,tuple(tuple(q) for q in o.matrix_world),dsign(o)) for o in s.objects}
 meshes={}
 for o in s.objects:
  if o.type=='MESH':
   g=o.data
   meshes[o.name]={'v':[(tuple(v.co),tuple((t.group,t.weight) for t in v.groups)) for v in g.vertices],
    'conn':[tuple(f.vertices) for f in g.polygons],'m':[(f.material_index,f.use_smooth) for f in g.polygons],
    'uv':{q.name:tuple(tuple(t.uv) for t in q.data) for q in g.uv_layers},'ms':[a.name if a else None for a in g.materials]}
 packed={n.name:sha(bytes(n.image.packed_file.data)) for n in nt.nodes if n.type=='TEX_IMAGE' and n.image and n.image.packed_file}
 slots.append(packed.pop('Expression 3 gag'))
 ties=sorted((l.from_node.name,l.from_socket.identifier,l.to_node.name,l.to_socket.identifier) for l in nt.links)
 actions={a.name:curves(a) for a in bpy.data.actions}
 props=dict(r.items())
 subs={}
 for i in range(4):
  r['Comic Emote']=i;r.update_tag();s.frame_set(25);bpy.context.view_layer.update()
  deps=bpy.context.evaluated_depsgraph_get()
  active=[]
  for o in er:
   q=o.evaluated_get(deps)
   if q.hide_render or q.scale.x<=0:continue
   active.append((o.name,tuple(tuple(t) for t in q.matrix_world)))
  subs[i]=active
  assert len(active)==int(i>0)
 return {'objs':objs,'meshes':meshes,'rig':{b.name:(b.inherit_scale,tuple(tuple(q) for q in b.matrix_local)) for b in r.data.bones},'actions':actions,'props':props,'face_drivers':dsign(nt),'face_links':ties,'packed_unchanged':packed,'emote_pose':subs}
a=inspect();bpy.ops.wm.open_mainfile(filepath=str(source),use_scripts=False);b=inspect()
assert not [q for q in a if a[q]!=b[q]],[q for q in a if a[q]!=b[q]]
assert slots[0]==sha((P/'assets'/'face-gekiga.png').read_bytes()) and slots[0]!=slots[1]
print('Reopen comparison: only active gag atlas changed; 4 comic selector poses identical.')
(P/'v79-reopen.json').write_text(json.dumps({'source_sha256':sha(source.read_bytes()),'v79_sha256':sha(candidate.read_bytes()),'texture_v78_sha256':slots[1],'texture_v79_sha256':slots[0],
 'objects':len(a['objs']),'rig_bones':len(a['rig']),'meshes':len(a['meshes']),'raw_triangles':sum(sum(len(c)-2 for c in m['conn']) for m in a['meshes'].values()),'unchanged':list(a.keys())},ensure_ascii=False,indent=2)+'\n')
