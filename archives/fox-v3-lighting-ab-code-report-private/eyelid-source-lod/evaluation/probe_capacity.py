from pathlib import Path
import json,shutil,subprocess,os,sys
R=Path(__file__).resolve().parent;W=R.parent;S=W/'fox-v3-normal-pair-evaluation/actual-on'
sys.path.insert(0,str(W/'fox-v3-normal-pair-evaluation/code'))
from geometry_certificate import sha,derived
from codec_audit import decode_snapshot,sha_bytes,fnv
pins={8:'833ac7683872375f9e63f819618e0e25ed40e0ac761a35f7604cd45501207a8e',9:'5e7ab10cf89a5cc79274e50cb83472f6086cd075de2743c81629a95fd051c5d8'}
for stage,pin in pins.items():
 H=R/f'probe-lid{stage}';H.mkdir(exist_ok=False)
 for name in ['code','product','inputs','physical','visibility','transport','scoring']:shutil.copytree(S/name,H/name,ignore=shutil.ignore_patterns('__pycache__'))
 for p in S.glob('physical-*.txt'):shutil.copy2(p,H/p.name)
 glb=W/f'fox-v3-lid-source-lod/lid-{stage}.glb';assert sha(glb)==pin;shutil.copy2(glb,H/'inputs/geometry-source-sided.glb');(H/'compiled').mkdir()
 cfg=json.loads((H/'inputs/candidate-config.json').read_text());counts=None
 for case in cfg['scenarios']:
  p=H/'compiled'/('scenario-'+case['name']+'.json');p.write_text(json.dumps(case));d=H/'compiled'/('model-'+case['name'])
  subprocess.run(['node',str(H/'code/compile.cjs'),str(glb),str(p),str(d)],check=True,stdout=subprocess.DEVNULL)
  n=derived(json.loads((d/'compile.json').read_text()));assert counts is None or n==counts;counts=n
 (H/'code/expected_counts.h').write_text(f"#define FOX_EXPECTED_VERTICES {counts['vertices']}u\n#define FOX_EXPECTED_TRIANGLES {counts['triangles']}u\n")
 p=H/'code/native_render.c';s=p.read_text();needle=' char path[4096];snprintf';branch=''' printf("{\\"renderExecuted\\":false,\\"snapshotBytes\\":%zu,\\"canonicalBytes\\":%zu,\\"mode4\\":%u,\\"mode5\\":%u,\\"records\\":%u,\\"work\\":%u,\\"coldBytes\\":%ld,\\"arenaBytes\\":%zu,\\"visibilitySceneBytes\\":%zu,\\"transportSceneBytes\\":%zu}\\n",416+s->packets.size,canonical_snapshot_bytes,codec_mode4,codec_mode5,s->packets.packets,s->work,bytes,ab,scene_bytes,transport_bytes);return 0;\n''';assert needle in s;p.write_text(s.replace(needle,branch+needle))
 flags=json.loads((S/'candidate-manifest.json').read_text())['build']['flags'];main=H/'product/main';native=H/'native-probe';cmd=['cc',*flags,'-I',str(main),'-I',str(H/'physical'),'-I',str(H/'visibility'),'-I',str(H/'transport'),str(p),str(H/'transport/bounce.c'),str(H/'transport/pixel_transport.c'),str(H/'visibility/visibility.c'),str(H/'visibility/pixel_binding.c'),str(H/'physical/fox_disk_lighting.c'),*[str(main/x) for x in ['ayatsuri/ayatsuri_model.c','ayatsuri/ayatsuri_visibility.c','ayatsuri/compact_opaque.c','ui/kasane/ksn_mesh_depth.c','ui/kasane/ksn_procedural.c']],'-lm','-o',str(native)]
 subprocess.run(cmd,check=True);D=H/'private-snapshots';D.mkdir();rows=[]
 for case in cfg['scenarios']:
  for camera in cfg['cameras']:
   for rev in [0,1]:
    key=camera['name']+'-'+case['name']+('-reverse' if rev else '');prefix=D/key
    args=[str(native),str(H/('compiled/model-'+case['name']+'/model.aynm')),str(prefix),str(rev),*map(str,camera['nativeCamera']),*map(str,case['nativeDirection']+case['intensity'])]
    env=dict(os.environ,HONE_NORMAL_PAIR_CODEC='1',HONE_LINEAR_LIGHT='1',HONE_PIXEL_LIGHT='1',HONE_PIXEL_VISIBILITY='1',HONE_TRANSPORT_MODE='2',HONE_OUTER_SAMPLES='16',HONE_GROUND_MODE='2',HONE_GROUND_FILE=str(H/case['ground']['inputFile']),HONE_DISK_FILE=str(H/('physical-'+case['name']+'.txt')))
    q=subprocess.run(args,env=env,capture_output=True,text=True);row={'key':key,'returncode':q.returncode,'stderr':q.stderr}
    if q.returncode==0:
     m=json.loads(q.stdout);raw=Path(str(prefix)+'.snapshot').read_bytes();old,modes,nv,nt=decode_snapshot(raw);assert nv==counts['vertices'] and nt==counts['triangles'] and len(old)==counts['snapshotBytes']==m['canonicalBytes'];assert len(raw)==m['snapshotBytes']<=65536;row.update(m);row.update(sha256=sha_bytes(old),fnv=fnv(old),wireSHA256=sha_bytes(raw))
    assert not Path(str(prefix)+'.u16le').exists();rows.append(row)
 result={'stage':stage,'glbSHA256':pin,'counts':counts,'rows':rows,'all20AppendPass':all(x['returncode']==0 for x in rows),'renderExecuted':False,'nativeSHA256':sha(native)};(R/f'capacity-lid{stage}.json').write_text(json.dumps(result,indent=2));print(json.dumps({'stage':stage,'counts':counts,'all20AppendPass':result['all20AppendPass'],'first':rows[0]}),flush=True)
