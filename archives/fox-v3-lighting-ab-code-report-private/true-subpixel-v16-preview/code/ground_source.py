import bpy,sys,pathlib,json,hashlib,ast,time,numpy as np
from mathutils import Vector
R=pathlib.Path(__file__).resolve().parents[1];P=R.parent;REF=P/'fox-reference-uncertainty-v3'
args=sys.argv[sys.argv.index('--')+1:];assert args in [['--extract'],['--fixture']]
sha=lambda p:hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def write(p,x):p.write_text(json.dumps(x,indent=2,allow_nan=False)+'\n')
def digest(x):return hashlib.sha256(json.dumps(x,sort_keys=True,separators=(',',':')).encode()).hexdigest()
cfg=json.loads((REF/'input/config.json').read_text());source=pathlib.Path(cfg['source']);assert sha(source)==cfg['sourceSHA256']
reader=P/'fox-v3-position-diagnostic/pass-decomposition/exr_io.py'
pins={str(p):sha(p) for p in [source,REF/'input/config.json',REF/'code/render_reference.py',pathlib.Path(__file__).resolve(),R/'GROUND_SOURCE_PLAN.md',reader]}
bpy.ops.wm.open_mainfile(filepath=str(source));ground=bpy.data.objects['Studio ground'];assert ground.type=='MESH' and not ground.hide_render and len(ground.data.materials)==1
mat=ground.data.materials[0];assert mat.use_nodes and not mat.animation_data and not mat.node_tree.animation_data
assert sorted(n.bl_idname for n in mat.node_tree.nodes)==['ShaderNodeBsdfPrincipled','ShaderNodeOutputMaterial'] and len(mat.node_tree.links)==1
bs=mat.node_tree.nodes.get('Principled BSDF');assert bs and all(not s.is_linked for s in bs.inputs)
color=list(bs.inputs['Emission Color'].default_value);strength=float(bs.inputs['Emission Strength'].default_value);le=[x*strength for x in color[:3]]
def material_state(m):
 return {'flags':{k:getattr(m,k) for k in ['use_nodes','use_backface_culling','surface_render_method','use_transparent_shadow'] if hasattr(m,k)},'nodes':{n.name:{'type':n.bl_idname,'inputs':{s.identifier:(list(s.default_value) if hasattr(s.default_value,'__len__') and not isinstance(s.default_value,str) else s.default_value) for s in n.inputs if hasattr(s,'default_value')}} for n in m.node_tree.nodes},'links':[[l.from_node.name,l.from_socket.identifier,l.to_node.name,l.to_socket.identifier] for l in m.node_tree.links]}
originalmat=material_state(mat)
obj=ground.evaluated_get(bpy.context.evaluated_depsgraph_get());mesh=obj.to_mesh();mesh.calc_loop_triangles()
vertices=[list(obj.matrix_world@v.co) for v in mesh.vertices];triangles=[list(t.vertices) for t in mesh.loop_triangles];normals=[]
for ids in triangles:
 a,b,c=[Vector(vertices[i]) for i in ids];n=(b-a).cross(c-a);assert n.length>0;normals.append(list(n.normalized()))
mesh_normals=[list((obj.matrix_world.to_3x3().inverted().transposed()@t.normal).normalized()) for t in mesh.loop_triangles]
assert np.allclose(normals,mesh_normals,rtol=0,atol=1e-7)
obj.to_mesh_clear()
# Select exactly the published reference material-loop AST, never render loops.
mod=ast.parse((REF/'code/render_reference.py').read_text());loops=[n for n in ast.walk(mod) if isinstance(n,ast.For) and isinstance(n.target,ast.Tuple) and [x.id for x in n.target.elts if isinstance(x,ast.Name)]==['name','color']]
assert len(loops)==1 and "inputs['Base Color']" in ast.unparse(loops[0])
loop=compile(ast.Module(body=[loops[0]],type_ignores=[]),'frozen_reference_albedo_assignment','exec')
materials={m.name:tuple(m.node_tree.nodes.get('Principled BSDF').inputs['Base Color'].default_value) for m in bpy.data.materials if m.use_nodes and m.node_tree.nodes.get('Principled BSDF')}
cases=[]
for case in cfg['scenarios']:
 exec(loop,{'bpy':bpy,'materials':materials,'case':case})
 aftercolor=list(bs.inputs['Emission Color'].default_value);afterstrength=float(bs.inputs['Emission Strength'].default_value)
 assert aftercolor==color and afterstrength==strength
 cases.append({'name':case['name'],'albedoScale':case['albedoScale'],'actualGroundBaseColor':list(bs.inputs['Base Color'].default_value),'emissionColor':aftercolor,'emissionStrength':afterstrength,'linearLe':[x*afterstrength for x in aftercolor[:3]],'emissionUnchanged':True,'richEnergyScale':case.get('richEnergyScale',1),'richWorldScale':case.get('richWorldScale',1)})
assert len(cases)==5
for name,value in materials.items():bpy.data.materials[name].node_tree.nodes.get('Principled BSDF').inputs['Base Color'].default_value=value
assert material_state(mat)==originalmat
payload={'sourceSHA256':sha(source),'referenceConfigSHA256':sha(REF/'input/config.json'),'object':ground.name,'matrixWorld':[list(r) for r in obj.matrix_world],'worldVertices':vertices,'triangles':triangles,'worldGeometricNormals':normals,'loopTriangleWorldNormals':mesh_normals,'linearLe':le,'sourceEmissionColor':color,'sourceEmissionStrength':strength,'materialState':originalmat,'objectFlags':{k:getattr(ground,k) for k in ['hide_render','visible_camera','visible_diffuse','visible_glossy','visible_transmission','visible_volume_scatter','visible_shadow'] if hasattr(ground,k)},'scenarios':cases,'referenceAlbedoAssignment':ast.unparse(loops[0]),'privateGeometryDoNotBundle':True}
private=R/'inputs/ground-source.json'
if args==['--extract']:
 assert not private.exists();write(private,payload)
 summary={k:v for k,v in payload.items() if k not in ['worldVertices','matrixWorld','worldGeometricNormals','loopTriangleWorldNormals']}
 summary.update(privateGroundFileSHA256=sha(private),worldGeometrySHA256=digest({'vertices':vertices,'triangles':triangles}),vertexCount=len(vertices),triangleCount=len(triangles),geometryDoubleBytes=len(vertices)*3*8,indexUint32Bytes=len(triangles)*3*4,sourceUnchanged=sha(source)==pins[str(source)],pins=pins)
 write(R/'ground-source-metadata.json',summary);assert all(sha(p)==h for p,h in pins.items());print('GROUND_SOURCE_EXTRACT_PASS',flush=True)
else:
 assert json.loads(private.read_text())==payload,'extraction drift'
 out=R/'emission-side-fixture-001';out.mkdir(exist_ok=False);write(out/'input-hashes-before.json',pins)
 sc=bpy.data.scenes.new('Ground emission side fixture');bpy.context.window.scene=sc;sc.render.engine='CYCLES';sc.cycles.samples=64;sc.cycles.seed=11;sc.cycles.use_denoising=False;sc.cycles.use_adaptive_sampling=False;sc.cycles.sample_clamp_direct=0;sc.cycles.sample_clamp_indirect=0
 sc.render.resolution_x=sc.render.resolution_y=32;sc.render.resolution_percentage=100;sc.render.threads_mode='FIXED';sc.render.threads=8;sc.render.film_transparent=False;sc.use_nodes=False
 sc.render.image_settings.file_format='OPEN_EXR_MULTILAYER';sc.render.image_settings.color_depth='32';sc.render.image_settings.exr_codec='NONE'
 world=bpy.data.worlds.new('Zero world');world.use_nodes=True;world.node_tree.nodes['Background'].inputs['Strength'].default_value=0;sc.world=world
 copied=mat.copy();assert material_state(copied)==originalmat
 geo=bpy.data.meshes.new('Same finite ground');geo.from_pydata(vertices,[],triangles);geo.update();geo.materials.append(copied);plane=bpy.data.objects.new('Fixture ground',geo);sc.collection.objects.link(plane)
 camera=bpy.data.objects.new('Fixture camera',bpy.data.cameras.new('Fixture camera'));sc.collection.objects.link(camera);sc.camera=camera;camera.data.type='ORTHO';camera.data.ortho_scale=2
 bpy.context.view_layer.use_pass_emit=True;assert len(sc.objects)==2 and not any(o.type=='LIGHT' for o in sc.objects)
 center=sum((Vector(v) for v in vertices),Vector())/len(vertices);normal=Vector(normals[0]);assert all(np.dot(n,normal)>1-1e-7 for n in normals)
 sys.path.insert(0,str(reader.parent));import exr_io
 rows=[];start=time.monotonic()
 for side,sign in [('front',1),('back',-1)]:
  camera.location=center+normal*(2*sign);camera.rotation_euler=(center-camera.location).to_track_quat('-Z','Y').to_euler();bpy.context.view_layer.update();path=out/(side+'.exr');sc.render.filepath=str(path);bpy.ops.render.render(write_still=True)
  channels=exr_io.read(path);measures={}
  for name in ['Combined','Emit']:
   rgb=np.stack([channels['ViewLayer.'+name+'.'+c] for c in 'RGB'],-1).astype(np.float64);center_values=rgb[8:24,8:24];assert np.isfinite(center_values).all()
   error=float(np.max(np.abs(center_values-np.array(le))))
   measures[name]={'expectedRGB':le,'actualMeanRGB':center_values.mean((0,1)).tolist(),'maximumAbsoluteError':error,'within1eMinus6':error<=1e-6}
  rows.append({'side':side,'file':path.name,'sha256':sha(path),'measures':measures});write(out/'partial.json',rows)
 afterpins={p:sha(p) for p in pins};write(out/'input-hashes-after.json',afterpins);assert afterpins==pins
 result={'sides':rows,'bothSidesEmitSourceLe':all(m['within1eMinus6'] for r in rows for m in r['measures'].values()),'sourceUnchanged':True,'materialCopyFunctionalExact':True,'sourceMaterialFlags':originalmat['flags'],'privateGroundFileSHA256':sha(private),'geometrySHA256':digest({'vertices':vertices,'triangles':triangles}),'resolution':[32,32],'centerRegion':[8,24,8,24],'samples':64,'seed':11,'threads':8,'worldStrength':0,'lightCount':0,'auxiliarySceneOnly':True,'fixtureHDRBytes':2*32*32*3*4,'wallSeconds':time.monotonic()-start,'scope':'directly observed two-sided emission; not inferred from culling flags; no native image inputs'}
 write(out/'COMPLETED.json',result);print('GROUND_EMISSION_SIDE_FIXTURE_COMPLETE',result['bothSidesEmitSourceLe'],flush=True)
