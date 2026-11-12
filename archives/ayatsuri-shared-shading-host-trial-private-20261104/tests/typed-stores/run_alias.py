#!/usr/bin/env python3
"""Run actual frozen pair harness with type-correct albedo/output aliases."""
import hashlib,json,os,platform,shlex,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
OUT=ROOT/'results/typed-stores-alias'
OUT.mkdir(parents=True,exist_ok=True)
PAIR=ROOT/'analysis/typed-stores/shade_pair.c'
TEST=Path(__file__).resolve().parent/'alias.c'
FLAGS=['-std=c11','-Wall','-Wextra','-Werror','-ffp-contract=off','-fexcess-precision=standard','-fno-fast-math','-fno-builtin-memcpy']
CONFIGS={'O0':['-O0'],'O2':['-O2'],'asan_ubsan_O0':['-O0','-g','-fsanitize=address,undefined','-fno-omit-frame-pointer','-no-pie'],'asan_ubsan_O2':['-O2','-g','-fsanitize=address,undefined','-fno-omit-frame-pointer','-no-pie']}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def identities():
    paths=[PAIR,TEST,Path(__file__).resolve()]
    for variant in ['candidate-bounded','candidate-typed-stores']:
        paths += [p for p in sorted((ROOT/variant/'main').rglob('*')) if p.is_file()]
    return {str(p.relative_to(ROOT)):sha(p) for p in paths}
def run(cmd,env=None):return subprocess.run(list(map(str,cmd)),capture_output=True,text=True,env=env)
report={'compiler':run(['cc','--version']).stdout.splitlines()[0],'host':platform.platform(),'flags':FLAGS,'leak_sanitizer':'Disabled explicitly because sandbox ptrace prevents LSan; no leak-testing claim.','identities_start':identities(),'configs':{}}
for name,opts in CONFIGS.items():
    dest=OUT/name;dest.mkdir(exist_ok=True)
    entry={'identities_start':identities(),'commands':[]};report['configs'][name]=entry
    objects=[]
    for sym,variant,typed in [('control','candidate-bounded',0),('candidate','candidate-typed-stores',1)]:
        obj=dest/(sym+'.o');objects.append(obj)
        cmd=['cc',*FLAGS,*opts,'-I'+str(ROOT/variant/'main'),'-DSHARED=1','-DTYPED_STORES='+str(typed),'-Dshade_pair='+sym+'_pair','-c',PAIR,'-o',obj]
        r=run(cmd);entry['commands'].append(shlex.join(list(map(str,cmd))))
        (dest/(sym+'-build.log')).write_text(r.stdout+r.stderr)
        if r.returncode:raise RuntimeError(f'{name} {sym} compile failed: {r.stderr}')
    cmd=['cc',*FLAGS,*opts,'-I'+str(ROOT/'candidate-bounded/main'),TEST,*objects,'-lm','-o',dest/'alias']
    r=run(cmd);entry['commands'].append(shlex.join(list(map(str,cmd))))
    (dest/'test-build.log').write_text(r.stdout+r.stderr)
    if r.returncode:raise RuntimeError(f'{name} test compile failed: {r.stderr}')
    entry['commands'].append('ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 '+str(dest/'alias'))
    r=run([dest/'alias'],{**os.environ,'ASAN_OPTIONS':'detect_leaks=0:halt_on_error=1','UBSAN_OPTIONS':'halt_on_error=1:print_stacktrace=1'})
    (dest/'run.log').write_text(r.stdout+r.stderr);entry['exit_code']=r.returncode
    entry['result']=json.loads(r.stdout) if r.stdout.strip() else {}
    entry['identities_end']=identities();entry['sources_stable']=entry['identities_start']==entry['identities_end']
    entry['passed']=r.returncode==0 and entry['result'].get('passed',False) and entry['sources_stable']
    entry['binary_sha256']=sha(dest/'alias')
    print(name,entry['passed'],flush=True)
    (OUT/'alias.json').write_text(json.dumps(report,indent=2)+'\n')
report['identities_end']=identities();report['sources_stable']=report['identities_start']==report['identities_end']
report['digests_identical']=len({x['result'].get('digest') for x in report['configs'].values()})==1
report['passed']=report['sources_stable'] and report['digests_identical'] and all(x['passed'] for x in report['configs'].values())
(OUT/'alias.json').write_text(json.dumps(report,indent=2)+'\n')
r=report['configs']['O2']['result']
(OUT/'REPORT.md').write_text(f'''# Typed color store overlap tests

Status: {'PASS' if report['passed'] else 'FAIL'}. Four configurations: O0, O2, ASan+UBSan O0, ASan+UBSan O2. Compiler: {report['compiler']}.

Each configuration: {r['cases']:,} synthetic shading inputs, {r['pair_calls']:,} calls, {r['exact_color_checks']:,} exact output checks, {r['canary_checks']:,} surrounding uint16 element checks. {r['output_2_not_4_aligned_calls']:,} calls use output aligned to 2 bytes but not 4. Digest: {r['digest']}; identical in all configurations.

The exact frozen analysis/typed-stores/shade_pair.c is compiled into separate control and candidate translation units with SHARED=1 and TYPED_STORES=0/1 respectively. Both original input colors are read by the oracle before mutation. Each resulting full 16-element array must match that immutable expectation. Arrays are declared uint16_t objects with 4-byte base alignment, never reinterpreted float/normal storage. No invalid uint16 pointer or new alias contract is used.

Five layouts, each at both uint16 index parities and for both implementations: output one element before albedo, identical pointers, one element after albedo, disjoint before, and disjoint after. The one-element-after case catches reading albedo[1] after overwriting it through out[0]. Every nonoutput element must remain unchanged, including input elements not overlapped by output. All 65,536 albedos occur in both input slots; other cases include 20,000 deterministic random inputs (xorshift seed 0x9e3779b9), direction extremes including FLT_TRUE_MIN/FLT_MAX, thickness boundaries, opposite directions and 27 independently rounded front/back SNORM half ties. Total cases comprise 65,536 RGB565, 180 extremes, 1,620 tie cases, and 20,000 random cases.

Strict FP: FE_TONEAREST checked, FP contraction off, no fast-math, standard excess precision. -fno-builtin-memcpy retained in every build. LSan is explicitly disabled because the sandbox ptrace restriction prevents its use; ASan and UBSan remain enabled. Source and harness identities verified before/after every run and overall. Exact commands, complete source hashes, binary hashes and counts are in alias.json; build/run logs in each configuration folder.

Reproduce from experiment root: `python3 tests/typed-stores/run_alias.py`.

Host semantic test only: no target runtime, cycle/performance, device, original assets, or general proof for all inputs. Product and old test files were not edited. This tests the actual isolated pair harness, not a fabricated variant; parent whole-evaluator tests separately cover product call sites.
''')
raise SystemExit(0 if report['passed'] else 1)
