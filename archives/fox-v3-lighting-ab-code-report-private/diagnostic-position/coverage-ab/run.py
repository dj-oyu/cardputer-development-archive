from pathlib import Path
import subprocess,json,os,hashlib,ctypes,time,resource
import numpy as np
D=Path(__file__).resolve().parent;R=D.parent;S=R.parent/'fox-v3-lighting-ab/four-both-002';O=R/'observer';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
# Only adapter changes: append a projected-triangle observation before submission.
s=(O/'native_render.c').read_text();s=s.replace('for(unsigned at=0;at<count;at++){','char trianglepath[4096];snprintf(trianglepath,sizeof trianglepath,"%s.triangles.f32",argv[2]);FILE *triout=fopen(trianglepath,"wb");if(!triout)return fail("triangles");\n for(unsigned at=0;at<count;at++){')
s=s.replace('unsigned char used[32]={0};','for(unsigned t=0;t<patch.header.triangles;t++){float row[7];row[0]=ids[index];for(unsigned k=0;k<3;k++){unsigned v=patch.indices[3*t+k];row[1+2*k]=patch.vertices[v].x;row[2+2*k]=patch.vertices[v].y;}if(fwrite(row,sizeof row,1,triout)!=1)return fail("trianglewrite");}\n  unsigned char used[32]={0};')
s=s.replace('if(ayatsuri_model_instance_dispose','fclose(triout);\n if(ayatsuri_model_instance_dispose');(D/'capture.c').write_text(s)
main=O/'product/main';binary=D/'capture';subprocess.run(['cc','-std=c11','-O2','-ffp-contract=off','-fexcess-precision=standard','-I',str(main),'-I',str(O/'physical'),str(D/'capture.c'),str(O/'physical/fox_disk_lighting.c'),*[str(main/p) for p in ['ayatsuri/ayatsuri_model.c','ayatsuri/ayatsuri_visibility.c','ayatsuri/compact_opaque.c','ui/kasane/ksn_mesh_depth.c','ui/kasane/ksn_procedural.c']],'-lm','-o',str(binary)],check=True)
subprocess.run(['cc','-std=c11','-O2','-shared','-fPIC','-ffp-contract=off','-fexcess-precision=standard',str(D/'coverage.c'),'-lm','-o',str(D/'coverage.so')],check=True)
lib=ctypes.CDLL(str(D/'coverage.so'));lib.coverage.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_double,ctypes.c_void_p]
def sample(t,g=1,r=0):
 t=np.asarray(t,np.float32,order='C');out=np.zeros((135,240),np.uint16);assert lib.coverage(t.ctypes.data,len(t),g,r,out.ctypes.data)==1;return out
# Synthetic square [10,12)x[10,12), shared diagonal, no gaps/double counts.
a=np.array([[1,10,10,12,10,12,12],[1,10,10,12,12,10,12]],np.float32);expected=np.zeros((135,240),np.uint16);expected[10:12,10:12]=1
assert np.array_equal(sample(a),expected)
assert np.array_equal(sample(a,25,0),expected*625)
for bad in [np.array([[1,0,0,1,1,2,2]],np.float32),np.array([[1,0,0,1,0,0,np.nan]],np.float32),a[:,[0,1,2,5,6,3,4]].copy(),np.array([[1,0,0,1,0,0,np.finfo(np.float32).max]],np.float32)]:
 out=np.zeros((135,240),np.uint16);assert lib.coverage(bad.ctypes.data,len(bad),1,0,out.ctypes.data)==0
out=np.zeros((135,240),np.uint16);assert lib.coverage(a.ctypes.data,len(a),1,1e300,out.ctypes.data)==0
b=a.copy();b[:,[1,3,5]]+=3;assert np.array_equal(sample(b),np.roll(expected,3,axis=1))
(D/'synthetic.json').write_text(json.dumps({'tests':8,'pass':True}))
cfg=json.loads((S/'inputs/candidate-config.json').read_text());checks={};start=time.monotonic();records=[]
for case in ['baseline','direction']:
 scenario=next(s for s in cfg['scenarios'] if s['name']==case);env={**os.environ,'HONE_LINEAR_LIGHT':'1','HONE_DISK_FILE':str(S/('physical-'+case+'.txt'))}
 for cam in cfg['cameras']:
  stem=f"native-{cam['name']}-{case}";args=[str(binary),str(S/('model-'+case)/'model.aynm'),str(D/stem),'0',*map(str,cam['nativeCamera']),*map(str,scenario['nativeDirection']+scenario['intensity'])]
  with (D/(stem+'.json')).open('w') as f:subprocess.run(args,env=env,stdout=f,check=True)
  checks[stem]={x:(D/(stem+x)).read_bytes()==(O/(stem+x)).read_bytes() for x in ['.u16le','.f32le','.observer.f32','.vertices.f64','.sides.u8','.map.u8']}
assert all(all(v.values()) for v in checks.values())
for view in ['front','oblique']:
 p=D/f'native-{view}-baseline.triangles.f32';assert p.read_bytes()==(D/f'native-{view}-direction.triangles.f32').read_bytes();t=np.fromfile(p,np.float32).reshape(-1,7)
 center=sample(t);old=np.isfinite(np.fromfile(O/f'native-{view}-baseline.f32le',np.float32).reshape(135,240));assert np.array_equal(center>0,old),'center coverage mismatch'
 t0=time.monotonic();count=sample(t,25,1.5);np.savez_compressed(D/f'{view}-coverage.npz',counts=count,center=center);records.append({'view':view,'submittedTriangles':len(t),'seconds':time.monotonic()-t0,'centerPixels':int(center.sum())})
(D/'run-report.json').write_text(json.dumps({'controls':checks,'records':records,'wallSeconds':time.monotonic()-start,'peakRSSKiB':resource.getrusage(resource.RUSAGE_SELF).ru_maxrss},indent=2));print(records)
