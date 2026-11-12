from pathlib import Path
import json,subprocess
R=Path(__file__).resolve().parent;B=R/'build';rows={}
for arm in ['raw','baseline','fast_bits','gather','gather_fast_bits']:
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
 chain=['agx_profile_eval']+([] if arm=='raw' else ['lossless_fetch4' if arm in ['gather','gather_fast_bits'] else 'lossless_fetch','lossless_decode_channel']+(['getbits'] if 'fast_bits' in arm else []))
 rows[arm]={**tot,'perFunctionHostStackBytes':stack,'conservativeProfileDecoderCallChainBytes':sum(stack[k] for k in chain),'callChain':chain,'retainedCacheRAM':0,'initializationRequired':False}
report={'arms':rows,'scope':'Host cc -O2 objects, excluding identical benchmark wrapper, linker/ELF metadata and alignment. Decoder includes both public fetch functions even if one is not called. Conservative stack sum adds compiler .su maxima on active nested chain, not instrumented high-water; excludes libm internal stack and ABI caller overhead. No embedded/device RAM or timing claim.','worstCase':{'baselineBlockDecodesPerValidProfile':4,'gatherBlockDecodesPerValidProfile':4,'maxDecodedU16PerBlock':192,'maxDecodedU16PerProfile':768,'cacheMissEvictionsActual':'Not applicable: no persistent cache. Full selected blocks are decoded every call, duplicate selected blocks only deduplicated within a gather call.'}}
(R/'COSTS.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
