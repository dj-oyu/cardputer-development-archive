#!/usr/bin/env python3
"""Static x86 disassembly indicators, not dynamic cycles or spill counts."""
import json,re
from pathlib import Path
root=Path(__file__).resolve().parent
for p in root.glob('*.asm'):
    current=None;d={}
    for line in p.read_text().splitlines():
        f=re.match(r'^[0-9a-f]+ <([^>]+)>:',line)
        if f:
            current=f[1];d[current]={'instructions':0,'rsp_memory_operand_instructions':0,'push_pop_instructions':0,'call_instructions':[]}
        # objdump tab fields separate instruction bytes from the mnemonic.
        fields=line.split('\t')
        if len(fields)<3 or current is None or not re.match(r'^\s*[0-9a-f]+:$',fields[0]):continue
        instruction=fields[2].strip().split(None,1)
        if not instruction:continue
        op=instruction[0];args=instruction[1] if len(instruction)>1 else ''
        entry=d[current];entry['instructions']+=1
        if re.search(r'\([^)]*%rsp[^)]*\)',args) and not op.startswith(('lea','nop')):entry['rsp_memory_operand_instructions']+=1
        if op.startswith(('push','pop')):entry['push_pop_instructions']+=1
        if op.startswith('call'):entry['call_instructions'].append(line.strip())
    out={'interpretation':'Static instruction-site counts across whole functions, including branches. %rbp is not assumed to be a frame pointer. %rsp operands may be deliberate arrays, arguments or spills; these counts alone cannot distinguish them. Does not count implicit call/return memory operations as explicit rsp operands. Not dynamic frequency or cycles.','functions':d}
    p.with_suffix('.static-counts.json').write_text(json.dumps(out,indent=2)+'\n')
