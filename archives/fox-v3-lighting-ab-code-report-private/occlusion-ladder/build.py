import bpy,json,pathlib,hashlib,struct,copy
R=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');O=R/'fox-v3-occlusion-reduction';S=R/'fox-reference-sculpt-private/fox-reference-standing-editable.blend';B=R/'fox-v3-ground-transport/le-001/inputs/geometry-source-sided.glb'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(S)=='9254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806'
names=['Muzzle pad -1','Muzzle pad 1','Smile -1','Smile 1']
def read(p):
 b=p.read_bytes();n=struct.unpack_from('<I',b,12)[0];d=json.loads(b[20:20+n]);bl=struct.unpack_from('<I',b,20+n)[0];return d,b[28+n:28+n+bl]
def write(p,d,b):
 d['buffers'][0]['byteLength']=len(b);j=json.dumps(d,separators=(',',':')).encode();j+=b' '*((-len(j))%4);b+=b'\0'*((-len(b))%4);p.write_bytes(struct.pack('<III',0x46546c67,2,28+len(j)+len(b))+struct.pack('<II',len(j),0x4e4f534a)+j+struct.pack('<II',len(b),0x004e4942)+b)
def patch(path,tag):
 base,bb=read(B);d,b=read(path);out=copy.deepcopy(base);offset=len(bb);assert offset%4==0;vo=len(out['bufferViews']);ao=len(out['accessors'])
 for v in d['bufferViews']:
  v=copy.deepcopy(v);v['byteOffset']=v.get('byteOffset',0)+offset;out['bufferViews'].append(v)
 for a in d['accessors']:
  a=copy.deepcopy(a);a['bufferView']+=vo;out['accessors'].append(a)
 changed=[]
 for n in d['nodes']:
  if 'mesh' not in n:continue
  bn=next(x for x in out['nodes'] if x['name']==n['name']);old=out['meshes'][bn['mesh']]['primitives'];new=copy.deepcopy(d['meshes'][n['mesh']]['primitives']);assert len(old)==len(new)==1
  new[0]['material']=old[0]['material'];new[0]['indices']+=ao
  for k in new[0]['attributes']:new[0]['attributes'][k]+=ao
  out['meshes'][bn['mesh']]['primitives']=new;changed.append(bn['mesh'])
 dest=O/f'{tag}.glb';write(dest,out,bb+b)
 dd,db=read(dest);assert db[:len(bb)]==bb
 for key in ('asset','scene','scenes','nodes','materials'):assert dd[key]==base[key]
 for i,m in enumerate(base['meshes']):
  if i not in changed:assert dd['meshes'][i]==m
 assert dd['accessors'][:len(base['accessors'])]==base['accessors'];assert dd['bufferViews'][:len(base['bufferViews'])]==base['bufferViews']
 total=sum(dd['accessors'][p['indices']]['count']//3 for m in dd['meshes'] for p in m['primitives'])
 return {'path':str(dest),'sha256':sha(dest),'triangles':total,'deltaTriangles':total-1166,'baselineBinaryPrefixByteIdentical':True,'otherMeshJsonAccessorsNormalsMaterialsNodesByteIdentical':True}
bpy.ops.wm.open_mainfile(filepath=str(S));dep=bpy.context.evaluated_depsgraph_get();sources={}
for name in names:
 o=bpy.data.objects[name];m=bpy.data.meshes.new_from_object(o.evaluated_get(dep),preserve_all_data_layers=True,depsgraph=dep);m.transform(o.matrix_world);m.calc_loop_triangles();sources[name]=m
rows=[]
for tag,pad,smile in [('source-four',None,None),('stage-1',32,20),('stage-2',64,40),('stage-3',128,80),('stage-4',256,160)]:
 bpy.ops.object.select_all(action='DESELECT');clones=[];counts={}
 for name,m in sources.items():
  c=bpy.data.objects.new('EXPORT '+name,m.copy());bpy.context.scene.collection.objects.link(c);c.select_set(True);clones.append(c);bpy.context.view_layer.objects.active=c;t=pad if name.startswith('Muzzle') else smile
  if t:
   mod=c.modifiers.new('Source-derived automatic collapse','DECIMATE');mod.decimate_type='COLLAPSE';mod.ratio=t/len(m.loop_triangles);mod.use_collapse_triangulate=True;bpy.ops.object.modifier_apply(modifier=mod.name)
  c.data.calc_loop_triangles();counts[name]=len(c.data.loop_triangles)
 path=O/(tag+'-four.glb');bpy.ops.export_scene.gltf(filepath=str(path),export_format='GLB',use_selection=True,export_texcoords=False,export_normals=True,export_tangents=False,export_materials='EXPORT',export_cameras=False,export_lights=False,export_animations=False,export_morph=False,export_extras=False)
 row={'stage':tag,'padTarget':pad,'smileTarget':smile,'counts':counts,'fourPath':str(path)}
 if pad:row.update(patch(path,tag))
 rows.append(row)
 for c in clones:bpy.data.objects.remove(c,do_unlink=True)
assert sha(S)=='9254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806'
(O/'build-report.json').write_text(json.dumps({'sourceSha256':sha(S),'baselineSha256':sha(B),'sourceUnchanged':True,'stages':rows},indent=2))
