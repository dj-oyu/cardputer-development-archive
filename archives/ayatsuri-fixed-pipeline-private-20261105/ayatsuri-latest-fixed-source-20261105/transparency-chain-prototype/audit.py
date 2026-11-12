import pathlib,hashlib,json,re,subprocess
P=pathlib.Path(__file__).resolve().parent;R=P.parent.parent;sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old={}
for folder in ['kernel-chain-prototype','kernel-chain-compact','transparency-spec','background-spec']:
 d=P.parent/folder;checked=0
 for line in (d/'SHA256SUMS').read_text().splitlines():
  h,n=line.split(None,1);f=d/n.strip()
  if not f.exists():f=R/n.strip()
  assert sha(f)==h,(folder,n);checked+=1
 old[folder]=dict(files_verified=checked,manifest_sha256=sha(d/'SHA256SUMS'))
rows=[]
for bits in (16,20,24):
 sy=(P/f'symbols-q{bits}.txt').read_text();tables={}
 for name in ('agx_encoded','shape'):
  ls=[l for l in sy.splitlines() if l.split()[-1]==name];assert len(ls)==1;tables[name]=int(ls[0].split()[1],16)
 assert tables==dict(agx_encoded=445248,shape=25700)
 assert not any(l.split()[-1] in ('mc_eval','mc_prepare','kc_block','kcc_block','lut_shared','ref_cache') for l in sy.splitlines())
 floating=[]
 for line in (P/f'disassembly-q{bits}.txt').read_text().splitlines():
  m=re.search(r'\t([a-z][a-z0-9]+)\s',line)
  if m and (re.match(r'v?(?:add|sub|mul|div|sqrt|min|max|round|comi|ucomi)(?:ss|sd|ps|pd)$',m[1]) or m[1].startswith(('cvt','vcvt','fadd','fsub','fmul','fdiv','fsqrt','fld','fst'))):floating.append(line)
 assert not floating
 undef=subprocess.check_output(['nm','-D','-u',str(P/f'conditional-q{bits}.so')],text=True);assert not re.search(r'\b(?:malloc|free|sqrt|pow|log|exp|sin|cos|floor|ceil|round)(?:f|l)?(?:@|$)',undef,re.M)
 rows.append(dict(bits=bits,floating_arithmetic_instructions=floating,undefined_symbols=undef,profile_symbols=tables,no_material_or_lighting_or_geometry_code_in_runtime=True,own_stack=(P/f'conditional-q{bits}.su').read_text()))
(P/'runtime-audit.json').write_text(json.dumps(rows,indent=2)+'\n')
files=[P.parent/'transparency-spec'/x for x in ('SPEC.md','evidence.json','weight-results.json')]+[P.parent/'background-spec'/x for x in ('REPORT.md','source-audit.json')]+[P.parent/'kernel-chain-prototype/fixtures.json',P.parent/'kernel-chain-prototype/dependency-manifest.json',P.parent/'material-c-compact/material.c',P.parent/'material-c-compact/material.h',P.parent/'control-prototype/control.c']+[P.parent/f'material-c-compact/material-q{b}.so' for b in (16,20,24)]
olddeps=json.loads((P.parent/'kernel-chain-prototype/dependency-manifest.json').read_text())
manifest=dict(schema='conditional-supplied-branch-radiance-v1',compiler=subprocess.check_output(['cc','--version'],text=True).splitlines()[0],original_source_pins=olddeps['source_pins'],primary_source_revision='32f5fdce0a0a571a39198edf8d7b5d719bf59f2c',dependencies={str(p.relative_to(R)):sha(p) for p in files},runtime_output_dependencies=olddeps['dependencies_by_provenance']['existing_frozen_output_not_latest_source_view_transform'],frozen_preservation=old,contract='Source proves closure weights only. Reducer conditionally assumes complete UNWEIGHTED compatible-direction/transport branch RGB supplied by caller, not a source integrator identity.',runtime_material_connection=False,material_connection_scope='Offline test fixture preparation calls frozen integer control/material to obtain weights only; runtime consumes weights plus supplied branch RGB.',background_connection=False,branch_provenance='Both complete branch RGB arrays are declared synthetic arithmetic fixtures, not from latest lights, diffuse approximation, old KEEP/FLOOR/WORLD or a scene query.')
(P/'dependency-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n');print(json.dumps(old))
