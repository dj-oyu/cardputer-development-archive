import bpy,pathlib,sys,json,hashlib,time,ast,ctypes,subprocess,numpy as np
from mathutils import Vector
R=pathlib.Path(sys.argv[sys.argv.index('--')+1]).resolve();D=R/'pass-decomposition';OLD=R/'rich-oracle';P=R.parent;REF=P/'fox-reference-uncertainty-v3';sys.path.insert(0,str(D));import exr_io
sha=lambda p:hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def pins():
 for f,h in json.loads((D/'input-hashes.json').read_text()).items():assert sha(P/f)==h,'input drift '+f
 for f,h in json.loads((D/'pre-execution-hashes.json').read_text()).items():assert sha(D/f)==h,'code drift '+f
subprocess.run(['python3',str(D/'build.py')],check=True)
pins();assert not (D/'COMPLETED.json').exists();(D/'images').mkdir(exist_ok=True)
cfg=json.loads((REF/'input/config.json').read_text());comp=json.loads((P/'fox-v3-lighting-ab/four-both-002/model-baseline/compile.json').read_text());m=json.loads((REF/'render-manifest.json').read_text());lookup={(r['seed'],r['view'],r['case']):r for r in m['images']};v=np.fromfile(R/'observer/native-front-baseline.vertices.f64',np.float64).reshape(3,256,32,3)
# Execute only audited function definitions, never prior render loops or output writes.
mod=ast.parse((OLD/'render_oracle.py').read_text());ns={'bpy':bpy,'np':np,'json':json,'Vector':Vector,'cfg':cfg,'comp':comp,'v':v,'D':OLD,'REF':REF,'lookup':lookup,'sha':sha,'materials':{x['id']:x for x in comp['materialTrace']}}
exec(compile(ast.Module(body=[n for n in mod.body if isinstance(n,ast.FunctionDef)],type_ignores=[]),'frozen_oracle_functions','exec'),ns)
lib=ctypes.CDLL(str(D/'native_encode.so'));lib.native_encode.argtypes=[ctypes.c_void_p,ctypes.c_void_p,ctypes.c_size_t]
oldlookup={(r['seed'],r['view'],r['case']):r for r in json.loads((OLD/'COMPLETED.json').read_text())['images']}
passFlags=['use_pass_diffuse_direct','use_pass_diffuse_indirect','use_pass_diffuse_color','use_pass_glossy_direct','use_pass_glossy_indirect','use_pass_glossy_color','use_pass_transmission_direct','use_pass_transmission_indirect','use_pass_transmission_color','use_pass_emit','use_pass_environment']
records=[];start=time.monotonic()
def display(sc,rgb,path,rawview=False):
 assert rgb.shape==(135,240,3) and np.isfinite(rgb).all();im=bpy.data.images.new('Diagnostic linear array',width=240,height=135,alpha=True,float_buffer=True);im.colorspace_settings.name='Linear Rec.709';im.alpha_mode='STRAIGHT';rgba=np.concatenate([rgb.astype(np.float32),np.ones((135,240,1),np.float32)],-1);im.pixels.foreach_set(np.ascontiguousarray(rgba[::-1]).ravel());im.update()
 oldview=sc.view_settings.view_transform;oldlook=sc.view_settings.look
 if rawview:sc.view_settings.view_transform='Raw';sc.view_settings.look='None'
 try:
  # No RenderLayers node: this invokes only the common compositor/output quantizer.
  sc.use_nodes=True;sc.node_tree.nodes.clear();inp=sc.node_tree.nodes.new('CompositorNodeImage');inp.image=im;out=sc.node_tree.nodes.new('CompositorNodeComposite');sc.node_tree.links.new(inp.outputs['Image'],out.inputs['Image']);sc.render.filepath=str(path);bpy.ops.render.render(write_still=True)
 finally:sc.view_settings.view_transform=oldview;sc.view_settings.look=oldlook;bpy.data.images.remove(im)
for seed in [11,29]:
 for case in ['baseline','direction']:
  for view in cfg['cameras']:
   stem=f"seed-{seed}-{view['name']}-{case}";sc=ns['setup'](seed,case,view);audit=ns['replace_character'](sc);vl=bpy.context.view_layer;assert not sc.use_nodes and not sc.cycles.use_denoising and not vl.use_pass_ambient_occlusion and not vl.cycles.use_pass_shadow_catcher;assert not any(getattr(o,'is_shadow_catcher',False) for o in sc.objects if o.type in ('MESH','CURVE','SURFACE','META','FONT','VOLUME'))
   for flag in passFlags:setattr(vl,flag,True)
   vl.cycles.use_pass_volume_direct=True;vl.cycles.use_pass_volume_indirect=True
   png=D/'images'/(stem+'-combined.png');assert not png.exists();sc.render.filepath=str(png);t=time.monotonic();bpy.ops.render.render(write_still=True);renderSeconds=time.monotonic()-t;old=oldlookup[(seed,view['name'],case)];oldpng=OLD/old['file'];assert sha(oldpng)==old['sha256'];subprocess.run(['python3',str(D/'png_compare.py'),str(png),str(oldpng),str(D/(stem+'-original-control.json'))],check=True)
   exr=D/'images'/(stem+'.exr');sc.render.image_settings.file_format='OPEN_EXR_MULTILAYER';sc.render.image_settings.color_depth='32';sc.render.image_settings.exr_codec='NONE';bpy.data.images['Render Result'].save_render(str(exr),scene=sc);sc.render.image_settings.file_format='PNG';sc.render.image_settings.color_depth='8'
   channels=exr_io.read(exr)
   def rgb(name):
    return np.stack([channels['ViewLayer.'+name+'.'+c] for c in 'RGB'],-1).astype(np.float64)
   combined=rgb('Combined');alpha=channels['ViewLayer.Combined.A'];assert np.array_equal(alpha,np.ones_like(alpha)),'nonopaque alpha unsupported'
   dc=rgb('DiffCol');gc=rgb('GlossCol');tc=rgb('TransCol');directspec=rgb('GlossDir')*gc;indirectdiff=rgb('DiffInd')*dc;reconstructed=(rgb('DiffDir')+rgb('DiffInd'))*dc+(rgb('GlossDir')+rgb('GlossInd'))*gc+(rgb('TransDir')+rgb('TransInd'))*tc+rgb('VolumeDir')+rgb('VolumeInd')+rgb('Emit')+rgb('Env');residual=reconstructed-combined;bound=2e-5+5e-6*abs(combined);oldGate=bool((abs(residual)<=bound).all());unexplainedResidual=combined-reconstructed
   rebuilt=D/'images'/(stem+'-redisplayed.png');display(sc,combined,rebuilt);subprocess.run(['python3',str(D/'png_compare.py'),str(png),str(rebuilt),str(D/(stem+'-display-control.json')),'--allow-difference'],check=True)
   analysis={'Combined':combined,'remove-direct-specular':combined-directspec,'remove-indirect-diffuse':combined-indirectdiff};negative={}
   for name,a in analysis.items():
    negative[name]={'negativeComponents':int((a<0).sum()),'minimum':float(a.min())};assert (a>=-bound).all(),('negative contribution outside tolerance',name,float(a.min()))
   assert (combined>=0).all();encoded=np.empty(combined.shape,np.float32);input32=np.ascontiguousarray(combined,np.float32);assert lib.native_encode(input32.ctypes.data,encoded.ctypes.data,encoded.size)==1
   outputs={}
   for arm,raw in [('profile-native-srgb',encoded),('remove-direct-specular',analysis['remove-direct-specular']),('remove-indirect-diffuse',analysis['remove-indirect-diffuse'])]:
    path=D/'images'/(stem+'-'+arm+'.png');display(sc,raw,path,rawview=arm=='profile-native-srgb');outputs[arm]={'file':str(path.relative_to(D)),'sha256':sha(path)}
   np.savez_compressed(D/'images'/(stem+'-components.npz'),combined=combined,directSpecular=directspec,indirectDiffuse=indirectdiff,reconstructed=reconstructed,unexplainedResidual=unexplainedResidual)
   row={'seed':seed,'view':view['name'],'case':case,'renderSeconds':renderSeconds,'combinedPNG':str(png.relative_to(D)),'combinedPNGSHA256':sha(png),'EXR':str(exr.relative_to(D)),'EXRSHA256':sha(exr),'channels':list(channels),'redisplayedPNG':str(rebuilt.relative_to(D)),'redisplayedPNGSHA256':sha(rebuilt),'oldRecompositionGatePassed':oldGate,'oldRecompositionGateViolatingComponents':int((abs(residual)>bound).sum()),'unexplainedResidualRetained':True,'residualMaxAbs':float(abs(residual).max()),'residualRMSE':float(np.sqrt(np.mean(residual**2))),'negative':negative,'outputs':outputs,'sourceSettings':ns['capture_settings'](sc),'originalShadingCompositorNodes':False,'postprocessCompositorNodes':sc.use_nodes,'alphaAllOne':True,'clampDirect':sc.cycles.sample_clamp_direct,'clampIndirect':sc.cycles.sample_clamp_indirect,'sameRenderContributionOnly':True};records.append(row);(D/'manifest.partial.json').write_text(json.dumps(records,indent=2));print('PASS_CASE_COMPLETE',seed,view['name'],case,flush=True)
pins();(D/'COMPLETED.json').write_text(json.dumps({'images':records,'wallSeconds':time.monotonic()-start,'scope':'Fixed3post-render comparisons; not physicalrerenders'},indent=2));print('PASS_DECOMPOSITION_COMPLETE',flush=True)
