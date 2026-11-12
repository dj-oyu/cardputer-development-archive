import bpy,sys,json,pathlib,hashlib,time,numpy as np
from mathutils import Vector
R=pathlib.Path(sys.argv[sys.argv.index('--')+1]).resolve();D=R/'rich-oracle';P=R.parent;REF=P/'fox-reference-uncertainty-v3';cfg=json.loads((REF/'input/config.json').read_text());comp=json.loads((P/'fox-v3-lighting-ab/four-both-002/model-baseline/compile.json').read_text());manifest=json.loads((REF/'render-manifest.json').read_text());lookup={(r['seed'],r['view'],r['case']):r for r in manifest['images']};sha=lambda p:hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest();v=np.fromfile(R/'observer/native-front-baseline.vertices.f64',np.float64).reshape(3,256,32,3)
def check_pins():
 for file,h in json.loads((D/'input-hashes.json').read_text()).items():assert sha(P/file)==h, 'input drift '+file
 for file,h in json.loads((D/'pre-execution-hashes.json').read_text()).items():assert sha(D/file)==h, 'code drift '+file
check_pins()
assert sha(cfg['source'])==cfg['sourceSHA256'];assert not (D/'COMPLETED.json').exists();(D/'images').mkdir(exist_ok=True)
for view in ['front','oblique']:
 for case in ['baseline','direction']:assert np.array_equal(v,np.fromfile(R/'observer'/f'native-{view}-{case}.vertices.f64',np.float64).reshape(3,256,32,3))
def capture_settings(sc):
 return {'engine':sc.render.engine,'display':{k:getattr(sc.view_settings,k) for k in ['view_transform','look','exposure','gamma']},'cycles':{k:getattr(sc.cycles,k) for k in ['use_denoising','use_adaptive_sampling','adaptive_threshold','adaptive_min_samples','sample_clamp_direct','sample_clamp_indirect','blur_glossy','pixel_filter_type','filter_width','use_animated_seed']},'frame':sc.frame_current,'dither':sc.render.dither_intensity,'filmTransparent':sc.render.film_transparent,'colorDepth':sc.render.image_settings.color_depth,'colorMode':sc.render.image_settings.color_mode}
def material_state():
 out={}
 for m in bpy.data.materials:
  if not m.use_nodes:continue
  nodes={}
  for n in m.node_tree.nodes:
   sockets={}
   for i,socket in enumerate(n.inputs):
    if hasattr(socket,'default_value'):
     value=socket.default_value
     try:value=list(value)
     except TypeError:pass
     sockets[str(i)+':'+socket.name]=value
   nodes[n.name]={'type':n.bl_idname,'inputs':sockets}
  out[m.name]={'flags':{k:getattr(m,k) for k in ['use_nodes','use_backface_culling','surface_render_method','use_transparent_shadow'] if hasattr(m,k)},'nodes':nodes,'links':[(l.from_node.name,l.from_socket.name,l.to_node.name,l.to_socket.name) for l in m.node_tree.links]}
 return out

def invariant_scene(sc):
 ground=bpy.data.objects['Studio ground'];world=sc.world
 return {'materials':material_state(),'cameraMatrix':[list(r) for r in sc.camera.matrix_world],'cameraClip':[sc.camera.data.clip_start,sc.camera.data.clip_end],'cameraOrthoScale':sc.camera.data.ortho_scale,'settings':capture_settings(sc),'lights':[{'name':o.name,'type':o.data.type,'shape':getattr(o.data,'shape',None),'size':getattr(o.data,'size',None),'energy':o.data.energy,'color':list(o.data.color),'matrix':[list(x) for x in o.matrix_world]} for o in sc.objects if o.type=='LIGHT'],'worldStrength':world.node_tree.nodes['Background'].inputs[1].default_value,'worldColor':list(world.node_tree.nodes['Background'].inputs[0].default_value),'groundMatrix':[list(x) for x in ground.matrix_world],'groundVertices':[list(x.co) for x in ground.data.vertices],'groundPolygons':[list(f.vertices) for f in ground.data.polygons],'groundMaterials':[m.name for m in ground.data.materials],'groundVisible':not ground.hide_render}
def setup(seed,case,view):
 bpy.ops.wm.open_mainfile(filepath=cfg['source']);sc=bpy.context.scene;sc.render.resolution_x=240;sc.render.resolution_y=135;sc.render.resolution_percentage=100;sc.render.image_settings.file_format='PNG';sc.render.image_settings.color_mode='RGBA';sc.render.image_settings.color_depth='8';sc.render.threads_mode='FIXED';sc.render.threads=8;sc.cycles.samples=2048;sc.cycles.seed=seed;cam=sc.camera;cam.data.type='ORTHO';cam.data.ortho_scale=4.8*240/135;cam.location=view['blenderLocation'];cam.rotation_euler=(Vector(view['blenderTarget'])-cam.location).to_track_quat('-Z','Y').to_euler()
 scenario=next(x for x in cfg['scenarios'] if x['name']==case);assert scenario['albedoScale']==1 and scenario.get('richEnergyScale',1)==1 and scenario.get('richWorldScale',1)==1
 key=bpy.data.objects[cfg['keyLightName']]
 if case=='direction':
  target=Vector(cfg['keyTarget']);distance=(key.location-target).length;key.location=target+Vector(scenario['blenderLight']).normalized()*distance;key.rotation_euler=(target-key.location).to_track_quat('-Z','Y').to_euler()
 bpy.context.view_layer.update();assert capture_settings(sc)==cfg['expectedRenderInvariantSettings']
 expected=cfg['expectedCaseMetadata'][case];tol=cfg['metadataFloatTolerance'];assert abs(key.data.energy-expected['keyEnergy'])<=tol;assert np.allclose(key.location,expected['keyLocation'],rtol=0,atol=tol);assert abs(sc.world.node_tree.nodes['Background'].inputs[1].default_value-expected['worldStrength'])<=tol
 row=lookup[(seed,view['name'],case)];meta=REF/row['metadata'];assert sha(meta)==row['metadataSHA256'];old=json.loads(meta.read_text())['geometry'];assert np.array_equal(np.array(cam.matrix_world),np.array(old['cameraMatrix']));assert [cam.data.clip_start,cam.data.clip_end]==old['clip'] and cam.data.ortho_scale==old['orthoScale'];assert [sc.render.resolution_x,sc.render.resolution_y,sc.render.resolution_percentage]==old['resolution']
 return sc
materials={m['id']:m for m in comp['materialTrace']}
def replace_character(sc):
 before=invariant_scene(sc);hidden=[];normerrors=[];poserrors=[];faces=0
 for o in list(sc.objects):
  if o.type in ('MESH','CURVE') and not o.hide_render and o.name!='Studio ground':o.hide_render=True;hidden.append(o.name)
 assert sorted(hidden)==json.loads((D/'source-audit.json').read_text())['characterObjects'] or sorted(hidden)==sorted(json.loads((D/'source-audit.json').read_text())['characterObjects'])
 for node,part in enumerate(comp['parts'],1):
  mt=materials[part['materialId']];mat=bpy.data.materials.get(mt['name']);assert mat and mat.use_nodes;assert sorted(n.bl_idname for n in mat.node_tree.nodes)==['ShaderNodeBsdfPrincipled','ShaderNodeOutputMaterial'];assert len(mat.node_tree.links)==1;link=list(mat.node_tree.links)[0];assert link.from_node.type=='BSDF_PRINCIPLED' and link.to_node.type=='OUTPUT_MATERIAL';bs=mat.node_tree.nodes.get('Principled BSDF');assert list(bs.inputs['Base Color'].default_value)==mt['sourceLinear']
  for socket in bs.inputs:assert not socket.is_linked
  ids=np.array(part['triangles'])[:,[0,2,1]];p=v[0,node,:len(part['positions'])][:,[0,2,1]]*[1,-1,-1]/38;n=v[1,node,:len(part['positions'])][:,[0,2,1]]*[1,-1,-1];back=v[2,node,:len(part['positions'])][:,[0,2,1]]*[1,-1,-1];assert np.array_equal(n,-back);assert np.isfinite(p).all() and np.isfinite(n).all() and (np.linalg.norm(n,axis=1)>0).all();n=n/np.linalg.norm(n,axis=1)[:,None]
  mesh=bpy.data.meshes.new(f'Oracle mesh {node}');mesh.from_pydata(p.tolist(),[],ids.tolist());mesh.update();assert len(mesh.polygons)==len(ids)
  for f in mesh.polygons:f.use_smooth=True
  mesh.normals_split_custom_set_from_vertices(n.tolist());mesh.materials.append(mat);ob=bpy.data.objects.new(f'Oracle part {node}',mesh);sc.collection.objects.link(ob)
  stored=np.array([c.vector[:] for c in mesh.corner_normals]);expected=np.array([n[l.vertex_index] for l in mesh.loops]);err=float(np.linalg.norm(stored-expected,axis=1).max());pe=float(abs(np.array([x.co[:] for x in mesh.vertices])-p).max());assert err<=1e-3 and pe<=1e-6;normerrors.append(err);poserrors.append(pe);faces+=len(ids)
 assert faces==1166 and len(comp['parts'])==45;assert invariant_scene(sc)==before
 return {'hiddenOriginalCharacters':hidden,'parts':45,'triangles':faces,'normalStorageMaxVectorError':max(normerrors),'positionStorageMaxError':max(poserrors),'unchangedScene':before}
# Establish original physical front/back independently of requested camera shading normal.
sidechecks={}
for view in cfg['cameras']:
 V=np.array(view['blenderLocation'])-view['blenderTarget'];V=V/np.linalg.norm(V);a=np.fromfile(R/'observer'/f"native-{view['name']}-baseline.observer.f32",np.float32).reshape(135,240,16);sides=np.fromfile(R/'observer'/f"native-{view['name']}-baseline.sides.u8",np.uint8).reshape(256,64);count=0
 for row in a[a[...,15]>0]:
  node,face=int(row[0]),int(row[1]);ids=row[3:6].astype(int);matches=[t for t in comp['parts'][node-1]['triangles'] if sorted(t)==sorted(ids.tolist())];assert len(matches)==1;orig=np.array(matches[0])[[0,2,1]];p=v[0,node,orig][:,[0,2,1]]*[1,-1,-1]/38;dot=np.dot(np.cross(p[1]-p[0],p[2]-p[0]),V);assert abs(dot)>1e-12 and (dot>0)==(int(sides[node,face])==0);count+=1
 sidechecks[view['name']]=count
(D/'side-controls.json').write_text(json.dumps(sidechecks,indent=2));records=[]
# Original-render controls precede any oracle result; exactsavedPNG not a fit target.
for view in cfg['cameras']:
 sc=setup(11,'baseline',view);png=D/'images'/f"control-seed11-{view['name']}-baseline.png";assert not png.exists();sc.render.filepath=str(png);bpy.ops.render.render(write_still=True);expected=REF/lookup[(11,view['name'],'baseline')]['file'];assert png.read_bytes()==expected.read_bytes(),'original source control mismatch'
(D/'ORIGINAL_CONTROL_PASS.json').write_text(json.dumps({'seed':11,'cases':['front-baseline','oblique-baseline'],'pngExact':True}))
for seed in [11,29]:
 for case in ['baseline','direction']:
  for view in cfg['cameras']:
   sc=setup(seed,case,view);audit=replace_character(sc);png=D/'images'/f"seed-{seed}-{view['name']}-{case}.png";assert not png.exists();sc.render.filepath=str(png);t=time.monotonic();bpy.ops.render.render(write_still=True);assert capture_settings(sc)==cfg['expectedRenderInvariantSettings'];row={'seed':seed,'view':view['name'],'case':case,'file':str(png.relative_to(D)),'sha256':sha(png),'seconds':time.monotonic()-t,'audit':audit};records.append(row);(D/'manifest.partial.json').write_text(json.dumps(records,indent=2));print('ORACLE_CASE_COMPLETE',seed,view['name'],case,flush=True)
check_pins();assert sha(cfg['source'])==cfg['sourceSHA256'];(D/'COMPLETED.json').write_text(json.dumps({'images':records,'sourceSHA256':cfg['sourceSHA256'],'scope':'8images diagnostic only; no new stability mask'},indent=2));print('ORACLE_COMPLETE',flush=True)
