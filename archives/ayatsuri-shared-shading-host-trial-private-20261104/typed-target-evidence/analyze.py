from pathlib import Path
import struct,re,json,subprocess,hashlib,collections,shutil
ROOT=Path(__file__).resolve().parent;OLD=ROOT/'results/previous-bounded-reference';OLD=OLD if (OLD/'model.o').exists() else Path('/workspace/ayatsuri-s3-reconstructed-20261104/results/candidate-bounded');BIN=Path('/workspace/.setup/espressif/tools/xtensa-esp-elf/esp-15.2.0_20251204/xtensa-esp-elf/bin')
def sections(p):
 b=p.read_bytes();at=struct.unpack_from('<I',b,32)[0];stride,n,si=struct.unpack_from('<HHH',b,46);rows=[struct.unpack_from('<10I',b,at+i*stride) for i in range(n)];s=rows[si];names=b[s[4]:s[4]+s[5]]
 return {names[x[0]:].split(b'\0',1)[0].decode():{'size':x[5],'flags':x[2],'data':b[x[4]:x[4]+x[5]] if x[1]!=8 else b''} for x in rows}
def alloc(p):return {n:x['data'] for n,x in sections(p).items() if x['flags']&2 and x['size']}
def relocs(p):
 a=re.split(r'RELOCATION RECORDS FOR \[([^]]+)\]:\n',p.read_text());return {a[k]:a[k+1].strip() for k in range(1,len(a),2) if a[k].startswith(('.text','.literal','.rodata'))}
summary={};snippets=[];reference=ROOT/'results/previous-bounded-reference';reference.mkdir(exist_ok=True)
for unit in ['model','shade_pair']:
 for suffix in ['o','relocations.txt','su']:
  if OLD.resolve()!=reference.resolve():shutil.copy2(OLD/(unit+'.'+suffix),reference/(unit+'.'+suffix))
 assert alloc(OLD/(unit+'.o'))==alloc(ROOT/'results/control'/(unit+'.o'))
 assert relocs(OLD/(unit+'.relocations.txt'))==relocs(ROOT/'results/control'/(unit+'.relocations.txt'))
summary['fresh_control_previous_machine_and_relocations_match']=True
for variant in ['control','candidate-typed-stores']:
 summary[variant]={}
 for unit in ['model','shade_pair']:
  d=ROOT/'results'/variant;obj=d/(unit+'.o');s=sections(obj);text=subprocess.check_output([str(BIN/'xtensa-esp32s3-elf-size'),str(obj)],text=True);(d/(unit+'.totals.txt')).write_text(text);totals=list(map(int,text.splitlines()[1].split()[:3]));stacks={}
  for line in (d/(unit+'.su')).read_text().splitlines():
   name,stack,kind=line.split('\t');stacks[name.split(':')[-1]]={'bytes':int(stack),'kind':kind}
  funcs={}
  for block in re.split('Disassembly of section ',(d/(unit+'.asm.txt')).read_text())[1:]:
   name=block.split(':',1)[0]
   if not name.startswith('.text.'):continue
   instructions=re.findall(r'^\s*([0-9a-f]+):\s+[0-9a-f]{4,8}\s+(\S+)\s*([^\n]*)',block,re.M);calls=collections.Counter(re.findall(r'R_XTENSA_ASM_EXPAND\s+(\S+)',block))
   funcs[name]={'bytes':s[name]['size'],'call_sites':dict(calls),'instruction_lines':len(instructions),'store_sites':[{'offset':at,'opcode':op,'operands':args.split('\t')[0]} for at,op,args in instructions if op in ['s16i','s32i','s32i.n']]}
   if name in ['.text.mesh_packet','.text.shade_pair']:
    lines=block.splitlines();calltarget='R_XTENSA_ASM_EXPAND\t.text.ayatsuri_shade_from_terms';idx=[i for i,l in enumerate(lines) if calltarget in l]
    for i in idx[-1:] if unit=='shade_pair' else idx[1::2]:snippets.append('\n'+variant+' '+unit+' second-color call and subsequent stores\n'+'\n'.join(lines[i-6:i+17]))
    if unit=='shade_pair':
     for i,l in enumerate(lines):
      if 'R_XTENSA_ASM_EXPAND\tmemcpy' in l:snippets.append('\ncontrol final external copy\n'+'\n'.join(lines[i-9:i+4]))
  summary[variant][unit]={'text_including_literal_rodata':totals[0],'data':totals[1],'bss':totals[2],'stack':stacks,'functions':funcs,'object_sha256':hashlib.sha256(obj.read_bytes()).hexdigest()}
  if unit=='shade_pair':
   rtl=(d/'shade_pair.reload').read_text();a=rtl.index(';; Function shade_pair ');b=rtl.find(';; Function ',a+4);ls=rtl[a:b if b>=0 else None].splitlines()
   matches=[i for i,l in enumerate(ls) if '%sfp' in l]
   for i in matches[-4:]:snippets.append('\n'+variant+' actual reload scalar preservation, not ABI argument slots\n'+'\n'.join(ls[max(0,i-2):i+3]))
summary['limitations']=['Static code-generation comparison only; no numerical target execution, cycles/FPS, total peak stack or hardware.','Instruction/store/call site counts include mutually exclusive paths; they are not dynamic counts.','su is one function frame. Arrays, ABI argument slots and explicit locals are distinct from %sfp scalar preservation.']
(ROOT/'results/analysis.json').write_text(json.dumps(summary,indent=2)+'\n');(ROOT/'results/selected-evidence.txt').write_text('\n'.join(snippets)+'\n')
print('FRESH_CONTROL_MATCH_AND_ANALYSIS_PASS')
for v in ['control','candidate-typed-stores']:
 for u in ['model','shade_pair']:
  x=summary[v][u];fn='.text.mesh_packet' if u=='model' else '.text.shade_pair';print(v,u,'text',x['text_including_literal_rodata'],'function_text',x['functions'][fn]['bytes'],'memcpy_sites',x['functions'][fn]['call_sites'].get('memcpy',0))
