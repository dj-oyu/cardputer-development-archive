from pathlib import Path
import re,subprocess,json,hashlib,struct,collections
ROOT=Path(__file__).resolve().parent
BIN=Path('/workspace/.setup/espressif/tools/xtensa-esp-elf/esp-15.2.0_20251204/xtensa-esp-elf/bin')
def elf_sections(p):
 b=p.read_bytes();assert b[:6]==b'\x7fELF\x01\x01';off=struct.unpack_from('<I',b,32)[0];stride,count,strings=struct.unpack_from('<HHH',b,46);rows=[struct.unpack_from('<10I',b,off+stride*i) for i in range(count)];table=rows[strings];names=b[table[4]:table[4]+table[5]];out={}
 for row in rows:
  name=names[row[0]:].split(b'\0',1)[0].decode();out[name]={'size':row[5],'flags':row[2],'data':b[row[4]:row[4]+row[5]] if row[1]!=8 else b''}
 return out
summary={};evidence=[]
for variant in ['baseline','candidate','candidate-bounded']:
 summary[variant]={}
 for unit in ['model','shade_pair']:
  d=ROOT/'results'/variant;obj=d/(unit+'.o');sizes=subprocess.check_output([str(BIN/'xtensa-esp32s3-elf-size'),str(obj)],text=True);(d/(unit+'.totals.txt')).write_text(sizes)
  text,data,bss=map(int,sizes.splitlines()[1].split()[:3]);sections=elf_sections(obj)
  stacks={}
  for line in (d/(unit+'.su')).read_text().splitlines():
   where,n,kind=line.split('\t');name=where.split(':')[-1];stacks[name]={'bytes':int(n),'kind':kind}
  asm=(d/(unit+'.asm.txt')).read_text();funcs={}
  for block in re.split('Disassembly of section ',asm)[1:]:
   name=block.split(':',1)[0]
   if not name.startswith('.text.'):continue
   calls=collections.Counter(re.findall(r'R_XTENSA_ASM_EXPAND\s+(\S+)',block));instructions=re.findall(r'^\s*[0-9a-f]+:\s+[0-9a-f]{4,8}\s+(\S+)',block,re.M)
   funcs[name]={'section_bytes':sections[name]['size'],'static_disassembly_instruction_lines':len(instructions),'call_sites':dict(calls)}
  summary[variant][unit]={'text_including_literals_rodata':text,'data':data,'bss':bss,'stack':stacks,'functions':funcs}
  if unit=='shade_pair':
   block=asm.split('Disassembly of section .text.shade_pair:')[1].split('Disassembly of section ')[0];lines=block.splitlines()
   for i,l in enumerate(lines):
    if any(x in l for x in ['R_XTENSA_ASM_EXPAND\tmemcpy','R_XTENSA_ASM_EXPAND\t.text.ayatsuri_shade_from_terms','s16i']):
     evidence.append('\n'+variant+' shade_pair assembly\n'+'\n'.join(lines[max(0,i-5):i+5]))
   rtl=(d/'shade_pair.reload').read_text();a=rtl.index(';; Function shade_pair ');z=rtl.find(';; Function ',a+4);ls=rtl[a:z if z>=0 else None].splitlines();matches=[i for i,l in enumerate(ls) if '%sfp' in l]
   for i in matches[-4:]:evidence.append('\n'+variant+' reload: scalar preserve/spill evidence\n'+'\n'.join(ls[max(0,i-2):i+3]))
   for i,l in enumerate(ls):
    if 'colors[' in l:evidence.append('\n'+variant+' reload: addressable colors array (not spill count)\n'+'\n'.join(ls[max(0,i-2):i+2]))
# Compare allocated section bytes rather than debug metadata or object file hashes.
allocated={}
for v in ['candidate','candidate-bounded']:
 sections=elf_sections(ROOT/'results'/v/'shade_pair.o');allocated[v]={n:x['data'] for n,x in sections.items() if x['flags']&2 and x['size']}
assert allocated['candidate']==allocated['candidate-bounded']
relocations={}
for v in ['candidate','candidate-bounded']:
 text=(ROOT/'results'/v/'shade_pair.relocations.txt').read_text();blocks=re.split(r'RELOCATION RECORDS FOR \[([^]]+)\]:\n',text);relocations[v]={blocks[k]:blocks[k+1].strip() for k in range(1,len(blocks),2) if blocks[k].startswith(('.text','.literal','.rodata'))}
assert relocations['candidate']==relocations['candidate-bounded']
summary['shade_pair_candidate_bounded_allocated_sections_equal']=True
summary['shade_pair_candidate_bounded_code_relocations_equal']=True
summary['notes']=['Counts are static call sites/instruction lines across all branch paths, not dynamic executions/cycles.','size text includes literal/rodata allocation; .text section sizes are separate.','su is each function frame, not total nested stack or runtime register-window spills.','No numerical execution or S3 hardware/cycle measurements occurred.']
(ROOT/'results/analysis.json').write_text(json.dumps(summary,indent=2)+'\n');(ROOT/'results/selected-evidence.txt').write_text('\n'.join(evidence)+'\n')
print('analysis saved; candidate/bounded shade_pair allocated bytes equal')
