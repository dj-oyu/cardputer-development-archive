from pathlib import Path
import json,platform
P=Path(__file__).resolve().parent
report={'host':platform.platform(),'scope':'Host object inspection only; no target memory/performance claim. Stack figures are per-function compiler reports, not measured call-chain peaks.','objects':{}}
for opt in [0,2]:
 syms=(P/f'symbols-O{opt}.txt').read_text().splitlines();tables=[]
 for line in syms:
  parts=line.split()
  if len(parts)==4 and parts[2].lower()=='r':tables.append({'name':parts[3],'bytes':int(parts[1],16)})
 assert tables==[{'name':'face_compact_blob','bytes':7963}]
 assert not any(name in '\n'.join(syms) for name in ['raw','binary','spanoff','runs'])
 section={}
 for line in (P/f'sections-O{opt}.txt').read_text().splitlines():
  parts=line.split()
  if len(parts)==3 and parts[0].startswith('.'):section[parts[0]]=int(parts[1])
 assert section['.rodata']==7963 and section['.data']==section['.bss']==0
 stack=[]
 for line in (P/f'sampler-host-O{opt}.su').read_text().splitlines():
  loc,size,kind=line.split('\t');stack.append({'function':loc.rsplit(':',1)[1],'reported_bytes':int(size),'kind':kind})
 report['objects'][f'O{opt}']={'tables':tables,'sections':section,'undefined_symbols':(P/f'undefined-O{opt}.txt').read_text().splitlines(),'compiler_stack':stack}
(P/'object-report.json').write_text(json.dumps(report,indent=2))
print('PASS: isolated O0/O2 objects contain only the 7963-byte table; no oracle/alternate-format data')
