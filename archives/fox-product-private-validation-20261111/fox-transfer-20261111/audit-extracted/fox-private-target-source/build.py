from pathlib import Path
import argparse,json,subprocess,tempfile,os
R=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('--mode',choices=['test','probe'],default='test');p.add_argument('--compile-only',action='store_true');p.add_argument('--output');a=p.parse_args();d=json.loads((R/'dependencies.json').read_text())
out=Path(a.output).resolve() if a.output else Path(tempfile.mkdtemp(prefix='fox-private-check-'));out.mkdir(parents=True,exist_ok=True)
sources=d['sources'].copy()
if a.mode=='test':sources[0]='fox-target-handoff-private-20261107/harness/test_harness.c'
cmd=[os.environ.get('CC','cc'),'-std=gnu11','-O2','-Wall','-Wextra','-Werror','-ffp-contract=off','-fno-fast-math','-fstack-usage','-ffunction-sections','-fdata-sections',*['-I'+str(R/i) for i in d['includes']],*[str(R/s) for s in sources],'-lm','-Wl,--gc-sections','-Wl,-Map='+str(out/'link.map'),'-o',str(out/'run')]
(out/'command.json').write_text(json.dumps(cmd));subprocess.run(cmd,cwd=out,check=True)
if not a.compile_only:subprocess.run([str(out/'run')],check=True)
print('BUILD_OUTPUT',out)
