from pathlib import Path
import hashlib,importlib.util,json,re,struct
P=Path(__file__).resolve().parent;R=P.parent.parent
E=R/'ayatsuri-pie-transfers-20261105/s3-result/evidence'
spec=importlib.util.spec_from_file_location('frame_lint',P.parent/'upstream/tools/frame_lint.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
manifest=json.loads((E/'EVIDENCE_MANIFEST.json').read_text())
result=[]
for name in ['c_scalar','explicit_scalar','ldf64','ldf128','rgb_scalar','rgb_qr','qr_leaf']:
 d=E/'objects'/name/'primary'; hashes={}
 for fn in ['module.o','instructions.txt','elf-abi.txt']:
  p=d/fn;b=p.read_bytes(); h=hashlib.sha256(b).hexdigest(); assert h==manifest[str(p.relative_to(E))]['sha256'];hashes[fn]=h
 b=(d/'module.o').read_bytes();assert b[:6]==b'\x7fELF\x01\x01';assert struct.unpack_from('<HH',b,16)==(1,94)
 source=(d/'instructions.txt').read_text();converted=[];count=0
 for l in source.splitlines():
  match=re.match(r'^(\s*[0-9a-f]+:)\s+([0-9a-f]{4,8})\s+([a-z][\w.]*)\s*(.*)$',l)
  if match:
   count+=1;l=match[1]+'\t'+match[3]+'\t'+match[4].split('\t',1)[0]
  converted.append(l)
 assert count>0
 text='\n'.join(converted)+'\n'; (P/(name+'.normalized.txt')).write_text(text)
 rows=list(m.scan(text.splitlines(),name));allrows=list(m.scan(text.splitlines(),name,0));assert len(allrows)==1
 expected=16 if name=='qr_leaf' else 32;assert allrows[0].frame==expected;assert rows==[]
 result.append({'name':name,'source_hashes':hashes,'elf_type':'ET_REL','elf_machine':94,'instructions_normalized':count,'frame_entry_bytes':expected,'default_lint_rows':[x._asdict() for x in rows],'claim':'Retained generic transfer object only; not a fixed arithmetic prototype or final firmware ELF.'})
out={'scope':'Parser sanity on hash-verified retained Xtensa disassembly; no compiler/objdump/device execution. Raw bytes and relocation annotations removed for upstream parser format only. Negative result is not a proof of no stack use.','results':result}
(P/'results.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
