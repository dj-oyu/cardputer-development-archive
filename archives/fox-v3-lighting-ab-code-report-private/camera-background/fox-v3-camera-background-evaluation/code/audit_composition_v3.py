"""Join by exact (x,y,sample), never reshape sample-major observer rows."""
from pathlib import Path
import sys,json,hashlib,ctypes,subprocess,numpy as np
D=Path(sys.argv[1]).resolve();arm=sys.argv[2];assert arm in ['on','background'];O=D/('background-control' if arm=='background' else arm);done=json.load(open(O/'COMPLETED.json'));assert len(done['frames'])==20
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
so=D/(arm+'-composition-encode.so');subprocess.run(['cc','-std=c11','-O2','-shared','-fPIC','-ffp-contract=off','-fexcess-precision=standard','-I',str(D/'product/main'),str(D/'code/encode_control.c'),'-lm','-o',str(so)],check=True)
f=ctypes.CDLL(str(so)).encode_control;f.argtypes=[ctypes.POINTER(ctypes.c_double),ctypes.POINTER(ctypes.c_uint16),ctypes.c_uint];results=[]
for row in done['frames']:
 p=O/row['prefix'];old=D/'off'/row['prefix'];target=np.fromfile(str(p)+'.targets.u8',np.uint8).reshape(135,240);assert np.isin(target,[0,1]).all();target=target.astype(bool);chars={};events={}
 if arm=='on':
  assert Path(str(p)+'.samples.jsonl').read_bytes()==Path(str(old)+'.samples.jsonl').read_bytes()
  for line in open(str(p)+'.samples.jsonl'):
   s=json.loads(line);key=(s['x'],s['y'],s['sample']);assert key not in chars;chars[key]=s
  assert len(chars)==4*int(target.sum())
 for line in open(str(p)+'.background.jsonl'):
  s=json.loads(line);x,y,j=s['x'],s['y'],s['sample'];assert all(type(v)is int for v in [x,y,j]);assert 0<=x<240 and 0<=y<135
  assert (target[y,x] and 0<=j<4) or (not target[y,x] and j==4294967295)
  key=(x,y,j);assert key not in events;events[key]=s
  assert type(s['characterHit'])is bool and type(s['action'])is int and s['action'] in [0,1,2] and type(s['floorClassification'])is int and s['floorClassification'] in [1,2]
  vals=np.array([s[k] for k in ['direct','world','Le','combined','returnedRGB']],dtype=np.float64);assert vals.shape==(5,3) and np.isfinite(vals).all() and (vals>=0).all()
  if s['action']==0:assert arm=='on' and s['characterHit'] and np.all(vals==0)
  else:
   for k in range(3):assert (s['direct'][k]+s['world'][k])+s['Le'][k]==s['combined'][k]==s['returnedRGB'][k]
 assert len(events)==32400+3*int(target.sum())
 olddepth=np.fromfile(str(old)+'.f32le','<f4').reshape(135,240);override_keys=set()
 oldrgb=np.fromfile(str(old)+'.u16le','<u2').reshape(135,240);actual=np.fromfile(str(p)+'.u16le','<u2').reshape(135,240);linear=np.zeros((135,240,3),np.float64);replace=np.zeros((135,240),bool);counts={'keep':0,'floor':0,'world':0,'characterOverrides':0}
 for y in range(135):
  for x in range(240):
   js=range(4) if target[y,x] else [4294967295]
   for j in js:
    e=events[(x,y,j)];action=e['action']
    if arm=='on':
     ch=chars[(x,y,j)] if target[y,x] else {'hit':bool(np.isfinite(olddepth[y,x])),'depth':float(olddepth[y,x])}
     assert e['characterHit'] is ch['hit']
     if ch['hit']:
      assert np.float32(e['characterDepth'])==np.float32(ch['depth'])
      if e['floorClassification']==1:
       expected_action=1 if np.float32(e['floorDepth'])>np.float32(ch['depth']) else 0
       assert action==expected_action
      else:assert action==0
     else:assert e['characterDepth']==0 and action!=0
     if e['characterHit'] and action!=0:override_keys.add((x,y,j))
    else:assert e['characterHit'] is False and e['characterDepth']==0 and action!=0
    counts[['keep','floor','world'][action]]+=1;counts['characterOverrides']+=bool(e['characterHit'] and action!=0)
    if target[y,x]:
     if action==0:
      c=chars[(x,y,j)];assert c['hit'] and np.float32(e['characterDepth'])==np.float32(c['depth']);v=c['linearRGB']
     else:v=e['returnedRGB']
     for k in range(3):linear[y,x,k]+=v[k]
    elif action!=0:linear[y,x]=e['returnedRGB'];replace[y,x]=True
   if target[y,x]:linear[y,x]*=.25
 enc=np.empty((135,240),np.uint16);f(linear.ctypes.data_as(ctypes.POINTER(ctypes.c_double)),enc.ctypes.data_as(ctypes.POINTER(ctypes.c_uint16)),32400)
 expected=oldrgb.copy();expected[target|replace]=enc[target|replace];assert np.array_equal(actual,expected)
 if arm=='on':assert override_keys==({(119,121,0),(141,121,1)} if row['view']=='front' else set());assert Path(str(p)+'.f32le').read_bytes()==Path(str(old)+'.f32le').read_bytes();assert counts['characterOverrides']==(2 if row['view']=='front' else 0)
 else:assert counts['keep']==0 and not np.isfinite(np.fromfile(str(p)+'.f32le','<f4')).any()
 results.append({k:row[k] for k in ['view','case','reverse']}|{'counts':counts,'completeUniqueDomain':True,'all565Exact':True,'characterDepthRetained':arm=='on','rawCharacterHDRExact':arm=='on','sampleFileSHA256':sha(Path(str(p)+'.samples.jsonl')),'compositionFileSHA256':sha(Path(str(p)+'.background.jsonl')),'targetsSHA256':sha(Path(str(p)+'.targets.u8'))})
(O/'COMPOSITION_AUDIT.json').write_text(json.dumps({'frames':results,'status':'ALL20_EXACT','encoderSHA256':sha(so),'diagnosticOnlyFullLinearScratchBytes':777600,'shapeNotInferredFromSceneRGB':True,'auditSourceSHA256':sha(Path(__file__))},indent=2)+'\n');print('ALL20_COMPOSITION_EXACT')
