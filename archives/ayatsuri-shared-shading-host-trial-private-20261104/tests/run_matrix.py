#!/usr/bin/env python3
"""Compare independent synthetic cases against fixed baseline/current source roots."""
import argparse, hashlib, json, os, pathlib, statistics, subprocess, sys
TEST=pathlib.Path(__file__).resolve().parent
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--baseline-dir',type=pathlib.Path,required=True)
parser.add_argument('--candidate-dir',type=pathlib.Path,required=True)
parser.add_argument('--output-dir',type=pathlib.Path,required=True)
parser.add_argument('--disable-leak-sanitizer',action='store_true',help='Explicitly disable LSan, leaving ASan and UBSan enabled.')
parser.add_argument('--leak-sanitizer-disabled-reason',default='explicit caller opt-out',help='Reason recorded when LSan is disabled.')
args=parser.parse_args()
OUT=args.output_dir.resolve();OUT.mkdir(parents=True,exist_ok=True)
FIX=OUT/'fixtures';FIX.mkdir(exist_ok=True)
VARIANTS={'baseline':args.baseline_dir.resolve(),'candidate':args.candidate_dir.resolve()}
SOURCES=['main/ayatsuri/ayatsuri_model.c','main/ayatsuri/ayatsuri_visibility.c','main/ayatsuri/compact_opaque.c','main/ui/kasane/ksn_procedural.c','main/ui/kasane/ksn_mesh_depth.c']
WRAPS=['-Wl,--wrap='+name for name in ['malloc','calloc','realloc','free']]
BASE=['-std=c11','-ffp-contract=off','-fexcess-precision=standard','-fno-fast-math']
SAN=['-g','-fsanitize=address,undefined','-fno-omit-frame-pointer','-no-pie']
CONFIGS={'O0':['-O0'],'O2':['-O2'],'asan_ubsan_O0':['-O0',*SAN],'asan_ubsan_O2':['-O2',*SAN],'m32':['-O2','-m32','-msse2','-mfpmath=sse']}
FIXTURES=['mixed','mesh_only']
def run(cmd,**kwargs):
    return subprocess.run([str(v) for v in cmd],capture_output=True,text=True,**kwargs)
def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
def identities():
    return {
        'sources':{v:{str(p.relative_to(root)):digest(p) for p in sorted((root/'main').rglob('*')) if p.is_file() and p.suffix in ('.c','.h','.inc')} for v,root in VARIANTS.items()},
        'harness':{name:digest(TEST/name) for name in ['evaluate_test.c','make_fixtures.py','run_matrix.py']},
        'fixtures':{name:digest(FIX/(name+'.aynm')) for name in FIXTURES}}
def save():
    (OUT/'matrix.json').write_text(json.dumps(report,indent=2)+'\n')
subprocess.run([sys.executable,str(TEST/'make_fixtures.py'),'--output-dir',str(FIX)],check=True)
report={'compiler':run(['cc','--version']).stdout.splitlines()[0],
        'scope':'Both variants retain the already-tested light-only optimization. Generic public-derived sources only. Exact host evaluation and real full production ksn_procedural plus ksn_mesh_depth painter raster. No Blender, QuickJS, firmware/device or FPS claim.',
        'leak_sanitizer':{'enabled':not args.disable_leak_sanitizer,'disabled_reason':args.leak_sanitizer_disabled_reason if args.disable_leak_sanitizer else None},
        'identities_start':identities(),'configs':{}}
# A missing multilib environment is distinct from an implementation build failure.
probe=OUT/'m32_probe.c';probe.write_text('#include <stdio.h>\n#include <stdlib.h>\n#include <stdint.h>\n#include <math.h>\nint main(void){volatile double x=2;return sqrt(x)>0?0:1;}\n')
probe_cmd=['cc',*BASE,*CONFIGS['m32'],probe,'-lm','-o',OUT/'m32_probe']
r=run(probe_cmd);(OUT/'m32_probe.log').write_text(' '.join(map(str,probe_cmd))+'\n'+r.stdout+r.stderr)
report['m32_toolchain_probe']={'available':r.returncode==0,'exit_code':r.returncode}
for cfg,opts in CONFIGS.items():
    folder=OUT/cfg;folder.mkdir(exist_ok=True)
    result={'flags':BASE+opts,'builds':{},'fixtures':{},'identities_start':identities()};report['configs'][cfg]=result
    if cfg=='m32' and not report['m32_toolchain_probe']['available']:
        result.update(status='not_run',reason='Separate 32-bit libc/toolchain compile/link probe failed. See m32_probe.log.');save();continue
    result['status']='running'
    for variant,src in VARIANTS.items():
        cmd=['cc',*BASE,'-ffunction-sections','-fdata-sections',*opts,'-I'+str(src/'main'),'-DCANDIDATE=1',TEST/'evaluate_test.c',*[src/p for p in SOURCES],'-Wl,--gc-sections',*WRAPS,'-lm','-o',folder/variant]
        r=run(cmd);(folder/(variant+'.build.log')).write_text(' '.join(map(str,cmd))+'\n'+r.stdout+r.stderr)
        result['builds'][variant]={'status':'passed' if r.returncode==0 else 'failed','exit_code':r.returncode}
    if all(b['status']=='passed' for b in result['builds'].values()):
        for fixture in FIXTURES:
            pair={};result['fixtures'][fixture]=pair
            for variant in VARIANTS:
                binary=folder/(variant+'_'+fixture+'.bin');log=folder/(variant+'_'+fixture+'.tsv')
                r=run([folder/variant,FIX/(fixture+'.aynm'),binary,log],env={**os.environ,'ASAN_OPTIONS':('detect_leaks=0' if args.disable_leak_sanitizer else 'detect_leaks=1')+':halt_on_error=1','UBSAN_OPTIONS':'halt_on_error=1:print_stacktrace=1'})
                (folder/(variant+'_'+fixture+'.run.log')).write_text(r.stdout+r.stderr)
                pair[variant]={'status':'passed' if r.returncode==0 else 'failed','exit_code':r.returncode}
                if r.returncode==0:
                    pair[variant].update(json.loads(r.stdout));pair[variant]['sha256']=digest(binary)
            pair['exact_match']=False
            if all(pair[v]['status']=='passed' for v in VARIANTS):
                a=(folder/('baseline_'+fixture+'.bin')).read_bytes();b=(folder/('candidate_'+fixture+'.bin')).read_bytes();pair['exact_match']=a==b
                if a!=b:pair['first_mismatch_offset']=next((j for j,(x,y) in enumerate(zip(a,b)) if x!=y),min(len(a),len(b)))
        if cfg=='O2':
            result['host_timings']={};result['timing_order']=[]
            for fixture in FIXTURES:
                d={'baseline':[],'candidate':[]};result['host_timings'][fixture]=d
                for round_id in range(7):
                    order=['baseline','candidate'] if round_id%2==0 else ['candidate','baseline']
                    result['timing_order'].append({'fixture':fixture,'round':round_id,'order':order})
                    for variant in order:
                        r=run([folder/variant,FIX/(fixture+'.aynm'),'/dev/null','/dev/null','bench'])
                        measured=json.loads(r.stdout) if r.returncode==0 else {'error':r.stderr,'exit_code':r.returncode}
                        measured['round']=round_id;d[variant].append(measured)
                d['summary']={}
                if all('light_us' in m and 'full_us' in m for v in VARIANTS for m in d[v]):
                    for key in ['light_us','full_us']:
                        a=[m[key] for m in d['baseline']];b=[m[key] for m in d['candidate']];ratios=[y/x for x,y in zip(a,b)]
                        d['summary'][key]={'baseline_median':statistics.median(a),'candidate_median':statistics.median(b),'paired_ratio_median':statistics.median(ratios),'paired_ratio_min':min(ratios),'paired_ratio_max':max(ratios)}
        for variant,src in VARIANTS.items():
            obj=folder/(variant+'_model.o')
            cmd=['cc',*BASE,*opts,'-fstack-usage','-I'+str(src/'main'),'-c',src/SOURCES[0],'-o',obj]
            r=run(cmd);(folder/(variant+'.object.log')).write_text(' '.join(map(str,cmd))+'\n'+r.stdout+r.stderr)
            result['builds'][variant]['metrics_status']='passed' if r.returncode==0 else 'failed'
            if r.returncode==0:
                (folder/(variant+'.size.log')).write_text(run(['size',obj]).stdout+'\n'+run(['size','-A',obj]).stdout)
    result['identities_end']=identities();result['sources_stable']=result['identities_start']==result['identities_end']
    result['status']='passed' if result['sources_stable'] and len(result['builds'])==2 and all(b['status']=='passed' for b in result['builds'].values()) and set(result['fixtures'])==set(FIXTURES) and all(f['exact_match'] for f in result['fixtures'].values()) else 'failed'
    save()
report['identities_end']=identities();report['sources_stable']=report['identities_start']==report['identities_end']
required=[name for name in CONFIGS if name!='m32' or report['m32_toolchain_probe']['available']]
report['passed']=report['sources_stable'] and all(report['configs'][name]['status']=='passed' for name in required)
save();print(json.dumps(report,indent=2));sys.exit(0 if report['passed'] else 1)
