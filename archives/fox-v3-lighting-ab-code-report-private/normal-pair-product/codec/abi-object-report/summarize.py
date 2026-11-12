from pathlib import Path
import hashlib,json,re
r=Path(__file__).resolve().parent;n=r.parent;o=n.parent/'fox-v3-eye-evaluation/actual-eyeB';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
f=json.loads((n/'SOURCE_FREEZE.json').read_text())
for p,h in f['product_files'].items():assert sha(n/p)==h['sha256'] and sha(o/p)==h['baseline_sha256']
result={'scope':'x86_64 host O2 relocatable objects; not linked target firmware or peak RAM','flags':(r/'flags.txt').read_text().strip(),'extra_measurement_flag':'-fstack-usage','abi_identical':(r/'old/abi.txt').read_bytes()==(r/'new/abi.txt').read_bytes(),'source_freeze_sha256':sha(n/'SOURCE_FREEZE.json'),'product_sources_unchanged':True,'struct_declarations_identical':{},'objects':{},'stack_frames':{}}
for p in ['product/main/ayatsuri/compact_opaque.h','product/main/ui/kasane/ksn_mesh_depth.h']:
 decl=lambda text:re.findall(r'typedef\s+struct\s*\{.*?\}\s*\w+\s*;',text,re.S)
 result['struct_declarations_identical'][p]=decl((n/p).read_text())==decl((o/p).read_text())
 assert result['struct_declarations_identical'][p]
for unit in ['compact_opaque','ksn_mesh_depth']:
 result['objects'][unit]={}
 for variant in ['old','new']:
  p=r/variant/f'{unit}.sections.txt';sections={}
  for line in p.read_text().splitlines():
   fields=line.split()
   if len(fields)==3 and fields[0].startswith('.') and fields[1].isdigit():sections[fields[0]]=int(fields[1])
  totals={'text':sum(v for k,v in sections.items() if k=='.text' or k.startswith('.text.')),'rodata':sum(v for k,v in sections.items() if k=='.rodata' or k.startswith('.rodata.')),'data':sum(v for k,v in sections.items() if k=='.data' or k.startswith('.data.')),'bss':sum(v for k,v in sections.items() if k=='.bss' or k.startswith('.bss.')),'eh_frame':sections.get('.eh_frame',0)}
  undefined=(r/variant/f'{unit}.undefined.txt').read_text()
  totals['allocator_symbols']=re.findall(r'\b(?:malloc|calloc|realloc|free|alloca|mmap)\b',undefined)
  totals['object_sha256']=sha(r/variant/f'{unit}.o')
  result['objects'][unit][variant]=totals
  frames={}
  for line in (r/variant/f'{unit}.su').read_text().splitlines():
   where,size,kind=line.split('\t');frames[where.rsplit(':',1)[-1]]={'own_frame_bytes':int(size),'classification':kind}
  result['stack_frames'].setdefault(unit,{})[variant]=frames
 result['objects'][unit]['delta']={key:result['objects'][unit]['new'][key]-result['objects'][unit]['old'][key] for key in ['text','rodata','data','bss','eh_frame']}
result['combined']={variant:{key:sum(result['objects'][unit][variant][key] for unit in result['objects']) for key in ['text','rodata','data','bss','eh_frame']} for variant in ['old','new','delta']}
assert result['abi_identical']
(r/'summary.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result['combined'],indent=2))
print('all_frozen_sources_and_baseline_hashes_unchanged',True)
