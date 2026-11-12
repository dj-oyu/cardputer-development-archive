import argparse,hashlib,json,re,struct
from pathlib import Path
ap=argparse.ArgumentParser();ap.add_argument('root');ap.add_argument('output');ap.add_argument('--manifest-root');a=ap.parse_args();p=Path(a.root);manifest_root=Path(a.manifest_root) if a.manifest_root else p
m=json.loads((p/'EVIDENCE_MANIFEST.json').read_text())
for n,v in m.items():
 b=(manifest_root/n).read_bytes();assert len(b)==v['bytes'] and hashlib.sha256(b).hexdigest()==v['sha256'],n
summaries=json.loads((p/'work/function-summary.json').read_text());objects=json.loads((p/'work/object-summary.json').read_text());result=[]
for obj in objects:
 ident=obj['identity'];file_ident=ident.removesuffix('-format');q=p/'objects'/file_ident
 if ident.endswith('-format'):
  build=json.loads((p/'work/build-status.json').read_text());commands=[c for c in build['commands'] if f"q{c['bits']}-{c['optimization']}/{c['unit']}"==file_ident];assert len(commands)==1 and commands[0]['exit_code']==0 and commands[0]['object_sha256']==obj['object_sha256']
 if obj.get('status')=='FAILED':
  assert not q.with_suffix('.o').exists();continue
 b=q.with_suffix('.o').read_bytes();assert b[:6]==b'\x7fELF\x01\x01' and struct.unpack_from('<HH',b,16)==(1,94)
 assert hashlib.sha256(b).hexdigest()==obj['object_sha256']
 entries={};name=None
 for line in q.with_suffix('.instructions.txt').read_text().splitlines():
  f=re.fullmatch(r'[0-9a-f]+ <([^>]+)>:',line)
  if f:name=f[1]
  e=re.search(r':\s+[0-9a-f]{4,8}\s+entry\s+a1,\s*(0x[0-9a-f]+|[0-9]+)',line)
  if e:assert name and name not in entries;entries[name]=int(e[1],0)
 su={}
 for line in q.with_suffix('.su').read_text().splitlines():
  fields=line.split('\t');name=fields[0].rsplit(':',1)[1];name=name.replace('.constprop','$constprop$0');assert name not in su;su[name]=int(fields[1])
 assert entries==su,(ident,entries,su)
 expected={x['symbol']:x['entry_frame'] for x in summaries if x['object_identity']==ident};assert expected==entries
 result.append({'object':ident,'entry_su_functions':len(entries),'max_own_frame':max(entries.values()),'verified_ELF32_Xtensa_REL':True})
out={'scope':'Independent manifest/hash, ELF-header, saved-prologue and own-stack cross-check. No target execution or disassembler was run here.','manifest_files':len(m),'objects_passed':len(result),'objects_failed':sum(x.get('status')=='FAILED' for x in objects),'functions_crosschecked':sum(x['entry_su_functions'] for x in result),'objects':result}
Path(a.output).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
