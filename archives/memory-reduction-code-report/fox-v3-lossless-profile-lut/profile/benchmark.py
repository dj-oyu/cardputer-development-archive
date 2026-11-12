"""Run only when comparison and sanitizer processes have completed."""
from pathlib import Path
import ctypes as C,numpy as np,json,time,statistics,hashlib,subprocess
R=Path(__file__).resolve().parent;B=R/'build-O2';p=C.POINTER(C.c_float)
libs={k:C.CDLL(str(B/(k+'.so'))) for k in ('old','new')}
for l in libs.values():l.profile_bench.argtypes=[p,C.c_size_t,C.c_uint];l.profile_bench.restype=C.c_uint64
meta=json.loads((R/'INPUTS.json').read_text());allactual=np.concatenate([np.fromfile(f['hdr'],'<f8').reshape(-1,3).astype(np.float32) for f in meta['frames']])
rng=np.random.default_rng(20261104);indices=rng.choice(len(allactual),8192,replace=False)
scenarios={'seededLogHDR':np.load(R/'private/synthetic.npz')['seeded_log_hdr'][:8192],'retained40SeededPixels':allactual[indices]};results={}
for scenario,a in scenarios.items():
 a=np.ascontiguousarray(a);n=len(a);repeats=16;rows=[]
 for l in libs.values():l.profile_bench(a.ctypes.data_as(p),n,1)
 for turn in range(9):
  row={'order':['old','new'] if turn%2==0 else ['new','old']}
  for name in row['order']:
   t=time.perf_counter_ns();checksum=libs[name].profile_bench(a.ctypes.data_as(p),n,repeats);elapsed=time.perf_counter_ns()-t
   row[name]={'nsPerProfile':elapsed/(n*repeats),'checksum':checksum}
  assert row['old']['checksum']==row['new']['checksum'];rows.append(row)
 old=statistics.median(x['old']['nsPerProfile'] for x in rows);new=statistics.median(x['new']['nsPerProfile'] for x in rows)
 results[scenario]={'inputs':n,'repetitions':repeats,'trials':rows,'medianOldNs':old,'medianNewNs':new,'newOverOld':new/old,'inputSHA256':hashlib.sha256(a.tobytes()).hexdigest()}
 print(scenario,old,new,new/old,flush=True)
report={'scenarios':results,'method':'Same resident deterministic inputs in identical order, one warmup per library, nine alternating AB/BA sequential trials, no concurrent profile test process. Not isolated from unrelated host load. Includes identical checksum loop. No target/renderer speed claim.','compiler':subprocess.check_output(['cc','--version'],text=True).splitlines()[0],'architecture':subprocess.check_output(['uname','-m'],text=True).strip(),'binaryPins':{k:hashlib.sha256((B/(k+'.so')).read_bytes()).hexdigest() for k in libs}}
(R/'BENCHMARK.json').write_text(json.dumps(report,indent=2)+'\n')
