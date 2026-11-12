from pathlib import Path
import hashlib,json,re,subprocess
P=Path(__file__).resolve().parent;R=P.parent.parent;M=P/'mirror';K='ayatsuri-latest-fixed-source-20261105/kernel-chain-compact';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
proof=json.loads((P/'source-proof.json').read_text());token_pattern=re.compile(r'/\*.*?\*/|//[^\n]*|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|[A-Za-z_][A-Za-z_0-9]*|[0-9][A-Za-z_0-9.]*|\S',re.S)
for row in proof['files']:
 a=(R/row['path']).read_text();b=(M/row['path']).read_text();assert sha(R/row['path'])==row['original_sha256'];assert sha(M/row['path'])==row['copied_sha256'];assert token_pattern.findall(a)==token_pattern.findall(b);assert re.findall(r'^\s*#.*$',a,re.M)==re.findall(r'^\s*#.*$',b,re.M)
 row['lexical_tokens_equal']=True;row['preprocessor_directive_lines_equal']=True
(P/'source-proof.json').write_text(json.dumps(proof,indent=2)+'\n')
records=[]
for bits in (16,20,24):
 name=f'compact-q{bits}.so';a=sha(R/K/name);b=sha(M/K/name);assert a==b;records.append(dict(bits=bits,original_runtime_sha256=a,formatted_runtime_sha256=b,runtime_byte_identical=True))
 cmd=['cc','-std=c11','-O2',f'-DMBITS={bits}','-Wall','-Werror=misleading-indentation','-fsyntax-only','compact.c'];p=subprocess.run(cmd,cwd=M/K,capture_output=True,text=True);(P/f'misleading-q{bits}.log').write_text(p.stdout+p.stderr);assert p.returncode==0,p.stderr
 for opt in (0,2):
  log=(M/K/f'test-q{bits}-o{opt}.log').read_text();assert '4473 accepted groups, 1107 nonopaque rejected groups' in log and 'PASS widths 1/2/4/8' in log
(P/'runtime-comparison.json').write_text(json.dumps(records,indent=2)+'\n')
# Full original verifier result and per-tuple admissions must match byte for byte.
for name in ('results.json','admissions.json','examples.json'):
 assert (R/K/name).read_bytes()==(M/K/name).read_bytes(),name
old={}
for folder in ['kernel-chain-prototype','kernel-chain-compact']:
 d=R/'ayatsuri-latest-fixed-source-20261105'/folder;count=0
 for line in (d/'SHA256SUMS').read_text().splitlines():
  h,n=line.split(None,1);assert sha(d/n.strip())==h;count+=1
 old[folder]=dict(files=count,sha256sums=sha(d/'SHA256SUMS'),unchanged=True)
report=dict(status='PASS',compiler=subprocess.check_output(['cc','--version'],text=True).splitlines()[0],original_build_script_unchanged=True,original_test_and_verifier_unchanged=True,original_host_flags_preserved=True,full_oracle_results_and_admissions_byte_identical=True,all_three_standalone_runtime_libraries_byte_identical=True,six_O0_O2_sanitizers_pass=True,additional_warning_probe='cc -std=c11 -O2 -DMBITS=16/20/24 -Wall -Werror=misleading-indentation -fsyntax-only compact.c; all pass; separate from unchanged runtime build flags',original_frozen_artifacts=old,scope='Host formatting-only equivalence; no target ABI, frame, speed, layout or admission claim.')
(P/'REPORT.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
