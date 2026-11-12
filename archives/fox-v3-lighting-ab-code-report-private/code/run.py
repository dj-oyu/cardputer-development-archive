import pathlib,sys,json,hashlib,subprocess,shutil,os,time
R=pathlib.Path(__file__).resolve().parents[1];W=R.parent
HEAD='4a4d4cf77f6c336971eb271324b34a32b4c2aa01+linear-disk-local'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def run(args,log):
 with log.open('w') as f:subprocess.run([str(x) for x in args],stdout=f,stderr=subprocess.STDOUT,check=True)
out=pathlib.Path(sys.argv[1]).resolve();out.mkdir(parents=True,exist_ok=False)
# Execute from a fresh code/input snapshot; concurrent work cannot change evaluated sources.
for name in ['code','product','inputs','physical']:
 if name=='physical':
  (out/name).mkdir()
  for p in (R/name).iterdir():
   if p.is_file() and p.suffix in ['.c','.h','.py','.md','.json','.sh','.txt']:shutil.copy2(p,out/name/p.name)
 else:shutil.copytree(R/name,out/name,ignore=shutil.ignore_patterns('__pycache__','.cache','*.log'))
cfg=json.loads((out/'inputs/candidate-config.json').read_text());mode=os.environ.get('HONE_LINEAR_LIGHT','0');assert mode in ['0','1'];cfg['linearLightEnabled']=mode=='1';physical_mode=os.environ.get('HONE_PHYSICAL_LIGHT','0');assert physical_mode in ['0','1'];cfg['physicalDiskEnabled']=physical_mode=='1';physical=json.loads((out/'inputs/physical-source.json').read_text());assert physical['sourceSHA256']==cfg['sourceSHA256'];assert physical['refConfigSHA256']==cfg['referenceConfigSHA256'];
if cfg['physicalDiskEnabled']:
 for case in cfg['scenarios']:case['physical']=next(x for x in physical['cases'] if x['name']==case['name'])
if cfg['physicalDiskEnabled']:
 cfg['mapping']='Source three DISK16 direct Lambert plus uniform colored world; artist .65 excluded; '+('decoded linear rho then sRGB output' if cfg['linearLightEnabled'] else 'encoded rho and output: factor-separation diagnostic, NOT physical linear light')
 cfg['unsupported']=['area/world occlusion','ground emission/reflection','GI','PBR/GGX/specular','AgX display profile','pixel physical shading','general asset-unit API','animation validation']
elif cfg['linearLightEnabled']:cfg['mapping']='Legacy single directional capacity projection with explicit sRGB albedo decode, linear artist ambient/diffuse, clamp and sRGB encode; not physical area-light equivalence'
(out/'inputs/candidate-config.json').write_text(json.dumps(cfg,indent=2));ref=W/'fox-reference-uncertainty-v3';rc=json.loads((ref/'input/config.json').read_text());assert sha(ref/'input/config.json')==cfg['referenceConfigSHA256'];source=pathlib.Path(rc['source']);assert sha(source)==cfg['sourceSHA256']
inputs=[p for d in ['code','product','inputs','physical'] for p in (out/d).rglob('*') if p.is_file()];hashes={str(p.relative_to(out)):sha(p) for p in inputs};(out/'input-hashes-start.json').write_text(json.dumps(hashes,indent=2))
main=out/'product/main';native=out/'native-render';flags=['-std=c11','-O2','-Wall','-Wextra','-Werror','-Wno-misleading-indentation','-ffp-contract=off','-fexcess-precision=standard']
run(['cc',*flags,'-I',main,'-I',out/'physical',out/'code/native_render.c',out/'physical/fox_disk_lighting.c',*[main/p for p in ['ayatsuri/ayatsuri_model.c','ayatsuri/ayatsuri_visibility.c','ayatsuri/compact_opaque.c','ui/kasane/ksn_mesh_depth.c','ui/kasane/ksn_procedural.c']],'-lm','-o',native],out/'build.log')
frames=[];accounting=[];negatives=[]
for scenario in cfg['scenarios']:
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
  meta=json.loads(pathlib.Path(str(prefix)+'.json').read_text());assert meta['physicalDiskEnabled']==cfg['physicalDiskEnabled'];assert meta['linearLightEnabled']==cfg['linearLightEnabled'];assert all(abs(a-b)<1e-5 for a,b in zip(meta['camera'],cam['nativeCamera']));assert all(abs(a-b)<1e-6 for a,b in zip(meta['light'],light))
  for ext in ['.u16le','.f32le']:assert pathlib.Path(str(prefix)+ext).read_bytes()==pathlib.Path(str(prefix)+'-reverse'+ext).read_bytes(),'ORDER_DIFFERENCE'
  rgb=pathlib.Path(str(prefix)+'.u16le');depth=pathlib.Path(str(prefix)+'.f32le');assert rgb.stat().st_size==64800 and depth.stat().st_size==129600
  frames.append({'view':cam['name'],'case':case,'rgb565':{'file':rgb.name,'sha256':sha(rgb)},'depth':{'file':depth.name,'sha256':sha(depth)},'metadata':{'resolution':[240,135],'nativeCamera':cam['nativeCamera'],'scenario':next(s for s in rc['scenarios'] if s['name']==case),'sourceLabel':'preserved 1166-triangle static export, authored sidedness restored','head':HEAD,'actual':meta,'nativeInput':scenario}});accounting.append({'view':cam['name'],'case':case,**meta})
# Runtime camera nonfinite rejection must happen before any buffer publication.
bad=out/'invalid-camera';cmd=[str(native),str(out/'model-baseline/model.aynm'),str(bad),'0','nan',*map(str,cfg['cameras'][0]['nativeCamera'][1:]),*map(str,cfg['scenarios'][0]['nativeDirection']+cfg['scenarios'][0]['intensity'])]
p=subprocess.run(cmd,capture_output=True,text=True);assert p.returncode!=0 and 'NATIVE_GATE:evaluate' in p.stderr and not pathlib.Path(str(bad)+'.u16le').exists();negatives.append('nonfinite camera rejected before output')
assert all(sha(out/p)==h for p,h in hashes.items());assert sha(source)==cfg['sourceSHA256'];assert sha(ref/'input/config.json')==cfg['referenceConfigSHA256']
m={'schemaVersion':'fox-candidate-rgb565-v1','candidate':{'label':'rebuilt-4a4d-linear-'+mode+'-physical-'+physical_mode+'-1166tri-v3','sourceLabel':'preserved 1166-triangle static export, authored sidedness restored','head':HEAD,'sourceFiles':[{'file':p,'sha256':h} for p,h in hashes.items()]},'reference':{'version':'new-reference-uncertainty-v3','configSHA256':cfg['referenceConfigSHA256']},'resolution':[240,135],'rgb565Format':'RGB565_U16_LE_ROW_MAJOR','depthFormat':'FLOAT32_LE_ROW_MAJOR_NEG_INF_BACKGROUND','frames':frames,'build':{'flags':flags,'binarySHA256':sha(native)},'scope':cfg['mapping'],'unsupported':cfg['unsupported']}
(out/'candidate-manifest.json').write_text(json.dumps(m,indent=2));(out/'accounting.json').write_text(json.dumps(accounting,indent=2));(out/'functional.json').write_text(json.dumps({'orderExactAll10':True,'disposedPoisonedBeforeRender':True,'negativeTests':negatives,'inputsUnchanged':True},indent=2));print(out/'candidate-manifest.json')
