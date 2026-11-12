import bpy,sys,json,pathlib,hashlib,time,ast,subprocess,struct,numpy as np
from mathutils import Vector
R=pathlib.Path(__file__).resolve().parents[1];W=R.parent;G=W/'fox-v3-lid-rich-proxy';REF=W/'fox-reference-uncertainty-v3';OLD=W/'fox-v3-position-diagnostic/rich-oracle';PASS=W/'fox-v3-position-diagnostic/pass-decomposition';sys.path.insert(0,str(R/'code'));import exr_io
args=sys.argv[sys.argv.index('--')+1:];assert len(args)==2 and args[0] in ['--audit','--render'];out=pathlib.Path(args[1]).resolve();out.mkdir(exist_ok=False);(out/'images').mkdir();sha=lambda p:hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest();write=lambda p,v:p.write_text(json.dumps(v,indent=2,allow_nan=False,default=list))
cfg=json.loads((REF/'input/config.json').read_text());lookup={(r['seed'],r['view'],r['case']):r for r in json.loads((REF/'render-manifest.json').read_text())['images']};native_rho={r['code']:r['rho'] for r in json.loads((G/'native-rho.json').read_text())};geometry=json.loads((G/'private-actual-geometry.json').read_text());proof=json.loads((G/'geometry-proof.json').read_text());assert sha(G/'private-actual-geometry.json')==proof['privateGeometrySHA256'];assert sha(cfg['source'])==cfg['sourceSHA256'];assert sum(len(p['rawIndices']) for p in geometry['parts'])==1564 and len(geometry['parts'])==54
paths={R/'rho-proof.json',G/'SOURCE_FREEZE-v2.json',G/'CODE_REPORT_FREEZE.json',G/'run-001/COMPLETED.json',G/'run-001/ORIGINAL_CONTROL_PASS.json',G/'run-001/input-hashes-before.json',G/'code/render.py',pathlib.Path(cfg['source']),R/'PLAN.md',G/'private-actual-geometry.json',G/'geometry-proof.json',G/'native-rho.json',OLD/'render_oracle.py',OLD/'source-audit.json',W/'fox-v3-character-lambert-ablation/code/render.py'};paths.update(p for p in (R/'code').rglob('*') if p.is_file() and '__pycache__' not in p.parts);paths.update(p for p in REF.rglob('*') if p.is_file() and '__pycache__' not in p.parts);paths.update(pathlib.Path(p) for p in proof['inputPins']);rho_proof=json.loads((R/'rho-proof.json').read_text());assert all(sha(p)==h for p,h in rho_proof['inputPins'].items());paths.update(pathlib.Path(p) for p in rho_proof['inputPins']);beforepins={str(p):sha(p) for p in sorted(paths)};write(out/'input-hashes-before.json',beforepins)
ns={'bpy':bpy,'np':np,'json':json,'Vector':Vector,'cfg':cfg,'REF':REF,'lookup':lookup,'sha':sha,'struct':struct}
mod=ast.parse((OLD/'render_oracle.py').read_text());wanted=['capture_settings','material_state','invariant_scene','setup','png_control'];defs=[n for n in mod.body if isinstance(n,ast.FunctionDef) and n.name in wanted];assert len(defs)==5;exec(compile(ast.Module(body=defs,type_ignores=[]),'old_pinned_setup','exec'),ns)
mod=ast.parse((W/'fox-v3-character-lambert-ablation/code/render.py').read_text());wanted=['scalar_rna','graph','frozen','material'];defs=[n for n in mod.body if isinstance(n,ast.FunctionDef) and n.name in wanted];assert len(defs)==4;exec(compile(ast.Module(body=defs,type_ignores=[]),'old_pinned_full_material_audit','exec'),ns)
digest=lambda v:hashlib.sha256(json.dumps(v,sort_keys=True,separators=(',',':'),default=list,allow_nan=False).encode()).hexdigest();materials={m['id']:m for m in geometry['materialTrace']};passflags=['use_pass_diffuse_direct','use_pass_diffuse_indirect','use_pass_diffuse_color','use_pass_glossy_direct','use_pass_glossy_indirect','use_pass_glossy_color','use_pass_transmission_direct','use_pass_transmission_indirect','use_pass_transmission_color','use_pass_emit','use_pass_environment']
def setup(case,view):
 sc=ns['setup'](11,case,view);vl=bpy.context.view_layer;assert not sc.use_nodes and not sc.cycles.use_denoising and not vl.use_pass_ambient_occlusion and not vl.cycles.use_pass_shadow_catcher
 for p in passflags:setattr(vl,p,True)
 vl.cycles.use_pass_volume_direct=True;vl.cycles.use_pass_volume_indirect=True;assert len([o for o in sc.objects if o.type=='LIGHT'])==3;return sc

def replace(sc):
 before=ns['invariant_scene'](sc);allmat={m.name:ns['material'](m) for m in bpy.data.materials};cycles=ns['scalar_rna'](sc.cycles);hidden=[];audits=[]
 for o in list(sc.objects):
  if o.type in ['MESH','CURVE'] and not o.hide_render and o.name!='Studio ground':o.hide_render=True;hidden.append(o.name)
 expected=json.loads((OLD/'source-audit.json').read_text())['characterObjects'];assert sorted(hidden)==sorted(expected)
 for part in geometry['parts']:
  node=part['node'];mt=materials[part['materialId']];mat=bpy.data.materials[mt['name']];assert ns['material'](mat)==allmat[mat.name];bs=next(n for n in mat.node_tree.nodes if n.bl_idname=='ShaderNodeBsdfPrincipled');assert list(bs.inputs['Base Color'].default_value)==mt['sourceLinear'];pos=np.array(part['sourcePositions']);norm=np.array(part['sourceFrontNormals']);indices=part['sourceIndices'];front=np.array(part['frontSNORM16']);back=np.array(part['backSNORM16']);assert np.array_equal(back,-front)
  mesh=bpy.data.meshes.new(f'Lid8 actual mesh {node}');mesh.from_pydata(pos.tolist(),[],indices);mesh.update()
  for f in mesh.polygons:f.use_smooth=True
  mesh.normals_split_custom_set_from_vertices(norm.tolist());mesh.materials.append(mat);ob=bpy.data.objects.new(f'Lid8 actual part {node}',mesh);sc.collection.objects.link(ob);assert np.array_equal(np.array([list(f.vertices) for f in mesh.polygons]),indices);assert len(mesh.materials)==1 and mesh.materials[0]==mat
  stored=np.array([n.vector[:] for n in mesh.corner_normals]);target=np.array([norm[l.vertex_index] for l in mesh.loops]);err=np.linalg.norm(stored-target,axis=1);pe=float(abs(np.array([list(v.co) for v in mesh.vertices])-pos).max());assert float(err.max())<=1e-3 and pe<=1e-6
  code=mt['albedo565'];encoded=np.array([(code>>11)/31,((code>>5)&63)/63,(code&31)/31]);native=np.where(encoded<=.04045,encoded/12.92,((encoded+.055)/1.055)**2.4)
  audits.append({'node':node,'vertices':len(pos),'triangles':len(indices),'materialName':mat.name,'materialId':part['materialId'],'originalMaterialFullStateSHA256':digest(allmat[mat.name]),'materialFullStateExact':ns['material'](mat)==allmat[mat.name],'sourceLinearRho':mt['sourceLinear'][:3],'native565':code,'native565DecodeRhoActualCFloat':native_rho[code],'nativeRhoIsNotSourceLinear':native_rho[code]!=mt['sourceLinear'][:3],'positionStorageMaxAbs':pe,'customNormalStorageMaxVectorError':float(err.max()),'customNormalStorageRMSVectorError':float(np.sqrt(np.mean(err**2)))})
 bpy.context.view_layer.update();assert ns['invariant_scene'](sc)==before;assert {m.name:ns['material'](m) for m in bpy.data.materials}==allmat;assert ns['scalar_rna'](sc.cycles)==cycles
 visible=[o for o in sc.objects if o.type in ['MESH','CURVE'] and not o.hide_render and o.name!='Studio ground'];assert len(visible)==54 and all(o.name.startswith('Lid8 actual part ') for o in visible)
 return {'parts':audits,'triangles':1564,'vertices':1163,'partCount':54,'allOriginalMaterialGraphsSocketsLinksFlagsExact':True,'allSceneLightWorldGroundCameraSettingsExact':True,'originalCharacterHiddenCount':len(hidden),'sourceFileSaved':False,'unchangedSceneSHA256':digest(before),'allMaterialStatesSHA256':digest(allmat),'fullCyclesSettings':cycles,'settings':ns['capture_settings'](sc),'geometryProofSHA256':sha(G/'geometry-proof.json')}

def render(sc,stem,proxy=False):
 png=out/'images'/(stem+'.png');sc.render.filepath=str(png);start=time.monotonic();bpy.ops.render.render(write_still=True);assert ns['capture_settings'](sc)==cfg['expectedRenderInvariantSettings'];row={'PNG':str(png.relative_to(out)),'PNGSHA256':sha(png),'seconds':time.monotonic()-start}
 if proxy:
  exr=out/'images'/(stem+'.exr');sc.render.image_settings.file_format='OPEN_EXR_MULTILAYER';sc.render.image_settings.color_depth='32';sc.render.image_settings.exr_codec='NONE';bpy.data.images['Render Result'].save_render(str(exr),scene=sc);sc.render.image_settings.file_format='PNG';sc.render.image_settings.color_depth='8';channels=exr_io.read(exr);assert all(np.isfinite(x).all() for x in channels.values());row.update(EXR=str(exr.relative_to(out)),EXRSHA256=sha(exr),channels=list(channels),alphaMin=float(channels['ViewLayer.Combined.A'].min()),alphaMax=float(channels['ViewLayer.Combined.A'].max()))
 return row

def ablate(sc):
 original={m.name:ns['material'](m) for m in bpy.data.materials};before=ns['invariant_scene'](sc);world=ns['graph'](sc.world.node_tree);copies={};records=[]
 proof=json.loads((R/'rho-proof.json').read_text());assert proof['varyingRhoParts']==0
 for p in proof['parts']:
  ob=bpy.data.objects[f"Lid8 actual part {p['node']}"];source=ob.data.materials[0];state=ns['material'](source);assert state==original[source.name];mt=materials[p['materialId']];assert source.name==mt['name']
  key=(source.name,p['A565']);assert p['A565']==p['B565'];rho=native_rho[p['A565']];assert rho==p['rhoActualCFloat']
  if key not in copies:
   nodes=source.node_tree.nodes;assert sorted(n.bl_idname for n in nodes)==['ShaderNodeBsdfPrincipled','ShaderNodeOutputMaterial'];bs=next(n for n in nodes if n.bl_idname=='ShaderNodeBsdfPrincipled');outnode=next(n for n in nodes if n.bl_idname=='ShaderNodeOutputMaterial');assert outnode.is_active_output and len(source.node_tree.links)==1 and all(not sock.is_linked for sock in bs.inputs)
   emission=list(bs.inputs['Emission Color'].default_value);strength=bs.inputs['Emission Strength'].default_value;assert strength==0 or emission[:3]==[0,0,0]
   copied=source.copy();assert ns['material'](copied)==state;tree=copied.node_tree;output=tree.nodes[outnode.name];output_before=ns['graph'](tree)['nodes'][output.name];tree.nodes.remove(tree.nodes[bs.name]);diffuse=tree.nodes.new('ShaderNodeBsdfDiffuse');diffuse.name='Native rho Lambert';diffuse.inputs['Color'].default_value=rho+[1.0];diffuse.inputs['Roughness'].default_value=0;tree.links.new(diffuse.outputs['BSDF'],output.inputs['Surface']);assert list(diffuse.inputs['Color'].default_value)==rho+[1.0] and diffuse.inputs['Roughness'].default_value==0 and all(not sock.is_linked for sock in diffuse.inputs)
   assert sorted(n.bl_idname for n in tree.nodes)==['ShaderNodeBsdfDiffuse','ShaderNodeOutputMaterial'] and len(tree.links)==1;assert ns['graph'](tree)['nodes'][output.name]==output_before;changed=ns['material'](copied);assert changed['properties']==state['properties'] and changed['cycles']==state['cycles'];copies[key]=copied
  ob.data.materials[0]=copies[key];records.append({'node':p['node'],'sourceMaterial':source.name,'rawA565':p['A565'],'rawB565':p['B565'],'colorActualCFloat':rho,'sourceLinearRho':mt['sourceLinear'][:3],'originalEmissionZero':True,'sourceMaterialHash':digest(state),'newMaterialHash':digest(ns['material'](copies[key]))})
 bpy.context.view_layer.update();after=ns['invariant_scene'](sc)
 assert {k:v for k,v in before.items() if k!='materials'}=={k:v for k,v in after.items() if k!='materials'};assert ns['graph'](sc.world.node_tree)==world;assert {name:ns['material'](bpy.data.materials[name]) for name in original}==original
 return {'parts':records,'materialCopies':len(copies),'onlyCharacterSurfaceCopyChanged':True,'originalMaterialDatablocksUnchanged':True,'worldGraphUnchanged':True,'floorLightsCameraRenderSettingsUnchanged':True,'sourceCharacterEmissionZero':True,'rhoProofSHA256':sha(R/'rho-proof.json'),'intervention':'BRDF plus native-rho, original world/floor emission retained; DiffDir not native3DISK-only'}

def reused_controls():
 freeze=json.loads((G/'CODE_REPORT_FREEZE.json').read_text());assert sha(G/'CODE_REPORT_FREEZE.json')=='433dfdf0ccf40be166aa392c03f6fd062188c42e60cee838f59682822c05e6b6';assert all(sha(G/p)==h for p,h in freeze['files'].items())
 previous=json.loads((G/'run-001/input-hashes-before.json').read_text());assert all(sha(p)==h for p,h in previous.items());controls=json.loads((G/'run-001/ORIGINAL_CONTROL_PASS.json').read_text());assert len(controls['controls'])==4
 for row in controls['controls']:
  actual=G/'run-001'/row['PNG'];assert sha(actual)==row['PNGSHA256'];expected=REF/lookup[(11,row['view'],row['case'])]['file'];ns['png_control'](actual,expected)
 return {'reusedNotRerendered':True,'fourOriginalControlsStillExact':True,'originalDependencyCount':len(previous),'priorFreezeSHA256':sha(G/'CODE_REPORT_FREEZE.json'),'sameFrozenSetupGeometryAndRenderHelpers':True}

control=reused_controls();write(out/'REUSED_CONTROL_PASS.json',control)
rows=[]
for case in ['baseline','direction']:
 view=next(v for v in cfg['cameras'] if v['name']=='oblique');sc=setup(case,view);geometry_audit=replace(sc);material_audit=ablate(sc);stem=f'lambert-seed11-oblique-{case}';auditfile=out/(stem+'-audit.json');write(auditfile,{'geometry':geometry_audit,'ablation':material_audit})
 if args[0]=='--render':
  row=render(sc,stem,True);row.update(view='oblique',case=case,seed=11,audit=auditfile.name,auditSHA256=sha(auditfile));rows.append(row);write(out/'manifest.partial.json',rows);print('LAMBERT_COMPLETE',case,flush=True)
after={str(p):sha(p) for p in paths};assert beforepins==after;assert sha(cfg['source'])==cfg['sourceSHA256'];write(out/'input-hashes-after.json',after)
status={'status':'TWO_CASE_LAMBERT_COMPLETE' if args[0]=='--render' else 'AUDIT_ONLY_COMPLETE','images':rows,'reusedOriginalControls':control,'inputsUnchanged':True,'sourceSaved':False,'sourceSHA256':sha(cfg['source']),'seed':11,'worldFloorEmissionRetained':True,'BRDFAndRhoJointIntervention':True};write(out/'COMPLETED.json',status);print(status['status'],flush=True)
