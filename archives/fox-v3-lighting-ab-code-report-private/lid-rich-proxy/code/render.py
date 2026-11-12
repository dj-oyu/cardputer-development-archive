import bpy,sys,json,pathlib,hashlib,time,ast,subprocess,struct,numpy as np
from mathutils import Vector
R=pathlib.Path(__file__).resolve().parents[1];W=R.parent;REF=W/'fox-reference-uncertainty-v3';OLD=W/'fox-v3-position-diagnostic/rich-oracle';PASS=W/'fox-v3-position-diagnostic/pass-decomposition';sys.path.insert(0,str(R/'code'));import exr_io
args=sys.argv[sys.argv.index('--')+1:];assert len(args)==2 and args[0] in ['--audit','--render'];out=pathlib.Path(args[1]).resolve();out.mkdir(exist_ok=False);(out/'images').mkdir();sha=lambda p:hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest();write=lambda p,v:p.write_text(json.dumps(v,indent=2,allow_nan=False,default=list))
cfg=json.loads((REF/'input/config.json').read_text());lookup={(r['seed'],r['view'],r['case']):r for r in json.loads((REF/'render-manifest.json').read_text())['images']};native_rho={r['code']:r['rho'] for r in json.loads((R/'native-rho.json').read_text())};geometry=json.loads((R/'private-actual-geometry.json').read_text());proof=json.loads((R/'geometry-proof.json').read_text());assert sha(R/'private-actual-geometry.json')==proof['privateGeometrySHA256'];assert sha(cfg['source'])==cfg['sourceSHA256'];assert sum(len(p['rawIndices']) for p in geometry['parts'])==1564 and len(geometry['parts'])==54
paths={pathlib.Path(cfg['source']),R/'PLAN.md',R/'private-actual-geometry.json',R/'geometry-proof.json',R/'native-rho.json',OLD/'render_oracle.py',OLD/'source-audit.json',W/'fox-v3-character-lambert-ablation/code/render.py'};paths.update(p for p in (R/'code').rglob('*') if p.is_file() and '__pycache__' not in p.parts);paths.update(p for p in REF.rglob('*') if p.is_file() and '__pycache__' not in p.parts);paths.update(pathlib.Path(p) for p in proof['inputPins']);beforepins={str(p):sha(p) for p in sorted(paths)};write(out/'input-hashes-before.json',beforepins)
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
 return {'parts':audits,'triangles':1564,'vertices':1163,'partCount':54,'allOriginalMaterialGraphsSocketsLinksFlagsExact':True,'allSceneLightWorldGroundCameraSettingsExact':True,'originalCharacterHiddenCount':len(hidden),'sourceFileSaved':False,'unchangedSceneSHA256':digest(before),'allMaterialStatesSHA256':digest(allmat),'fullCyclesSettings':cycles,'settings':ns['capture_settings'](sc),'geometryProofSHA256':sha(R/'geometry-proof.json')}

def render(sc,stem,proxy=False):
 png=out/'images'/(stem+'.png');sc.render.filepath=str(png);start=time.monotonic();bpy.ops.render.render(write_still=True);assert ns['capture_settings'](sc)==cfg['expectedRenderInvariantSettings'];row={'PNG':str(png.relative_to(out)),'PNGSHA256':sha(png),'seconds':time.monotonic()-start}
 if proxy:
  exr=out/'images'/(stem+'.exr');sc.render.image_settings.file_format='OPEN_EXR_MULTILAYER';sc.render.image_settings.color_depth='32';sc.render.image_settings.exr_codec='NONE';bpy.data.images['Render Result'].save_render(str(exr),scene=sc);sc.render.image_settings.file_format='PNG';sc.render.image_settings.color_depth='8';channels=exr_io.read(exr);assert all(np.isfinite(x).all() for x in channels.values());row.update(EXR=str(exr.relative_to(out)),EXRSHA256=sha(exr),channels=list(channels),alphaMin=float(channels['ViewLayer.Combined.A'].min()),alphaMax=float(channels['ViewLayer.Combined.A'].max()))
 return row
if args[0]=='--audit':
 audits=[]
 for case in ['baseline','direction']:
  for view in cfg['cameras']:audits.append({'view':view['name'],'case':case,'audit':replace(setup(case,view))})
 write(out/'audit.json',audits);status={'status':'AUDIT_ONLY_COMPLETE','rendered':False,'sourceSaved':False}
else:
 controls=[]
 for case in ['baseline','direction']:
  for view in cfg['cameras']:
   sc=setup(case,view);stem=f'control-seed11-{view["name"]}-{case}';row=render(sc,stem);expected=REF/lookup[(11,view['name'],case)]['file'];check=out/(stem+'-png-exact.json');strict=ns['png_control'](out/row['PNG'],expected);write(out/(stem+'-nonvolatile-chunks.json'),strict);subprocess.run(['python3',str(R/'code/png_compare.py'),str(out/row['PNG']),str(expected),str(check)],check=True);row.update(view=view['name'],case=case,controlFile=check.name,expectedSHA256=sha(expected));controls.append(row);write(out/'controls.partial.json',controls);print('ORIGINAL_CONTROL',view['name'],case,flush=True)
 write(out/'ORIGINAL_CONTROL_PASS.json',{'seed':11,'allFourOriginalPNGsExactExceptAllowedVolatileMetadata':True,'controls':controls})
 rows=[]
 for case in ['baseline','direction']:
  for view in cfg['cameras']:
   sc=setup(case,view);audit=replace(sc);stem=f'proxy-seed11-{view["name"]}-{case}';auditfile=out/(stem+'-audit.json');write(auditfile,audit);row=render(sc,stem,True);row.update(view=view['name'],case=case,seed=11,audit=auditfile.name,auditSHA256=sha(auditfile));rows.append(row);write(out/'manifest.partial.json',rows);print('PROXY_COMPLETE',view['name'],case,flush=True)
 status={'status':'FOUR_CASE_PROXY_COMPLETE','seed':11,'images':rows,'allOriginalControlsPassed':True,'noNewStabilityOrGlobalAcceptance':True,'sourceSaved':False}
after={str(p):sha(p) for p in paths};assert beforepins==after;assert sha(cfg['source'])==cfg['sourceSHA256'];write(out/'input-hashes-after.json',after);status.update(sourceSHA256=sha(cfg['source']),inputsUnchanged=True);write(out/'COMPLETED.json',status);print(status['status'],flush=True)
