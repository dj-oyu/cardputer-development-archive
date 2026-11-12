"""Only reconstruct and legacy-control; never enable alternate profile here."""
from common import *
import time,resource
assert len(sys.argv)==4;O=Path(sys.argv[1]).resolve();proof=Path(sys.argv[2]).resolve();assert sha(proof)==sys.argv[3];assert O.parent==R and not O.exists();O.mkdir();a=admission();lib,fun=check_profile();old=json.load(open(RAW/'COMPLETED.json'));assert old['rgbDepthAllExactBaseline'] and old['allTenSnapshotsExact'] and old['finiteNonnegativeHDR'];sourcepins={str(proof):sha(proof),str(RAW/'COMPLETED.json'):sha(RAW/'COMPLETED.json'),str(Path(__file__)):sha(Path(__file__)),str(R/'code/common.py'):sha(R/'code/common.py')};frames=[]
for view in ['front','oblique']:
 for case in ['baseline','direction','intensity','ambient','albedo']:
  key=view+'-'+case;p=D/'on/private-partial'/('native-'+key);capture=next(f for f in old['frames'] if f['view']==view and f['case']==case)
  for n,h in capture['files'].items():assert sha(RAW/n)==h;sourcepins[str(RAW/n)]=h
  for ext in ['.snapshot','.f32le']:assert Path(str(p)+ext).read_bytes()==(RAW/('native-'+key+ext)).read_bytes()
  center=np.fromfile(RAW/('native-'+key+'-combined.f64le'),'<f8').reshape(135,240,3);assert np.isfinite(center).all() and (center>=0).all();target=np.fromfile(str(p)+'.targets.u8',np.uint8).reshape(135,240).astype(bool);depth=np.fromfile(str(p)+'.f32le','<f4').reshape(135,240);chars={};seen=np.zeros((135,240),np.uint8);linear=np.zeros_like(center);events=kept=replaced=0
  for line in open(str(p)+'.samples.jsonl'):
   s=json.loads(line);k=(s['x'],s['y'],s['sample']);assert k not in chars and target[k[1],k[0]];chars[k]=(s['hit'],s['depth'],s['linearRGB'])
  assert len(chars)==4*int(target.sum());start=time.perf_counter_ns()
  for line in open(str(p)+'.background.jsonl'):
   e=json.loads(line);x,y,j=e['x'],e['y'],e['sample'];assert all(type(v)is int for v in [x,y,j]);assert 0<=x<240 and 0<=y<135 and type(e['action'])is int and e['action'] in [0,1,2];events+=1
   if target[y,x]:
    assert 0<=j<4 and seen[y,x]==j;seen[y,x]+=1;hit,z,rgb=chars[(x,y,j)];assert e['characterHit'] is hit
    if hit:assert np.float32(e['characterDepth'])==np.float32(z)
    else:assert e['characterDepth']==0
    v=rgb if e['action']==0 else e['returnedRGB'];assert e['action']!=0 or hit
    for k in range(3):linear[y,x,k]+=float(v[k])
   else:
    assert j==4294967295 and seen[y,x]==0;seen[y,x]=1;assert e['characterHit'] is bool(np.isfinite(depth[y,x]))
    if e['characterHit']:assert np.float32(e['characterDepth'])==depth[y,x]
    if e['action']==0:assert e['characterHit'];linear[y,x]=center[y,x];kept+=1
    else:linear[y,x]=e['returnedRGB'];replaced+=1
  assert np.array_equal(seen,np.where(target,4,1)) and events==32400+3*int(target.sum());linear[target]*=.25;assert np.isfinite(linear).all() and (linear>=0).all();elapsed=time.perf_counter_ns()-start
  legacy,clamp=encode(fun,linear,0);assert clamp==0;expected=np.fromfile(str(p)+'.u16le','<u2').reshape(135,240);assert np.array_equal(legacy,expected),key
  h=O/('hdr-'+key+'.f64le');linear.astype('<f8').tofile(h);l=O/('legacy-'+key+'.u16le');legacy.astype('<u2').tofile(l)
  frames.append({'view':view,'case':case,'legacyByteExact':True,'all565Exact':True,'pixels':32400,'sourceSceneSHA256':sha(Path(str(p)+'.u16le')),'events':events,'targetPixels':int(target.sum()),'centerHDRReusedPixels':kept,'nonTargetReplacedPixels':replaced,'reconstructionNsIncludingJSONJoin':elapsed,'hdr':h.name,'hdrSHA256':sha(h),'legacy':l.name,'legacySHA256':sha(l),'characterDepthSHA256':sha(Path(str(p)+'.f32le')),'targetSHA256':sha(Path(str(p)+'.targets.u8')),'minimumHDR':float(linear.min()),'maximumHDR':float(linear.max())})
  print(key,'LEGACY_EXACT',flush=True)
a.recheck();check_profile();assert all(sha(n)==h for n,h in sourcepins.items());save(O/'INPUT_PINS.json',sourcepins);save(O/'LEGACY_CONTROL.json',{'status':'ALL10_LEGACY_BYTE_EXACT','frames':frames,'sameCurrentHDRViaSourceInputProvenanceNotNewCapture':True,'quarterOrder':[0,1,2,3],'centerProof':str(proof),'centerProofSHA256':sha(proof),'inputPinsSHA256':sha(O/'INPUT_PINS.json'),'profileInputFreezeSHA256':sha(R/'PROFILE_INPUT_FREEZE.json'),'rawHDRArrayBytes':777600,'outputArrayBytes':64800,'diagnosticProcessPeakRSSKiB':resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,'alternateProfileExecuted':False});print('ALL10_LEGACY_CONTROL_PASS')
