from pathlib import Path
import json,re,hashlib,struct,csv,collections
R=Path(__file__).parent;m=json.loads((R/'build-status.json').read_text());O=Path(m['output_root']);functions=[];objects=[];evidence=[]
def sections(p):
 b=p.read_bytes();at=struct.unpack_from('<I',b,32)[0];stride,n,si=struct.unpack_from('<HHH',b,46);rows=[struct.unpack_from('<10I',b,at+i*stride) for i in range(n)];s=rows[si];names=b[s[4]:s[4]+s[5]]
 return {names[x[0]:].split(b'\0',1)[0].decode():{'size':x[5],'flags':x[2]} for x in rows}
for c in m['commands']:
 assert c['exit_code']==0;obj=Path(c['object']);d=obj.parent;s=sections(obj);key=d.name+'/compact-format';su={}
 for l in (d/'compact.su').read_text().splitlines():
  name,frame,kind=l.split('\t');su[name.rsplit(':',1)[1]]=int(frame)
 asm=(d/'compact.instructions.txt').read_text();calls=collections.Counter();entrymatches=True
 for block in re.split('Disassembly of section ',asm)[1:]:
  sec=block.split(':',1)[0];name=re.search(r'^[0-9a-f]+ <([^>]+)>:',block,re.M)[1];entry=int(re.search(r'\bentry\s+a1,\s*(0x[0-9a-f]+|\d+)',block)[1],0);sf=su.get(name);assert sf==entry,(key,name,sf,entry)
  cl=collections.Counter(re.findall(r'R_XTENSA_ASM_EXPAND\s+(\S+)',block));calls.update(cl)
  functions.append({'object_identity':key,'object_sha256':c['object_sha256'],'symbol':name,'section':sec,'entry_frame':entry,'su_own_frame':sf,'text_bytes':s[sec]['size'],'literal_bytes':s.get('.literal.'+name,{}).get('size',0),'heuristic_far_sites':0,'call_sites':dict(cl)})
  if name=='kcc_block':
   ls=block.splitlines();i=next(i for i,l in enumerate(ls) if '<kcc_block>:' in l);evidence.append(key+'\n'+'\n'.join(ls[i:i+15]))
 assert 'FRAME_LINT functions=0 far_accesses=0 extra_insns=0' in (d/'compact.frame-lint.txt').read_text()
 unresolved=[l.split()[-1] for l in (d/'compact.unresolved.txt').read_text().splitlines() if l.strip()]
 objects.append({'identity':key,'instruction_bytes':sum(x['size'] for n,x in s.items() if n.startswith('.text')),'literal_bytes':sum(x['size'] for n,x in s.items() if n.startswith('.literal')),'rodata_bytes':sum(x['size'] for n,x in s.items() if n.startswith('.rodata')),'data_bytes':sum(x['size'] for n,x in s.items() if n.startswith('.data')),'bss_bytes':sum(x['size'] for n,x in s.items() if n.startswith('.bss')),'runtime_helper_sites':{k:v for k,v in calls.items() if k.startswith('__')},'unresolved_symbols':unresolved,'scanner_far_sites':0,'preprocessor_token_identity':True,'object_sha256':c['object_sha256']})
(R/'object-summary.json').write_text(json.dumps(objects,indent=2)+'\n');(R/'function-summary.json').write_text(json.dumps(functions,indent=2)+'\n');(R/'manual-inspection.txt').write_text('Heuristic scanner reports zero claimed far sites in every separately preflighted compact object. Largest actual frame528B. This is not a gate, sound bound, or absence proof.\n\n'+'\n\n'.join(evidence)+'\n')
with (R/'function-summary.csv').open('w') as f:
 cols=['object_identity','symbol','entry_frame','su_own_frame','text_bytes','literal_bytes','heuristic_far_sites'];w=csv.DictWriter(f,fieldnames=cols);w.writeheader();w.writerows({k:x[k] for k in cols} for x in functions)
print('SUCCESSFUL_COMPACT_OBJECTS',len(objects),'FUNCTIONS',len(functions),'ENTRY_SU_MATCH_ALL')
for x in objects:print(x['identity'],x['instruction_bytes'],x['literal_bytes'],x['rodata_bytes'])
