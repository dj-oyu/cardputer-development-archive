from pathlib import Path
import json,hashlib,statistics,subprocess,struct,tempfile
import numpy as np
W=Path('/workspace/scratch/6d8dcdbcdc54');B=W/'fox-v3-profile-four-block-cache/bench';R=B.parent/'review'
load=lambda p:json.loads(p.read_text());sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
x=load(B/'BENCHMARK.json');cost=load(B/'COSTS.json');build=load(B/'BUILD.json');m=load(W/'fox-v3-lossless-profile-lut/profile/INPUTS.json');libs=load(B/'LIBRARIES.json');arms=['raw','baseline','gather','cache4']
for p,h in m['pins'].items():assert sha(W/p)==h,p
for p,h in build['sourcePins'].items():assert sha(W/p)==h,p
for p,h in x['harnessPins'].items():assert sha(B/p)==h,p
for a,h in x['binaryPins'].items():assert sha(Path(libs[a]))==h,a
assert sha(B/'PLAN.md')==x['planSHA256'];assert sha(B/'BUILD.json')==x['buildSHA256'];assert sha(W/'fox-v3-lossless-profile-lut/profile/INPUTS.json')==x['inputManifestSHA256']
assert x['contextSize']=={'raw':0,'baseline':0,'gather':0,'cache4':3224}
orders={'manifest_order':list(range(40)),'alternate_off_on':[j for i in range(20) for j in(i,i+20)]}
checks=0;summaries={}
for name,s in x['scenarios'].items():
 order,mode=name.split('/');ix=orders[order];names=[m['frames'][i]['name'] for i in ix];assert s['frameOrder']==names;assert s['pixels']==1296000
 h=hashlib.sha256()
 for i in ix:h.update(np.fromfile(m['frames'][i]['hdr'],'<f8').astype('<f4').tobytes())
 assert h.hexdigest()==s['inputSHA256']
 rows=s['trials'];assert len(rows)==9
 for t,row in enumerate(rows):
  expected=arms[t%4:]+arms[:t%4]
  if t%2:expected=expected[::-1]
  assert row['trial']==t and row['order']==expected and list(row['arms'])==expected
 for row in [s['warmups']]+[r['arms'] for r in rows]:
  for a,r in row.items():
   assert len(r['frames'])==40;assert [f['name'] for f in r['frames']]==names
   assert r['pixelNs']==sum(f['pixelNs'] for f in r['frames'])
   assert r['setupNs']==r['bindNs']+sum(f['resetBindNs'] for f in r['frames'])
   assert r['setupPlusPixelNs']==r['setupNs']+r['pixelNs']
   assert r['dispatchAndSnapshotGapNs']==r['batchWallNs']-r['setupPlusPixelNs']>=0
   assert r['counterTotals']==[sum(f['counterDelta'][k] for f in r['frames']) for k in range(3)]
   if mode=='cold_per_frame':assert r['bindNs']==0
   else:assert all(f['resetBindNs']==0 for f in r['frames'])
   if a=='cache4':assert (r['bindNs']>0)==(mode=='warm_across_frames')
   else:assert r['setupNs']==0 and r['counterTotals']==[0,0,0]
   for k,f in enumerate(r['frames']):
    assert f['pixels']==32400 and f['pixelNs']>0
    assert f['checksum']==s['warmups']['raw']['frames'][k]['checksum']
    assert f['counterDelta']==s['warmups'][a]['frames'][k]['counterDelta']
    if a=='cache4':assert sum(f['counterDelta'][:2])==129600 and f['counterDelta'][2]==0
    checks+=1
 for metric,vals in s['medians'].items():
  for a in arms:assert vals[a]==statistics.median(r['arms'][a][metric] for r in rows)
 for a in arms:
  assert s['primaryNsPerProfile'][a]==s['medians']['batchWallNs'][a]/s['pixels']
  for ref in ['raw','baseline','gather']:assert s['primaryRatios'][ref][a]==s['medians']['batchWallNs'][a]/s['medians']['batchWallNs'][ref]
  for i,f in enumerate(s['medianFramePixelNs'][a]):assert f=={'name':names[i],'ns':statistics.median(r['arms'][a]['frames'][i]['pixelNs'] for r in rows)}
 cache=s['primaryNsPerProfile']['cache4'];summaries[name]={'cacheNsPerProfile':cache,'gatherSpeedup':s['primaryNsPerProfile']['gather']/cache,'cacheVsRaw':cache/s['primaryNsPerProfile']['raw'],'actualCounts':s['warmups']['cache4']['counterTotals']}
for a,c in cost['arms'].items():
 paths=[B/'build'/f'{a}_profile.o']+([] if a=='raw' else[B/'build'/f'{a}_decoder.o']);tot={'text':0,'readOnlyData':0,'writableStatic':0};stack={}
 for p in paths:
  for line in subprocess.check_output(['size','-A',str(p)],text=True).splitlines():
   cols=line.split()
   if len(cols)<2 or not cols[1].isdigit():continue
   section,n=cols[0],int(cols[1])
   if section.startswith('.text'):tot['text']+=n
   if section.startswith('.rodata'):tot['readOnlyData']+=n
   if section in ['.bss','.data']:tot['writableStatic']+=n
  for line in p.with_suffix('.su').read_text().splitlines():name,n,_=line.split('\t');stack[name.split(':')[-1]]=int(n)
 for key,n in tot.items():assert c[key]==n
 assert c['perFunctionHostStackBytes']==stack;assert c['conservativeProfileDecoderCallChainBytes']==sum(stack[k] for k in c['callChain'])
 assert c['callerCacheSizeofBytes']==x['contextSize'][a]
# Verify data actually compiled into each compressed object against frozen blob.
blob=(W/'fox-v3-lossless-profile-lut/research/private/agx_cube4_rice.bin').read_bytes()
with tempfile.TemporaryDirectory(dir=R) as tmp:
 for a in ['baseline','gather','cache4']:
  p=Path(tmp)/'section';subprocess.run(['objcopy','--dump-section',f'.rodata={p}',str(B/'build'/f'{a}_profile.o')],check=True);assert p.read_bytes()==blob
raw_text=(W/'fox-v3-profile-integration-feasibility/build-private/agx_lut.inc').read_text()
raw=np.fromstring(raw_text.split('{',1)[1].split('}',1)[0],dtype='<u2',sep=',').tobytes()
with tempfile.TemporaryDirectory(dir=R) as tmp:
 p=Path(tmp)/'section';subprocess.run(['objcopy','--dump-section',f'.rodata={p}',str(B/'build/raw_profile.o')],check=True);assert p.read_bytes()==raw
assert build['sourcePins']['fox-v3-profile-four-block-cache/implementation/block_cache.c']=='7e06ed0436d9e6be0783f0b31c208f75034be297f450e10f813e00d04a13fff6'
result={'status':'PASS','inputPins':87,'frameArmChecksIncludingWarmups':checks,'measuredFrameArmChecks':5760,'scenarios':summaries,'objectCostsVerified':True,'compiledCompressedDataMatchesFrozenBlob':True,'compiledRawDataMatchesFrozenTable':True,'newTimingRuns':0}
(R/'BENCHMARK_REVIEW.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
