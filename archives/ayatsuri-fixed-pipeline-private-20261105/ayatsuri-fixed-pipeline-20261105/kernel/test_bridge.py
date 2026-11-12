"""Compare actual AYFQ decoded normal/color integers to C encoding of same binary64."""
import sys
sys.dont_write_bytecode=True
import importlib.util, pathlib, math, random, subprocess, hashlib
root=pathlib.Path(__file__).resolve().parent
source=root.parent/'converter/compile_fixed.py'
spec=importlib.util.spec_from_file_location('converter_bridge',source)
c=importlib.util.module_from_spec(spec);spec.loader.exec_module(c)
rng=random.Random(20261105)
normal_x=[-1.,1.,0.]+[s*(i+.5)/32767 for s in (-1,1) for i in (0,1,2,16382,32766)]+[rng.uniform(-1,1) for _ in range(200)]
colors=[0.,1.]+[(i+.5)/32767 for i in (0,1,2,16382,32766)]+[rng.random() for _ in range(206)]
assert len(normal_x)==len(colors)
cases=[];normals=0;color_components=0
for x,color in zip(normal_x,colors):
 n=[x, math.sqrt(max(0,1-x*x)),0.]
 rgb=[color,1.-color,.5]
 report={'schema':'ayatsuri-fixed-static-input-v1','coordinate_system':'ayatsuri-native-metres','source_units':'metres','geometry_scale':1,'source_mode':'baked-static','parts':[{'positions':[[0,0,0],[1,0,0],[0,1,0]],'normals':[n,n,n],'triangles':[[0,1,2]],'materialId':'m','materialSidedness':'single'}],'materialTrace':[{'id':'m','scaledLinear':rgb}]}
 blob,_=c.compile_report(report);d=c.decode(blob)
 for a,b in zip(n,d['parts'][0]['normals'][0]):cases.append((a,32767.,b));normals+=1
 for a,b in zip(rgb,d['materials'][0]):cases.append((a,32767.,b));color_components+=1
# Additional exact representable binary64 half ties and full int16 endpoint range.
for x in [-32768.5,-32768.,-2.5,-1.5,-.5,0.,.5,1.5,2.5,32766.5,32767.,32767.49]:
 cases.append((x,1.,c.quantize(x,1.,-32768,32767)))
inputs=''.join(x.hex()+' '+s.hex()+'\n' for x,s,_ in cases)
for opt in (0,2):
 exe=root/f'bridge-O{opt}'
 subprocess.run(['gcc','-std=c11',f'-O{opt}','-g','-fsanitize=address,undefined','-fno-omit-frame-pointer',str(root/'bridge_encode.c'),'-lm','-o',str(exe)],check=True)
 import os
 r=subprocess.run([str(exe)],input=inputs,text=True,capture_output=True,check=True,env={**os.environ,'ASAN_OPTIONS':'detect_leaks=0'})
 rows=[tuple(map(int,line.split())) for line in r.stdout.splitlines()]
 assert len(rows)==len(cases)
 for i,((ok,q),(_,_,expected)) in enumerate(zip(rows,cases)):
  assert ok and q==expected,(opt,i,cases[i],ok,q)
 print(f'O{opt}: {normals} AYFQ normal components + {color_components} AYFQ linear color components + 12 exact scaled ties/endpoints: {len(cases)} matches, 0 mismatches')
print('binary64 transport: Python float.hex -> C scanf %la; floating preparation FE_TONEAREST')
print('converter_sha256',hashlib.sha256(source.read_bytes()).hexdigest())
