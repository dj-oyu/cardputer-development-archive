import bpy,pathlib,sys,json,hashlib,time,ast,numpy as np
from mathutils import Vector
D=pathlib.Path(__file__).resolve().parent;P=D.parent.parent;OLD=P/'fox-v3-position-diagnostic/rich-oracle';REF=P/'fox-reference-uncertainty-v3'
sys.path.insert(0,str(P/'fox-v3-position-diagnostic/pass-decomposition'));import exr_io
sha=lambda p:hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
cfg=json.loads((REF/'input/config.json').read_text());comp=json.loads((P/'fox-v3-lighting-ab/four-both-002/model-baseline/compile.json').read_text());manifest=json.loads((REF/'render-manifest.json').read_text());lookup={(r['seed'],r['view'],r['case']):r for r in manifest['images']};v=np.fromfile(P/'fox-v3-position-diagnostic/observer/native-front-baseline.vertices.f64',np.float64).reshape(3,256,32,3)
mod=ast.parse((OLD/'render_oracle.py').read_text());ns={'bpy':bpy,'np':np,'json':json,'Vector':Vector,'cfg':cfg,'comp':comp,'v':v,'D':OLD,'REF':REF,'lookup':lookup,'sha':sha,'materials':{x['id']:x for x in comp['materialTrace']}}
exec(compile(ast.Module(body=[n for n in mod.body if isinstance(n,ast.FunctionDef)],type_ignores=[]),'frozen_oracle_functions','exec'),ns)
def check():
 for f,h in json.loads((D/'freeze.json').read_text())['files'].items():assert sha(P/f)==h,'input drift '+f
 assert sha(cfg['source'])==cfg['sourceSHA256']
check();assert not (D/'COMPLETED.json').exists();records=[];total=time.monotonic();view=next(x for x in cfg['cameras'] if x['name']=='oblique')
flags=['use_pass_diffuse_direct','use_pass_diffuse_indirect','use_pass_diffuse_color','use_pass_glossy_direct','use_pass_glossy_indirect','use_pass_glossy_color','use_pass_transmission_direct','use_pass_transmission_indirect','use_pass_transmission_color','use_pass_emit','use_pass_environment']
for case in ['baseline','direction']:
 for shadows in [True,False]:
  check();sc=ns['setup'](11,case,view);audit=ns['replace_character'](sc);before=ns['invariant_scene'](sc);original_materials=ns['material_state']();mapping=[];copies={}
  for node,part in enumerate(comp['parts'],1):
   ob=bpy.data.objects[f'Oracle part {node}'];source=ob.data.materials[0];mt=ns['materials'][part['materialId']]
   if source.name not in copies:
    mat=source.copy();mat.name='Diagnostic Lambert '+source.name;mat.node_tree.nodes.clear();df=mat.node_tree.nodes.new('ShaderNodeBsdfDiffuse');df.inputs['Color'].default_value=mt['sourceLinear'];df.inputs['Roughness'].default_value=0.;out=mat.node_tree.nodes.new('ShaderNodeOutputMaterial');mat.node_tree.links.new(df.outputs['BSDF'],out.inputs['Surface']);copies[source.name]=mat
   ob.data.materials[0]=copies[source.name];mapping.append({'node':node,'materialId':part['materialId'],'sourceMaterial':source.name,'cloneMaterial':copies[source.name].name,'sourceLinear':mt['sourceLinear'],'sourceRGB565':mt['albedo565'],'sourceQuantized':mt['quantized'],'sourceEncoded':mt['encoded'],'triangles':len(part['triangles'])})
  ground=bpy.data.objects['Studio ground'];groundcopies=[]
  eg=ground.evaluated_get(bpy.context.evaluated_depsgraph_get());gm=eg.to_mesh();gm.calc_loop_triangles();ground_geometry={'coordinates':'Blender world xyz','vertices':[list(eg.matrix_world @ x.co) for x in gm.vertices],'triangles':[list(t.vertices) for t in gm.loop_triangles]};eg.to_mesh_clear();gp=D/'ground-geometry.json'
  if gp.exists():assert json.loads(gp.read_text())==ground_geometry
  else:gp.write_text(json.dumps(ground_geometry,indent=2))
  for idx,source in enumerate(list(ground.data.materials)):
   mat=source.copy();mat.name='Diagnostic ground '+source.name;ground.data.materials[idx]=mat
   for n in mat.node_tree.nodes:
    if n.type=='BSDF_PRINCIPLED':assert not n.inputs['Emission Strength'].is_linked;n.inputs['Emission Strength'].default_value=0.
   groundcopies.append({'source':source.name,'clone':mat.name})
  sc.world=sc.world.copy();sc.world.name='Diagnostic zero world';sc.world.node_tree.nodes['Background'].inputs['Strength'].default_value=0.
  lights=[o for o in sc.objects if o.type=='LIGHT'];assert len(lights)==3 and all(o.data.type=='AREA' for o in lights)
  for ob in lights:ob.data.use_shadow=shadows
  after=ns['invariant_scene'](sc);assert before['lights']==after['lights'];assert before['cameraMatrix']==after['cameraMatrix'];assert before['settings']==after['settings'];assert before['groundVertices']==after['groundVertices'] and before['groundPolygons']==after['groundPolygons'];assert all(ns['material_state']()[k]==val for k,val in original_materials.items())
  for flag in flags:setattr(bpy.context.view_layer,flag,True)
  bpy.context.view_layer.cycles.use_pass_volume_direct=True;bpy.context.view_layer.cycles.use_pass_volume_indirect=True
  assert not sc.use_nodes and not sc.cycles.use_denoising
  stem=f"seed11-oblique-{case}-shadow{'on' if shadows else 'off'}";out=D/(stem+'.exr');assert not out.exists();sc.render.image_settings.file_format='OPEN_EXR_MULTILAYER';sc.render.image_settings.color_depth='32';sc.render.image_settings.exr_codec='NONE';sc.render.filepath=str(out)
  row={'case':case,'shadow':shadows,'seed':11,'view':'oblique','before':before,'after':after,'geometryAudit':audit,'materialMapping':mapping,'groundCopies':groundcopies,'renderSettings':ns['capture_settings'](sc),'samples':sc.cycles.samples,'threads':sc.render.threads,'lightShadows':{o.name:o.data.use_shadow for o in lights},'cyclesVersion':bpy.app.version_string}
  (D/(stem+'-audit.json')).write_text(json.dumps(row,indent=2));print('RENDER_START',stem,flush=True);t=time.monotonic();bpy.ops.render.render(write_still=True);row['renderSeconds']=time.monotonic()-t
  channels=exr_io.read(out)
  def rgb(name):return np.stack([channels['ViewLayer.'+name+'.'+c] for c in 'RGB'],-1).astype(np.float64)
  direct=rgb('DiffDir')*rgb('DiffCol');npy=D/(stem+'-direct.npy');np.save(npy,direct);components=D/(stem+'-components.npz');np.savez_compressed(components,DiffDir=rgb('DiffDir'),DiffCol=rgb('DiffCol'),DiffInd=rgb('DiffInd'),Combined=rgb('Combined'),Emit=rgb('Emit'),GlossDir=rgb('GlossDir'),GlossInd=rgb('GlossInd'),GlossCol=rgb('GlossCol'))
  row.update({'exr':out.name,'exrSHA256':sha(out),'direct':npy.name,'directSHA256':sha(npy),'components':components.name,'componentsSHA256':sha(components),'arrayConvention':'top-down y increasing EXR scanlines; scene-linear RGB float64; no exposure or view transform','channels':list(channels),'directMin':float(direct.min()),'directMax':float(direct.max()),'emitMaxAbs':float(abs(rgb('Emit')).max())});records.append(row);(D/(stem+'-audit.json')).write_text(json.dumps(row,indent=2));(D/'manifest.partial.json').write_text(json.dumps(records,indent=2));check();print('RENDER_COMPLETE',stem,row['renderSeconds'],flush=True)
check();assert len(records)==4;(D/'COMPLETED.json').write_text(json.dumps({'renders':records,'renderSecondsTotal':sum(r['renderSeconds'] for r in records),'wallSecondsTotal':time.monotonic()-total,'sourceSHA256After':sha(cfg['source']),'scope':'Four auxiliary diagnostic renders only; not original-rich goal reference; no source pixels used by native'},indent=2));print('FOUR_RENDERS_COMPLETE',flush=True)
