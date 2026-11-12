import pathlib,struct,zlib,numpy as np,json,subprocess,ctypes,hashlib
P=pathlib.Path(__file__).resolve().parent
f=json.loads((P/'frozen.json').read_text());N=f['size']
def png(p):
 b=p.read_bytes();pos=8;raw=b''
 while pos<len(b):
  n=struct.unpack('>I',b[pos:pos+4])[0];t=b[pos+4:pos+8];d=b[pos+8:pos+8+n];pos+=12+n
  if t==b'IHDR':w,h,depth,typ,_,_,inter=struct.unpack('>IIBBBBB',d);assert depth==16 and typ==2 and inter==0
  if t==b'IDAT':raw+=d
 raw=zlib.decompress(raw);rows=[];prior=np.zeros(w*6,np.uint8);stride=w*6
 for y in range(h):
  ft=raw[y*(stride+1)];r=np.frombuffer(raw[y*(stride+1)+1:(y+1)*(stride+1)],np.uint8).copy()
  for x in range(stride):
   a=int(r[x-6]) if x>=6 else 0;b=int(prior[x]);c=int(prior[x-6]) if x>=6 else 0
   if ft==1:p=a
   elif ft==2:p=b
   elif ft==3:p=(a+b)//2
   elif ft==4:
    q=a+b-c;ds=[abs(q-a),abs(q-b),abs(q-c)];p=[a,b,c][ds.index(min(ds))]
   else:p=0
   r[x]=(int(r[x])+p)&255
  rows.append(r.copy());prior=r
 return np.stack(rows).reshape(h,w,6).view('>u2').reshape(h,w,3)[::-1].reshape(-1,3).astype(np.float32)/65535
lut=png(P/'lut.png')[:N**3];oracle=png(P/'oracle.png')[:len(np.load(P/'samples.npy'))];np.save(P/'oracle.npy',oracle)
with (P/'agx_lut.inc').open('w') as o:
 o.write('#define AGX_N %d\n#define AGX_LO %.17g\n#define AGX_HI %.17g\n#define AGX_LOG_RANGE %.17g\nstatic const float agx_lut[%d]={\n'%(N,f['lo'],f['hi'],np.log1p(f['hi']/f['lo']),N**3*3))
 for row in lut:o.write(','.join('%.9gf'%v if v not in (0,1) else ('0.0f' if v==0 else '1.0f') for v in row)+',\n')
 o.write('};\n')
subprocess.run(['cc','-std=c99','-O2','-shared','-fPIC',str(P/'agx_profile.c'),'-lm','-o',str(P/'libagx.so')],check=True)
subprocess.run(['cc','-std=c99','-O2',str(P/'agx_profile.c'),str(P/'cli.c'),'-lm','-o',str(P/'agx_cli')],check=True)
samples=np.load(P/'samples.npy');actual=np.frombuffer(subprocess.run([str(P/'agx_cli')],input=samples.tobytes(),stdout=subprocess.PIPE,check=True).stdout,np.float32).reshape(-1,3)
lib=ctypes.CDLL(str(P/'libagx.so'));fun=lib.agx_profile_eval;ptr=ctypes.POINTER(ctypes.c_float);fun.argtypes=[ptr,ptr]
statuses=[]
for row in samples:
 out=np.zeros(3,np.float32);statuses.append(fun(row.ctypes.data_as(ptr),out.ctypes.data_as(ptr)))
invalid=[]
for val in [-1,-1e-30,float('nan'),float('inf'),-float('inf')]:
 for c in range(3):
  a=np.zeros(3,np.float32);a[c]=val;o=np.array([.123,.456,.789],np.float32);before=o.copy();s=fun(a.ctypes.data_as(ptr),o.ctypes.data_as(ptr));invalid.append(s==2 and np.array_equal(o,before))
def stats(a,b):
 e=np.abs(a-b)*[31,63,31];return dict(rmse=np.sqrt(np.mean(e*e,axis=0)).tolist(),p99=np.percentile(e,99,axis=0).tolist(),max=e.max(axis=0).tolist())
def passed(s):return max(s['rmse'])<=.5 and max(s['p99'])<=1 and max(s['max'])<=2
report={};off=0
for name,n in json.loads((P/'groups.json').read_text()).items():
 s=stats(actual[off:off+n],oracle[off:off+n]);report[name]=dict(count=n,clamped=int(np.count_nonzero(np.array(statuses[off:off+n])==1)),metrics=s,pass_gate=passed(s));off+=n
s=stats(actual,oracle);report['all_accepted']=dict(count=len(samples),metrics=s,pass_gate=passed(s));report['invalid_atomic']=all(invalid)
q=np.array([31,63,31]);e=np.abs(np.floor(actual*q+.5)-np.floor(oracle*q+.5));report['quantized_565_code_difference']=dict(rmse=np.sqrt((e*e).mean(0)).tolist(),p99=np.percentile(e,99,axis=0).tolist(),max=e.max(0).tolist())
report['lut_readonly_bytes']=lut.nbytes;(P/'validation.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))
