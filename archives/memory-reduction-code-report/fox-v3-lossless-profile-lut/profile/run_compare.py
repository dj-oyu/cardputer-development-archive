from pathlib import Path
import ctypes as C,hashlib,json,subprocess,time,statistics,sys,numpy as np
R=Path(__file__).resolve().parent;W=R.parents[1];S=W/'fox-v3-profile-integration-feasibility/build-private';D=R.parent/'research/block_decoder.c'
mode=sys.argv[1] if len(sys.argv)>1 else 'O2';B=R/f'build-{mode}';B.mkdir(exist_ok=True)
flags=['-std=c11','-O2' if mode!='O0' else '-O0','-fno-fast-math','-ffp-contract=off','-fstack-usage','-I'+str(R),'-I'+str(R/'private')]
def run(args):subprocess.run(args,check=True,cwd=B)
run(['cc',*flags,'-fPIC','-c',str(S/'agx_profile.c'),'-o','old.o'])
run(['cc',*flags,'-fPIC','-c',str(R/'candidate_profile.c'),'-o','new.o'])
run(['cc',*flags,'-fPIC','-c',str(D),'-o','decoder.o'])
run(['cc',*flags,'-fPIC','-c',str(R/'batch_bridge.c'),'-o','batch.o'])
for name,obj in [('old',['old.o']),('new',['new.o','decoder.o'])]:run(['cc','-shared',*obj,'batch.o','-lm','-o',name+'.so'])
(B/'size.txt').write_text(subprocess.check_output(['size','-A','old.o','new.o','decoder.o'],cwd=B,text=True))
p=C.POINTER(C.c_float);u=C.POINTER(C.c_uint16);ip=C.POINTER(C.c_int)
libs={name:C.CDLL(str(B/(name+'.so'))) for name in ('old','new')}
for l in libs.values():
 l.profile_batch.argtypes=[p,C.c_size_t,p,ip,u];l.profile_bench.argtypes=[p,C.c_size_t,C.c_uint];l.profile_bench.restype=C.c_uint64;l.agx_profile_eval.argtypes=[p,p];l.agx_profile_eval.restype=C.c_int
meta=json.loads((R/'INPUTS.json').read_text());results={'mode':mode,'flags':flags,'groups':{},'frames':[],'inputs':meta['pins'],'codePins':{str(x):hashlib.sha256(x.read_bytes()).hexdigest() for x in [R/'candidate_profile.c',D,R/'batch_bridge.c']}}
def evaluate(l,a):
 a=np.ascontiguousarray(a,dtype=np.float32);o=np.empty(a.shape,np.float32);s=np.empty(len(a),np.int32);q=np.empty(len(a),np.uint16)
 l.profile_batch(a.ctypes.data_as(p),len(a),o.ctypes.data_as(p),s.ctypes.data_as(ip),q.ctypes.data_as(u));return o,s,q
def compare(a,expected=None):
 old=evaluate(libs['old'],a);new=evaluate(libs['new'],a)
 assert all(x.tobytes()==y.tobytes() for x,y in zip(old,new)),'profile mismatch'
 if expected is not None:assert old[2].tobytes()==expected and new[2].tobytes()==expected,'565 mismatch'
 return {'samples':len(a),'floatBitsExact':True,'statusesExact':True,'nearest565Exact':True,'clamped':int(np.count_nonzero(old[1]==1)),'invalid':int(np.count_nonzero(old[1]==2))}
for name,a in np.load(R/'private/synthetic.npz').items():
 results['groups'][name]=compare(a);print(mode,name,len(a),'PASS',flush=True)
for row in meta['frames']:
 a=np.fromfile(row['hdr'],'<f8').reshape(-1,3).astype(np.float32)
 results['frames'].append({'name':row['name'],**compare(a,Path(row['expected565']).read_bytes())});print(mode,row['name'],'PASS',flush=True)
# Null, invalid write atomicity, full/partial input-output aliases and interleaving.
for name,l in libs.items():
 sentinel=np.array([.123,.456,.789],np.float32);before=sentinel.tobytes()
 assert l.agx_profile_eval(None,sentinel.ctypes.data_as(p))==2 and sentinel.tobytes()==before
 assert l.agx_profile_eval(sentinel.ctypes.data_as(p),None)==2
 for c in range(3):
  for bad in [-1.,-1e-30,np.nan,np.inf,-np.inf]:
   a=np.zeros(3,np.float32);a[c]=bad;o=sentinel.copy();assert l.agx_profile_eval(a.ctypes.data_as(p),o.ctypes.data_as(p))==2 and o.tobytes()==before
 for k in range(100):
  a=np.array([k*.01,k*.02,k*.03],np.float32);expected=evaluate(l,a[None,:]);
  for offset in (0,1,2):
   buf=np.zeros(5,np.float32);buf[:3]=a;status=l.agx_profile_eval(buf.ctypes.data_as(p),C.cast(buf.ctypes.data+offset*4,p));assert status==expected[1][0] and buf[offset:offset+3].tobytes()==expected[0].tobytes()
results['nullInvalidAndAlias']='PASS';results['status']='PASS'
# Same deterministic resident sample order, no competing benchmark worker, AB/BA alternating.
if mode=='O2':
 a=np.ascontiguousarray(np.load(R/'private/synthetic.npz')['seeded_log_hdr'][:8192]);n=len(a);repeats=8;records=[]
 for name,l in libs.items():l.profile_bench(a.ctypes.data_as(p),n,1)
 for turn in range(7):
  row={}
  for name in (('old','new') if turn%2==0 else ('new','old')):
   start=time.perf_counter_ns();checksum=libs[name].profile_bench(a.ctypes.data_as(p),n,repeats);elapsed=time.perf_counter_ns()-start;row[name]={'ns':elapsed,'nsPerProfile':elapsed/(n*repeats),'checksum':checksum}
  assert row['old']['checksum']==row['new']['checksum'];records.append(row);print('bench',turn,row,flush=True)
 old=statistics.median(r['old']['nsPerProfile'] for r in records);new=statistics.median(r['new']['nsPerProfile'] for r in records)
 results['benchmark']={'inputs':n,'repetitions':repeats,'warmups':1,'trials':records,'medianOldNs':old,'medianNewNs':new,'ratio':new/old,'scope':'Standalone host sequential profile-only; includes identical checksum loop, excludes physical rendering, target cache/flash/ABI effects.'}
for path,digest in meta['pins'].items():assert hashlib.sha256((W/path).read_bytes()).hexdigest()==digest
for path,digest in results['codePins'].items():assert hashlib.sha256(Path(path).read_bytes()).hexdigest()==digest
(R/f'RESULTS-{mode}.json').write_text(json.dumps(results,indent=2)+'\n');print('COMPLETE',mode,flush=True)
