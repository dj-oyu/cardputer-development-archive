from pathlib import Path
import hashlib,json,re
p=Path(__file__).resolve().parent;r=p.parent
results={'host':{},'qemu':{},'limits':['Mock transport only, not production board or DMA','Synchronous QuickJS bridge only; public motion and AYNM unchanged','ASan+UBSan passes with leak detection disabled; LSan cannot run under this environment ptrace','Failure preserves latest hash/JS state; already submitted pixels are not undone']}
for t in range(0,1001,125):
 a=(p/f'motion-{t}ms.rgb565').read_bytes();b=(r/f'fox-eye-runtime-qemu-20261111/motion/captures/motion-{t}ms.rgb565').read_bytes();assert a==b;results['host'][t]={'bytes':len(a),'reference_equal':True,'sha256':hashlib.sha256(a).hexdigest()}
log=(p/'qemu/run-ready/uart.log').read_text();assert 'FOX_EYE_QEMU_DONE composed_frames=9' in log
rows={i:{} for i in range(9)}
for i,y,data in re.findall(r'COMPOSED_ROW sample=(\d+) y=(\d+) ([0-9a-f]+)',log):assert len(data)==960;assert int(y) not in rows[int(i)];rows[int(i)][int(y)]=bytes.fromhex(data)
for i in range(9):
 assert set(rows[i])==set(range(135));a=b''.join(rows[i][y] for y in range(135));b=(p/f'motion-{i*125}ms.rgb565').read_bytes();assert a==b;(p/f'qemu-motion-{i*125}ms.rgb565').write_bytes(a);results['qemu'][i*125]={'bytes':len(a),'host_and_reference_equal':True,'sha256':hashlib.sha256(a).hexdigest()}
results['inputs']={}
for x in json.loads((p/'private/command-o2.json').read_text()):
 if x.endswith('.c'):results['inputs'][x]=hashlib.sha256(Path(x).read_bytes()).hexdigest()
for x in ['generic/ayatsuri_controls.js','private/fox_controls.js','private/scenario.js']:
 results['inputs'][x]=hashlib.sha256((p/x).read_bytes()).hexdigest()
results['inputs']['public_ayatsuri_motion.js']=hashlib.sha256((r/'qemu-render-20261111/apps/lib/ayatsuri_motion.js').read_bytes()).hexdigest()
(p/'validation.json').write_text(json.dumps(results,indent=2)+'\n');print('PASS 9 host + 9 QEMU frames byte-identical to prior reference, 64800 bytes each')
