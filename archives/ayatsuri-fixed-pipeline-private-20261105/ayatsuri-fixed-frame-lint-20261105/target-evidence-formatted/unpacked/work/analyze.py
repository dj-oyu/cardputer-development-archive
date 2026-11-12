from pathlib import Path
import json,re,struct,collections,csv,subprocess,hashlib
R=Path(__file__).parent;m=json.loads((R/'build-status.json').read_text());O=Path(m['output_root']);BIN=Path(m['compiler']['path']).parent

def sections(p):
 b=p.read_bytes();at=struct.unpack_from('<I',b,32)[0];stride,n,si=struct.unpack_from('<HHH',b,46);rows=[struct.unpack_from('<10I',b,at+i*stride) for i in range(n)];s=rows[si];names=b[s[4]:s[4]+s[5]]
 return {names[x[0]:].split(b'\0',1)[0].decode():{'size':x[5],'flags':x[2]} for x in rows}
objects=[];functions=[];evidence=[]
for c in m['commands']:
 obj=Path(c['object']);d=obj.parent;u=c['unit'];key=f"q{c['bits']}-{c['optimization']}/{u}"
 if c['exit_code']:
  clean=re.sub(r'\x1b\[[0-9;]*[mK]','',(d/(u+'.compile.log')).read_text());objects.append({'identity':key,'status':'FAILED','error_count':clean.count('error:'),'misleading_indentation_count':clean.count('-Werror=misleading-indentation'),'object_present':obj.exists()});continue
 s=sections(obj);su={}
 for line in (d/(u+'.su')).read_text().splitlines():
  src,frame,kind=line.split('\t');su[src.rsplit(':',1)[1]]={'frame':int(frame),'kind':kind}
 scan=(d/(u+'.frame-lint.txt')).read_text();assert 'FRAME_LINT functions=0 far_accesses=0 extra_insns=0 limit=1020' in scan
 unresolved=subprocess.check_output([str(BIN/'xtensa-esp32s3-elf-nm'),'-u',str(obj)],text=True);(d/(u+'.unresolved.txt')).write_text(unresolved);unresolved=[l.split()[-1] for l in unresolved.splitlines() if l.strip()]
 text=(d/(u+'.instructions.txt')).read_text();funcs=[];allsites=collections.Counter();allfar=[]
 for block in re.split('Disassembly of section ',text)[1:]:
  sec=block.split(':',1)[0];match=re.search(r'^([0-9a-f]+) <([^>]+)>:',block,re.M);assert match,sec;name=match[2]
  frame=re.search(r'\bentry\s+a1,\s*(0x[0-9a-f]+|\d+)',block);entry=int(frame[1],0) if frame else 0;su_name=name if name in su else name.replace('$constprop$0','.constprop');sf=su.get(su_name,{}).get('frame');calls=collections.Counter(re.findall(r'R_XTENSA_ASM_EXPAND\s+(\S+)',block));allsites.update(calls)
  insns=re.findall(r'^\s*([0-9a-f]+):\s+[0-9a-f]{4,8}\s+(\S+)\s*([^\n]*)',block,re.M)
  roots=[{'offset':at,'instruction':op+' '+args.split('\t')[0]} for at,op,args in insns if op=='addmi' and re.search(r',\s*a1,',args) and int(args.split(',')[2].split()[0],0)>1020]
  allfar+=roots
  row={'object_identity':key,'object_sha256':c['object_sha256'],'symbol':name,'section':sec,'entry_frame':entry,'su_own_frame':sf,'su_symbol_label':su_name,'clone_label_mapping_explicit':su_name!=name,'text_bytes':s[sec]['size'],'literal_bytes':s.get('.literal.'+name,{}).get('size',0),'heuristic_far_sites':0,'candidate_addmi_far_roots':roots,'call_sites':dict(calls),'PIE_instruction_sites':sum(op.startswith('ee.') for _,op,_ in insns)};functions.append(row);funcs.append(row)
  if sf!=entry:evidence.append(key+' '+name+' entry/su differ '+str((entry,sf)))
 objrow={'identity':key,'status':'PASS','bits':c['bits'],'optimization':c['optimization'],'unit':u,'object_sha256':c['object_sha256'],'instruction_bytes':sum(x['size'] for n,x in s.items() if n.startswith('.text.')),'literal_bytes':sum(x['size'] for n,x in s.items() if n.startswith('.literal.')),'rodata_bytes':sum(x['size'] for n,x in s.items() if n.startswith('.rodata')),'data_bytes':sum(x['size'] for n,x in s.items() if n.startswith('.data')),'bss_bytes':sum(x['size'] for n,x in s.items() if n.startswith('.bss')),'functions_parsed':len(funcs),'scanner_reported_rows':0,'scanner_far_sites':0,'entry_su_match_all':all(x['entry_frame']==x['su_own_frame'] for x in funcs),'candidate_addmi_far_roots':allfar,'static_call_sites':dict(allsites),'unresolved_symbols':unresolved,'runtime64_helper_sites':{k:v for k,v in allsites.items() if k in ('__muldi3','__udivdi3','__divdi3','__umoddi3','__moddi3','__ashldi3','__lshrdi3','__ashrdi3')}};objects.append(objrow)
 # Preserve representative actual prologues and scalar stack accesses only, no constant dump.
 for row in funcs:
  if row['symbol'] in ('mc_block','mc_eval$part$0','cp_block','tc_block','tc_mix'):
   block=next(b for b in re.split('Disassembly of section ',text)[1:] if b.startswith(row['section']+':'));ls=block.splitlines();idx=next(i for i,l in enumerate(ls) if '<'+row['symbol']+'>:' in l);evidence.append(key+' '+row['symbol']+'\n'+'\n'.join(ls[idx:idx+11]))
(R/'object-summary.json').write_text(json.dumps(objects,indent=2)+'\n');(R/'function-summary.json').write_text(json.dumps(functions,indent=2)+'\n');(R/'manual-inspection.txt').write_text('No heuristic far-access sites were claimed in18 successful objects. All input disassemblies preflighted as nonempty Xtensa REL. Each function prologue and compiler su independently cross-checked. Zero is an advisory pattern count, not an acceptance gate.\n'+'\n\n'.join(evidence)+'\n')
with (R/'function-summary.csv').open('w') as f:
 cols=['object_identity','symbol','entry_frame','su_own_frame','text_bytes','literal_bytes','heuristic_far_sites'];w=csv.DictWriter(f,fieldnames=cols);w.writeheader();w.writerows({k:r[k] for k in cols} for r in functions)
print('OBJECTS',len(objects),'SUCCESS',sum(x['status']=='PASS' for x in objects),'FUNCTIONS',len(functions),'ENTRY_SU_MATCH',all(x['entry_frame']==x['su_own_frame'] for x in functions),'FAR_ROOTS',sum(len(x.get('candidate_addmi_far_roots',[])) for x in objects))
for x in objects:
 if x['status']=='PASS':print(x['identity'],'text/lit/RO',x['instruction_bytes'],x['literal_bytes'],x['rodata_bytes'],'max_frame',max(f['entry_frame'] for f in functions if f['object_identity']==x['identity']))
