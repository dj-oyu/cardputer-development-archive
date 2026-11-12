"""Copy only the four standalone arithmetic TUs and their quoted includes."""
import pathlib,re,hashlib,json,os,shutil
P=pathlib.Path(__file__).resolve().parent;R=P.parent.parent;D=P/'capsule';D.mkdir(exist_ok=True)
units=['ayatsuri-latest-fixed-source-20261105/kernel-chain-compact/compact.c','ayatsuri-latest-fixed-source-20261105/material-c-compact/material.c','ayatsuri-latest-fixed-source-20261105/control-prototype/control.c','ayatsuri-latest-fixed-source-20261105/transparency-chain-prototype/conditional.c']
# Explicit whitelist confines quoted include resolution; there is no profile data.
allowed=set(units)|set('ayatsuri-latest-fixed-source-20261105/'+p for p in ['kernel-chain-compact/compact.h','kernel-chain-prototype/chain.h','material-c-compact/material.h','material-c-compact/generated-q16.inc','material-c-compact/generated-q20.inc','material-c-compact/generated-q24.inc','control-prototype/control.h','transparency-chain-prototype/conditional.h'])|set('ayatsuri-fixed-integer-light-20261105/'+p for p in ['integer_light.h','normal_bridge.h'])|set('ayatsuri-fixed-frame-stage1-20261105/aa/code/'+p for p in ['integer_aa.h','profile_adapter.h'])|set('ayatsuri-fixed-integer-output-20261105/code/'+p for p in ['private_adapter_api.h','integer_output.h','block_cache.h'])
queue=list(units);copied={}
while queue:
 name=queue.pop()
 if name in copied:continue
 assert name in allowed,name
 src=R/name;content=src.read_bytes();dest=D/name;dest.parent.mkdir(parents=True,exist_ok=True)
 if dest.exists():assert dest.read_bytes()==content
 else:dest.write_bytes(content)
 copied[name]=hashlib.sha256(content).hexdigest()
 for inc in re.findall(r'^\s*#\s*include\s*"([^"]+)"',content.decode(),re.M):
  path=(src.parent/inc).resolve().relative_to(R.resolve()).as_posix();assert path in allowed,path;queue.append(path)
manifest=dict(units=units,copied_sha256=copied,private_profile_content_included=False,geometry_fixtures_included=False,note='Material generated LUTs are source-derived private numeric data; capsule stays private. Profile API headers only, no profile definition or fabricated replacement. Objects intentionally remain unlinked.')
(P/'capsule-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
# Bounded discoverability, not a filesystem-wide absence claim.
names=['xtensa-esp32s3-elf-gcc','xtensa-esp-elf-gcc','xtensa-esp32-elf-gcc','xtensa-esp32s3-elf-objdump','xtensa-esp-elf-objdump','xtensa-esp32s3-elf-readelf']
paths={n:shutil.which(n) for n in names};roots=['/home/agent/.espressif/tools','/opt/esp','/opt/xtensa','/usr/local/xtensa']
status=dict(status='BLOCKED_MISSING_DISCOVERABLE_TARGET_TOOLCHAIN',path_tools=paths,known_roots={p:pathlib.Path(p).exists() for p in roots},idf_path=os.environ.get('IDF_PATH',''),target_objects_created=0,target_programs_executed=0,toolchains_installed=0,reason='No already installed Xtensa compiler/binutils discovered on PATH or checked standard roots. Not a filesystem-wide absence proof.',required='An existing ESP32-S3-configured Xtensa GCC plus matching objdump/readelf, C headers and a confirmed ABI/configuration; no installation is attempted.')
(P/'availability.json').write_text(json.dumps(status,indent=2)+'\n');print(json.dumps(status,indent=2));print('Copied',len(copied),'files')
