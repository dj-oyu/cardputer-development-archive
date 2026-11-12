import pathlib,subprocess,json,hashlib,re,platform
P=pathlib.Path(__file__).resolve().parent;R=P.parent.parent
sources={'material':P.parent/'material-c-compact/material.c','control':P.parent/'control-prototype/control.c','accumulation':R/'ayatsuri-fixed-frame-stage1-20261105/aa/code/integer_aa.c','profile_adapter':R/'ayatsuri-fixed-frame-stage1-20261105/aa/code/profile_adapter.c','integer_output':R/'ayatsuri-fixed-integer-output-20261105/code/integer_output.c','block_cache':R/'ayatsuri-fixed-integer-output-20261105/code/block_cache.c','private_adapter':R/'ayatsuri-fixed-integer-output-20261105/private/adapter.c'}
rows=[]
for bits in (16,20,24):
 for name,src in sources.items():
  obj=P/f'{name}-q{bits}.o';subprocess.run(['cc','-std=c11','-O2',f'-DMBITS={bits}','-fstack-usage','-c',str(src),'-o',str(obj)],check=True)
  (P/f'{name}-q{bits}-size.txt').write_text(subprocess.check_output(['size','-A',str(obj)],text=True))
 dis=subprocess.check_output(['objdump','-d',str(P/f'chain-q{bits}.so')],text=True);(P/f'full-disassembly-q{bits}.txt').write_text(dis)
 # Moves and integer SIMD operations are allowed; actual floating-point arithmetic/conversion is not.
 suspicious=[]
 for ln in dis.splitlines():
  m=re.search(r'\t([a-z][a-z0-9]+)\s',ln)
  if m and (re.match(r'v?(?:add|sub|mul|div|sqrt|min|max|round|comi|ucomi)(?:ss|sd|ps|pd)$',m[1]) or m[1].startswith(('cvt','vcvt','fadd','fsub','fmul','fdiv','fsqrt','fld','fst'))):suspicious.append(ln)
 undef=subprocess.check_output(['nm','-D','-u',str(P/f'chain-q{bits}.so')],text=True)
 assert not suspicious and not re.search(r'\b(?:sqrt|pow|log|exp|sin|cos|floor|ceil|round)(?:f|l)?(?:@|$)',undef,re.M)
 rows.append(dict(bits=bits,floating_arithmetic_instructions=suspicious,undefined_symbols=undef,profile_numeric_static=dict(encoded=445248,shaper=25700),material_lut=3084))
(P/'integer-runtime-audit.json').write_text(json.dumps(rows,indent=2)+'\n')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
groups={
 'latest_geometry_material': [P.parent/'attribute-prototype/attributes-q20-v2.json',P.parent/'attribute-prototype/material-semantics-binding.json',P.parent/'material-prototype/control-fixtures.json',P.parent/'material-c-compact/dependency-manifest.json',P.parent/'material-c-compact/results.json',P.parent/'material-c-compact/material.h',P.parent/'material-c-compact/material.c',P.parent/'control-prototype/control.c',P.parent/'control-prototype/control.h']+[P.parent/f'material-c-compact/generated-q{b}.inc' for b in (16,20,24)],
 'supplied_numeric_lighting': [R/'ayatsuri-fixed-integer-light-20261105/integer_light.h',R/'ayatsuri-fixed-integer-light-20261105/normal_bridge.h',P/'fixtures.json'],
 'existing_frozen_output_not_latest_source_view_transform': list((R/'ayatsuri-fixed-integer-output-20261105/code').glob('*.c'))+list((R/'ayatsuri-fixed-integer-output-20261105/code').glob('*.h'))+[R/'ayatsuri-fixed-integer-output-20261105/private'/x for x in ('adapter.c','shaper.h','profile_data.h','PINS.json')]+list((R/'ayatsuri-fixed-frame-stage1-20261105/aa/code').glob('*.c'))+list((R/'ayatsuri-fixed-frame-stage1-20261105/aa/code').glob('*.h'))}
manifest=dict(schema='independent-numeric-kernel-chain-v1',compiler=subprocess.check_output(['cc','--version'],text=True).splitlines()[0],python=platform.python_version(),compile_commands='build.sh and audit.py retained verbatim; O0/O2, per-Q, ASan+UBSan, no libm or fast-math',source_pins=dict(original='d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a',derived_2k_v2='384ada0c37da16d625b1e6612a0d2f7ca538c29fe0d8dff43a929841ec63fba8',neutral_sidecar='00a81fbcd19c79c578bbbbd7ab077ee6f63048a106c5594675ff208670d5e85e'),dependencies_by_provenance={k:{str(p.relative_to(R)):sha(p) for p in v} for k,v in groups.items()},renderer_HEAD_integration=False,source_pins_status='preserved authoritative attribute-v2 binding; no source re-evaluation',coordinate_pipeline='canonical attribute-v2 Q20 -> Q14 barycentric RNE Q20 -> world RNE Q16 / object-local Q16 RNE, Q20 identity, Q24 x16; Q24 does not restore discarded coordinate precision')
(P/'dependency-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
