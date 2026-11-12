from pathlib import Path
import hashlib,json,subprocess,os,sys,shutil
R=Path(__file__).resolve().parent;W=R.parent;SOURCE=W/'fox-v3-eye-evaluation/actual-eyeB';sys.path.insert(0,str(SOURCE/'code'));from geometry_certificate import verify,sha
PIN='a8b9778f4915b6bab4a9c2312397f361280c4ef787353a466082fe87e803b116';cert=verify(SOURCE,PIN);H=R/'private-harness';H.mkdir(exist_ok=False)
for name in ['code','product','inputs','physical','visibility','transport','compiled']:shutil.copytree(SOURCE/name,H/name,ignore=shutil.ignore_patterns('__pycache__'))
for p in SOURCE.glob('physical-*.txt'):shutil.copy2(p,H/p.name)
p=H/'code/native_render.c';s=p.read_text();needle=' char path[4096];snprintf';branch=''' const char *private_dump=getenv("HONE_PRIVATE_SNAPSHOT_DUMP");
 if(private_dump&&!strcmp(private_dump,"1")){
  if(!pixel||!visibility||!transportmode)return fail("dump-dependency");
  size_t total=416+s->packets.size;char dump_path[4096];snprintf(dump_path,sizeof dump_path,"%s.snapshot",argv[2]);FILE *df=fopen(dump_path,"wb");if(!df)return fail("dump-output");if(fwrite(px.storage,1,total,df)!=total||fclose(df))return fail("dump-write");
  printf("{\\"privateSnapshotDump\\":true,\\"renderExecuted\\":false,\\"snapshotBytes\\":%zu,\\"records\\":%u,\\"work\\":%u,\\"snapshotFingerprint\\":\\"%016llx\\",\\"disposedBeforeDump\\":true,\\"reverse\\":%s}\\n",total,s->packets.packets,s->work,(unsigned long long)binding.snapshot_hash,reverse?"true":"false");
  bounce_binding_clear(&tx.binding);fox_pixel_unbind(&binding);return 0;
 }
''';assert needle in s;s=s.replace(needle,branch+needle);p.write_text(s);(R/'diagnostic-branch.c.txt').write_text(branch)
parity={str(p.relative_to(SOURCE)):sha(p)==sha(H/p.relative_to(SOURCE)) for name in ['product','physical','visibility','transport','compiled'] for p in (SOURCE/name).rglob('*') if p.is_file() and '__pycache__' not in p.parts};assert all(parity.values());(R/'core-parity.json').write_text(json.dumps(parity,indent=2))
flags=json.loads((SOURCE/'candidate-manifest.json').read_text())['build']['flags'];main=H/'product/main';native=H/'native-dump';cmd=['cc',*flags,'-I',str(main),'-I',str(H/'physical'),'-I',str(H/'visibility'),'-I',str(H/'transport'),str(H/'code/native_render.c'),str(H/'transport/bounce.c'),str(H/'transport/pixel_transport.c'),str(H/'visibility/visibility.c'),str(H/'visibility/pixel_binding.c'),str(H/'physical/fox_disk_lighting.c'),*[str(main/p) for p in ['ayatsuri/ayatsuri_model.c','ayatsuri/ayatsuri_visibility.c','ayatsuri/compact_opaque.c','ui/kasane/ksn_mesh_depth.c','ui/kasane/ksn_procedural.c']],'-lm','-o',str(native)]
with (R/'build.log').open('w') as f:subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,check=True)
D=R/'private-snapshots';D.mkdir(exist_ok=False);cfg=json.loads((H/'inputs/candidate-config.json').read_text());rows=[]
for case in cfg['scenarios']:
 for camera in cfg['cameras']:
  for rev in [0,1]:
   name='native-'+camera['name']+'-'+case['name']+('-reverse' if rev else '');prefix=D/name;args=[str(native),str(H/('compiled/model-'+case['name']+'/model.aynm')),str(prefix),str(rev),*map(str,camera['nativeCamera']),*map(str,case['nativeDirection']+case['intensity'])];env=dict(os.environ,HONE_LINEAR_LIGHT='1',HONE_PIXEL_LIGHT='1',HONE_PIXEL_VISIBILITY='1',HONE_TRANSPORT_MODE='2',HONE_OUTER_SAMPLES='16',HONE_GROUND_MODE='2',HONE_GROUND_FILE=str(H/case['ground']['inputFile']),HONE_DISK_FILE=str(H/('physical-'+case['name']+'.txt')),HONE_PRIVATE_SNAPSHOT_DUMP='1');q=subprocess.run(args,env=env,capture_output=True,text=True);(D/(name+'.stderr')).write_text(q.stderr);assert q.returncode==0,q.stderr;m=json.loads(q.stdout);old=json.loads((SOURCE/(name+'.json')).read_text());assert m['snapshotBytes']==old['snapshotBytes']==65216;assert m['records']==old['records']==51 and m['work']==old['work'];assert m['snapshotFingerprint']==old['visibilitySnapshotFingerprint'];assert m['renderExecuted'] is False and m['disposedBeforeDump'] is True
   raw=Path(str(prefix)+'.snapshot').read_bytes();v=14695981039346656037
   for byte in raw:v=((v^byte)*1099511628211)&0xffffffffffffffff
   assert format(v,'016x')==m['snapshotFingerprint'];row={'view':camera['name'],'case':case['name'],'reverse':bool(rev),'file':str(Path(str(prefix)+'.snapshot').relative_to(R)),'sha256':sha(Path(str(prefix)+'.snapshot')),**m};rows.append(row)
verify(SOURCE,PIN);result={'status':'PRIVATE_ACTUAL_APPEND_DUMPS_COMPLETE','rows':rows,'sourceCertificateSHA256':PIN,'nativeSHA256':sha(native),'flags':flags,'coreFilesAllByteExact':True,'all20FingerprintMatchFrozenActual':True,'noRenderExecuted':True};(R/'dump-summary.json').write_text(json.dumps(result,indent=2));print(json.dumps({'snapshots':len(rows),'all20FingerprintMatchFrozenActual':True,'snapshotBytesEach':65216}))
