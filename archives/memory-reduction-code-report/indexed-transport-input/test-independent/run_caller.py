from pathlib import Path
import subprocess,os,hashlib,json
root=Path(__file__).resolve().parents[1];d=root/'test-independent';source=root/'harness/native_render_row.c'
s=source.read_text();start=s.index('  bounce_vertex *attributes=transportmode?calloc(');end=s.index('\n  double *xyz=',start);block=s[start:end]+'\n';inc=d/'caller_alloc_exact.inc';inc.write_text(block)
rows=[]
for mode,flags in [('O2',[]),('O2-asan-ubsan',['-fsanitize=address,undefined','-fno-omit-frame-pointer'])]:
 cmd=['cc','-std=c11','-O2','-g','-Wall','-Wextra','-Werror',*flags,str(d/'caller_alloc.c'),'-o',str(d/('caller-'+mode))];subprocess.run(cmd,check=True);p=subprocess.run([cmd[-1]],capture_output=True,text=True,env={**os.environ,'ASAN_OPTIONS':'detect_leaks=0:halt_on_error=1','UBSAN_OPTIONS':'halt_on_error=1'});(d/('caller-'+mode+'.log')).write_text(p.stdout+p.stderr);p.check_returncode();print(mode,p.stdout.strip());rows.append(dict(mode=mode,command=cmd,output=p.stdout.strip(),exit=p.returncode))
(d/'CALLER_RESULTS.json').write_text(json.dumps(dict(status='PASS',scope='Exact source-extracted allocation statements in isolated synthetic wrapper; not full main execution or proof of native output rollback. No helper exposed. LSan disabled.',results=rows,sha256={str(p.relative_to(root)):hashlib.sha256(p.read_bytes()).hexdigest() for p in [source,inc,d/'caller_alloc.c',Path(__file__)]}),indent=2)+'\n')
