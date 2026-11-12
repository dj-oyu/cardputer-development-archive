#!/usr/bin/env python3
"""Three separately invoked reviewed stages; no retry, no core mutation."""
from pathlib import Path
import json,hashlib,sys,os,subprocess,time
from compare_canary import compare,RAW,REPORTS
assert not sys.flags.optimize
R=Path('/workspace/scratch/6d8dcdbcdc54');D=Path(__file__).resolve().parent;P=D.parent/'preflight';G=D/'generated-v2';B=D/'build-canary';O=D/'canary-output';OLD=R/'fox-v3-indexed-bvh-bounds/actual-on-001/native-front-baseline';KINDS=['baseline','q16','q20']
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,j):
 with p.open('x') as f:json.dump(j,f,indent=2);f.write('\n')
def pinset():
 paths=[D/'run_canary.py',D/'compare_canary.py',D/'classify_pixels.py',D/'make_contact_sheet.py',D/'CANARY_PLAN.md',D/'HEADER_ADMISSION_DESIGN.md',D/'METADATA_INPUT_FREEZE.json',D/'METADATA_RESULT.json',D/'MEMORY_STACK_CONTRACT.json',B/'BUILD.json',B/'STACK_DELTA.json',B/'native-render',P/'RESULT.json',P/'identity.bin']
 build=json.loads((B/'BUILD.json').read_text());paths += [R/p for p in build['files']];paths += [B/p for p in build['stackFiles']];paths += list(G.glob('*'));paths += [R/p for p in json.loads((D/'METADATA_INPUT_FREEZE.json').read_text())['files']];paths += [R/'fox-v3-indexed-bvh-bounds/MEMORY_LEDGER.json',R/'fox-v3-indexed-bvh-bounds/CONSTRUCTION_NAMED_STACK.json',D/'build_canary.py',D/'generate_headers_v2.py',D/'comparator-selftest.json',D/'RUNNER_REPORT_CONTRACT.md'];paths += list((R/'ayatsuri-fixed-pipeline-20261105/bridge').glob('*.py'));paths += list((R/'ayatsuri-fixed-pipeline-20261105/bridge/private').glob('*.json'));paths += [R/'ayatsuri-fixed-pipeline-20261105/source-adapter/private-fixed-source.json',R/'ayatsuri-fixed-pipeline-20261105/converter/results/private/from-glb-q16.ayfq',R/'ayatsuri-fixed-pipeline-20261105/converter/results/private/from-glb-q20.ayfq'];paths += [Path(str(OLD)+e) for e in RAW+REPORTS+['.command.json']]
 for k in KINDS:
  c=json.loads((P/(k+'-front.command.json')).read_text());paths += [Path(c['command'][1]),P/(k+'-front.command.json'),D/(k+'-front.metadata.json'),P/(k+'-front.aa-ledger.json')];paths += [P/(k+'-front'+e) for e in ['.snapshot','.targets.u8','.center-depth.f32le']]
 base=json.loads(Path(str(OLD)+'.command.json').read_text());paths += [Path(base['environment'][k]) for k in ['HONE_DISK_FILE','HONE_GROUND_FILE']]
 missing=[str(p) for p in paths if not p.is_file()];assert not missing,('Missing or nonfile frozen dependency',missing)
 return {str(p.relative_to(R)):sha(p) for p in paths}
def commands():
 base=json.loads(Path(str(OLD)+'.command.json').read_text());rows=[]
 for k in KINDS:
  c=json.loads((P/(k+'-front.command.json')).read_text());env=base['environment'].copy();env['HONE_AA_LEDGER']=str(G/(k+'-front.ledger.txt'));args=[str(B/'native-render'),c['command'][1],str(O/(k+'-front')),*base['command'][3:]];assert args[3]=='0' and env['HONE_FLOOR_WORLD']=='on' and env['HONE_FLOOR_CASE']=='0';rows.append({'kind':k,'command':args,'environment':env,'modelSHA256':sha(args[1]),'metadata':str(D/(k+'-front.metadata.json'))})
 return rows
if sys.argv[1:]==['--prepare']:
 assert not O.exists();write(D/'CANARY_EXECUTION_FREEZE_V2.json',{'status':'FROZEN_PENDING_PARENT_REVIEW','frameLimit':3,'sequence':KINDS,'noRetries':True,'files':pinset(),'commands':commands(),'baselineExpectedRawExact':RAW,'baselineNonTimingOnlyDifference':'background.inputJSONSHA256 = generated-v2/CANDIDATE_INPUTS.json SHA256','candidatePolicy':'own metadata exact; numeric output changes measured, not hidden'});print(sha(D/'CANARY_EXECUTION_FREEZE_V2.json'));raise SystemExit
assert len(sys.argv)==4 and sys.argv[1]=='--run' and sys.argv[2] in KINDS
kind=sys.argv[2];freeze=D/'CANARY_EXECUTION_FREEZE_V2.json';assert sha(freeze)==sys.argv[3];f=json.loads(freeze.read_text());assert f['files']==pinset() and f['commands']==commands();O.mkdir(exist_ok=True)
for earlier in KINDS[:KINDS.index(kind)]:assert json.loads((O/(earlier+'-front.PASS.json')).read_text())['status']=='PASS'
prefix=O/(kind+'-front');assert not list(O.glob(kind+'-front.*')),'Existing attempt: do not retry or overwrite';entry=next(c for c in f['commands'] if c['kind']==kind);write(Path(str(prefix)+'.command.json'),{'status':'FROZEN_ONE_ATTEMPT','freezeSHA256':sha(freeze),**entry})
env={k:v for k,v in os.environ.items() if not k.startswith('HONE_')};env.update(entry['environment']);start=time.monotonic()
try:
 with Path(str(prefix)+'.stdout-pending').open('x') as out,Path(str(prefix)+'.stderr').open('x') as err:
  proc=subprocess.run(entry['command'],env=env,stdout=out,stderr=err,timeout=300)
 assert proc.returncode==0 and not Path(str(prefix)+'.stderr').read_text(),'Renderer failed or wrote stderr'
 Path(str(prefix)+'.stdout-pending').rename(Path(str(prefix)+'.json'));assert f['files']==pinset(),'Frozen input changed during execution'
 result=compare(prefix,OLD,kind,json.loads(Path(entry['metadata']).read_text()),P/(kind+'-front'),sha(G/'CANDIDATE_INPUTS.json'))
 write(Path(str(prefix)+'.PASS.json'),{'status':'PASS','elapsedSecondsDescriptiveOnly':time.monotonic()-start,'freezeSHA256':sha(freeze),'comparison':result,'files':{e:sha(str(prefix)+e) for e in RAW+REPORTS}});print(json.dumps(result,indent=2))
except Exception as e:
 write(Path(str(prefix)+'.FAILED.json'),{'status':'FAILED_NO_RETRY','error':repr(e),'elapsedSeconds':time.monotonic()-start,'successManifestPublished':False});raise
