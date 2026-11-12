"""Complete actual diagnostic sample accounting, linear order/black denominator/output control."""
from pathlib import Path
import sys,json,hashlib,ctypes,subprocess,numpy as np
D=Path(sys.argv[1]).resolve();arm=sys.argv[2];assert arm in ['off','zero','on'];O=D/arm;done=json.loads((O/'COMPLETED.json').read_text());assert len(done['frames'])==20
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();root=Path(__file__).resolve().parents[1];W=next(p for p in Path(__file__).resolve().parents if (p/'fox-v3-lid-evaluation/actual-lid8-v2').is_dir());expected={}
for view in ['front','oblique']:
 w=json.load(open(W/'fox-v3-lid-transport-point-audit/verified-winners-v2'/f'{view}-baseline.json'));ids=np.full((135,240),65535,np.uint16)
 for p in w['points']:ids[p['y'],p['x']]=int(p['sourceObjectId'])
 target=np.zeros((135,240),bool);pad=np.pad(ids,1,constant_values=65535)
 for dy,dx in [(-1,0),(0,-1),(0,1),(1,0)]:target|=ids!=pad[1+dy:136+dy,1+dx:241+dx]
 expected[view]=target
so=D/'encode-control.so';subprocess.run(['cc','-std=c11','-O2','-shared','-fPIC','-ffp-contract=off','-fexcess-precision=standard','-I',str(D/'product/main'),str(D/'code/encode_control.c'),'-lm','-o',str(so)],check=True);lib=ctypes.CDLL(str(so));f=lib.encode_control;f.argtypes=[ctypes.POINTER(ctypes.c_double),ctypes.POINTER(ctypes.c_uint16),ctypes.c_uint];results=[]
for row in done['frames']:
 p=O/row['prefix'];base=W/'fox-v3-boundary-rho-affine-evaluation/actual-A2/on'/row['prefix'];target=np.fromfile(str(p)+'.targets.u8',np.uint8).reshape(135,240);assert np.array_equal(target,expected[row['view']]);assert np.isin(target,[0,1]).all();target=target.astype(bool)
 seen=np.zeros((135,240),np.uint8);acc=np.zeros((135,240,3),np.float64);support=np.zeros((135,240),np.uint8);count=hits=0;fieldMax=0.
 with open(str(p)+'.samples.jsonl') as stream:
  for line in stream:
   s=json.loads(line);x,y,j=s['x'],s['y'],s['sample'];assert type(x)is int and type(y)is int and type(j)is int and 0<=x<240 and 0<=y<135 and 0<=j<4 and target[y,x];assert seen[y,x]==j;seen[y,x]+=1;count+=1
   vals=np.array([s[k] for k in ['P','Ns','rho','linearRGB']],np.float64);assert vals.shape==(4,3) and np.isfinite(vals).all();assert type(s['hit'])is bool
   if s['hit']:
    hits+=1;support[y,x]|=1<<j;assert type(s['node'])is int and 1<=s['node']<=54 and type(s['face'])is int and 0<=s['face']<64;assert 0<=s['sourceId']<92;assert type(s['back'])is bool and s['depth'] is not None and np.isfinite(s['depth']);assert np.linalg.norm(vals[1])>0 and (vals[2]>=0).all() and (vals[2]<=1).all() and (vals[3]>=0).all()
    components=[np.asarray(s[k],np.float64) for k in ['directRGB','worldRGB','bounceRGB','groundLeRGB','floorReflectedRGB']];assert all(v.shape==(3,) and np.isfinite(v).all() and (v>=0).all() for v in components);combined=components[0]+components[1]+components[2];combined+=components[3];
    if arm=='on':combined+=components[4]
    else:assert (components[4]==0).all()
    assert np.array_equal(combined,vals[3])
   else:assert s['depth'] is None and (vals==0).all() and s['sourceId']==65535
   for k in range(3):acc[y,x,k]+=float(vals[3,k])
 assert np.array_equal(seen,4*target.astype(np.uint8));assert count==4*int(target.sum());avg=acc*.25;encoded=np.empty((135,240),np.uint16);f(avg.ctypes.data_as(ctypes.POINTER(ctypes.c_double)),encoded.ctypes.data_as(ctypes.POINTER(ctypes.c_uint16)),32400)
 actual=np.fromfile(str(p)+'.u16le','<u2').reshape(135,240);old=np.fromfile(str(base)+'.u16le','<u2').reshape(135,240);assert np.array_equal(actual[target],encoded[target]);assert arm=='on' or np.array_equal(actual[~target],old[~target]);assert (actual[target&(support==0)]==0).all();depth=np.fromfile(str(base)+'.f32le','<f4').reshape(135,240);fullsupport=np.isfinite(depth);fullsupport[target]=support[target]!=0;assert (actual[~fullsupport]==0).all()
 aa=json.load(open(str(p)+'.aa.json'));assert aa['observerHits']==hits and aa['observerSamples']==count
 result={'view':row['view'],'case':row['case'],'reverse':row['reverse'],'targets':int(target.sum()),'samples':count,'hits':hits,'linearFourMeanEncodeExact':True,'nonTargetsOldA2ByteExact':bool(np.array_equal(actual[~target],old[~target])),'nonTargetLightingMayChange':arm=='on','blackNohitFixedDenominator':True,'centerDepthUnchanged':True,'supportPixels':int(fullsupport.sum()),'supportNewVsCenter':int((fullsupport&~np.isfinite(depth)).sum()),'supportLostVsCenter':int((~fullsupport&np.isfinite(depth)).sum()),'targetSHA256':sha(Path(str(p)+'.targets.u8')),'samplesSHA256':sha(Path(str(p)+'.samples.jsonl'))};results.append(result)
 np.savez_compressed(str(p)+'.support.npz',center=np.isfinite(depth),target=target,sampleBits=support,aaSupport=fullsupport)
(O/'SAMPLE_AUDIT.json').write_text(json.dumps({'status':'ALL20_SAMPLE_LINEAR_OUTPUT_CONTROLS_PASS','frames':results,'encoderSourceSHA256':sha(D/'code/encode_control.c'),'encoderBinarySHA256':sha(so),'fullHDRScratchDiagnosticOnly':777600,'formalDepthRemainsCenterNotNewCoverage':True},indent=2)+'\n');print('SAMPLE_AUDIT_ALL20_PASS')
