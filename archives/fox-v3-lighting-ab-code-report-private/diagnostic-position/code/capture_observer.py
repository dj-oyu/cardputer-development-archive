from pathlib import Path
import shutil,subprocess,json,os,hashlib
R=Path(__file__).resolve().parents[1];S=R.parent/'fox-v3-lighting-ab/four-both-002';O=R/'observer';O.mkdir(exist_ok=True)
for d in ['product','physical']:shutil.copytree(S/d,O/d,dirs_exist_ok=True)
s=(S/'code/native_render.c').read_text().replace('int main(int argc,char **argv){','extern float diagnostic[240*135][16];\nextern double diagnostic_vertices[3][256][32][3];\nunsigned char diagnostic_sides[256][64];\nunsigned char diagnostic_vertex_map[256][32];\nint main(int argc,char **argv){')
s=s.replace('printf("{\\"physicalDiskEnabled', 'snprintf(path,sizeof path,"%s.observer.f32",argv[2]);FILE *obs=fopen(path,"wb");if(!obs||fwrite(diagnostic,sizeof diagnostic,1,obs)!=1)return fail("observer");fclose(obs);\n printf("{\\"physicalDiskEnabled')
s=s.replace('if(reverse){uint8_t rb', 'for(unsigned t=0;t<patch.header.triangles;t++)diagnostic_sides[ids[index]][t]=(bits[t/8]>>(t%8))&1;\n  if(reverse){uint8_t rb')
s=s.replace('printf("{\\\"physicalDiskEnabled', 'snprintf(path,sizeof path,"%s.vertices.f64",argv[2]);obs=fopen(path,"wb");fwrite(diagnostic_vertices,sizeof diagnostic_vertices,1,obs);fclose(obs);snprintf(path,sizeof path,"%s.sides.u8",argv[2]);obs=fopen(path,"wb");fwrite(diagnostic_sides,sizeof diagnostic_sides,1,obs);fclose(obs);\n printf("{\\\"physicalDiskEnabled')
s=s.replace('bool ok=back?ksn_mesh_append_sided', 'unsigned char used[32]={0};for(unsigned t=0;t<3u*patch.header.triangles;t++)used[patch.indices[t]]=1;unsigned compact=0;for(unsigned v=0;v<patch.header.vertices;v++)if(used[v])diagnostic_vertex_map[ids[index]][compact++]=v;\n  bool ok=back?ksn_mesh_append_sided')
s=s.replace('fwrite(diagnostic_sides,sizeof diagnostic_sides,1,obs);fclose(obs);', 'fwrite(diagnostic_sides,sizeof diagnostic_sides,1,obs);fclose(obs);snprintf(path,sizeof path,"%s.map.u8",argv[2]);obs=fopen(path,"wb");fwrite(diagnostic_vertex_map,sizeof diagnostic_vertex_map,1,obs);fclose(obs);')
(O/'native_render.c').write_text(s)
p=O/'product/main/ayatsuri/ayatsuri_model.c';s=p.read_text();s='double diagnostic_vertices[3][256][32][3];\n'+s
s=s.replace('if(!experimental_mesh_color(i,snorm,m16(d+14),d[18],coeff,&shade,world,&out->color_a)', 'for(unsigned r=0;r<3;r++){diagnostic_vertices[0][id][v][r]=world[r];diagnostic_vertices[1][id][v][r]=snorm[r]/32767.0;}\n        if(!experimental_mesh_color(i,snorm,m16(d+14),d[18],coeff,&shade,world,&out->color_a)')
s=s.replace('uint16_t *back=mesh_back_colors(i,id,nv)+2*v;', 'for(unsigned r=0;r<3;r++)diagnostic_vertices[2][id][v][r]=snorm[r]/32767.0;\n            uint16_t *back=mesh_back_colors(i,id,nv)+2*v;');p.write_text(s)
p=O/'product/main/ui/kasane/ksn_mesh_depth.c';s=p.read_text();s='float diagnostic[240*135][16];\n'+s
s=s.replace('z[at]=depth;', '''z[at]=depth;
                float *diag=diagnostic[yy*240+x];diag[0]=view.node;diag[1]=face;diag[2]=back;
                for(unsigned k=0;k<3;k++){diag[3+k]=indices[k];diag[6+k]=(float)w[k];diag[9+k]=v[k].color_a;diag[12+k]=v[k].color_b;}diag[15]=1;''');p.write_text(s)
main=O/'product/main';binary=O/'native-render';subprocess.run(['cc','-std=c11','-O2','-ffp-contract=off','-fexcess-precision=standard','-I',str(main),'-I',str(O/'physical'),str(O/'native_render.c'),str(O/'physical/fox_disk_lighting.c'),*[str(main/p) for p in ['ayatsuri/ayatsuri_model.c','ayatsuri/ayatsuri_visibility.c','ayatsuri/compact_opaque.c','ui/kasane/ksn_mesh_depth.c','ui/kasane/ksn_procedural.c']],'-lm','-o',str(binary)],check=True)
cfg=json.loads((S/'inputs/candidate-config.json').read_text());checks={}
for case in ['baseline','direction']:
 scenario=next(s for s in cfg['scenarios'] if s['name']==case);env={**os.environ,'HONE_LINEAR_LIGHT':'1','HONE_DISK_FILE':str(S/('physical-'+case+'.txt'))}
 for cam in cfg['cameras']:
  stem=f"native-{cam['name']}-{case}";args=[str(binary),str(S/('model-'+case)/'model.aynm'),str(O/stem),'0',*map(str,cam['nativeCamera']),*map(str,scenario['nativeDirection']+scenario['intensity'])]
  with (O/(stem+'.json')).open('w') as f:subprocess.run(args,env=env,stdout=f,check=True)
  checks[stem]={x:(O/(stem+x)).read_bytes()==(S/(stem+x)).read_bytes() for x in ['.u16le','.f32le']}
assert all(all(c.values()) for c in checks.values());(R/'observer-parity.json').write_text(json.dumps(checks,indent=2));print(checks)
