from pathlib import Path
import json,subprocess,ctypes as C
R=Path(__file__).resolve().parent;B=R/'build';rows={};build=json.loads((R/'BUILD.json').read_text())
for arm in ['raw','baseline','gather','cache4']:
 files=[B/(arm+'_profile.o')]+([] if arm=='raw' else [B/(arm+'_decoder.o')]);tot={'text':0,'readOnlyData':0,'writableStatic':0};stack={}
 for f in files:
  for line in subprocess.check_output(['size','-A',str(f)],text=True).splitlines():
   cols=line.split()
   if len(cols)<2 or not cols[1].isdigit():continue
   key,n=cols[0],int(cols[1])
   if key.startswith('.text'):tot['text']+=n
   elif key.startswith('.rodata'):tot['readOnlyData']+=n
   elif key in ['.data','.bss']:tot['writableStatic']+=n
  for line in f.with_suffix('.su').read_text().splitlines():
   name,size,kind=line.split('\t');stack[name.rsplit(':',1)[-1]]=int(size)
 chain={'raw':['agx_profile_eval'],'baseline':['agx_profile_eval','lossless_fetch','lossless_decode_channel'],'gather':['agx_profile_eval','lossless_fetch4','lossless_decode_channel'],'cache4':['agx_cache_profile_eval','agx_cache_fetch4','header']}[arm]
 l=C.CDLL(str(B/(arm+'.so')));l.profile_context_size.restype=C.c_size_t
 rows[arm]={**tot,'perFunctionHostStackBytes':stack,'conservativeProfileDecoderCallChainBytes':sum(stack[k] for k in chain),'callChain':chain,'callerCacheSizeofBytes':l.profile_context_size(),'benchmarkStaticContextBytes':l.profile_context_size(),'initializationRequired':arm=='cache4'}
report={'arms':rows,'compilerFlags':build['flags'],'scope':'Host cc -O2 objects excluding benchmark bridge, linker metadata and alignment. Fixed caller cache is stored by bridge as a host convenience and is reported separately, not omitted. Conservative stack sums compiler .su values on nested chain; cache decode_channel is inlined into agx_cache_fetch4. Excludes libm/memcpy/memcmp internals and ABI caller overhead. Not observed stack high-water, embedded RAM, or device timing. Bind fully validates index and empties cache/counters; clear unbinds. No allocations. Cache snapshots encoded bytes as well as 1536-byte decoded payload, explaining larger actual sizeof.','worstCase':{'cacheSlots':4,'decodedU16PayloadBytes':1536,'maxMissesPerProfile':4,'maxDecodedU16PerProfile':768,'maxEncodedSnapshotBytesPerSlot':396,'maxHitSnapshotCompareBytesPerProfile':1584,'evictionCount':'Not exposed by API; not inferred as measured.'}}
(R/'COSTS.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
