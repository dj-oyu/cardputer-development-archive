import bpy, hashlib, json, os
from pathlib import Path
P=Path(__file__).resolve().parent
names=['worried','surprised','gag','sleepy']
source=P.parent/'chair-knee-cross-v77'/'chair-knee-over-knee-v77-motion.blend'
candidate=Path(bpy.data.filepath)
sha=lambda data:hashlib.sha256(data).hexdigest()
assert sha(source.read_bytes())=='337deaaedae9354ada5e90993327f34d485b5a7ecf3c8bd9e9242a763654f4d5'
def rows():
  scene=bpy.context.scene
  def obj(o):
   return {'geometry':[(list(v.co),[(g.group,g.weight) for g in v.groups]) for v in o.data.vertices],
    'faces':[(list(f.vertices),f.material_index,f.use_smooth) for f in o.data.polygons],
    'materials':[m.name if m else None for m in o.data.materials],
    'UV':{q.name:[list(l.uv) for l in q.data] for q in o.data.uv_layers}}
  def act(a):return [(f.data_path,f.array_index,[(list(k.co),list(k.handle_left),list(k.handle_right),k.interpolation) for k in f.keyframe_points]) for f in a.fcurves]
  def bones(r):return {b.name:(b.parent.name if b.parent else None,[list(z) for z in b.matrix_local],b.length,b.inherit_scale) for b in r.data.bones}
  out={}
  out['objects']={o.name:o.type for o in scene.objects}
  out['mesh']={o.name:obj(o) for o in scene.objects if o.type=='MESH'}
  out['actions']={a.name:act(a) for a in bpy.data.actions}
  out['rig']={r.name:bones(r) for r in scene.objects if r.type=='ARMATURE'}
  out['camera']=(scene.camera.name,[list(q) for q in scene.camera.matrix_world])
  out['timeline']=[scene.frame_current,scene.frame_start,scene.frame_end]
  out['phase_eye']={}
  for n in ('Image Texture','Image Texture.001','Image Texture.002'):
   mat=scene.objects['Sculpted cheeks, jaw and cranium'].data.materials[0]
   q=mat.node_tree.nodes[n]
   out['phase_eye'][n]=sha(bytes(q.image.packed_file.data))
  return out
R=rows();s=bpy.context.scene
mt=s.objects['Sculpted cheeks, jaw and cranium'].data.materials[0]
rig=next(o for o in s.objects if o.type=='ARMATURE')
assert (rig['Face Expression'],rig['Face Blink'],rig['Face Smile'])==(0,0,0)
four={}
for i,n in enumerate(names,1):
  t=mt.node_tree.nodes[f'Expression {i} {n}'].image
  v=sha(bytes(t.packed_file.data))
  assert v==sha((P/'assets'/('face-'+n+'.png')).read_bytes())
  four[n]={'asset_sha256':v,'bytes':len(bytes(t.packed_file.data))}
bpy.ops.wm.open_mainfile(filepath=str(source),use_scripts=False)
S=rows()
assert R==S,[k for k in R if R[k]!=S[k]]
report={'source_sha256':sha(source.read_bytes()),'model_sha256':sha(candidate.read_bytes()),
        'verified_default_state':[0,0,0],'objects':len(R['objects']),'mesh_objects':len(R['mesh']),
        'triangles':sum(sum(len(x[0])-2 for x in d['faces']) for d in R['mesh'].values()),'motion_actions':list(R['actions']),
        'rig_source_preserved':True,'mesh_uv_and_topology_preserved':True,'packed_original_atlases_unchanged':True,
        'new_packed_assets':four}
(P/'reopen-v78.json').write_text(json.dumps(report,indent=2)+'\n')
print('PRESERVATION',json.dumps(report,ensure_ascii=False))
