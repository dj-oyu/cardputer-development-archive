import argparse,pathlib,shutil,json,subprocess,sys
from geometry_certificate import sha,derived,verify
R=pathlib.Path(__file__).resolve().parents[1]
a=argparse.ArgumentParser();a.add_argument('--glb',type=pathlib.Path,required=True);a.add_argument('--glb-sha256',required=True);a.add_argument('--codec-mode',type=int,choices=[0,1],required=True);a.add_argument('--output',type=pathlib.Path,required=True);a=a.parse_args()
for name,h in json.loads((R/'inputs/immutable-core-pins.json').read_text()).items():assert sha(R/name)==h,'immutable core drift: '+name
assert sha(a.glb)==a.glb_sha256,'source GLB pin mismatch';out=a.output.resolve();out.mkdir(exist_ok=False)
for name in ['code','product','inputs','physical','visibility','transport','scoring']:shutil.copytree(R/name,out/name,ignore=shutil.ignore_patterns('__pycache__','*.log'))
shutil.copy2(a.glb,out/'inputs/geometry-source-sided.glb');(out/'compiled').mkdir()
cfg=json.loads((out/'inputs/candidate-config.json').read_text());counts=None
for s in cfg['scenarios']:
 p=out/'compiled'/('scenario-'+s['name']+'.json');p.write_text(json.dumps(s));d=out/'compiled'/('model-'+s['name'])
 subprocess.run(['node',str(out/'code/compile.cjs'),str(out/'inputs/geometry-source-sided.glb'),str(p),str(d)],check=True)
 c=derived(json.loads((d/'compile.json').read_text()))
 if counts is None:counts=c
 else:assert c==counts
# Read compiled model through unchanged C model parser for independent arena/header evidence.
main=out/'product/main';helper=out/'compiled/header.c';helper.write_text('''#include <stdio.h>\n#include <stdlib.h>\n#include "ayatsuri/ayatsuri_model.h"\nint main(int argc,char **argv){if(argc!=2)return 2;FILE *f=fopen(argv[1],"rb");if(!f)return 2;fseek(f,0,SEEK_END);long n=ftell(f);rewind(f);void *d=malloc(n);if(fread(d,1,n,f)!=(size_t)n)return 2;ayatsuri_model m;if(ayatsuri_model_open(d,n,&m))return 2;printf("%zu\\n",ayatsuri_model_instance_bytes(&m));return 0;}\n''')
sources=['ayatsuri/ayatsuri_model.c','ayatsuri/ayatsuri_visibility.c','ayatsuri/compact_opaque.c','ui/kasane/ksn_mesh_depth.c','ui/kasane/ksn_procedural.c']
subprocess.run(['cc','-std=c11','-O2','-I',str(main),'-I',str(out/'physical'),str(helper),str(out/'physical/fox_disk_lighting.c'),*[str(main/p) for p in sources],'-lm','-o',str(out/'compiled/header')],check=True)
arena=int(subprocess.check_output([str(out/'compiled/header'),str(out/'compiled/model-baseline/model.aynm')]))
(out/'code/expected_counts.h').write_text(f"/* Generated from pinned actual compile output, not a relaxed limit. */\n#define FOX_EXPECTED_VERTICES {counts['vertices']}u\n#define FOX_EXPECTED_TRIANGLES {counts['triangles']}u\n")
files={str(p.relative_to(out)):sha(p) for name in ['code','product','physical','visibility','transport','compiled','scoring'] for p in (out/name).rglob('*') if p.is_file() and '__pycache__' not in p.parts}
files['inputs/geometry-source-sided.glb']=sha(out/'inputs/geometry-source-sided.glb')
contract=json.loads((out/'inputs/codec-contract.json').read_text());assert contract['glbSHA256']==a.glb_sha256;files['inputs/codec-contract.json']=sha(out/'inputs/codec-contract.json')
cert={'codecMode':a.codec_mode,'codecContractSHA256':sha(out/'inputs/codec-contract.json'),'codecSnapshotBytes':contract['modes'][str(a.codec_mode)]['snapshotBytes'],'version':'geometry-compile-pin-v1','glbSHA256':a.glb_sha256,'counts':counts,'arenaBytes64bit':arena,'files':files};p=out/'inputs/geometry-certificate.json';p.write_text(json.dumps(cert,indent=2));verify(out,sha(p));print(json.dumps({'prepared':str(out),'certificateSHA256':sha(p),'counts':counts,'arenaBytes64bit':arena}))
