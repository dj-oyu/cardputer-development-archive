import pathlib,hashlib,json,subprocess,re
P=pathlib.Path(__file__).resolve().parent;A=P.parent/'kernel-chain-prototype';R=P.parent.parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
# Verify every frozen audit file, never rewrite that directory.
checked=0
for line in (A/'SHA256SUMS').read_text().splitlines():
 h,n=line.split(None,1);assert sha(A/n.strip())==h,n;checked+=1
rows=[]
for bits in (16,20,24):
 symbols=(P/f'symbols-q{bits}.txt').read_text();tables={}
 for name in ('lut_shared','agx_encoded','shape'):
  ls=[l for l in symbols.splitlines() if l.split()[-1]==name];assert len(ls)==1,(bits,name,ls);tables[name]=int(ls[0].split()[1],16)
 assert tables==dict(lut_shared=3084,agx_encoded=445248,shape=25700)
 assert not any(l.split()[-1] in ('kc_block','ref_cache','ref_light') for l in symbols.splitlines())
 # No data objects are introduced by the compact chain object itself.
 own_symbols=subprocess.check_output(['nm','-S',str(P/f'compact-q{bits}.o')],text=True)
 data=[l for l in own_symbols.splitlines() if len(l.split())>=4 and l.split()[-2] in 'rRdDbB'];assert not data,data
 suspicious=[]
 for line in (P/f'disassembly-q{bits}.txt').read_text().splitlines():
  m=re.search(r'\t([a-z][a-z0-9]+)\s',line)
  if m and (re.match(r'v?(?:add|sub|mul|div|sqrt|min|max|round|comi|ucomi)(?:ss|sd|ps|pd)$',m[1]) or m[1].startswith(('cvt','vcvt','fadd','fsub','fmul','fdiv','fsqrt','fld','fst'))):suspicious.append(line)
 assert not suspicious
 undefined=subprocess.check_output(['nm','-D','-u',str(P/f'compact-q{bits}.so')],text=True)
 assert not re.search(r'\b(?:malloc|free|sqrt|pow|log|exp|sin|cos|floor|ceil|round)(?:f|l)?(?:@|$)',undefined,re.M)
 rows.append(dict(bits=bits,table_symbols=tables,no_new_chain_readonly_data=True,no_audit_or_test_helpers_in_runtime=True,no_float_arithmetic=True,no_libm_or_heap_dependency=True,undefined_symbols=undefined,host_own_stack=(P/f'compact-q{bits}.su').read_text()))
(P/'storage-runtime-audit.json').write_text(json.dumps(rows,indent=2)+'\n')
parent=json.loads((A/'dependency-manifest.json').read_text());manifest=dict(schema='final-only-storage-compaction-v1',compiler=subprocess.check_output(['cc','--version'],text=True).splitlines()[0],frozen_audit_files_verified=checked,frozen_audit_sha256sums=sha(A/'SHA256SUMS'),storage_transformation=sha(P/'storage-transform-proof.json'),source_and_kernel_dependencies=parent,additional_frozen_dependencies={str(p.relative_to(R)):sha(p) for p in [A/'chain.c',A/'chain.h',A/'reference.c',A/'fixtures.json',A/'fixtures.inc',A/'verify.py',A/'test_native.c',A/'results.json']},changes='Separate API with aa_result-only output. Identical ordered arithmetic/error predicates, independent final staging and reused one-slot scratch. No renderer/CI/source changes.')
(P/'dependency-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print('All',checked,'frozen audit files unchanged; selected-Q tables occur once, compact object adds no static data; no FP/libm/heap runtime.')
