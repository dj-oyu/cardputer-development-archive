import bpy,sys,json,pathlib,hashlib,time,ast,subprocess,numpy as np
from mathutils import Vector
ROOT=pathlib.Path(__file__).resolve().parents[1];P=ROOT.parent
ORACLE=P/'fox-v3-position-diagnostic/rich-oracle';PASS=P/'fox-v3-position-diagnostic/pass-decomposition';REF=P/'fox-reference-uncertainty-v3'
sys.path.insert(0,str(ROOT/'code'));import exr_io
args=sys.argv[sys.argv.index('--')+1:];assert args in [['--audit'],['--reviewer-contract-closed']]
AUDIT=args==['--audit']
sha=lambda p:hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def digest(v):return hashlib.sha256(json.dumps(v,sort_keys=True,separators=(',',':'),allow_nan=False,default=list).encode()).hexdigest()
def write(p,v):p.write_text(json.dumps(v,indent=2,allow_nan=False,default=list)+'\n')
cfg=json.loads((REF/'input/config.json').read_text());comp=json.loads((P/'fox-v3-lighting-ab/four-both-002/model-baseline/compile.json').read_text())
lookup={(r['seed'],r['view'],r['case']):r for r in json.loads((REF/'render-manifest.json').read_text())['images']}
v=np.fromfile(P/'fox-v3-position-diagnostic/observer/native-front-baseline.vertices.f64',np.float64).reshape(3,256,32,3)
paths=set([pathlib.Path(cfg['source']),ROOT/'PLAN.md',ORACLE/'render_oracle.py',ORACLE/'source-audit.json',P/'fox-v3-lighting-ab/four-both-002/model-baseline/compile.json',P/'fox-v3-position-diagnostic/observer/native-front-baseline.vertices.f64'])
for folder in [ROOT/'code',REF,PASS,ORACLE]:paths.update(p for p in folder.rglob('*') if p.is_file() and '__pycache__' not in p.parts)
paths=sorted(paths);beforepins={str(p):sha(p) for p in paths}
assert sha(cfg['source'])==cfg['sourceSHA256']
assert sha(ROOT/'code/exr_io.py')==sha(PASS/'exr_io.py') and sha(ROOT/'code/png_compare.py')==sha(PASS/'png_compare.py')
selected=['capture_settings','material_state','invariant_scene','setup','replace_character']
mod=ast.parse((ORACLE/'render_oracle.py').read_text());defs=[n for n in mod.body if isinstance(n,ast.FunctionDef) and n.name in selected];assert sorted(n.name for n in defs)==sorted(selected)
ns={'bpy':bpy,'np':np,'json':json,'Vector':Vector,'cfg':cfg,'comp':comp,'v':v,'D':ORACLE,'REF':REF,'lookup':lookup,'sha':sha,'materials':{x['id']:x for x in comp['materialTrace']}}
exec(compile(ast.Module(body=defs,type_ignores=[]),'audited_oracle_functions','exec'),ns)
passFlags=['use_pass_diffuse_direct','use_pass_diffuse_indirect','use_pass_diffuse_color','use_pass_glossy_direct','use_pass_glossy_indirect','use_pass_glossy_color','use_pass_transmission_direct','use_pass_transmission_indirect','use_pass_transmission_color','use_pass_emit','use_pass_environment']
def scalar_rna(obj):
 out={}
 for prop in obj.bl_rna.properties:
  key=prop.identifier
  if key in ['rna_type','name','name_full','users','is_updated','is_updated_data','is_embedded_data','is_library_indirect','is_runtime_data','session_uid','tag']:continue
  if prop.type in ['BOOLEAN','INT','FLOAT','STRING','ENUM']:
   val=getattr(obj,key)
   if getattr(prop,'is_array',False):val=list(val)
   if isinstance(val,set):val=sorted(val)
   out[key]=val
 return out
def graph(tree):
 if not tree:return None
 assert not tree.animation_data,'animated node tree unsupported'
 nodes={}
 for n in tree.nodes:
  def sockets(ss):
   return [{'identifier':s.identifier,'name':s.name,'type':s.bl_idname,'linked':s.is_linked,'value':list(s.default_value) if hasattr(s,'default_value') and hasattr(s.default_value,'__len__') and not isinstance(s.default_value,str) else getattr(s,'default_value',None)} for s in ss]
  nodes[n.name]={'properties':scalar_rna(n),'inputs':sockets(n.inputs),'outputs':sockets(n.outputs)}
 return {'properties':scalar_rna(tree),'nodes':nodes,'links':sorted([l.from_node.name,l.from_socket.identifier,l.to_node.name,l.to_socket.identifier] for l in tree.links)}
def material(m):
 assert not m.animation_data,'animated material unsupported'
 return {'properties':scalar_rna(m),'graph':graph(m.node_tree),'cycles':scalar_rna(m.cycles) if hasattr(m,'cycles') else None}
def ground_socket(sc):
 ground=bpy.data.objects['Studio ground'];assert ground.type=='MESH' and not ground.hide_render
 assert len(ground.data.materials)==1 and len(ground.modifiers)==0
 m=ground.data.materials[0];assert m and m.use_nodes
 users=[o.name for o in bpy.data.objects if o.type=='MESH' and any(slot.material==m for slot in o.material_slots)]
 assert users==[ground.name],('ground material shared',users)
 nodes=list(m.node_tree.nodes);assert sorted(n.bl_idname for n in nodes)==['ShaderNodeBsdfPrincipled','ShaderNodeOutputMaterial']
 bs=next(n for n in nodes if n.bl_idname=='ShaderNodeBsdfPrincipled');out=next(n for n in nodes if n.bl_idname=='ShaderNodeOutputMaterial')
 assert out.is_active_output and len(m.node_tree.links)==1
 link=list(m.node_tree.links)[0];assert link.from_node==bs and link.to_node==out and link.to_socket.name=='Surface'
 strength=bs.inputs['Emission Strength'];assert not strength.is_linked
 assert strength.default_value==.25,('unexpected emission strength',strength.default_value)
 return ground,m,bs,strength

def scene_state(sc):
 objects={}
 for o in sc.objects:
  row={'type':o.type,'properties':scalar_rna(o),'matrix':[list(r) for r in o.matrix_world]}
  if o.type=='MESH':
   row['geometry']={'vertices':[list(v.co) for v in o.data.vertices],'polygons':[[*f.vertices] for f in o.data.polygons],'materialIndices':[f.material_index for f in o.data.polygons],'smooth':[f.use_smooth for f in o.data.polygons],'cornerNormals':[list(n.vector) for n in o.data.corner_normals]}
   row['materials']=[material(s.material) if s.material else None for s in o.material_slots]
  if o.type=='LIGHT':row['light']={'properties':scalar_rna(o.data),'graph':graph(o.data.node_tree)}
  if o.type=='CAMERA':row['camera']=scalar_rna(o.data)
  objects[o.name]=row
 return {'objects':objects,'world':{'properties':scalar_rna(sc.world),'graph':graph(sc.world.node_tree)},'settings':ns['capture_settings'](sc),'render':scalar_rna(sc.render),'cycles':scalar_rna(sc.cycles),'viewLayer':scalar_rna(bpy.context.view_layer),'viewLayerCycles':scalar_rna(bpy.context.view_layer.cycles)}
def changes(a,b,path=''):
 if type(a)!=type(b):return [path]
 if isinstance(a,dict):
  if a.keys()!=b.keys():return [path+'/keys']
  return sum((changes(a[k],b[k],path+'/'+str(k)) for k in a),[])
 if isinstance(a,list):
  if len(a)!=len(b):return [path+'/length']
  return sum((changes(x,y,path+'/'+str(i)) for i,(x,y) in enumerate(zip(a,b))),[])
 return [] if a==b else [path]
def setup(seed,case,view):
 sc=ns['setup'](seed,case,view);audit=ns['replace_character'](sc);vl=bpy.context.view_layer
 assert not sc.use_nodes and not sc.cycles.use_denoising and not vl.use_pass_ambient_occlusion and not vl.cycles.use_pass_shadow_catcher
 for flag in passFlags:setattr(vl,flag,True)
 vl.cycles.use_pass_volume_direct=True;vl.cycles.use_pass_volume_indirect=True
 assert len([o for o in sc.objects if o.type=='LIGHT'])==3
 return sc,audit

def ablate(sc):
 ground,m,bs,strength=ground_socket(sc);before=scene_state(sc);original=material(m)
 actual={'object':ground.name,'material':m.name,'strength':strength.default_value,'color':list(bs.inputs['Emission Color'].default_value),'graph':original,'groundGeometryHash':digest(before['objects'][ground.name]['geometry']),'groundMatrix':before['objects'][ground.name]['matrix']}
 copied=m.copy();assert material(copied)==original,'material copy functional drift'
 ground.data.materials[0]=copied;copystate=scene_state(sc);assert copystate==before,'material assignment functional drift'
 copied.node_tree.nodes[bs.name].inputs['Emission Strength'].default_value=0
 after=scene_state(sc);diff=changes(before,after)
 assert len(diff)==1 and '/Studio ground/materials/0/graph/nodes/'+bs.name+'/inputs/' in diff[0] and diff[0].endswith('/value'),diff
 # Verify socket identity as well as unique changed field.
 sockindex=list(copied.node_tree.nodes[bs.name].inputs).index(copied.node_tree.nodes[bs.name].inputs['Emission Strength'])
 assert diff==[f'/objects/Studio ground/materials/0/graph/nodes/{bs.name}/inputs/{sockindex}/value']
 return {'actualSourceGround':actual,'beforeHash':digest(before),'copiedHash':digest(copystate),'afterHash':digest(after),'exactChanges':diff,'before':before,'after':after,'onlyEmissionStrengthChanged':True}
def pins(out):
 after={str(p):sha(p) for p in paths};write(out/'input-hashes-after.json',after);assert beforepins==after,'source/reference/code drift'

def render(sc,stem,out):
 png=out/'images'/(stem+'.png');exr=out/'images'/(stem+'.exr');assert not png.exists() and not exr.exists()
 sc.render.filepath=str(png);start=time.monotonic();bpy.ops.render.render(write_still=True)
 sc.render.image_settings.file_format='OPEN_EXR_MULTILAYER';sc.render.image_settings.color_depth='32';sc.render.image_settings.exr_codec='NONE'
 bpy.data.images['Render Result'].save_render(str(exr),scene=sc)
 sc.render.image_settings.file_format='PNG';sc.render.image_settings.color_depth='8'
 channels=exr_io.read(exr);assert all(np.isfinite(a).all() for a in channels.values())
 return {'EXR':str(exr.relative_to(out)),'EXRSHA256':sha(exr),'combinedPNG':str(png.relative_to(out)),'combinedPNGSHA256':sha(png),'channels':list(channels),'renderSeconds':time.monotonic()-start},channels

if AUDIT:
 out=ROOT/'audit-001';out.mkdir(exist_ok=False);write(out/'input-hashes-before.json',beforepins)
 sc,audit=setup(11,'baseline',next(x for x in cfg['cameras'] if x['name']=='oblique'))
 info=ablate(sc);write(out/'source-audit.json',{'sourceSHA256':sha(cfg['source']),'oracle':audit,'materialOnlyAudit':info,'rendered':False,'sourceSaved':False,'helperDefinitions':selected});pins(out)
 print('READ_ONLY_AUDIT_PASS',flush=True)
else:
 out=ROOT/'run-001';out.mkdir(exist_ok=False);(out/'images').mkdir();write(out/'input-hashes-before.json',beforepins);start=time.monotonic()
 # Identical copy/slot replacement in ON and OFF; only OFF changes the strength.
 view=next(x for x in cfg['cameras'] if x['name']=='oblique');sc,oracle=setup(11,'baseline',view)
 ground,m,bs,strength=ground_socket(sc);state=scene_state(sc);copied=m.copy();assert material(copied)==material(m);ground.data.materials[0]=copied;assert scene_state(sc)==state
 control,channels=render(sc,'control-seed-11-oblique-baseline-on',out)
 old=PASS/'images/seed-11-oblique-baseline.exr';oldchannels=exr_io.read(old)
 assert channels.keys()==oldchannels.keys(),'ON control channel set mismatch'
 for name in channels:assert channels[name].dtype==oldchannels[name].dtype and channels[name].shape==oldchannels[name].shape and channels[name].tobytes()==oldchannels[name].tobytes(),('ON control bit mismatch',name)
 subprocess.run(['python3',str(ROOT/'code/png_compare.py'),str(out/control['combinedPNG']),str(PASS/'images/seed-11-oblique-baseline-combined.png'),str(out/'on-png-control.json')],check=True)
 write(out/'ON_CONTROL_PASS.json',{'allEXRChannelsBitExact':True,'materialCopyPathSameAsOFF':True,'oldEXR':str(old),'oldEXRSHA256':sha(old),'capture':control,'functionalSceneHash':digest(state)})
 records=[]
 for seed in [11,29]:
  for case in ['baseline','direction']:
   for view in cfg['cameras']:
    sc,oracle=setup(seed,case,view);audit=ablate(sc);stem=f"seed-{seed}-{view['name']}-{case}-off";auditfile=out/(stem+'-audit.json');write(auditfile,audit)
    row,channels=render(sc,stem,out);row.update(seed=seed,view=view['name'],case=case,audit=auditfile.name,auditSHA256=sha(auditfile),onlyEmissionStrengthChanged=True,sourceSettings=ns['capture_settings'](sc),oracleTriangles=oracle['triangles'])
    records.append(row);write(out/'manifest.partial.json',records);print('OFF_CASE_COMPLETE',seed,view['name'],case,flush=True)
 pins(out);write(out/'COMPLETED.json',{'images':records,'onControlPassed':True,'allONControlEXRChannelsBitExact':True,'inputsUnchanged':True,'sourceUnchanged':True,'sourceSHA256':sha(cfg['source']),'wallSeconds':time.monotonic()-start,'scope':'paired physical ground emission strength ablation only; no source saved or native changes'})
 print('GROUND_EMISSION_ABLATION_COMPLETE',flush=True)
