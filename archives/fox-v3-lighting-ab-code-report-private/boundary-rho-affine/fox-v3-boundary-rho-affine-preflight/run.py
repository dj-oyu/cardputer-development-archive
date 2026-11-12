from pathlib import Path
import json,subprocess,hashlib,time
R=Path(__file__).resolve().parent;W=R.parent;OLD=W/'fox-v3-boundary-aa-evaluation/actual-001/on';rows=[];pins={};sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();pins[str(R/'count-hits')]=sha(R/'count-hits');
for p in [R/'count_hits.c',Path(__file__),W/'fox-v3-boundary-rho-affine-core-A/product/main/ayatsuri/compact_opaque.c',W/'fox-v3-boundary-rho-affine-core-A/product/main/ayatsuri/compact_opaque.h',OLD/'COMPLETED.json']:pins[str(p)]=sha(p)
start=time.perf_counter()
for arm,q in [('A','.25'),('B','0x1.272062ae104d0p-2')]:
 for row in json.load(open(OLD/'COMPLETED.json'))['frames']:
  p=OLD/row['prefix'];snap=Path(str(p)+'.snapshot');mask=Path(str(p)+'.targets.u8')
  for x in [snap,mask]:pins[str(x)]=sha(x)
  d=json.loads(subprocess.check_output([str(R/'count-hits'),str(snap),str(mask),q]));d.update({k:row[k] for k in ['view','case','reverse']});d['arm']=arm;d['snapshotSHA256']=sha(snap);d['targetSHA256']=sha(mask)
  if arm=='A':
   source=Path(str(p)+'.aa.json');pins[str(source)]=sha(source);assert d['sampleHits']==json.load(open(source))['sampleHits']
  rows.append(d)
assert all(sha(Path(p))==h for p,h in pins.items());result={'status':'ALL40_GEOMETRY_PREFLIGHT_COMPLETE','rows':rows,'inputPins':pins,'wallSeconds':time.perf_counter()-start,'scope':'covered union equals final hit for these pinned inputs; every covered triangle interpolated depth explicitly checked finite; no winner material/shader evaluated; mask source fixed v32 runtime output with pinned source geometry','buildFlags':['-std=c11','-O2','-ffp-contract=off','-fexcess-precision=standard','-fstack-usage'],'cpuTimingScope':'per-process from before file reads through explicit FNV hashes; excludes printf/process startup; wall includes subprocess and parent pin work','frameBudgetIncluded':False,'reason':'separate newly authorized host reservation preflight; computation/memory disclosed, not old frame-equivalent cost'};(R/'RESULT.json').write_text(json.dumps(result,indent=2)+'\n');print([(r['arm'],r['view'],r['sampleHits'],r['totalHits']) for r in rows if r['case']=='baseline' and not r['reverse']])
