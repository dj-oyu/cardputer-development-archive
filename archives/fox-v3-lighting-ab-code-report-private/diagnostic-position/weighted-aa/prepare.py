from pathlib import Path
import subprocess,json,os,hashlib
D=Path(__file__).resolve().parent;R=D.parent;O=R/'observer';S=R.parent/'fox-v3-lighting-ab/four-both-002'
s=(O/'native_render.c').read_text().replace('for(unsigned at=0;at<count;at++){','char trianglepath[4096];snprintf(trianglepath,sizeof trianglepath,"%s.triangles.f32",argv[2]);FILE *triout=fopen(trianglepath,"wb");if(!triout)return fail("triangles");\n for(unsigned at=0;at<count;at++){')
s=s.replace('unsigned char used[32]={0};','for(unsigned t=0;t<patch.header.triangles;t++){float row[15];row[0]=ids[index];row[1]=t;row[2]=(bits[t/8]>>(t%8))&1;for(unsigned k=0;k<3;k++){unsigned v=patch.indices[3*t+k];row[3+k]=v;row[6+3*k]=patch.vertices[v].x;row[7+3*k]=patch.vertices[v].y;row[8+3*k]=depth[v];}if(fwrite(row,sizeof row,1,triout)!=1)return fail("trianglewrite");}\n  unsigned char used[32]={0};')
s=s.replace('if(ayatsuri_model_instance_dispose','fclose(triout);\n if(ayatsuri_model_instance_dispose');(D/'capture.c').write_text(s)
main=O/'product/main';subprocess.run(['cc','-std=c11','-O2','-ffp-contract=off','-fexcess-precision=standard','-I',str(main),'-I',str(O/'physical'),str(D/'capture.c'),str(O/'physical/fox_disk_lighting.c'),*[str(main/p) for p in ['ayatsuri/ayatsuri_model.c','ayatsuri/ayatsuri_visibility.c','ayatsuri/compact_opaque.c','ui/kasane/ksn_mesh_depth.c','ui/kasane/ksn_procedural.c']],'-lm','-o',str(D/'capture')],check=True)
s=(R/'visibility/shader_visibility.c').read_text()+'''\nint encode_raw(const double *raw,unsigned short *out){unsigned q[3];for(unsigned k=0;k<3;k++){if(!isfinite(raw[k])||raw[k]<0)return 0;float value=ayatsuri_srgb_encode((float)fmin(1.0,raw[k]));q[k]=(unsigned)lroundf(value*(k==1?63:31));}*out=(q[0]<<11)|(q[1]<<5)|q[2];return 1;}\n''';(D/'shader.c').write_text(s)
for name,extra in [('raster',[]),('shader',['-I',str(main),'-I',str(O/'physical')])]:subprocess.run(['cc','-std=c11','-O2','-shared','-fPIC','-ffp-contract=off','-fexcess-precision=standard',*extra,str(D/(name+'.c')),'-lm','-o',str(D/(name+'.so'))],check=True)
cfg=json.loads((S/'inputs/candidate-config.json').read_text());checks={}
for case in ['baseline','direction']:
 scenario=next(s for s in cfg['scenarios'] if s['name']==case);env={**os.environ,'HONE_LINEAR_LIGHT':'1','HONE_DISK_FILE':str(S/('physical-'+case+'.txt'))}
 for cam in cfg['cameras']:
  stem=f"native-{cam['name']}-{case}";args=[str(D/'capture'),str(S/('model-'+case)/'model.aynm'),str(D/stem),'0',*map(str,cam['nativeCamera']),*map(str,scenario['nativeDirection']+scenario['intensity'])]
  with (D/(stem+'.json')).open('w') as f:subprocess.run(args,env=env,stdout=f,check=True)
  checks[stem]={x:(D/(stem+x)).read_bytes()==(O/(stem+x)).read_bytes() for x in ['.u16le','.f32le','.observer.f32','.vertices.f64','.sides.u8','.map.u8']}
assert all(all(v.values()) for v in checks.values());(D/'capture-controls.json').write_text(json.dumps(checks,indent=2))
