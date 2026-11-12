from pathlib import Path
import subprocess,json,hashlib,statistics,sys
R=Path(__file__).resolve().parent;sys.path.insert(0,str(R));from prototype import encode,records
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();O=R/'codec-cpu-001';O.mkdir(exist_ok=False);flags=['-std=c11','-O2','-Wall','-Wextra','-Werror','-Wno-misleading-indentation','-ffp-contract=off','-fexcess-precision=standard'];binary=O/'codec-bench';subprocess.run(['cc',*flags,str(R/'codec_bench.c'),'-o',str(binary)],check=True)
manifest=json.loads((R/'dump-summary.json').read_text());jobs=[]
for x in manifest['rows']:
 raw=R/x['file'];expected=R/'private-encoded'/(raw.stem+'.diag-e4');jobs.append((raw.stem,raw,expected,'actual'))
# Actual-range quantization-asymmetry fixtures: one component per selected record.
import struct
raw0=jobs[0][1].read_bytes()
for mode in ['single-record-fallback','all-record-fallback']:
 data=bytearray(raw0)
 for i,(off,rec,nv,nt,stride,raw) in enumerate(records(raw0)):
  if mode=='single-record-fallback' and i:break
  old=struct.unpack_from('<h',data,off+12+50)[0];struct.pack_into('<h',data,off+12+50,old+1 if old<32767 else old-1)
 raw=R/'private-snapshots'/(mode+'.snapshot');raw.write_bytes(data);enc,_=encode(bytes(data));expected=R/'private-encoded'/(mode+'.diag-e4');expected.write_bytes(enc);jobs.append((mode,raw,expected,'synthetic-normal-range-asymmetry'))
pins={str(p):sha(p) for _,raw,expected,_ in jobs for p in [raw,expected]};pins[str(R/'codec_bench.c')]=sha(R/'codec_bench.c');pins[str(binary)]=sha(binary);rows=[]
for name,raw,expected,kind in jobs:
 q=subprocess.run([str(binary),str(raw),str(expected),'1000'],capture_output=True,text=True);assert q.returncode==0,(name,q.returncode,q.stderr);x=json.loads(q.stdout);x.update(name=name,kind=kind);x['perCallNs']={op:{'min':min(v)/1000,'median':statistics.median(v)/1000,'max':max(v)/1000} for op,v in x['batchNs'].items()};rows.append(x);(O/'progress.json').write_text(json.dumps(rows,indent=2))
assert all(sha(Path(p))==h for p,h in pins.items());actual=[x for x in rows if x['kind']=='actual'];summary={op:{'min':min(v),'median':statistics.median(v),'max':max(v)} for op in ['copy','encode','decode'] for v in [[ns/1000 for row in actual for ns in row['batchNs'][op]]]};result={'status':'COMPLETE_STANDALONE_DIAGNOSTIC_NOT_PRODUCT_COST','actualSnapshots':20,'syntheticFixtures':2,'repeats':3,'iterationsPerBatch':1000,'flags':flags,'inputPins':pins,'allBatchOutputsExact':True,'actualAll60BatchesPerCallNs':summary,'rows':rows,'scope':'Standalone C byte copy vs diagnostic conditional encode/decode, preallocated buffers; not original product writer delta, not renderer overhead, not device timing'};(O/'COMPLETED.json').write_text(json.dumps(result,indent=2));print(json.dumps(summary,indent=2))
