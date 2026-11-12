import pathlib,sys,json,hashlib,subprocess,shutil,os,time,math
R=pathlib.Path(__file__).resolve().parents[1];W=R.parent
HEAD='4a4d4cf77f6c336971eb271324b34a32b4c2aa01+linear-disk-pixel-visibility-ground-bounce-local'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def run(args,log):
 with log.open('w') as f:subprocess.run([str(x) for x in args],stdout=f,stderr=subprocess.STDOUT,check=True)
def fnv64(data):
 value=14695981039346656037
 for byte in data:value=((value^byte)*1099511628211)&0xffffffffffffffff
 return format(value,'016x')
def validate_ground(meta,cfg,scenario):
 ground=scenario['ground'];enabled=bool(cfg['groundMode'])
 assert meta['groundMode']==cfg['groundMode']
 for actual,expected in [('groundObjectId','objectId'),('groundFirstTriangle','firstTriangle'),('groundTriangleCount','triangleCount'),('emissionGeneration','emissionGeneration'),('groundInputFingerprint','inputFingerprint')]:
  assert meta[actual]==ground[expected],actual
 assert len(meta['groundLe'])==3 and all(math.isfinite(a) and abs(a-b)<=1e-15 for a,b in zip(meta['groundLe'],ground['linearLe']))
 assert meta['visibilityGeneration']==([2,1,1] if enabled else [1,1,1])
 assert meta['visibilityVertices']==(853 if enabled else 849)
 assert meta['visibilityTriangles']==(1168 if enabled else 1166)
 assert meta['materialGeneration']==1 and meta['innerSamples']==16
 assert meta['transportContextBytes']==272
 assert meta['transportSceneBytes']==(75312 if enabled else 75184)
 assert meta['visibilitySceneBytes']==(327056 if enabled else 326496)
 for field,value in [('visibilityRayLimit',1000000),('visibilityNodeLimit',100000000),('visibilityTriangleLimit',50000000),('visibilitySceneLimit',524288),('transportRayLimit',20000000),('transportNodeLimit',800000000),('transportTriangleLimit',300000000),('transportSceneLimit',262144)]:
  assert meta[field]==value,field
 assert meta['disposedBeforeRender'] is True
 assert meta['primary_hits']+meta['primary_misses']==meta['primary_rays']
 for field in ['primary_ground_hits','primary_ground_emission_hits','secondary_ground_hits']:
  assert type(meta[field]) is int and meta[field]>=0
 assert meta['primary_ground_hits']<=meta['primary_hits']
 assert meta['secondary_ground_hits']<=meta['secondary_world_rays']
 assert meta['primary_ground_emission_hits']==(meta['primary_ground_hits'] if cfg['groundMode']==2 else 0)
 if not enabled:assert meta['primary_ground_hits']==meta['secondary_ground_hits']==0
 for group in ['visibility','transport']:
  for used,limit in [('Rays','RayLimit'),('NodeVisits','NodeLimit'),('TriangleTests','TriangleLimit'),('SceneBytes','SceneLimit')]:
   assert 0<=meta[group+used]<=meta[group+limit],group+used
 assert meta['visibilityTemporaryBytes']==meta['visibilityVertices']*3*8+meta['visibilityTriangles']*3*4
 assert meta['transportTemporaryBytes']==meta['visibilityTriangles']*64
 assert meta['snapshotBytes']<=meta['snapshotCapacity']==65536
 assert meta['depthScratchBytes']==7680 and meta['colorBandBytes']==3840
out=pathlib.Path(sys.argv[1]).resolve();out.mkdir(parents=True,exist_ok=False)
# Execute from a fresh code/input snapshot; concurrent work cannot change evaluated sources.
for name in ['code','product','inputs','physical','visibility','transport']:
 if name=='physical':
  (out/name).mkdir()
  for p in (R/name).iterdir():
   if p.is_file() and p.suffix in ['.c','.h','.py','.md','.json','.sh','.txt']:shutil.copy2(p,out/name/p.name)
 else:shutil.copytree(R/name,out/name,ignore=shutil.ignore_patterns('__pycache__','.cache','*.log'))
cfg=json.loads((out/'inputs/candidate-config.json').read_text());mode=os.environ.get('HONE_LINEAR_LIGHT','1');assert mode in ['0','1'];cfg['linearLightEnabled']=mode=='1';physical_mode=os.environ.get('HONE_PHYSICAL_LIGHT','1');assert physical_mode in ['0','1'];cfg['physicalDiskEnabled']=physical_mode=='1';pixel_mode=os.environ.get('HONE_PIXEL_LIGHT','1');assert pixel_mode in ['0','1'];cfg['pixelLightEnabled']=pixel_mode=='1';visibility_mode=os.environ.get('HONE_PIXEL_VISIBILITY','1');assert visibility_mode in ['0','1'];cfg['visibilityEnabled']=visibility_mode=='1';assert not cfg['visibilityEnabled'] or cfg['pixelLightEnabled'];transport_mode=os.environ.get('HONE_TRANSPORT_MODE','2');assert transport_mode in ['0','1','2'];cfg['transportMode']=int(transport_mode);cfg['outerSamples']=int(os.environ.get('HONE_OUTER_SAMPLES','16'));cfg['innerSamples']=16;assert cfg['outerSamples'] in [16,64];assert not cfg['transportMode'] or cfg['visibilityEnabled'];cfg['agxProfileEnabled']=False;assert not cfg['pixelLightEnabled'] or (cfg['linearLightEnabled'] and cfg['physicalDiskEnabled']);physical=json.loads((out/'inputs/physical-source.json').read_text());assert physical['sourceSHA256']==cfg['sourceSHA256'];assert physical['refConfigSHA256']==cfg['referenceConfigSHA256'];
if cfg['physicalDiskEnabled']:
 for case in cfg['scenarios']:case['physical']=next(x for x in physical['cases'] if x['name']==case['name'])
if cfg['physicalDiskEnabled']:
 cfg['mapping']='Source three DISK16 direct Lambert plus uniform colored world; artist .65 excluded; '+('decoded linear rho then sRGB output' if cfg['linearLightEnabled'] else 'encoded rho and output: factor-separation diagnostic, NOT physical linear light')
 cfg['unsupported']=['area/world occlusion','ground emission/reflection','GI','PBR/GGX/specular','AgX display profile','pixel physical shading','general asset-unit API','animation validation']
elif cfg['linearLightEnabled']:cfg['mapping']='Legacy single directional capacity projection with explicit sRGB albedo decode, linear artist ambient/diffuse, clamp and sRGB encode; not physical area-light equivalence'
if cfg['pixelLightEnabled']:
 cfg['mapping']+='; pixel-rate raw world/SNORM/rho interpolation then same direct DISK16+world, clamp+sRGB RGB565; no AgX/visibility'
 cfg['unsupported'].remove('pixel physical shading')
if cfg['visibilityEnabled']:
 cfg['mapping']+='; bounded owned character-only BVH visibility, immutable generation binding, no ground occluder/world visibility'
 cfg['unsupported'].remove('area/world occlusion');cfg['unsupported']+=['world occlusion','ground occluder','product RAM fit/Pocket lifecycle integration']
if cfg['transportMode']:
 cfg['mapping']+='; world term replaced by cosine visible misses, '+('no surface reflection' if cfg['transportMode']==1 else 'one Lambert diffuse reflection with secondary direct visibility and visible world')
 cfg['unsupported']=[x for x in cfg['unsupported'] if x not in ['world occlusion','GI']]+['higher bounce GI','ground geometry/emission/reflection','PBR specular transport']
(out/'inputs/candidate-config.json').write_text(json.dumps(cfg,indent=2));ref=W/'fox-reference-uncertainty-v3';rc=json.loads((ref/'input/config.json').read_text());assert sha(ref/'input/config.json')==cfg['referenceConfigSHA256'];source=pathlib.Path(rc['source']);assert sha(source)==cfg['sourceSHA256']
# The three ground arms all retain identical one-reflection transport settings.
ground_mode=os.environ.get('HONE_GROUND_MODE','0');assert ground_mode in ['0','1','2']
cfg['groundMode']=int(ground_mode)
assert cfg['transportMode']==2 and cfg['visibilityEnabled'] and cfg['pixelLightEnabled'] and cfg['physicalDiskEnabled'] and cfg['linearLightEnabled']
assert len(cfg['scenarios'])==5 and len(cfg['cameras'])==2
assert len({x['name'] for x in cfg['scenarios']})==5 and len({x['name'] for x in cfg['cameras']})==2
ground_source_path=out/'inputs/ground-source.json';ground_source=json.loads(ground_source_path.read_text())
cfg['groundSourceSHA256']=sha(ground_source_path)
assert cfg['groundSourceSHA256']=='6320121022bc7ab8f23300b45181d58ed09e1bdffd7e2239fbd5194e9521be9b','GROUND_SOURCE_DRIFT'
assert ground_source['sourceSHA256']==cfg['sourceSHA256'] and ground_source['referenceConfigSHA256']==cfg['referenceConfigSHA256']
assert ground_source['object']=='Studio ground' and ground_source['privateGeometryDoNotBundle'] is True
vertices=ground_source['worldVertices'];triangles=ground_source['triangles']
assert len(vertices)==4 and all(len(v)==3 and all(math.isfinite(x) for x in v) for v in vertices)
assert triangles==[[0,1,3],[0,3,2]]
assert {x['name'] for x in ground_source['scenarios']}=={x['name'] for x in cfg['scenarios']}
for scenario in cfg['scenarios']:
 source_case=next(x for x in ground_source['scenarios'] if x['name']==scenario['name'])
 le=source_case['linearLe'];assert len(le)==3 and all(math.isfinite(x) and x>=0 for x in le)
 assert source_case['emissionUnchanged'] is True and le==ground_source['linearLe']
 assert le==[x*source_case['emissionStrength'] for x in source_case['emissionColor'][:3]]
 assert source_case['albedoScale']==scenario['albedoScale']
 # Native consumes precisely these unscaled Blender-world coordinates and source-linear Le.
 ground_file=out/'inputs'/('ground-'+scenario['name']+'.txt')
 text='FOXGROUND1\n'+'\n'.join(' '.join(format(x,'.17g') for x in v) for v in vertices)+'\n'
 text+='\n'.join(' '.join(str(x) for x in t) for t in triangles)+'\n'
 text+=' '.join(format(x,'.17g') for x in le)+'\n';ground_file.write_text(text)
 on=bool(cfg['groundMode'])
 scenario['ground']={'mode':cfg['groundMode'],'objectId':1 if on else 0,'firstTriangle':1166 if on else 0,'triangleCount':2 if on else 0,'emissionGeneration':1 if on else 0,'linearLe':le if on else [0,0,0],'inputFile':str(ground_file.relative_to(out)),'inputSHA256':sha(ground_file),'inputFingerprint':fnv64(ground_file.read_bytes()) if on else '0000000000000000','sourceSHA256':cfg['groundSourceSHA256']}
cfg['mapping']='Private host-only three-arm ground diagnostic; fixed one Lambert reflection with DISK16 visibility and cosine visible world; '+['floor omitted (OFF)','finite source ground occludes rays with zero radiance (CONTROL)','finite source ground occludes rays and supplies source-linear Le at primary hemisphere first hits (PRIMARY_LE)'][cfg['groundMode']]
cfg['unsupported']=['ground camera rasterization','ground BSDF/reflection','secondary ground emission','higher bounce GI','PBR/GGX/specular','AgX display profile','general asset-unit API','animation validation','product RAM fit/Pocket lifecycle integration']
(out/'inputs/candidate-config.json').write_text(json.dumps(cfg,indent=2))
# Publish explicit settings to subprocesses, including when caller uses defaults.
for key,value in [('HONE_LINEAR_LIGHT',mode),('HONE_PHYSICAL_LIGHT',physical_mode),('HONE_PIXEL_LIGHT',pixel_mode),('HONE_PIXEL_VISIBILITY',visibility_mode),('HONE_TRANSPORT_MODE',transport_mode),('HONE_OUTER_SAMPLES',str(cfg['outerSamples']))]:os.environ[key]=value
if cfg['groundMode']:os.environ['HONE_GROUND_MODE']=ground_mode
else:os.environ.pop('HONE_GROUND_MODE',None)
inputs=[p for d in ['code','product','inputs','physical','visibility','transport'] for p in (out/d).rglob('*') if p.is_file()];hashes={str(p.relative_to(out)):sha(p) for p in inputs};(out/'input-hashes-start.json').write_text(json.dumps(hashes,indent=2))
main=out/'product/main';native=out/'native-render';flags=['-std=c11','-O2','-Wall','-Wextra','-Werror','-Wno-misleading-indentation','-ffp-contract=off','-fexcess-precision=standard']
run(['cc',*flags,'-I',main,'-I',out/'physical','-I',out/'visibility','-I',out/'transport',out/'code/native_render.c',out/'transport/bounce.c',out/'transport/pixel_transport.c',out/'visibility/visibility.c',out/'visibility/pixel_binding.c',out/'physical/fox_disk_lighting.c',*[main/p for p in ['ayatsuri/ayatsuri_model.c','ayatsuri/ayatsuri_visibility.c','ayatsuri/compact_opaque.c','ui/kasane/ksn_mesh_depth.c','ui/kasane/ksn_procedural.c']],'-lm','-o',native],out/'build.log')
frames=[];accounting=[];negatives=[]
for scenario in cfg['scenarios']:
 if cfg['groundMode']:os.environ['HONE_GROUND_FILE']=str(out/scenario['ground']['inputFile'])
 else:os.environ.pop('HONE_GROUND_FILE',None)
 case=scenario['name'];sp=out/(case+'.json');sp.write_text(json.dumps(scenario));md=out/('model-'+case)
 run(['node',out/'code/compile.cjs',out/'inputs/geometry-source-sided.glb',sp,md],out/('compile-'+case+'.log'))
 light=scenario['nativeDirection']+scenario['intensity']
 if cfg['physicalDiskEnabled']:
  pc=scenario['physical'];vals=[]
  for l in pc['lights']:
   assert l['shape']=='DISK';vals.extend(l['position']+l['eulerXYZ']+l['color']+[l['power'],l['diameter']])
  vals.extend(pc['worldRGB']+[pc['worldStrength']]);fp=out/('physical-'+case+'.txt');fp.write_text('FOXDISK1\n'+' '.join(format(x,'.17g') for x in vals)+'\n');os.environ['HONE_DISK_FILE']=str(fp)
 else:os.environ.pop('HONE_DISK_FILE',None)
 for cam in cfg['cameras']:
  prefix=out/('native-'+cam['name']+'-'+case)
  for rev in [0,1]:
   p=pathlib.Path(str(prefix)+('-reverse' if rev else ''))
   run([native,md/'model.aynm',p,rev,*cam['nativeCamera'],*light],pathlib.Path(str(p)+'.json'))
  meta=json.loads(pathlib.Path(str(prefix)+'.json').read_text());assert meta['transportMode']==cfg['transportMode'] and meta['transportComplete'];assert meta['outerSamples']==cfg['outerSamples'];assert meta['visibilityEnabled']==cfg['visibilityEnabled'] and meta['visibilityComplete'];assert meta['pixelLightEnabled']==cfg['pixelLightEnabled'] and meta['agxProfileEnabled']==False;assert meta['physicalDiskEnabled']==cfg['physicalDiskEnabled'];assert meta['linearLightEnabled']==cfg['linearLightEnabled'];assert all(abs(a-b)<1e-5 for a,b in zip(meta['camera'],cam['nativeCamera']));assert all(abs(a-b)<1e-6 for a,b in zip(meta['light'],light))
  validate_ground(meta,cfg,scenario)
  reverse_meta=json.loads(pathlib.Path(str(prefix)+'-reverse.json').read_text());validate_ground(reverse_meta,cfg,scenario)
  for field in ['transportMode','transportComplete','outerSamples','visibilityEnabled','visibilityComplete','pixelLightEnabled','agxProfileEnabled','physicalDiskEnabled','linearLightEnabled','camera','light']:
   assert reverse_meta[field]==meta[field],field+'_REVERSE_METADATA_DIFFERENCE'
  assert meta['reverse'] is False and reverse_meta['reverse'] is True
  for field in ['groundMode','groundObjectId','groundFirstTriangle','groundTriangleCount','emissionGeneration','groundLe','groundInputFingerprint','visibilityGeneration','visibilityGeometryFingerprint','materialFingerprint']:
   assert meta[field]==reverse_meta[field],field+'_ORDER_DIFFERENCE'
  for ext in ['.u16le','.f32le']:assert pathlib.Path(str(prefix)+ext).read_bytes()==pathlib.Path(str(prefix)+'-reverse'+ext).read_bytes(),'ORDER_DIFFERENCE'
  rgb=pathlib.Path(str(prefix)+'.u16le');depth=pathlib.Path(str(prefix)+'.f32le');assert rgb.stat().st_size==64800 and depth.stat().st_size==129600
  frames.append({'view':cam['name'],'case':case,'rgb565':{'file':rgb.name,'sha256':sha(rgb)},'depth':{'file':depth.name,'sha256':sha(depth)},'metadata':{'resolution':[240,135],'nativeCamera':cam['nativeCamera'],'scenario':next(s for s in rc['scenarios'] if s['name']==case),'sourceLabel':'preserved 1166-triangle static export, authored sidedness restored','head':HEAD,'actual':meta,'nativeInput':scenario}});accounting.append({'view':cam['name'],'case':case,**meta})
# Runtime camera nonfinite rejection must happen before any buffer publication.
bad=out/'invalid-camera';cmd=[str(native),str(out/'model-baseline/model.aynm'),str(bad),'0','nan',*map(str,cfg['cameras'][0]['nativeCamera'][1:]),*map(str,cfg['scenarios'][0]['nativeDirection']+cfg['scenarios'][0]['intensity'])]
p=subprocess.run(cmd,capture_output=True,text=True);assert p.returncode!=0 and 'NATIVE_GATE:evaluate' in p.stderr and not pathlib.Path(str(bad)+'.u16le').exists();negatives.append('nonfinite camera rejected before output')
assert len(frames)==10 and len(accounting)==10
assert all(sha(out/p)==h for p,h in hashes.items());assert sha(source)==cfg['sourceSHA256'];assert sha(ref/'input/config.json')==cfg['referenceConfigSHA256']
m={'schemaVersion':'fox-candidate-rgb565-v1','candidate':{'label':'rebuilt-4a4d-linear-'+mode+'-physical-'+physical_mode+'-pixel-'+pixel_mode+'-ground-'+ground_mode+'-1166tri-v3','sourceLabel':'preserved 1166-triangle static export, authored sidedness restored','head':HEAD,'sourceFiles':[{'file':p,'sha256':h} for p,h in hashes.items()]},'reference':{'version':'new-reference-uncertainty-v3','configSHA256':cfg['referenceConfigSHA256']},'resolution':[240,135],'rgb565Format':'RGB565_U16_LE_ROW_MAJOR','depthFormat':'FLOAT32_LE_ROW_MAJOR_NEG_INF_BACKGROUND','frames':frames,'build':{'flags':flags,'binarySHA256':sha(native)},'scope':cfg['mapping'],'unsupported':cfg['unsupported']}
(out/'candidate-manifest.json').write_text(json.dumps(m,indent=2));(out/'accounting.json').write_text(json.dumps(accounting,indent=2));(out/'functional.json').write_text(json.dumps({'orderExactAll10':True,'groundMetadataAll10':True,'reverseGroundMetadataAll10':True,'disposedPoisonedBeforeRender':True,'negativeTests':negatives,'inputsUnchanged':True},indent=2));print(out/'candidate-manifest.json')
