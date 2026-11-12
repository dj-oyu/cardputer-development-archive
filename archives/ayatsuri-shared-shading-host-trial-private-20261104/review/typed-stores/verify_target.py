from pathlib import Path
import struct,re,json,hashlib,shlex,collections
R=Path(__file__).resolve().parents[2];T=R/'typed-target-evidence'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def elf(p):
 b=p.read_bytes();assert b[:6]==b'\x7fELF\x01\x01' and struct.unpack_from('<H',b,18)[0]==94
 off=struct.unpack_from('<I',b,32)[0];stride,num,ni=struct.unpack_from('<HHH',b,46)
 rows=[struct.unpack_from('<10I',b,off+i*stride) for i in range(num)]
 def data(x):return b[x[4]:x[4]+x[5]] if x[1]!=8 else b''
 def string(b,n):return b[n:].split(b'\0',1)[0].decode()
 names=data(rows[ni]);sn=[string(names,x[0]) for x in rows];sec={n:(x,data(x))for n,x in zip(sn,rows)};rels={}
 for x in rows:
  if x[1]!=4:continue
  sym=rows[x[6]];st=data(rows[sym[6]]);syms=[]
  for at in range(0,sym[5],sym[9]):
   name,val,size,info,other,idx=struct.unpack_from('<IIIBBH',data(sym),at);syms.append((string(st,name) or (sn[idx] if idx<num else ''),val))
  rr=[]
  for at in range(0,x[5],x[9]):
   ofs,info,add=struct.unpack_from('<IIi',data(x),at);name,val=syms[info>>8];rr.append((ofs,info&255,name,val,add))
  rels[sn[x[7]]]=rr
 return sec,rels
m=json.loads((T/'MANIFEST.json').read_text())
for n,v in m.items():p=T/n;assert p.stat().st_size==v['bytes'] and sha(p)==v['sha256']
for a,b in [('control','candidate-bounded'),('candidate-typed-stores','candidate-typed-stores')]:
 for p in (T/a/'main').rglob('*'):
  if p.is_file():assert p.read_bytes()==(R/b/'main'/p.relative_to(T/a/'main')).read_bytes()
assert (T/'shade_pair.c').read_bytes()==(R/'analysis/typed-stores/shade_pair.c').read_bytes()
result={'manifest_entries_verified':len(m),'objects':{},'fresh_control_matches_previous':True};total=0
for v in ['control','candidate-typed-stores']:
 for u in ['model','shade_pair']:
  p=T/'results'/v/(u+'.o');sec,rels=elf(p);ins=0;calls=0
  asm=(p.parent/(u+'.asm.txt')).read_text()
  for block in re.split(r'Disassembly of section ',asm)[1:]:
   name=block.split(':',1)[0]
   if not name.startswith('.text'):continue
   raw=sec[name][1]
   for ofs,h in re.findall(r'^\s*([0-9a-f]+):\s+([0-9a-f]{4,8})\s+\S+',block,re.M):
    bs=bytes.fromhex(h)[::-1];ofs=int(ofs,16);assert raw[ofs:ofs+len(bs)]==bs,(v,u,name,ofs);ins+=1
   displayed={(int(o,16),n) for o,n in re.findall(r'([0-9a-f]+): R_XTENSA_ASM_EXPAND\s+(\S+)',block)}
   actual={(o,n)for o,t,n,val,a in rels.get(name,[])if t==11};assert displayed==actual;calls+=len(actual)
  if v=='control':
   for old in [R/'target-evidence/results/candidate-bounded'/(u+'.o'),T/'results/previous-bounded-reference'/(u+'.o')]:
    os,orr=elf(old);alloc=lambda s:{n:d for n,(x,d)in s.items()if x[2]&2 and x[5]};assert alloc(sec)==alloc(os)
    code=lambda rr:{n:x for n,x in rr.items()if n.startswith(('.text','.literal','.rodata'))};assert code(rels)==code(orr)
  result['objects'][v+'/'+u]={'sha256':sha(p),'displayed_instruction_bytes_verified':ins,'call_annotations_verified':calls,'text_class':sum(x[5]for x,d in sec.values()if x[2]&2 and not x[2]&1),'memcpy_sites':{n:sum(t==11 and s=='memcpy' for o,t,s,val,a in rr)for n,rr in rels.items()if n in ['.text.mesh_packet','.text.shade_pair']}}
  total+=ins
metadata=json.loads((T/'results/build-metadata.json').read_text());cmds=json.loads((T/'results/commands.json').read_text());orig=shlex.split(metadata['original']['command']);source_root='/workspace/cardputer-pr117-mesh-fw-20261103';remote='/workspace/ayatsuri-s3-typed-stores-20261104'
for c in cmds:
 assert c['exit_code']==0 and shlex.split(c['shell_command'])==c['argv'];expected=[];skip=False
 for arg in orig:
  if skip:skip=False;continue
  if arg in ['-o','-MF','-MT','-MQ']:skip=True;continue
  if arg in ['-c',metadata['original']['file'],'-MD','-MMD','-MP']:continue
  if arg.startswith('-I'+source_root+'/main'):arg='-I'+remote+'/'+c['variant']+arg[len('-I'+source_root):]
  expected.append(arg)
 assert c['argv'][:len(expected)]==expected
 assert [a for a in c['argv'] if re.match(r'^-O',a)][-1]=='-O2'
 for u,x in metadata['variants'][c['variant']].items():
  p=T/'results'/c['variant']/(u+'.o');assert sha(p)==x['object_sha256'] and p.stat().st_size==x['object_bytes']
for name,x in metadata['response_files'].items():
 if 'content'in x:assert hashlib.sha256(x['content'].encode()).hexdigest()==x['sha256']
result['total_instruction_encodings_verified']=total;result['commands_verified']=len(cmds)
(R/'review/typed-stores/target-verification.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
