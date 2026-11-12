"""Run only after independent correctness gates and parent quiet-window approval."""
from pathlib import Path
import argparse,ctypes as C,numpy as np,json,time,statistics,hashlib,subprocess,os
R=Path(__file__).resolve().parent;W=R.parents[1];BASE=W/'fox-v3-lossless-profile-lut/profile'
def digest(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
ap=argparse.ArgumentParser();ap.add_argument('--libraries',default=str(R/'LIBRARIES.json'));ap.add_argument('--quiet-window-approved',action='store_true');args=ap.parse_args()
if not args.quiet_window_approved:raise SystemExit('Explicit coordinated quiet window required')
paths=json.loads(Path(args.libraries).read_text());names=list(paths);assert names==['raw','baseline','gather','cache4']
p=C.POINTER(C.c_float);libs={k:C.CDLL(str(Path(v).resolve())) for k,v in paths.items()}
for l in libs.values():
 l.profile_bench.argtypes=[p,C.c_size_t];l.profile_bench.restype=C.c_uint64
 l.profile_setup.argtypes=[];l.profile_setup.restype=C.c_int
 l.profile_counters.argtypes=[C.POINTER(C.c_uint64)]
 l.profile_context_size.argtypes=[];l.profile_context_size.restype=C.c_size_t
meta=json.loads((BASE/'INPUTS.json').read_text());assert len(meta['pins'])==87
build=json.loads((R/'BUILD.json').read_text())
def verify():
 for f,h in meta['pins'].items():assert digest(W/f)==h,f
 for f,h in build['sourcePins'].items():assert digest(W/f)==h,f
verify();frames=[]
for f in meta['frames']:
 a=np.ascontiguousarray(np.fromfile(f['hdr'],'<f8').reshape(-1,3).astype(np.float32));assert a.shape==(32400,3)
 assert np.isfinite(a).all() and (a>=0).all();frames.append((f['name'],a))
assert len(frames)==40
orders={'manifest_order':list(range(40)),'alternate_off_on':[j for i in range(20) for j in (i,i+20)]}
def snapshot():return {'load':os.getloadavg(),'processes':subprocess.check_output(['ps','-eo','pid,pcpu,comm','--sort=-pcpu'],text=True)[:6000]}
report={'method':(R/'PLAN.md').read_text(),'planSHA256':digest(R/'PLAN.md'),'buildSHA256':digest(R/'BUILD.json'),'harnessPins':{f:digest(R/f) for f in ['benchmark_ordered.py','batch_bridge.c','build.py']},'binaryPins':{k:digest(v) for k,v in paths.items()},'host':subprocess.check_output(['uname','-a'],text=True).strip(),'cpuinfo':Path('/proc/cpuinfo').read_text()[:1500],'startSnapshot':snapshot(),'scenarios':{},'inputManifestSHA256':digest(BASE/'INPUTS.json'),'contextSize':{k:l.profile_context_size() for k,l in libs.items()},'counterNames':['hits','misses','invalidations'],'counterNotes':'Counters enabled during timing. Cold bind resets counters; warm deltas subtract previous frame. No eviction or byte/symbol counter exposed. Successful misses correspond to full decoded blocks on valid fixed data. Primary batchWallNs includes setup, loops, Python dispatch and counter snapshots; setupPlusPixelNs removes dispatch/snapshot gaps. Stateless setup is zero.'}
def setup(name):
 if name!='cache4':return 0
 start=time.perf_counter_ns();ok=libs[name].profile_setup();elapsed=time.perf_counter_ns()-start
 assert ok==1;return elapsed
def trial(name,selected,cold):
 l=libs[name];records=[];previous=[0,0,0];sums=[0,0,0];wall=time.perf_counter_ns()
 bind_ns=0 if cold else setup(name)
 for frame,a in selected:
  reset_ns=setup(name) if cold else 0
  if cold:previous=[0,0,0]
  start=time.perf_counter_ns();check=l.profile_bench(a.ctypes.data_as(p),len(a));elapsed=time.perf_counter_ns()-start
  assert check!=2**64-1,(name,frame,'invalid profile')
  counts=(C.c_uint64*3)();l.profile_counters(counts);delta=[counts[i]-previous[i] for i in range(3)];previous=list(counts)
  sums=[sums[i]+delta[i] for i in range(3)]
  records.append({'name':frame,'pixels':len(a),'pixelNs':elapsed,'resetBindNs':reset_ns,'checksum':check,'counterDelta':delta})
 batch=time.perf_counter_ns()-wall;pixels=sum(x['pixelNs'] for x in records);setup_ns=bind_ns+sum(x['resetBindNs'] for x in records)
 return {'frames':records,'bindNs':bind_ns,'setupNs':setup_ns,'pixelNs':pixels,'batchWallNs':batch,'setupPlusPixelNs':pixels+setup_ns,'dispatchAndSnapshotGapNs':batch-pixels-setup_ns,'counterTotals':sums}
for order,indices in orders.items():
 for mode in ['cold_per_frame','warm_across_frames']:
  scenario=order+'/'+mode;cold=mode=='cold_per_frame';selected=[frames[i] for i in indices]
  warmups={name:trial(name,selected,cold) for name in names}
  for i in range(40):assert len({warmups[name]['frames'][i]['checksum'] for name in names})==1,(scenario,'warmup',i)
  rows=[]
  for turn in range(9):
   arm_order=names[turn%4:]+names[:turn%4]
   if turn%2:arm_order=arm_order[::-1]
   row={'trial':turn,'order':arm_order,'arms':{name:trial(name,selected,cold) for name in arm_order}}
   for i in range(40):assert len({row['arms'][name]['frames'][i]['checksum'] for name in names})==1,(scenario,turn,i)
   rows.append(row);print(scenario,turn,{k:round(v['batchWallNs']/1e6,3) for k,v in row['arms'].items()},flush=True)
  med={metric:{name:statistics.median(row['arms'][name][metric] for row in rows) for name in names} for metric in ['batchWallNs','setupPlusPixelNs','pixelNs','setupNs','bindNs']}
  n=sum(len(a) for _,a in selected)
  report['scenarios'][scenario]={'pixels':n,'frameOrder':[x[0] for x in selected],'inputSHA256':hashlib.sha256(b''.join(a.tobytes() for _,a in selected)).hexdigest(),'warmups':warmups,'trials':rows,'medians':med,'primaryNsPerProfile':{k:v/n for k,v in med['batchWallNs'].items()},'primaryRatios':{reference:{k:v/med['batchWallNs'][reference] for k,v in med['batchWallNs'].items()} for reference in ['raw','baseline','gather']},'medianFramePixelNs':{name:[{'name':selected[i][0],'ns':statistics.median(row['arms'][name]['frames'][i]['pixelNs'] for row in rows)} for i in range(40)] for name in names}}
  (R/'BENCHMARK.json').write_text(json.dumps(report,indent=2)+'\n')
report['endSnapshot']=snapshot();verify()
for k,h in report['binaryPins'].items():assert digest(paths[k])==h
(R/'BENCHMARK.json').write_text(json.dumps(report,indent=2)+'\n');print('COMPLETE',flush=True)
