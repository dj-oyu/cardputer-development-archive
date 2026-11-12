from pathlib import Path
import json,hashlib,statistics,subprocess
import numpy as np
R=Path(__file__).resolve().parent;B=R.parent/'bench';W=R.parents[1];P=W/'fox-v3-lossless-profile-lut/profile'
j=json.loads((B/'BENCHMARK.json').read_text());m=json.loads((P/'INPUTS.json').read_text());libs=json.loads((B/'LIBRARIES.json').read_text());names=list(libs)
def h(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
assert j['inputManifestSHA256']==h(P/'INPUTS.json')
for k,v in j['binaryPins'].items():assert v==h(libs[k])
frames=[(f['name'],np.fromfile(f['hdr'],'<f8').reshape(-1,3).astype(np.float32)) for f in m['frames']]
summary={}
for name,scenario in j['scenarios'].items():
 indices=list(range(40)) if name=='manifest_order' else [v for i in range(20) for v in (i,20+i)]
 selected=[frames[i] for i in indices] if name!='cold_seeded_log_hdr' else [('seeded_log_hdr_first8192',np.load(P/'private/synthetic.npz')['seeded_log_hdr'][:8192])]
 assert scenario['pixels']==sum(len(x[1]) for x in selected)
 assert scenario['frameOrder']==[x[0] for x in selected]
 assert scenario['inputSHA256']==hashlib.sha256(b''.join(a.tobytes() for _,a in selected)).hexdigest()
 assert len(scenario['trials'])==9
 for t,row in enumerate(scenario['trials']):
  order=names[t%5:]+names[:t%5];order=order[::-1] if t%2 else order
  assert row['order']==order and row['trial']==t
  for arm in names:
   f=row['arms'][arm]['frames'];assert len(f)==len(selected)
   assert [x['name'] for x in f]==[x[0] for x in selected]
   assert [x['pixels'] for x in f]==[len(x[1]) for x in selected]
   assert row['arms'][arm]['totalNs']==sum(x['ns'] for x in f)
  for i in range(len(selected)):assert len({row['arms'][arm]['frames'][i]['checksum'] for arm in names})==1
 med={a:statistics.median(t['arms'][a]['totalNs'] for t in scenario['trials']) for a in names}
 assert med==scenario['medianTotalNs']
 for a in names:
  assert scenario['medianNsPerProfile'][a]==med[a]/scenario['pixels']
  assert scenario['overRaw'][a]==med[a]/med['raw'] and scenario['overBaseline'][a]==med[a]/med['baseline']
  for i,x in enumerate(scenario['medianFrameNs'][a]):assert x['name']==selected[i][0] and x['ns']==statistics.median(t['arms'][a]['frames'][i]['ns'] for t in scenario['trials'])
 summary[name]={'nsPerProfile':scenario['medianNsPerProfile'],'overRaw':scenario['overRaw'],'overBaseline':scenario['overBaseline'],'all9PairedTrialsAndInputHashes':True}
cost=json.loads((B/'COSTS.json').read_text())
for a,c in cost['arms'].items():
 actual={'text':0,'readOnlyData':0,'writableStatic':0}
 for f in [B/'build'/f'{a}_profile.o']+([] if a=='raw' else [B/'build'/f'{a}_decoder.o']):
  for line in subprocess.check_output(['size','-A',str(f)],text=True).splitlines():
   p=line.split()
   if len(p)<2 or not p[1].isdigit():continue
   k='text' if p[0].startswith('.text') else 'readOnlyData' if p[0].startswith('.rodata') else 'writableStatic' if p[0] in ('.data','.bss') else None
   if k:actual[k]+=int(p[1])
 for k,v in actual.items():assert c[k]==v
 assert c['conservativeProfileDecoderCallChainBytes']==sum(c['perFunctionHostStackBytes'][f] for f in c['callChain'])
 assert c['writableStatic']==c['retainedCacheRAM']==0
report=json.loads((R/'REVIEW.json').read_text());report['status']='PASS_INDEPENDENT_CORRECTNESS_AND_BENCHMARK_REVIEW';report['benchmarkRecomputed']=summary;report['costsRecomputed']=True;report['benchmarkPins']={f:h(B/f) for f in ['BENCHMARK.json','COSTS.json','LOCALITY.json','PLAN.md','BUILD.json']};(R/'REVIEW.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(summary,indent=2))
