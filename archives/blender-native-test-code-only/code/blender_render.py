import bpy,math,sys,json,pathlib,hashlib
from mathutils import Vector
manifest=json.loads(pathlib.Path(sys.argv[sys.argv.index('--')+1]).read_text())
OUT=pathlib.Path(manifest['output'])
SRC=pathlib.Path(manifest['source'])
bpy.ops.wm.open_mainfile(filepath=str(SRC))
sc=bpy.context.scene
rich_settings={'blenderVersion':bpy.app.version_string,'blenderBuildHash':bpy.app.build_hash.decode(),'engine':sc.render.engine,'samples':sc.cycles.samples,'seed':sc.cycles.seed,'denoise':sc.cycles.use_denoising,'viewTransform':sc.view_settings.view_transform,'look':sc.view_settings.look,'exposure':sc.view_settings.exposure,'gamma':sc.view_settings.gamma,'pixelFilter':sc.cycles.pixel_filter_type,'filterWidth':sc.cycles.filter_width,'sourceMaterialBackfaceCulling':{m.name:m.use_backface_culling for m in bpy.data.materials},'lights':[{'name':o.name,'type':o.data.type,'energy':o.data.energy,'color':list(o.data.color),'location':list(o.location),'rotation':list(o.rotation_euler)} for o in sc.objects if o.type=='LIGHT']}
dep=bpy.context.evaluated_depsgraph_get();stats=[];clones=[]
originals=[o for o in sc.objects if o.type in ('MESH','CURVE') and not o.hide_render and o.name!='Studio ground']
for o in originals:
 ev=o.evaluated_get(dep);me=bpy.data.meshes.new_from_object(ev,preserve_all_data_layers=True,depsgraph=dep)
 me.transform(o.matrix_world);me.calc_loop_triangles()
 c=bpy.data.objects.new('EXPORT '+o.name,me);sc.collection.objects.link(c);clones.append(c)
 stats.append({'name':o.name,'sourceVertices':len(me.vertices),'sourceTriangles':len(me.loop_triangles),'area':sum(p.area for p in me.polygons)})
for o in originals:o.hide_render=True;o.hide_set(True)
for m in bpy.data.materials:
 m.use_backface_culling=True
# glTF exporter receives opaque base color only; no studio or hidden source duplicate.
def export(name):
 bpy.ops.object.select_all(action='DESELECT')
 for o in clones:o.select_set(True)
 bpy.context.view_layer.objects.active=clones[0]
 bpy.ops.export_scene.gltf(filepath=str(OUT/name),export_format='GLB',use_selection=True,export_texcoords=False,export_normals=True,export_tangents=False,export_materials='EXPORT',export_cameras=False,export_lights=False,export_animations=False,export_morph=False,export_extras=False)
export('fox-evaluated-full.glb')
# One fixed auto-reduction budget. Preserves source; no manual vertex/pose sculpting.
BUDGET=1200;minimum=4;weights=[math.sqrt(x['area']) for x in stats];remain=BUDGET-minimum*len(stats)
for o,row,w in zip(clones,stats,weights):
 target=max(minimum,int(minimum+remain*w/sum(weights)));row['targetTriangles']=target
 if row['sourceTriangles']>target:
  mod=o.modifiers.new('Export-only automatic collapse','DECIMATE');mod.decimate_type='COLLAPSE';mod.ratio=target/row['sourceTriangles'];mod.use_collapse_triangulate=True
  bpy.context.view_layer.objects.active=o;bpy.ops.object.modifier_apply(modifier=mod.name)
 o.data.calc_loop_triangles();row['outputVertices']=len(o.data.vertices);row['outputTriangles']=len(o.data.loop_triangles)
export('fox-auto1200.glb')
(OUT/'export-report.json').write_text(json.dumps({'source':str(SRC),'sourceSha256':hashlib.sha256(SRC.read_bytes()).hexdigest(),'sourceChanged':False,'method':'Blender evaluated clone; independent collapse decimate per object, sqrt surface area budget allocation; no remodelling','targetTriangles':BUDGET,'objects':stats,'sourceTriangles':sum(s['sourceTriangles'] for s in stats),'outputTriangles':sum(s['outputTriangles'] for s in stats),'materials':'Opaque material base colors only. PBR/lighting not transferred; no texture/morph/rig.','pose':'Unchanged; visually unaccepted posture remains.'},indent=2))
# Rich capacity sweep: only declared source key/world/material parameter changes.
# Preserve fill/rim, area size, materials/PBR, original engine, exposure and AgX.
for m in bpy.data.materials:m.use_backface_culling=rich_settings['sourceMaterialBackfaceCulling'][m.name]
sc.render.resolution_x=240;sc.render.resolution_y=135;sc.render.resolution_percentage=100
cam=sc.camera;cam.data.ortho_scale=4.8*240/135
for o in originals:o.hide_render=False
for o in clones:o.hide_render=True
key=bpy.data.objects[manifest['richMapping']['keyLightName']];keyloc=key.location.copy();keyrot=key.rotation_euler.copy();energy=key.data.energy;target=Vector(manifest['richMapping']['keyTarget']);distance=(keyloc-target).length
background=sc.world.node_tree.nodes.get('Background');worldstrength=background.inputs[1].default_value
base_materials={m.name:tuple(m.node_tree.nodes.get('Principled BSDF').inputs['Base Color'].default_value) for m in bpy.data.materials if m.use_nodes and m.node_tree.nodes.get('Principled BSDF')}
rich_cases=[]
for scenario in manifest['scenarios']:
 if scenario['name']=='unlit':continue
 key.location=keyloc;key.rotation_euler=keyrot;key.data.energy=energy*scenario.get('richEnergyScale',1);background.inputs[1].default_value=worldstrength*scenario.get('richWorldScale',1)
 if scenario['name']=='direction':
  key.location=target+Vector(scenario['blenderLight']).normalized()*distance;key.rotation_euler=(target-key.location).to_track_quat('-Z','Y').to_euler()
 for m in bpy.data.materials:
  if m.name in base_materials:
   c=base_materials[m.name];m.node_tree.nodes.get('Principled BSDF').inputs['Base Color'].default_value=tuple(min(1,x*scenario['albedoScale']) for x in c[:3])+(c[3],)
 rich_cases.append({'name':scenario['name'],'keyLocation':list(key.location),'keyEnergy':key.data.energy,'keyColor':list(key.data.color),'worldStrength':background.inputs[1].default_value,'albedoScale':scenario['albedoScale'],'otherLightsUnchanged':True,'materialBackfaceCulling':{m.name:m.use_backface_culling for m in bpy.data.materials}})
 for view in manifest['cameras']:
  cam.location=view['blenderLocation'];cam.rotation_euler=(Vector(view['blenderTarget'])-cam.location).to_track_quat('-Z','Y').to_euler()
  sc.render.filepath=str(OUT/('blender-rich-'+view['name']+'-'+scenario['name']+'.png'));bpy.ops.render.render(write_still=True)
  if scenario['name']=='baseline':
   import shutil;shutil.copyfile(sc.render.filepath,OUT/('blender-rich-original-'+view['name']+'.png'))
key.location=keyloc;key.rotation_euler=keyrot;key.data.energy=energy;background.inputs[1].default_value=worldstrength
for m in bpy.data.materials:
 if m.name in base_materials:m.node_tree.nodes.get('Principled BSDF').inputs['Base Color'].default_value=base_materials[m.name]
# Independent Blender diffuse reference. No native evaluated lighting / rendered pixels are read.
basecolors={m.name:tuple(m.node_tree.nodes.get('Principled BSDF').inputs['Base Color'].default_value) for m in bpy.data.materials if m.use_nodes and m.node_tree.nodes.get('Principled BSDF')}
for o in sc.objects:
 if o.name=='Studio ground':o.hide_render=True
sc.world.color=(0,0,0);sc.world.use_nodes=True;sc.world.node_tree.nodes.get('Background').inputs[1].default_value=0
sc.render.engine='CYCLES';sc.cycles.samples=1;sc.cycles.use_denoising=False;sc.render.resolution_x=240;sc.render.resolution_y=135;sc.render.resolution_percentage=100;sc.render.film_transparent=True
sc.view_settings.view_transform='Raw';sc.view_settings.look='None';sc.view_settings.exposure=0;sc.view_settings.gamma=1;sc.render.dither_intensity=0
sc.render.image_settings.file_format='PNG';sc.render.image_settings.color_mode='RGBA';sc.render.image_settings.color_depth='8'
cam=sc.camera;cam.data.type='ORTHO';cam.data.ortho_scale=4.8*240/135
srgb=lambda x:12.92*x if x<=.0031308 else 1.055*x**(1/2.4)-.055
for scenario in manifest['scenarios']:
 # Geometry Normal is world-space, like the inverse-transpose model normals.
 L=Vector(scenario['blenderLight']);L.normalize()
 for m in bpy.data.materials:
  if m.name not in basecolors:continue
  base=[srgb(min(1,x*scenario['albedoScale'])) for x in basecolors[m.name][:3]]
  nt=m.node_tree;nt.nodes.clear();out=nt.nodes.new('ShaderNodeOutputMaterial');em=nt.nodes.new('ShaderNodeEmission');nt.links.new(em.outputs[0],out.inputs['Surface'])
  geom=nt.nodes.new('ShaderNodeNewGeometry');dot=nt.nodes.new('ShaderNodeVectorMath');dot.operation='DOT_PRODUCT';dot.inputs[1].default_value=L;nt.links.new(geom.outputs['Normal'],dot.inputs[0])
  positive=nt.nodes.new('ShaderNodeMath');positive.operation='MAXIMUM';positive.inputs[1].default_value=0;nt.links.new(dot.outputs['Value'],positive.inputs[0])
  combine=nt.nodes.new('ShaderNodeCombineXYZ')
  for k in range(3):
   scale=nt.nodes.new('ShaderNodeMath');scale.operation='MULTIPLY_ADD';scale.inputs[1].default_value=base[k]*scenario['diffuse']*scenario['intensity'][k];scale.inputs[2].default_value=base[k]*scenario['ambient'];scale.use_clamp=True;nt.links.new(positive.outputs[0],scale.inputs[0]);nt.links.new(scale.outputs[0],combine.inputs[k])
  nt.links.new(combine.outputs[0],em.inputs['Color'])
 for view in manifest['cameras']:
  cam.location=view['blenderLocation'];cam.rotation_euler=(Vector(view['blenderTarget'])-cam.location).to_track_quat('-Z','Y').to_euler()
  # Source versus reduced is measured separately under exactly the same light.
  for kind in ['full','reduced']:
   for o in originals:o.hide_render=kind!='full'
   for o in clones:o.hide_render=kind!='reduced'
   sc.render.filepath=str(OUT/('blender-'+kind+'-'+view['name']+'-'+scenario['name']+'.png'));bpy.ops.render.render(write_still=True)
  if scenario['name']=='unlit':
   # Diagnostic only: Cycles ordinarily shows backfaces, unlike native triangle culling.
   for m in bpy.data.materials:
    if m.name not in basecolors:continue
    nt=m.node_tree;outnode=next(n for n in nt.nodes if n.type=='OUTPUT_MATERIAL');em=next(n for n in nt.nodes if n.type=='EMISSION');geom=next(n for n in nt.nodes if n.type=='NEW_GEOMETRY');mix=nt.nodes.new('ShaderNodeMixShader');transparent=nt.nodes.new('ShaderNodeBsdfTransparent');nt.links.new(geom.outputs['Backfacing'],mix.inputs[0]);nt.links.new(em.outputs[0],mix.inputs[1]);nt.links.new(transparent.outputs[0],mix.inputs[2]);nt.links.new(mix.outputs[0],outnode.inputs['Surface'])
   sc.render.filepath=str(OUT/('blender-reduced-cull-diagnostic-'+view['name']+'.png'));bpy.ops.render.render(write_still=True)
   for m in bpy.data.materials:
    if m.name not in basecolors:continue
    nt=m.node_tree;nt.links.new(next(n for n in nt.nodes if n.type=='EMISSION').outputs[0],next(n for n in nt.nodes if n.type=='OUTPUT_MATERIAL').inputs['Surface'])
(OUT/'blender-metadata.json').write_text(json.dumps({'cameras':manifest['cameras'],'scenarios':manifest['scenarios'],'sourceSha256':hashlib.sha256(SRC.read_bytes()).hexdigest(),'richOriginalSettings':rich_settings,'richCases':rich_cases,'richMapping':manifest['richMapping'],'diagnosticSettings':{'transparentBackground':True,'samples':1,'viewTransform':'Raw','dither':0,'seed':sc.cycles.seed,'filterWidth':sc.cycles.filter_width},'renderer':'Cycles emission custom diffuse; continuous interpolated normals, NOT native vertex results','view':'Raw','samples':1,'dither':0,'background':[0,0,0],'resolution':[240,135]}))
