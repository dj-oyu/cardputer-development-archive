"""Full ordered retained corpus benchmark. Run only in coordinated quiet interval."""
from pathlib import Path
import argparse,ctypes as C,numpy as np,json,time,statistics,hashlib,subprocess,os
R=Path(__file__).resolve().parent;W=R.parents[1];BASE=W/'fox-v3-lossless-profile-lut/profile'
def digest(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
ap=argparse.ArgumentParser();ap.add_argument('--libraries',required=True,help='JSON map of arm name to shared library');args=ap.parse_args()
paths=json.loads(Path(args.libraries).read_text());names=list(paths);assert names==['raw','baseline','fast_bits','gather','gather_fast_bits']
p=C.POINTER(C.c_float);libs={k:C.CDLL(str(Path(v).resolve())) for k,v in paths.items()}
for l in libs.values():l.profile_bench.argtypes=[p,C.c_size_t,C.c_uint];l.profile_bench.restype=C.c_uint64
meta=json.loads((BASE/'INPUTS.json').read_text());assert len(meta['pins'])==87
for f,h in meta['pins'].items():assert digest(W/f)==h,f
frames=[]
for f in meta['frames']:
 a=np.ascontiguousarray(np.fromfile(f['hdr'],'<f8').reshape(-1,3).astype(np.float32));assert a.shape==(32400,3)
 assert np.isfinite(a).all() and (a>=0).all()
 frames.append((f['name'],a))
assert len(frames)==40
synthetic=np.ascontiguousarray(np.load(BASE/'private/synthetic.npz')['seeded_log_hdr'][:8192])
assert np.isfinite(synthetic).all() and (synthetic>=0).all()
scenarios={'manifest_order':list(range(40)),'alternate_off_on':[j for i in range(20) for j in (i,i+20)]}
def snapshot():return {'load':os.getloadavg(),'processes':subprocess.check_output(['ps','-eo','pid,pcpu,comm','--sort=-pcpu'],text=True)[:6000]}
report={'method':(R/'PLAN.md').read_text(),'planSHA256':digest(R/'PLAN.md'),'binaryPins':{k:digest(v) for k,v in paths.items()},'host':subprocess.check_output(['uname','-a'],text=True).strip(),'cpu':subprocess.run(['lscpu'],text=True,capture_output=True).stdout+' (lscpu may be unavailable under container sysfs; see cpuinfo)' ,'cpuinfo':Path('/proc/cpuinfo').read_text()[:1500],'startSnapshot':snapshot(),'scenarios':{},'inputManifestSHA256':digest(BASE/'INPUTS.json'),'setupNs':0,'setupReason':'All five arms stateless: no initialization or cross-call cache.'}
def bench(l,a):
 start=time.perf_counter_ns();check=l.profile_bench(a.ctypes.data_as(p),len(a),1);return {'ns':time.perf_counter_ns()-start,'checksum':check}
for scenario,indices in [*scenarios.items(),('cold_seeded_log_hdr',[0])]:
 selected=[frames[i] for i in indices] if scenario!='cold_seeded_log_hdr' else [('seeded_log_hdr_first8192',synthetic)]
 for name in names:
  for _,a in selected:bench(libs[name],a)
 rows=[]
 for turn in range(9):
  order=names[turn%len(names):]+names[:turn%len(names)]
  if turn%2:order=order[::-1]
  row={'trial':turn,'order':order,'arms':{}}
  for name in order:
   records=[{'name':n,'pixels':len(a),**bench(libs[name],a)} for n,a in selected]
   row['arms'][name]={'frames':records,'totalNs':sum(x['ns'] for x in records)}
  for i in range(len(selected)):assert len({row['arms'][name]['frames'][i]['checksum'] for name in names})==1,(scenario,turn,i)
  rows.append(row);print(scenario,turn,{k:round(v['totalNs']/1e6,3) for k,v in row['arms'].items()},flush=True)
 med={name:statistics.median(row['arms'][name]['totalNs'] for row in rows) for name in names}
 n=sum(len(a) for _,a in selected)
 report['scenarios'][scenario]={'pixels':n,'frameOrder':[x[0] for x in selected],'inputSHA256':hashlib.sha256(b''.join(a.tobytes() for _,a in selected)).hexdigest(),'trials':rows,'medianTotalNs':med,'medianNsPerProfile':{k:v/n for k,v in med.items()},'overRaw':{k:v/med['raw'] for k,v in med.items()},'overBaseline':{k:v/med['baseline'] for k,v in med.items()},'medianFrameNs':{name:[{'name':selected[i][0],'ns':statistics.median(row['arms'][name]['frames'][i]['ns'] for row in rows)} for i in range(len(selected))] for name in names}}
 (R/'BENCHMARK.json').write_text(json.dumps(report,indent=2)+'\n')
report['endSnapshot']=snapshot()
for f,h in meta['pins'].items():assert digest(W/f)==h
for k,h in report['binaryPins'].items():assert digest(paths[k])==h
(R/'BENCHMARK.json').write_text(json.dumps(report,indent=2)+'\n')
print('COMPLETE',flush=True)
