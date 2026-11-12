"""Strict offline static-fixture preparation. No evaluator, ray or renderer calls."""
import ctypes as C, hashlib,json,math,os,pathlib,re,struct,tempfile
HERE=pathlib.Path(__file__).resolve().parent
ROOT=HERE.parent.parent
INPUT=ROOT/'fox-v3-floor-direct-reflection-evaluation/actual-002/inputs'
PINS={'physical-source.json':'df54b60b50702516c84e570446225d5b0f861def469b7816a987d9f8a1167bff','ground-source.json':'6320121022bc7ab8f23300b45181d58ed09e1bdffd7e2239fbd5194e9521be9b','candidate-config.json':'d48a1a03221c6d99a0ad8076e5d2f4dd1f90ed6f25b574e00dcbdab06c494a30','source-materials.json':'70aa3443dcd0b128b16a149e2ad5009ab8b00e48c468554c9404b5708c7e69af'}
def require(x,msg):
 if not x:raise ValueError(msg)
def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def pairs(ps):
 d={}
 for k,v in ps:
  require(k not in d,'duplicate JSON key');d[k]=v
 return d
def loads(s):
 require(len(s.encode())<=2*1024*1024,'input byte limit')
 def reject(x):raise ValueError('nonfinite JSON constant')
 try:d=json.loads(s,object_pairs_hook=pairs,parse_constant=reject)
 except (RecursionError,OverflowError) as e:raise ValueError('JSON nesting/numeric range') from e
 def walk(x,depth=0):
  require(depth<32,'nesting limit')
  if isinstance(x,dict):
   require(len(x)<=256,'object count')
   for y in x.values():walk(y,depth+1)
  elif isinstance(x,list):
   require(len(x)<=256,'array count')
   for y in x:walk(y,depth+1)
  elif isinstance(x,(int,float)) and not isinstance(x,bool):require(abs(x)<=1e12 and math.isfinite(x),'finite numeric envelope')
 walk(d);return d
def number(x,lo,hi):
 require(type(x) in (int,float) and lo<=x<=hi and math.isfinite(x),'numeric domain');return float(x)
def vec(x,lo,hi):
 require(isinstance(x,list) and len(x)==3,'vec3');return [number(v,lo,hi) for v in x]
def keys(x,expected):require(isinstance(x,dict) and set(x)==set(expected),'unsupported or missing fields')
def quant(x,scale,lo,hi):
 number(x,lo/scale,hi/scale);v=x*scale;require(math.isfinite(v),'quantization finite');q=round(v);require(lo<=q<=hi,'encoded domain');return q

def validate_scene(s):
 keys(s,('schema','mode','lights','world_rgb','world_strength','visibility'))
 require(s['schema']=='ayatsuri-offline-static-light-input-v1' and s['mode']=='extracted-static-fixture','unsupported format/dynamics')
 require(s['visibility']=='caller-supplied-per-hit','no inferred visibility')
 require(isinstance(s['lights'],list) and len(s['lights'])==3,'three lights required')
 for l in s['lights']:
  keys(l,('shape','rotation_mode','identity_scale','no_parent','position','euler_xyz','color','power','diameter'))
  require(l['shape']=='DISK' and l['rotation_mode']=='XYZ' and isinstance(l['identity_scale'],list) and len(l['identity_scale'])==3 and all(type(x) in (int,float) and x==1 for x in l['identity_scale']) and l['no_parent'] is True,'unsupported shape/transform')
  vec(l['position'],-8,8);vec(l['euler_xyz'],-math.pi*16,math.pi*16);vec(l['color'],0,1)
  number(l['power'],1e-9,256*math.pi*math.pi);number(l['diameter'],1e-9,16)
 vec(s['world_rgb'],0,16);number(s['world_strength'],0,16)

def prepare(s):
 validate_scene(s)
 flat=[]
 for l in s['lights']:flat+=l['position']+l['euler_xyz']+l['color']+[l['power'],l['diameter']]
 flat+=s['world_rgb']+[s['world_strength']]
 lib=C.CDLL(str(HERE/'reference_init.so'));lib.prepare_reference.argtypes=[C.POINTER(C.c_double)]*3
 f=(C.c_double*51)();samples=(C.c_double*144)();require(lib.prepare_reference((C.c_double*37)(*flat),f,samples)==0,'reference prepare rejected')
 doubles=[];ints=[]
 for i in range(3):
  row=list(f[16*i:16*i+16]);sp=[list(samples[(i*16+j)*3:(i*16+j+1)*3]) for j in range(16)]
  d={'center':row[:3],'normal':row[3:6],'axis_u':row[6:9],'axis_v':row[9:12],'power_rgb_over_pi_squared':row[12:15],'radius':row[15],'samples16':sp};doubles.append(d)
  n=[quant(v,32767,-32767,32767) for v in d['normal']];require(32762**2<=sum(v*v for v in n)<=32772**2,'normal length')
  ints.append({'center_q16':[quant(v,65536,-524288,524288) for v in d['center']],'normal_s32767':n,'power_q16':[quant(v,65536,0,256<<16) for v in d['power_rgb_over_pi_squared']],'samples16_q16':[[quant(v,65536,-524288,524288) for v in p] for p in sp]})
 world=list(f[48:51]);wi=[quant(v,1<<24,0,16<<24) for v in world]
 return {'high_precision':{'lights':doubles,'world_radiance':world},'integer_scene':{'lights':ints,'world_q24':wi},'reference_fields51':list(f)}

def f32(x):return struct.unpack('<f',struct.pack('<f',x))[0]
def camera(c):
 keys(c,('name','blenderLocation','blenderTarget','verticalOrtho','nativeCamera','pixelConvention'))
 loc=vec(c['blenderLocation'],-128,128);target=vec(c['blenderTarget'],-128,128);ortho=number(c['verticalOrtho'],.1,256)
 native=[]
 for p in (loc,target):native += [p[0]*38,-p[2]*38,-p[1]*38]
 native += [135/ortho/38,119.5,67]
 require(native==c['nativeCamera'],'authored camera mapping')
 v=list(map(f32,native));f=[v[k]-v[k+3] for k in range(3)];length=math.hypot(math.hypot(f[0],f[1]),f[2]);require(length>0,'coincident camera');f=[x/length for x in f];rx,rz=f[2],-f[0];length=math.hypot(rx,rz)
 if length<1e-6:rx,rz,length=1,0,1
 rx/=length;rz/=length
 basis=[[f32(rx),0.,f32(rz)],[f32(f[1]*rz),f32(f[2]*rx-f[0]*rz),f32(-f[1]*rx)],list(map(f32,f))]
 rows=[[a*(v[6]*38 if j<2 else 1) for a in b] for j,b in enumerate(basis)]
 offsets=[(v[7+j] if j<2 else 0)-sum(b[k]*v[k+3] for k in range(3))*(v[6] if j<2 else 1/38) for j,b in enumerate(basis)]
 return {'authored':c,'stored_native_f32':v,'basis_f32':basis,'prepared_rows_double':rows,'prepared_offsets_double':offsets,'integer':{'m_q20':[quant(x,1<<20,-(1<<28),1<<28) for row in rows for x in row],'offset_q10':[quant(x,1024,-(4096<<10),4096<<10) for x in offsets],'position_frac':20,'screen_frac':10,'width':240,'height':135},'sample_convention':'Native reference samples integer i; center119.5/67 already subtracts Blender halfpixel. Do not subtract again.'}

def write_new(path,data):
 path=pathlib.Path(path);require(path.parent.resolve().is_relative_to(HERE),'output must stay inside prepare directory')
 payload=(json.dumps(data,indent=2,allow_nan=False)+'\n').encode();fd,tmp=tempfile.mkstemp(prefix='.prepare-',dir=path.parent)
 try:
  with os.fdopen(fd,'wb') as f:f.write(payload);f.flush();os.fsync(f.fileno())
  os.link(tmp,path) # Atomic publication, EEXIST protects files and symlinks.
  d=os.open(path.parent,os.O_RDONLY);os.fsync(d);os.close(d)
 finally:os.unlink(tmp)

def audit():
 src={};provenance={}
 ref=ROOT/'fox-v3-indexed-bvh-bounds/private-build/physical/fox_disk_lighting.c'
 require(sha(ref)=='c8bd5a8fbb006050628c4a5349fffef91155a36ee436a0ede541569b008573ac','reference source identity')
 prefix=ref.read_text().split('/* Reject proximity')[0].replace('#include \"fox_disk_lighting.h\"','#include \"../../fox-v3-indexed-bvh-bounds/private-build/physical/fox_disk_lighting.h\"')
 require((HERE/'reference_init.c').read_text().startswith(prefix),'unchanged initializer prefix')
 for name,pin in PINS.items():
  p=INPUT/name;require(sha(p)==pin,'source identity');src[name]=loads(p.read_text());provenance[str(p.relative_to(ROOT))]=pin
 physical=src['physical-source.json'];base=next(c for c in physical['cases'] if c['name']=='baseline')
 scene={'schema':'ayatsuri-offline-static-light-input-v1','mode':'extracted-static-fixture','visibility':'caller-supplied-per-hit','lights':[],'world_rgb':base['worldRGB'],'world_strength':base['worldStrength']}
 for l in base['lights']:
  require(l['normalize'] is None and abs(l['spread']-math.pi)<1e-6,'unsupported light spread/normalize')
  scene['lights'].append({'shape':l['shape'],'rotation_mode':l['rotationMode'],'identity_scale':l['identityScale'],'no_parent':l['noParent'],'position':l['position'],'euler_xyz':l['eulerXYZ'],'color':l['color'],'power':l['power'],'diameter':l['diameter']})
 textpath=INPUT.parent/'on/physical-baseline.txt';tokens=textpath.read_text().split();require(tokens[0]=='FOXDISK1' and len(tokens)==38,'disk text format')
 expected=[x for l in scene['lights'] for x in l['position']+l['euler_xyz']+l['color']+[l['power'],l['diameter']]]+scene['world_rgb']+[scene['world_strength']]
 require(list(map(float,tokens[1:]))==expected,'authored light text mismatch');provenance[str(textpath.relative_to(ROOT))]=sha(textpath)
 result=prepare(scene)
 stats={'center_q16_abs_error':0.,'sample_q16_abs_error':0.,'normal_s32767_abs_error':0.,'power_q16_abs_error':0.,'world_q24_abs_error':max(abs(a-b/(1<<24)) for a,b in zip(result['high_precision']['world_radiance'],result['integer_scene']['world_q24'])),'authored_float_axes_vs_prepared_double_max':0.}
 for authored,d,i in zip(base['lights'],result['high_precision']['lights'],result['integer_scene']['lights']):
  for label,dk,ik,scale in [('center_q16_abs_error','center','center_q16',65536),('normal_s32767_abs_error','normal','normal_s32767',32767),('power_q16_abs_error','power_rgb_over_pi_squared','power_q16',65536)]:stats[label]=max(stats[label],max(abs(a-b/scale) for a,b in zip(d[dk],i[ik])))
  stats['sample_q16_abs_error']=max(stats['sample_q16_abs_error'],max(abs(a-b/65536) for p,q in zip(d['samples16'],i['samples16_q16']) for a,b in zip(p,q)))
  stats['authored_float_axes_vs_prepared_double_max']=max(stats['authored_float_axes_vs_prepared_double_max'],max(abs(a-b) for ak,dk in [('normal','normal'),('tangentU','axis_u'),('tangentV','axis_v')] for a,b in zip(authored[ak],d[dk])))
 result['quantization_error']=stats
 snap=ROOT/'fox-v3-indexed-bvh-bounds/actual-on-001/native-front-baseline.snapshot';require(sha(snap)=='006cfd92bda231a4ae7922f23aa125176f807967feaf444e2f3f8b19ef72cab0','snapshot identity');blob=snap.read_bytes();require(blob[:8]==b'KSPX\1\0\0\0' and len(blob)>=416,'saved snapshot header')
 old=list(struct.unpack_from('<51d',blob,8));bits=struct.pack('<51d',*result['reference_fields51']);require(bits==blob[8:416],'prepared double scene mismatch')
 provenance[str(snap.relative_to(ROOT))]=sha(snap)
 # Compare 16 samples against each explicit snapshot field; no struct cast/import.
 constants=re.search(r'disk16\[16\]\[2\] = \{(.*?)\n\};',(HERE/'reference_init.c').read_text(),re.S).group(1);uv=[list(map(float,p)) for p in re.findall(r'\{\s*([\-0-9.]+),\s*([\-0-9.]+)\}',constants)];require(len(uv)==16,'quadrature count')
 for i,d in enumerate(result['high_precision']['lights']):
  o=old[i*16:i*16+16];samples=[[o[k]+o[15]*(u*o[6+k]+v*o[9+k]) for k in range(3)] for u,v in uv]
  require(struct.pack('<48d',*(x for p in samples for x in p))==struct.pack('<48d',*(x for p in d['samples16'] for x in p)),'sample double mismatch')
 cams=[]
 for c in src['candidate-config.json']['cameras']:
  cp=ROOT/f"fox-v3-indexed-bvh-bounds/actual-on-001/native-{c['name']}-baseline.command.json";cmd=loads(cp.read_text());require(list(map(float,cmd['command'][4:13]))==c['nativeCamera'],'camera command mismatch');cams.append(camera(c));provenance[str(cp.relative_to(ROOT))]=sha(cp)
 ground=src['ground-source.json'];require(ground['matrixWorld']==[[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]],'ground transform unsupported')
 gt=INPUT/'ground-baseline.txt';tokens=gt.read_text().split();require(tokens[0]=='FOXGROUND1' and len(tokens)==22,'ground text')
 expected=[x for v in ground['worldVertices'] for x in v]+[x for t in ground['triangles'] for x in t]+ground['linearLe'];require(list(map(float,tokens[1:]))==expected,'ground text mismatch');provenance[str(gt.relative_to(ROOT))]=sha(gt)
 gp={'high_precision_world_vertices':ground['worldVertices'],'triangles':ground['triangles'],'normal':ground['worldGeometricNormals'],'linear_emission':ground['linearLe'],'emission_q24':[quant(v,1<<24,0,16<<24) for v in ground['linearLe']],'lighting_geometry_admitted':False,'reason':'Floor vertices reach +/-100m; lighting position domain is +/-8m. Retained only; no clipping, fallback, floor lighting or visibility implementation.'}
 materials=[]
 for name,m in src['source-materials.json']['materials'].items():
  require(m['doubleSided'] is True and len(m['baseColor'])==4 and m['baseColor'][3]==1,'material unsupported')
  materials.append({'name':name,'linear_rgb':m['baseColor'][:3],'rho_s32767':[quant(x,32767,0,32767) for x in m['baseColor'][:3]],'double_sided':True})
 fixedpath=ROOT/'ayatsuri-fixed-pipeline-20261105/source-adapter/private-fixed-source.json';fixed=json.loads(fixedpath.read_text());require(sha(fixedpath)=='81a174a5237d17863d60baff9463c411309f57e3e2cee236254cf6a74c22063b','fixed source identity')
 by_rgb={tuple(m['scaledLinear']):m['id'] for m in fixed['materialTrace']}
 matched=[]
 for m in materials:
  m['fixed_material_id']=by_rgb.get(tuple(m['linear_rgb']))
  if m['fixed_material_id'] is None:require(m['name']=='Warm studio backdrop' and m['linear_rgb']==ground['sourceEmissionColor'][:3],'unmatched material');m['scope']='retained ground only, no material evaluator'
  else:matched.append(m['fixed_material_id']);m['scope']='fixed source mesh diffuse reflectance'
 require(len(matched)==8 and len(set(matched))==8 and len(materials)==9,'source material correspondence');provenance[str(fixedpath.relative_to(ROOT))]=sha(fixedpath)
 for rel in ['fox-v3-indexed-bvh-bounds/private-build/physical/fox_disk_lighting.c','fox-v3-indexed-bvh-bounds/private-build/physical/fox_disk_lighting.h','ayatsuri-fixed-integer-light-20261105/integer_light.h','ayatsuri-fixed-integer-light-20261105/normal_bridge.h','ayatsuri-fixed-integer-geometry-20261105/geometry.h','ayatsuri-fixed-integer-output-20261105/code/private_adapter_api.h']:provenance[rel]=sha(ROOT/rel)
 return {'schema':'ayatsuri-offline-static-scene-prepared-v1','scope':'Pinned extracted baseline arithmetic fixture; NOT an arbitrary Blender animation validator, frame renderer or fallback implementation.','rounding':'IEEE binary64 preparation FE_TONEAREST, no FMA/fast-math; integer encode nearest ties even; range checked before encode, no saturation.','visibility':'UNSET: caller-supplied masks per hit. All-visible allowed only as explicitly labeled synthetic test assumption.','source_input':scene,'lights':result,'cameras':cams,'ground':gp,'materials':materials,'provenance_sha256':provenance,'preparer_sha256':{'prepare.py':sha(HERE/'prepare.py'),'reference_init.c':sha(HERE/'reference_init.c')},'fidelity':{'prepared_scene_double_fields':51,'prepared_scene_bit_mismatches':0,'disk16_sample_double_components':144,'disk16_sample_bit_mismatches':0,'physical_text_source_match':True,'camera_command_match':True,'ground_text_match':True,'material_source_match':True,'animation_validation':'unavailable in authored extraction; arbitrary/dynamic scene import unsupported'}}
if __name__=='__main__':
 import sys
 require(len(sys.argv)==2,'usage: prepare.py NEW_OUTPUT.json')
 data=audit();write_new(HERE/sys.argv[1],data);print(json.dumps(data['fidelity'],indent=2))
