from pathlib import Path
import time,json,sys
p=Path(sys.argv[1]);assert not p.exists();p.parent.mkdir(parents=True,exist_ok=True)
def sample():return list(map(int,Path('/proc/stat').read_text().splitlines()[0].split()[1:]))
a=sample();t=time.monotonic_ns();time.sleep(1);b=sample();elapsed=time.monotonic_ns()-t;delta=[y-x for x,y in zip(a,b)];total=sum(delta[:8]);busy=total-delta[3]-delta[4]
d={'epoch':time.time(),'elapsedNs':elapsed,'jiffiesBefore':a,'jiffiesAfter':b,'jiffiesDelta':delta,'totalJiffiesFirst8':total,'busyJiffiesFirst8':busy,'busyFraction':busy/total if total else None,'loadavg':Path('/proc/loadavg').read_text().strip(),'visibleProcessCount':len(list(Path('/proc').glob('[0-9]*'))),'scope':'Namespace-visible one-second observation, not proof that all host workloads are absent. Guest columns excluded from total to avoid double counting.'};p.write_text(json.dumps(d,indent=2)+'\n');print(json.dumps(d))
